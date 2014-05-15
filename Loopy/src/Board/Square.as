package Board
{
	public class Square
	{
		private var _parent:Board;
		private var _xPosition:Number;
		private var _yPosition:Number;
		private var _type:int;
		
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
		
		public function Square(parent:Board, xPosition:Number, yPosition:Number, type:int)
		{
			_parent = parent;
			_xPosition = xPosition;
			_yPosition = yPosition;
			_type = type;
		}
		
		public function Select():void
		{
		}
		
		public function DeSelect():void
		{
		}
		
		public function MoveTo(xPosition:Number, yPosition:Number):void
		{
			_parent.IsPaused = true;
			_xPosition = xPosition;
			_yPosition = yPosition;
			_parent.IsPaused = false;
		}
	}
}