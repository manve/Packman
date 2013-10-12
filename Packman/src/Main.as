package 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import flash.geom.*;
	
	
	/**
	 * ...
	 * @author denis sychev
	 */
	public class Main extends Sprite
	{
		public var game:GameState;
		private var size:Number = 30;
		
		private var directX:Number = 0;
		private var directY:Number = 0;
		private var directX2:Number = 0;
		private var directY2:Number = 0;
		
		
		private var pacman:Sprite;
		private var pacmanX:Number = 350;
		private var pacmanY:Number = 350;
		private var pacmanStep:Number = 20;
		private var map:Vector.<Number>;
		private var matrix:MapMatrix = new MapMatrix();
		private var color:Number = 0xffff00;
		public function Main():void 
		{
			this.addChild(matrix);
			this.map = this.matrix.matrix;
			this.game = new GameState(this.matrix);
			
			this.pacman = new Sprite();
			this.pacman.graphics.beginFill(color);
			this.pacman.graphics.drawCircle(this.pacmanX, this.pacmanY, 8);
			this.pacman.graphics.endFill();
			
			this.addChild(this.pacman);
			this.addChild(this.game);
			//this.game.container.addChild(this.game.satellite);
			addEventListener(Event.ENTER_FRAME, this.draw);
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDownHandler);
		}
		
		private function draw(event:Event):void {
			this.color = this.game.packmanColor;
			
			if (color == 0xff0000) {
				this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDownHandler);
				
				this.pacman.graphics.clear();
				this.pacman.graphics.beginFill(color);
				this.pacman.graphics.drawEllipse(this.pacmanX, this.pacmanY, 16, 8 );	
				this.pacman.graphics.endFill();
			} else {
				this.moveMob(event);
				
				// перешли в следующую клетку
				if ((this.pacmanX % 20 < 0.001) && (this.pacmanY % 20 < 0.001)) {
					var currentX:Number = this.pacmanX * 30 / 20;
					var currentY:Number = (this.pacmanY / 20) % 30;
					this.map[currentX + currentY] = 0;
				}
			}
		}
		
		private function getMapValue(x:Number, y:Number, deltX:Number, deltY:Number):Number {
			if (deltY != 0)
			{
				if (this.map[(this.pacmanX - 10) * 30 / 20 + (this.pacmanY - 10) / 20 - deltY] < 1)
					{
						this.matrix.graphics.beginFill(0xffffff);
						this.matrix.graphics.drawCircle(this.pacmanX, pacmanY, 9);
						this.matrix.graphics.endFill();
						this.map[(this.pacmanX - 10) * 30 / 20 + (this.pacmanY - 10) / 20 - deltY]--;
						return deltY * this.pacmanStep;
					}
				return 0;
			}
			
			if (this.map[(this.pacmanX - 10) * 30 / 20 - deltX * 30 + (this.pacmanY - 10) / 20] < 1)
					{
						this.matrix.graphics.beginFill(0xffffff);
						this.matrix.graphics.drawCircle(this.pacmanX, pacmanY, 9);
						this.matrix.graphics.endFill();
						return deltX * this.pacmanStep;
					}//this.map[(x - 1) + y] < 1 ? x - 1 : x;
				return 0;
		}
		private function onKeyDownHandler(event:KeyboardEvent):void {
			this.pacman.graphics.clear();
			switch(event.keyCode) {
				case 38: // up
					this.directY2 = -1;
					this.directX2 = 0;
					//this.pacmanY -= this.getMapValue(this.pacmanX , this.pacmanY, 0, 1);
					break;
				case 40: // down
					//this.pacmanY -= this.getMapValue(this.pacmanX , this.pacmanY, 0, -1);
					this.directY2 = 1;
					this.directX2 = 0;
					
					break;
				case 37: // left
					//this.pacmanX -= this.getMapValue(this.pacmanX , this.pacmanY, 1, 0);
					this.directX2 = -1;
					this.directY2 = 0;
					break;
				case 39: //right
					//this.pacmanX -= this.getMapValue(this.pacmanX , this.pacmanY, -1, 0);
					this.directX2 = 1;
					this.directY2 = 0;
					break;
				default:
					break;
			}
			this.pacman.graphics.beginFill(color);
			this.pacman.graphics.drawCircle(this.pacmanX, this.pacmanY, 8);
			this.pacman.graphics.endFill();
			
			this.game.setPackmansCord(this.pacmanX, this.pacmanY);
		}
		
		public function moveMob(event:Event):void {
			var x:Number = Math.random();
			var y:Number = Math.random();
			this.pacman.graphics.clear();
			this.pacmanX -= 10;
			this.pacmanY -= 10;
			
			// перешли в следующую клетку
			if ((this.pacmanX % 20 < 0.001) && (this.pacmanY % 20 < 0.001)) {

				this.directX = this.directX2;
				this.directY = this.directY2;
				
				
				var currentX:Number = this.pacmanX * 30 / 20;
				var currentY:Number = (this.pacmanY / 20) % 30;
				var nextX:Number = currentX + this.directX * 30;
				var nextY:Number = currentY + this.directY;
				
				if (this.map[nextX + nextY] > 0) {
					this.directX = 0;
					this.directY = 0;
				} else {
					this.map[nextX + nextY] = 0;
					
					this.matrix.graphics.beginFill(0xffffff);
					this.matrix.graphics.drawCircle(this.pacmanX + 10, this.pacmanY + 10, 8);
					this.matrix.graphics.endFill();
						
					this.game.setPackmansCord(this.pacmanX + 10, this.pacmanY + 10);
					
				}
			}
			
			this.pacmanX += 10;
			this.pacmanY += 10;
			this.pacmanX += this.directX * 2;
			this.pacmanX = this.pacmanX < 30 ? 30 : this.pacmanX < this.size * 20 - 30 ? this.pacmanX : this.size * 20 - 30;
			this.pacmanY += this.directY * 2;
			this.pacmanY = this.pacmanY < 30 ? 30 : this.pacmanY < this.size * 20 - 30 ? this.pacmanY : this.size * 20 - 30;

			this.pacman.graphics.beginFill(this.color);
			this.pacman.graphics.drawCircle(this.pacmanX, this.pacmanY, 10);
			this.pacman.graphics.endFill();
			
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		}
		
	}
	
}