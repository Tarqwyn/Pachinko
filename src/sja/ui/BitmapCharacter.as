package sja.ui 
{
	import flash.display.*;
	import flash.text.*;

	
	/**
	 * ...
	 * @author Steven Atherton ...
	 * 
	 * Utility class to take String of possible slotmachine reel and parse them into Bitmap data so that appropriate
	 * Tweening and blurring can be applied by the PachinkoslotMachine Class
	 * Any system or embeded font can be used including a custom Font
	 * 
	 * Adapted from code and an idea by Joakim Roos available @ http://www.deviouswork.com/2009/07/10/slotmachine-effect/
	 */

	
	public class BitmapCharacter extends Sprite
	{
	
	// Here we define the font we want to use..
	private var wingdingFont:Wingdings3 = new Wingdings3();
	// The currentdisplayed character as a bitmap representation
	private var _currentCharacterAsBitmap : Bitmap;
 
	public function BitmapCharacter(aCharacterRange:String, aSize:uint, aFont:Font = null):void {
		// Set the styles
		var format:TextFormat = new TextFormat();
		format.font = wingdingFont.fontName;
		if(aFont) {
			format.font = aFont.fontName;
			switch (aFont.fontStyle) {
				case FontStyle.BOLD:
					format.bold = true;
					break;
				case FontStyle.BOLD_ITALIC:
					format.bold = true;
					format.italic = true;
					break;
				case FontStyle.ITALIC:
					format.italic = true;
					break;
			}
		}
		format.size = aSize;
		format.color = 0x00ffff;
 
		// We nee a text field for the final character to be displayed in
		var reelCharacter:TextField = new TextField();
		reelCharacter.width = 1;
		reelCharacter.height = 1;
		reelCharacter.autoSize = TextFieldAutoSize.LEFT
		reelCharacter.selectable = false;
		reelCharacter.defaultTextFormat = format;
		if (aFont) reelCharacter.embedFonts = true;
		reelCharacter.filters = [GameConstants.NEON_BLUE];
		addChild(reelCharacter);
 
		// Run through all possible characters and make a bitmap give the a name with the suffix bmp_ and character (i,e bmp_x)
		var i : int = aCharacterRange.length;
		while(i--) {
			reelCharacter.text = aCharacterRange.charAt(i)+" ";
			var characterBitMapData:BitmapData = new BitmapData(reelCharacter.width, reelCharacter.height, true, 0x000000);
			var characterBitMapImage:Bitmap = new Bitmap(characterBitMapData, "auto", true);
			characterBitMapImage.name = "bmp_" + aCharacterRange.charAt(i);
			characterBitMapImage.visible = false;
			//add the bitmap version
			addChild(characterBitMapImage);
			characterBitMapData.draw(this);
		}
		// remove the font version
		removeChild(reelCharacter);
		reelCharacter = null;
	}
	
	//Setters and getters use by the Pachinko Slot machine class
		public function get currentCharacter():Bitmap{	
			return _currentCharacterAsBitmap; 
			}
			
		public function set currentCharacter(aInput_bitmap:Bitmap):void {
			_currentCharacterAsBitmap = aInput_bitmap; }
		}

}