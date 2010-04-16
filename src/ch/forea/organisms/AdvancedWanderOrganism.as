package ch.forea.organisms {
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	/**
	 * @author alyoka
	 */
	public class AdvancedWanderOrganism extends Sprite implements IOrganism {
		
		private var _id:uint;
		private var _sex:Boolean;
		private var _colour:uint;
		
		//this dictionary will contain any implementation specific variables
		private var _variables:Dictionary = new Dictionary();
	    
		public function AdvancedWanderOrganism(id:uint, sex:Boolean, colour:uint){
			_id = id;
			_sex = sex;
			_colour = colour;
		}
		
		public function draw():void{
			graphics.beginFill(_colour);
			graphics.lineStyle(.5);
			if(_sex){
				graphics.drawRect(-5, -5, 10, 10);
			}else{
				graphics.drawCircle(0, 0, 5);
			}
			graphics.endFill();
		}
		
		public function move():void{
			if(!_variables["direction"]) _variables["direction"] = Math.random()*360;			if(!_variables["velocity"]) _variables["velocity"] = new Vector3D();			if(!_variables["acceleration"]) _variables["acceleration"] = new Vector3D();			if(!_variables["maxForce"]) _variables["maxForce"] = .1;			if(!_variables["maxSpeed"]) _variables["maxSpeed"] = 2;
			
			var location:Vector3D = new Vector3D(x,y);
			// Update velocity
	    	_variables["velocity"].incrementBy(_variables["acceleration"]);
	    	// Limit speed
	    	if(Math.sqrt(_variables["velocity"].x * _variables["velocity"].x + _variables["velocity"].y * _variables["velocity"].y) > _variables["maxSpeed"]){
				_variables["velocity"].normalize();
				_variables["velocity"].x *= _variables["maxSpeed"];
				_variables["velocity"].y *= _variables["maxSpeed"];
	      	}
	      	location.incrementBy(_variables["velocity"]);
	      	// Reset acceleration to 0 each cycle
	     	_variables["acceleration"].scaleBy(0);

			_variables["direction"] += Math.random() * .5 - .25; // randomly change our wander theta
			
			//
			//wander
			var wanderRadius:Number = 16; // Radius for our "wander circle"
			var wanderDistance:Number = 60; // Distance for our "wander circle"
	      
			// Now we have to calculate the new location to steer towards on the wander circle
			var circleLocation:Vector3D = _variables["velocity"].clone(); // Start with the velocity
			circleLocation.normalize(); // Normalize to get heading
			circleLocation.scaleBy(wanderDistance); //Multiply the distance
			circleLocation.incrementBy(location); // Make it relative to the organism's location
	      
			var circleOffset:Vector3D = new Vector3D(wanderRadius * Math.cos(_variables["direction"]), wanderRadius * Math.sin(_variables["direction"]));
			var target:Vector3D = circleLocation.clone().add(circleOffset);

			//check borders
			if(target.x < 20) target.x = 10;
			else if(target.x > World.WIDTH - 20) target.x = World.WIDTH - 10;
			if(target.y < 20) target.y = 10;
			else if(target.y > World.HEIGHT - 20) target.y = World.HEIGHT - 10;
			
			// Steer towards it
			var steer:Vector3D; // The steering vector
			var slowDown:Boolean = false;
			var desired:Vector3D = target.clone().subtract(location); // A vector pointing from the location to the target
			var distance:Number = Math.sqrt(desired.x * desired.x + desired.y * desired.y); // Distance from the target is the magnitude of the vector
			// If the distance is greater than 0, calculate steering (otherwise return 0 vector)
			if(distance > 0){
				// Normalize desired
				desired.normalize();
				// Two options for desired vector magnitude (1 -- based on distance, 2 -- maxspeed)
				if(slowDown && distance < 100) desired.scaleBy(_variables["maxSpeed"] * (distance / 100)); // This damping is somewhat arbitrary
				else desired.scaleBy(_variables["maxSpeed"]);
				// Steering = Desired - Velocity
				steer = desired.subtract(_variables["velocity"]);
				// Limit to maximum steering force
				if(Math.sqrt(steer.x * steer.x + steer.y * steer.y) > _variables["maxForce"]){
				steer.normalize();
				steer.scaleBy(_variables["maxForce"]);
				}
			}else{
				steer = new Vector3D();
		    }
			_variables["acceleration"].incrementBy(steer); 

			x = location.x;
			y = location.y;
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
