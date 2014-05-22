package States
{
	import Assets.AssetsManager;
	
	import StateMachine.FSM;
	import StateMachine.State;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	import utils.ResolutionController;
	
	public class SplashState extends State
	{
		private const FONT_NAME:String = "PixelSplitter";
		private const TITTLE_TEXT:String = "LOOPY";
		private const ATLAS:String = "ButtonAtlas";
		private const LEFT_TEXTURE:String = "008";
		
		private var _create:Boolean = false;
		private var _play:Boolean = false;
		
		private var _titleTextField:TextField;
		private var _playBtn:Button;
		private var _createBtn:Button;
		
		public function SplashState(name:String, parentFSM:FSM, scene:Sprite)
		{
			super(name, parentFSM, scene);
			_titleTextField = new TextField(500, 200, "", FONT_NAME, 30, 0x000000);
			_titleTextField.batchable = true;
			_titleTextField.vAlign = VAlign.TOP;
			_titleTextField.hAlign = HAlign.CENTER;
		}		
		
		public override function onEnter():void
		{
			_playBtn = new Button(AssetsManager.getAtlas(ATLAS).getTexture(LEFT_TEXTURE), "");
			_createBtn = new Button(AssetsManager.getAtlas(ATLAS).getTexture(LEFT_TEXTURE), "");
			_playBtn.addEventListener(Event.TRIGGERED, onPlayButtonDown);
			_createBtn.addEventListener(Event.TRIGGERED, onCreateButtonDown);
			
			_scene.addChild(_titleTextField);
			_scene.addChild(_playBtn);
			_scene.addChild(_createBtn);
			_titleTextField.text = TITTLE_TEXT;
			
			ResolutionController.dockObject(_playBtn, ResolutionController.CENTER, -_playBtn.width - 50, ResolutionController.CENTER, 0);
			ResolutionController.dockObject(_createBtn, ResolutionController.CENTER, _createBtn.width + 50, ResolutionController.CENTER, 0);
			ResolutionController.dockObject(_titleTextField, ResolutionController.CENTER, 0, ResolutionController.TOP, 150);
		}
		
		public override function onExit():void
		{
			_scene.removeChild(_titleTextField);
			_scene.removeChild(_playBtn);
			_scene.removeChild(_createBtn);
			
			_create = false;
			_play = false;
		}
		
		private function onPlayButtonDown(event:Event):void
		{
			_play = true;
			_playBtn.removeEventListener(Event.TRIGGERED, onPlayButtonDown);
			_createBtn.removeEventListener(Event.TRIGGERED, onCreateButtonDown);
		}
		
		private function onCreateButtonDown(event:Event):void
		{
			_create = true;
			_playBtn.removeEventListener(Event.TRIGGERED, onPlayButtonDown);
			_createBtn.removeEventListener(Event.TRIGGERED, onCreateButtonDown);
		}
		
		public function play():Boolean
		{
			return _play;
		}
		
		public function create():Boolean
		{
			return _create;
		}
	}
}