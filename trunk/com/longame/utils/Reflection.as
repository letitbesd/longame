/*******************************************************************************
 * PushButton Engine
 * Copyright (C) 2009 PushButton Labs, LLC
 * For more information see http://www.pushbuttonengine.com
 * 
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package  com.longame.utils
{
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import com.longame.managers.AssetsLibrary;
	import com.longame.resource.database.ItemSpec;
	import com.longame.utils.debug.Logger;
	
    /**
     * TypeUtility is a static class containing methods that aid in type
     * introspection and reflection.
     */
    public class Reflection
    {
        /**
         * Registers a function that will be called when the specified type needs to be
         * instantiated. The function should return an instance of the specified type.
         * 
         * @param typeName The name of the type the specified function should handle.
         * @param instantiator The function that instantiates the specified type.
         */
        public static function registerInstantiator(typeName:String, instantiator:Function):void
        {
            if (_instantiators[typeName])
                Logger.warn("TypeUtility", "RegisterInstantiator", "An instantiator for " + typeName + " has already been registered. It will be replaced.");
            
            _instantiators[typeName] = instantiator;
        }
        /**
         * Gets the type of a field as a string for a specific field on an object.
         * 
         * @param object The object on which the field exists.
         * @param field The name of the field whose type is being looked up.
         * 
         * @return The fully qualified name of the type of the specified field, or
         * null if the field wasn't found.
         */
        public static function getFieldType(object:*, field:String):String
        {
            var typeXML:XML = getTypeDescription(object);
            
            // Look for a matching accessor.
            for each(var property:XML in typeXML.child("accessor"))
            {
                if (property.attribute("name") == field)
                    return property.attribute("type");
            }
            
            // Look for a matching variable.
            for each(var variable:XML in typeXML.child("variable"))
            {
                if (variable.attribute("name") == field)
                    return variable.attribute("type");
            }
            
            return null;
        }
		/**
		 * 获取对象的静态变量名列表,返回格式[{name:"itemSpec",type:"com.longsir.model.ItemSpec"},...]
		 * @param object 对象
		 * @includeAccessor:是否包含get,set方法
		 * */
		public static function getStaticVariables (object:*,includeAccessor:Boolean=true) :Array
		{
			var variableList :Array = [];
			var xml :XML = getClassDescription(getClassName(object));
			//获取普通静态变量
			for each (var child :XML in xml.variable) {
				variableList.push({name:child.@name.toString(),type:child.@type.toString().replace("::",".")});
			}
			if(!includeAccessor) return variableList;
			//获取静态get方法
			for each (child in xml.accessor) {
				variableList.push({name:child.@name.toString(),type:child.@type.toString().replace("::",".")});
			}			
			return variableList;
		}
		/**
		 * 获取对象的变量名列表，不包括get方法,返回格式[{name:"itemSpec",type:"com.longsir.model.ItemSpec"},...]
		 * @param object 对象
		 * @includeAccessor:是否包含get,set方法
		 * */		
		public static function getVariables (object:*,includeAccessor:Boolean=true) :Array
		{
			var variableList :Array = [];
			var xml :XML = getClassDescription(getClassName(object));
			//获取普通变量
			for each (var child :XML in xml.factory.variable) {
				variableList.push({name:child.@name.toString(),type:child.@type.toString().replace("::",".")});
			}
			if(!includeAccessor) return variableList;
			//获取get属性
			for each (child in xml.factory.accessor) {
				variableList.push({name:child.@name.toString(),type:child.@type.toString().replace("::",".")});
			}
			return variableList;
		}
		/**
		 * 获取名为fieldName的所有静态属性和静态get方法的class类
		 * **/
		public static function getStaticVariableType (object :*, fieldName :String):Class
		{
			var xml :XML = getClassDescription(getClassName(object));
			for each (var varXml :XML in xml.variable) {
				if (varXml.@name.toString() == fieldName) {
					return getClassByName(varXml.@type.toString());
				}
			}
			for each (varXml in xml.accessor) {
				if (varXml.@name.toString() == fieldName) {
					return getClassByName(varXml.@type.toString());
				}
			}
			
			return null;
		} 		
		/**
		 * 获取object里meta名为metaName，并且有一个变量key,其值为value的变量名列表,包括get方法
		 * 如果key,value没有被指定，则返回全部标签名为metaName的变量名
		 * @param object: 对象
		 * @metaName:     metaData的标签名
		 * @key:          标签变量名，如果后面两个指定，则返回特定的
		 * @value:        变量名对应的值
		 * */
		public static function getVariableNamesWithMeta(object:*,metaName:String,key:String=null,value:*=null):Array
		{
			var description:XML = getTypeDescription(object);
			if (!description)
				return [];
			return _getVariableNamesWithMeta(description,metaName,key,value);
		}	
		private static function _getVariableNamesWithMeta(description:XML,metaName:String,key:String=null,value:*=null):Array
		{
			var vars:Array=[];
			for each (var variable:XML in description.*)
			{
				// Only check variables/accessors.
				if (variable.name() != "variable" && variable.name() != "accessor")
					continue;
				// Scan for  metadata with name metaName
				for each (var metadataXML:XML in variable.*)
				{
					if (metadataXML.@name == metaName)
					{
						var varName:String=variable.@name.toString();
						//如果key,vlaue都有，那么只返回key=value的那个
						if(key&&value) {
							//这种表达方式xml是否可以接受？todo
							if(metadataXML.arg.((@key==key)&&(@value==value)).length) vars.push(varName);
						}
						else vars.push(varName);
					}
				}
			}
			return vars;			
		}
		/**
		 * 获取对象object里具有metaName元标签的变量信息，格式：[{varName:变量名,varClass:变量的类名,metaKey:metaValue,...},...]
		 * @param object:     对象
		 * @param metaName    指定的元标签名
		 * */
		public static function getMetaInfos(object:*,metaName:String):Array
		{
			var description:XML = getTypeDescription(object);
			if (!description)
				return [];
			var metas:Array=[];
			for each (var variable:XML in description.*)
			{
				// Only check variables/accessors.
				if (variable.name() != "variable" && variable.name() != "accessor")
					continue;
				// Scan for  metadata with name metaName
				for each (var metadataXML:XML in variable.*)
				{
					if (metadataXML.@name != metaName) continue;
					var meta:Object=_getMeta(metadataXML,variable);
					if(meta) {
						metas.push(meta);
					}
				}
			}
			return metas;			
		}
		/**
		 * 获取object中字段为field的元标签信息
		 * @param object:要解析的class实例
		 * @param field: 实例的变量名
		 * Exmaple:
		 *    1. public class testClass1{
		 *         [MetaTest(type="special",sex="girl")]
		 *         public var testVar:SomeClass;	
		 *       }
		 *    用getMeta(testClass1Instance,"testVar")
		 *    返回 Object: {varName:"testVar",varClass:"SomeClass",type:"special",sex:"girl"}
		 *    注意：如果是个纯标签[MetaTest]，返回的是一个{cls:theClassName}
		 * */
        public static function getMeta(object:*,field:String):*
		{
			var description:XML = getTypeDescription(object);
			if (!description)
				return null;
			for each (var variable:XML in description.*)
			{
				// Skip if it's not the field we want.
				if (variable.@name != field)
					continue;
				
				// Only check variables/accessors.
				if (variable.name() != "variable" && variable.name() != "accessor")
					continue;
				// Scan for TypeHint metadata.
				for each (var metadataXML:XML in variable.*)
				{
					var meta:Object=_getMeta(metadataXML,variable);
					if(meta) return meta;
				}

			}
			return null;
		}
		private static function _getMeta(metadataXML:XML,variable:XML):*
		{
			//这个标签每个属性都有，系统的，滤掉
			if(metadataXML.@name=="__go_to_definition_help") return null;
			/**
			 * metadataXML.arg是一个XMLList
			 * metadataXML.arg=<arg key="type" value="special"/>
			 *                  <arg key="sex" value="girl"/>
			 * 对应[MetaTest(type="special",sex="girl")]
			 * */
			//"longame.components::AbstractComp"
			var className:String=variable.@type.toString();	
			className=className.replace("::",".");
			var meta:Object={varName:variable.@name.toString(),varClass:className};					
			for each(var arg:XML in metadataXML.arg){
				var key:String=arg.@key.toString();
				var value:String=arg.@value.toString();
				meta[key]=value;
			}
			return meta;
		}
		/**
		 * Determines if an object is an instance of a dynamic class.
		 * 
		 * @param object The object to check.
		 * 
		 * @return True if the object is dynamic, false otherwise.
		 */
		public static function isDynamic(object:*):Boolean
		{
			if (object is Class)
			{
				Logger.error(object, "isDynamic", "The object is a Class type, which is always dynamic");
				return true;
			}
			
			var typeXml:XML = getTypeDescription(object);
			return typeXml.@isDynamic == "true";
		}		
        /**
         * Gets the xml description of an object's type through a call to the
         * flash.utils.describeType method. Results are cached, so only the first
         * call will impact performance.
         * 
         * @param object The object to describe.
         * 
         * @return The xml description of the object.
         */
        public static function getTypeDescription(object:*):XML
        {
            var className:String = getClassName(object);
            if (!_typeDescriptions[className])
                _typeDescriptions[className] = describeType(object);
            
            return _typeDescriptions[className];
        }
        
        /**
         * Gets the xml description of a class through a call to the
         * flash.utils.describeType method. Results are cached, so only the first
         * call will impact performance.
         * 
         * @param className The name of the class to describe.
         * 
         * @return The xml description of the class.
         */
        public static function getClassDescription(className:String):XML
        {
            if (!_typeDescriptions[className])
            {
                try
                {
                    _typeDescriptions[className] = describeType(getDefinitionByName(className));
                }
                catch (error:Error)
                {
                    return null;
                }
            }
            
            return _typeDescriptions[className];
        }
		public static function getClass (obj :Object) :Class
		{
			if (obj.constructor is Class) {
				return Class(obj.constructor);
			}
			return getClassByName(getQualifiedClassName(obj));
		}
		/**
		 * Get just the class name, e.g. "ClassUtil".
		 */
		public static function tinyClassName (obj :Object) :String
		{
			var s :String = getClassName(obj);
			var dex :int = s.lastIndexOf(".");
			return s.substring(dex + 1); // works even if dex is -1
		}
		/**
		 * Get the full class name, e.g. "com.threerings.util.ClassUtil".
		 * Calling getClassName with a Class object will return the same value as calling it with an
		 * instance of that class. That is, getClassName(Foo) == getClassName(new Foo()).
		 */
		public static function getClassName (obj :Object) :String
		{
			return getQualifiedClassName(obj).replace("::", ".");
		}
		public static function getClassByName(name:String):Class
		{
			return AssetsLibrary.getClass(name);
//			if(ApplicationDomain.currentDomain.hasDefinition(name)){
//				return getDefinitionByName(name) as Class;
//			}
//			return null;
		}
		/**
		 * Creates an instance of the given class and passes the arguments to
		 * the constructor.
		 *
		 * TODO find a generic solution for this. Currently we support constructors
		 * with a maximum of 10 arguments.
		 *
		 * @param clazz the class from which an instance will be created
		 * @param args the arguments that need to be passed to the constructor
		 */
		public static function newInstance(clazz:Class, args:Array = null):* {
			var result:*;
			var a:Array = (args == null) ? [] : args;
			
			switch (a.length) {
				case 1:
					result = new clazz(a[0]);
					break;
				case 2:
					result = new clazz(a[0], a[1]);
					break;
				case 3:
					result = new clazz(a[0], a[1], a[2]);
					break;
				case 4:
					result = new clazz(a[0], a[1], a[2], a[3]);
					break;
				case 5:
					result = new clazz(a[0], a[1], a[2], a[3], a[4]);
					break;
				case 6:
					result = new clazz(a[0], a[1], a[2], a[3], a[4], a[5]);
					break;
				case 7:
					result = new clazz(a[0], a[1], a[2], a[3], a[4], a[5], a[6]);
					break;
				case 8:
					result = new clazz(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]);
					break;
				case 9:
					result = new clazz(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8]);
					break;
				case 10:
					result = new clazz(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9]);
					break;
				default:
					result = new clazz();
			}
			
			return result;
		}
        private static var _typeDescriptions:Dictionary = new Dictionary();
        private static var _instantiators:Dictionary = new Dictionary();
    }
}