package States
{	
	import Assets.AssetsManager;
	
	import StateMachine.FSM;
	import StateMachine.State;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class GameState extends State
	{
		private var _bg:Image;
		private var _isClickedEnter:Boolean = false;

		public function GameState(name:String, parentFSM:FSM, scene:Sprite)
		{
			super(name, parentFSM, scene);
			_bg = new Image(AssetsManager.getTexture("background_02"));
		}
		
		public override function onEnter():void
		{
			_scene.addChild(_bg);
			_scene.addEventListener(starling.events.TouchEvent.TOUCH, onTouch);
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