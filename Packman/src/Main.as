package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author denis sychev
	 */
	public class Main extends Sprite 
	{
		private var game:StartGame;
		
		public function Main() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void {
			this.startGame();
		}
		
		private function startGame() {
			this.game = new StartGame();
			this.addChild(this.game);
			this.game.addEventListener(typeof NewGame, this.onNewGame);
		}
		
		private function onNewGame(e:NewGame):void {
			this.removeChild(this.game);
			this.game.removeEventListener(typeof NewGame, this.onNewGame);
			this.startGame();
			this.stage.focus = this.game;
		}
		
	}

}