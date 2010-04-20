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
		
		private var timeTF:TextField;		private var timeValue:TextField;		private var killsTF:TextField;		private var killsValue:TextField;		private var matesTF:TextField;		private var matesValue:TextField;
		private var organisms:TextField;		private var organismsValue:TextField;
		private var colours:TextField;		private var coloursCount:TextField;		private var coloursValue:TextField;		private var statistics:TextField;		private var statisticsValue:TextField;
		private var playStopBtn:Sprite;		private var pauseResumeBtn:Sprite;
		
		private var organismDetails:Sprite;
		
		private var dominantColour:ColourDTO;
		private var kills:uint = 0;		private var mates:uint = 0;
		private var organismsCount:uint = 0;
		private	var startTime:Number;		private	var pauseTime:Number = 0;		private	var pausedTime:Number = 0;
		
		private static const PLAYING:String = "playing";		private static const PAUSED:String = "paused";		private static const STOPPED:String = "stopped";
		
		private var state:String = "stopped";
		
		public function UserInterface() {
			playStopBtn = new Sprite();
			playStopBtn.graphics.lineStyle(.5);
			playStopBtn.graphics.beginFill(0xAAAAAA);
			playStopBtn.graphics.drawRoundRect(0, 0, 50, 25, 5);
			playStopBtn.graphics.endFill();
			playStopBtn.x = 320;
			playStopBtn.addChild(createTF(10,5,"Start"));
			playStopBtn.addEventListener(MouseEvent.CLICK, changeState);
			addChild(playStopBtn);	
			
			pauseResumeBtn = new Sprite();
			pauseResumeBtn.graphics.lineStyle(.5);
			pauseResumeBtn.graphics.beginFill(0xAAAAAA);
			pauseResumeBtn.graphics.drawRoundRect(0, 0, 50, 25, 5);
			pauseResumeBtn.graphics.endFill();
			pauseResumeBtn.x = 375;
			pauseResumeBtn.addChild(createTF(10,5,"Pause"));
			pauseResumeBtn.addEventListener(MouseEvent.CLICK, changeState);
			addChild(pauseResumeBtn);
			
			timeTF = createTF(320,40,"Time:", true);
			addChild(timeTF);
			timeValue = createTF(400,timeTF.y,"0");
			addChild(timeValue);
			
			killsTF = createTF(320,timeTF.y+16,"Kills:", true);			addChild(killsTF);
			killsValue = createTF(400,killsTF.y,"0");
			addChild(killsValue);
			
			matesTF = createTF(320,killsTF.y+16,"Mates:", true);
			addChild(matesTF);
			matesValue = createTF(400,matesTF.y,"0");
			addChild(matesValue);
			
			organisms = createTF(320,matesTF.y+16,"Organisms:", true);
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
			
			organismDetails = new Sprite();
			organismDetails.graphics.lineStyle(.5);
			organismDetails.graphics.beginFill(0xffffff);
			organismDetails.graphics.drawRect(0, 0, 200, 50);
			organismDetails.graphics.endFill();
			organismDetails.visible = false;
			addChild(organismDetails);			
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

		public function update(organisms:uint, colours:Array, kills:uint = 0):void{
			var time:Number = new Date().getTime() - startTime - pausedTime;
			timeValue.text = Math.floor(time / 60) + " : "+Math.floor(time % 60);
			//update mates, kills and organisms counts
			this.kills += kills;
			mates += organisms - organismsCount - kills;
			organismsCount = organisms;
			if(kills > 0) killsValue.text = String(this.kills);
			if(mates > 0) matesValue.text = String(mates);
			organismsValue.text = String(organismsCount);
			coloursValue.text = "";
			//format colours to format [colour value   - count]
			colours.sortOn("count", Array.NUMERIC | Array.DESCENDING);
			dominantColour = colours[0];
			for each(var c:ColourDTO in colours){
				coloursValue.appendText(c.valueInHex + "\t-  " + c.count + "\n");
			}
			coloursCount.text = "("+colours.length + "):";
		}
		
		public function showOrganismDetails(xpos:Number, ypos:Number, id:uint, colour:uint, className:String, collisions:uint):void{
			organismDetails.addChild(createTF(2,1,"ID:\t\t"+id));			organismDetails.addChild(createTF(2,13,"Class:\t\t"+className));			organismDetails.addChild(createTF(2,25,"Colour:\t"+ new ColourDTO(colour,0).valueInHex));			organismDetails.addChild(createTF(2,37,"Collisions:\t"+collisions));
			organismDetails.visible = true;
			organismDetails.x = xpos + 5;
			organismDetails.y = ypos + 5;
		}
		
		public function hideOrganismDetails():void{
			organismDetails.visible = false;
			while(organismDetails.numChildren > 0){
				organismDetails.removeChildAt(0);
			}
		}
		
		private function changeState(me:MouseEvent):void{
			switch(state){
				case PLAYING:
					if(me.target == playStopBtn){
						state = STOPPED;
						playStopBtn.removeChildAt(0);
						playStopBtn.addChild(createTF(10,5,"Start"));
						pauseResumeBtn.visible = false;
						dispatchEvent(new InterfaceEvent(InterfaceEvent.STOP));					}else{
						state = PAUSED;
						pausedTime += new Date().getTime() - pauseTime;
						pauseResumeBtn.removeChildAt(0);
						pauseResumeBtn.addChild(createTF(10,5,"Resume"));
						playStopBtn.visible = false;
						dispatchEvent(new InterfaceEvent(InterfaceEvent.PAUSE));
					}
				break;
				case STOPPED:
					state = PLAYING;
					startTime = new Date().getTime();					playStopBtn.removeChildAt(0);
					playStopBtn.addChild(createTF(12,5,"Stop"));
					pauseResumeBtn.visible = true;
					dispatchEvent(new InterfaceEvent(InterfaceEvent.START));
				break;
				case PAUSED:					state = PLAYING;
					pauseTime = new Date().getTime();
					pauseResumeBtn.removeChildAt(0);
					pauseResumeBtn.addChild(createTF(10,5,"Pause"));
					playStopBtn.visible = true;
					dispatchEvent(new InterfaceEvent(InterfaceEvent.RESUME));
				break;			}
		}
	}
}
