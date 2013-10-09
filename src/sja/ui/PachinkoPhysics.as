
package sja.ui
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import sja.ui.GameEvents;
	import sja.ui.PachinkoBall;
	
	
	/**
	 * @author Steven Atherton
	 * 
	 * Pachinko Physics with gravity and friction
	 **/
	
	[Event(name = "spinSlotMachine", type = "sja.ui.GameEvents")]
	[Event(name = "ballArrayIsDirty", type = "sja.ui.GameEvents")]
	[Event(name = "ballArrayIsClean", type = "sja.ui.GameEvents")]
	[Event(name = "ballOnBall", type = "sja.ui.GameEvents")]
	[Event(name = "downHole", type = "sja.ui.GameEvents")]	

	
	public class PachinkoPhysics extends MovieClip
	{
		// reference to container (stage, movieclip or sprite)
		private var _canvas:MovieClip;
		private var timer:Timer = new Timer(20, 0);
		
		// boundries
		private var _minX:int;
		private var _minY:int;
		private var _maxX:int;
		private var _maxY:int;
		
		// balls array
		private var _ballArray:Array = [];
		// static location array
		private var _locationArray:Array = [];
		// used to rebuild array after balls have been removed from the machine;
		private var _newBallArray:Array = [];
		private var _charge:Boolean = false;
		// an attempt to join magnetised balls with a nice visula effect
		//private var links:Array;
		// Enviroment variables effected by slot machine results
		private var _float:Number = 1;
		private var _heavy:Boolean = false;

		
		// takes a Display object and use it to be the boundary of the physics engine 
		public function PachinkoPhysics($canvas:MovieClip)
		{
			_canvas = $canvas;
			setBoundries(_canvas);
		}
		
		//	Enables machine physics
		public function enable():void
		{
			_canvas.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		// Disables machine physics
		public function disable():void
		{
			_canvas.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		// Sets container boundries
		public function setBoundries($container:MovieClip):void
		{
			_minX = 0;
			_minY = 0;
			_maxX = $container.width;
			_maxY = $container.height;
		}

		// Use this to add a ball into the machine..
		public function createBall(ball:PachinkoBall):void
		{
			_ballArray.push(ball)
		}
		
		// Use add active balls to the new machine array..
		public function createUpdatedBall(ball:PachinkoBall):void
		{
			_newBallArray.push(ball)
		}

		// Use add a new location into the machine..
		public function createLocation(location:Object):void
		{
			_locationArray.push(location);
		}
		
		
		// checks to see if bounding box collision has occured
		// only if it has does it check for a line collision
		private function hitTestLine(ball1:Object, line2:Object):void {
			if (ball1.justHit !=true){
			if (ball1.hitTestObject(line2)) {
				var yD:Number = (line2.startXY.y - ball1.y);
				var xD:Number = (line2.startXY.x - ball1.x);
				var ballA:Number = Math.atan2(yD, xD)
				var diffA:Number = (line2.segmentAngle - ballA);
				var ballDist:Number = yD / Math.sin(ballA);
				var collisionDistance:Number = Math.sin(diffA) * ballDist;
				if ((Math.abs(collisionDistance) <= ball1.radius)) {
					line2.dispatchEvent(new Event(GameEvents.ADD_POINTS, true))
					dispatchEvent(new Event(GameEvents.BALL_ON_PIN));
					ball1.justHit = true;
					collidePinArray(ball1, line2)
					}
				}
			}
		}
	
		
		// Tests for collision between two objects with a radius property
		// by calculating the distance between them
		private function hitTestCircle(ball1:Object, ball2:Object):Boolean
		{
			var retval:Boolean = false;
			var segMentStep:Number = 1;
			var segMentValue:Number = 0;
			
			if (ball1.velocityX * -1 > 16 || ball1.velocityY * -1 >16) {
				if ((ball1.velocityX * -1) > (ball1.velocityY * -1)){
					segMentStep = Math.round((ball1.velocityX * -1) / 5);
					}
					else {
					segMentStep = Math.round((ball1.velocityY * -1) / 5);
					}
			}
			for (var s:uint = 0; s < segMentStep; s++) {
				var distance:Number = getDistance((ball1.x+segMentValue) - (ball2.x+segMentValue), (ball1.y+segMentValue) - (ball2.y+segMentValue));
				if (distance <= (ball1.radius + ball2.radius))
				{
					retval = true;
				}
				segMentValue = segMentValue + 5;
			}
			return retval;			
		}
		
		//  Update function that all the balls in the physics engine
		private function update():void 
		{
			// define common vars
			var tempBall1:PachinkoBall;			
			var i:int;
			var tempBall2:PachinkoBall;
			var tempLocation:Object;
			var k:int;
			var l:int;
			
			// loop thru balls array
			for (i = 0; i < _ballArray.length; i++)
			
			//_ballArray[i].applyForce(_ballArray);
			{
				// save a reference to ball
				tempBall1 = _ballArray[i] as PachinkoBall;
				
				// check for collision with other balls
				for (k = 0; k < _ballArray.length; k++)
				{
					// save a reference to ball 2
					tempBall2 = _ballArray[k] as PachinkoBall;
					
					// make sure we dont test for collision against itself
					if (tempBall1 == tempBall2) continue;
					
					if (charge == true) {
						tempBall1.connect(tempBall2);
						tempBall1.applyForce(_ballArray);
					}else if (charge == false) {
						tempBall1.disconnect(tempBall2);
					
					// check if balls are colliding by checking the distance between them
					if(hitTestCircle(tempBall1, tempBall2))
						{
							// calculate collision reaction
							collideBalls(tempBall1, tempBall2);
							dispatchEvent(new Event(GameEvents.BALL_ON_BALL));
							
							// if balls are still touching after collision reaction,
							// try to move them apart
							if(hitTestCircle(tempBall1, tempBall2))
							{
								tempBall1.x += tempBall1.velocityX;
								tempBall1.y += tempBall1.velocityY;
								tempBall2.x -= tempBall1.velocityX
								tempBall2.y -= tempBall1.velocityY
							}
						}
					}
				}
				// an attempt to get joining lines between magnitised balls may try and implement again later
				if (charge == true) {
				 //drawEdges(_ballArray);	
				}
				
				// Bounce off walls
				// Check if we hit left
				if (((tempBall1.x - tempBall1.radius) < _minX) && (tempBall1.velocityX < 0))
				{
					// reverse velocity
					tempBall1.velocityX = -tempBall1.velocityX;
					dispatchEvent(new Event(GameEvents.BALL_ON_WALL));
					
				}
				// Check if we hit right
				else if ((tempBall1.x + tempBall1.radius) > _maxX && (tempBall1.velocityX > 0))
				{
					// reverse velocity
					tempBall1.velocityX = -tempBall1.velocityX;
					dispatchEvent(new Event(GameEvents.BALL_ON_WALL));
				
				}
				// Check if we hit top
				if (((tempBall1.y - tempBall1.radius) < _minY) && (tempBall1.velocityY < 0))
				{
					// reverse velocity
					tempBall1.velocityY = -tempBall1.velocityY;
					dispatchEvent(new Event(GameEvents.BALL_ON_WALL));
				}
				// Check if we hit bottom
				else if (((tempBall1.y + tempBall1.radius) > _maxY) && (tempBall1.velocityY > 0))
				{
					tempBall1.y = 10000;
					tempBall1.stopBall();
					tempBall1.markedforRemoval = true;
					tempBall1.downTheHole();
				
				}
				
				// check if we hit a location
				if(tempBall1 !=null){
				for (l = 0; l < _locationArray.length; l++) {
					tempLocation = _locationArray[l];
					// loop thro location types
					// must be a more effiecient way of doing this using subclasses
					switch(tempLocation.type)
					{
					case "pinArray":
						hitTestLine(tempBall1, tempLocation);
						break;
					case "gutterNode":
						if (tempBall1.hitTestObject(tempLocation as PachinkoLocation)) {
						if (tempBall1.velocityY > 0) {
								tempBall1.stopBall();
								if (tempLocation.configType == "right") { tempBall1.x = 380 } else { tempBall1.x = 20; }
								tempBall1.y = tempLocation.y;
								tempBall1.saveBall = true;
								tempBall1.downTheHole();
								tempBall1.markedforRemoval = true;
								//trace("hit gutter")
						}else{
							tempBall1.velocityY = -tempBall1.velocityY;
						}
						}
						
						break;
					case "slot":
						if(tempBall1.radius<7){
						if (hitTestCircle(tempBall1, tempLocation)) {
							if (tempBall1.justHit != true) {
								dispatchEvent(new Event(GameEvents.DOWN_HOLE));
								tempBall1.stopBall();
								tempBall1.x = tempLocation.x;
								tempBall1.y = tempLocation.y;
								tempBall1.saveBall = true;
								tempBall1.downTheHole();
								tempBall1.markedforRemoval = true;
								dispatchEvent(new Event(GameEvents.SPIN_SLOT));
								//trace("hit slot")
								}						
							}
						}
						break;
					case "points":
							if(tempBall1.radius<7){
							if (hitTestCircle(tempBall1, tempLocation)) {
							if (tempBall1.justHit != true) {
								dispatchEvent(new Event(GameEvents.DOWN_HOLE));
								tempBall1.stopBall();
								tempBall1.x = tempLocation.x;
								tempBall1.y = tempLocation.y;
								tempBall1.downTheHole();
								tempBall1.markedforRemoval = true;
								tempLocation.dispatchEvent(new Event(GameEvents.ADD_POINTS, true));
								//dispatchEvent(new Event(GameEvents.BALL_ARRAY_IS_DIRTY, true));
								//("hit points")
								}						
							}
						}
						break;
					case "pin":
							if (hitTestCircle(tempBall1, tempLocation)) {
								tempBall1.justHit = true;
								collideBalls(tempBall1, tempLocation);
								dispatchEvent(new Event(GameEvents.BALL_ON_PIN));
								tempLocation.dispatchEvent(new Event(GameEvents.ADD_POINTS, true))
								//trace("hit pin")
						}
						break;
					case "void":
							if (hitTestCircle(tempBall1, tempLocation)) {
								tempBall1.justHit = true;
								collideBalls(tempBall1, tempLocation);
								dispatchEvent(new Event(GameEvents.BALL_ON_PIN));
								tempLocation.dispatchEvent(new Event(GameEvents.ADD_POINTS, true))
								//trace("void")
							}
						
						break;
					case "chargeNode":
						if (hitTestCircle(tempBall1, tempLocation)) {
							if(tempLocation.visible == true){
									tempLocation.direction = tempLocation.direction * -1;
									collideBalls(tempBall1, tempLocation);
									tempBall1.chargeBall();
									tempLocation.dispatchEvent(new Event(GameEvents.CHARGE, true));
									//trace("hit charge")
							}
						}
						break;
						default:
						//trace ("Unknown location"+tempLocation.type)
					}
				}
			}
				
				// apply friction to ball velocity
				tempBall1.velocityX *= GameConstants.FRICTION;
				tempBall1.velocityY *= GameConstants.FRICTION;
	
				
				// update position based on velocity
				tempBall1.x += tempBall1.velocityX;
				tempBall1.y += tempBall1.velocityY;
			
				tempBall1.velocityY += GameConstants.GRAVITY * _float;
				
				if (_heavy) {
						tempBall1.chargeBall();
				}
				
			}

		}
		

		//  Collision reaction
		private function collideBalls(collisionObject1:Object, collisionObject2:Object):void
		{
			
			// calculate the distance between center of balls with the Pythagoras' theorem
			var dx:Number = collisionObject1.x - collisionObject2.x;
			var dy:Number = collisionObject1.y - collisionObject2.y;
			
			// calculate the angle of the collision in radians
			var collisionAngle:Number = Math.atan2(dy, dx);
			
			// calculate the velocity vector for each ball
			// using existing ball X & Y velocities
			var speed1:Number = Math.sqrt(collisionObject1.velocityX * collisionObject1.velocityX + collisionObject1.velocityY * collisionObject1.velocityY)
			var speed2:Number = Math.sqrt(collisionObject2.velocityX * collisionObject2.velocityX + collisionObject2.velocityY * collisionObject2.velocityY)
			
			// calculate the angle in radians for each ball using it's current velocities
			// Calculate the angle formed by vector velocity of each ball, knowing your direction.
			var direction1:Number = Math.atan2(collisionObject1.velocityY, collisionObject1.velocityX);
			var direction2:Number = Math.atan2(collisionObject2.velocityY, collisionObject2.velocityX);
			
			// rotate the vectors counterclockwise so we can
			// calculate the conservation of momentum next
			var velocityX1:Number = speed1 * Math.cos(direction1 - collisionAngle);
			var velocityY1:Number = speed1 * Math.sin(direction1 - collisionAngle);			
			var velocityX2:Number = speed2 * Math.cos(direction2 - collisionAngle);
			var velocityY2:Number = speed2 * Math.sin(direction2 - collisionAngle);
			
			// take the mass of each ball and update their velocities based
			// on the law of conservation of momentum
			var finalVelocityX1:Number = ((collisionObject1.mass - collisionObject2.mass) * velocityX1 + (collisionObject2.mass + collisionObject2.mass) * velocityX2) / (collisionObject1.mass + collisionObject2.mass);
			var finalVelocityX2:Number = ((collisionObject1.mass + collisionObject1.mass) * velocityX1 + (collisionObject2.mass - collisionObject1.mass) * velocityX2) / (collisionObject1.mass + collisionObject2.mass);
			
			// Y velocities stay constant
			// because this is an 1D environment collision
			var finalVelocityY1:Number = velocityY1;
			var finalVelocityY2:Number = velocityY2;
			
			// after we have our final velocities, we rotate the angles back
			// so that the collision angle is preserved
			collisionObject1.velocityX = Math.cos(collisionAngle) * finalVelocityX1 + Math.cos(collisionAngle + Math.PI / 2) * finalVelocityY1;
			collisionObject1.velocityY = Math.sin(collisionAngle) * finalVelocityX1 + Math.sin(collisionAngle + Math.PI / 2) * finalVelocityY1;
			collisionObject2.velocityX = Math.cos(collisionAngle) * finalVelocityX2 + Math.cos(collisionAngle + Math.PI / 2) * finalVelocityY2;
			collisionObject2.velocityY = Math.sin(collisionAngle) * finalVelocityX2 + Math.sin(collisionAngle + Math.PI / 2) * finalVelocityY2;
			
			// add velocity to ball positions
			collisionObject1.x += collisionObject1.velocityX;
			collisionObject1.y += collisionObject1.velocityY;
			if(collisionObject2 is PachinkoBall){
				collisionObject2.x += collisionObject2.velocityX;
				collisionObject2.y += collisionObject2.velocityY;
			}
			
		}
		
		private function collidePinArray(ball1:Object, line2:Object):void {
			//line as angle
			//store cos and sin of lineAngle - will be used more than once
			var cosSegmentAngle:Number = Math.cos(line2.segmentAngle);
			var sinSegmentAngle:Number = Math.sin(line2.segmentAngle);
			//store initial velocity
			var vxi:Number = ball1.velocityX;
			var vyi:Number = ball1.velocityY;
			//project velocity onto line of action
			var vyip:Number = vyi * cosSegmentAngle - vxi * sinSegmentAngle;
			var vxip:Number = vxi * cosSegmentAngle +vyi * sinSegmentAngle;
			//reverse the velocity
			var vyfp:Number = -vyip;
			var vxfp:Number = vxip;
			//translate back to original axis
			var vyf:Number = vyfp * cosSegmentAngle + vxfp * sinSegmentAngle;
			var vxf:Number = vxfp * cosSegmentAngle - vyfp * sinSegmentAngle;
			//set new velocities
			ball1.velocityY = vyf;
			ball1.velocityX = vxf;
			//x += ball1.velocityX*2;
			//y += ball1.velocityX*2;		
		}
		
		// Event Handlers
	
	// EnterFrame handler
		private function onEnterFrame(e:Event):void 
		{
			update();
		}

		// Utilities
		
		// Get distance
		public function getDistance(delta_x:Number, delta_y:Number):Number
		{
			return Math.sqrt((delta_x*delta_x)+(delta_y*delta_y));
		}
		
		// Get radians
		public function getRadians(delta_x:Number, delta_y:Number):Number
		{
			var r:Number = Math.atan2(delta_y, delta_x);
			
			if (delta_y < 0)
			{
				r += (2 * Math.PI);
			}
			return r;
		}
		
		// Get degrees
		public function getDegrees(radians:Number):Number
		{
			return Math.floor(radians/(Math.PI/180));
		}
		
		// Setters and Getters
		public function set ballArray(value:Array):void 
		{
			_ballArray = value;
		
		}
		
		public function get ballArray():Array 
		{
			return _ballArray;
		}
		
		public function set newBallArray(value:Array):void 
		{
			_newBallArray = value;		
		}
		
		public function get newBallArray():Array 
		{
			return _newBallArray;
		}
		
		public function get charge():Boolean 
		{
			return _charge;
		}
		
		public function set charge(value:Boolean):void 
		{
			_charge = value;
		}
		
		// set and auto reset and any enviroment variables
		public function set float(value:Number):void 
		{
			_float = value;
			new DelayCall().call(function():void{_float = 1},5000)
		}
		
		public function set heavy(value:Boolean):void 
		{
			_heavy = value;
			new DelayCall().call(function():void{_heavy = false},5000)
		}
		
		public function set locationArray(value:Array):void 
		{
			_locationArray = value;
		}
	}
}