package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import States.Game;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	[SWF(frameRate="60", width="1024", height="768", backgroundColor="0x000000")]
	public class LoopyWeb extends Sprite
	{
		
		[Embed(source="../media/graphics/MainAtlas/001.png")]
		public static const LOOPY_SPLASH:Class;
		
		private var _starlingFramework:Starling;
		private var _splashTexture:Bitmap;
		public function LoopyWeb()
		{			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			addStarlingFramework();
			addSlpash();
		}
		
		private function addStarlingFramework():void
		{
			var screenWidth:int  = 1024;
			var screenHeight:int = 768;
			var viewPort:Rectangle = new Rectangle(0, 0, screenWidth, screenHeight);
			var starlingResolution:Point;
			
			_starlingFramework = new Starling(Game, stage, viewPort);
			_starlingFramework.stage3D.addEventListener(starling.events.Event.CONTEXT3D_CREATE, removeSplash);
			
			starlingResolution = ResolutionController.adjustResolution();
			_starlingFramework.stage.stageHeight  = starlingResolution.x;
			_starlingFramework.stage.stageWidth   = starlingResolution.y;
			
			_starlingFramework.antiAliasing = 1;
			_starlingFramework.start();
		}
		
		
		private function addSlpash():void
		{
			_splashTexture = new LOOPY_SPLASH() as Bitmap;
			
			this.addChild(_splashTexture);
			stage.addEventListener(flash.events.Event.RESIZE, centerSplash);
			
			_splashTexture.smoothing = true;
			centerSplash();
		}
		
		private function centerSplash(pEvent:flash.events.Event = null):void
		{
			var starlingResolution:Point = ResolutionController.adjustResolution();
			var starlingStageWidth:int = stage.stageWidth;
			var starlingStageHeight:int = stage.stageHeight;
			
			var aspect:Number = 1;
			var widthAspect:Number = starlingStageWidth / _splashTexture.width;
			var heightAspect:Number = starlingStageHeight / _splashTexture.height;
			
			if(widthAspect > heightAspect) aspect = widthAspect;
			else aspect = heightAspect;
			
			_splashTexture.width = _splashTexture.width * aspect;
			_splashTexture.height = _splashTexture.height * aspect;
			
			_splashTexture.x = starlingStageWidth/2 - _splashTexture.width/2;
			_splashTexture.y = starlingStageHeight/2 - _splashTexture.height/2;
		}
		
		
		private function removeSplash(e:flash.events.Event):void
		{
			_starlingFramework.stage3D.removeEventListener(starling.events.Event.CONTEXT3D_CREATE, removeSplash);
			stage.removeEventListener(flash.events.Event.RESIZE, centerSplash);
			this.removeChild(_splashTexture);
		}
	}
}