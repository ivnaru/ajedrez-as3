package 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import org.flashdevelop.utils.FlashConnect;
	import com.greensock.TweenNano;
	
	public class Ajedrez extends MovieClip
	{
		private var casillas:Array;
		private var piezaArrastrada:MovieClip;
		private var ultimaCasilla:Casilla;
		private var reyNegro:Point, reyBlanco:Point, casillaJaque:Point, atLineaJaque:Point;
		private var negrasEnJaque:Boolean, blancasEnJaque:Boolean;
		private var arrastrandoPieza:Boolean;
		
		public function Ajedrez() 
		{
			casillaJaque = new Point( 0, 0 );
			atLineaJaque = new Point( 0, 0 );
			addEventListener( MouseEvent.MOUSE_UP, abandonarArrastre );
			casillas = new Array( 8 );
			for( var i:uint=0; i<8; i++ ) casillas[i] = new Array( 8 );
			var color:uint = 0;
			for( var f:uint=0; f<8; f++ ) 
			{
				for( var c:uint=0; c<8; c++ ) 
				{
					if( (f+c)%2 != 0  ) color = 0xA7C0DC; // Azul palido-claro
					else color = 0xFFFFFF; // Blanco
					switch( f )
					{
						case 0:
							switch( c )
							{
								case 0: case 7: colocarCasilla( new Torre( false ), f, c, false, color, 5 ); break;
								case 1: case 6: colocarCasilla( new Caballo( false ), f, c, false, color, 7 ); break;
								case 2: case 5: colocarCasilla( new Alfil( false ), f, c, false, color, 9 ); break;
								case 3: colocarCasilla( new Dama( false ), f, c, false, color, 11 ); break;
								case 4: 
									colocarCasilla( new Rey( false, 0 ), f, c, false, color, 13 );
									reyNegro = new Point( f, c ); break;
							} break;
						case 1: colocarCasilla( new Peon( f, c, false ), f, c, false, color, 3 ); break;
						case 6: colocarCasilla( new Peon( f, c, true ), f, c, false, color, 2 ); break;
						case 7:
							switch( c )
							{
								case 0: case 7: colocarCasilla( new Torre( true ), f, c, false, color, 4 ); break;
								case 1: case 6: colocarCasilla( new Caballo( true ), f, c, false, color, 6 ); break;
								case 2: case 5: colocarCasilla( new Alfil( true ), f, c, false, color, 8 ); break;
								case 3: colocarCasilla( new Dama( true ), f, c, false, color, 10 ); break;
								case 4: 
									colocarCasilla( new Rey( true, 7 ), f, c, false, color, 12 ); 
									reyBlanco = new Point( f, c ); break;
							} break;
						default: colocarCasilla( null, f, c, false, color, 1 );	
					}
				}
			}
		}
		
		private function colocarCasilla( ficha:Ficha, f:uint, c:uint, bando:Boolean, color:uint, framePieza:uint )
		{
			casillas[f][c] = new Casilla( ficha, f, c, this, color ); 
			casillas[f][c].x = c*75 + 50;
			casillas[f][c].y = f*75 + 70;
			casillas[f][c].dibujarCasilla( color );
			var p:Pieza = new Pieza( f, c, casillas, new Piezas(), this, framePieza );
			casillas[f][c].addChild( p.getPieza() );
			addChild( casillas[f][c] );
		}
		
		public function arrastrar( f:uint, c:uint, pieza:MovieClip )
		{
			piezaArrastrada = pieza;
			piezaArrastrada.x = f;
			piezaArrastrada.y = c;
			addChild( piezaArrastrada );
			piezaArrastrada.mouseEnabled = false;
			piezaArrastrada.startDrag();
		}
		
		private function abandonarArrastre( e:MouseEvent )
		{
			piezaArrastrada.mouseEnabled = true;
			arrastrandoPieza = false;
			for( var f:uint=0; f<8; f++ ) 
			{
				for( var c:uint=0; c<8; c++ ) 
				{
					if( casillas[f][c].hitTestPoint( mouseX, mouseY, true ) )
					{
						casillas[f][c].dibujarCasilla( casillas[f][c].getColor() );
						if( piezaArrastrada.currentFrame != 1 )
						{
							if( ultimaCasilla.getFicha().mover( ultimaCasilla.getFila(), ultimaCasilla.getColumna(), f, c, this ) )
							{
								removeChild( piezaArrastrada );
								casillaJaque.x = f; casillaJaque.y = c;
								casillas[f][c].getChildAt(0).gotoAndStop( piezaArrastrada.currentFrame );
								casillas[f][c].setFicha( ultimaCasilla.getFicha() );
								ultimaCasilla.setFicha( null );
								if ( casillas[f][c].getFicha().getBando() ) 
								{
									blancasEnJaque = false;
									verificarMate( reyNegro, false );
								}
								else
								{
									negrasEnJaque = false;
									verificarMate( reyBlanco, true );
								}
							}
							else TweenNano.to( piezaArrastrada, 0.12, { x:ultimaCasilla.x, y:ultimaCasilla.y, onComplete:moverPieza } );
						}
						else removeChild( piezaArrastrada );
						c = 8; f = 8;
					}
				}
			}
		}
		
		private function diagonalJaqueAtacada( bando:Boolean, filaI:uint, columnaI:uint, filaF:uint, columnaF:uint, pasoF:int, pasoC:int ):Boolean
		{
			for( var f:uint = filaI+pasoF, c:uint = columnaI+pasoC; f != filaF, c != columnaF; f=f+pasoF, c=c+pasoC )
			{
				if ( casillas[f][c].esAtacada( bando, this, 0, 1, 0 ) && casillas[atLineaJaque.x][atLineaJaque.y].getFicha().mover( atLineaJaque.x, atLineaJaque.y, f, c, this ) )
				{
					FlashConnect.trace("diagonal de aki: " + f + ", " + c);
					return false;
				}
			}
			
			return true;
		}
		
		private function rectaJaqueAtacada( bando:Boolean, filaI:uint, columnaI:uint, filaF:uint, columnaF:uint, pasoF:int, pasoC:int, dir:Boolean ):Boolean
		{
			if ( dir ) // dir == true: movimiento vertical
			{
				for( var f:uint = filaI+pasoF; f != filaF; f=f+pasoF)
				{
					if( casillas[f][columnaI].esAtacada( bando, this, 0, 0, 0 ) && casillas[atLineaJaque.x][atLineaJaque.y].getFicha().mover( atLineaJaque.x, atLineaJaque.y, f, columnaF, this ) )
					{	
						FlashConnect.trace("recta de aki: " + f + ", " + c);
						return false;
					}
				}
			}
			else
			{
				for( var c:uint = columnaI+pasoC; c != columnaF; c=c+pasoC)
				{
					if( casillas[filaI][c].esAtacada( bando, this, 0, 1, 0 ) && casillas[atLineaJaque.x][atLineaJaque.y].getFicha().mover( atLineaJaque.x, atLineaJaque.y, filaI, c, this ) )
						return false;
				}
			}
			return true;
		}
		
		private function verificarMate( reyEnemigo:Point, bandoEnemigo:Boolean )
		{
			// Verifica si hay jaque
			if ( casillas[reyEnemigo.x][reyEnemigo.y].esAtacada( bandoEnemigo, this, 0, 0, 0 ) )
			{
				var esMate:Boolean = true;
				// Verifica si otra pieza tambièn da jaque ( jaque doble ) *en el jaque doble la ùnica forma de escapar
				// es mover el rey
				if ( casillas[reyEnemigo.x][reyEnemigo.y].esAtacada( bandoEnemigo, this, 0, 0, 1 ) )
				{
					// Verifica las casillas a las que puede mover el rey y si puede hacerlo.
					if ( moverRey( reyEnemigo,  bandoEnemigo ) == false ) esMate = false;
					// Si no pudo mover es mate.
					if ( esMate ) FlashConnect.trace("Mate!!");
					else // Es jaque
					{
						if ( bandoEnemigo ) blancasEnJaque = true;
						else negrasEnJaque = true;
						FlashConnect.trace( "Jaque!" );
					}
				}
				else // No es jaque doble
				{
					// Verifica las casillas a las que puede mover el rey y si puede hacerlo.
					if ( moverRey( reyEnemigo,  bandoEnemigo ) == false ) 
					{
						FlashConnect.trace("El rey se puede mover.");
						esMate = false;
					} else FlashConnect.trace("El rey no se puede mover.");
					// Si el rey no puede moverse y la ficha atacante ( la que da jaque ) es atacada, no es mate.
					if ( esMate && casillas[casillaJaque.x][casillaJaque.y].esAtacada( !bandoEnemigo, this, 0, 0, 0 ) )
					{
						FlashConnect.trace("La ficha q jaquea es atacada.");
						esMate = false;
					} else FlashConnect.trace("La ficha q jaquea no es atacada.");
					// Si el rey no puede moverse y la ficha atacante no es atacada, hay que verificar si se puede interponer una ficha
					// entre la atacante y el rey para evadir el jaque ( solo vàlido para ataques a distancia de alfil, torre y dama ).
					if ( esMate )
					{
						// verifica ataques diagonales
						if( reyEnemigo.x+reyEnemigo.y == casillaJaque.x+casillaJaque.y )
						{
							// Diagonal superior izquiera, caso contrario la inferior derecha
							if ( reyEnemigo.x > casillaJaque.x )  esMate = diagonalJaqueAtacada( !bandoEnemigo, reyEnemigo.x, reyEnemigo.y, casillaJaque.x, casillaJaque.y, -1, 1 );
							else esMate = diagonalJaqueAtacada( !bandoEnemigo, reyEnemigo.x, reyEnemigo.y, casillaJaque.x, casillaJaque.y, 1, -1 );
						}
						else if( reyEnemigo.x-reyEnemigo.y == casillaJaque.x-casillaJaque.y )
						{
							// Diagonal superior derecha, caso contrario la inferior izquierda
							if ( reyEnemigo.x > casillaJaque.x ) esMate = diagonalJaqueAtacada( !bandoEnemigo, reyEnemigo.x, reyEnemigo.y, casillaJaque.x, casillaJaque.y, -1, -1 );
							else esMate = diagonalJaqueAtacada( !bandoEnemigo, reyEnemigo.x, reyEnemigo.y, casillaJaque.x, casillaJaque.y, 1, 1 );
						}
						// Verifica ataques en linea recta
						if( reyEnemigo.y == casillaJaque.y ) // recto
						{
							if( reyEnemigo.x > casillaJaque.x ) esMate = rectaJaqueAtacada( !bandoEnemigo, reyEnemigo.x, reyEnemigo.y, casillaJaque.x, casillaJaque.y, -1, 0, true );
							else esMate = rectaJaqueAtacada( !bandoEnemigo, reyEnemigo.x, reyEnemigo.y, casillaJaque.x, casillaJaque.y, 1, 0, true );
						}
						else if( reyEnemigo.x == casillaJaque.x ) // horizontal
						{
							if( reyEnemigo.y > casillaJaque.y ) esMate = rectaJaqueAtacada( !bandoEnemigo, reyEnemigo.x, reyEnemigo.y, casillaJaque.x, casillaJaque.y, 0, -1, false );
							else esMate = rectaJaqueAtacada( !bandoEnemigo, reyEnemigo.x, reyEnemigo.y, casillaJaque.x, casillaJaque.y, 0, 1, false );
						}
					}
					// si no hay pieza que pueda interponerse, entonces es mate.
					if ( esMate ) FlashConnect.trace("Mate!");
					else // jaque
					{
						if ( bandoEnemigo ) blancasEnJaque = true;
						else negrasEnJaque = true;
						FlashConnect.trace( "Jaque!" );
					}
				}
			}
		}
		
		private function moverRey( reyEnemigo:Point, bandoEnemigo:Boolean )
		{
			for ( var col:int = reyEnemigo.y - 1; col < reyEnemigo.y + 2; ++col )
			{
				for ( var fil:int = reyEnemigo.x - 1; fil < reyEnemigo.x + 2; ++fil )
				{
					if ( col > -1 && col < 8 && fil > -1 && fil < 8 && ( fil != reyEnemigo.x || col != reyEnemigo.y ) )
					{
						if ( casillas[fil][col].getFicha() != null )
						{
							if ( casillas[fil][col].getFicha().getBando() != casillas[reyEnemigo.x][reyEnemigo.y].getFicha().getBando() && 
							( casillas[fil][col].esAtacada( bandoEnemigo, this, 1, 0, 0 ) == false || casillas[fil][col].esAtacada( !bandoEnemigo, this, 0, 0, 0 ) ) )
							{
								FlashConnect.trace("aki: " + fil + ", " + col);
								return false;
							}
						}
						else if ( casillas[fil][col].esAtacada( bandoEnemigo, this, 0, 0, 0 ) == false )
						{
							FlashConnect.trace("aki: " + fil + ", " + col);
							return false;
						}
					}
				}
			}
			return true;
		}
		
		private function moverPieza()
		{
			removeChild( piezaArrastrada );
			casillas[ultimaCasilla.getFila()][ultimaCasilla.getColumna()].getChildAt(0).gotoAndStop( piezaArrastrada.currentFrame );
		}
		
		public function getCasillas():Array { return casillas; }
		public function getBlancasEnJaque():Boolean { return blancasEnJaque; }
		public function getNegrasEnJaque():Boolean { return negrasEnJaque; }
		public function setReyNegro( fila:uint, columna:uint ) { reyNegro.x = fila; reyNegro.y = columna; }
		public function setReyBlanco( fila:uint, columna:uint ) { reyBlanco.x = fila; reyBlanco.y = columna; }
		public function setUltimaCasilla( ultimaCasilla:Casilla ) { this.ultimaCasilla = ultimaCasilla; }
		public function getCasillaJaque():Point { return casillaJaque; }
		public function getArratrandoPieza():Boolean { return arrastrandoPieza; }
		public function setArrastrandoPieza( arrastrandoPieza:Boolean ) { this.arrastrandoPieza = arrastrandoPieza; }
		public function getAtLineaJaque():Point { return atLineaJaque; }
		public function getReyNegro():Point { return reyNegro; }
		public function getReyBlanco():Point { return reyBlanco; }
	}
}