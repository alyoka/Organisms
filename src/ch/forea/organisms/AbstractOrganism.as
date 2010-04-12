package ch.forea.organisms {
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author alena
	 */
	public class AbstractOrganism extends Sprite {
		
		public var colour:uint;
		public var _sex:Boolean;
		
		private var _id:uint;
		
		//wander
		private var direction:Number;
		private var speed:Number;
		private var wanderAngle:Number;
		
		public function AbstractOrganism(id:uint){
			_id = id;
			
			_sex = Math.round(Math.random()) == 1;
			var c:uint = Math.random()*0xCC + 48;
			colour = _sex ? c << 4 : c << 16;
			
			graphics.beginFill(colour);
			graphics.drawCircle(0, 0, 5);
			graphics.endFill();
			
			x = Math.random() * World.WIDTH;			y = Math.random() * World.HEIGHT;
			direction = Math.random()*360;
			speed = Math.random()*2+.5;
			
			addEventListener(Event.ENTER_FRAME, wander);
		}
		
		protected function wander(e:Event = null):void{
			var m:Number = Math.random();
			if(x <= 0){
				direction = 0;
			}else if(x >= World.WIDTH) {
				direction = 180;
			}else if(y <= 0){
				direction = 90;
			}else if(y >= World.HEIGHT) {
				direction = 270;
			}
			wanderAngle = m/2 - .25;
			direction += wanderAngle;
			x += Math.cos(direction) * speed;  
			y += Math.sin(direction) * speed; 
		}
		
		public function collides(organism:AbstractOrganism):Boolean{
			var dx:Number = x - organism.x;
			var dy:Number = y - organism.y;
			return Math.sqrt(dx*dx + dy*dy) <= (width/2 + organism.width/2);
		}
		
		public function meet(organism:AbstractOrganism):int{
			if(sex == organism.sex){
				return -Math.round(Math.random()*10);
			}
			return Math.round(Math.random()*10);
		}
		
		public function die():void{
			trace("OH NO!!!");
			removeEventListener(Event.ENTER_FRAME, wander);
		}
		
		public function get id():uint {
			return _id;
		}
		
		public function get sex():Boolean {
			return _sex;
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
