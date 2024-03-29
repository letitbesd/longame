package com.xingcloud.util
{
	import com.longame.utils.debug.Logger;
	import com.xingcloud.model.DBObject;
	
	import flash.display.LoaderInfo;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * TypeUtility is a static class containing methods that aid in type
	 * introspection and reflection.
	 */
	public class Reflection
	{
		private static var _typeDescriptions:Dictionary=new Dictionary();
		private static var _instantiators:Dictionary=new Dictionary();
		private static var _domains:Array=[];

		/**
		 *获取对象中某个属性的类型,获取范围包括包含一切公共的成员变量,公共的静态成员变量以及getter/setter类型
		 * @param object 需要处理的对象
		 * @param fieldName 属性的名称
		 * @return 属性所对应的类
		 *
		 */
		public static function getVariableType(object:Object, fieldName:String):Class
		{
			var xml:XML=describeType(object);
			var varChild:XML;
			for each (varChild in xml.variable)
			{
				if (varChild.@name.toString() == fieldName)
				{
					return getClassByName(varChild.@type.toString());
				}
			}
			for each (varChild in xml.accessor)
			{
				if (varChild.@name.toString() == fieldName)
				{
					return getClassByName(varChild.@type.toString());
				}
			}
			if (object is Class) //从构造里获取定义
			{
				for each (varChild in xml.factory.variable)
				{
					if (varChild.@name.toString() == fieldName)
					{
						return getClassByName(varChild.@type.toString());
					}
				}
				for each (varChild in xml.factory.accessor)
				{
					if (varChild.@name.toString() == fieldName)
					{
						return getClassByName(varChild.@type.toString());
					}
				}
			}
			return null;
		}

		/**
		 *  判定一个对象是否继承自某个类
		 * @param target 需要判断的对象
		 * @param baseClass 基类
		 * @return target是否是baseClass类型或继承自baseClass类型
		 *
		 */
		public static function checkBaseClass(target:Object, baseClass:Class):Boolean
		{
			if (target is Class)
			{
				var xml:XML=describeType(target);
				for each (var extend:XML in xml.extendsClass)
				{
					if (extend.@type.toString() == getQualifiedClassName(baseClass))
						return true;
				}
			}
			else
			{
				return (target is baseClass);
			}
			return false;
		}

		/**
		 * 将source的所有属性复制到target上
		 * @param source:要复制的源头
		 * @param target:要赋值的对象
		 * @param excluded:不希望复制的字段,如["id","name"]
		 * */
		public static function cloneProperties(source:Object, target:Object, excluded:Array=null):void
		{
			var cls:Class=getClassByInstance(source)
			var props:Array=[];
			if (cls == Object)
			{
				for (var key:String in source)
				{
					props.push(key);
				}
			}
			else
			{
				props=Reflection.getVariableNames(source, true);
			}
			var prop:String;
			for each (prop in props)
			{
				if (excluded && (excluded.indexOf(prop) >= 0))
					continue;
				if (target.hasOwnProperty(prop))
				{
					try
					{
						if (isSimple(target[prop]))
						{
							target[prop]=source[prop];
						}
						else
						{
							var varType:Class=getVariableType(target, prop);
							if (varType == Dictionary)
							{
								target[prop]=new Dictionary();
								cloneProperties(source[prop], target[prop]);
							}
							else if (varType == Object)
							{
								target[prop]=source[prop];
							}
							else if (checkBaseClass(varType, DBObject))
							{
								if (!target[prop])
									target[prop]=new varType();
								(target[prop] as DBObject).parseFromObject(source[prop]);
							}
							else
							{
								target[prop]=source[prop];
							}
						}
					}
					catch (e:Error)
					{
						Logger.error("Reflection","cloneProperties",e.message);
						continue;
					}
				}
			}
		}

		/**
		 * 获取对象变量名列表
		 * @param object 对象
		 * @param includeGetter:是否包含get,set方法
		 * */
		public static function getVariableNames(object:Object, includeGetter:Boolean=false):Array
		{
			var variableList:Array=[];
			var xml:XML=describeType(object);
			var child:XML;
			if (object is Class)
			{
				for each (child in xml.factory.variable)
				{
					variableList.push(child.@name.toString());
				}
				if (includeGetter)
				{
					for each (child in xml.factory.accessor)
					{
						variableList.push(child.@name.toString());
					}
				}
			}
			else
			{
				for each (child in xml.variable)
				{
					variableList.push(child.@name.toString());
				}
				if (includeGetter)
				{
					for each (child in xml.accessor)
					{
						variableList.push(child.@name.toString());
					}
				}
			}
			return variableList;
		}

		/**
		 * 获取类的最短名称，即不包括完整包名
		 * @param obj 类或实例对象
		 * @return 最短类名
		 */
		public static function tinyClassName(obj:Object):String
		{
			var s:String=fullClassName(obj);
			var dex:int=s.lastIndexOf(".");
			return s.substring(dex + 1); // works even if dex is -1
		}

		/**
		 * 获取类的完整名称
		 * @param obj 类或者实例对象
		 * @return 完整类名
		 *
		 */
		public static function fullClassName(obj:Object):String
		{
			return getQualifiedClassName(obj).replace("::", ".");
		}

		/**
		 *根据实例获取类定义
		 * @param obj 实例对象
		 * @return 类定义
		 *
		 */
		public static function getClassByInstance(obj:Object):Class
		{
			return getClassByName(getQualifiedClassName(obj));
		}

		/**
		 *根据名称获取类定义
		 * @param cname 完整类名称
		 * @param domain 查找的程序域
		 * @return 类定义
		 *
		 */
		public static function getClassByName(cname:String, domain:ApplicationDomain=null):Class
		{
			cname=cname.replace("::", ".");
			if (domain)
			{
				if (domain.hasDefinition(cname))
				{
					return domain.getDefinition(cname) as Class;
				}
			}
			else
			{
				try
				{
					var length:int=_domains.length;
					for (var i:int=0; i < length; i++)
					{
						var domain:ApplicationDomain=_domains[i];
						if (domain == null)
							continue;
						if (domain.hasDefinition(cname))
						{
							return domain.getDefinition(cname) as Class;
						}
					}
					return getDefinitionByName(cname) as Class;
				}
				catch (e:Error)
				{

				}
			}
			return null;
		}

		/**
		 *获取当前对象的内存地址
		 * @param target 需要获取地址的对象
		 * @return 此对象的内存地址
		 *
		 */
		public static function getAdress(target:Object):String
		{
			try
			{
				AdressType(target);
			}
			catch (e:Error)
			{
				var reg:RegExp=/@[0-9a-f]{7}/;
				return reg.exec(e.message);
			}
			return "@0000000";
		}

		/**
		 * 是否是动态对象
		 * @param target 需要检查的对象
		 * @return 是否是动态
		 *
		 */
		public static function isDynamic(target:Object):Boolean
		{
			var isdynamic:String=describeType(target).@isDynamic.toString();
			return isdynamic == "true";
		}

		/**
		 *  检验是否是简单对象，简单对象包括:
		 *  <ul>
		 *    <li><code>String</code></li>
		 *    <li><code>Number</code></li>
		 *    <li><code>uint</code></li>
		 *    <li><code>int</code></li>
		 *    <li><code>Boolean</code></li>
		 *    <li><code>Date</code></li>
		 *    <li><code>Array</code></li>
		 *  </ul>
		 *
		 *  @param value 需要检测的对象
		 *
		 *  @return 是简单对象则返回true
		 */
		public static function isSimple(value:Object):Boolean
		{
			var type:String=typeof(value);
			switch (type)
			{
				case "number":
				case "string":
				case "boolean":
				{
					return true;
				}

				case "object":
				{
					return (value is Date) || (value is Array);
				}
			}

			return false;
		}

		public static function addApplicationDomain(d:ApplicationDomain):void
		{
			_domains.push(d);
		}

		/**
		 * Return an array of class names in LoaderInfo object.
		 *
		 * @param	target		Associated LoaderInfo object or a ByteArray, which contains swf data.
		 *
		 * @param	extended	If false, function returns only classes.
		 * 						If true, function return all visible definitions (classes, interfaces, functions,
		 * 						namespaces, variables, constants, vectors, etc.).
		 * 						Extended mode is slightly slower than a regular search.
		 *
		 * @param	linkedOnly	If true, function returns only linked classes (objects with linkage),
		 * 						MUCH faster than regular or extended search.
		 * 						This mode is preferable if you need only graphic resources (sprites, bitmaps, fonts, etc.).
		 * 						NB: "extended" parameter will be ignored if this argument is true.
		 */
		public static function getDefinitionNames(target:Object, extended:Boolean=false, linkedOnly:Boolean=false):Array
		{
			var bytes:ByteArray;

			if (target is LoaderInfo)
			{
				bytes=(target as LoaderInfo).bytes;
			}
			else if (target is ByteArray)
			{
				bytes=target as ByteArray;
			}
			else
				throw new ArgumentError('Error #1001: The specified target is invalid');

			var position:uint=bytes.position;
			var finder:Finder=new Finder(bytes);
			bytes.position=position;
			return finder.getDefinitionNames(extended, linkedOnly);
		}
	}
}

