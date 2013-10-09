package sja.ui 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import sja.ui.*;
	
	/**
	 * ...
	 * @author ...
	 * 
	 * A simple rotating turret adapted from the Week 8 Klingon example on StudentCentral
	 */
	public class PachinkoLauncher extends MovieClip
	{
		private var _launcherOpening:Point = new Point(160, 70);
		private var __launcherRad:Number;
		private var _direction:String;
		private var _turret:Sprite = new Sprite; 
		private var _mask:Shape = new Shape();
		
		public function PachinkoLauncher() 
		{
			
			this.x = 200;
			this.y = -10;
			
			// Visual lighting effect
			var gradType:String = GradientType.RADIAL;
			var matrix:Matrix = new Matrix();
			var spreadMethod:String = SpreadMethod.PAD;
			var interp:String = InterpolationMethod.LINEAR_RGB;
			var focalPtRatio:Number = 0;
			matrix.createGradientBox(60, 60, 0,-15,-30);
			_turret.graphics.lineStyle(1, 0x0000FF);
			_turret.graphics.beginGradientFill(gradType,[0xFFFFFF,0x505050],[1,1],[0,255],matrix,spreadMethod,interp,focalPtRatio)
			_turret.graphics.drawCircle(0, 0, 40);
			_turret.graphics.endFill();
			_turret.graphics.lineStyle(1, 0x505050);
			_turret.graphics.beginFill(0x000000, 1)
			_turret.graphics.drawEllipse(30, -7, 9, 14)
			_turret.graphics.endFill()
			_turret.rotation = 90;
			_turret.filters = [GameConstants.NEON_LT_BLUE_B]
			addChild(_turret);
			addChild(_mask);
			_mask.x = _turret.x;
			_mask.y = _turret.y;
			drawMask();
			_turret.mask = _mask;
		}
		
		
		// Rotate the launcher what direction?
		public function rotateLauncher(direction:String):void {
			_direction = direction;
			addEventListener(Event.ENTER_FRAME, moveLauncher);
		}
		
		//stop the launcher
		public function stopLauncher():void {
			removeEventListener(Event.ENTER_FRAME, moveLauncher);
		}
		
		// Move it frame by frame until max & min rotation is reached
		private function moveLauncher(e:Event):void {			
				switch (_direction)
				{
				case "Left":
					if(_turret.rotation < 150){
						_turret.rotation += 1

					}
				break;
			case "Right":
					if(_turret.rotation > 30){
						_turret.rotation -= 1

					}
				break;
				default:
				trace ("shouldnt get here")
				}
				
			}

			// returns the position of the luancher opening required whena ball is added 
			public function get launcherOpening():Point{
			//Calculate Starting coordinates
			_launcherOpening.x = this.x + (GameConstants.LAUNCHER_HOLE * Math.cos((_turret.rotation)/(180/Math.PI)));
			_launcherOpening.y = this.y + (GameConstants.LAUNCHER_HOLE * Math.sin((_turret.rotation)/(180/Math.PI)));	
			return _launcherOpening;
			}
			
			public function get turret():Sprite 
			{
				return _turret;
			}
			
			
			// Masks out the top of the launcher
			private function drawMask():void {
				_mask.graphics.lineStyle();
				_mask.graphics.beginFill(0x000000, 1);
				_mask.graphics.drawRect( -45, 11, 90, 70);
				_mask.graphics.endFill();
				
			}
		
	}

}