package Board
{
	import starling.display.DisplayObjectContainer;

	public class Board extends DisplayObjectContainer
	{
		
		private var _selectedSquare:Square = null;
		private var _isPaused:Boolean = false;
		private var _squares:Array;
		private var _cicle:Array;
		private var _percentageCompleted:Number = 0;
		private var _vPenalization:Number;
		private var _hPenalization:Number;
		private var _goldenPrize:Number;
		private var _goldenPenalization:Number;
		private var _normalPrize:Number;
		private var _normalPenalization:Number;
		private var _score:Number;
		
		public function get IsPaused():Boolean
		{
			return _isPaused;
		}
		
		public function set IsPaused(value:Boolean):void
		{
			_isPaused = value;
		}
		
		public function Board()
		{
			_vPenalization = -1;
			_hPenalization = -3;
			_goldenPrize = 25;
			_goldenPenalization = -25;
			_normalPrize = 5;
			_normalPenalization = -7;
			
			_score = 0;
			
			Initialize();
		}
		
		private function Initialize():void
		{
			_squares = new Array();
			
			for (var i:int = 0; i < 8; i++) 
			{
				for (var j:int = 0; j < 8; j++) 
				{
					_squares.push(new Square(this, i, j, Math.floor(Math.random()*3)));
				}
				
			}
		}
		
		public function TapSquare(square:Square):void
		{
			if(_selectedSquare == null)
			{
				_selectedSquare = square;
				_selectedSquare.Select();
			}
			else if(_selectedSquare == square)
			{
				_selectedSquare.DeSelect();
				_selectedSquare = null;
			}
			else if(!isAdjacent(_selectedSquare, square))
			{
				_selectedSquare.DeSelect();
				_selectedSquare = square;
				_selectedSquare.Select();
			}
			else
			{
				_selectedSquare.DeSelect();
				moveSquares(_selectedSquare, square);
				_selectedSquare = null;
			}
		}
		
		private function isAdjacent(firstSquare:Square, secondSquare:Square):Boolean
		{
			var xDistance:Number = Math.abs(firstSquare.XPosition - secondSquare.XPosition);
			var yDistance:Number = Math.abs(firstSquare.YPosition - secondSquare.YPosition);
			return (xDistance + yDistance == 1);
		}
		
		private function moveSquares(currentSquare:Square, otherSquare:Square):void
		{
			var isCurrAtCicle:Boolean = isAtCycle(currentSquare);
			var isOtherAtCicle:Boolean = isAtCycle(otherSquare);
			var score:Number = currentSquare.XPosition == otherSquare.XPosition ? _hPenalization : _vPenalization;
			
			var currXPos:Number = currentSquare.XPosition;
			var currYPos:Number = currentSquare.YPosition;
			var otherXPos:Number = otherSquare.XPosition;
			var otherYPos:Number = otherSquare.YPosition;
			
			if((isCurrAtCicle && !isOtherAtCicle) || (!isCurrAtCicle && isOtherAtCicle))
			{
				score += isCurrAtCicle ? getPenalization(currentSquare) : getPrize(currentSquare);
				score += isOtherAtCicle ? getPenalization(otherSquare) : getPrize(currentSquare);
			}
			
			_score += score;
			trace("Score: " + _score);
			
			currentSquare.MoveTo(otherXPos, otherYPos);
			otherSquare.MoveTo(currXPos, currYPos);
		}
		
		private function getPenalization(square:Square):Number
		{
			var score:Number = 0;
			switch(square.Type)
			{
				case SquareType.GOLDEN:
					score = _goldenPenalization
					break;
					
				case SquareType.RIGHT:
					score = _normalPenalization
					break;
				default:
					break;
			}
			return score;
		}
		
		private function getPrize(square:Square):Number
		{
			var score:Number = 0;
			switch(square.Type)
			{
				case SquareType.GOLDEN:
					score = _goldenPrize
					break;
				
				case SquareType.RIGHT:
					score = _normalPrize
					break;
				default:
					break;
			}
			return score;
		}
		
		private function isAtCycle(square:Square):Boolean
		{
			return false;
		}
	}
}