import flash.geom.Rectangle;
import flash.utils.ByteArray;
import flash.utils.Endian;

internal class Finder
{

	public function Finder(bytes:ByteArray)
	{
		super();
		this._data=new SWFByteArray(bytes);
	}

	/**
	 * @private
	 */
	private var _data:SWFByteArray;

	/**
	 * @private
	 */
	private var _stringTable:Array;

	/**
	 * @private
	 */
	private var _namespaceTable:Array;

	/**
	 * @private
	 */
	private var _multinameTable:Array;

	public function getDefinitionNames(extended:Boolean, linkedOnly:Boolean):Array
	{
		var definitions:Array=new Array();
		var tag:uint;
		var id:uint;
		var length:uint;
		var minorVersion:uint;
		var majorVersion:uint;
		var position:uint;
		var name:String;
		var index:int;

		while (this._data.bytesAvailable)
		{
			tag=this._data.readUnsignedShort();
			id=tag >> 6;
			length=tag & 0x3F;
			length=(length == 0x3F) ? this._data.readUnsignedInt() : length;
			position=this._data.position;

			if (linkedOnly)
			{
				if (id == 76)
				{
					var count:uint=this._data.readUnsignedShort();

					while (count--)
					{
						this._data.readUnsignedShort(); // Object ID
						name=this._data.readString();
						index=name.lastIndexOf('.');
						if (index >= 0)
							name=name.substr(0, index) + '::' + name.substr(index + 1); // Fast. Simple. Cheat ;)
						definitions.push(name);
					}
				}
			}
			else
			{
				switch (id)
				{
					case 72:
					case 82:
						if (id == 82)
						{
							this._data.position+=4;
							this._data.readString(); // identifier
						}

						minorVersion=this._data.readUnsignedShort();
						majorVersion=this._data.readUnsignedShort();
						if (minorVersion == 0x0010 && majorVersion == 0x002E)
							definitions.push.apply(definitions, this.getDefinitionNamesInTag(extended));
						break;
				}
			}

			this._data.position=position + length;
		}

		return definitions;
	}

