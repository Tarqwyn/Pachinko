package sja.ui 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Steven Atherton
	 * 
	 * Custom Pachinko Game Events...
	 * 
	 * Easier than keeping track of calls between objects
	 */
	public class GameEvents extends Event 
	{
		public static const GAME_START_1:String = "gameStart1";
		public static const GAME_START_2:String = "gameStart2";
		public static const GAME_START_3:String = "gameStart3";
		public static const RESTART:String = "reStart";
		public static const GAME_OVER:String = "gameOver";
		public static const SPIN_SLOT:String = "spinSlotMachine";
		public static const SPIN_COMPLETE:String = "spinComplete";
		public static const SPIN_WIN:String = "spinIsWinner";
		public static const STOP_REEL:String = "stopReel";
		public static const DOWN_HOLE:String = "downHole";
		public static const ADD_POINT:String = "addPoint";
		public static const ADD_POINTS:String = "addPoints";
		public static const BALL_ON_BALL:String = "ballOnBall";
		public static const BALL_ON_PIN:String = "ballOnPin";
		public static const BALL_ON_WALL:String = "ballOnWall";
		public static const LAUNCHER_START:String = "launcherStart";
		public static const LAUNCHER_STOP:String = "launcherStop";
		public static const PIPE_ANIMATION:String = "pipeAnimation";
		public static const AUTO_BALL:String = "autoBall";
		public static const CHARGE:String = "charge";
		public static const SAVE_BALL:String = "saveBall";
		public static const BONUS_BALL:String = "bonusBalls";
		public static const RELEASE_BALLS:String = "releaseBalls"
				
		
		public function GameEvents(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new GameEvents(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("GameEvents", "type", "bubbles", "cancelable", "eventPhase"); 
		}

	}
	
}