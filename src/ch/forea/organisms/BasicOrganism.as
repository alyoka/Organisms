package ch.forea.organisms {
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author alena
	 */
	public class BasicOrganism extends Sprite implements IOrganism {
		
		public var _sex:Boolean;
		
		private var _id:uint;
		private var _colour:uint;
		
		//wander
		private var _direction:Number;
		private var _speed:Number;
		private var _wanderAngle:Number;
		
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
			_wanderAngle = m/2 - .25;
			_direction += _wanderAngle;
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
//		
//		public function get colourImportance():Number{
//			return _colourImportance / age;	
//		}
//		
//		public function meetMale(organism:AbstractOrganism):int{
//			return 0;
//		}
//		
//		public function meetFemale(organism:AbstractOrganism):int{
//			return 0;
//		}
//		
//		public function get agressivness():Number{
//			return _maxAgressivness * strength / age;
//		}
//		
//		//increases between age 0 - 10, stays at max until 30 and then decreases until death 
//		public function get strength():Number{
//			return _currentStrength * age;
//		}
//		
//		//@returns colour difference (0 - 255)
//		protected function compareColours(colour:uint):Number{
//			var	r1:uint = this.colour >> 16;
//			var g1:uint = (this.colour >> 8) & 255;//			var b1:uint = this.colour & 255;
//			
//			var	r2:uint = colour >> 16;
//			var g2:uint = (colour >> 8) & 255;
//			var b2:uint = colour & 255;
//			
//			var dr:uint = Math.abs(r1 - r2);//			var dg:uint = Math.abs(g1 - g2);//			var db:uint = Math.abs(b1 - b2);
//			
//			return (dr + dg + db) / 3;
//		}
		
	}
}
