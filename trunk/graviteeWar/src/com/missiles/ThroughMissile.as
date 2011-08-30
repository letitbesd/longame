package com.missiles
{
	import collision.CDK;
	import collision.CollisionData;
	
	import com.PathNode;
	import com.Planet;
	import com.longame.managers.AssetsLibrary;
	import com.time.EnterFrame;
	
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class ThroughMissile extends MissileBase
	{
		private var throughSpeed:int=8;
		private var isThrough:Boolean;
		private var isFirstCircle:Boolean=true;
		public function ThroughMissile(path:Vector.<PathNode>, targetPlanet:Planet, id:int,scopeStrength:int)
		{
			super(path,targetPlanet,id,scopeStrength);
			this._scopeStrength=scopeStrength;
		}
		override public function destroy():void
		{
			if(_targetPlanet){
			isThrough=true;
			}
			if(this.parent) this.parent.removeChild(this);
			this.fire.destroy();
		}
		override public function onFrame():void
		{
			super.onFrame();
			if(isThrough==true){
				var vx:Number=Math.cos(this.rotation*Math.PI/180)*throughSpeed;
				var vy:Number=Math.sin(this.rotation*Math.PI/180)*throughSpeed;
				if(isFirstCircle==true){
					this.x+=vx*2.5;
					this.y+=vy*2.5;
				}
			  this.throughPlanet();
			  this.x+=vx;
			  this.y+=vy;
			}
		}
		private function throughPlanet():void
		{
			var p:Point=this._targetPlanet.backLayer.globalToLocal(new Point(this.x,this.y));
			var circle:Shape=new Shape();
			circle.graphics.beginFill(0x4D4D4D,1)
			circle.graphics.drawCircle(this.x,this.y,7);
			circle.graphics.endFill();
			var cd:CollisionData=CDK.check(circle,this._targetPlanet);
			if(cd&&cd.overlapping.length>130){
				Main.scene.midLayer.addChild(circle);
			}else
			{
				this._targetPlanet.addHole(this.x,this.y,this._scopeStrength);
				EnterFrame.removeObject(this);
				isThrough=false;
				var hole:MovieClip=AssetsLibrary.getMovieClip("hole");
				hole.x=this.x;
				hole.y=this.y;
				Main.scene.midLayer.blendMode=BlendMode.LAYER;
				Main.scene.midLayer.addChild(hole);
			}
			isFirstCircle=false;
			
		}
	}
}