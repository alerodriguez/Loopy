package States
{	
	import Assets.AssetsManager;
	
	import MainMenu.MainMenuLevelSlider;
	
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
		private const TITTLE_TEXT:String = "LOOPY";
		
		private var _isClickedEnter:Boolean = false;
		private var _titleTextField:TextField;
		
		private var _levelSlider:MainMenuLevelSlider;

		public function MainMenuState(name:String, parentFSM:FSM, scene:Sprite)
		{
			super(name, parentFSM, scene);
			
			AssetsManager.registerBitmapFont(FONT_NAME);
			
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
			_levelSlider = new MainMenuLevelSlider(onButtonStartDown);
			_scene.addChild(_levelSlider);
		}
		
		private function destroyMenu():void
		{
			_scene.removeChild(_levelSlider);
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