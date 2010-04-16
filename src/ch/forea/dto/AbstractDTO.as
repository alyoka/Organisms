package ch.forea.dto {
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	public class AbstractDTO {
		private static const PATTERN : RegExp = /(.*)\:/;
		
		public function toString() : String {
			var objectString : String = getQualifiedClassName(this) + "(";
			var variables : XMLList = describeType(this)..variable;
			var variablesString : Array = new Array();
			for each (var child:XML in variables) {
				variablesString.push(child.@name + " = " + (child.@type == "Object" ? formatObject(this[child.@name]) : this[child.@name]));
			}
			
			var accessors:XMLList = describeType(this)..accessor;
			for each (child in accessors){
				if(child.@access.toString() != "writeonly"){
               		variablesString.push(child.@name + " = " + (child.@type == "Object" ? formatObject(this[child.@name]) : this[child.@name]));
				}
			}
            objectString += variablesString.join(", ");
            return objectString + ")";  
		}
		
		private function formatObject(object:Object):String{
			var varString:Array = new Array();
			for(var i:String in object){
				varString.push(i + ":" + object[i]);
			}
			return "{" + varString.join(", ") + "}";
		}
		
		/**
		 * Returns the class name for the DTO.
		 */
		public function getClassName() : String {
			return getQualifiedClassName(this).replace(PATTERN, "");
		}
	}
}
