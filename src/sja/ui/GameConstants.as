package sja.ui 
{
	import flash.filters.*;
	import flash.text.*;
	/**
	 * ...
	 * @author Steven Atherton
	 * 
	 * Contains all Game constants it may be possible make some of these public static vars and have them load via a config file, specifically it game is expanded 
	 * to include additional levels with different colour schemes..
	 */
	public class GameConstants 
	{
			public static const DIGITAL_FONT:DigitalReadoutUpright = new DigitalReadoutUpright();
			// Pachinko Message
			public static const MODAL_BLUR:BlurFilter = new BlurFilter(7, 7);
			public static const TITLE_TEXT:TextFormat = new TextFormat(DIGITAL_FONT.fontName, 48, 0x00FFFF);
			public static const SUB_TITLT:TextFormat = new TextFormat("arial", 14, 0x00FFFF);
			public static const BODY_TEXT:TextFormat = new TextFormat("arial", 10, 0x00FFFF);
			public static const BUTTON_TEXT:TextFormat = new TextFormat("arial", 16,0x000000,true);
			
			// Game Size
			
			public static const WIDTH:Number = 400;
			public static const HEIGHT:Number = 600;
			
		
			// Physics Models
			public static const GRAVITY:Number = 0.68;
			public static const FRICTION:Number = 1;
		
			
			// Effects
			public static const NEON_BLUE:GlowFilter = new GlowFilter(0x0000ff, 1, 5, 5, 4, 1, false);
			public static const NEON_LT_BLUE:GlowFilter = new GlowFilter(0x00ffff, 0.75, 30, 30, 2, 1);
			public static const NEON_LT_BLUE_B:DropShadowFilter = new DropShadowFilter(0,90,0x00fffff,30,30,2)
			public static const NEON_BLUE_INNER:GlowFilter = new GlowFilter(0x0000ff, 1, 2, 2, 4, 1, true);
			public static const NEON_LT_BLUE_INNER:GlowFilter = new GlowFilter(0x00ffff, 0.75, 20, 20, 2, 1,true);
			public static const NEON_RED:GlowFilter = new GlowFilter(0xff0066, 1, 20, 20, 3);
			public static const LABEL_TEXT:TextFormat = new TextFormat("arial", 10,0x00FFFF);
			
			//Scoreboard
			public static const SPEED:int = 25; // how fast to count
			public static const NUM_DIGITS:int = 7; // how many digits there are in the score
			public static const DISPLAY_TEXT:TextFormat = new TextFormat(DIGITAL_FONT.fontName, 16,0x00FFFF);
			
			//Launcher
			public static const LAUNCHER_HOLE:Number = 40; // 
			
			

	}

}