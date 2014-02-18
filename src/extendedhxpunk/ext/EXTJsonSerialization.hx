package extendedhxpunk.ext;

import tjson.TJSON;

/**
 * Credit (branched from code at): http://stackoverflow.com/questions/11074340/can-you-deserialize-a-json-string-to-a-class-instance-with-haxe
 * (As of 2/8/2014, the following solution can be found as an updated answer there as well)
 */
class EXTJsonSerialization
{
	/**
	 * Json encode an object. 'fieldMap' may be used to limit the fields that get encoded
	 * for specific types. For instance, one might pass an object that looks like:
	 * 
	 * var fieldMap = 
	 * { 
	 *     "flash.geom.Point" : ["x", "y"]
	 * };
	 * 
	 * which would result in only the 'x' and 'y' fields of objects of type 'flash.geom.Point'
	 * getting encoded. Objects whose types are not specified in this mapping will have all of
	 * fields encoded (except Functions and Enums).
	 * 
	 * Note that this function properly adds an '_explicitType' field to all objects, so they
	 * may be correctly decoded by the decode() function.
	 * 
	 * @param	o			The object to encode
	 * @param	fieldMap	Specific fields to encode for specific object types
	 * @return				A json-encoded string of the object
	 */
	public static function encode(o:Dynamic, fieldMap:Dynamic = null):String
	{
		if (fieldMap == null)
			fieldMap = { };
		var encodable = createEncodable(o, fieldMap);
		return TJSON.encode(encodable, "fancy");
	}
	
	/**
	 * Json decode an object.
	 * 
	 * Note that this function requires the '_explicitType' property to be set (in json) on
	 * objects that need to be decoded into haxe objects of specific types. Otherwise they
	 * will be decoded into anonymous objects.
	 * 
	 * @param	s			String of json to decode
	 * @param	typeClass	The class type to decode into
	 * @return				The created and decoded object
	 */
	public static function decode<T>(s:String, typeClass:Class<Dynamic>) : T 
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
	
	private static function createEncodable(objectToEncode:Dynamic, fieldMap:Dynamic):Dynamic
	{
		var type = Type.getClass(objectToEncode);
		var typeName:String = null;
		if (type != null)
			typeName = Type.getClassName(type);
		
		if (typeName == "Array")
		{
			var encodableArray:Array<Dynamic> = new Array();
			var objectArray:Array<Dynamic> = cast objectToEncode;
			
			for (i in 0...objectArray.length)
			{
				var value = objectArray[i];
				
				if (isEncodable(value))
				{
					var valueTypeString:String = Type.getClassName(Type.getClass(value));
					var isValueObject:Bool = (Reflect.isObject(value) && valueTypeString != "String") || (valueTypeString == "Array");
					
					if (isValueObject)
					{
						var encodableValue = createEncodable(value, fieldMap);
						encodableArray.push(encodableValue);
					}
					else
					{
						encodableArray.push(value);
					}
				}
			}
			
			return encodableArray;
		}
		else
		{
			var encodable:Dynamic = { };
			if (typeName != null)
				Reflect.setField(encodable, "_explicitType", typeName);
			
			var fields:Array<String> = EXTJsonSerialization.getFields(objectToEncode, fieldMap);
			for (field in fields)
			{
				var value = Reflect.field(objectToEncode, field);
				
				if (isEncodable(value))
				{
					var valueTypeString:String = Type.getClassName(Type.getClass(value));
					var isValueObject:Bool = (Reflect.isObject(value) && valueTypeString != "String") || (valueTypeString == "Array");
					if (isValueObject)
					{
						var encodableValue = createEncodable(value, fieldMap);
						Reflect.setField(encodable, field, encodableValue);
					}
					else
					{
						Reflect.setField(encodable, field, value);
					}
				}
			}
			
			return encodable;
		}
	}

	private static function populate(inst:Dynamic, data:Dynamic):Void
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
	
	private static function isEncodable(obj:Dynamic):Bool
	{
		return !Reflect.isFunction(obj) && !Std.is(obj, Enum);
	}
	
	private static function getFields(obj:Dynamic, fieldMap:Dynamic):Array<String>
	{
		var type = Type.getClass(obj);
		var typeName:String = null;
		if (type != null)
			typeName = Type.getClassName(Type.getClass(obj));
		
		if (typeName != null && Reflect.hasField(fieldMap, typeName))
		{
			return Reflect.field(fieldMap, typeName);
		}
		else if (isAnonymous(obj))
		{
			return Reflect.fields(obj);
		}
		else if (type != null)
		{
			return Type.getInstanceFields(type);
		}
		else
		{
			throw "Could not get fields for object";
			return null;
		}
	}
	
	/**
	 * Credit: https://groups.google.com/forum/#!msg/haxelang/1ddZUb2XVoU/Y42QaiGPB3kJ
	 */
	private static function isAnonymous(obj:Dynamic):Bool
	{
		return Type.typeof(obj) == TObject && !Std.is(obj, Class) && !Std.is(obj, Enum);
	}
}
