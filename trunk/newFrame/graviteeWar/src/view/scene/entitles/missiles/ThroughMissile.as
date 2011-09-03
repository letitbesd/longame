package view.scene.entitles.missiles
{
	import com.collision.CDK;
	import com.collision.CollisionData;
	import com.longame.managers.AssetsLibrary;
	
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import view.scene.entitles.PathNode;
	import view.scene.entitles.Planet;

	/**
	 * 穿透星球的子弹
	 * */
	public class ThroughMissile extends MissileBase
	{
		private var throughSpeed:int=8;
		private var isThrough:Boolean;
		private var isFirstCircle:Boolean=true;
		public function ThroughMissile(path:Vector.<PathNode>, targetPlanet:Planet, id:int,scopeStrength:int)
		{
			super(path,targetPlanet,id,scopeStrength);
			this._scope=scopeStrength;
		}
		override protected function doWhenActive():void
		{
			super.doWhenActive();
//			isThrough = true;
		}
		
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
			
		}
		override public function destroy():void
		{
//			if(this.parent) this.parent.removeChild(this);
//			this.fire.destroy();
			
			if(_targetPlanet){
				isThrough=true;
			}
		}
		override protected  function doRender():void
		{
			super.doRender();
			if(isThrough==true)
			{
				var vx:Number=Math.cos(this.rotation*Math.PI/180)*throughSpeed;
				var vy:Number=Math.sin(this.rotation*Math.PI/180)*throughSpeed;
				if(isFirstCircle==true)
				{
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
			var circle:Shape=new Shape();
			circle.graphics.beginFill(0x4D4D4D,0.8)
			circle.graphics.drawCircle(this.x,this.y,7);
			circle.graphics.endFill();
			var cd:CollisionData=CDK.check(circle,this._targetPlanet.container);
			if(cd&&cd.overlapping.length>130){
				//问题 ：爆炸后星球表面的痕迹不能擦除 
				var p:Point=this._targetPlanet.container.globalToLocal(new Point(this.x,this.y));
				_targetPlanet.scene.container.addChild(circle);
//				circle.x=p.x;
//				circle.y=p.y
			}else
			{
				this._targetPlanet.addHole(this.x,this.y,this._scope);
				isThrough=false;
				super.destroy();
			}
			isFirstCircle=false;
			
		}
	}
}