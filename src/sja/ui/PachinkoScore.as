package sja.ui
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import sja.ui.*;
	/**
	 * ...
	 * @author Steven Atherton
	 * 
	 * Adapted form an idea and tutorial by Cadin Batrack http://active.tutsplus.com/tutorials/effects/create-a-pinball-style-rolling-score-counter-class/
	 * Additional code added to handled increase counters that speed up and slow down based on difference between scores
	 * And to release events to the main game when point thresholds as passed as well as additional visual styles
	 * 
	 */
	public class PachinkoScore extends PachinkoScore_model
	{
		
		[Event(name = "bonusBalls", type = "sja.ui.GameEvents")]
		[Event(name = "releaseBalls", type = "sja.ui.GameEvents")]
				
		private var _totalScore:int = 0;
		private var _displayScore:int = 0;
		private var _accelerate:int = 1;
		private var _nextBonus:int = 100000;
		private var _releaseBonus:int = 500000;
		// Scoreboard constructor
		public function PachinkoScore(pos:Point =  null) 
		{
			super();
			this.x = pos.x;
			this.y = pos.y;
		}
		// Add an amount to the score
		public function add(amount:int):void {
			_totalScore += amount;
			addEventListener(Event.ENTER_FRAME, updateScoreDisplay); // start the display counting up
		}
		
		// this runs every frame to update the score
		private function updateScoreDisplay(e:Event):void {
			//Speed up and slow down
			if(_totalScore-_displayScore > 20000){_accelerate = 41}else if(_totalScore-_displayScore > 10000){_accelerate = 21}else if(_totalScore-_displayScore > 10000){_accelerate = 11} else if(_totalScore-_displayScore > 2000){_accelerate = 5}else{_accelerate = 1}
			// increment the display score by the speed amount
			_displayScore += GameConstants.SPEED*_accelerate;
			if(_displayScore > _totalScore){
				_displayScore = _totalScore;
			}
			var scoreStr:String = String(_displayScore); // cast displayScore as a String
			// add leading zeros
			while(scoreStr.length < GameConstants.NUM_DIGITS){
				scoreStr = "0" + scoreStr;
			}
			for (var i:int = 0; i < GameConstants.NUM_DIGITS; i++) {
				var num:Number = int(scoreStr.charAt(i));
				this["digit"+(i+1)].gotoAndStop(num+1);// set the digit mc to the right frame
			}
			
			// Dispatch threshold events
			if (_totalScore == _displayScore) {
				dispatchEvent(new Event(GameEvents.GAME_OVER,true));
				removeEventListener(Event.ENTER_FRAME, updateScoreDisplay);
			}
			
			if (_displayScore > _nextBonus) {
				dispatchEvent(new Event(GameEvents.BONUS_BALL, true));
				_nextBonus = _nextBonus * 2;
			}
			
			if (_displayScore > _releaseBonus) {
				dispatchEvent(new Event(GameEvents.RELEASE_BALLS, true));
				_releaseBonus = _releaseBonus * 2;
			}
		}
		
		// Setters and Getters
		public function get totalScore():int 
		{
			return _totalScore;

		}
		public function get displayScore():int 
		{
			return _displayScore;
		}
}


}