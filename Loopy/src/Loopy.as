package
{	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import Screens.Game;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	[SWF(frameRate="60", width="1024", height="768", backgroundColor="0x000000")]
	public class Loopy extends Sprite
	{
		
		[Embed(source="../media/graphics/background_01.jpg")]
		public static const LOOPY_SPLASH:Class;
		
		private var myStarling:Starling;
		private var _splashTexture:Bitmap;
		
		public function Loopy()
		{
			
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING, onOrientationChanging);
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var screenWidth:int  = stage.fullScreenWidth;
			var screenHeight:int = stage.fullScreenHeight;
			var viewPort:Rectangle = new Rectangle(0, 0, screenWidth, screenHeight);
			
			myStarling = new Starling(Game, stage, viewPort);
			myStarling.stage3D.addEventListener(starling.events.Event.CONTEXT3D_CREATE, removeSplash);
			
			// Point: x: height, y: width
			var starlingResolution:Point = ResolutionController.adjustResolution();
			myStarling.stage.stageHeight  = starlingResolution.x;
			myStarling.stage.stageWidth   = starlingResolution.y;
			
			myStarling.antiAliasing = 1;
			myStarling.start();
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, onApplicationActive);
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, onApplicationDeactive);
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			
			addSlpash();
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
			myStarling.stage3D.removeEventListener(starling.events.Event.CONTEXT3D_CREATE, removeSplash);
			stage.removeEventListener(flash.events.Event.RESIZE, centerSplash);
			this.removeChild(_splashTexture);
		}
		
		protected function onOrientationChanging(event:StageOrientationEvent):void
		{
			switch(event.afterOrientation)
			{
				//keeps device locked in landscape mode
				case StageOrientation.DEFAULT:
				case StageOrientation.UPSIDE_DOWN:
					event.preventDefault();
					break;
				
				case StageOrientation.ROTATED_RIGHT:
				case StageOrientation.ROTATED_LEFT:
					//allow default
					break;
			}
		}
		
		
		protected function onApplicationActive(event:flash.events.Event):void
		{
			myStarling.start();
		}
		
		protected function onApplicationDeactive(event:flash.events.Event):void
		{
			myStarling.stop();
			stage.focus = null;
		}
	}
}