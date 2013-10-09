package sja.ui 
{
import flash.display.*;
import flash.events.*;
import flash.utils.*;

	/**
	 * ...
	 * @author Steven Atherton
	 * 
	 * Uses Force Directed algorithms to apply repulsion and attraction to the balls creating the effect of capturing them in a magnetic
	 * Field.. The effect if intresting but not perfect and requires a little refining in order to make it perfect, possible pathing the ball cluster 
	 * to a single magnetic point
	 * 
	 */

	public class PachinkoMagneticBall extends MovieClip {
	   
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var fx:Number = 0;
		public var fy:Number = 0;

		public const damping:Number = 0.05;
		public const timestep:Number = 0.05;

		// Where we store all the magnetised balls
		public var magnetised:Dictionary;

		public function PachinkoMagneticBall() {
			magnetised = new Dictionary(true);
		}

		// function to add a balls connection to another ball
		public function connect(other:PachinkoMagneticBall):void {
			magnetised[other] = other;
			other.magnetised[this] = this;
		}
		
		// function to remove a balls connection to another ball
		public function disconnect(other:PachinkoMagneticBall):void {
			delete magnetised[other];
			delete other.magnetised[this];
		}
		
		// based on pseudocode from http://en.wikipedia.org/wiki/Force-based_algorithms_%28graph_drawing%29
		
		// Here we apply forces across all our magnetised balls pushing them apart and attracting them back
		public function applyForce(allBalls:Array):void {
			var other:PachinkoMagneticBall;

			fx = fy = 0;
			
			// repell the balls
			for each(other in allBalls) {
				if (other == this) continue;
			   var repulsion:Object = calculateRepulsion(other);
			   fx += repulsion.x;
			   fy += repulsion.y;
			}

			// and attract them
			for each(other in magnetised) {
				var attraction:Object = calculateAttraction(other);
				fx += attraction.x;
				fy += attraction.y;
			}

			vx = (vx + timestep * fx) * damping;
			vy = (vy + timestep * fy) * damping;

			x = x + timestep * vx;
			y = y + timestep * vy;
			
		}

		// helper function that caculates attraction
		public function calculateAttraction(other:PachinkoMagneticBall):Object {
			var k:Number = 500;
			var idealDistance:Number = 0;
			var dist:Number = distance(other);
			// only pull it back as close as the idealdistance
			var f:Number = - k * (dist - idealDistance);
			var c:Number = f / dist;
			return({x: c * (this.x - other.x),
					y: c * (this.y - other.y)});
		}

		// helper function that caculates repulsion
		public function calculateRepulsion(other:PachinkoMagneticBall):Object {
			var dist:Number = distance(other);
			var f:Number = 50000000 / (dist * dist);
			return({x: f * (this.x - other.x) / dist,
					y: f * (this.y - other.y) / dist});
		}

		//helper function used to work out the distance between 2 ball
		public function distance(other:PachinkoMagneticBall):Number {
			var xd:Number = this.x - other.x;
			var yd:Number = this.y - other.y;
			var dist:Number = Math.sqrt(xd*xd+yd*yd);
			return dist;
		}
	}
	}