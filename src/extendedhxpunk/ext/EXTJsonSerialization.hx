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
		return TJSON.encode(o, "fancy");
	}

	public static function decode<T>(s : String, typeClass : Class<Dynamic>) : T 
	{
		var o = TJSON.parse(s);
		var inst;
		
#if !flash
		if (Type.getClassName(typeClass) == "Array")
			inst = new Array<Dynamic>();
		else
#end
			inst = Type.createEmptyInstance(typeClass);
		EXTJsonSerialization.populate(inst, o);
		return cast inst;
	}
	
	//public static function decodeIntoMap(s : String) : Map
	//{
		//var o = TJSON.parse(s);
		//var map = new Map();
		//
	//}

	public static function populate(inst : Dynamic, data : Dynamic):Void
	{
#if !flash
		var dataTypeString:String = Type.getClassName(Type.getClass(data));
		
		if (dataTypeString == "Array")
		{
			var dataArray:Array<Dynamic> = cast data;
			var instArray:Array<Dynamic> = cast inst;
			
			for (i in 0...dataArray.length)
			{
				var value = dataArray[i];
				var valueTypeString:String = Type.getClassName(Type.getClass(value));
				var isValueObject:Bool = (Reflect.isObject(value) && valueTypeString != "String") || (valueTypeString == "Array");
				var valueExplicitType:String = null;
				
				if (isValueObject)
				{
					valueExplicitType = Reflect.field(value, "_explicitType");
					if (valueExplicitType == null && valueTypeString == "Array")
						valueExplicitType = "Array";
				}
				
				if (valueExplicitType != null)
				{
					if (valueTypeString == "Array")
					{
						var fieldInst = new Array<Dynamic>();
						populate(fieldInst, value);
						instArray.push(fieldInst);
					}
					else
					{
						var fieldInst = Type.createEmptyInstance(Type.resolveClass(valueExplicitType));
						populate(fieldInst, value);
						instArray.push(fieldInst);
					}
				}
				else
				{
					instArray.push(value);
				}
			}
		}
		else
#end
		{
			for (field in Reflect.fields(data)) 
			{
				if (field == "_explicitType")
					continue;
				
				var value = Reflect.field(data, field);
				var valueTypeString:String = Type.getClassName(Type.getClass(value));
				var isValueObject:Bool = (Reflect.isObject(value) && valueTypeString != "String") || (valueTypeString == "Array");
				var valueExplicitType:String = null;
				
				if (isValueObject)
				{
					valueExplicitType = Reflect.field(value, "_explicitType");
					if (valueExplicitType == null && valueTypeString == "Array")
						valueExplicitType = "Array";
				}
				
				if (valueExplicitType != null)
				{
#if !flash
					if (valueTypeString == "Array")
					{
						var fieldInst = new Array<Dynamic>();
						populate(fieldInst, value);
						Reflect.setField(inst, field, fieldInst);
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
}
