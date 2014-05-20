package States
{	
	import Assets.AssetsManager;
	
	import MainMenu.MainMenuLevel;
	
	import StateMachine.FSM;
	import StateMachine.State;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class MainMenuState extends State
	{
		private const FONT_NAME:String = "PixelSplitter";
		private const CONFIG_XML:String = "BoardsConfigXML";
		private const TITTLE_TEXT:String = "LOOPY";
		
		private var _isClickedEnter:Boolean = false;
		private var _titleTextField:TextField;
		private var _mainMenuConfig:XML;
		
		private var _temporalLevel:MainMenuLevel;

		public function MainMenuState(name:String, parentFSM:FSM, scene:Sprite)
		{
			super(name, parentFSM, scene);
			
			AssetsManager.registerBitmapFont(FONT_NAME);
			_mainMenuConfig = AssetsManager.getXML(CONFIG_XML);
			
			_titleTextField = new TextField(1000, 1000, "", FONT_NAME, 30, 0x000000);
			_titleTextField.batchable = true;
			_titleTextField.vAlign = VAlign.TOP;
			_titleTextField.hAlign = HAlign.CENTER;
		}
		
		public override function onEnter():void
		{
			_scene.addChild(_titleTextField);
			
			ResolutionController.dockObject(_titleTextField, ResolutionController.CENTER, 0, ResolutionController.TOP, 50);
			
			_titleTextField.text = TITTLE_TEXT;
			createMenu();
		}
		
		private function createMenu():void
		{
			var id:String = _mainMenuConfig.child("board")[0].@id;
			var name:String = _mainMenuConfig.child("board")[0].@name;
			var scores:Array = new Array();
			
			for each (var score:XML in _mainMenuConfig.child("board")[0].child("score"))
			{
				scores.push(score.@value);
			}
			
			_temporalLevel = new MainMenuLevel(id, name, scores, onButtonStartDown);
			_scene.addChild(_temporalLevel);
			
			ResolutionController.dockObject(_temporalLevel, ResolutionController.CENTER, 0, ResolutionController.CENTER, -50);
		}
		
		private function destroyMenu():void
		{
			_scene.removeChild(_temporalLevel);
		}
		
		public override function onExit():void
		{
			destroyMenu();
			
			_scene.removeChild(_titleTextField);
			_isClickedEnter = false;
		}
		
		private function onButtonStartDown(event:Event):void
		{
			_isClickedEnter = true;
		}
		
		public function onEnterClicked():Boolean
		{
			return _isClickedEnter;
		}
	}
}