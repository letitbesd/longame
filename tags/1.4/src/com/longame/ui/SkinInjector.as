package com.longame.ui
{
	import com.bumpslide.ui.skin.ISkinnable;
	import com.longame.core.IDisposable;
	import com.longame.utils.ObjectUtil;
	import com.longame.utils.Reflection;
	import com.longame.utils.debug.Logger;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import org.swiftsuspenders.Reflector;

	/**
	 * Inject a MovieClip as a skin to a target
	 * */
	public class SkinInjector implements IDisposable
	{
		/**
		 * The inject skin part meta name
		 * */
		public static const PART_META_NAME:String="Child";
		/**
		 * MovieClip source
		 * */
		private var _skin:MovieClip;
		/**
		 * The target to skin with the MovieClip
		 * */
		private var _target:DisplayObjectContainer;
		/**
		 * 以[Child(source="ch.ch1.item" state="normal")]为形式的元数据标签
		 * */
		protected var _skinMetas:Array;
		/**
		 * 解析成功的skinPar
		 * */
		protected var _skinParts:Dictionary=new Dictionary();
		//TODO
		protected var _data:*;
		//TODO
		protected var _state:String;
		
		private static const reflector:Reflector=new Reflector();
		
		/**
		 * @param target: The target to skin with the MovieClip
		 * @param skin: MovieClip source
		 * */
		public function SkinInjector(target:DisplayObjectContainer,skin:MovieClip=null)
		{
			this._target=target;
			//解析Skin标签
			_skinMetas=Reflection.getMetaInfos(this._target,PART_META_NAME);
			if(skin) this.inject(skin);
		}
		public function inject(skin:MovieClip):Boolean
		{
			if(skin==null){
				throw new Error("Skin MovieClip should'nt be null!");
			}
			if(this._skin){
				this.destroySkin();
			}
			this._skin=skin;
			this._skin.stop();
			this.parseSkin();
			return _skinMetas.length>0;
		}
		public function getSkinPart(name:String):DisplayObject
		{
			return _skinParts[name];
		}
		/**
		 * 根据MovieClip皮肤和Child标签信息来解析
		 *		[Child(source="mc1.mc2.okButton"]
		 * 		public var button:LabelButton;
		 * 上面表示一个LabelButton定义，source是skin里嵌套的原件，如上表示skin.mc1.mc2.okButton这个嵌套了3级的原件,它会作为button的skin，
		 *  如果不指定source,则自动在skin里寻找名位buton的MovieClip作为button的skin
		 *      [Child(source="mc1.labelTxt")]
		 * 		public var label:TextField;
		 * 上面表示将label指向skin.mc1.labelTxt这个文本框，当然还可以是任何flash的原生显示类，这样在程序里不用一个劲的点来点去的了
		 *      [Child(source="item",state="normal"]
		 * 		public var normalButton:LabelButton;
		 * 		[Child(source="item",state="locked"]
		 * 		public var lockedButton:LabelButton;
		 * 上面使用了标签的state属性，表示skin会有normal和locked两帧，每帧都放了一个可作为LabelButton皮肤的MC，名字都叫item，这样这个ui组件
		 * 就可以有normal和locked两种状态了,详见set state()
		 * 注意：
		 * 1. Child标签里可以设定任何组件所具有的属性，如下定义一个按钮，为选中状态，当定义属性的规则可见StringParser
		 * 	   [Child(selected="true")]
		 *     public var button:Button;
		 * 2. skinMc里需要转换成Component的，不要有动画，一定要有动画将其放置到空容器中，让空容器动；
		 * 3. 不要将要转成Component的对象和遮罩和一些图形放在以起，出了问题查这个
		 */
		private function parseSkin():void
		{
			//If the skin MovieClip has a parent and  is not in a Loader, we add the skin to the target and add the target to the skin's parent at the same level and same position
			if(this._skin.parent&&(!this.skinIsInLoader())){
				//将this添加到skinMC父亲的相应层级
				var index:int=this._skin.parent.getChildIndex(this._skin);
				this._skin.parent.addChildAt(this._target,index);
			}
			//然后将skinMC添加到this中，如此则skinMC保证了位置和层次的一致性
			this._target.addChildAt(_skin,0);
//			this._target.addChild(_skin);
			_skinParts=new Dictionary();
			var type:Class;
			for each(var skinInfo:* in _skinMetas){
				if(skinInfo.state){
					//如果有状态组件且不是当前状态的，忽略之
					if(_state!=skinInfo.state) continue;
				}
				//获取有source指定的原件做child的skin
				var childSkin:DisplayObject=this.getSkinChildSource(skinInfo);
				if(childSkin==null) {
				    Logger.warn(this,"parseSkin","No source with name: "+(skinInfo.source||skinInfo.varName)+" in skin!");
					continue;
				}
				//根据childSkin创建对于的child组件
				this.createSkinChild(skinInfo,childSkin);
				//可能的话，将data配置给对应状态的child
				if(_data&&skinInfo.state&&(_state==skinInfo.state)) _target[skinInfo.varName].data=_data;
			}
		}
		private function createSkinChild(skinInfo:*,childSkin:DisplayObject):void
		{
			var type:Class=getDefinitionByName(skinInfo.varClass) as Class;
			//如果skinPart和source是同一类型的元件，则直接赋值就可以了，否则视为ui元件，传入skinMC
			if(reflector.classExtendsOrImplements(type,ISkinnable)){
				var child:ISkinnable=new type() as ISkinnable;
				_target[skinInfo.varName]=child;
				//将name设为变量名
				(child as DisplayObject).name=skinInfo.varName;
				child.skin=childSkin;
			}else{
				_target[skinInfo.varName]=childSkin;
			}
			//解析可能的预定义属性,source和state几个属性除外
			ObjectUtil.cloneProperties(skinInfo,_target[skinInfo.varName],["source","state","skin","skinClass"]);
			_skinParts[skinInfo.varName]=_target[skinInfo.varName];
//			this.whenSkinChildCreated(_target[skinInfo.varName]);
//			Logger.info(this,"createSkinChild","Create skin child: "+skinInfo.varName);
		}
		/**
		 * 根据meta的source信息获取子元素的skin源
		 * */
		private function getSkinChildSource(skinInfo:*):DisplayObject
		{
			var sourcePath:String=skinInfo.source;
			//如果没有指定source属性，则取skinMC下同名的元件
			if(sourcePath==null) sourcePath=skinInfo.varName;
			//sourcePath允许多级嵌套，但其根目标是skinMC
			var sarr:Array=sourcePath.split(".");
			var len:int=sarr.length;
			var source:DisplayObject=this._skin;
			for(var i:int=0;i<len;i++){
				source=source[sarr[i]];
			}
			return source;
		}
		/**
		 * If the skin MovieClip is in a loader
		 * */
		private function skinIsInLoader():Boolean
		{
			//将loader排除，因为单独的swf加载后parent就是loader
			var p:DisplayObjectContainer=this._skin.parent;
			while(p){
				if(p is Loader){
					return true;
				}
				p=p.parent;
			}
			return false;
		}
		private function destroySkin():void
		{
			if(this._skin&&this._skin.parent) this._skin.parent.removeChild(this._skin);
			for each(var skinInfo:* in _skinMetas){
				if(_target[skinInfo.varName]==null) continue;
				if(_target[skinInfo.varName] is IDisposable) (_target[skinInfo.varName] as IDisposable).dispose();
				_target[skinInfo.varName]=null;
			}
			this._skin=null;
			this._skinParts=null;
		}
		final public function dispose():void
		{
			if(_disposed) return;
			_disposed=true;
			if(_skin){
				this.destroySkin();
				_skin=null;
			}
			_target=null;
			_skinMetas=null;
		}
		private var _disposed:Boolean;
		public function get disposed():Boolean
		{
			return _disposed;
		}
	}
}