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
	 * This could have been implemented via having subClasses 
	 * However it was much faster to code and test as a single class with a type
	 * refactoring may be appropriate if the game is expanded and as more possible locations
	 * are added as this could become unwieldy very quickly
	 */
	public class PachinkoLocation extends MovieClip 
	{
		// events requi
		[Event(name = "addPoints", type = "sja.ui.GameEvents")]
		[Event(name = "charge", type = "sja.ui.GameEvents")]
		
		// embeded graphics
		[Embed(source = '/images/charge.png')]
		private var chargeClass:Class;
		private var charge:Bitmap = new chargeClass();
		
		[Embed(source = '/images/gutterR.png')]
		private var gutterRClass:Class;
		private var gutterR:Bitmap = new gutterRClass();
		
		[Embed(source = '/images/gutterL.png')]
		private var gutterLClass:Class;
		private var gutterL:Bitmap = new gutterLClass();
	
		// variables
		private var _type:String;
		private var _radius:Number;
		private var _velocityX:Number = 0;
		private var _velocityY:Number = 0;
		private var _speed:Number = 0;
		private var _mass:Number = 50;
		private var _configType:String;
		private var _startXY:Point;
		private var _endXY:Point;
		private var _segmentAngle:Number;
		private var _direction:Number = 1;
		private var _pointsValue:Number = 0;

		
		// create the location and visual representation based on type
		public function PachinkoLocation(type:String = "pin", configType:String ="right",startXY:Point=null,endXY:Point=null,points:Number = 100) 
		{
			
			_type = type;
			_configType = configType;
			_startXY = startXY;
			_endXY = endXY;
			_pointsValue = points;
			
			switch (_type){

				case "pin":
				pinLocation()
				break;
				
				case "array":
				pinLocation()
				break;

				case "slot":
				slotMachineLocation()
				break;
				
				case "points":
				pointsLocation()
				break;
				
				case "pinArray":
				pinArrayLocation()
				break;
				
				case "chargeNode":
				chargeLocation()
				break;

				case "gutterNode":
				gutterLocation()
				break;
				
				case "void":
				voidLocation()
				break;
				}
			
		}
		
		// Slot machine hole
		public function slotMachineLocation():void
		{
			this.x = this.startXY.x;
			this.y = this.startXY.y;
			this.graphics.lineStyle(2,0x00ffff);
			this.graphics.beginFill(0x000000);
			this.graphics.drawCircle(0, 0, 7);
			this.graphics.endFill();
			this.radius = 7;
			this.filters = [GameConstants.NEON_BLUE]
			var text:TextField = new TextField;
			text.text = "Slot";
			text.x = 10;
			text.y = - 20;
			addChild(text);
			text.setTextFormat(GameConstants.LABEL_TEXT);
			text.selectable = false; 
		}
		
		//Points hole
		public function pointsLocation():void
		{
			this.x = this.startXY.x
			this.y = this.startXY.y
			this.graphics.lineStyle(2,0x00ffff);
			this.graphics.beginFill(0x000000);
			this.graphics.drawCircle(0, 0, 7);
			this.graphics.endFill();
			this.radius = 7;
			this.filters = [GameConstants.NEON_BLUE]
			var text:TextField = new TextField;
			text.text = this.pointsValue.toString();
			if (this.x > 280) { if(this._pointsValue<1000){text.x = -30}else{text.x = -40};} else { text.x = 10;}
			text.y = - 20;
			addChild(text);
			text.setTextFormat(GameConstants.LABEL_TEXT);
			text.selectable = false; 
		}
		
		// A standard single pin
		public function pinLocation():void
		{
			this.x = this.startXY.x
			this.y = this.startXY.y
			this.graphics.lineStyle(3,0x00ffff);
			this.graphics.beginFill(0x00ffff);
			this.graphics.drawCircle(0, 0, 1);
			this.graphics.endFill();
			this.radius = 4;
		}
		
		// An array of closely packed pins
		public function pinArrayLocation():void
		{
			this.graphics.lineStyle(1, 0x000000,0.01);
			this.graphics.moveTo(_startXY.x, _startXY.y);
			this.graphics.lineTo(_endXY.x, _endXY.y);
			segmentAngle = Math.atan2((startXY.y - endXY.y), (startXY.x - endXY.x))
		}
		
		// A moving charge location
		// this could take additional arguments allowing for it to appear anywhere in the machine
		// this could be a good argument for moving Location out into subclasses
		public function chargeLocation():void {
				this.x = this.startXY.x
				this.y = this.startXY.y
				charge.filters = [GameConstants.NEON_LT_BLUE];
				charge.x = (charge.width / 2) * -1;
				charge.y = (charge.height / 2) * -1;
				addChild(charge);
				this.radius = (charge.width / 2);
				addEventListener(Event.ENTER_FRAME, moveLocation);
		}
		
		// Handles the moveong of a location in this case a charge
		private function moveLocation(e:Event):void {
			if (this.x > 280) {
				_direction = -1
			}else if (this.x < 120) {
				_direction = +1
			}
			this.x = this.x +direction;
		}
		
		// A gutter location
		private function gutterLocation():void {
			this.x = this.startXY.x
			this.y = this.startXY.y
			if (_configType == "left") {
			addChild(gutterL)
			}else if (_configType == "right") {
			addChild(gutterR)	
			}
			
		}
		
		// empty location used as a helper in this case to sourround the launcher so it has a collision
		// effect without the need for additional code in the physic engine
		private function voidLocation():void {
			this.x = this.startXY.x
			this.y = this.startXY.y
			//trace("making void")
			this.radius = 40;	
		}
		
		
		// Setters and Getters
		public function get radius():Number 
		{
			return _radius;
		}
		
		public function set radius(value:Number):void 
		{
			_radius = value;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function get velocityX():Number 
		{
			return _velocityX;
		}
		
		public function set velocityX(value:Number):void 
		{
			_velocityX = value;
		}
		
		public function get velocityY():Number 
		{
			return _velocityY;
		}
		
		public function set velocityY(value:Number):void 
		{
			_velocityY = value;
		}
		
		public function get speed():Number 
		{
			return _speed;
		}
		
		public function set speed(value:Number):void 
		{
			_speed = value;
		}
		
		public function get mass():Number 
		{
			return _mass;
		}
		
		public function set mass(value:Number):void 
		{
			_mass = value;
		}
		
		public function get configType():String 
		{
			return _configType;
		}
		
		public function get startXY():Point 
		{
			return _startXY;
		}
		
		public function get endXY():Point 
		{
			return _endXY;
		}
		
		public function get segmentAngle():Number 
		{
			return _segmentAngle;
		}
		
		public function set segmentAngle(value:Number):void 
		{
			_segmentAngle = value;
		}
		
		public function get direction():Number 
		{
			return _direction;
		}
		
		public function set direction(value:Number):void 
		{
			_direction = value;
		}
		
		public function get pointsValue():Number 
		{
			return _pointsValue;
		}
	
	}

}