package sja.ui 
{
	import flash.geom.Point;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Steven Atherton
	 * 
	 * Use the PachinkoDisplay_model - see libs/fla
	 * 
	 * Takes a string argument places each character in the appropriate digital readout fiels
	 */
	public class PachinkoDisplay extends PachinkoDisplay_model 
	{
		private var _currentDisplay:String;

		public function PachinkoDisplay(pos:Point) 
		{
			this.x = pos.x;
			this.y = pos.y;
			super();		
		}
		
		public function get currentDisplay():String 
		{
			return _currentDisplay;
		}
		
		// this could do with a little more intelligence and error trapping
		// Such as autospacing and handeling Strings greater that 8 characters somehow without crashing the game..
		public function set currentDisplay(value:String):void {
			_currentDisplay = value;		
			for (var s:uint = 0; s < _currentDisplay.length;  s++) {
				this["text" + (s)].myText.text = _currentDisplay.charAt(s)
			} 
            }  
		
	}

}