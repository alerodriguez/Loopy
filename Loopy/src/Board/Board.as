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
		
		//Variables para cada tabla de juego
		private var _MinimoCompletado:Number = 50;
		private var _MaximoCompletado:Number = 60;
		private var _PuntajeInicial:Number = 200;
		private var _CantidadActual:Number = 0;
		private var _EspacioCorrecto:Number = 16;
		private var _tablaInicial:Array =
			[
				[0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0],
				[0,0,1,1,1,1,0,0],
				[0,0,1,1,1,1,0,0],
				[0,0,1,1,1,1,0,0],
				[0,0,1,1,1,1,0,0],
				[0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0]
			]
		
		
		
		public function FillBoard():void
		{
			_squares = new Array();
			//Cantidad de fichas dentro de la zona correcta (cantidad minima + random entre la diferencia del minimo y maximo
			var _CantidadDentro:Number = Math.floor(_EspacioCorrecto*(_MinimoCompletado/100)) + Math.floor(Math.random()*(_EspacioCorrecto*((_MaximoCompletado-_MinimoCompletado)/100)));
			var _CantidadFuera:Number = _EspacioCorrecto - _CantidadDentro + Math.floor(Math.random()*5);
			var _ProbCorrectaFuera:Number = (100/(64 - _EspacioCorrecto)) * _CantidadFuera;
			var _ProbCorrectaDentro:Number = (100 / _EspacioCorrecto) * _CantidadDentro;
			var _EspacioCorrectoRestante:Number = _EspacioCorrecto;
			var _EspacioIncorrectoRestante:Number = 64 - _EspacioCorrecto;
			var _IsCorrect:Boolean;
			for (var i:int = 0; i < 8; i++) 
			{
				for (var j:int = 0; j < 8; j++) 
				{
					_IsCorrect = _tablaInicial[i][j];
					if(_IsCorrect) //está en la misma fila
					{
						_EspacioCorrectoRestante--;
						if(_CantidadDentro <= 0)
						{
							_squares.push(new Square(this, i, j, 2));
							continue;
						}
						if(_CantidadDentro > _EspacioCorrectoRestante)
						{
							_squares.push(new Square(this, i, j, 1, true));
							_CantidadDentro--;
							continue;
						}
						if(Math.random() <= (_ProbCorrectaDentro/100))
						{
							_squares.push(new Square(this, i, j, 1, true));
							_CantidadDentro--;
						}
						else
						{
							_squares.push(new Square(this, i, j, 2));
						}
					}
					else
					{
						_EspacioIncorrectoRestante--;
						if(_CantidadFuera <= 0)
						{
							_squares.push(new Square(this, i, j, 2));
							continue;
						}
						if(_CantidadFuera > _EspacioIncorrectoRestante)
						{
							_squares.push(new Square(this, i, j, 1, true));
							_CantidadFuera--;
							continue;
						}
						if(Math.random() <= (_ProbCorrectaFuera/100))
						{
							_squares.push(new Square(this, i, j, 1, true));
							_CantidadFuera--;
						}
						else
						{
							_squares.push(new Square(this, i, j, 2));
						}
					}
				}
			}
		}
		
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
			
			//Initialize();
			FillBoard();
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