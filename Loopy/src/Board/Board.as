package Board
{	
	import starling.display.DisplayObjectContainer;

	public class Board extends DisplayObjectContainer
	{
		
		private var _selectedSquare:Square = null;
		private var _isPaused:Boolean = false;
		private var _squares:Array;
		private var _percentageCompleted:Number = 0;
		private var _vPenalization:Number;
		private var _hPenalization:Number;
		private var _goldenPrize:Number;
		private var _goldenPenalization:Number;
		private var _normalPrize:Number;
		private var _normalPenalization:Number;
		private var _score:Number;
		private var _changeTextFunction:Function;
		
		//Variables para cada tabla de juego
		private var _minCompletionPercentage:Number = 50;
		private var _maxCompletionPercentage:Number = 60;
		private var _CantidadActual:Number = 0;
		private var _completionTableSize:Number = 16;
		private var _completionTable:Array;
		
		public function get IsPaused():Boolean
		{
			return _isPaused;
		}
		
		public function set IsPaused(value:Boolean):void
		{
			_isPaused = value;
		}
		
		public function get Score():Number
		{
			return _score;
		}
		
		public function get Percentage():Number
		{
			return _percentageCompleted;
		}
		
		public function Board(changeTextFunction:Function)
		{
			_changeTextFunction = changeTextFunction;	
			Initialize();
		}
		
		private function Initialize():void
		{
			var table:Object = BoardConfigurationManager.getInstance().getLevel();
			
			_vPenalization = table.verticalPenalization;
			_hPenalization = table.horizontalPenalization;
			_goldenPrize = table.goldenPrize;
			_goldenPenalization = table.goldenPenalization;
			_normalPrize = table.normalPrize;
			_normalPenalization = table.normalPenalization;
			_score = table.initialScore;
			_minCompletionPercentage = table.minCompletionPercentage;
			_maxCompletionPercentage = table.maxCompletionPercentage;
			_completionTableSize = table.completionTableSize;
			_completionTable = table.completionTable;
			
			FillBoard();
			_percentageCompleted = getPercentage();
		}
		
		
		/**
		 * Codigo del mancorro
		 */
		
		public function FillBoard():void
		{
			_squares = new Array();
			//Cantidad de fichas dentro de la zona correcta (cantidad minima + random entre la diferencia del minimo y maximo
			var _CantidadDentro:Number = Math.floor(_completionTableSize*(_minCompletionPercentage/100)) + Math.floor(Math.random()*(_completionTableSize*((_maxCompletionPercentage-_minCompletionPercentage)/100)));
			var _CantidadFuera:Number = _completionTableSize - _CantidadDentro + Math.floor(Math.random()*5);
			var _ProbCorrectaFuera:Number = (100/(64 - _completionTableSize)) * _CantidadFuera;
			var _ProbCorrectaDentro:Number = (100 / _completionTableSize) * _CantidadDentro;
			var _EspacioCorrectoRestante:Number = _completionTableSize;
			var _EspacioIncorrectoRestante:Number = 64 - _completionTableSize;
			var _IsCorrect:Boolean;
			var _probTemp:Number;
			for (var i:int = 0; i < 8; i++) 
			{
				for (var j:int = 0; j < 8; j++) 
				{
					_IsCorrect = _completionTable[i][j];
					if(_IsCorrect) //está en la misma fila
					{
						_EspacioCorrectoRestante--;
						if(_CantidadDentro <= 0)
							_probTemp = 0;
						else if(_CantidadDentro > _EspacioCorrectoRestante)
							_probTemp = 100;
						else if(Math.random() <= (_ProbCorrectaDentro/100))
							_probTemp = _ProbCorrectaDentro;
						if(addSquare(i, j, _probTemp, true))
							_CantidadDentro--;
					}
					else
					{
						_EspacioIncorrectoRestante--;
						if(_CantidadFuera <= 0)
							_probTemp = 0;
						if(_CantidadFuera > _EspacioIncorrectoRestante)
							_probTemp = 100;
						if(Math.random() <= (_ProbCorrectaFuera/100))
							_probTemp = _ProbCorrectaFuera
						if(addSquare(i, j, _probTemp, false))
							_CantidadFuera--;
					}
				}
			}
		}
		
		public function addSquare(posX:Number, posY:Number, prob:Number, correct:Boolean):Boolean
		{
			if(Math.random() <= (prob/100))
			{
				_squares.push(new Square(this, posY, posX, 1, correct));
				return true;
			}
			else
			{
				_squares.push(new Square(this, posY, posX, 2, correct));
				return false;
			}
		}
		
		/**
		 * Fin del codigo del mancorro
		 */
		
		
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
			var isCurrAtCicle:Boolean = currentSquare.IsCorrect;
			var isOtherAtCicle:Boolean = otherSquare.IsCorrect;
			var score:Number = currentSquare.XPosition == otherSquare.XPosition ? _hPenalization : _vPenalization;
			
			var currXPos:Number = currentSquare.XPosition;
			var currYPos:Number = currentSquare.YPosition;
			var otherXPos:Number = otherSquare.XPosition;
			var otherYPos:Number = otherSquare.YPosition;
			
			if((isCurrAtCicle && !isOtherAtCicle) || (!isCurrAtCicle && isOtherAtCicle))
			{
				score += isCurrAtCicle ? getPenalization(currentSquare) : getPrize(currentSquare);
				score += isOtherAtCicle ? getPenalization(otherSquare) : getPrize(otherSquare);
			}
			
			_score += score;
			
			currentSquare.IsCorrect = isOtherAtCicle;
			otherSquare.IsCorrect = isCurrAtCicle;
			
			currentSquare.MoveTo(otherXPos, otherYPos);
			otherSquare.MoveTo(currXPos, currYPos);
			
			_percentageCompleted = getPercentage();
			_changeTextFunction();
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
		
		private function getPercentage():Number
		{
			var percentage:Number = 0;
			for each (var square:Square in _squares) 
			{
				if(square.IsCorrect && square.Type != SquareType.WRONG)
				{
					percentage++;
				}
			}
			
			return percentage * 100 / _completionTableSize;
		}
	}
}