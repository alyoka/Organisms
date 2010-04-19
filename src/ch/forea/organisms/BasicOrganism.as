package ch.forea.organisms {

	/**
	 * @author alyoka
	 */
	public class BasicOrganism extends AbstractOrganism implements IOrganism {
		
//		private var _id:uint;
//		private var _sex:Boolean;
//		private var _colour:uint;
//		
//		//this dictionary will contain any implementation specific variables
//		private var _variables:Dictionary = new Dictionary();
		
		public function BasicOrganism(id:uint, sex:Boolean, colour:uint){
//			_id = id;
//			_sex = sex;
//			_colour = colour;
			super(id,sex,colour);
		}
		
		override public function draw():void{
			graphics.beginFill(colour);
			if(sex){
				graphics.drawRect(-5, -5, 10, 10);
			}else{
				graphics.drawCircle(0, 0, 5);
			}
			graphics.endFill();
		}
		
		override public function move():void{
			if(!_variables["direction"]) _variables["direction"] = Math.random()*360;
			if(!_variables["speed"]) _variables["speed"] = Math.random()*2+.5;
			
			var m:Number = Math.random();
			if(x <= 0) _variables["direction"] = 0;
			else if(x >= World.WIDTH) _variables["direction"] = 180;
			else if(y <= 0) _variables["direction"] = 90;
			else if(y >= World.HEIGHT) _variables["direction"] = 270;

			_variables["direction"] += m/2 - .25;
			x += Math.cos(_variables["direction"]) * _variables["speed"];  
			y += Math.sin(_variables["direction"]) * _variables["speed"]; 
		}
		
//		public function meet(organism:IOrganism):int{
//			if(sex == organism.sex){
//				return -Math.round(Math.random()*10);
//			}
//			return Math.round(Math.random()*10);
//		}
//		
//		public function get id():uint {
//			return _id;
//		}
//		
//		public function get sex():Boolean {
//			return _sex;
//		}
//		
//		public function get colour():uint {
//			return _colour;
//		}
//		
//		public function get variables():Dictionary {
//			return _variables;
//		}
	}
}
