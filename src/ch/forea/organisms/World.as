package ch.forea.organisms {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * @author alena
	 */
	public class World extends Sprite {
		public static const WIDTH:Number = 300;		public static const HEIGHT:Number = 300;
		
		private var organisms:Vector.<AbstractOrganism> = new Vector.<AbstractOrganism>();
		private var collisions:Dictionary = new Dictionary();
		private var idCounter:uint;
		
		//monitoring
		private var kills:uint;
		private var mates:uint;
		private	var start:Number;	
		
		public function World() {
			start = new Date().getTime();
			
			graphics.beginFill(0,.1);
			graphics.drawRect(0, 0, 300, 300);
			graphics.endFill();
			x = 10;
			y = 10;
			
		 	addEventListener(Event.ENTER_FRAME, checkCollision);
			
			var o:AbstractOrganism;
			for(idCounter = 0; idCounter<10; idCounter++){
				o = new AbstractOrganism(idCounter);
				organisms.push(o);
				addChild(o);
			}
		}
		
		private function checkCollision(e:Event):void{
			var o1:AbstractOrganism;			var o2:AbstractOrganism;
			for(var i:uint = 0; i<organisms.length-1; i++){
				o1 = organisms[i];				for(var k:uint = i+1; k<organisms.length; k++){
					o2 = organisms[k];
					if(o1.collides(o2)){
						if(!collisions[o1.id] && !collisions[o2.id]){
							collisions[o1.id] = o2.id;
							collisions[o2.id] = o1.id;
							collide(o1, o2);
						}
					}else if(collisions[o1.id]==o2.id || collisions[o2.id]==o1.id) {
						collisions[o1.id] = null;
						collisions[o2.id] = null;	
					}
				}
			}
		}
		
		public function collide(organism1:AbstractOrganism, organism2:AbstractOrganism):void{
			trace("Collision");
			var attracted1:int = organism1.meet(organism2);			var attracted2:int = organism2.meet(organism1);
			if(attracted1 < -3 && attracted2 < -3){
				var looser:AbstractOrganism;
				//FIGHT
				looser = (Math.round(Math.random()) == 0) ? organism1 : organism2;
				looser.die();
				collisions[organism1.id] = null;
				collisions[organism2.id] = null;
				removeChild(looser);
				organisms.splice(organisms.indexOf(looser),1);
				kills++;
				trace('kills: ' + (kills) + ', population: '+organisms.length + ", time: "+((new Date().getTime() - start)/1000));
			}else if(attracted1 > 7 || attracted2 > 7){
				//MATE
				mate(organism1, organism2);
			}
		}
		
		public function mate(organism1:AbstractOrganism, organism2:AbstractOrganism):void{
			trace("Love is in the air!");
			var o:AbstractOrganism = new AbstractOrganism(idCounter++);
			organisms.push(o);
			addChild(o);
			mates++;
			trace('mates: ' + (mates) + ', population: '+organisms.length + ", time: "+((new Date().getTime() - start)/1000));
		}
	}
}
