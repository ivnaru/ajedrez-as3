package  
{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	public class Pieza
	{
		private var pieza:MovieClip;
		private var tablero:MovieClip;
		private var casilla:Casilla;
		
		public function Pieza( f:uint, c:uint, casillas:Array, pieza:MovieClip, tablero:MovieClip, framePieza:uint )
		{
			this.pieza = pieza;
			this.tablero = tablero;
			casilla = casillas[f][c];
			this.pieza.addEventListener(MouseEvent.MOUSE_DOWN, arrastrar);
			pieza.gotoAndStop( framePieza );
			casilla.addChild( pieza );
		}
		
		public function arrastrar( e:MouseEvent )
		{
			tablero.setArrastrandoPieza( true );
			var indice:uint = pieza.currentFrame;
			pieza.gotoAndStop(1);
			var p:Piezas = new Piezas();
			p.gotoAndStop(indice);
			tablero.setUltimaCasilla( casilla );
			tablero.arrastrar( casilla.x, casilla.y, p );
		}
		
		public function getPieza():MovieClip
		{ return pieza; }
	}
}