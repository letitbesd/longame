/*
 * hexagonlib - Multi-Purpose ActionScript 3 Library.
 *       __    __
 *    __/  \__/  \__    __
 *   /  \__/HEXAGON \__/  \
 *   \__/  \__/  LIBRARY _/
 *            \__/  \__/
 *
 * Licensed under the MIT License
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package com.longame.utils.env
{
	import flash.display.DisplayObject;
	
	
	/**
	 * Returns the full path of the location that the SWF is stored in which is identified
	 * by the specified display object. If location is <code>null</code>,
	 * StageReference.stage is used by default.
	 * 
	 * @param location DisplayObject to get the full path of.
	 * @return The full path of the DisplayObject's location.
	 * 
	 * @example
	 * <pre>
	 *     trace(getPath(stage)); // http://www.yourdomain.com/flash/test/
	 * </pre>
	 */
	public function getPath(location:DisplayObject = null):String
	{
		if (!location) location = Engine.nativeStage;
		var s:String = location.loaderInfo.url;
		return s.substr(0, s.lastIndexOf("/") + 1);
	}
}
