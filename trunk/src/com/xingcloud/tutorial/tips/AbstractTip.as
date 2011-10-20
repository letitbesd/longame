package  com.xingcloud.tutorial.tips
{
	import com.xingcloud.tutorial.steps.TutorialStep;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Rectangle;

	public class AbstractTip implements ITutorialTip
	{
		protected var _owner:TutorialStep;
		private var _target:String;
		/**
		 * 是否明确指定了target，从step那里得到的不算
		 * */
		protected var _explicitTarget:Boolean;
		/**
		 * 用于放置显示元素的总容器，如气泡，遮罩
		 * */
		protected var _canvas:Sprite;
		/**
		 * 指定一个全局坐标系下的矩形范围，用于显示tip，
		 * 这个参数用于当target实在不好指定时，让开发者自己定义位置
		 * */
//		protected var _rect:Rectangle;
		
		public function AbstractTip()
		{
		}
		public function parseFromXML(xml:XML):void
		{
			_target=xml.@target;
			_explicitTarget=(_target && _target.length);
		}
		public function get target():DisplayObject
		{
			if(_explicitTarget){
				if(_owner.owner && _owner.owner.target){
					var t:DisplayObject=_owner.owner.target;
					var ts:Array=_target.split(".");
					for(var i:int=0;i<ts.length;i++){
						t=t[ts[i]];
					}
					return t;
//					return _owner.owner.target[_target] as DisplayObject;
				}
				return null;
			}
			return _owner.target;
		}
		final public function show():void
		{
			if(_canvas==null){
				_canvas=new Sprite();
				target.stage.addChild(_canvas);
//				_canvas.x=x;
//				_canvas.y=y;
			}
			this.doShow();
		}
		protected function doShow():void
		{
			//to do in subclass
		}
		
		final public function hide():void
		{
			if(_target==null) return;
			this.doHide();
			target.stage.removeChild(_canvas);
			_canvas=null;
			_target=null;
		}
		protected function doHide():void
		{
			//to do in subclass
		}
		public function get owner():TutorialStep
		{
			return _owner;
		}
		public function set owner(value:TutorialStep):void
		{
			_owner=value;
		}
	}
}