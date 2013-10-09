package sja.ui 
{
	import com.greensock.*;
	import com.greensock.plugins.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	import sja.ui.*;
 
	// Specific custome events
	[Event(name = "spinComplete", type = "sja.ui.GameEvents")]
	[Event(name = "spinIsWinner", type = "sja.ui.GameEvents")]
	[Event(name = "stopReel", type = "sja.ui.GameEvents")]
	
	/**
	 * ...
	 * @author Steven Atherton
	 * 
	 * an modified an extended version of an orginal idea by Joakim Roos http://www.deviouswork.com/2009/07/10/slotmachine-effect/
	 * Renders a three reel slot machine using a String of Alphanumeric data, then Randomises each reel in turn to produce a result
	 * by comparing the random result the Slotmachine Event results which are captured via the Main game class
	 * ...
	 */
	public class PachinkoSlot extends Sprite
	{
			
			// Variables
			private var _characterRange_str : String;
			private var _slotText_str : String;
			private var _bcContainer_mc : Sprite;
			private var _bcMask_mc:Sprite;
			private var _currentChar_int : Number;
			private var _aSize:uint;

			public function PachinkoSlot(aSlotText:String,pos:Point = null, aSize:uint = 12, aCharacterRange:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890") {
				this.x = pos.x;
				this.y = pos.y;
				TweenPlugin.activate([BlurFilterPlugin]);
				characterRange = aCharacterRange;
				_slotText_str = aSlotText;
				_aSize = aSize
				// Skin out slot machine
				graphicRender();
				renderReels();
			}
	 
			//Prepare for the animation
			public function render():void {
				this.slotText_str = this.characterRange.charAt((Math.random() * 10) - 1) + this.characterRange.charAt((Math.random() * 10) - 1) + this.characterRange.charAt((Math.random() * 10) - 1);
				//	used to test Win states
				//  this.slotText_str = "DDD"
				_currentChar_int = 0;
				var chars: int = characterRange.length;
				var t:Timer = new Timer(100, chars);
				t.addEventListener(TimerEvent.TIMER, _updateAnimation);
				t.addEventListener(TimerEvent.TIMER_COMPLETE, _endAnimation);
				t.start();
			}
	 
			// Take each reel and Tween it upwards and apply a blur filter giving the impression of a spinning reel
			// This called via a timer event
			private function _updateAnimation(aEvent_te:TimerEvent):void {
				for(var i:int = 0; i < _bcContainer_mc.numChildren; i++) {
					var bc:BitmapCharacter = _bcContainer_mc.getChildAt(i) as BitmapCharacter;
					var	bmp:Bitmap = bc.getChildAt(_currentChar_int) as Bitmap;
					bmp.y = bmp.height;
					bmp.visible = true;
					if(bc.currentCharacter != null) {
						TweenLite.to(bc.currentCharacter, 0.1, {y:-bc.currentCharacter.height, delay:i*.1, overwrite:false});
					}
					TweenLite.to(bmp, 0.1, {y:0,blurFilter:{blurY:10}, delay:i*.1, overwrite:false});
					bc.currentCharacter = bmp;
				}
				if(_currentChar_int < characterRange.length-1) _currentChar_int++;
				else _currentChar_int = 0;
	 
			}
	 
			// Take each reel and stop the tweening and reshow the character result for that reel
			// This called via a timer Complete event
			private function _endAnimation(aEvent_te:TimerEvent):void {
				for (var i:int = 0; i < _bcContainer_mc.numChildren; i++) {
					var bc:BitmapCharacter = _bcContainer_mc.getChildAt(i) as BitmapCharacter;
					TweenLite.to(bc.currentCharacter, 0.1, {y:-bc.currentCharacter.height, delay:0, overwrite:true});
					for(var j:int = 0; j < characterRange.length; j++) {
						var delay_num:Number = i*.1 + j*.1;
						var	bmp:Bitmap = bc.getChildAt(j) as Bitmap;
						TweenLite.to(bc.currentCharacter, 0.1, {y:-bc.currentCharacter.height, delay:delay_num, overwrite:false});
						bc.currentCharacter = bmp;
						if(bmp.name == "bmp_"+ _slotText_str.charAt(i)) {
							TweenLite.to(bmp, 0.1, { y:0, blurFilter: { blurY:0 }, delay:delay_num, overwrite:false } );	
							break;
						} else {
							TweenLite.to(bmp, 0.1, {y:0,blurFilter:{blurY:10}, delay:delay_num, overwrite:false});
						}
						
					}
					// send the reel stop spinning event after the calculated delay
					new DelayCall().call(_dispatchReelEvent,(delay_num*1000));
				}
				// tidy up listeners
				var t:Timer = aEvent_te.target as Timer;
				t.stop();
				t.removeEventListener(TimerEvent.TIMER_COMPLETE, _endAnimation);
				t = null;
				TweenLite.delayedCall(delay_num, _dispatchCompleteEvent);
			}
			
	
			
			// This is the code which renders the reels
			private function renderReels():void {
				// take our outcome string and reverse it
				var reverse_str:String = _slotText_str.split('').reverse().join('');
				var i: uint = reverse_str.length;
				var ox:Number = 0;
				// add a container
				_bcContainer_mc = new Sprite();
				addChild(_bcContainer_mc);
				// loop back through reversed string
				while(i--) {
					// make a new bitmap image
					var bc:BitmapCharacter = new BitmapCharacter(characterRange, _aSize);
					bc.name = "BitmapCharacter_" + reverse_str.charAt(i) +"_" + Math.random();
					// add it to the container
					_bcContainer_mc.addChild(bc);
					bc.x = ox;
					bc.getChildByName("bmp_" + reverse_str.charAt(i)).visible = true;
					// move to next reel
					ox = bc.x + 37;
					// turn it off ready for the spin effect
					bc.getChildByName("bmp_" + reverse_str.charAt(i)).visible = false;
				}
				// add a mask so we can see blur outside our window
				_bcMask_mc = new Sprite();
				addChild(_bcMask_mc);
				with(_bcMask_mc.graphics) {
					beginFill(0xffffff, .1);
					drawRect(0, 2, _bcContainer_mc.width, _bcContainer_mc.height);
					endFill();
				}
				_bcContainer_mc.mask = _bcMask_mc;
			}
			
			// This is our slot machine Skin... this could be pulled in externally or just changed on the fly for different levels etc
			private function graphicRender() :void {	
				var rectWidth:Number=111;
				var rectHeight:Number=44;
				var mat:Matrix;
				var colors:Array;
				var alphas:Array;
				var ratios:Array;
				var gradType:String = GradientType.LINEAR;
				colors=[0x000000, 0x505050];
				alphas=[1,1];
				ratios = [0, 255];
				this.graphics.lineStyle(1,0x0000ff,0.5);
				this.graphics.beginFill(0x0000FF);
				this.graphics.drawRoundRect(-6, -4, rectWidth + 8, rectHeight + 8, 5, 5);
				this.graphics.endFill();
				mat=new Matrix();
				mat.createGradientBox(rectWidth,rectHeight,toRad(-90));
				this.graphics.lineStyle(3);
				this.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, mat);
				this.graphics.drawRoundRect(-2, 0, rectWidth,rectHeight,4,4);
				this.graphics.endFill();
				this.graphics.moveTo(35, 0);
				this.graphics.lineTo(35, 44);
				this.graphics.moveTo(72, 0);
				this.graphics.lineTo(72, 44);
				this.filters = [GameConstants.NEON_LT_BLUE]
			}
	 
			// Used to tell the Soundmanaged to make the rell stop sound
			private function _dispatchReelEvent():void {
				dispatchEvent(new Event(GameEvents.STOP_REEL));
			}
			
			// the machine is finished it Spin so dispatch the appropriate Event
			private function _dispatchCompleteEvent():void {
				if (_slotText_str.charAt(0) == _slotText_str.charAt(1) && _slotText_str.charAt(0) == _slotText_str.charAt(2)) {
					dispatchEvent(new Event(GameEvents.SPIN_WIN));
				}
				dispatchEvent(new Event(GameEvents.SPIN_COMPLETE));
			}
			
					public function get characterRange() : String 
			{	
				return _characterRange_str; 
			}
			
			// Setters and Getters
			
			public function set characterRange(aInput_str : String):void {	
				_characterRange_str = aInput_str; 
			}
			
			public function get slotText_str():String 
			{
				return _slotText_str;
			}
			
			public function set slotText_str(value:String):void 
			{
				_slotText_str = value;
				removeChild(_bcContainer_mc);
				removeChild(_bcMask_mc)
				renderReels();		
			}
			
			
			// Helper function
			private function toRad(a:Number):Number {
				return a*Math.PI/180;
			}
		}	
	}