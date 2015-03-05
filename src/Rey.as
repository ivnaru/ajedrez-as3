package 
{	
	public class Rey extends Ficha
	{
		private var filaOriginal:uint;
		private var fueMovido:Boolean;
		
		public function Rey( bando:Boolean, filaOriginal:uint ) 
		{
			super( bando );
			this.filaOriginal = filaOriginal;
		}
		
		override public function mover( filaI:uint, columnaI:uint, filaF:uint, columnaF:uint, tablero:Ajedrez ):Boolean
		{
			var fichaF:Ficha = tablero.getCasillas()[filaF][columnaF].getFicha();
			if( ( ((( filaI == filaF && Math.abs(columnaI - columnaF) == 1 ) || ( columnaI == columnaF && Math.abs(filaI-filaF) == 1 ) || ( Math.abs(columnaI-columnaF) == 1 && Math.abs(filaI-filaF) == 1 )) && !tablero.getCasillas()[filaF][columnaF].esAtacada(super.getBando(), tablero, 1, 0, 0)) ||
				 ((!fueMovido && columnaF == columnaI-2 && filaI == filaOriginal && filaOriginal == filaF) || (!fueMovido && columnaF == columnaI+2 && filaOriginal == filaF && filaF == filaI) )) &&
				 (fichaF == null || fichaF.getBando() != super.getBando()) )
			{
				if( columnaF == columnaI-2 )
				{
					var ficha:Ficha = tablero.getCasillas()[filaOriginal][0].getFicha();
					if ( ficha is Torre && !Torre(ficha).getFueMovida() && tablero.getCasillas()[filaOriginal][1].getFicha() == null && tablero.getCasillas()[filaOriginal][2].getFicha() == null && tablero.getCasillas()[filaOriginal][3].getFicha() == null && !caminoAtacado( tablero, -2, super.getBando() ) )
					{
						if ( super.getBando() && tablero.getBlancasEnJaque() ) return false;
						else if ( super.getBando() == false && tablero.getNegrasEnJaque() ) return false;
						moverTorre( tablero, 0, 3 );
					}
					else return false; 
				}
				else if( columnaF == columnaI+2 )
				{
					var ficha1:Ficha = tablero.getCasillas()[filaOriginal][7].getFicha();
					if ( ficha1 is Torre && !Torre(ficha1).getFueMovida() && tablero.getCasillas()[filaOriginal][5].getFicha() == null && tablero.getCasillas()[filaOriginal][6].getFicha() == null && !caminoAtacado( tablero, 2, super.getBando() ) )
					{
						if ( super.getBando() && tablero.getBlancasEnJaque() ) return false;
						else if ( super.getBando() == false && tablero.getNegrasEnJaque() ) return false;
						moverTorre( tablero, 7, 5 );
					}
					else return false;
				}
				if ( super.getBando() ) tablero.setReyBlanco( filaF, columnaF );
				else tablero.setReyNegro( filaF, columnaF );
				return fueMovido = true;
			}
			else return false;
		}
		
		private function moverTorre( tablero:Ajedrez, columnaI:uint, columnaF:uint  )
		{
			tablero.getCasillas()[filaOriginal][columnaI].setFicha( null );
			tablero.getCasillas()[filaOriginal][columnaI].getChildAt( 0 ).gotoAndStop( 1 );
			tablero.getCasillas()[filaOriginal][columnaF].setFicha( new Torre( super.getBando() ) );
			if( super.getBando() ) tablero.getCasillas()[filaOriginal][columnaF].getChildAt( 0 ).gotoAndStop( 4 );
			else tablero.getCasillas()[filaOriginal][columnaF].getChildAt( 0 ).gotoAndStop( 5 );
		}
		
		// Verifica si las casillas intermedias del enroque están atacadas.
		private function caminoAtacado( tablero:Ajedrez, indicador:int, bando:Boolean ):Boolean
		{
			if ( indicador == 2 ) // Si el enroque es en flanco de rey
			{
				if ( bando ) // Si es de las blancas
				{
					// Verificando si las casillas por las que pasarà el rey no estèn atacadas
					if( tablero.getCasillas()[7][5].esAtacada( bando, tablero, 1, 0, 0 ) ) return true;
					if( tablero.getCasillas()[7][6].esAtacada( bando, tablero, 1, 0, 0 ) ) return true;
				}
				else // Negras
				{
					if( tablero.getCasillas()[0][5].esAtacada( bando, tablero, 1, 0, 0 ) ) return true;
					if( tablero.getCasillas()[0][6].esAtacada( bando, tablero, 1, 0, 0 ) ) return true;
				}
			}
			else // Si es en flanco de dama
			{
				if ( bando )
				{
					if( tablero.getCasillas()[7][3].esAtacada( bando, tablero, 1, 0, 0 ) ) return true;
					if( tablero.getCasillas()[7][2].esAtacada( bando, tablero, 1, 0, 0 ) ) return true;
				}
				else
				{
					if( tablero.getCasillas()[0][3].esAtacada( bando, tablero, 1, 0, 0 ) ) return true;
					if ( tablero.getCasillas()[0][2].esAtacada( bando, tablero, 1, 0, 0 ) ) return true;
				}
			}
			return false;
		}
	}
}