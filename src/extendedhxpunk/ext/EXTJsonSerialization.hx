package extendedhxpunk.ext;

import tjson.TJSON;

/**
 * Credit (branched from code at): http://stackoverflow.com/questions/11074340/can-you-deserialize-a-json-string-to-a-class-instance-with-haxe
 * (As of 2/8/2014, the following solution can be found as an updated answer there as well)
 *
 * NOTE - the "_explicitType" property will need to be set in json for objects within objects that are being decoded.
 */
class EXTJsonSerialization
{
	public static function encode(o : Dynamic) : String
	{
		return TJSON.encode(o);
	}

	public static function decode<T>(s : String, typeClass : Class<Dynamic>) : T 
	{
		var o = TJSON.parse(s);
		var inst = Type.createEmptyInstance(typeClass);
		EXTJsonSerialization.populate(inst, o);
		return inst;
	}
	
	//public static function decodeIntoMap(s : String) : Map
	//{
		//var o = TJSON.parse(s);
		//var map = new Map();
		//
	//}

	public static function populate(inst, data):Void
	{
		for (field in Reflect.fields(data)) 
		{
			if (field == "_explicitType")
				continue;
			
			var value = Reflect.field(data, field);
			var valueTypeString:String = Type.getClassName(Type.getClass(value));
			var isValueObject:Bool = (Reflect.isObject(value) && valueTypeString != "String") || (valueTypeString == "Array");
			var valueExplicitType:String = null;
			
			//EXTConsole.debug("", "", [ "field = " + field + ", valueTypeString = " + valueTypeString ]);
			
			if (isValueObject)
			{
				valueExplicitType = Reflect.field(value, "_explicitType");
				//EXTConsole.debug("", "", ["valueExplicitType = " + valueExplicitType]);
				if (valueExplicitType == null && valueTypeString == "Array")
					valueExplicitType = "Array";
			}
			
			if (valueExplicitType != null)
			{
#if !flash
				if (valueTypeString == "Array")
				{
					var fieldArray:Array<Dynamic> = new Array();
					var valueArray:Array<Dynamic> = cast value;
					EXTConsole.debug("", "", [ "value array [1] = " + valueArray[1]]);
					
					for (i in 0...valueArray.length)
					{
						fieldArray.push(valueArray[i]);
						//EXTConsole.debug("", "", [ "field array [" + i + "] = " + fieldArray[i]]);
					}
					
					Reflect.setField(inst, field, fieldArray);
				}
				else
#end
				{
					var fieldInst = Type.createEmptyInstance(Type.resolveClass(valueExplicitType));
					populate(fieldInst, value);
					Reflect.setField(inst, field, fieldInst);
				}
			}
			else
			{
				Reflect.setField(inst, field, value);
			}
		}
	}
}
