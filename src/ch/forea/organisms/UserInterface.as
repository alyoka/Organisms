package ch.forea.organisms {
	import ch.forea.dto.ColourDTO;
	import ch.forea.event.InterfaceEvent;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author alyoka
	 */
	public class UserInterface extends Sprite {
		
		private var time:TextField;
		private var organisms:TextField;
		private var colours:TextField;
		private var toggleBtn:Sprite;
		
		private var dominantColour:ColourDTO;
		
		private var isRunning:Boolean = false;
		
		public function UserInterface() {
			toggleBtn = new Sprite();
			toggleBtn.graphics.lineStyle(.5);
			toggleBtn.graphics.beginFill(0xAAAAAA);
			toggleBtn.graphics.drawRoundRect(0, 0, 50, 25, 5);
			toggleBtn.graphics.endFill();
			toggleBtn.x = 320;
			toggleBtn.addChild(createTF(10,5,"Start"));
			toggleBtn.addEventListener(MouseEvent.CLICK, toggle);
			addChild(toggleBtn);	
			
			time = createTF(320,40,"Time:", true);
			addChild(time);
			timeValue = createTF(400,time.y,"0");
			addChild(timeValue);
			
			kills = createTF(320,time.y+16,"Kills:", true);
			killsValue = createTF(400,kills.y,"0");
			addChild(killsValue);
			
			mates = createTF(320,kills.y+16,"Mates:", true);
			addChild(mates);
			matesValue = createTF(400,mates.y,"0");
			addChild(matesValue);
			
			organisms = createTF(320,mates.y+16,"Organisms:", true);
			addChild(organisms);
			organismsValue = createTF(400,organisms.y,"");
			addChild(organismsValue);
			
			colours = createTF(320, organisms.y+20, "Colours", true);
			addChild(colours);
			coloursCount = createTF(360, colours.y, ":", true);
			addChild(coloursCount);
			coloursValue = createTF(320, colours.y+16,"");
			addChild(coloursValue);
			
			statistics = createTF(0,320,"Statistics:", true);
			addChild(statistics);
			statisticsValue = createTF(0,334);
			statisticsValue.selectable = true;
			statisticsValue.mouseEnabled = true;
			statisticsValue.mouseWheelEnabled = true;
			addChild(statisticsValue);
		}
		
		private function toggle(me:MouseEvent):void{
			if(isRunning){
				toggleBtn.removeChildAt(0);
				dispatchEvent(new InterfaceEvent(InterfaceEvent.STOP));
				toggleBtn.removeChildAt(0);
				dispatchEvent(new InterfaceEvent(InterfaceEvent.START));
			}
			isRunning = !isRunning;
		}

		private function createTF(x:Number, y:Number, text:String="", bold:Boolean = false, underline:Boolean = false):TextField{
			var tf:TextField = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.defaultTextFormat = new TextFormat("Arial", 10, null, bold, null, underline);
			tf.multiline = false;
			tf.width = 90;
			tf.height = 15;
			tf.x = x;
			tf.y = y;
			tf.text = text;
			tf.mouseEnabled = false;
			return tf;
		}
		
		public function printStatistics():void{
			statisticsValue.text = "Time: "+timeValue.text+",\t kills: "+killsValue.text+",\t mates: "+matesValue.text+",\t organisms: "+organismsValue.text + ",\t dominant: " + dominantColour.valueInHex + "(" + dominantColour.count + ")\n" + statisticsValue.text;
		}

		public function update(time:Number, organisms:uint, colours:Array, kills:uint = 0, mates:uint = 0):void{
			timeValue.text = Math.floor(time / 60) + " : "+Math.floor(time % 60);
			if(kills > 0) killsValue.text = String(kills);
			if(mates > 0) matesValue.text = String(mates);
			organismsValue.text = String(organisms);
			coloursValue.text = "";
			//format colours to format [colour value   - count]
			colours.sortOn("count", Array.NUMERIC | Array.DESCENDING);
			dominantColour = colours[0];
			for each(var c:ColourDTO in colours){
				coloursValue.appendText(c.valueInHex + "\t-  " + c.count + "\n");
			}
			coloursCount.text = "("+colours.length + "):";
		}
	}
}