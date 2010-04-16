package ch.forea.dto {

	/**
	 * @author alyoka
	 */
	public class ColourDTO extends AbstractDTO{
		public var value:uint;
		public var count:uint;
		
		public function ColourDTO(value:uint, count:uint){
			this.value = value;
			this.count = count;
		}
		
		public function get valueInHex():String{
			var hex:String = value.toString(16);
			var l:uint = hex.length;
			for(var i:uint = 0;i<6-l;i++){
				hex = "0"+hex;
			}
			return hex;
		}
	}
}
