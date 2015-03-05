package  
{	
	import org.flashdevelop.utils.FlashConnect;
	public class Caballo extends Ficha
	{
		public function Caballo( bando:Boolean ) { super( bando ); }
		
		override public function mover( filaI:uint, columnaI:uint, filaF:uint, columnaF:uint, tablero:Ajedrez ):Boolean
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
			var fichaF:Ficha = tablero.getCasillas()[filaF][columnaF].getFicha();
			if ( ( fichaF == null || fichaF.getBando() != super.getBando() ) && !super.estaClavada( tablero, filaI, columnaI, filaF, columnaF ) && ( ( Math.abs( filaI - filaF ) == 2 && Math.abs( columnaI - columnaF ) == 1 ) || ( Math.abs( filaI - filaF ) == 1 && Math.abs( columnaI - columnaF ) == 2 ) ) )
				return true;
			else return false;
		}
	}
}