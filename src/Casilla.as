package  
{
	import com.greensock.plugins.CacheAsBitmapPlugin;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import org.flashdevelop.utils.FlashConnect;
	
	public class Casilla extends Sprite
	{
		private var ficha:Ficha;
		private var fila:uint;
		private var columna:uint;
		private var colorF:uint;
		private var tablero:Ajedrez;
		
		public function Casilla( ficha:Ficha, fila:uint, columna:uint, tablero:Ajedrez, color:uint )
		{
			this.ficha = ficha;
			this.fila = fila;
			this.columna = columna;
			this.tablero = tablero;
			colorF = color;
			addEventListener( MouseEvent.ROLL_OVER, sobreCasilla );
			addEventListener( MouseEvent.ROLL_OUT, salirCasilla );
		}
		
		public function dibujarCasilla( color:uint )
		{
			graphics.beginFill( color, 1 );
			graphics.drawRect( 0, 0, 75, 75 );
			graphics.endFill();
		}
		
		// Devuelve false si no està atacada y true si lo està.
		/*
		 * param bando: El bando que es atacado. Si se pasa true se verificarà si una pieza negra ataca a una blanca y viceversa.
		 * param tablero: Referencia a la clase que contiene todos los elementos del juego.
		 * param verificarRey: Un valor de 1 indica que se verificaràn los ataques del rey
		 * param verifPeonAdelante: Un valor de 1 indica que se verificarà si un peon puede moverse hacia adelante para interponerse
		 * 							en el jaque.
		 * param ignorarJaque: Un valor de 1 indica que se ignorarà la casilla anterior que hizo jaque para buscar otra que tambièn lo
		 * 					   haga y determinar si hay jaque doble.
		 */
		public function esAtacada( bando:Boolean, tablero:Ajedrez, verificarRey:uint, verifPeonAdelante:uint, ignorarJaque:uint ):Boolean
		{
			// ataca Alfil o Dama
			for ( var a:int = fila+1, b:int = columna+1; a < 8 && b < 8; ++a, ++b ) // Diagonal inferior derecha
			{
				// Si la casilla no està cavìa
				if ( tablero.getCasillas()[a][b].getFicha() != null )
				{
					// Si es rey del mismo bando hay que ignorarlo, por ejemplo si el rey blanco està en jaque por un alfil o dama, no debe
					// poder moverse en esa misma diagonal, en el caso de no existir esta condiciòn eso es lo que pasarìa.
					if ( tablero.getCasillas()[a][b].getFicha() is Rey && tablero.getCasillas()[a][b].getFicha().getBando() == bando ) continue;
					if ( alfilDama( bando, a, b, tablero, ignorarJaque ) ) return true;
					else break;
				}
			}
			for ( a = fila-1, b = columna-1; a > -1 && b > -1; --a, --b ) // Diagonal superior izquierda
			{
				if ( tablero.getCasillas()[a][b].getFicha() != null )
				{
					if ( tablero.getCasillas()[a][b].getFicha() is Rey && tablero.getCasillas()[a][b].getFicha().getBando() == bando ) continue;
					if ( alfilDama( bando, a, b, tablero, ignorarJaque ) ) return true;
					else break;
				}
			}
			for ( a = fila-1, b = columna+1; a > -1 && b < 8; --a, ++b ) // Diagonal superior derecha
			{
				if ( tablero.getCasillas()[a][b].getFicha() != null )
				{
					if ( tablero.getCasillas()[a][b].getFicha() is Rey && tablero.getCasillas()[a][b].getFicha().getBando() == bando ) continue;
					if ( alfilDama( bando, a, b, tablero, ignorarJaque ) ) return true;
					else break;
				}
			}
			for ( a = fila+1, b = columna-1; a < 8 && b > -1; ++a, --b ) // Diagonal inferior izquierda
			{
				if ( tablero.getCasillas()[a][b].getFicha() != null )
				{
					if ( tablero.getCasillas()[a][b].getFicha() is Rey && tablero.getCasillas()[a][b].getFicha().getBando() == bando ) continue;
					if ( alfilDama( bando, a, b, tablero, ignorarJaque ) ) return true;
					else break;
				}
			}
			// ataca Torre o Dama
			for ( a = fila + 1; a < 8; ++a ) // Lìnea recta inferior
			{
				if ( tablero.getCasillas()[a][columna].getFicha() != null )
				{
					if ( tablero.getCasillas()[a][columna].getFicha() is Rey && tablero.getCasillas()[a][columna].getFicha().getBando() == bando ) continue;
					if ( torreDama( bando, a, columna, tablero, ignorarJaque ) ) return true;
					else break;
				}
			}
			for ( a = fila - 1; a > -1; --a ) // Lìnea recta superior
			{
				if ( tablero.getCasillas()[a][columna].getFicha() != null )
				{
					if ( tablero.getCasillas()[a][columna].getFicha() is Rey && tablero.getCasillas()[a][columna].getFicha().getBando() == bando ) continue;
					if ( torreDama( bando, a, columna, tablero, ignorarJaque ) ) return true;
					else break;
				}
			}
			for ( b = columna + 1; b < 8; ++b ) // Lìnea horizontal derecha
			{
				if ( tablero.getCasillas()[fila][b].getFicha() != null )
				{
					if ( tablero.getCasillas()[fila][b].getFicha() is Rey && tablero.getCasillas()[fila][b].getFicha().getBando() == bando ) continue;
					if ( torreDama( bando, fila, b, tablero, ignorarJaque ) ) return true;
					else break;
				}
			}
			for ( b = columna - 1; b > -1; --b ) // Linea horizontal izquierda
			{
				if ( tablero.getCasillas()[fila][b].getFicha() != null )
				{
					if ( tablero.getCasillas()[fila][b].getFicha() is Rey && tablero.getCasillas()[fila][b].getFicha().getBando() == bando ) continue;
					if ( torreDama( bando, fila, b, tablero, ignorarJaque ) ) return true;
					else break;
				}
			}
			// atacado por Caballo
			if ( fila+1 < 8 && columna+2 < 8 && caballo( bando, fila+1, columna+2, tablero, ignorarJaque ) ) return true;
			if ( fila+2 < 8 && columna+1 < 8 && caballo( bando, fila+2, columna+1, tablero, ignorarJaque ) ) return true;
			if ( fila-1 > -1 && columna+2 < 8 && caballo( bando, fila-1, columna+2, tablero, ignorarJaque ) ) return true;
			if ( fila-1 > -1 && columna-2 > -1 && caballo( bando, fila-1, columna-2, tablero, ignorarJaque ) ) return true;
			if ( fila+1 < 8 && columna-2 > -1 && caballo( bando, fila+1, columna-2, tablero, ignorarJaque ) ) return true;
			if ( fila+2 < 8 && columna-1 > -1 && caballo( bando, fila+2, columna-1, tablero, ignorarJaque ) ) return true;
			if ( fila-2 > -1 && columna+1 < 8 && caballo( bando, fila-2, columna+1, tablero, ignorarJaque ) ) return true;
			if ( fila-2 > -1 && columna-1 > -1 && caballo( bando, fila-2, columna-1, tablero, ignorarJaque ) ) return true;
			// atacado por Peon
			if ( verifPeonAdelante == 0 )
			{
				if ( bando )
				{
					if ( fila-1 > -1 && columna-1 > -1 && peon(  bando, fila-1, columna-1, tablero, ignorarJaque ) ) return true;
					if ( fila-1 > -1 && columna+1 < 8 && peon(  bando, fila-1, columna+1, tablero, ignorarJaque ) ) return true;
				}
				else
				{
					if ( fila+1 < 8 && columna-1 > -1 && peon(  bando, fila+1, columna-1, tablero, ignorarJaque ) ) return true;
					if ( fila+1 < 8 && columna+1 < 8 && peon(  bando, fila+1, columna+1, tablero, ignorarJaque ) ) return true;
				}
			}
			if( verificarRey == 1 )
			{
				// atacado por Rey
				if( fila-1 > -1 && columna-1 > -1 && rey( bando, fila-1, columna-1, tablero ) ) return true;
				if( fila-1 > -1 && columna+1 < 8 && rey( bando, fila-1, columna+1, tablero ) ) return true;
				if( fila-1 > -1 && rey( bando, fila-1, columna, tablero ) ) return true;
				if( fila+1 < 8 && columna+1 < 8 && rey( bando, fila+1, columna+1, tablero ) ) return true;
				if( fila+1 < 8 && columna-1 > -1 && rey( bando, fila+1, columna-1, tablero ) ) return true;
				if( fila+1 < 8 && rey( bando, fila+1, columna, tablero ) ) return true;
				if( columna+1 < 8 && rey( bando, fila, columna+1, tablero ) ) return true;
				if ( columna - 1 > -1 && rey( bando, fila, columna - 1, tablero ) ) return true;
			}
			// Verificar si hay un peon que puede moverse hacia adelante para interponerse en un jaque
			if( verifPeonAdelante == 1 )
			{
				if ( bando )
				{
					if ( fila - 1 > -1 && peonAdelante( bando, fila - 1, columna, tablero ) ) return true;
					if ( fila - 2 > -1 && peonAdelante( bando, fila - 2, columna, tablero ) ) return true;
				}
				else
				{
					if ( fila + 1 < 8 && peonAdelante( bando, fila + 1, columna, tablero ) ) return true;
					if ( fila + 2 < 8 && peonAdelante( bando, fila + 2, columna, tablero ) ) return true;
				}
			}
			// Si logra pasar lo anterior, no està atacada.
			return false;
		}
		
		/*
		 * param bando: El bando que es atacado. Si se pasa true se verificarà si una pieza negra ataca a una blanca y viceversa.
		 * param f: La fila de la casilla a verificar.
		 * param c: La columna de la casilla a verificar.
		 * param tablero: Referencia a la clase que contiene todos los elementos del juego.
		 * param ignorarJaque: Un valor de 1 indica que se ignorarà la casilla anterior que hizo jaque para buscar otra que tambièn lo
		 * 					   haga y determinar si hay jaque doble.
		 */
		public function alfilDama( bando:Boolean, f:uint, c:uint, tablero:Ajedrez, ignorarJaque:uint ):Boolean
		{
			// Si se indica que hay que ignorar la casilla anterior que se verificò que hacìa jaque y si la casilla que se va a verificar
			// conincide con la anterior hay que ignorarla para verificar si existe otra casilla que tambièn hace jaque, con el fin de comprobar
			// si se ha hecho jaque doble.
			if ( ignorarJaque == 1  && tablero.getCasillaJaque().x == f && tablero.getCasillaJaque().y == c ) return false;
			if ( bando != tablero.getCasillas()[f][c].getFicha().getBando() && (tablero.getCasillas()[f][c].getFicha() is Alfil || tablero.getCasillas()[f][c].getFicha() is Dama ) )
			{
				if ( ficha is Rey ) { tablero.getCasillaJaque().x = f; tablero.getCasillaJaque().y = c; }
				tablero.getAtLineaJaque().x = f; tablero.getAtLineaJaque().y = c;
				return true;
			}
			else return false;
		}
		
		public function torreDama( bando:Boolean, f:uint, c:uint, tablero:Ajedrez, ignorarJaque:uint ):Boolean
		{
			if ( ignorarJaque == 1  && tablero.getCasillaJaque().x == f && tablero.getCasillaJaque().y == c ) return false;
			if ( bando != tablero.getCasillas()[f][c].getFicha().getBando() && (tablero.getCasillas()[f][c].getFicha() is Torre || tablero.getCasillas()[f][c].getFicha() is Dama ) )
			{
				if ( ficha is Rey ) { tablero.getCasillaJaque().x = f; tablero.getCasillaJaque().y = c; }
				tablero.getAtLineaJaque().x = f; tablero.getAtLineaJaque().y = c;
				return true;
			}
			else return false;
		}
		
		private function caballo( bando:Boolean, f:uint, c:uint, tablero:Ajedrez, ignorarJaque:uint ):Boolean
		{
			if ( ignorarJaque == 1  && tablero.getCasillaJaque().x == f && tablero.getCasillaJaque().y == c ) return false;
			if ( tablero.getCasillas()[f][c].getFicha() != null && bando != tablero.getCasillas()[f][c].getFicha().getBando() && tablero.getCasillas()[f][c].getFicha() is Caballo )
			{
				if ( ficha is Rey ) { tablero.getCasillaJaque().x = f; tablero.getCasillaJaque().y = c; }
				tablero.getAtLineaJaque().x = f; tablero.getAtLineaJaque().y = c;
				return true;
			}
			else return false;
		}
		
		private function peon( bando:Boolean, f:uint, c:uint, tablero:Ajedrez, ignorarJaque:uint ):Boolean
		{
			if ( ignorarJaque == 1  && tablero.getCasillaJaque().x == f && tablero.getCasillaJaque().y == c ) return false;
			if ( tablero.getCasillas()[f][c].getFicha() != null && bando != tablero.getCasillas()[f][c].getFicha().getBando() && tablero.getCasillas()[f][c].getFicha() is Peon )
			{
				if ( ficha is Rey ) { tablero.getCasillaJaque().x = f; tablero.getCasillaJaque().y = c; }
				tablero.getAtLineaJaque().x = f; tablero.getAtLineaJaque().y = c;
				return true;
			}
			else return false;
		}
		
		private function rey( bando:Boolean, f:uint, c:uint, tablero:Ajedrez ):Boolean
		{
			if ( tablero.getCasillas()[f][c].getFicha() != null && bando != tablero.getCasillas()[f][c].getFicha().getBando() && tablero.getCasillas()[f][c].getFicha() is Rey )
				return true;
			else return false;
		}
		
		private function peonAdelante( bando:Boolean, f:uint, c:uint, tablero:Ajedrez ):Boolean
		{
			if ( tablero.getCasillas()[f][c].getFicha() != null && bando != tablero.getCasillas()[f][c].getFicha().getBando() && tablero.getCasillas()[f][c].getFicha() is Peon )
			{
				tablero.getAtLineaJaque().x = f; tablero.getAtLineaJaque().y = c;
				return true;
			}
			else return false;
		}
		
		private function sobreCasilla( e:MouseEvent ) { if ( tablero.getArratrandoPieza() ) dibujarCasilla( 0xA4A0DC ); }
		private function salirCasilla( e:MouseEvent ) { if ( tablero.getArratrandoPieza() ) dibujarCasilla( colorF ); }
		public function getFicha():Ficha {return ficha;}
		public function setFicha( ficha:Ficha ) {this.ficha = ficha;}
		public function getFila():uint {return fila;}
		public function getColumna():uint { return columna; }
		public function getColor():uint {return colorF;}
	}
}