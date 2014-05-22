package States
{
	
	import StateMachine.FSM;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		private var _mainMenu:MainMenuState;
		private var _game:GameState;
		private var _fSMManager:FSM;
		
		public function Game()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			_fSMManager = new FSM(this);
			
			_mainMenu = new MainMenuState("MainMenu", _fSMManager, this);
			_game = new GameState("Game", _fSMManager, this);
			
			_fSMManager.addState(_mainMenu, true);
			_fSMManager.addState(_game);
			
			_fSMManager.addTransition(_mainMenu, _game, _mainMenu.onEnterClicked);
			_fSMManager.addTransition(_game, _mainMenu, _game.onIsGameEnded);
		}
	}
}