﻿/*** MotionBlurPlugin by Grant Skinner. Nov 3, 2009* Visit www.gskinner.com/blog for documentation, updates and more free code.*** Copyright (c) 2009 Grant Skinner* * Permission is hereby granted, free of charge, to any person* obtaining a copy of this software and associated documentation* files (the "Software"), to deal in the Software without* restriction, including without limitation the rights to use,* copy, modify, merge, publish, distribute, sublicense, and/or sell* copies of the Software, and to permit persons to whom the* Software is furnished to do so, subject to the following* conditions:* * The above copyright notice and this permission notice shall be* included in all copies or substantial portions of the Software.* * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR* OTHER DEALINGS IN THE SOFTWARE.**/package com.gskinner.motion.plugins {		import com.gskinner.motion.GTween;	import flash.filters.BlurFilter;		/**	* Plugin for GTween. Automatically applies a motion blur effect when x & y are tweened. This plugin	* will create a new blur filter on the target, and remove it based on a saved index when the tween ends.	* This can potentially cause problems with other filters that create or remove filters.	* <br/><br/>	* <b>Note:</b> Because it works on the common x,y properties, and has a reasonably high CPU cost,	* this plugin is disabled for all tweens by default (ie. its enabled property is set to false).	* Set <code>pluginData.MotionBlurEnabled</code> to true on the tweens you want to enable it for,	* or set <code>MotionBlurPlugin.enabled</code> to true to enable it by default for all tweens.	* <br/><br/>	* Supports the following <code>pluginData</code> properties:<UL>	* <LI> MotionBlurEnabled: overrides the enabled property for the plugin on a per tween basis.	* <LI> MotionBlurData: Used internally.	* </UL>	**/	public class MotionBlurPlugin implements IGTweenPlugin {			// Static interface:		/** Specifies whether this plugin is enabled for all tweens by default. **/		public static var enabled:Boolean=false;				/** Specifies the strength to use when calculating the blur. A higher value will result in more blurring. **/		public static var strength:Number = 0.6;				/** @private **/		protected static var instance:MotionBlurPlugin;				/**		* Installs this plugin for use with all GTween instances.		**/		public static function install():void {			if (instance) { return; }			instance = new MotionBlurPlugin();			GTween.installPlugin(instance,["x","y"]);		}			// Public methods:		/** @private **/		public function init(tween:GTween, name:String, value:Number):Number {			return value;		}				/** @private **/		public function tween(tween:GTween, name:String, value:Number, initValue:Number, rangeValue:Number, ratio:Number, end:Boolean):Number {			if (!((enabled && tween.pluginData.MotionBlurEnabled == null) || tween.pluginData.MotionBlurEnabled)) { return value; }						var data:Object = tween.pluginData.MotionBlurData;			if (data == null) { data = initTarget(tween); }						var f:Array = tween.target.filters;			var blurF:BlurFilter = f[data.index] as BlurFilter;			if (blurF == null) { return value; }			if (end) {				f.splice(data.index,1);				delete(tween.pluginData.MotionBlurData);			} else {				var blur:Number = Math.abs((tween.ratioOld-ratio)*rangeValue*strength);				if (name == "x") { blurF.blurX = blur; }				else { blurF.blurY = blur; }			}			tween.target.filters = f;						// tell GTween to tween x/y with the default value:			return value;		}			// Private methods:		/** @private **/		protected function initTarget(tween:GTween):Object {			var f:Array = tween.target.filters;			f.push(new BlurFilter(0,0,1));			tween.target.filters = f;			return tween.pluginData.MotionBlurData = {index:f.length-1}		}			}}