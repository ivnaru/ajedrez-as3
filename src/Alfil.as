package  
{
	public class Alfil extends Ficha
	{
		public function Alfil( bando:Boolean ) { super( bando ); }
		
		override public  function mover( filaI:uint, columnaI:uint, filaF:uint, columnaF:uint, tablero:Ajedrez ):Boolean
		{
			if( filaI+columnaI == filaF+columnaF )
			{
				if( filaI > filaF ) return verificarMovimiento( filaI, columnaI, filaF, columnaF, -1, 1, tablero );
				else return verificarMovimiento( filaI, columnaI, filaF, columnaF, 1, -1, tablero );
			}
			else if( filaI-columnaI == filaF-columnaF )
			{
				if( filaI > filaF ) return verificarMovimiento( filaI, columnaI, filaF, columnaF, -1, -1, tablero );
				else return verificarMovimiento( filaI, columnaI, filaF, columnaF, 1, 1, tablero );
			}
			else return false;
		}
		
		private function verificarMovimiento( filaI:uint, columnaI:uint, filaF:uint, columnaF:uint, pasoF:int, pasoC:int, tablero:Ajedrez ):Boolean
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
			} // termina la verificacion de jaque
			if( filaI != filaF && columnaI != columnaF )
			{
				var esPosible:Boolean = true;
				for( var f:uint = filaI+pasoF, c:uint = columnaI+pasoC; f != filaF, c != columnaF; f=f+pasoF, c=c+pasoC )
				{
					if( tablero.getCasillas()[f][c].getFicha() != null ) esPosible = ( f = filaF-pasoF, c = columnaF-pasoC, false );
				}
				if( esPosible && !super.estaClavada( tablero, filaI, columnaI, filaF, columnaF ) && (tablero.getCasillas()[f][c].getFicha() == null || tablero.getCasillas()[f][c].getFicha().getBando() != super.getBando()) ) return true;
				else return false;	
			}
			else return false;
		}
	}
}