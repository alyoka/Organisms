package ch.forea.organisms {
	import flash.utils.Dictionary;

	/**
	 * @author alyoka
	 */
	public interface IOrganism{
		//methods
		function draw():void;		function move():void;		function meet(organism:IOrganism):int;
		
		//getters
		function get id():uint;
		function get sex():Boolean;
		function get colour():uint;		function get className():String;
		function get variables():Dictionary;//contains any implementation specific variables
		
		//display object
		function set x(x:Number):void;		function get x():Number;		function set y(y:Number):void;		function get y():Number;		function set width(width:Number):void;		function get width():Number;		function set height(height:Number):void;		function get height():Number;
	}
}
