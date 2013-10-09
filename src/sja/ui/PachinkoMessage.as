package sja.ui 
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	/**
	 * ...
	 * @author Steven Atherton
	 * 
	 * The game start overlay
	 * 
	 * Handles basic user imput via a couple of Simplebuttons
	 * May be better handled as a SWC component
	 *
	 */
	public class PachinkoMessage extends Sprite 
	{
		[Event(name = "gameStart1", type = "sja.ui.GameEvents")]
		[Event(name = "gameStart2", type = "sja.ui.GameEvents")]
		[Event(name = "gameStart3", type = "sja.ui.GameEvents")]
		
		[Embed(source = '/text/instructions.html',mimeType="application/octet-stream")]
		private var instructionsClass:Class;
		private var instructions:String = new instructionsClass();
		
		// variables
		private var font:DigitalReadoutUpright = new DigitalReadoutUpright();
		private var _title_text:TextFormat = new TextFormat();
		private var _title:TextField = new TextField;
		private var _body:TextField = new TextField;
		private var _style:StyleSheet = new StyleSheet();
		
	
		// draws the overlay window and sets up formatting
		public function PachinkoMessage(title:String) 
		{
			_style.setStyle("h1", { fontSize:'16' } );
			this.x = 50;
			this.y = 50;
			this.graphics.lineStyle(1,0x0000ff);
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0,0,GameConstants.WIDTH-100,GameConstants.HEIGHT-100);
			this.graphics.endFill();
			addText();
			setFormats();
			this.title = title;
			this._body.styleSheet = _style;
			this._body.htmlText = instructions;
			catchLevels();
		}
		
		// Set specific field formats
		private function setFormats():void {
			_title_text.font = font.fontName;
			_title_text.size =  48;
			_title_text.color = 0x00FFFF;
			_title.width = 300;
			_title.filters = [GameConstants.NEON_BLUE];
			_title.autoSize = TextFieldAutoSize.CENTER
			_title.y = 10;
			_title.selectable = false;
			_title.defaultTextFormat = _title_text;
			_title.embedFonts = true;
			_title.antiAliasType = AntiAliasType.ADVANCED;
			// Body
			_body.defaultTextFormat = GameConstants.BODY_TEXT;
			_body.width = 280;
			_body.multiline = true;
			_body.filters = [GameConstants.NEON_BLUE];
			_body.autoSize = TextFieldAutoSize.LEFT
			_body.wordWrap = true;
			_body.y = 60;
			_body.x = 10;
			_body.selectable = false;	
		}
		
		// add the textfields
		private function addText():void {
				this.addChild(_title);
				this.addChild(_body);
		}
		
		// draw the selection buttons 
		private function catchLevels():void {
			drawButton("1", "Easy", 10, 460);
			drawButton("2", "Medium", 105, 460);
			drawButton("3","Hard",200, 460);
			
		}
		
		// Draws our Simple buttons
		// Again this may be better served as part of a swc component
		private function drawButton(level:String,label:String,posX:Number,posY:Number):void {
		 var levelButton:SimpleButton = new SimpleButton();
		 levelButton.x = posX;
		 levelButton.y = posY;
		 levelButton.name = level;
		 var btnText1:TextField = new TextField();
		 btnText1.defaultTextFormat = GameConstants.BUTTON_TEXT;
		 btnText1.width = 90;
		 btnText1.text = label;
		 btnText1.autoSize = TextFieldAutoSize.CENTER;
		 btnText1.selectable = false;
		 btnText1.y = 5;
		 var btnText2:TextField = new TextField();
		 btnText2.defaultTextFormat = GameConstants.BUTTON_TEXT;
		 btnText2.width = 90;
		 btnText2.text = label;
		 btnText2.autoSize = TextFieldAutoSize.CENTER;
		 btnText2.selectable = false;
		  btnText2.y = 5;
		 var btnText3:TextField = new TextField();
		 btnText3.defaultTextFormat = GameConstants.BUTTON_TEXT;
		 btnText3.width = 90;
		 btnText3.text = label;
		 btnText3.autoSize = TextFieldAutoSize.CENTER;
		 btnText3.selectable = false;
		 btnText3.y = 5;
		 

		 var down:Sprite = new Sprite();
		 down.graphics.lineStyle(1, 0x000000);
		  down.graphics.beginFill(0xFFCC00);
		  down.graphics.drawRect(0, 0, 90, 30);

		  var up:Sprite = new Sprite();
		  up.graphics.lineStyle(1, 0x000000);
		  up.graphics.beginFill(0x0099FF);
		  up.graphics.drawRect(0, 0, 90, 30);

		  var over:Sprite = new Sprite();
		  over.graphics.lineStyle(1, 0x000000);
		  over.graphics.beginFill(0x9966FF);
		  over.graphics.drawRect(0, 0, 90, 30);

		 
		 levelButton.upState = up;
		 levelButton.overState = over;
		 levelButton.downState = down;
		 levelButton.useHandCursor = true;
		 levelButton.hitTestState = up;

		 up.addChild(btnText1);
		 down.addChild(btnText2);
		 over.addChild(btnText3);
		  
		 levelButton.name = level;
		 addChild(levelButton);
		 activateButton(levelButton);
		}
		
		private function activateButton(levelButton:SimpleButton):void {
			levelButton.addEventListener(MouseEvent.CLICK, displayMessage);
		}

		// dispatch a game start event back to main
		private function displayMessage(e:Event):void {
			switch(e.currentTarget.name) {
				case "1":
				dispatchEvent(new Event(GameEvents.GAME_START_1, true));
				break;	
				case "2":
				dispatchEvent(new Event(GameEvents.GAME_START_2, true));
				break;	
			case "3":
				dispatchEvent(new Event(GameEvents.GAME_START_3, true));
				break;
			default:
				dispatchEvent(new Event(GameEvents.GAME_START_1, true));
			}	
		}
		
		
		// Setter and Getters
		public function get title():String 
		{
			return _title.text;
		}
		
		public function set title(value:String):void 
		{
			_title.text = value;
			
		}
		
		public function get body():String 
		{
			return _body.text;
		}
		
		public function set body(value:String):void 
		{
			_body.text = value;
		}
		
	}

}