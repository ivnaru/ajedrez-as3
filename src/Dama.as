package  
{	
	public class Dama extends Ficha
	{
		public function Dama( bando:Boolean ) { super( bando ); }
		
		override public function mover( filaI:uint, columnaI:uint, filaF:uint, columnaF:uint, tablero:Ajedrez ):Boolean
		{
			return new Alfil( super.getBando() ).mover( filaI, columnaI, filaF, columnaF, tablero ) || new Torre( super.getBando() ).mover( filaI, columnaI, filaF, columnaF, tablero ) ;
		}
	}
}