package sja.ui 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	
	/**
	 * ...
	 * @author Steven Atherton
	 * 
	 * A simple class that keeps track of the umber of balls available to the player
	 * 
	 * As well as the number of Saved balls released via an Autoball event
	 * 
	 * once balls reach zero it dispatched the game Over event for main to interprate if all gameOver states are met..
	 */
	public class PachinkoBallCounter extends Sprite{
	
	[Event(name = "gameOver", type = "sja.ui.GameEvents")]
		
		// Variables
		private var _noOfBalls:Number;
		private var _noOfSavedBalls:Number;
		private var _ballText:TextField = new TextField;
		private var font:DigitalReadoutUpright = new DigitalReadoutUpright();
		private var _label_text:TextFormat = new TextFormat();

		
		public function PachinkoBallCounter(noBalls:Number = 20, savedBalls:Number =0,pos:Point = null) 
		{
			this.x = pos.x;
			this.y = pos.y;
	
			// the Readout
			_label_text.font = font.fontName;
			_label_text.size = 16;
			_label_text.color = 0x00FFFF;
			_ballText.defaultTextFormat = _label_text;
			_ballText.embedFonts = true;
			_ballText.antiAliasType = AntiAliasType.ADVANCED;
			_ballText.filters = [GameConstants.NEON_BLUE];
			_ballText.selectable = false; 
			_noOfBalls = noBalls;
			_noOfSavedBalls = savedBalls;
			_ballText.text = "Balls: "+noOfBalls.toString();
			addChild(_ballText);
		}
		
		// Setters and getters
		public function get noOfBalls():Number 
		{
			return _noOfBalls;
		}
		
		public function set noOfBalls(value:Number):void 
		{
			_noOfBalls = value;
			_ballText.text = "Balls: " + _noOfBalls.toString();
			
			if (_noOfBalls < 0) {
				dispatchEvent(new Event(GameEvents.GAME_OVER,true));
			}
		}
		
		public function get noOfSavedBalls():Number 
		{
			return _noOfSavedBalls;
		}
		
		public function set noOfSavedBalls(value:Number):void 
		{
			
			_noOfSavedBalls = value;
		}
		
		public function set ballText(value:String):void 
		{
			_ballText.text = value;
		}	
	}

}