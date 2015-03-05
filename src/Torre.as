package 
{	
	public class Torre extends Ficha
	{
		private var fueMovida:Boolean;
		
		public function Torre( bando:Boolean )
		{
			super( bando );
		}
		
		override public function mover( filaI:uint, columnaI:uint, filaF:uint, columnaF:uint, tablero:Ajedrez ):Boolean
		{
			if( columnaI == columnaF )
			{
				if( filaI > filaF ) return verificarMovimiento( filaI, columnaI, filaF, columnaF, -1, 0, tablero, true );
				else return verificarMovimiento( filaI, columnaI, filaF, columnaF, 1, 0, tablero, true );
			}
			else if( filaI == filaF )
			{
				if( columnaI > columnaF ) return verificarMovimiento( filaI, columnaI, filaF, columnaF, 0, -1, tablero, false );
				else return verificarMovimiento( filaI, columnaI, filaF, columnaF, 0, 1, tablero, false );
			}
			else return false;
		}
		
		private function verificarMovimiento( filaI:uint, columnaI:uint, filaF:uint, columnaF:uint, pasoF:int, pasoC:int, tablero:Ajedrez, dir:Boolean ):Boolean
		{
			if ( super.getBando() && tablero.getBlancasEnJaque() ) // Verifica si su rey està en jaque y es posible mover
			{
				if ( movimientoEnJaque( filaI, columnaI, filaF, columnaF, tablero, true, tablero.getReyBlanco().x, tablero.getReyBlanco().y ) == false )
				return false;
			}
			else if ( super.getBando() == false && tablero.getNegrasEnJaque() )
			{
				if ( movimientoEnJaque( filaI, columnaI, filaF, columnaF, tablero, false, tablero.getReyNegro().x, tablero.getReyNegro().y ) == false )
				return false;
			}
			if( filaI != filaF || columnaI != columnaF ) // Si la casilla de destino no es la inicial
			{
				var esPosible:Boolean = true;
				// Verifica las casillas intermedias entre la inicial y final, si hay una ficha no sera posible mover
				if ( dir ) // dir == true: movimiento vertical
				{
					for( var f:uint = filaI+pasoF; f != filaF; f=f+pasoF)
					{
						if( tablero.getCasillas()[f][columnaI].getFicha() != null )
						{
							f = filaF-pasoF;
							esPosible = false;
						}
					}
				}
				else
				{
					for( var c:uint = columnaI+pasoC; c != columnaF; c=c+pasoC)
					{
						if( tablero.getCasillas()[filaI][c].getFicha() != null )
						{
							c = columnaF-pasoC;
							esPosible = false;
						}
					}
				}
				// Si no hay fihcas intermedias y... no hay ficha en la casilla final, o la ficha de la casilla final es del otro bando, serà posible mover
				if( esPosible && !super.estaClavada( tablero, filaI, columnaI, filaF, columnaF ) && (tablero.getCasillas()[filaF][columnaF].getFicha() == null || tablero.getCasillas()[filaF][columnaF].getFicha().getBando() != super.getBando()) ) return fueMovida = true;
				else return false;	
			}
			else return false;
		}
		
		public function getFueMovida():Boolean {return fueMovida;}
	}
}