package com.longame.display.screen
{
	import com.bumpslide.ui.BaseClip;
	import com.bumpslide.ui.UIComponent;
	import com.longame.core.IDisposable;
	import com.longame.display.core.RenderManager;
	import com.longame.game.scene.BaseScene;
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
	public class McScreen extends UIComponent  implements  IScreen
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		private var source:*;
		/**
		 * Creates a new McScreen instance.
		 */
		public function McScreen(source:*)
		{
			super();
			if(source==null){
				throw new Error("Source is null!");
			}
			this.source=source;
		}
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public function get scene():BaseScene
		{
			return null;
		}
		public function get ui():UIComponent{
			return this;	
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
			RenderManager.getDisplayFromSource(source,setup,null,false,true);
//			if(ResourceManager.instance.paused) this.setup();
//			else ResourceManager.instance.onComplete.addOnce(this.setup);
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
		override protected function doDispose():void
		{
			removeEvents();
			super.doDispose();
			_onCreate=null;
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
		protected function setup(skin:DisplayObject):void
		{
//			ResourceManager.instance.onComplete.remove(this.setup);
			this.onCreate.dispatch(this);
			this.skin=skin;
		}
		override protected function initSkinParts():void
		{
			super.initSkinParts();
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
