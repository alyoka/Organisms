package ch.forea.organisms {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * @author alyoka
	 */
	public class World extends Sprite {
		public static const WIDTH:Number = 300;		public static const HEIGHT:Number = 300;
		
		private var organisms:Vector.<IOrganism> = new Vector.<IOrganism>();
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
			
		 	addEventListener(Event.ENTER_FRAME, update);
			
			var o:IOrganism;
			for(idCounter = 0; idCounter<10; idCounter++){
//				o = new BasicOrganism(idCounter, Math.round(Math.random()) == 1, (Math.round(Math.random()) == 1 ? 0xff : 0xff0000));
				o = new AdvancedWanderOrganism(idCounter, Math.round(Math.random()) == 1, (Math.round(Math.random()) == 1 ? 0xff : 0xff0000));
				o.x = Math.random() * World.WIDTH;
				o.y = Math.random() * World.HEIGHT;
				o.draw();
				organisms.push(o);
				addChild(o as DisplayObject);
			}
		}
		
		private function update(e:Event):void{
			var killed:Vector.<IOrganism> = checkCollision();
			if(killed.length) cleanup(killed);
			for each(var o:IOrganism in organisms){
				o.move();
			}
		}
		
		private function checkCollision():Vector.<IOrganism>{
			var killedOrganisms:Vector.<IOrganism> = new Vector.<IOrganism>();
			var killed:IOrganism;			var o1:IOrganism;
			var o2:IOrganism;
			for(var i:uint = 0; i<organisms.length-1; i++){
				o1 = organisms[i];				for(var k:uint = i+1; k<organisms.length; k++){
					//check distance between the two organisms
					o2 = organisms[k];
					var dx:Number = o1.x - o2.x;
					var dy:Number = o1.y - o2.y;
					if(Math.sqrt(dx*dx + dy*dy) <= (o1.width/2 + o2.width/2)){
						if(!collisions[o1.id] && !collisions[o2.id]){
							collisions[o1.id] = o2.id;
							collisions[o2.id] = o1.id;
							killed = collide(o1, o2);
							if(killed){
								killedOrganisms.push(killed);
							}
						}
					}else if(collisions[o1.id]==o2.id || collisions[o2.id]==o1.id) {
						collisions[o1.id] = null;
						collisions[o2.id] = null;	
					}
				}
			}
			return killedOrganisms;
		}
		
		private function cleanup(killed:Vector.<IOrganism>):void{
			for each(var organism:IOrganism in killed){
				collisions[organism.id] = null;
				delete collisions[organism.id];
				try{
					removeChild(organism as DisplayObject);
				}catch(e:Error){
					throw e;
				}
				organisms.splice(organisms.indexOf(organism),1);
			}
		}
		
		private function collide(organism1:IOrganism, organism2:IOrganism):IOrganism{
			trace("Collision");
			var attracted1:int = organism1.meet(organism2);			var attracted2:int = organism2.meet(organism1);
			if(attracted1 < -3 && attracted2 < -3){
				//FIGHT
				var looser:IOrganism = (Math.round(Math.random()) == 0) ? organism1 : organism2;
				kills++;
				trace('- mates: ' + (mates) + ', kills: ' + (kills) + ', population: '+(organisms.length-1) + ", time: "+((new Date().getTime() - start)/1000) + ", killed id: "+looser.id);
				//cleanup collision for the survivor
				collisions[looser == organism1 ? organism2.id : organism1.id] = null;
				return looser;
			}else if(attracted1 > 7 || attracted2 > 7){
				//MATE
				mate(organism1, organism2);
				trace('+ mates: ' + (mates) + ', kills: ' + (kills) + ', population: '+organisms.length + ", time: "+((new Date().getTime() - start)/1000));
			}
			return null;
		}
		
		public function mate(organism1:IOrganism, organism2:IOrganism):void{
//			var o:IOrganism = new BasicOrganism(idCounter++, Math.round(Math.random()) == 1, mergeColours(organism1.colour, organism2.colour));
			var o:IOrganism = new AdvancedWanderOrganism(idCounter++, Math.round(Math.random()) == 1, mergeColours(organism1.colour, organism2.colour));
			o.x = organism1.x + 10 - Math.random() * 20;
			o.y = organism2.y + 10 - Math.random() * 20;
			o.draw();
			organisms.push(o);
			addChild(o as DisplayObject);
			mates++;
		}
		
		private function mergeColours(c1:uint, c2:uint):uint{
			var	r1:uint = c1 >> 16;
			var g1:uint = (c1 >> 8) & 255;
			var b1:uint = c1 & 255;
			
			var	r2:uint = c2 >> 16;
			var g2:uint = (c2 >> 8) & 255;
			var b2:uint = c2 & 255;
			
			var r:uint = Math.min(r1,r2) + Math.abs(r1 - r2)/2;
			var g:uint = Math.min(g1,g2) + Math.abs(g1 - g2)/2;
			var b:uint = Math.min(b1,b2) + Math.abs(b1 - b2)/2;
			
			return (r<<16 | g<<8 | b);
		}
	}
}
