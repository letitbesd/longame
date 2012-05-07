﻿/**
 * This code is part of the Bumpslide Library maintained by David Knape
 * Fork me at http://github.com/tkdave/bumpslide_as3
 * 
 * Copyright (c) 2010 by Bumpslide, Inc. 
 * http://www.bumpslide.com/
 *
 * This code is released under the open-source MIT license.
 * See LICENSE.txt for full license terms.
 * More info at http://www.opensource.org/licenses/mit-license.php
 */

	// notifies listenerers that we've been redrawn
	[Event(name="redraw",type="com.bumpslide.events.UIEvent")]
	
	// fired after mxml children are created, or 1ms after constructor has finished
	[Event(name="creationComplete",type="flash.events.Event")]
	
	// MXML Default property
	[DefaultProperty("children")]
	

		
		// properties to apply to skin if we create it by class reference
		private var _skinProps:Object;

		/**
		 * inject a movieclip as a skin
		 * */
		protected var skinInjector:SkinInjector;
			skinInjector=new SkinInjector(this)
			skinInjector.dispose();
			skinInjector=null;
			_invalidated=null;
			_skinClass=null;
			_skin=null;
			_skinProps=null;
				if(hasChanged(VALID_SKIN_STATE)){
					if(_skin is ISkin){
						(_skin as ISkin).renderSkin( skinState );
					}else if(_skin is MovieClip){
						try {
							var displayMethod:Function = this['_' + skinState];
							displayMethod.call( this );
						} catch (e:Error) {
							this.skinInjector.update(_skinState);
						}
					}
					triggerRender();
					validate( VALID_SKIN_STATE );
				}
		 * Trigger a stage Event.RENDER and handle it with the render method.
		 * 
		 * If there is no stage, render is called on the next frame.
		 * Called on the first render event after a skin state change has been applied
		 * 
		 * If using movieclip frames, this is a good time to update the content in that frame.
		 * 
		 * By default, we update size. Use case for this is Buttons with flash movieclips as skin states.
		 */
		 * When skin state changed
		 * 1. If the skin is ISkin, it will call ISkin.render() method
		 * 2. If the skin is MovieClip,  it will try to call this["_"+skinState] function or (skin as MovieClip).gotoAndStop(skinState)
				ObjectUtil.mergeProperties( skinProps, _skin);
				initSkinParts();
			}
			
			var part:DisplayObject=skinInjector.getSkinPart(name);
			if(part) return part;
			// look for skinPart in the skin
		{
			return mouseEnabled;
		}
			if(skin && skinProps) ObjectUtil.mergeProperties( skinProps, skin);