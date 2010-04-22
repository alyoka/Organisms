package ch.forea.organisms {
	import ch.forea.dto.ColourDTO;
	import ch.forea.ui.UserInterface;
	import ch.forea.ui.event.InterfaceEvent;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * @author alyoka
	 */
	public class World extends Sprite {
		public static const WIDTH:Number = 300;		public static const HEIGHT:Number = 300;
		
		private var collisions:Dictionary;
		private var idCounter:uint;
		
		private var organismsContainer:Sprite;
		
		private var ui:UserInterface;
		
		
		public function World() {
			graphics.beginFill(0,.1);
			graphics.drawRect(0, 0, 300, 300);
			graphics.endFill();
			x = 10;
			y = 10;
			
			organismsContainer = addChild(new Sprite()) as Sprite;
			
			ui = new UserInterface();
			ui.addEventListener(InterfaceEvent.START, start);			ui.addEventListener(InterfaceEvent.STOP, stop);			ui.addEventListener(InterfaceEvent.PAUSE, pause);			ui.addEventListener(InterfaceEvent.RESUME, resume);
			addChild(ui);
		}
		
		private function start(e:InterfaceEvent):void{
			idCounter = 1;
			collisions = new Dictionary();
			var obj:DisplayObject;
			while(organismsContainer.numChildren > 0){
				obj = organismsContainer.removeChildAt(0);
				obj.removeEventListener(MouseEvent.MOUSE_OVER, showOrganismDetails);				obj.removeEventListener(MouseEvent.MOUSE_OUT, hideOrganismDetails);
			}
			var reds:uint = e.options.red;
			var blues:uint = e.options.blue;
			for(idCounter; idCounter<=reds; idCounter++){
				addOrganism(idCounter, 0xff0000, Math.random() * World.WIDTH, Math.random() * World.HEIGHT);
			}
			for(idCounter; idCounter<=reds+blues; idCounter++){
				addOrganism(idCounter, 0xff, Math.random() * World.WIDTH, Math.random() * World.HEIGHT);
			}
			ui.play();
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function stop(e:Event = null):void{
			removeEventListener(Event.ENTER_FRAME, update);
			ui.printStatistics();
			ui.stop();
		}
		
		private function pause(e:Event):void{
			removeEventListener(Event.ENTER_FRAME, update);
			ui.pause();
		}
		
		private function resume(e:Event):void{
			addEventListener(Event.ENTER_FRAME, update);
			ui.resume();
		}

		private function update(e:Event):void{
			var killed:Vector.<IOrganism> = checkCollision();
			var kills:uint = 0;
			if(killed.length) {
				kills = killed.length;
				cleanup(killed);
			}
			var colourDict:Dictionary = new Dictionary();
			for(var i:uint = 0; i<organismsContainer.numChildren; i++) {
				var o:IOrganism = organismsContainer.getChildAt(i) as IOrganism; 
				(colourDict[o.colour]) ? colourDict[o.colour] += 1 : colourDict[o.colour] = 1;
				o.move();
			}
			var colours:Array=[];
			for(var c:* in colourDict){
				colours.push(new ColourDTO(c, colourDict[c]));
			}
			ui.update(organismsContainer.numChildren,colours,kills);
			//XXX: stop if too many instances
			if(organismsContainer.numChildren == 200){
				stop();
			}
		}
		
		private function checkCollision():Vector.<IOrganism>{
			var killedOrganisms:Vector.<IOrganism> = new Vector.<IOrganism>();
			var killed:IOrganism;			var o1:IOrganism;
			var o2:IOrganism;
			for(var i:uint = 0; i<organismsContainer.numChildren-1; i++){
				o1 = organismsContainer.getChildAt(i) as IOrganism;				for(var k:uint = i+1; k<organismsContainer.numChildren; k++){
					//check distance between the two organisms
					o2 = organismsContainer.getChildAt(k) as IOrganism;
					var dx:Number = o1.x - o2.x;
					var dy:Number = o1.y - o2.y;
					//if they're close - collide
					if(Math.sqrt(dx*dx + dy*dy) <= (o1.width/2 + o2.width/2)){
						if(!collisions[o1.id] && !collisions[o2.id]){
							collisions[o1.id] = o2.id;
							collisions[o2.id] = o1.id;
							killed = collide(o1, o2);
							if(killed){
								killedOrganisms.push(killed);
							}
						}
					//if they're now far from each other but were colliding before - set them free
					}else if(collisions[o1.id]==o2.id && collisions[o2.id]==o1.id) {
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
					organismsContainer.removeChild(organism as DisplayObject);
				}catch(e:Error){
					throw e;
				}
			}
		}
		
		private function collide(organism1:IOrganism, organism2:IOrganism):IOrganism{
			var attracted1:int = organism1.meet(organism2);			var attracted2:int = organism2.meet(organism1);
			if(attracted1 < -3 && attracted2 < -3){
				//FIGHT
				var looser:IOrganism = (Math.round(Math.random()) == 0) ? organism1 : organism2;
				//cleanup collision for the survivor
				collisions[looser == organism1 ? organism2.id : organism1.id] = null;
				return looser;
			}else if(attracted1 > 7 || attracted2 > 7){
				//MATE
				addOrganism(idCounter++, mergeColours(organism1.colour, organism2.colour), organism1.x + 10 - Math.random() * 20, organism2.y + 10 - Math.random() * 20);
			}
			return null;
		}
		
		private function addOrganism(id:uint, colour:uint, xpos:Number, ypos:Number):void{
//			var o:IOrganism = new BasicOrganism(idCounter++, Math.round(Math.random()) == 1, colour));
			var o:IOrganism = new AdvancedWanderOrganism(id, Math.round(Math.random()) == 1, colour);
			o.x = xpos;
			o.y = ypos;
			o.draw();
			(o as DisplayObject).addEventListener(MouseEvent.MOUSE_OVER, showOrganismDetails);			(o as DisplayObject).addEventListener(MouseEvent.MOUSE_OUT, hideOrganismDetails);
			organismsContainer.addChild(o as DisplayObject);
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
		
		private function showOrganismDetails(me:MouseEvent):void{
			var organism:IOrganism = me.target as IOrganism;
			ui.showOrganismDetails(organism.x, organism.y, organism.id, organism.colour, organism.className, collisions[organism.id]);
		}
		
		private function hideOrganismDetails(me:MouseEvent):void{
			ui.hideOrganismDetails();
		}
	}
}
