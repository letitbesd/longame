package com.bumpslide.events {
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * Drag Event dispatched by the Bumpslide DragBehavior
	 * 
	 * @author David Knape
	 */
	public class DragEvent extends Event {

		public static var EVENT_DRAG_START:String = "bumpslideDragStart";
		
		// location of drag target when drag was started
		
		// current location of drag target relative to drag start
		
		// current location of drag target
		public var current:Point;
		
		// distance dragged on this move
		public var velocity:Point;
				
		public function DragEvent(type:String, sprite_start:Point, current_loc:Point, drag_velocity:Point=null) {
			super(type, true, true);
			start = sprite_start;
			current = current_loc!=null ? current_loc : start.clone();
			delta = current.subtract( start );
			velocity = drag_velocity;
		}
		
		
	}
}