	/**
	 * @private
	 */
	private function getDefinitionNamesInTag(extended:Boolean):Array
	{
		var classesOnly:Boolean=!extended;
		var count:int;
		var kind:uint;
		var id:uint;
		var flags:uint;
		var counter:uint;
		var ns:uint;
		var names:Array=new Array();
		this._stringTable=new Array();
		this._namespaceTable=new Array();
		this._multinameTable=new Array();

		// int table
		count=this._data.readASInt() - 1;

		while (count > 0 && count--)
		{
			this._data.readASInt();
		}

		// uint table
		count=this._data.readASInt() - 1;

		while (count > 0 && count--)
		{
			this._data.readASInt();
		}

		// Double table
		count=this._data.readASInt() - 1;

		while (count > 0 && count--)
		{
			this._data.readDouble();
		}

		// String table
		count=this._data.readASInt() - 1;
		id=1;

		while (count > 0 && count--)
		{
			this._stringTable[id]=this._data.readUTFBytes(this._data.readASInt());
			id++;
		}

		// Namespace table
		count=this._data.readASInt() - 1;
		id=1;

		while (count > 0 && count--)
		{
			kind=this._data.readUnsignedByte();
			ns=this._data.readASInt();
			if (kind == 0x16)
				this._namespaceTable[id]=ns; // only public
			id++;
		}

		// NsSet table
		count=this._data.readASInt() - 1;

		while (count > 0 && count--)
		{
			counter=this._data.readUnsignedByte();
			while (counter--)
				this._data.readASInt();
		}

		// Multiname table
		count=this._data.readASInt() - 1;
		id=1;

		while (count > 0 && count--)
		{
			kind=this._data.readASInt();

			switch (kind)
			{
				case 0x07:
				case 0x0D:
					ns=this._data.readASInt();
					this._multinameTable[id]=[ns, this._data.readASInt()];
					break;
				case 0x0F:
				case 0x10:
					this._multinameTable[id]=[0, this._stringTable[this._data.readASInt()]];
					break;
				case 0x11:
				case 0x12:
					break;
				case 0x09:
				case 0x0E:
					this._multinameTable[id]=[0, this._stringTable[this._data.readASInt()]];
					this._data.readASInt();
					break;
				case 0x1B:
				case 0x1C:
					this._data.readASInt();
					break;
				case 0x1D: // Generic
					if (extended)
					{
						var multinameID:uint=this._data.readASInt(); // u8 or u30, maybe YOU know?
						// param count (u8 or u30), should always to be 1 in current ABC versions
						var params:uint=this._data.readASInt();
						name=this.getName(multinameID);

						while (params--)
						{
							var paramID:uint=this._data.readASInt();

							if (name)
							{ // not the best method, i know
								name=name + '.<' + this.getName(paramID) + '>';
								names.push(name);
							}
						}

						this._multinameTable[id]=[0, name];
					}
					else
					{
						this._data.readASInt();
						this._data.readASInt();
						this._data.readASInt();
					}
					break;
			}

			id++;
		}

		// Method table
		count=this._data.readASInt();

		while (count > 0 && count--)
		{
			var paramsCount:int=this._data.readASInt();
			counter=paramsCount;
			this._data.readASInt();
			while (counter--)
				this._data.readASInt();
			this._data.readASInt();
			flags=this._data.readUnsignedByte();

			if (flags & 0x08)
			{
				counter=this._data.readASInt();

				while (counter--)
				{
					this._data.readASInt();
					this._data.readASInt();
				}
			}

			if (flags & 0x80)
			{
				counter=paramsCount;
				while (counter--)
					this._data.readASInt();
			}
		}

		// Metadata table
		count=this._data.readASInt();

		while (count > 0 && count--)
		{
			this._data.readASInt();
			counter=this._data.readASInt();

			while (counter--)
			{
				this._data.readASInt();
				this._data.readASInt();
			}
		}

		// Instance table
		count=this._data.readASInt();
		var classCount:uint=count;
		var name:String;
		var isInterface:Boolean;

		while (count > 0 && count--)
		{
			id=this._data.readASInt();
			this._data.readASInt();
			flags=this._data.readUnsignedByte();
			if (flags & 0x08)
				ns=this._data.readASInt();
			isInterface=Boolean(flags & 0x04);
			counter=this._data.readASInt();
			while (counter--)
				this._data.readASInt();
			this._data.readASInt(); // iinit
			this.readTraits();

			if (classesOnly && !isInterface)
			{
				name=this.getName(id);
				if (name)
					names.push(name);
			}
		}

		if (classesOnly)
			return names;

		// Class table
		count=classCount;

		while (count && count--)
		{
			this._data.readASInt(); // cinit
			this.readTraits();
		}

		// Script table
		count=this._data.readASInt();
		var traits:Array;

		while (count && count--)
		{
			this._data.readASInt(); // init
			traits=this.readTraits(true);
			if (traits.length)
				names.push.apply(names, traits);
		}

		return names;
	}

