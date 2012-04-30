package com.longame.display.screen
{
	import com.bumpslide.ui.BaseClip;
	import com.longame.core.IDisposable;
	import com.longame.display.core.RenderManager;
	import com.longame.resource.ResourceManager;
	import com.longame.utils.DisplayObjectUtil;
	import com.xingcloud.tutorial.TutorialManager;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import org.osflash.signals.Signal;
	
	/**
	 * McScreen Class
	 * 
	 * @author Sascha Balkau
	 * @version 0.9.5
	 */
	public class McScreen extends BaseClip implements  IScreen
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new McScreen instance.
		 */
		public function McScreen()
		{
			super();
		}
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public function get sceneLayer():Sprite{
			return null;
		}
		public function get ui():Sprite{
			return null;	
		}
		protected var _onCreate:Signal=new Signal(McScreen);
		public function get onCreate():Signal
		{
			return _onCreate;
		}
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		/**
		 * @inheritDoc
		 */
		public function load():void
		{
			if(ResourceManager.instance.paused) this.setup();
			else ResourceManager.instance.onComplete.addOnce(this.setup);
		}
		/**
		 * @inheritDoc
		 */
		public function update(para:Object=null):void
		{
			//to be inherited
		}
		/**
		 * @inheritDoc
		 */
		override protected function doDestroy():void
		{
			removeEvents();
			super.doDestroy();
			_onCreate=null;
			RenderManager.dispose();
		}
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Sets up the display. This method should only be called once after object
		 * instantiation. It initiates the display by creating child objects and adding
		 * event listeners.
		 * 
		 * @private
		 */
		protected function setup(data:*=null):void
		{
			ResourceManager.instance.onComplete.remove(this.setup);
			this.onCreate.dispatch(this);
		}
		override protected function whenSkinned():void
		{
			this.addEvents();
		}
		/**
		 * Should be used to add any required event listeners to the display and/or it's
		 * children.
		 * 
		 * @private
		 */
		protected function addEvents():void
		{
			/* Abstract method! */
		}
		
		
		/**
		 * Used to remove any event listeners that has been added with addEventListeners().
		 * This method is automatically called by the destroy() method.
		 * 
		 * @private
		 */
		protected function removeEvents():void
		{
			/* Abstract method! */		
		}
	}
}
