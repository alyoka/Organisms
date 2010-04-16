package ch.forea.event {
	import flash.events.Event;
	
	/**
	 * @author alyoka
	 */
	public class InterfaceEvent extends Event {
		
		public static const START:String = "start";		public static const STOP:String = "stop";
		public function InterfaceEvent(type:String) {
			super(type);
		}
		override public function clone():Event{
			return new InterfaceEvent(type);
		}
	}
}
