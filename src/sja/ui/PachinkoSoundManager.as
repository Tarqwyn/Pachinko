package sja.ui 
{
	import flash.display.Sprite;
	import flash.media.*;
	import flash.events.*;
	/**
	 * ...
	 * @author Steven Atherton
	 * 
	 * Class to contain and manage all sound effects within the game
	 */
	public class PachinkoSoundManager
	{

		// embed sounds
		private var backgroundMusic:BackgroundMusic = new BackgroundMusic;
		[Embed(source = "/sounds/ballonball.mp3")]
		private var ballonballClass:Class;
		private var ballonball:Sound = new ballonballClass() as Sound;
		[Embed(source = "/sounds/ballonpin.mp3")]
		private var ballonpinClass:Class;
		private var ballonpin:Sound = new ballonpinClass() as Sound;
		[Embed(source = "/sounds/ballonwall.mp3")]
		private var ballonwallClass:Class;
		private var ballonwall:Sound = new ballonwallClass() as Sound;
		[Embed(source = "/sounds/power.mp3")]
		private var powerClass:Class;
		private var power:Sound = new powerClass() as Sound;
		[Embed(source = "/sounds/release.mp3")]
		private var releaseClass:Class;
		private var release:Sound = new releaseClass() as Sound;
		[Embed(source = "/sounds/launcher.mp3")]
		private var launcherClass:Class;
		private var launcher:Sound = new launcherClass() as Sound;
		[Embed(source = "/sounds/fruitmachine.mp3")]
		private var fruitmachineClass:Class;
		private var fruitmachine:Sound = new fruitmachineClass() as Sound;
		[Embed(source = "/sounds/fruitwin.mp3")]
		private var fruitwinClass:Class;
		private var fruitwin:Sound = new fruitwinClass() as Sound;
		[Embed(source = "/sounds/stopspin.mp3")]
		private var stopspinClass:Class;
		private var stopspin:Sound = new stopspinClass() as Sound;
		[Embed(source = "/sounds/downhole.mp3")]
		private var downholeClass:Class;
		private var downhole:Sound = new downholeClass() as Sound;
		[Embed(source = "/sounds/charge.mp3")]
		private var chargeClass:Class;
		private var charge:Sound = new chargeClass() as Sound;
		
		//private var sndChannel:SoundChannel = new SoundChannel;
		private var turretSndChannel:SoundChannel = new SoundChannel();
		private var _backgroundSndChannel:SoundChannel =  new SoundChannel();
		
		public function PachinkoSoundManager() 
		{
			//backgroundSndChannel.addEventListener(Event.SOUND_COMPLETE, backgroundMusicSound);
		}
		
		public function ballOnBall():void {
			ballonball.play();
		}
		
		public function ballOnPin():void {
			ballonpin.play();
		}
		
		public function ballOnWall():void {
			ballonwall.play();
		}
		
		public function powerSound():void {
			power.play();
		}
		
		public function releaseSound():void {
			release.play();
		}
		
		public function fruitSound():void {
			fruitmachine.play();
		}
		
		public function fruitWinSound():void {
			fruitwin.play();
		}
		
		public function stopReelSound():void {
			stopspin.play();
		}
		
		public function downHoleSound():void {
			downhole.play();
		}
		
		public function chargeSound():void {
			charge.play();
		}
		
		public function backgroundMusicSound():void {
			//trace("Japenesse")
			_backgroundSndChannel = backgroundMusic.play(0,int.MAX_VALUE);
		}
		
		public function launcherSound():void {
			turretSndChannel=launcher.play();
		}
		
		public function launcherSoundStop():void {
			if(turretSndChannel != null){
				turretSndChannel.stop();
				turretSndChannel = launcher.play(10750);
			}	
			//turretSndChannel.stop();
		}
		
		public function get backgroundSndChannel():SoundChannel 
		{
			return _backgroundSndChannel;
		}
	}

}