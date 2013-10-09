
package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	import sja.ui.*;

	/**
	 * ...
	 * @author Steven Atherton
	 * 
	 * Pachinko
	 * 
	 * Assignment 1 CI328 
	 */
	
	

	public class Main extends MovieClip
	{

		// Embeded Assets
		[Embed(source = 'images/background.jpg')]
		private var backdropClass:Class;
		private var backdrop:Bitmap = new backdropClass();
		
		[Embed(source = 'levels/pins.csv',mimeType="application/octet-stream")]
		private var pinsClass:Class;
		private var pinsCSV:String = new pinsClass();
		
		[Embed(source = 'levels/points.csv',mimeType="application/octet-stream")]
		private var pointsClass:Class;
		private var pointsCSV:String = new pointsClass();
		
		// Classes and Variables
		private var gameInstructions:PachinkoMessage;
		private var _mc:MovieClip;
		private var _physics:PachinkoPhysics;
		private var _sounds:PachinkoSoundManager;
		private var _soundBool:Boolean = true;
		private var fruit:PachinkoSlot;
		private var score:PachinkoScore;
		private var display:PachinkoDisplay;
		private var launcher:PachinkoLauncher;
		private var power:PachinkoPowerMeter;
		private var _ballCounter:PachinkoBallCounter ;
		private var charge:PachinkoLocation;
		private var slotTrigger:PachinkoLocation;
		private var gutterNodeL:PachinkoLocation;
		private var gutterNodeR:PachinkoLocation;
		private var gameEnd:PachinkoHighScore;
		private var multiplier:Number = 1;
		private var displayCleaner:Timer = new Timer(38);		
		private var ballLauncherPower:Number = 13;
		private var spinCount:Number = 0;

		public function Main()
		{	
            if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			// Turn of Scaling as it looks rubbish full screen
			stage.scaleMode = StageScaleMode.NO_SCALE;
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// Listen for gamestart event
			machineStart();
		}
		
		private function machineStart(e:Event = null):void {
			_mc = new MovieClip();
			addEventListener(GameEvents.GAME_START_1, gameStart);
			addEventListener(GameEvents.GAME_START_2, gameStart);
			addEventListener(GameEvents.GAME_START_3, gameStart);
			// Draw our physics engine canvas
			mc.graphics.lineStyle(2,0x0000ff);
			mc.graphics.beginFill(0x000000);
			mc.graphics.drawRect(0,0,GameConstants.WIDTH+2,GameConstants.HEIGHT+2);
			mc.graphics.endFill();
			mc.x = 0
			mc.y = 0;
			backdrop.filters = [GameConstants.NEON_LT_BLUE_INNER]
			// Add a backdrop
			backdrop.x = 1;
			backdrop.y = 1;
			mc.addChild(backdrop);
			// Add to stage
			addChild(mc);
			// Display Instructions modal Window
			instructions();	
		}
		
		private function instructions():void {
			// Blur out main window
			mc.filters = [GameConstants.MODAL_BLUR];
			// add instructions window
			gameInstructions = new PachinkoMessage("Pachinko");
			this.addChild(gameInstructions);
			if(_sounds == null){
				_sounds = new PachinkoSoundManager;
				_sounds.backgroundMusicSound();
			}
		}
		
		private function endPachinko():void {
			// Blur out main window
			mc.filters = [GameConstants.MODAL_BLUR];
			// add highScore window
			gameEnd = new PachinkoHighScore("HIGH SCORES",score.totalScore.toString());
			this.addChild(gameEnd);
			addEventListener(GameEvents.RESTART, clearAssets);

		}
		
		private function gameStart(e:Event=null):void {
			// Tidy up the listener
			switch(e.type) {
				case "gameStart1":
				_ballCounter = new PachinkoBallCounter(60,0,new Point(30,560));
				break;
				case "gameStart2":
				_ballCounter = new PachinkoBallCounter(40,0,new Point(30,560));
				break;
				case "gameStart3":
				_ballCounter = new PachinkoBallCounter(20,0,new Point(30,560));
				break;
			}
			removeEventListener(GameEvents.GAME_START_1, gameStart);
			removeEventListener(GameEvents.GAME_START_2, gameStart);
			removeEventListener(GameEvents.GAME_START_3, gameStart);
			// hide our instruction window we might need it later
			gameInstructions.visible = false;
			// remove the modal blue
			mc.filters = [];
			// start the ball cleaning timer there could be potentially hundreds of balls added to the game 
			// this ensures that balls a periodically cleaned from the Display list and the physics engine and they are kept in synch
			displayCleaner.start();
			// Initialise game assets and game listeners
			initAssets();
			initListeners();
		}
		
		
		
		private  function initListeners():void {
			// Keyboard control
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyboard);
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyboard);
			// Custom game events
			addEventListener(GameEvents.GAME_OVER, gameOverHandler);
			addEventListener(GameEvents.BONUS_BALL, increasePlayersBalls);
			addEventListener(GameEvents.RELEASE_BALLS, releasePlayersBalls);
			addEventListener(GameEvents.SAVE_BALL, saveBall);
			addEventListener(GameEvents.ADD_POINTS, incrementPoints);
			addEventListener(GameEvents.AUTO_BALL, addBall);
			_physics.addEventListener(GameEvents.SPIN_SLOT, spin);
			charge.addEventListener(GameEvents.CHARGE, chargeHandler);	
			// Listener to periodically synch the physics engine and the Display list
			displayCleaner.addEventListener(TimerEvent.TIMER, ballsOnDisplayList);
		}
		
		private function initAssets():void {
			//re-initialise variables
			
			score = new PachinkoScore(new Point(110,545));
			display =  new PachinkoDisplay(new Point(97,155));
			launcher =  new PachinkoLauncher;
			power = new PachinkoPowerMeter(new Point(295, 567));
			gutterNodeL = new PachinkoLocation("gutterNode", "left", new Point(0, 535));
			gutterNodeR = new PachinkoLocation("gutterNode", "right", new Point(302, 535));
			//Physic Simulation object
			_physics = new PachinkoPhysics(mc); // container is a movieclip on stage
			//enable physics simulation
			_physics.enable();
			// PachinkoBallCounter object..
			mc.addChild(_ballCounter);
			// Pichinko scorer object
			mc.addChild(score);
			// The turret style launcher
			mc.addChild(launcher);
			var voidMask:PachinkoLocation = new PachinkoLocation("void", "right", new Point(200, -10));
			_physics.createLocation(voidMask);
			mc.addChild(voidMask);
			// The launchers powermeter
			mc.addChild(power);
			// The moving plasma ball style bonus
			charge =  new PachinkoLocation("chargeNode","right",new Point(200,325));
			mc.addChild(charge);
			_physics.createLocation(charge);
			// The information display
			display.filters = [GameConstants.NEON_LT_BLUE]
			mc.addChild(display);
			display.currentDisplay = "Pachinko"
			// Adds the pins for level1 
			// TO DO update to select from a passed level..
			// Easily extendable to have different levels, move this out to a level class with a level manager
			addPins(CSVobjArray.parse(pinsCSV, false));
			//The point Scoring Slots
			// TO DO update to a CSV parsed loop..
			addPoints(CSVobjArray.parse(pointsCSV, false));
			// The slot machine
			addSlotMachine();
			// gutters
			mc.addChild(gutterNodeL);
			mc.addChild(gutterNodeR);
			_physics.createLocation(gutterNodeL);
			_physics.createLocation(gutterNodeR);
			// The Sound manager class
			soundHandler()
		}
		
		private function removeAllListners():void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyboard);
			stage.removeEventListener(KeyboardEvent.KEY_UP, handleKeyboard);
			// Custom game events
			removeEventListener(GameEvents.GAME_OVER, gameOverHandler);
			removeEventListener(GameEvents.BONUS_BALL, increasePlayersBalls);
			removeEventListener(GameEvents.RELEASE_BALLS, releasePlayersBalls);
			removeEventListener(GameEvents.SAVE_BALL, saveBall);
			removeEventListener(GameEvents.ADD_POINTS, incrementPoints);
			removeEventListener(GameEvents.AUTO_BALL, addBall);
			_physics.removeEventListener(GameEvents.SPIN_SLOT, spin);
			charge.removeEventListener(GameEvents.CHARGE, chargeHandler);	
			// Listener to periodically synch the physics engine and the Display list
			displayCleaner.removeEventListener(TimerEvent.TIMER, ballsOnDisplayList);
		}
		
		private function clearAssets(e:Event):void {
			removeEventListener(GameEvents.RESTART, clearAssets);
			//re-initialise variables	
			removeChild(mc);
			_physics.locationArray = [];
			_physics =  null;
			score = null;
			display =  null;
			launcher =  null;
			power = null;
			machineStart();
		}
		
		private function addBall(e:Event = null):void {
			// Create new ball
			// precalculate ball properties
			var newSpeed:Number = ballLauncherPower / 13;
			var newRadius:Number = 6 // * 20 + 10;
			var newRotation:Number = launcher.turret.rotation
			var newMass:Number = 6;
			var ball:PachinkoBall = new PachinkoBall(launcher.launcherOpening.x, launcher.launcherOpening.y, newRadius, newRotation,newSpeed , newMass);
			// add to display list	
			mc.addChild(ball);			
			// save ball in balls array and name it just in case
			ball.name = ("pachinkoBall" + (_physics.ballArray.length));
			// add the ball to the phyics Engine
			_physics.createBall(ball);
			_sounds.releaseSound();
			//stop the powerMeter;
			powerStop();
			// Depreciate the ballcounter dependant on whether ball was added manually or by the Autoball release bonus
			if (e != null) {
				_ballCounter.noOfSavedBalls = _ballCounter.noOfSavedBalls - 1;
			}else {
				_ballCounter.noOfBalls = _ballCounter.noOfBalls - 1;
			}				
		}
		
		// Create and add the slot machine to the stage
		private function addSlotMachine():void {
			slotTrigger = new PachinkoLocation("slot","right",new Point(200,265));
			slotTrigger.name = "slotTrigger"
			mc.addChild(slotTrigger);
			_physics.createLocation(slotTrigger);
			_physics.addEventListener(GameEvents.SPIN_SLOT, spin);
			fruit = new PachinkoSlot('DDD',new Point(148,375), 35, 'DJJKKQQQX0');
			fruit.addEventListener(GameEvents.STOP_REEL, stopReel);
			mc.addChild(fruit);
			fruit.render();
		}
		
		// Create and add the pins to the stage
		private function addPins(pinsArray:Array):void {
			for (var cluster:Object in pinsArray) {
			var locCurX:Number =  pinsArray[cluster].startX;
			var locCurY:Number =  pinsArray[cluster].startY;
			for (var i:int = 0; i < pinsArray[cluster].qty; i++) {
				var pin:PachinkoLocation = new PachinkoLocation(pinsArray[cluster].type,pinsArray[cluster].direction,new Point(locCurX,locCurY));
				if (pinsArray[cluster].type == "pin") {
					_physics.createLocation(pin);
				}
				pin.filters = [GameConstants.NEON_BLUE_INNER]
				mc.addChild(pin);	
				var curDirection:String = pinsArray[cluster].direction.toString();
				if (curDirection == "right") {
					locCurX = locCurX + Number(pinsArray[cluster].stepX);
				}else {
					locCurX = locCurX - Number(pinsArray[cluster].stepX);
				}
				locCurY = locCurY + Number(pinsArray[cluster].stepY);
			}
			if (pinsArray[cluster].type == "array") {
					var line:PachinkoLocation = new PachinkoLocation("pinArray","right",new Point(pinsArray[cluster].startX,pinsArray[cluster].startY),new Point(locCurX,locCurY))
					mc.addChild(line);
					_physics.createLocation(line);
					_physics.createLocation(line);
				}
			
			}	
		}
		
		// Create and add points scoring slots
		private function addPoints(pointsArray:Array):void {
			for (var hole:Object in pointsArray) {
				var locCurX:Number =  pointsArray[hole].xPos;
				var locCurY:Number =  pointsArray[hole].yPos;
				var locPoints:Number = pointsArray[hole].points
				var point:PachinkoLocation = new PachinkoLocation("points","right",new Point(locCurX,locCurY),null,locPoints);
					mc.addChild(point);
					_physics.createLocation(point);
			}	
		}
	
		// Spint the slot machine
		private function spin(e:Event):void {	
			spinCount++	
			//trace("adding "+spinCount)
			display.currentDisplay = "  SPIN  ";
			new DelayCall().call(  function():void { display.currentDisplay="PACHINKO"}, 5000);
			slotTrigger.filters = [GameConstants.NEON_RED];
			fruit.filters = [GameConstants.NEON_RED];
			fruit.addEventListener(GameEvents.SPIN_WIN, winningSpin);
			fruit.addEventListener(GameEvents.SPIN_COMPLETE,spinComplete);
			if(spinCount > 1){
			new DelayCall().call(function():void { _sounds.fruitSound();fruit.render();}, 1500 * spinCount);
			}else {
				_sounds.fruitSound();
				fruit.render();
			}
		}
		
		// The Spin has finished
		private function spinComplete(e:Event):void {
				removeEventListener(GameEvents.SPIN_COMPLETE, spinComplete);
				spinCount--	

					slotTrigger.filters = [GameConstants.NEON_BLUE];
					fruit.filters = [GameConstants.NEON_LT_BLUE];
					if (display.currentDisplay == "  SPIN  ") { display.currentDisplay = "  LOSE  "; new DelayCall().call(  function():void { display.currentDisplay="PACHINKO"}, 5000); }
		}
		
		
		// Tell the soundmanager the reel as stopped
		private function stopReel(e:Event):void {
				_sounds.stopReelSound();
		}
		
		// A winning spin applies some results which effect the game
		private function winningSpin(e:Event):void {
			fruit.removeEventListener(GameEvents.SPIN_WIN, winningSpin);
			_sounds.fruitWinSound();
			switch (fruit.slotText_str.charAt(0))
				{
				case "D":
					display.currentDisplay = "MAGNETIC";
					_physics.charge = true;
					new DelayCall().call(  function():void { display.currentDisplay = "PACHINKO" }, 5000);
					new DelayCall().call(  function():void { _physics.charge = false;}, 10000);
					break;
					score.add(5000);b
				case "J":
					display.currentDisplay = "FLOAT UP"
					new DelayCall().call(  function():void { display.currentDisplay="PACHINKO"}, 5000);
					_physics.float = -1;
					score.add(5000);
					break;
				case "K":
					display.currentDisplay = " HEAVY  "
					new DelayCall().call(  function():void { display.currentDisplay="PACHINKO"}, 5000);
					_physics.heavy = true;
					score.add(5000);
					break;	
				case "Q":
					increasePlayersBalls();
					break;			
				case "X":
					releasePlayersBalls();
				case "0":
					display.currentDisplay = " +500000"
					new DelayCall().call(  function():void { display.currentDisplay="PACHINKO"}, 5000);
					score.add(500000);

				default:
				trace ("shouldnt get here")
				}	
		}
		
		// Tell the PachinkoScore to add points
		private function incrementPoints(e:Event):void {
			score.add(e.target.pointsValue * multiplier);
			if(e.target.type != "pin" || e.target.type != "array"){
				if (e.target.type == "gutterNode") {
					_ballCounter.noOfBalls = _ballCounter.noOfBalls + 1
				}
			}

		}
		
		// start the powwer meter
		private function powerStart():void {
			
			addEventListener(Event.ENTER_FRAME, increasePower);

		}
		// stop the power meter
		private function powerStop():void {

			removeEventListener(Event.ENTER_FRAME, increasePower);
			ballLauncherPower = 13;
			power.gotoAndStop(1);
			
		}
		 // Add to the balls release power
		private function increasePower(ev:Event):void {
			ballLauncherPower ++;
			if (ballLauncherPower % 13 == 0) {
				if (ballLauncherPower > 130) {
				ballLauncherPower = 13;
				}
				power.gotoAndStop(ballLauncherPower / 13)
				_sounds.powerSound();
				//trace("increase power level by one to "+ballLauncherPower/13);
			}			
		}
		
	
		// Cleans the display list and makes sure that only balls still being tracked by 
		// the Physics engine are displayed..
		// It may be better to use the Physics engine to mantain the ball and locations
		// display list nut when I tried I got unexpected results with balls staying on screen
		// this  could be improved I'm sure
		private function ballsOnDisplayList(e:TimerEvent = null):void {
			//trace("*************CLEANING ARRAY AND DISPLAY********************")
			//trace(mc.numChildren)
			for (var i:int = 0; i < mc.numChildren; i++) {
			var dispBall:Object = Object(mc.getChildAt(i));	
					if (dispBall is PachinkoBall) {
						//trace("*************BALL FOUND********************")
    					if (dispBall.readyforRemoval) {
							//trace("removing" + dispBall.name);
							mc.removeChild(dispBall as PachinkoBall)
							
						}else if(dispBall.markedforRemoval){
							//trace("animation pending" + dispBall.name);
							//trace("x: " + dispBall.x + " y: " + dispBall.y);
							if (dispBall.y > 999) {
								mc.removeChild(dispBall as PachinkoBall);
							}
						}else {
							//trace("live ball" + dispBall.name);
							dispBall.name = ("pachinkoBall" + (_physics.newBallArray.length));
							_physics.createUpdatedBall(dispBall as PachinkoBall);
						}
						}else {
						//trace("*******NOT A BALL*************")	
						}
				}
				_physics.ballArray = _physics.newBallArray;
				_physics.newBallArray = [];
				//trace("*************CLEANED********************")
				if(_physics.ballArray.length < 1){gameOverHandler(new Event(GameEvents.GAME_OVER,true));}
				
		}

		// Keyboard Event handler
		private function handleKeyboard(ev:KeyboardEvent):void {
			if (ev.type == "keyDown") {
				switch (ev.keyCode)
				{
				case 32:
					powerStart();
				break;
				case 37:
					
					if (_soundBool == true) {
						launcher.rotateLauncher("Left")
						_sounds.launcherSound();
						_soundBool = false;
					}
				break;
				case 39:
					
					if (_soundBool == true) {
						launcher.rotateLauncher("Right")
						_sounds.launcherSound();
						_soundBool = false;
					}
				break;
				default:
				trace ("shouldnt get here")
				}
			}else if (ev.type == "keyUp") {
				switch (ev.keyCode)
				{
				case 32:
					if(ballLauncherPower>13){
						if(_ballCounter.noOfBalls>0){
							addBall();
						}else {
							_ballCounter.ballText = "No Balls"
							powerStop();
							
						}
					}else {
					   powerStop();
					}
				case 37:
					
					if (_soundBool == false) {
						launcher.stopLauncher();
						_sounds.launcherSoundStop();
						_soundBool = true;
					}
				break;
			case 39:
					
					if (_soundBool == false) {
						launcher.stopLauncher();
						_sounds.launcherSoundStop();                                             
						_soundBool = true;
					}
				break;
				break;
				default:
				trace ("shouldnt get here")
				}
				}
		}
		
		// Handles all the events that trigger sounds which take place outside Main
		private function soundHandler():void {
			_physics.addEventListener(GameEvents.BALL_ON_BALL, function():void {
				_sounds.ballOnBall();
				});
			_physics.addEventListener(GameEvents.BALL_ON_PIN, function():void {
				_sounds.ballOnPin();
				});
			_physics.addEventListener(GameEvents.BALL_ON_WALL, function():void {
				_sounds.ballOnWall();
				});
			_physics.addEventListener(GameEvents.DOWN_HOLE, function():void {
				_sounds.downHoleSound();
				});
		}
		
		// Charge a Ball
		private function chargeHandler(e:Event):void
		{
			display.currentDisplay = " CHARGE "
			new DelayCall().call(  function():void { display.currentDisplay="PACHINKO"}, 5000);
			charge.visible = false;
			multiplier = 10;
			_sounds.chargeSound();
			new DelayCall().call(  function():void { charge.visible = true;multiplier = 1 }, 5000);
		}
		// Tell PachinkoBallCounter to add to the Saved balls tally
		private function saveBall(e:Event):void {
			//trace("*******************SAVE BALL***********************************************")
			_ballCounter.noOfSavedBalls = _ballCounter.noOfSavedBalls+1	
		}
		// Tell PachinkoBallCounter to add to the available balls tally
		private function increasePlayersBalls(e:Event=null):void {
			_ballCounter.noOfBalls = _ballCounter.noOfBalls + 5;
			display.currentDisplay = "+5 BALLS"
			new DelayCall().call(  function():void { display.currentDisplay="PACHINKO"}, 5000);
	
		}
		
		// Automatically release saved balls via the launcher
		private function releasePlayersBalls(e:Event = null):void {
			display.currentDisplay = "AUTOBALL"
			new DelayCall().call(  function():void { display.currentDisplay="PACHINKO"}, 5000);
			var loop:uint;
			var i:uint;
			loop = _ballCounter.noOfSavedBalls;
			for (i = 0; i < loop; i++) { 
				new DelayCall().call(function():void{dispatchEvent(new Event(GameEvents.AUTO_BALL,true))}, 500*i);
			}
		}
		
		// Checks to see if all the Game over states are true and handles this
		private function gameOverHandler(e:Event=null):void {
			//trace("*****GAME OVER TEST****")
			//trace(_ballCounter.noOfBalls)
			//trace(_physics.ballArray.length)
			//trace(score.totalScore)
			if (_ballCounter.noOfBalls < 1 && _physics.ballArray.length < 1 && score.totalScore == score.displayScore) {
				_ballCounter.ballText = "Game Over";
				displayCleaner.stop();
				removeAllListners();
				powerStop();
				endPachinko();
				//                                      
				//trace("*****GAME OVER TRUE****")
			}else {
				//trace("*****GAME OVER FALSE****")
			}
		}
		
		// Setters and Getters
		public function get mc():MovieClip 
		{
			return _mc;
		}
	}
		
}