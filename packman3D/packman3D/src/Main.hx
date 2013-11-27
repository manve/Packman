package ;

import flash.Lib;
	
import flash.display.Sprite;
import flash.events.Event;

/**
 * ...
 * @author denis sychev
 */

class Main
{
	private static var game:GameStage;
	
	static function main() 
	{
		game = new GameStage();
		//this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
		startGame();
	}
	
	private static function onAddedToStage(e:Event) {
		startGame();
	}
	
	private static function startGame() {
		game = new GameStage();
		//this.addChild(this.game);
		Lib.current.addChild(game);
		game.addEventListener('NewGameEvent', onNewGame);
	}
	
	private static function onNewGame(e:Event) {
		//this.removeChild(this.game);
		game.removeEventListener('NewGameEvent', onNewGame);
		startGame();
		//this.stage.focus = this.game;
	}
}