package com.longame.commands.tween
{
	import com.longame.commands.base.Command;
	import com.gskinner.motion.GTween;
	
	public class TweenAction extends Command
	{
		protected var _tweener:GTween;
		public function TweenAction(g:GTween,delay:uint=0)
		{
			this._tweener=g;
			this.paused=true;
			super(delay);
		}
		override protected function doExecute():void
		{
			super.doExecute();
			this.paused=false;
			_tweener.onComplete=this.onTweenOver;
		}
		override public function set  paused(v:Boolean):void
		{
			if(this._paused==v) return;
			_paused=v;
			_tweener.paused=v;
		}
		protected function onTweenOver(g:GTween):void
		{
			this.complete();
		}
		public function get tweener():GTween
		{
			return _tweener;
		}
	}
}