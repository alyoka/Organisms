package ch.forea.organisms {
	import flash.display.Sprite;

	/**
	 * @author alyoka
	 */
	public class BasicOrganism extends Sprite implements IOrganism {
		
		public var _sex:Boolean;
		
		private var _id:uint;
		private var _colour:uint;
		
		//wander
		private var _direction:Number;
		private var _speed:Number;
		
		public function BasicOrganism(id:uint, colour:uint){
			_id = id;
			_sex = Math.round(Math.random()) == 1;
			_colour = colour;
			_direction = Math.random()*360;
			_speed = Math.random()*2+.5;
		}
		
		public function draw():void{
			graphics.beginFill(_colour);
			if(_sex){
				graphics.drawRect(-5, -5, 10, 10);
			}else{
				graphics.drawCircle(0, 0, 5);
			}
			graphics.endFill();
		}
		
		public function move():void{
			var m:Number = Math.random();
			if(x <= 0){
				_direction = 0;
			}else if(x >= World.WIDTH) {
				_direction = 180;
			}else if(y <= 0){
				_direction = 90;
			}else if(y >= World.HEIGHT) {
				_direction = 270;
			}
			_direction += m/2 - .25;
			x += Math.cos(_direction) * _speed;  
			y += Math.sin(_direction) * _speed; 
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
		
//		public var age:uint;//lifecycle - 0 - 
//		
//		public var colour:uint;//		private var _colourImportance:Number;
//		
//		private var _maxAgressivness:Number;//inherited//		
//		private var _maxStrength:Number;//inherited, increases with each fight//		private var _currentStrength:Number;//lifecycle, decreases with each fight and recovers to _maxStrength after some time
//		
//		private var _timeSinceLastSex:Number;//lifecycle
	}
}
