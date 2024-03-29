package com.longame.utils
{
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	/** 
	* DeployUtil is used check if your SWF runs locally or on a certzainhost.
	*   
	* @author Rien Verbrugghe
	* @mail rien.verbrugghe@nascom.be
	* 
	*/
	
	public class DeployUtil
	{
		protected static function get DOMAIN():String
		{
			var localConnection:LocalConnection = new LocalConnection();
			var domain:String = localConnection.domain;
			localConnection = null;
			return domain;
		}

		/**
		 * doesUrlContain checks if the URL of the HTML page where the SWF is hosted contains a specific value.
		 * Handy to activate a testing/debug state for live applications which have been deployed already.
		 */
		public static function doesUrlContain(value:String):Boolean
		{
			var result:Boolean = false;
			var pageURL:String = ExternalInterface.call('window.location.href.toString');
			
			if(pageURL.indexOf(value)!=-1)
				result = true;
				
			return result;
		}
		/**
		 * isHostedOn us used to check if your SWF is run from the host you specified in the search string.
		 * 
		 * @param domain The string you want to search on if it's present in the location string where you SWF is hosted on.
		 */
		public static function isHostedOn(domain:String="www.nascom.be"):Boolean
		{
			//compare with or without possible "www."
			return (DOMAIN == domain || DOMAIN == domain.substr(4,domain.length));
		}
		
		/**
		 * isLocal us used to check if your SWF is run from your local filesystem or from a server environment.
		 * 
		 **/ 
		public static function get isLocal():Boolean 
		{
			//ds: 'remote' (Security.REMOTE) — This file is from an Internet URL and operates under domain-based sandbox rules.
			return Security.sandboxType != Security.REMOTE;
		}
		
		/**
		 * isInBrowser checks if the flash is run from the browser.
		 * 
		 **/ 
		public static function get isInBrowser():Boolean 
		{
			return (Capabilities.playerType == "PlugIn" || Capabilities.playerType == "ActiveX");
		}
		
		/**
		 * isInAIR checks if the flash is run from an AIR runtime environment.
		 * 
		 **/
		public static function get isInAIR():Boolean 
		{
			return Capabilities.playerType == "Desktop";
		}
		
		/**
		 * isFlashvarSet to check if certain flashvar has been set
		 * 
		 * @param swf Your root swf
		 * @param flashvarName The name of your flashvar you wish to check
		 */ 
		public static function isFlashvarSet(swf:Sprite, flashvarName:String):Boolean
		{
			var result:Boolean = false;
			if(swf.hasOwnProperty("loaderInfo"))
			{
				if(swf.loaderInfo.parameters.hasOwnProperty(flashvarName) && swf.loaderInfo.parameters[flashvarName]!="" && swf.loaderInfo.parameters[flashvarName]!="undefined" && swf.loaderInfo.parameters[flashvarName]!=null && swf.loaderInfo.parameters[flashvarName]!=undefined)
					result = true;
			}else{
				throw new Error(swf+" does not contain any flashvars.");
			}
			return result;
		}
		
		/**
		 * getSwfPath is used to return the folder where the SWF is hosted.
		 * 
		 * @param root The root of your SWF.
		 */
		public static function getSwfPath(root:Sprite):String
		{
			var uri:String = root.loaderInfo.loaderURL;
			return uri.substring(0, uri.lastIndexOf("/")) + "/";
		}

		public static function setNascomContextMenu(root:Sprite, version:String):void
		{
			if(root.hasOwnProperty("contextMenu"))
			{
				var contextMenu:ContextMenu = new ContextMenu();
				contextMenu.hideBuiltInItems();
				var contextMenuItemVersion:ContextMenuItem = new ContextMenuItem("Application version: " + version);
				contextMenuItemVersion.enabled = false;
				var contextMenuItemCopyright:ContextMenuItem = new ContextMenuItem("Copyright © " + new Date().fullYear + " Nascom - All Rights Reserved");
				contextMenuItemCopyright.separatorBefore = true;
				contextMenuItemCopyright.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, openNascomLink);
				contextMenu.customItems.push(contextMenuItemVersion,contextMenuItemCopyright);
				root.contextMenu = contextMenu;
			}else{
				throw new Error("The root parameter you passed to the setNascomContextMenu function has no contextMenu property.");
			}
		}
		
		protected static function openNascomLink(event:ContextMenuEvent):void
		{
			navigateToURL(new URLRequest("http://www.nascom.be"),"_blank");
		}
	}
}