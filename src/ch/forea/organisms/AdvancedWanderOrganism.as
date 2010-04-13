package ch.forea.organisms {
	import flash.display.Sprite;
	import flash.geom.Vector3D;

	/**
	 * @author alena
	 */
	public class AdvancedWanderOrganism extends Sprite implements IOrganism {
		
		public var _sex:Boolean;
		
		private var _id:uint;
		private var _colour:uint;
		
		//wander
		private var _location:Vector3D;
	    private var _velocity:Vector3D;
	    private var _acceleration:Vector3D;
	    private var _r:Number; // TODO: change to _radius
	    private var _wanderTheta:Number;
	    private var _maxForce:Number;
	    private var _maxSpeed:Number;
		
		public function AdvancedWanderOrganism(id:uint){
			//basic
			_id = id;
			_sex = Math.round(Math.random()) == 1;
			var c:uint = Math.random()*0xCC + 48;
			_colour = _sex ? c << 4 : c << 16;
			
			//advanced wander
			var location:Vector3D = new Vector3D(512, 384);
		    var maxSpeed:Number = 2;
		    var maxForce:Number = .1;
		
		    _acceleration = new Vector3D();
		    _velocity = new Vector3D();
		    _location = location.clone();
		    _r = 5;
		    _wanderTheta = 0;
		    _maxSpeed = maxSpeed;
		    _maxForce = maxForce;
		}
		
		public function draw():void{
			// Draw a triangle rotated in the direction of the velocity.  1.57079633 = 90 degrees in radians
			graphics.beginFill(_colour);
			graphics.drawCircle(0, 0, _r);
			graphics.endFill();
		}
		
		public function move():void{
//			graphics.clear();
		    wander();
		    update();
		    borders();
		    draw();
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
		
		// Method to update location
	    private function update():void{
	    	// Update velocity
	    	_velocity.incrementBy(_acceleration);
	    	// Limit speed
	    	if(Math.sqrt(_velocity.x * _velocity.x + _velocity.y * _velocity.y + _velocity.z * _velocity.z) > _maxSpeed){
				_velocity.normalize();
				_velocity.x *= _maxSpeed;
				_velocity.y *= _maxSpeed;
				_velocity.z *= _maxSpeed;
	      	}
	      	_location.incrementBy(_velocity);
	      	// Reset acceleration to 0 each cycle
	     	_acceleration.scaleBy(0);
	    }
	    
	    private function borders():void{
			if(_location.x < 0) _location.x = World.WIDTH;
			else if(_location.x > World.WIDTH) _location.x = 0; 
			if(_location.y < 0) _location.y = World.HEIGHT;
			else if(_location.y > World.HEIGHT) _location.y = 0;
	    }
	
	    private function wander():void{
			var wanderRadius:Number = 16; // Radius for our "wander circle"
			var wanderDistance:Number = 60; // Distance for our "wander circle"
			//var change:Number = .25;
			_wanderTheta += Math.random() * .5 - .25; // randomly change our wander theta
	      
			// Now we have to calculate the new location to steer towards on the wander circle
			var circleLocation:Vector3D = _velocity.clone(); // Start with the velocity
			circleLocation.normalize(); // Normalize to get heading
			circleLocation.scaleBy(wanderDistance); //Multiply the distance
			circleLocation.incrementBy(_location); // Make it relative to the organism's location
	      
			var circleOffset:Vector3D = new Vector3D(wanderRadius * Math.cos(_wanderTheta), wanderRadius * Math.sin(_wanderTheta));
			var target:Vector3D = circleLocation.clone().add(circleOffset);
			_acceleration.incrementBy(steer(target, false)); // Steer towards it
	
			// Render wandering circle, etc.
			x = _location.x;
			y = _location.y;
//			drawWanderStuff(_location, circleLocation, target, wanderRadius);
	    }
	
	    private function steer(target:Vector3D, slowDown:Boolean):Vector3D{
			var steer:Vector3D; // The steering vector
			var desired:Vector3D = target.clone().subtract(_location); // A vector pointing from the location to the target
			var distance:Number = Math.sqrt(desired.x * desired.x + desired.y * desired.y + desired.z * desired.z); // Distance from the target is the magnitude of the vector
			// If the distance is greater than 0, calculate steering (otherwise return 0 vector)
			if(distance > 0){
				// Normalize desired
				desired.normalize();
				// Two options for desired vector magnitude (1 -- based on distance, 2 -- maxspeed)
				if(slowDown && distance < 100) desired.scaleBy(_maxSpeed * (distance / 100)); // This damping is somewhat arbitrary
				else desired.scaleBy(_maxSpeed);
				// Steering = Desired - Velocity
				steer = desired.subtract(_velocity);
				// Limit to maximum steering force
				if(Math.sqrt(steer.x * steer.x + steer.y * steer.y + steer.z * steer.z) > _maxForce){
				steer.normalize();
				steer.scaleBy(_maxForce);
				}
			}else{
				steer = new Vector3D();
		    }
		    return steer;
		}
	    
//	    private function drawWanderStuff(location:Vector3D, circle:Vector3D, target:Vector3D, radius:Number):void{
//			graphics.lineStyle(1, 0);
//			graphics.drawCircle(circle.x, circle.y, radius);
//			graphics.drawCircle(target.x, target.y, 4);
//			graphics.moveTo(location.x, location.y);
//			graphics.lineTo(circle.x, circle.y);
//			graphics.lineTo(target.x, target.y);
//	    }
	}
}
