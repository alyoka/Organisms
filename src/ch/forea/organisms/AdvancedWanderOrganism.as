package ch.forea.organisms {
	import flash.display.Sprite;
	import flash.geom.Vector3D;

	/**
	 * @author alyoka
	 */
	public class AdvancedWanderOrganism extends Sprite implements IOrganism {
		
		public var _sex:Boolean;
		
		private var _id:uint;
		private var _colour:uint;
		
		//wander
	    private var _velocity:Vector3D = new Vector3D();
	    private var _acceleration:Vector3D = new Vector3D();
	    private var _direction:Number;
	    
	    private const maxForce:Number = .1;
	    private const maxSpeed:Number = 2;
		
		public function AdvancedWanderOrganism(id:uint, colour:uint){
			//basic
			_id = id;
			_sex = Math.round(Math.random()) == 1;
			_colour = colour;
			
			//wander
			_direction = Math.random()*360;
		}
		
		public function draw():void{
			// Draw a triangle rotated in the direction of the velocity.  1.57079633 = 90 degrees in radians
			graphics.beginFill(_colour);
			if(_sex){
				graphics.drawRect(-5, -5, 10, 10);
			}else{
				graphics.drawCircle(0, 0, 5);
			}
			graphics.endFill();
		}
		
		public function move():void{
			var location:Vector3D = new Vector3D(x,y);
			// Update velocity
	    	_velocity.incrementBy(_acceleration);
	    	// Limit speed
	    	if(Math.sqrt(_velocity.x * _velocity.x + _velocity.y * _velocity.y + _velocity.z * _velocity.z) > maxSpeed){
				_velocity.normalize();
				_velocity.x *= maxSpeed;
				_velocity.y *= maxSpeed;
				_velocity.z *= maxSpeed;
	      	}
	      	location.incrementBy(_velocity);
	      	// Reset acceleration to 0 each cycle
	     	_acceleration.scaleBy(0);

			//
			//check borders
			if(location.x < 0) location.x = World.WIDTH;
			else if(location.x > World.WIDTH) location.x = 0; 
			if(location.y < 0) location.y = World.HEIGHT;
			else if(location.y > World.HEIGHT) location.y = 0;
			
			//
			//wander
			var wanderRadius:Number = 16; // Radius for our "wander circle"
			var wanderDistance:Number = 60; // Distance for our "wander circle"
			//var change:Number = .25;
			_direction += Math.random() * .5 - .25; // randomly change our wander theta
	      
			// Now we have to calculate the new location to steer towards on the wander circle
			var circleLocation:Vector3D = _velocity.clone(); // Start with the velocity
			circleLocation.normalize(); // Normalize to get heading
			circleLocation.scaleBy(wanderDistance); //Multiply the distance
			circleLocation.incrementBy(location); // Make it relative to the organism's location
	      
			var circleOffset:Vector3D = new Vector3D(wanderRadius * Math.cos(_direction), wanderRadius * Math.sin(_direction));
			var target:Vector3D = circleLocation.clone().add(circleOffset);
			_acceleration.incrementBy(steer(location, target, false)); // Steer towards it
	
			// Render wandering circle, etc.
			x = location.x;
			y = location.y;
		}
		
		public function collides(organism:IOrganism):Boolean{
			var dx:Number = x - organism.x;
			var dy:Number = y - organism.y;
			return Math.sqrt(dx*dx + dy*dy) <= (width/2 + organism.width/2);
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
		
	    private function steer(location:Vector3D, target:Vector3D, slowDown:Boolean):Vector3D{
			var steer:Vector3D; // The steering vector
			var desired:Vector3D = target.clone().subtract(location); // A vector pointing from the location to the target
			var distance:Number = Math.sqrt(desired.x * desired.x + desired.y * desired.y + desired.z * desired.z); // Distance from the target is the magnitude of the vector
			// If the distance is greater than 0, calculate steering (otherwise return 0 vector)
			if(distance > 0){
				// Normalize desired
				desired.normalize();
				// Two options for desired vector magnitude (1 -- based on distance, 2 -- maxspeed)
				if(slowDown && distance < 100) desired.scaleBy(maxSpeed * (distance / 100)); // This damping is somewhat arbitrary
				else desired.scaleBy(maxSpeed);
				// Steering = Desired - Velocity
				steer = desired.subtract(_velocity);
				// Limit to maximum steering force
				if(Math.sqrt(steer.x * steer.x + steer.y * steer.y + steer.z * steer.z) > maxForce){
				steer.normalize();
				steer.scaleBy(maxForce);
				}
			}else{
				steer = new Vector3D();
		    }
		    return steer;
		}
		
		public function get colour():uint {
			return _colour;
		}
	}
}
