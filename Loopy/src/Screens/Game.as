package Screens
{
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		private var _mainMenu:MainMenu;
		
		public function Game()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			_mainMenu = new MainMenu();
			this.addChild(_mainMenu);
			_mainMenu.initialize();
		}
	}
}