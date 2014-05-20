package Board
{
	import Assets.AssetsManager;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Square extends DisplayObjectContainer
	{
		private const ATLAS:String = "SquareAtlas";
		private const GOLDEN_TEXTURE:String = "000";
		private const RIGHT_TEXTURE:String = "001";
		private const WRONG_TEXTURE:String = "002";
		private const PADDING_OFFSET:Number = 2;
		
		private var _parent:Board;
		private var _xPosition:Number;
		private var _yPosition:Number;
		private var _type:int;
		private var _squareImage:Image;
		private var _isCorrect:Boolean;
		
		
		public function get XPosition():Number
		{
			return _xPosition;
		}
		
		public function set XPosition(value:Number):void
		{
			_xPosition = value;
		}
		
		public function get YPosition():Number
		{
			return _yPosition;
		}
		
		public function set YPosition(value:Number):void
		{
			_yPosition = value;
		}
		
		public function get Type():int
		{
			return _type;
		}
		
		public function set Type(value:int):void
		{
			_yPosition = _type;
		}
		
		public function get IsCorrect():Boolean
		{
			return _isCorrect;
		}
		
		public function set IsCorrect(value:Boolean):void
		{
			_isCorrect = value;
		}
		
		public function Square(parent:Board, xPosition:Number, yPosition:Number, type:int, isCorrect:Boolean = false)
		{
			_parent = parent;
			_xPosition = xPosition;
			_yPosition = yPosition;
			_type = type;
			_isCorrect = isCorrect;
			
			Initialize();
		}
		
		private function Initialize():void
		{
			switch(_type)
			{
				case SquareType.GOLDEN:
					_squareImage = new Image(AssetsManager.getAtlas(ATLAS).getTexture(GOLDEN_TEXTURE));
					break;
					
				case SquareType.RIGHT:
					_squareImage = new Image(AssetsManager.getAtlas(ATLAS).getTexture(RIGHT_TEXTURE));
					break;
					
				default:
					_squareImage = new Image(AssetsManager.getAtlas(ATLAS).getTexture(WRONG_TEXTURE));
					break;
			}
			
			_parent.addChild(this);
			this.addChild(_squareImage);
			this.x = _squareImage.width * _xPosition + PADDING_OFFSET * (_xPosition - 1);
			this.y = _squareImage.height * _yPosition + PADDING_OFFSET * (_yPosition - 1);
			
			this.addEventListener(starling.events.TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if(touch != null && touch.phase == TouchPhase.ENDED)
			{
				_parent.TapSquare(this);
			}
		}
		
		public function Select():void
		{
			_squareImage.alpha = 0.5;
		}
		
		public function DeSelect():void
		{
			_squareImage.alpha = 1.0;
		}
		
		public function MoveTo(xPosition:Number, yPosition:Number):void
		{
			_parent.IsPaused = true;
			_xPosition = xPosition;
			_yPosition = yPosition;
			_parent.IsPaused = false;
			
			this.x = _squareImage.width * _xPosition + PADDING_OFFSET * (_xPosition - 1);
			this.y = _squareImage.height * _yPosition + PADDING_OFFSET * (_yPosition - 1);
		}
	}
}