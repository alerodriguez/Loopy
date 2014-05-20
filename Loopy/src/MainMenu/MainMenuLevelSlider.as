package MainMenu
{
	import Assets.AssetsManager;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	
	public class MainMenuLevelSlider extends DisplayObjectContainer
	{
		private const SCORE_CHILD:String = "score";
		private const LEVEL_WIDTH:Number = 500;
		private const LEVEL_PADDING:Number = 100;
		private const X_PADDING:Number = 350;
		private const Y_PADDING:Number = 200;
		
		private const ATLAS:String = "SquareAtlas";
		private const UP_TEXTURE:String = "001";
		
		private var _levels:Array;
		private var _onButtonStartDown:Function;
		
		private var _backButton:Button;
		private var _nextButton:Button;
		
		private var _index:Number = 0;
		
		public function MainMenuLevelSlider(onButtonStartDown:Function)
		{
			super();
			_onButtonStartDown = onButtonStartDown;
			_levels = new Array();
			initialize();
		}
		
		private function initialize():void
		{
			var index:Number = 0; 
			for each (var level:XML in MainMenuXMLManager.getInstance().BoardChilds) 
			{
				addLevel(level);
				if(_levels.length > index)
				{
					_levels[index].x = LEVEL_PADDING + (index * (LEVEL_PADDING + Starling.current.stage.stageWidth));
				}
				index++;
			}
			
			addButtons();
			
			this.x = Starling.current.stage.stageWidth / 2 - X_PADDING;
			this.y = Starling.current.stage.stageHeight / 2 - Y_PADDING;
		}
		
		private function addLevel(level:XML):void
		{
			var id:String = level.@id;
			var name:String = level.@name;
			var scores:Array = new Array();
			
			for each (var score:XML in level.child(SCORE_CHILD))
			{
				scores.push(score.@value);
			}
			
			var mainMenuLevel:MainMenuLevel = new MainMenuLevel(id, name, scores, _onButtonStartDown);
			
			_levels.push(mainMenuLevel);
			this.addChild(mainMenuLevel);
		}
		
		private function addButtons():void
		{
			_backButton = new Button(AssetsManager.getAtlas(ATLAS).getTexture(UP_TEXTURE), "");
			_nextButton = new Button(AssetsManager.getAtlas(ATLAS).getTexture(UP_TEXTURE), "");
			
			_backButton.addEventListener(Event.TRIGGERED, onBackButtonDown);
			_nextButton.addEventListener(Event.TRIGGERED, onNextButtonDown);
			
			_backButton.y = this.height / 2 - _backButton.height;
			_nextButton.y = this.height / 2 - _nextButton.height;
			_backButton.x = 25;
			_nextButton.x = X_PADDING * 2 - _nextButton.width - 25;
			
			_backButton.enabled = false;
			
			this.addChild(_backButton);
			this.addChild(_nextButton);
		}
		
		private function onBackButtonDown(event:Event):void
		{
			_index -= 1;
			if(_index < 1) _backButton.enabled = false;
			if(_levels.length > _index) _nextButton.enabled = true;
			moveToIndex(_index);
		}
		
		private function onNextButtonDown(event:Event):void
		{
			_index += 1;
			if(_levels.length - 2 < _index) _nextButton.enabled = false;
			if(_index > 0) _backButton.enabled = true;
			moveToIndex(_index);
		}
		
		private function moveToIndex(index:Number):void
		{
			for each (var level:MainMenuLevel in _levels) 
			{
				level.x = LEVEL_PADDING + (-index * (LEVEL_PADDING + Starling.current.stage.stageWidth));
				index--;
			}
		}
	}
}