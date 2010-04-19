package ch.forea.organisms {
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**
	 * @author alyoka
	 */
	public class AbstractOrganism extends Sprite implements IOrganism {
		
		private var _id:uint;
		private var _sex:Boolean;
		private var _colour:uint;
		
		//this dictionary will contain any implementation specific variables
		protected var _variables:Dictionary = new Dictionary();
		
		public function AbstractOrganism(id:uint, sex:Boolean, colour:uint){
			_id = id;
			_sex = sex;
			_colour = colour;
		}
		
		public function draw():void{
		}
		
		public function move():void{
		}
		
		public function meet(organism:IOrganism):int{
			if(sex == organism.sex){
				return -Math.round(Math.random()*10);
			}
			return Math.round(Math.random()*10);
		}
		
		public function get id():uint {
			return _id;
		}
		
		public function get sex():Boolean {
			return _sex;
		}
		
		public function get colour():uint {
			return _colour;
		}
		
		public function get variables():Dictionary {
			return _variables;
		}
	}
}
