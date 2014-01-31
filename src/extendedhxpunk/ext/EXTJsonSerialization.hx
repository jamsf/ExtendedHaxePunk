package extendedhxpunk.ext;

import tjson.TJSON;

/**
 * Credit: http://stackoverflow.com/questions/11074340/can-you-deserialize-a-json-string-to-a-class-instance-with-haxe
 *
 * This works only for basic class instances but you can extend it to work with 
 * any type.
 * It doesn't work with nested class instances; you can detect the required
 * types with macros (will fail for interfaces or extended classes) or keep
 * track of the types in the serialized object.
 * Also you will have problems with objects that have circular references.
 */
class EXTJsonSerialization
{
	// to solve some of the issues above you should iterate on all the fields,
	// check for a non-compatible Json type and build a structure like the
	// following before serializing
	public static function encode(o : Dynamic) 
	{
		return TJSON.encode(o);
	}

	public static function decode<T>(s : String, typeClass : Class<Dynamic>) : T 
	{
		var o = TJSON.parse(s);
		//var o = haxe.Json.parse(s),
		var inst = Type.createEmptyInstance(typeClass);
		EXTJsonSerialization.populate(inst, o.data);
		return inst;
	}

	private static function populate(inst, data) 
	{
		for (field in Reflect.fields(data)) 
		{
			Reflect.setField(inst, field, Reflect.field(data, field));
		}
	}
}
