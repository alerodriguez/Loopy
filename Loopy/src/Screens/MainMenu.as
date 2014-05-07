package Screens
{	
	import Assets.AssetsManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class MainMenu extends Sprite
	{
		private var _bg:Image;

		public function MainMenu()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			drawScreen();
		}
		
		private function drawScreen():void
		{
			_bg = new Image(AssetsManager.getTexture("background_01"));
			this.addChild(_bg);
		}
		
		public function initialize():void
		{
			this.visible = true;
		}
	}
}