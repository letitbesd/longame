/*
Copyright 2009, Eric Smith. All rights reserved.
This work is subject to the terms in the software agreement that was issued with the Citrus Engine product.
*/
package com.longame.model.consts
{
	public class Registration
	{
		public static const TOP_LEFT:String = "topLeft";
		public static const CENTER:String = "center";
		
		public static function validate(type:String):void
		{
			if((type!=TOP_LEFT)&&(type!=CENTER))
				throw new Error("Invalidated registration type!");
		}
	}
}