package com.longame.modules.entities.display.primitive
{
	import __AS3__.vec.Vector;
	
	import com.longame.display.graphics.IFill;
	import com.longame.display.graphics.IStroke;
	import com.longame.display.graphics.SolidColorFill;
	import com.longame.display.graphics.Stroke;
	import com.longame.model.consts.Registration;
	import com.longame.model.consts.RenderStyle;
	import com.longame.modules.entities.DisplayEntity;
	import com.longame.utils.debug.Logger;

	/**
	 * AbstractPrimitive 这是一个画图来展示可视对象的基本类
	 */
	public class AbstractPrimitive extends DisplayEntity implements IPrimitive
	{
		////////////////////////////////////////////////////////////////////////
		//	CONSTANTS
		////////////////////////////////////////////////////////////////////////
		
		static public const DEFAULT_WIDTH:Number = 25;
		static public const DEFAULT_LENGTH:Number = 25;
		static public const DEFAULT_HEIGHT:Number = 25;
		
		//////////////////////////////////////////////////////
		// STYLES
		//////////////////////////////////////////////////////
		protected var _renderStyle:String = RenderStyle.SOLID;
		
		/**
		 * @private
		 */
		public function get renderStyle ():String
		{
			return _renderStyle;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set renderStyle (value:String):void
		{
			if (_renderStyle != value)
			{
				_renderStyle = value;
				_styleInvalidated=true;
			}
		}
		
		//////////////////////////////
		//	MATERIALS
		//////////////////////////////
			//	PROFILE STROKE
			//////////////////////////////
		
		private var pStroke:IStroke;
		
		public function get profileStroke ():IStroke
		{
			return pStroke;
		}
		
		public function set profileStroke (value:IStroke):void
		{
			if (pStroke != value)
			{
				pStroke = value;
				_styleInvalidated=true;
			}
		}
		
			//	MAIN FILL
			//////////////////////////////
		
		public function get fill ():IFill
		{
			return IFill(fills[0]);
		}
		
		public function set fill (value:IFill):void
		{
			fills = [value, value, value, value, value, value];
		}
		
			//	FILLS
			//////////////////////////////
		
		static protected const DEFAULT_FILL:IFill = new SolidColorFill(0xFFFFFF, 1);
		
		private var fillsArray:Vector.<IFill> = new Vector.<IFill>();
		
		/**
		 * @private
		 */
		public function get fills ():Array
		{
			var temp:Array = [];
			var f:IFill;
			for each (f in fillsArray)
				temp.push(f);
			
			return temp;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set fills (value:Array):void
		{
			if (value)
				fillsArray = Vector.<IFill>(value);
			
			else
				fillsArray = new Vector.<IFill>();
			
			_styleInvalidated=true;
		}
		
			//	MAIN STROKE
			//////////////////////////////
		
		public function get stroke ():IStroke
		{
			return IStroke(strokes[0]);
		}
		
		public function set stroke (value:IStroke):void
		{
			strokes = [value, value, value, value, value, value];
		}
		
			//	STROKES
			//////////////////////////////
		static protected const DEFAULT_STROKE:IStroke = new Stroke(0, 0x000000,.6);
		
		private var edgesArray:Vector.<IStroke> = new Vector.<IStroke>();
		
		/**
		 * @private
		 */
		public function get strokes ():Array
		{
			var temp:Array = [];
			var s:IStroke;
			for each (s in edgesArray)
				temp.push(s);
			
			return temp;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set strokes (value:Array):void
		{
			if (value)
				edgesArray = Vector.<IStroke>(value);
			
			else
				edgesArray = new Vector.<IStroke>();
			
			_styleInvalidated=true;
		}
		
		/////////////////////////////////////////////////////////
		//	RENDER
		/////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		override protected function doRender ():void
		{
			//we do this before calling super.render() so as to only perform drawing logic for the size or style invalidation, not both.
			if (_sizeInvalidated || _styleInvalidated)
			{
				if (!validateGeometry())
				{
					Logger.error(this,"doRender","validation of geometry failed.");
					return;
//					throw new Error("validation of geometry failed.");
				}
				
				drawGeometry();
				_styleInvalidated = false;
			}
			
			super.doRender();
		}
		
		/////////////////////////////////////////////////////////
		//	VALIDATION
		/////////////////////////////////////////////////////////
		
		
		/**
 		 * 验证此图形的尺寸是否合法，只有合法才能画
		 */
		protected function validateGeometry ():Boolean
		{
			//overridden by subclasses
			return true;	
		}
		
		/**
		 * @inheritDoc
		 */
		protected function drawGeometry ():void
		{
			//overridden by subclasses
		}
		
		////////////////////////////////////////////////////////////
		//	INVALIDATION
		////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var _styleInvalidated:Boolean = false;
		/**
		 * @inheritDoc
		 */
		override public function get invalidated():Boolean
		{
			return _positionInvalidated||_scaleInvalidated||_rotationInvalidated||_styleInvalidated;
		}	
		
		////////////////////////////////////////////////////////////
		//	CLONE
		////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function clone ():*
		{
//			var cloneInstance:IPrimitive = super.clone() as IPrimitive;
//			cloneInstance.fills = fills;
//			cloneInstance.strokes = strokes
//			cloneInstance.styleType = styleType;
//			
//			return cloneInstance;
		}
		
		////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		////////////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function AbstractPrimitive (id:String=null)
		{
			super(id);
			_registration=Registration.TOP_LEFT;
		}
		
	}
}