	/**
	 * @private
	 */
	private function readTraits(buildNames:Boolean=false):Array
	{
		var kind:uint;
		var counter:uint;
		var ns:uint;
		var id:uint;
		var traitCount:uint=this._data.readASInt();
		var names:Array;
		var name:String;
		if (buildNames)
			names=[];

		while (traitCount--)
		{
			id=this._data.readASInt(); // name
			kind=this._data.readUnsignedByte();
			var upperBits:uint=kind >> 4;
			var lowerBits:uint=kind & 0xF;
			this._data.readASInt();
			this._data.readASInt();

			switch (lowerBits)
			{
				case 0x00:
				case 0x06:
					if (this._data.readASInt())
						this._data.readASInt();
					break;
			}

			if (buildNames)
			{
				name=this.getName(id);
				if (name)
					names.push(name);
			}

			if (upperBits & 0x04)
			{
				counter=this._data.readASInt();
				while (counter--)
					this._data.readASInt();
			}
		}

		return names;
	}

	/**
	 * @private
	 */
	private function getName(id:uint):String
	{
		if (!(id in this._multinameTable))
			return null;
		var mn:Array=this._multinameTable[id] as Array;
		var ns:uint=mn[0] as uint;
		var nsName:String=this._stringTable[this._namespaceTable[ns] as uint] as String;
		var name:String=mn[1] is String ? mn[1] : (this._stringTable[mn[1] as uint] as String);
		if (nsName && nsName.indexOf('__AS3__') < 0 /* cheat! */)
			name=nsName + '::' + name;
		return name;
	}
}

internal class AdressType
{
}

internal class SWFByteArray extends ByteArray
{

	/**
	 * @private
	 */
	private static const TAG_SWF:String='FWS';

