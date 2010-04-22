package ch.forea.ui {
	import ch.forea.dto.ColourDTO;
	import ch.forea.ui.event.InterfaceEvent;
	import ch.forea.ui.event.SliderEvent;
	import ch.forea.ui.slider.Slider;

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
		
		//instantiation inputs
		private var blueOrganisms:TextField;		private var blueOrganismsValue:Slider;		private var redOrganisms:TextField;		private var redOrganismsValue:Slider;
		
		//monitoring
		private var dominantColour:ColourDTO;
		private var kills:uint = 0;		private var mates:int = 0;
		private var organismsCount:uint = 0;
		private	var startTime:Number;		private	var pauseTime:Number = 0;		private	var pausedTime:Number = 0;
		
		//states
		private static const PLAYING:String = "playing";
		private static const PAUSED:String = "paused";
		private static const STOPPED:String = "stopped";
		
		private var state:String = "stopped";
		
		public function UserInterface() {
			blueOrganisms = createTF(320,0,"Blue:", true);
			addChild(blueOrganisms);
			
			blueOrganismsValue = new Slider(100, 0, 10, 1, 5, createTF(), createTF(), createTF());
			blueOrganismsValue.x = 360;
			blueOrganismsValue.y = blueOrganisms.y+5;
			addChild(blueOrganismsValue);
			
			redOrganisms = createTF(320,blueOrganismsValue.y + 15,"Red:", true);
			addChild(redOrganisms);
			
			redOrganismsValue = new Slider(100, 0, 10, 1, 5, createTF(), createTF(), createTF());
			redOrganismsValue.x = 360;			redOrganismsValue.y = redOrganisms.y+5;
			addChild(redOrganismsValue);
			
			playStopBtn = new Sprite();
			playStopBtn.graphics.lineStyle(.5);
			playStopBtn.graphics.beginFill(0xAAAAAA);
			playStopBtn.graphics.drawRoundRect(0, 0, 50, 25, 5);
			playStopBtn.graphics.endFill();
			playStopBtn.x = 320;
			playStopBtn.y = redOrganismsValue.y + 20;
			playStopBtn.addChild(createTF(10,5,"Start"));
			playStopBtn.addEventListener(MouseEvent.CLICK, changeState);
			addChild(playStopBtn);	
			
			pauseResumeBtn = new Sprite();
			pauseResumeBtn.graphics.lineStyle(.5);
			pauseResumeBtn.graphics.beginFill(0xAAAAAA);
			pauseResumeBtn.graphics.drawRoundRect(0, 0, 50, 25, 5);
			pauseResumeBtn.graphics.endFill();
			pauseResumeBtn.x = 375;
			pauseResumeBtn.y = playStopBtn.y;
			pauseResumeBtn.addChild(createTF(10,5,"Pause"));
			pauseResumeBtn.addEventListener(MouseEvent.CLICK, changeState);
			addChild(pauseResumeBtn);
			
			timeTF = createTF(320,playStopBtn.y + 40,"Time:", true);
			addChild(timeTF);
			timeValue = createTF(400,timeTF.y,"0");
			addChild(timeValue);
						killsTF = createTF(320,timeTF.y+16,"Kills:", true);
			addChild(killsTF);
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

		private function reset():void{
			kills = 0;
			mates = 0;
			organismsCount = 0;
			startTime = new Date().getTime();
			pausedTime = 0;
			dominantColour = null;
		}
		
		private function createTF(x:Number=0, y:Number=0, text:String="", bold:Boolean = false, underline:Boolean = false):TextField{
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
			var time:Number = (new Date().getTime() - startTime - pausedTime)/1000;
			timeValue.text = Math.floor(time / 60) + " : "+Math.floor(time % 60);
			if(!organismsCount) organismsCount = organisms;
			//update mates, kills and organisms counts
			this.kills += kills;
			mates += (organisms - organismsCount + kills);
			matesValue.text = String(mates);
			organismsCount = organisms;
			killsValue.text = String(this.kills);
//			if(mates > 0) matesValue.text = String(mates);
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
		
		public function play():void{
			state = PLAYING;
			reset();
			playStopBtn.removeChildAt(0);
			playStopBtn.addChild(createTF(12,5,"Stop"));
			pauseResumeBtn.visible = true;
		}
		public function stop():void{
			state = STOPPED;
			playStopBtn.removeChildAt(0);
			playStopBtn.addChild(createTF(10,5,"Start"));
			pauseResumeBtn.visible = false;
		}
		public function pause():void{
			state = PAUSED;
			pauseTime = new Date().getTime();
			pauseResumeBtn.removeChildAt(0);
			pauseResumeBtn.addChild(createTF(10,5,"Resume"));
			playStopBtn.visible = false;
		}
		public function resume():void{
			state = PLAYING;
			pausedTime += new Date().getTime() - pauseTime;
			pauseResumeBtn.removeChildAt(0);
			pauseResumeBtn.addChild(createTF(10,5,"Pause"));
			playStopBtn.visible = true;
		}
		
		private function changeState(me:MouseEvent):void{
			switch(state){
				case PLAYING:
					if(me.target == playStopBtn){
						dispatchEvent(new InterfaceEvent(InterfaceEvent.STOP));					}else{
						dispatchEvent(new InterfaceEvent(InterfaceEvent.PAUSE));
					}
				break;
				case STOPPED:
					dispatchEvent(new InterfaceEvent(InterfaceEvent.START,{red:redOrganismsValue.value, blue:blueOrganismsValue.value}));
					break;
				case PAUSED:					dispatchEvent(new InterfaceEvent(InterfaceEvent.RESUME));
				break;			}
		}
	}
}
