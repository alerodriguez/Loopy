package MainMenu
{
	import Assets.AssetsManager;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class MainMenuLevel extends DisplayObjectContainer
	{
		private const ATLAS:String = "SquareAtlas";
		private const UP_TEXTURE:String = "001";
		private const DISABLED_TEXTURE:String = "002";
		
		private const SCORES_OFFSET:Number = 40;
		private const SCORES_PADDING:Number = 50;
		
		private const BUTTON_X_OFFSET:Number = 50;
		private const BUTTON_Y_OFFSET:Number = 50;
		
		private var _id:String;
		private var _name:String;
		private var _scores:Array;
		private var _startHandler:Function;
		private var _editHandler:Function;
		private var _editable:Boolean;
		
		private var _nameTextField:TextField;
		private var _scoresTextFields:Array;
		private var _startButton:Button;
		private var _editButton:Button;
		
		public function MainMenuLevel(id:String, name:String, scores:Array, startHandler:Function, editHandler:Function = null, editable:Boolean = false)
		{
			super();
			_id = id;
			_name = name;
			_scores = scores;
			_startHandler = startHandler;
			_editHandler = editHandler;
			_editable = editable;
			
			initialize();
		}
		
		private function initialize():void
		{
			_nameTextField = new TextField(500, 100, _name, "font", 30, 0x000000);
			_nameTextField.batchable = true;
			_nameTextField.vAlign = VAlign.TOP;
			_nameTextField.hAlign = HAlign.CENTER;
			this.addChild(_nameTextField);
			
			_scoresTextFields = new Array();
			for (var index:int = 0; index < _scores.length; index++)
			{
				var scoreText:String = (index + 1) + " Lugar: " + _scores[index].toString()
				_scoresTextFields.push(new TextField(500, 40, scoreText, "font", 30, 0x000000));
				_scoresTextFields[index].batchable = true;
				_scoresTextFields[index].vAlign = VAlign.TOP;
				_scoresTextFields[index].hAlign = HAlign.LEFT;
				_scoresTextFields[index].y = SCORES_PADDING + index * SCORES_OFFSET;
				this.addChild(_scoresTextFields[index]);
			}
			
			_startButton = new Button(AssetsManager.getAtlas(ATLAS).getTexture(UP_TEXTURE), "Iniciar");
			_editButton = new Button(AssetsManager.getAtlas(ATLAS).getTexture(UP_TEXTURE), "Editar");
			_editButton.enabled = _editable;
			
			_editButton.x = BUTTON_X_OFFSET;
			_startButton.x = this.width - BUTTON_X_OFFSET - _startButton.width;
			_editButton.y = this.height + BUTTON_Y_OFFSET;
			_startButton.y = this.height + BUTTON_Y_OFFSET;
			
			_startButton.addEventListener(Event.TRIGGERED, _startHandler);
			_editButton.addEventListener(Event.TRIGGERED, _editHandler);
			
			this.addChild(_editButton);
			this.addChild(_startButton);
		}
	}
}