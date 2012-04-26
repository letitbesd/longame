package com.longame.managers
{
	import com.gskinner.motion.GTweener;
	import com.longame.resource.Resource;
	import com.longame.utils.debug.Logger;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The SoundManager is a singleton that allows you to have various ways to control sounds in your project.
	 * <p />
	 * The SoundManager can load external or library sounds, pause/mute/stop/control volume for one or more sounds at a time, 
	 * fade sounds up or down, and allows additional control to sounds not readily available through the default classes.
	 * <p />
	 * This class is dependent on TweenLite (http://www.tweenlite.com) to aid in easily fading the volume of the sound.
	 * 
	 * @author Matt Przybylski [http://www.reintroducing.com]
	 * @version 1.0
	 */
	public class SoundManager
	{
		//- PRIVATE & PROTECTED VARIABLES -------------------------------------------------------------------------
		
		private static var _soundsDict:Dictionary;
		private static var _sounds:Array;
		protected static var _soundOn:Boolean;
		
		//- PUBLIC & INTERNAL VARIABLES ---------------------------------------------------------------------------
		
		public function SoundManager() 
		{
		}
		private static var inited:Boolean;
		public static function init():void
		{
			if(inited) return;
			inited=true;
			_soundsDict = new Dictionary(true);
			_sounds = new Array();
			_soundOn=true;
		}
		
		//- PUBLIC & INTERNAL METHODS -----------------------------------------------------------------------------
		
		/**
		 * Adds a sound from the library to the sounds dictionary for playing in the future.
		 * 
		 * @param $linkageID The class name of the library symbol that was exported for AS
		 * @param $name The string identifier of the sound to be used when calling other methods on the sound
		 * 
		 * @return Boolean A boolean value representing if the sound was added successfully
		 */
		public static function addLibrarySound($linkageID:*, $name:String=""):Boolean
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				if (_sounds[i].name == $name) return false;
			}
			var snd:Sound;
			if($linkageID is String){
				var sCls:Class=getDefinitionByName($linkageID) as Class;
				if(sCls==null) return false;
				snd=new sCls() as Sound;
			}else if($linkageID is Class){
				snd=new $linkageID() as Sound;
			}else{
				throw new Error("sound must be String or Class...");
			}
			addSound(snd,$name);
			return true;
		}
		
		/**
		 * Adds an external sound to the sounds dictionary for playing in the future.
		 * 
		 * @param $path A string representing the path where the sound is on the server
		 * @param $name The string identifier of the sound to be used when calling other methods on the sound
		 * @param $buffer The number, in milliseconds, to buffer the sound before you can play it (default: 1000)
		 * @param $checkPolicyFile A boolean that determines whether Flash Player should try to download a cross-domain policy file from the loaded sound's server before beginning to load the sound (default: false) 
		 * 
		 * @return Boolean A boolean value representing if the sound was added successfully
		 */
		public static function addExternalSound($path:String, $name:String, $buffer:Number = 1000, $checkPolicyFile:Boolean = false):Boolean
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				if (_sounds[i].name == $name) return false;
			}
			$path=Resource.parseURL($path);
			try{
				var quest:URLRequest=new URLRequest($path);
				var context:SoundLoaderContext=new SoundLoaderContext($buffer,$checkPolicyFile);
				var snd:Sound = new Sound(quest,context);
			}catch(e:Error){
				Logger.error("SoundManager","addExternalSound",$path+" does not exist!");
				return false;
			}
			addSound(snd,$name);
			return true;
		}
		public static function addSound(snd:Sound,$name:String):void
		{
			var sndObj:Object = new Object();
			sndObj.name = $name;
			sndObj.sound = snd;
			sndObj.channel = new SoundChannel();
			sndObj.position = 0;
			sndObj.paused = true;
			sndObj.volume = 1;
			sndObj.startTime = 0;
			sndObj.loops = 0;
			sndObj.pausedByAll = false;
			
			_soundsDict[$name] = sndObj;
			_sounds.push(sndObj);
		}
		/**
		 * Removes a sound from the sound dictionary.  After calling this, the sound will not be available until it is re-added.
		 * 
		 * @param $name The string identifier of the sound to remove
		 * 
		 * @return void
		 */
		public static function removeSound($name:String):void
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				if (_sounds[i].name == $name)
				{
					_sounds[i] = null;
					_sounds.splice(i, 1);
				}
			}
			
			delete _soundsDict[$name];
		}
		
		/**
		 * Removes all sounds from the sound dictionary.
		 * 
		 * @return void
		 */
		public static function removeAllSounds():void
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				_sounds[i] = null;
			}
			
			_sounds = new Array();
			_soundsDict = new Dictionary(true);
		}
		
		/**
		 * Plays or resumes a sound from the sound dictionary with the specified name.
		 * 
		 * @param $name The string identifier of the sound to play
		 * @param $volume A number from 0 to 1 representing the volume at which to play the sound (default: 1)
		 * @param $startTime A number (in milliseconds) representing the time to start playing the sound at (default: 0)
		 * @param $loops An integer representing the number of times to loop the sound (default: 0)
		 * 
		 * @return void
		 */
		public static function playSound($name:String, $volume:Number = 1, $startTime:Number = 0, $loops:int = 0):Boolean
		{
			if(!soundOn) return false;
			var snd:Object = _soundsDict[$name];
			if(snd==null){
				addLibrarySound($name,$name);
				snd = _soundsDict[$name];
			}
			if(snd==null){
				throw new Error("Sound with "+$name+" does not exist!");
			}
			snd.volume = $volume;
			snd.startTime = $startTime;
			snd.loops = $loops;
			//todo
			if(snd.channel) stopSound($name);
			if (snd.paused)
			{
				if(snd.position>=snd.sound.length){
					snd.position=0;
				}
				snd.channel = snd.sound.play(snd.position,snd.loops, new SoundTransform(snd.volume));
			}
			else
			{
				snd.channel = snd.sound.play($startTime, snd.loops, new SoundTransform(snd.volume));
			}
			snd.paused = false;
			return true;
		}
		
		/**
		 * Stops the specified sound.
		 * 
		 * @param $name The string identifier of the sound
		 * 
		 * @return void
		 */
		public static function stopSound($name:String):void
		{
			var snd:Object = _soundsDict[$name];
			if(snd.channel!=null){
				snd.channel.stop();	
				snd.paused = true;	
			}
			snd.position=0;
		}
		
		/**
		 * Pauses the specified sound.
		 * 
		 * @param $name The string identifier of the sound
		 * 
		 * @return void
		 */
		public static function pauseSound($name:String):void
		{
			var snd:Object = _soundsDict[$name];
			var pos:Number=0;
			if(snd.channel!=null){
				pos = snd.channel.position;
				snd.channel.stop();
				snd.paused = true;				
			}
			snd.position=pos;

		}

		/**
		 * Plays all the sounds that are in the sound dictionary.
		 * 
		 * @param $useCurrentlyPlayingOnly A boolean that only plays the sounds which were currently playing before a pauseAllSounds() or stopAllSounds() call (default: false)
		 * 
		 * @return void
		 */
		public static function playAllSounds($useCurrentlyPlayingOnly:Boolean = false):void
		{
			if(!soundOn) return;
			for (var i:int = 0; i < _sounds.length; i++)
			{
				var sndObj:Object=_sounds[i];
				var id:String =sndObj.name;
				
				if ($useCurrentlyPlayingOnly)
				{
					if (sndObj.pausedByAll)
					{
						sndObj.pausedByAll = false;
						if(!soundCompleted(id)) playSound(id);
					}
				}
				else
				{
					if(!soundCompleted(id)) playSound(id);
				}
			}
		}
		
		/**
		 * Stops all the sounds that are in the sound dictionary.
		 * 
		 * @param $useCurrentlyPlayingOnly A boolean that only stops the sounds which are currently playing (default: true)
		 * 
		 * @return void
		 */
		public static function stopAllSounds($useCurrentlyPlayingOnly:Boolean = true):void
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				var id:String = _sounds[i].name;
				
				if ($useCurrentlyPlayingOnly)
				{
					if (!_soundsDict[id].paused)
					{
						_soundsDict[id].pausedByAll = true;
						stopSound(id);
					}
				}
				else
				{
					stopSound(id);
				}
			}
		}
		
		/**
		 * Pauses all the sounds that are in the sound dictionary.
		 * 
		 * @param $useCurrentlyPlayingOnly A boolean that only pauses the sounds which are currently playing (default: true)
		 * 
		 * @return void
		 */
		public static function pauseAllSounds($useCurrentlyPlayingOnly:Boolean = true):void
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				var id:String = _sounds[i].name;
				
				if ($useCurrentlyPlayingOnly)
				{
					if (!_soundsDict[id].paused)
					{
						_soundsDict[id].pausedByAll = true;
						pauseSound(id);
					}
				}
				else
				{
					pauseSound(id);
				}
			}
		}
		
		/**
		 * Fades the sound to the specified volume over the specified amount of time.
		 * 
		 * @param $name The string identifier of the sound
		 * @param $targVolume The target volume to fade to, between 0 and 1 (default: 0)
		 * @param $fadeLength The time to fade over, in seconds (default: 1)
		 * 
		 * @return void
		 */
		public static function fadeSound($name:String, $targVolume:Number = 0, $fadeLength:Number = 1):void
		{
			var fadeChannel:SoundChannel = _soundsDict[$name].channel;
			//TweenLite.to(fadeChannel, $fadeLength, {volume: $targVolume});
			GTweener.to(fadeChannel,$fadeLength,{volume:$targVolume});
		}
		
		/**
		 * Mutes the volume for all sounds in the sound dictionary.
		 * 
		 * @return void
		 */
		public static function muteAllSounds():void
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				var id:String = _sounds[i].name;
				
				setSoundVolume(id, 0);
			}
		}
		
		/**
		 * Resets the volume to their original setting for all sounds in the sound dictionary.
		 * 
		 * @return void
		 */
		public static function unmuteAllSounds():void
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				var id:String = _sounds[i].name;
				var snd:Object = _soundsDict[id];
				var curTransform:SoundTransform = snd.channel.soundTransform;
				curTransform.volume = snd.volume;
				snd.channel.soundTransform = curTransform;
			}
		}
		
		/**
		 * Sets the volume of the specified sound.
		 * 
		 * @param $name The string identifier of the sound
		 * @param $volume The volume, between 0 and 1, to set the sound to
		 * 
		 * @return void
		 */
		public static function setSoundVolume($name:String, $volume:Number):void
		{
			var snd:Object = _soundsDict[$name];
			var curTransform:SoundTransform = snd.channel.soundTransform;
			curTransform.volume = $volume;
			snd.channel.soundTransform = curTransform;
		}
		
		/**
		 * Gets the volume of the specified sound.
		 * 
		 * @param $name The string identifier of the sound
		 * 
		 * @return Number The current volume of the sound
		 */
		public static function getSoundVolume($name:String):Number
		{
			return _soundsDict[$name].channel.soundTransform.volume;
		}
		
		/**
		 * Gets the position of the specified sound.
		 * 
		 * @param $name The string identifier of the sound
		 * 
		 * @return Number The current position of the sound, in milliseconds
		 */
		public static function getSoundPosition($name:String):Number
		{
			return _soundsDict[$name].channel.position;
		}
		
		/**
		 * Gets the duration of the specified sound.
		 * 
		 * @param $name The string identifier of the sound
		 * 
		 * @return Number The length of the sound, in milliseconds
		 */
		public static function getSoundDuration($name:String):Number
		{
			return _soundsDict[$name].sound.length;
		}
		
		/**
		 * Gets the sound object of the specified sound.
		 * 
		 * @param $name The string identifier of the sound
		 * 
		 * @return Sound The sound object
		 */
		public static function getSoundObject($name:String):Sound
		{
			return _soundsDict[$name].sound;
		}
		
		/**
		 * Identifies if the sound is paused or not.
		 * 
		 * @param $name The string identifier of the sound
		 * 
		 * @return Boolean The boolean value of paused or not paused
		 */
		public static function isSoundPaused($name:String):Boolean
		{
			return _soundsDict[$name].paused;
		}
		
		/**
		 * Identifies if the sound was paused or stopped by calling the stopAllSounds() or pauseAllSounds() methods.
		 * 
		 * @param $name The string identifier of the sound
		 * 
		 * @return Number The boolean value of pausedByAll or not pausedByAll
		 */
		public static function isSoundPausedByAll($name:String):Boolean
		{
			return _soundsDict[$name].pausedByAll;
		}
		
		//- EVENT HANDLERS ----------------------------------------------------------------------------------------
		
		
		
		//- GETTERS & SETTERS -------------------------------------------------------------------------------------
		
		public static function get sounds():Array
		{
			return _sounds;
		}
		public static function get soundOn():Boolean
		{
			return _soundOn;
		}
		public static function set soundOn(s:Boolean):void
		{
			if(_soundOn==s) return;
			_soundOn=s;
			s?playAllSounds():pauseAllSounds();			
		}		
		public static function soundCompleted(name:String):Boolean
		{
			var sndObj:Object=_soundsDict[name];
			var ch:SoundChannel=sndObj.channel;
			if(ch==null) return false;
			var total:Number=sndObj.sound.length*sndObj.loops;
			return (ch.position>=total);
		}
		//- END CLASS ---------------------------------------------------------------------------------------------
	}
}