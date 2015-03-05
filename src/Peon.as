package 
{	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import org.flashdevelop.utils.FlashConnect;

	public class Peon extends Ficha
	{
		private var fila:uint, columna:uint;
		private var tablero:Ajedrez;
		private var capturaPaso:int;
		var promo:Promocion = new Promocion();
		var promoN:PromocionN = new PromocionN();
		
		public function Peon( fila:uint, columna:uint, bando:Boolean ) 
		{
			super( bando );
			this.fila = fila;
			this.columna = columna;
		}
		
		override public function mover( filaI:uint, columnaI:uint, filaF:uint, columnaF:uint, tablero:Ajedrez ):Boolean
		{
			var fichaI:Ficha = tablero.getCasillas()[filaI][columnaI].getFicha();
			var fichaF:Ficha = tablero.getCasillas()[filaF][columnaF].getFicha();
			// Si es blanco
			if( fichaI.getBando() ) return verificarMovimiento( fichaI, fichaF, filaI, columnaI, filaF, columnaF, tablero, 0, 6, -1, -2, 1 );
			else return verificarMovimiento( fichaI, fichaF, filaI, columnaI, filaF, columnaF, tablero, 7, 1, 1, 2, -1 );
		}
		
		private function verificarMovimiento( fichaI:Ficha, fichaF:Ficha, filaI:uint, columnaI:uint, filaF:uint, columnaF:uint, tablero:Ajedrez, filaPro:uint, fila2P:uint, n1:int, n2:int, n3:int ):Boolean
		{
			if( ((fichaF == null && ((filaI+n1 == filaF && columnaI == columnaF) || (filaI+n2 == filaF && columnaI == columnaF && filaI == fila2P)))
			   || ((columnaI+n1 == columnaF || columnaI+n3 == columnaF ) && filaI+n1 == filaF && fichaF != null  && fichaI.getBando() != fichaF.getBando() )
			   || (Peon(fichaI).getCapturaPaso() == -1 && ((filaI+1 == filaF && columnaI+1 == columnaF && !fichaI.getBando()) ||  (filaI-1 == filaF && columnaI+1 == columnaF && fichaI.getBando())))
			   || (Peon(fichaI).getCapturaPaso() == 1 && ((filaI+1 == filaF && columnaI-1 == columnaF && !fichaI.getBando() ) || (filaI-1 == filaF && columnaI-1 == columnaF && fichaI.getBando())))) && !super.estaClavada( tablero, filaI, columnaI, filaF, columnaF ) )
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
				fila = filaF; columna = columnaF;// ver gestionar promocion PILAS AHI si se puede cambiar eso!
				this.tablero = tablero;
				if( filaI+n2 == filaF )
				{
					if( columnaF > 0 && tablero.getCasillas()[filaF][columnaF-1].getFicha() is Peon && tablero.getCasillas()[filaF][columnaF-1].getFicha().getBando() != super.getBando())
						tablero.getCasillas()[filaF][columnaF-1].getFicha().setCapturaPaso( -1 );
					if( columnaF < 7 && tablero.getCasillas()[filaF][columnaF+1].getFicha() is Peon && tablero.getCasillas()[filaF][columnaF+1].getFicha().getBando() != super.getBando())
						tablero.getCasillas()[filaF][columnaF+1].getFicha().setCapturaPaso( 1 );
				}
				else if( filaF == filaPro )
				{
					// Si es blanco
					if( n3 == 1 ) mostrarCuadroPromo( promo, tablero );
					else mostrarCuadroPromo( promoN, tablero );
				}
				if( (Peon(fichaI).getCapturaPaso() == -1 && ((filaI+1==filaF && columnaI+1 == columnaF) ||  (filaI-1==filaF && columnaI+1 ==columnaF))) )
				{
					tablero.getCasillas()[filaI][columnaI+1].getChildAt(0).gotoAndStop(1);
					tablero.getCasillas()[filaI][columnaI+1].setFicha( null );
				}
				else if( (Peon(fichaI).getCapturaPaso() == 1 && ((filaI+1==filaF && columnaI-1 == columnaF) || (filaI-1==filaF && columnaI-1 ==columnaF))) )
				{
					tablero.getCasillas()[filaI][columnaI-1].getChildAt(0).gotoAndStop(1);
					tablero.getCasillas()[filaI][columnaI-1].setFicha( null );
				}
				return true;
			}
			else return false;
		}
		
		private function mostrarCuadroPromo( promo:Sprite, tablero:Ajedrez )
		{
			promo.x = 250;
			promo.y = 5;
			tablero.addChild( promo );
			promo.getChildAt(1).addEventListener( MouseEvent.CLICK, promoverC );
			promo.getChildAt(2).addEventListener( MouseEvent.CLICK, promoverA );
			promo.getChildAt(3).addEventListener( MouseEvent.CLICK, promoverT );
			promo.getChildAt(4).addEventListener( MouseEvent.CLICK, promoverD );
		}
		
		private function promoverC(e:MouseEvent)
		{
			if( e.target == promoN.getChildAt(1) ) gestionarPromocion( 7, promoN, new Caballo( false ) );
			else if( e.target == promo.getChildAt(1) ) gestionarPromocion( 6, promo, new Caballo( true ) );
		}
		
		private function promoverA(e:MouseEvent)
		{
			if( e.target == promoN.getChildAt(2) ) gestionarPromocion( 9, promoN, new Alfil( false ) );
			else if( e.target == promo.getChildAt(2) ) gestionarPromocion( 8, promo, new Alfil( true ) );
		}
		
		private function promoverT(e:MouseEvent)
		{
			if( e.target == promoN.getChildAt(3) ) gestionarPromocion( 5, promoN, new Torre( false ) );
			else if( e.target == promo.getChildAt(3) ) gestionarPromocion( 4, promo, new Torre( true ) );
		}
		
		private function promoverD(e:MouseEvent)
		{
			if( e.target == promoN.getChildAt(4) ) gestionarPromocion( 11, promoN, new Dama( false ) );
			else if( e.target == promo.getChildAt(4) ) gestionarPromocion( 10, promo, new Dama( true ) );
		}
		
		private function gestionarPromocion( indice:uint, promo:Sprite, ficha:Ficha )
		{
			tablero.getCasillas()[fila][columna].getChildAt(0).gotoAndStop(indice);
			tablero.getCasillas()[fila][columna].setFicha( ficha );
			tablero.removeChild( promo );
		}
		
		public function getCapturaPaso():int {return capturaPaso;}
		
		public function setCapturaPaso( capturaPaso:int ) {this.capturaPaso = capturaPaso;}
	}
}