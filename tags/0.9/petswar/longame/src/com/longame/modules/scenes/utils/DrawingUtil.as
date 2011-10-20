package com.longame.modules.scenes.utils
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import com.longame.display.core.IDisplayRenderer;
	import com.longame.modules.scenes.SceneManager;
	import com.longame.model.consts.AxisOrientation;

	/**
	 * DrawingUtil provides some convenience methods for drawing shapes in 3D isometric space.
	 */
	public class DrawingUtil
	{
		/* static public function drawIsoCircle (g:Graphics, originPt:Vector3D, radius:Number, plane:String = "xy"):void
		{
			switch (plane)
			{
				case AxisOrientation.YZ:
				{					
					break;
				}
				
				case AxisOrientation.XZ:
				{
					break;
				}
				
				case AxisOrientation.XY:
				default:
				{
					var ptX:Vector3D = SceneMath.isoToScreen(polarVector3d(originPt, radius, 135 * Math.PI / 180));
					var ptY:Vector3D = SceneMath.isoToScreen(polarVector3d(originPt, radius, 225 * Math.PI / 180));
					var ptW:Vector3D = SceneMath.isoToScreen(polarVector3d(originPt, radius, 315 * Math.PI / 180));
					var ptH:Vector3D = SceneMath.isoToScreen(polarVector3d(originPt, radius, 45 * Math.PI / 180));
					
					g.drawEllipse(Vector3DX.x, ptY.y, ptW.x - ptX.x, ptH.y - ptY.y);
				}
			}
		} */
		
		/**
		 * Draws a rectangle in 3D isometric space relative to a specific plane.
		 * 
		 * @param g The target graphics object performing the drawing tasks.
		 * @param originPt The origin pt where the specific drawing task originates.
		 * @param width The width of the rectangle. This is relative to the first orientation axis in the given plane.
		 * @param length The length of the rectangle. This is relative to the second orientation axis in the given plane.
		 * @param plane The plane of orientation to draw the rectangle on.
		 */
		static public function drawIsoRectangle (g:Graphics, originPt:Vector3D, width:Number, length:Number, plane:String = "xy"):void
		{
			var pt0:Vector3D = SceneManager.sceneToScreen(originPt, true);
			switch (plane)
			{
				case AxisOrientation.XZ:
				{
					var pt1:Vector3D = SceneManager.sceneToScreen(new Vector3D(originPt.x + width, originPt.y, originPt.z));
					var pt2:Vector3D = SceneManager.sceneToScreen(new Vector3D(originPt.x + width, originPt.y, originPt.z + length));
					var pt3:Vector3D = SceneManager.sceneToScreen(new Vector3D(originPt.x, originPt.y, originPt.z + length));
					break;
				}
				
				case AxisOrientation.YZ:
				{
					pt1 = SceneManager.sceneToScreen(new Vector3D(originPt.x, originPt.y + width, originPt.z));
					pt2 = SceneManager.sceneToScreen(new Vector3D(originPt.x, originPt.y + width, originPt.z + length));
					pt3 = SceneManager.sceneToScreen(new Vector3D(originPt.x, originPt.y, originPt.z + length));
					
					break;
				}
				
				case AxisOrientation.XY:
				default:
				{
					pt1 = SceneManager.sceneToScreen(new Vector3D(originPt.x + width, originPt.y, originPt.z));
					pt2 = SceneManager.sceneToScreen(new Vector3D(originPt.x + width, originPt.y + length, originPt.z));
					pt3 = SceneManager.sceneToScreen(new Vector3D(originPt.x, originPt.y + length, originPt.z));
				}
			}
			
			g.moveTo(pt0.x, pt0.y);
			g.lineTo(pt1.x, pt1.y);
			g.lineTo(pt2.x, pt2.y);
			g.lineTo(pt3.x, pt3.y);
			g.lineTo(pt0.x, pt0.y);
		}
		
		/**
		 * Draws an arrow in 3D isometric space relative to a specific plane.
		 * 
		 * @param g The target graphics object performing the drawing tasks.
		 * @param originPt The origin pt where the specific drawing task originates.
		 * @param degrees The angle of rotation in degrees perpendicular to the plane of orientation.
		 * @param length The length of the arrow.
		 * @param width The width of the arrow.
		 * @param plane The plane of orientation to draw the arrow on.
		 */
		static public function drawIsoArrow (g:Graphics, originPt:Vector3D, degrees:Number, length:Number = 27, width:Number = 6, plane:String = "xy"):void
		{			
			var pt0:Vector3D = new Vector3D();
			var pt1:Vector3D = new Vector3D();
			var pt2:Vector3D = new Vector3D();
			
			var toRadians:Number = Math.PI / 180;
			
			var ptR:Vector3D;
			
			switch (plane)
			{
				case AxisOrientation.XZ:
				{
					pt0 = polarVector3d(new Vector3D(0, 0, 0), length, degrees * toRadians)
					ptR = new Vector3D(pt0.x + originPt.x, pt0.z + originPt.y, pt0.y + originPt.z);
					pt0 = SceneManager.sceneToScreen(ptR);
					
					pt1 = polarVector3d(new Vector3D(0, 0, 0), width / 2, (degrees + 90) * toRadians)
					ptR = new Vector3D(pt1.x + originPt.x, pt1.z + originPt.y, pt1.y + originPt.z);
					pt1 = SceneManager.sceneToScreen(ptR);
					
					pt2 = polarVector3d(new Vector3D(0, 0, 0), width / 2, (degrees + 270) * toRadians)
					ptR = new Vector3D(pt2.x + originPt.x, pt2.z + originPt.y, pt2.y + originPt.z);
					pt2 = SceneManager.sceneToScreen(ptR);
					
					break;
				}
				
				case AxisOrientation.YZ:
				{
					pt0 = polarVector3d(new Vector3D(0, 0, 0), length, degrees * toRadians)
					ptR = new Vector3D(pt0.z + originPt.x, pt0.x + originPt.y, pt0.y + originPt.z);
					pt0 = SceneManager.sceneToScreen(ptR);
					
					pt1 = polarVector3d(new Vector3D(0, 0, 0), width / 2, (degrees + 90) * toRadians)
					ptR = new Vector3D(pt1.z + originPt.x, pt1.x + originPt.y, pt1.y + originPt.z);
					pt1 = SceneManager.sceneToScreen(ptR);
					
					pt2 = polarVector3d(new Vector3D(0, 0, 0), width / 2, (degrees + 270) * toRadians)
					ptR = new Vector3D(pt2.z + originPt.x, pt2.x + originPt.y, pt2.y + originPt.z);
					pt2 = SceneManager.sceneToScreen(ptR);
					
					break;
				}
				case AxisOrientation.XY:
				default:
				{
					pt0 = polarVector3d(originPt, length, degrees * toRadians)
					pt0 = SceneManager.sceneToScreen(pt0);
					
					pt1 = polarVector3d(originPt, width / 2, (degrees + 90) * toRadians)
					pt1 = SceneManager.sceneToScreen(pt1);
					
					pt2 = polarVector3d(originPt, width / 2, (degrees + 270) * toRadians)
					pt2 = SceneManager.sceneToScreen(pt2);
					
				}
			}
			
			g.moveTo(pt0.x, pt0.y);
			g.lineTo(pt1.x, pt1.y);
			g.lineTo(pt2.x, pt2.y);
			g.lineTo(pt0.x, pt0.y);
		}
		
		/**
		 * Creates a BitmapData object of the target IIsoDisplayObject.
		 * 
		 * @param target The target to retrieve the data from.
		 * 
		 * @return BitmapData A drawn bitmap data object of the target object.
		 */
		static public function getIsoBitmapData (target:IDisplayRenderer):BitmapData
		{
			target.render();
			//get the screen bounds and adjust matrix for negative rect values.
			var rect:Rectangle = target.container.getBounds(target.container);
			var bitmapdata:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
			bitmapdata.draw(target.container, new Matrix(1, 0, 0, 1, rect.x * -1, rect.y * -1));
			
			return bitmapdata;
		}
		
		/**
		 * Given a particular isometric orientation this method returns a matrix needed to project(skew) and image onto that plane.
		 * 
		 * @param orientation The isometric planar orientation.
		 * @return Matrix The matrix associated with the provided isometric orientation.
		 * 
		 * @see as3isolib.enum.AxisOrientation
		 */
		static public function getIsoMatrix (orientation:String):Matrix
		{
			var m:Matrix = new Matrix();
			
			switch (orientation)
			{
				case AxisOrientation.XY:
				{
					var m2:Matrix = new Matrix();
					m2.scale(1, 0.5);
					
					m.rotate(Math.PI / 4);
					m.scale(Math.SQRT2, Math.SQRT2);
					m.concat(m2);
					
					break;
				}
				
				case AxisOrientation.XZ:
				{
					m.b = Math.PI / 180 * 30;
					//m.b = Math.atan(0.5);
					break;
				}
				
				case AxisOrientation.YZ:
				{
					m.b = Math.PI / 180 * -30;
					//m.b = Math.atan(-0.5);
					break;
				}
				
				default:
				{
					//do nothing
				}
			}
			
			return m;
		}
		static public function polarVector3d (originPt:Vector3D, radius:Number, theta:Number = 0):Vector3D
		{
			var tx:Number = originPt.x + Math.cos(theta) * radius;
			var ty:Number = originPt.y + Math.sin(theta) * radius;
			var tz:Number = originPt.z
			
			return new Vector3D(tx, ty, tz);
		}
	}
}