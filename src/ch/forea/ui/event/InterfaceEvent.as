package ch.forea.ui.event {
	import flash.events.Event;
	
	/**
	 * @author alyoka
	 */
	public class InterfaceEvent extends Event {
		
		public static const START:String = "start";
		
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