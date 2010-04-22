package ch.forea.ui.event {
	import flash.events.Event;
	
	/**
	 * @author alyoka
	 */
	public class InterfaceEvent extends Event {
		
		public static const START:String = "start";		public static const STOP:String = "stop";		public static const PAUSE:String = "pause";		public static const RESUME:String = "resume";
		
		public var options:Object;
		
		public function InterfaceEvent(type:String, options:Object = null) {
			this.options = options;
			super(type);
		}
		override public function clone():Event{
			return new InterfaceEvent(type, options);
		}
	}
}
