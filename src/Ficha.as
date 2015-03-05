package 
{
	public class Ficha 
	{
		private var bando:Boolean;
		
		public function Ficha( bando:Boolean ) {this.bando = bando;}
		
		public function mover( filaI:uint, columnaI:uint, filaF:uint, columnaF:uint, tablero:Ajedrez ):Boolean { return false; }
		
		function amenazaRey( fila:uint, columna:uint, tablero:Ajedrez, paso:int ) { return false; }
		
		function estaClavada( tablero:Ajedrez, fila:uint, columna:uint, filaF:uint, columnaF:uint ):Boolean
		{
			// Alfil o Dama
			for ( var a:int = fila+1, b:int = columna+1; a < 8 && b < 8; ++a, ++b )
			{
				if ( tablero.getCasillas()[a][b].getFicha() != null )
				{
					if ( hayRey1( tablero, a, b ) )
					{
						for ( a = fila-1, b = columna-1; a > -1 && b > -1; --a, --b )
						{
							if ( tablero.getCasillas()[a][b].getFicha() != null )
							{
								if ( tablero.getCasillas()[a][b].alfilDama( bando, a, b, tablero, 0 ) )
								{
									if ( fila - columna == filaF - columnaF ) return false;
									else return true;
								}
								else break;
							}
						}
						return false;
					}
					else if ( tablero.getCasillas()[a][b].alfilDama( bando, a, b, tablero, 0 ) )
					{
						for ( a = fila-1, b = columna-1; a > -1 && b > -1; --a, --b )
						{
							if ( tablero.getCasillas()[a][b].getFicha() != null )
							{
								if ( hayRey2( tablero, a, b ) )
								{
									if ( fila - columna == filaF - columnaF ) return false;
									else return true;
								}
								else break;
							}
						}
					}
					else break;
				}
			}
			for ( a = fila+1, b = columna-1; a < 8 && b > -1; ++a, --b )
			{
				if ( tablero.getCasillas()[a][b].getFicha() != null )
				{
					if ( hayRey1( tablero, a, b ) )
					{
						for ( a = fila-1, b = columna+1; a > -1 && b < 8; --a, ++b )
						{
							if ( tablero.getCasillas()[a][b].getFicha() != null )
							{
								if ( tablero.getCasillas()[a][b].alfilDama( bando, a, b, tablero, 0 ) )
								{
									if ( fila + columna == filaF + columnaF ) return false;
									else return true;
								}
								else break;
							}
						}
						return false;
					}
					else if ( tablero.getCasillas()[a][b].alfilDama( bando, a, b, tablero, 0 ) )
					{
						for ( a = fila-1, b = columna+1; a > -1 && b < 8; --a, ++b )
						{
							if ( tablero.getCasillas()[a][b].getFicha() != null )
							{
								if ( hayRey2( tablero, a, b ) )
								{
									if ( fila + columna == filaF + columnaF ) return false;
									else return true;
								}
								else break;
							}
						}
						return false;
					}
					else break;
				}
			}
			// Torre o Dama
			for ( a = fila+1; a < 8; ++a )
			{
				if ( tablero.getCasillas()[a][columna].getFicha() != null )
				{
					if ( hayRey1( tablero, a, columna ) )
					{
						for ( a = fila-1; a > -1; --a )
						{
							if ( tablero.getCasillas()[a][columna].getFicha() != null )
							{
								if ( tablero.getCasillas()[a][columna].torreDama( bando, a, columna, tablero, 0 ) )
								{
									if ( columna == columnaF ) return false;
									else return true;
								}
								else break;
							}
						}
						return false;
					}
					else if ( tablero.getCasillas()[a][columna].torreDama( bando, a, columna, tablero, 0 ) )
					{
						for ( a = fila-1; a > -1; --a )
						{
							if ( tablero.getCasillas()[a][columna].getFicha() != null )
							{
								if ( hayRey2( tablero, a, columna ) )
								{
									if ( columna == columnaF ) return false;
									else return true;
								}
								else break;
							}
						}
					}
					else break;
				}
			}
			for ( a = columna+1; a < 8; ++a )
			{
				if ( tablero.getCasillas()[fila][a].getFicha() != null )
				{
					if ( hayRey1( tablero, fila, a ) )
					{
						for ( a = columna-1; a > -1; --a )
						{
							if ( tablero.getCasillas()[fila][a].getFicha() != null )
							{
								if ( tablero.getCasillas()[fila][a].torreDama( bando, fila, a, tablero, 0 ) )
								{
									if ( fila == filaF ) return false;
									else return true;
								}
								else break;
							}
						}
						return false;
					}
					else if ( tablero.getCasillas()[fila][a].torreDama( bando, fila, a, tablero, 0 ) )
					{
						for ( a = columna-1; a > -1; --a )
						{
							if ( tablero.getCasillas()[fila][a].getFicha() != null )
							{
								if ( hayRey2( tablero, fila, a ) )
								{
									if ( fila == filaF ) return false;
									else return true;
								}
								else break;
							}
						}
					}
					else break;
				}
			}
			return false;
		}
		
		private function hayRey1( tablero:Ajedrez, a:uint, b:uint ):Boolean
		{
			if ( bando == tablero.getCasillas()[a][b].getFicha().getBando() && tablero.getCasillas()[a][b].getFicha() is Rey ) return true;
			else return false;
		}
		
		private function hayRey2( tablero:Ajedrez, a:uint, b:uint ):Boolean
		{
			if ( tablero.getCasillas()[a][b].getFicha() is Rey && bando == tablero.getCasillas()[a][b].getFicha().getBando() ) return true;
			else return false;
		}
		
		function movimientoEnJaque( filaI:uint, columnaI:uint, filaF:uint, columnaF:uint, tablero:Ajedrez, bando:Boolean, reyX:uint, reyY:uint ):Boolean
		{
			var ficha:Ficha = tablero.getCasillas()[filaF][columnaF].getFicha();
			tablero.getCasillas()[filaF][columnaF].setFicha( tablero.getCasillas()[filaI][columnaI].getFicha() );
			tablero.getCasillas()[filaI][columnaI].setFicha( null );
			if ( tablero.getCasillas()[reyX][reyY].esAtacada( bando, tablero, 0, 0, 0 ) )
			{
				tablero.getCasillas()[filaI][columnaI].setFicha( tablero.getCasillas()[filaF][columnaF].getFicha() );
				tablero.getCasillas()[filaF][columnaF].setFicha( ficha );
				return false;
			}
			tablero.getCasillas()[filaI][columnaI].setFicha( tablero.getCasillas()[filaF][columnaF].getFicha() );
			tablero.getCasillas()[filaF][columnaF].setFicha( ficha );
			return true;
		}
		
		public function getBando():Boolean {return bando;}
	}
}