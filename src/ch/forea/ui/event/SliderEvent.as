package ch.forea.ui.event {
	import flash.events.Event;
	
	/**
	 * @author alyoka
	 */
	public class SliderEvent extends Event {
		
		public static const VALUE:String = "value";
		
		public var value:uint;
				public function SliderEvent(type:String, value:uint) {
			this.value = value;
			super(type);
		}
		override public function clone():Event{
			return new SliderEvent(type, value);
		}
	}
}
