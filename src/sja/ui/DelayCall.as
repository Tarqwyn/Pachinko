package sja.ui 
{
	import flash.events.*;
	import flash.utils.*;
	/**
	 * ...
	 * @author Steven Atherton
	 * 
	 * A Utility call to handle delayed calls, quickly developed and probably needs a bit of work to be more robust, but useful for handeling
	 * game events which are not Frame specific, such the Reel stop noise on the Pachinko slot machine..
	 */
	public class DelayCall 
	{
		private	var delayTimerEvent:TimerEvent;
		private	var delayedFunction:Function;
		private	var delayTimer:Timer;
		
		// May be beter as a static function, but was a bit flakey in practice.. needs work to get it to be more robust
		public function DelayCall() {
			
		}
		
		public function call(call:Function, delay:Number):void
		{	
			this.delayedFunction = call;
			delayTimer = new Timer(delay, 1);
			delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, callFunction);
			delayTimer.start();
		}
		
		private function callFunction(event:TimerEvent):void {
			delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, callFunction);
			delayedFunction();
		}
	}
}