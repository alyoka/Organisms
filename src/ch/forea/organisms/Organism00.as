package ch.forea.organisms {

	/**
	 * @author alyoka
	 */
	public class Organism00 extends AbstractOrganism implements IOrganism {
		
		public function Organism00(id:uint, sex:Boolean, colour:uint){
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
			else if(x >= 300) _variables["direction"] = 180;
			else if(y <= 0) _variables["direction"] = 90;
			else if(y >= 300) _variables["direction"] = 270;

			_variables["direction"] += m/2 - .25;
			x += Math.cos(_variables["direction"]) * _variables["speed"];  
			y += Math.sin(_variables["direction"]) * _variables["speed"]; 
		}
	}
}
