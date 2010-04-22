package ch.forea.ui.slider {
	import ch.forea.ui.event.SliderEvent;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * @author alyoka
	 */
	public class Slider extends Sprite {
		
		private var thumb:Sprite;
		private var minValue:uint;
		private var maxValue:uint;
		private var stepValue:uint;
		private var stepX:Number;
		
		private var minTF:TextField;
		private var maxTF:TextField;
		private var valTF:TextField;
		
		private var _value:uint = 0;
		 
		public function Slider(width:Number, minVal:uint, maxVal:uint, step:uint, defaultVal:int = -1, minTF:TextField = null, maxTF:TextField = null, valTF:TextField = null) {
			minValue = minVal;
			maxValue = maxVal;
			stepValue = step;
			stepX = step*width/(maxVal - minVal);

			thumb = new Sprite();
			thumb.graphics.beginFill(0x444444);
			thumb.graphics.drawRect(-3, -3, 6, 6);
			thumb.graphics.endFill();
			if(defaultVal >= 0){
				_value = defaultVal;
				thumb.x = valueToXpos(defaultVal);				
			}
			addChild(thumb);
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, drag);
			
			if(minTF){
				this.minTF = minTF;
				this.minTF.text = String(minVal);
				this.minTF.x = - this.minTF.width/2;
				this.minTF.y = 3;
				addChild(this.minTF);
			}
			
			if(maxTF){
				this.maxTF = maxTF;
				this.maxTF.text = String(maxVal);
				this.maxTF.x = width - this.maxTF.width/2;
				this.maxTF.y = 3;
				addChild(this.maxTF);
			}
			
			if(valTF){
				this.valTF = valTF;
				this.valTF.text = String(xposToValue(thumb.x));
				this.valTF.x = thumb.x - this.valTF.width/2;
				this.valTF.y = 3;
				addChild(this.valTF);
			}
			
			this.graphics.beginFill(0x999999);
			this.graphics.drawRect(0, 0, width, 1);
			this.graphics.endFill();
			
			this.graphics.lineStyle(.5);
			this.graphics.moveTo(0, -5);
			this.graphics.lineTo(0, 5);
			this.graphics.moveTo(width, -5);
			this.graphics.lineTo(width, 5);
			
			for(var i:uint = minVal+1; i<maxVal; i++){
				this.graphics.moveTo(valueToXpos(minVal+i), -2);
				this.graphics.lineTo(valueToXpos(minVal+i), 2);
			}
					}
		
		private function drag(me:MouseEvent):void{
			thumb.startDrag(true,new Rectangle(0,0,width,0));
			thumb.removeEventListener(MouseEvent.MOUSE_DOWN, drag);	
			this.addEventListener(MouseEvent.MOUSE_UP, release);
			this.addEventListener(MouseEvent.MOUSE_OUT, release);		}
		private function release(me:MouseEvent):void{
			thumb.stopDrag();
			_value = (xposToValue(thumb.x));
			thumb.x = valueToXpos(value);
			if(valTF){
				valTF.text = String(_value);
				valTF.x = thumb.x - this.valTF.width/2;
			}
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, drag);
			this.removeEventListener(MouseEvent.MOUSE_UP, release);
			this.removeEventListener(MouseEvent.MOUSE_OUT, release);
			dispatchEvent(new SliderEvent(SliderEvent.VALUE, value));
		}

		private function xposToValue(xpos:Number):uint{
			return Math.abs(xpos/stepX);
		}
		
		private function valueToXpos(value:uint):Number{
			return value * stepX;
		}
		
		public function get value():uint {
			return _value;
		}
	}
}
