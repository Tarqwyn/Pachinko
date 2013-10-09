package sja.ui 
{
	import flash.geom.*;
	import flash.text.*;
	/**
	 * ...
	 * @author Steven Atherton
	 * 
	 * Use the PachinkoDisplay_model - see libs/fla
	 * 
	 * Just a simple 10 frame movie clip that increases a meter
	 * An example of using a swc to cut dome on code
	 * 
	 */
	public class PachinkoPowerMeter extends PachinkoPowerMeter_model 
	{
		
		private var font:DigitalReadoutUpright = new DigitalReadoutUpright();
		private var _label_text:TextFormat = new TextFormat();
		private var meterText:TextField = new TextField;
			
		public function PachinkoPowerMeter(pos:Point) 
		{
			// Add atext label
			this.x = pos.x;
			this.y = pos.y;
			_label_text.font = font.fontName;
			_label_text.size = 16;
			_label_text.color = 0x00FFFF;
			meterText.defaultTextFormat = _label_text;
			meterText.embedFonts = true;
			meterText.antiAliasType = AntiAliasType.ADVANCED;
			meterText.filters = [GameConstants.NEON_BLUE];
			meterText.text = "Power";
			meterText.x = 55;
			meterText.y = -5;
			meterText.selectable = false; 	
			addChild(meterText);
		}
		
	}

}