package sja.ui 
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	
	/**
	 * ...
	 * @author Steven Atherton
	 * 
	 * Handles high score display and user request to quit and restart
	 * 
	 * Its a bit mess and needs a bit of refactoring to make the code more elegant and understanab;e
	 */
	public class PachinkoHighScore extends Sprite 
	{
		
		[Event(name = "restart", type = "sja.ui.GameEvents")]
		
		// the game credits as an object
		[Embed(source = '/text/credits.html',mimeType="application/octet-stream")]
		
		// Variables
		private var creditsClass:Class;
		private var creditText:String = new creditsClass();	
		private var font:DigitalReadoutUpright = new DigitalReadoutUpright();
		private var _title_text:TextFormat = new TextFormat();
		private var _score_text:TextFormat = new TextFormat();	
		private var _title:TextField = new TextField;
		private var _credits:TextField = new TextField;
		private var _style:StyleSheet = new StyleSheet();
		private var score:String;
		private var loader:URLLoader;
		private var table:Sprite;
		private var inputField:TextField = new TextField();
		private var yourScore:TextField =  new TextField();
		private var levelButton:SimpleButton;
	
		
		public function PachinkoHighScore(title:String,thisScore:String) 
		{
			getScores();
			// assign the total end game score
			score = thisScore;
			// Set global styles and draw the overlay window
			_style.setStyle("h1", { fontSize:'16' } );
			this._credits.defaultTextFormat = GameConstants.BODY_TEXT;
			this._credits.styleSheet = _style;
			this._credits.htmlText = creditText;
			this.x = 50;
			this.y = 50;
			this.graphics.lineStyle(1,0x0000ff);
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0,0,GameConstants.WIDTH-100,GameConstants.HEIGHT-100);
			this.graphics.endFill();
			addText();
			setFormats();
			this.title = title;
			catchPlayer();
		}
		
		// Set specific field formats
		private function setFormats():void {
			_title_text.font = font.fontName;
			_title_text.size =  48;
			_title_text.color = 0x00FFFF;
			_score_text.font = font.fontName;
			_score_text.size =  32;
			_score_text.color = 0x00FFFF;
			_title.width = 300;
			_title.filters = [GameConstants.NEON_BLUE];
			_title.autoSize = TextFieldAutoSize.CENTER
			_title.y = 10;
			_title.selectable = false;
			_title.defaultTextFormat = _title_text;
			_title.embedFonts = true;
			_title.antiAliasType = AntiAliasType.ADVANCED;	
		}
		
		// Render the High Score Table
		// This is a bit overlong and may be better served being a component in a swc
		private function formatScores(scores:Array):void {
			if(table != null){this.removeChild(table);}
			table = new Sprite();
			this.addChild(table);
			var nameHeader:TextField = new TextField();
			var scoreHeader:TextField = new TextField();
			nameHeader.x = 30;
			scoreHeader.x = 180;
			nameHeader.y = 75;
			scoreHeader.y = 75;
			nameHeader.defaultTextFormat = _score_text;
			scoreHeader.defaultTextFormat = _score_text;
			nameHeader.filters = [GameConstants.NEON_BLUE];
			scoreHeader.filters = [GameConstants.NEON_BLUE];
			nameHeader.selectable = false;
			scoreHeader.selectable = false;
			nameHeader.text = "NAME"
			scoreHeader.text = "SCORE"	
			table.addChild(nameHeader);
			table.addChild(scoreHeader);
			var step:Number = 115;
			for (var line:Object in scores) {
				var nameText:TextField = new TextField();
				var scoreText:TextField = new TextField();
				var curScore:String =  scores[line].score;
				var curName:String =  scores[line].name;
				nameText.autoSize = TextFieldAutoSize.LEFT;
				scoreText.autoSize = TextFieldAutoSize.LEFT;
				nameText.x = 30;
				scoreText.x = 180;
				nameText.y = step;
				scoreText.y = step;
				nameText.defaultTextFormat = _score_text;
				scoreText.defaultTextFormat = _score_text;
				nameText.filters = [GameConstants.NEON_BLUE];
				scoreText.filters = [GameConstants.NEON_BLUE];
				nameText.text = curName
				scoreText.text = curScore	
				nameText.selectable = false;
				scoreText.selectable = false;
				table.addChild(nameText);
				table.addChild(scoreText);
				step = step + 30;
			}	
			
			yourScore.x = 30;
			yourScore.y = 430;
			yourScore.defaultTextFormat = GameConstants.SUB_TITLT;
			yourScore.filters = [GameConstants.NEON_BLUE];
			yourScore.text = "Your Score is " + score + " enter your name";
			yourScore.selectable = false;
			yourScore.autoSize = TextFieldAutoSize.LEFT;
			table.addChild(yourScore);
			

			this.addChild(inputField);
			inputField.defaultTextFormat = _score_text;
			inputField.filters = [GameConstants.NEON_BLUE];
			
			inputField.borderColor = 0x00ffff;
			inputField.border = true;
			inputField.width = 145;
			inputField.height = 30;
			inputField.x = 30;
			inputField.y = 455;
			inputField.maxChars = 10;
			inputField.restrict = "A-Za-z0-9";
			inputField.type = "input";
			stage.focus = inputField;
		}
		
		
		private function addText():void {
				this.addChild(_title);
		}
		
		private function catchPlayer():void {

			drawButton("1","Send",180, 455);
			
		}
		
		// Draws our Simple buttons
		// Again this may be better served as part of a swc component
		private function drawButton(level:String,label:String,posX:Number,posY:Number):void {
		 levelButton = new SimpleButton();
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
		 if(label == "Send"){
			levelButton.addEventListener(MouseEvent.CLICK, sendScores);
		 }else if(label == "Quit"){
			levelButton.addEventListener(MouseEvent.CLICK, showCredits);
			}else {
			levelButton.addEventListener(MouseEvent.CLICK, replayGame);
			}
		}
		
		// Handles the user request to replay by dispatch a event back to the main game
		private function replayGame(e:Event):void {
			dispatchEvent(new Event(GameEvents.RESTART, true));
		}
		
		// Displays the game credits
		private function showCredits(e:Event):void {
			getChildByName("3").visible = false;
			getChildByName("2").visible = false
			_title.visible = false;
			table.visible = false;
			_credits.width = 280;
			_credits.multiline = true;
			_credits.filters = [GameConstants.NEON_BLUE];
			_credits.autoSize = TextFieldAutoSize.LEFT
			_credits.wordWrap = true;
			_credits.y = 20;
			_credits.x = 10;
			_credits.selectable = false;
			addChild(_credits)
			// Close the swf after 10 seconds displaying the credist
			new DelayCall().call(function():void { fscommand("quit") }, 10000);	
		}


		// Displays buttons for player choice once score is submitted
		private function continueGame():void {
			drawButton("2", "New Game", 80, 455);
			drawButton("3", "Quit", 180, 455);	
		}

		
		// Sends scores to a external PHP script which inturns updates a mySQL database
		// this ensure one worldwide score table..
		// this should be expanded to have different high score tables for Easy, Medium and Hard
		private function sendScores (e:Event):void {
			yourScore.visible = false;
			inputField.visible = false;
			levelButton.visible = false
			var scriptRequest:URLRequest = new URLRequest("http://www.tarquindandy.com/scores/addScore.php");
			var scriptLoader:URLLoader = new URLLoader();
			var scriptVars:URLVariables = new URLVariables();
 
			scriptLoader.addEventListener(Event.COMPLETE, handleLoadSuccessful);
			scriptLoader.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);
 
			scriptVars.userName = inputField.text;
			scriptVars.myScore = score;

			scriptRequest.method = URLRequestMethod.POST;
			scriptRequest.data = scriptVars;
 			
			scriptLoader.load(scriptRequest);
			// waits a few seconds for the score to be updated to the database and displays the top 10 again,
			// this couldbe made more effiecient by only firing if the current score is in the top 10
			new DelayCall().call(function():void {
				getScores(); 
				continueGame();}
				,2000);
		 }
		
		// Error trapping helper functions
		private function handleLoadSuccessful($evt:Event):void
		{
   	 		//trace("Sent.");
		}
 
		private function handleLoadError($evt:IOErrorEvent):void
		{
   		 	//trace("Failed.");
		}	
		
		// Request the scores form the mySql datbase, these are returned as a CSV file as this is easy to parse and CSVObjArray is already part of the package
		// by appending a date and time to the URL this ensure that the result is not cached.. if the game became hugely popular 
		// then server side caching should be implemented or the Server would fall over using thios method..
		private function getScores():void {
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, varsLoaded);
			loader.load(new URLRequest("http://www.tarquindandy.com/scores/getScores.php?time"+new Date().getTime()));
		}
		
		// the CSV as loaded sucessfully swnd it for parsing and display
		private function varsLoaded (event:Event):void {
			loader.removeEventListener(Event.COMPLETE, varsLoaded);
			//trace(loader.data);
			formatScores(CSVobjArray.parse(loader.data as String, false));
		}
		
		public function get title():String 
		{
			return _title.text;
		}
		
		public function set title(value:String):void 
		{
			_title.text = value;
			
		}
	}

}