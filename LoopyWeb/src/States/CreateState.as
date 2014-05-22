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
	
	public class CreateState extends State
	{
		private const FONT_NAME:String = "PixelSplitter";
		private const TITTLE_TEXT:String = "Create";
		private const ATLAS:String = "ButtonAtlas";
		private const LEFT_TEXTURE:String = "008";
		
		private var _saved:Boolean = false;
		
		private var _titleTextField:TextField;
		private var _saveBtn:Button;
		
		public function CreateState(name:String, parentFSM:FSM, scene:Sprite)
		{
			super(name, parentFSM, scene);
			_titleTextField = new TextField(500, 200, "", FONT_NAME, 30, 0x000000);
			_titleTextField.batchable = true;
			_titleTextField.vAlign = VAlign.TOP;
			_titleTextField.hAlign = HAlign.CENTER;
		}		
		
		public override function onEnter():void
		{
			_saveBtn = new Button(AssetsManager.getAtlas(ATLAS).getTexture(LEFT_TEXTURE), "");
			_saveBtn.addEventListener(Event.TRIGGERED, onSaveButtonDown);
			
			_scene.addChild(_titleTextField);
			_scene.addChild(_saveBtn);
			_titleTextField.text = TITTLE_TEXT;
			
			ResolutionController.dockObject(_saveBtn, ResolutionController.CENTER, 0, ResolutionController.CENTER, 200);
			ResolutionController.dockObject(_titleTextField, ResolutionController.CENTER, 0, ResolutionController.CENTER, -200);
		}
		
		public override function onExit():void
		{
			_scene.removeChild(_titleTextField);
			_scene.removeChild(_saveBtn);
			
			_saved = false;
		}
		
		private function onSaveButtonDown(event:Event):void
		{
			_saved = true;
			_saveBtn.removeEventListener(Event.TRIGGERED, onSaveButtonDown);
		}
		
		public function isSaved():Boolean
		{
			return _saved;
		}
	}
}