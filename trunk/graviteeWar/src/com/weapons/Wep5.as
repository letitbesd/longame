package com.weapons
{
	import com.IFrameObject;
	import com.Planet;
	import com.Scene;
	import com.heros.Hero;
	import com.longame.managers.AssetsLibrary;
	import com.longame.utils.MathUtil;
	import com.time.EnterFrame;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	public class Wep5 extends WepBase 
	{			
		private var currentPlanet:Planet;
		private var content:MovieClip;
		private var isOn:Boolean=false;
		private var count:int=0;
		private var playSlow:Boolean=true;
		public function Wep5(id:int,planet:Planet)
		{
			super(id);
			currentPlanet=planet;
			this.damageScopeStrength=1.3;
		}
		override public function simulatePath(param:Object, heroIndex:int):void
		{
			
		}
		override public function shoot():void
		{
			content=AssetsLibrary.getMovieClip("wep5");
			Main.scene.addChild(content);
			if(heroInfo.rotation<0) heroInfo.rotation+=360;
			content.x=heroInfo.x-Math.cos((heroInfo.rotation-90)*Math.PI/180)*4;
			content.y=heroInfo.y-Math.sin((heroInfo.rotation-90)*Math.PI/180)*4;
			content.rotation=heroInfo.rotation;
			content.gotoAndStop(2);
			this.changeAction=true;
			EnterFrame.addObject(this);
		}
		override public function onFrame():void
		{
		  if(isOn==false)
		  {
				for each (var h:Hero in Scene.sceneHeros)
				{
				  var dist:Number=MathUtil.getDistance(content.x,content.y,h.x,h.y);
				  if(dist<60){
					  		isOn=true;
						  content.play();
				  	}
				}
		  }
		  else
		  {
			  if(playSlow==true)
			  {
			     if(content.currentFrame==content.totalFrames)
				 {
					 content.gotoAndStop(1);
					 count++;
					 if(count>=3) playSlow=false;
					 setTimeout(content.play,700);
				 }
			  }
			  else
			  {
			  	content.play();
				setTimeout(this.bomb,1000);
				EnterFrame.removeObject(this);
			  }
		  }
		  
		}
		private function bomb():void
		{
			content.stop();
			this.currentPlanet.addHole(content.x,content.y,this.damageScopeStrength);
			if(content.parent) content.parent.removeChild(content);
		}
		
	}
}