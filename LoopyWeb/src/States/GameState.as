package States
{	
	import Assets.AssetsManager;
	
	import Board.Board;
	
	import StateMachine.FSM;
	import StateMachine.State;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class GameState extends State
	{
		private var _bg:Image;
		private var _isClickedEnter:Boolean = false;
		private var _board:Board;

		public function GameState(name:String, parentFSM:FSM, scene:Sprite)
		{
			super(name, parentFSM, scene);
			_bg = new Image(AssetsManager.getAtlas("mainAtlas").getTexture("001"));
			_board = new Board();
		}
		
		public override function onEnter():void
		{
			_scene.addChild(_bg);
			_scene.addChild(_board);
			
			ResolutionController.dockObject(_board, ResolutionController.CENTER, 0, ResolutionController.CENTER, 0);
			
			_bg.addEventListener(starling.events.TouchEvent.TOUCH, onTouch);
		}
		
		public override function onExit():void
		{
			_scene.removeChild(_bg);
			_isClickedEnter = false;
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_scene);
			if(touch != null && touch.phase == TouchPhase.ENDED)
			{
				_isClickedEnter = true;
				_scene.removeEventListener(starling.events.TouchEvent.TOUCH, onTouch);
			}
		}
		
		public function onEnterClicked():Boolean
		{
			return _isClickedEnter;
		}
	}
}