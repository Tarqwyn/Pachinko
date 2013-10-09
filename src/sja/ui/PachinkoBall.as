
package sja.ui 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import sja.ui.*;
	
	
	/**
	 * ...
	 * @author Steven Atherton
	 * 
	 * Our basic pachinkoBall, it extends the PachinkoMagenitBall which allows the game Physics engine to turn on 
	 * Force direction algorithms
	 * 
	 */
		
public class PachinkoBall extends PachinkoMagneticBall
	{
		[Event(name = "removeBall", type = "sja.ui.GameEvents")]
				
		// data
		private var _velocityX:Number = 0;
		private var _velocityY:Number = 0;
		private var _speed:Number;
		private var _mass:Number;
		private var _radius:Number;
		private var _radians:Number;
		private var _markedforRemoval:Boolean = false;
		private var _readyforRemoval:Boolean = false;
		private var _saveBall:Boolean = false;
		private var _justHit:Boolean = false;
		private var count:uint = 0;
		private var shrinkSec:Number = 1;
		private var minSize:Number = 0;
		
		
		/**
		 * Ball Constructor
		 * @param	x
		 * @param	y
		 * @param	rotation
		 * @param	speed
		 * @param	radius
		 * @param	mass
		 */
		public function PachinkoBall(x:Number, y:Number, radius:Number, rotation:Number, speed:Number, mass:Number) 
		{
			// set parameters
			this.x = x;
			this.y = y;
			this.radius = radius;
			this.rotation = rotation;
			this.speed = speed;
			this.mass = mass;
			
			// calculate the other vars
			this.radians = this.rotation * Math.PI / 180;
			this.velocityX = Math.cos(this.radians) * this.speed;
			this.velocityY = Math.sin(this.radians) * this.speed;
			// draw ball
			drawBall();
	
		}
		
		// Makes the ball pretty called when intantiated and when events that effect the balls size are dispatch  by the physics engine..
		private function drawBall():void {
			this.graphics.clear();
			var colour1:Number;
			var colour2:Number;
			if (this.radius > 6) {
				this.filters = [GameConstants.NEON_LT_BLUE];
				colour1 = 0x0000ff;
				colour2 = 0x00ffff;
				}else {
				colour1 = 0x505050;
				colour2 = 0xFFFFFF;
				this.filters = [];	
				}
			var gradType:String = GradientType.RADIAL;
			var matrix:Matrix = new Matrix();
			var spreadMethod:String = SpreadMethod.PAD;
			var interp:String = InterpolationMethod.LINEAR_RGB;
			var focalPtRatio:Number = 0;
			matrix.createGradientBox((radius+4), (radius+4), 0, -3, -5);
			this.graphics.lineStyle(1, colour1);
			this.graphics.beginGradientFill(gradType,[colour2,colour1],[1,1],[0,255],matrix,spreadMethod,interp,focalPtRatio)
			this.graphics.drawCircle(0, 0, radius);
			this.graphics.endFill();
		}
		
		// If a ball is about to disappear down the hole this flags the balkl for removal and starts the animation
		public function downTheHole():void {
			if (!markedforRemoval) {
			shrinkSec = 0;
			minSize = 0;
			this.addEventListener(Event.ENTER_FRAME, shrink);
			}	
		}
		
		// Shrinking animation used when balls disappear down holes or when recovering form the Heavy and Charge effects
		private function shrink(e:Event):void {
			if (this.radius == minSize) {
				this.removeEventListener(Event.ENTER_FRAME, shrink);
				if(minSize == 0){
					this.filters = [];             
					if(_saveBall){
						dispatchEvent(new Event(GameEvents.SAVE_BALL, true));
						_saveBall = false;
					}
					readyforRemoval = true; 
				}
			}
			if(minSize == 0){
				this.radius = this.radius - 1;
				this.mass = this.mass - 1
			}else {
				if (shrinkSec % 13 == 0) {
					this.radius = this.radius - 1;
					this.mass = this.mass - 1
				}
			}
			shrinkSec++
		}
		
		
		// Utility function that stops the ball in its tracks
		public function stopBall():void {
			this.speed = 0;
			this.velocityX = 0;
			this.velocityY = 0;
		}
		
		// Apply the Charged ball visual effect
		public function chargeBall():void {
			shrinkSec = 0;
			minSize = 6;
			this.radius = 16;
			this.mass = 16;
			this.filters = [GameConstants.NEON_LT_BLUE];
			this.addEventListener(Event.ENTER_FRAME, shrink);
		}
		
		// Setters and getters
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
		
		public function get radius():Number 
		{
			return _radius;
			
		}
		
		public function set radius(value:Number):void 
		{
			_radius = value;
			drawBall();
		}
		
		public function get radians():Number 
		{
			return _radians;
		}
		
		public function set radians(value:Number):void 
		{
			_radians = value;
		}
		
		public function get velocityX():Number
		{
			return _velocityX;
		}
		
		public function set velocityX(value:Number):void 
		{
			if (value > 10) {
				value = 10
			}else if (value < -10) {
				value = -10	
			}
			_velocityX = value;
		}
		
		public function get velocityY():Number
		{
	
			return _velocityY;
		}
		
		public function set velocityY(value:Number):void 
		{		
			if (value > 10) {
				value = 10
			}else if (value < -10) {
				value = -10	
			}
			_velocityY = value;
		}
		
		public function get markedforRemoval():Boolean 
		{
			return _markedforRemoval;
		}
		
		public function set markedforRemoval(value:Boolean):void 
		{
			_markedforRemoval = value;
		}
		
		public function get justHit():Boolean 
		{
			return _justHit;
		}
		
		public function set justHit(value:Boolean):void 
		{
			_justHit = value;
			this.addEventListener(Event.ENTER_FRAME, countToRemove);
		}
		
		public function get readyforRemoval():Boolean 
		{
			return _readyforRemoval;
		}
		
		public function set readyforRemoval(value:Boolean):void 
		{	
			_readyforRemoval = value;
		}
		
		public function set saveBall(value:Boolean):void 
		{
			_saveBall = value;
		}
		
		
		// Helper function that flag a ball as having just hit something, used to combat the effect of balls being caught in a infinite collision loop 
		// between pins the flag is automatically removed after 2 frames...
		private function countToRemove(e:Event):void {
			count++
			if (count < 2) {
				this.justHit = false;
				this.removeEventListener(Event.ENTER_FRAME, countToRemove);
				count = 0;
				}
			
		}
		
	}
	
}