	/**
	 * @private
	 */
	private static const TAG_SWF_COMPRESSED:String='CWS';

	public function SWFByteArray(data:ByteArray=null):void
	{
		super();
		super.endian=Endian.LITTLE_ENDIAN;
		var endian:String;
		var tag:String;

		if (data)
		{
			endian=data.endian;
			data.endian=Endian.LITTLE_ENDIAN;

			if (data.bytesAvailable > 26)
			{
				tag=data.readUTFBytes(3);

				if (tag == SWFByteArray.TAG_SWF || tag == SWFByteArray.TAG_SWF_COMPRESSED)
				{
					this._version=data.readUnsignedByte();
					data.readUnsignedInt();
					data.readBytes(this);
					if (tag == SWFByteArray.TAG_SWF_COMPRESSED)
						super.uncompress();
				}
				else
					throw new ArgumentError('Error #2124: Loaded file is an unknown type.');

				this.readHeader();
			}

			data.endian=endian;
		}
	}

	/**
	 * @private
	 */
	private var _bitIndex:uint;

	/**
	 * @private
	 */
	private var _version:uint;

	/**
	 * @private
	 */
	private var _frameRate:Number;

	/**
	 * @private
	 */
	private var _rect:Rectangle;

	public function get version():uint
	{
		return this._version;
	}

	public function get frameRate():Number
	{
		return this._frameRate;
	}

	public function get rect():Rectangle
	{
		return this._rect;
	}

	public function writeBytesFromString(bytesHexString:String):void
	{
		var length:uint=bytesHexString.length;

		for (var i:uint=0; i < length; i+=2)
		{
			var hexByte:String=bytesHexString.substr(i, 2);
			var byte:uint=parseInt(hexByte, 16);
			writeByte(byte);
		}
	}

	public function readRect():Rectangle
	{
		var pos:uint=super.position;
		var byte:uint=this[pos];
		var bits:uint=byte >> 3;
		var xMin:Number=this.readBits(bits, 5) / 20;
		var xMax:Number=this.readBits(bits) / 20;
		var yMin:Number=this.readBits(bits) / 20;
		var yMax:Number=this.readBits(bits) / 20;
		super.position=pos + Math.ceil(((bits * 4) - 3) / 8) + 1;
		return new Rectangle(xMin, yMin, xMax - xMin, yMax - yMin);
	}

	public function readBits(length:uint, start:int=-1):Number
	{
		if (start < 0)
			start=this._bitIndex;
		this._bitIndex=start;
		var byte:uint=this[super.position];
		var out:Number=0;
		var shift:Number=0;
		var currentByteBitsLeft:uint=8 - start;
		var bitsLeft:Number=length - currentByteBitsLeft;

		if (bitsLeft > 0)
		{
			super.position++;
			out=this.readBits(bitsLeft, 0) | ((byte & ((1 << currentByteBitsLeft) - 1)) << (bitsLeft));
		}
		else
		{
			out=(byte >> (8 - length - start)) & ((1 << length) - 1);
			this._bitIndex=(start + length) % 8;
			if (start + length > 7)
				super.position++;
		}

		return out;
		return 0;
	}

	public function readASInt():int
	{
		var result:uint=0;
		var i:uint=0, byte:uint;
		do
		{
			byte=super.readUnsignedByte();
			result|=(byte & 0x7F) << (i * 7);
			i+=1;
		} while (byte & 1 << 7);
		return result;
	}

	public function readString():String
	{
		var i:uint=super.position;
		while (this[i] && (i+=1))
		{
		}
		var str:String=super.readUTFBytes(i - super.position);
		super.position=i + 1;
		return str;
	}

	public function traceArray(array:ByteArray):String
	{ // for debug
		var out:String='';
		var pos:uint=array.position;
		var i:uint=0;
		array.position=0;

		while (array.bytesAvailable)
		{
			var str:String=array.readUnsignedByte().toString(16).toUpperCase();
			str=str.length < 2 ? '0' + str : str;
			out+=str + ' ';
		}

		array.position=pos;
		return out;
	}

	/**
	 * @private
	 */
	private function readFrameRate():void
	{
		if (this._version < 8)
		{
			this._frameRate=super.readUnsignedShort();
		}
		else
		{
			var fixed:Number=super.readUnsignedByte() / 0xFF;
			this._frameRate=super.readUnsignedByte() + fixed;
		}
	}

	/**
	 * @private
	 */
	private function readHeader():void
	{
		this._rect=this.readRect();
		this.readFrameRate();
		super.readShort(); // num of frames
	}
}
