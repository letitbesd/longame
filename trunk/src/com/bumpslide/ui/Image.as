/**
 * This code is part of the Bumpslide Library maintained by David Knape
 * Fork me at http://github.com/tkdave/bumpslide_as3
 * 
 * Copyright (c) 2010 by Bumpslide, Inc. 
 * http://www.bumpslide.com/
 *
 * This code is released under the open-source MIT license.
 * See LICENSE.txt for full license terms.
 * More info at http://www.opensource.org/licenses/mit-license.php
 */
		public var priority:uint = 1;
		

			_status=null;
			_loadingQueue=null;
			_attachment=null;
			_constructorArgs=null;
			_loaderRequest=null;
			loaderContext=null;
					bitmap.pixelSnapping = PixelSnapping.NEVER;

			ImageUtil.reset(image);
			_nativeSize = ImageUtil.getSize(image);
				unload();
			}