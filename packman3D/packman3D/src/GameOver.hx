package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.display.Loader;
import flash.net.URLLoaderDataFormat;

/**
 * ...
 * @author denis sychev
 */

class GameOver extends Sprite implements IDispose
{
		private var urlrequest:URLRequest;
		private var urlLoader:URLLoader;
		private var loader:Loader;

	public function new() 
	{
		super();
		
		this.urlrequest = new URLRequest("http://localhost:1444/img/game-over-black-wallpaper.jpg");
		this.urlLoader = new URLLoader();
		this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
	
		this.urlLoader.addEventListener(Event.COMPLETE, onDataLoaded);
		this.urlLoader.load(this.urlrequest);
	}
	
	public function dispose():Void {
		this.urlLoader.removeEventListener(Event.COMPLETE, onDataLoaded);
        this.removeChild(this.loader);		
	}
	
	private function onDataLoaded(e:Event):Void {
		this.loader = new Loader();
        this.loader.loadBytes(this.urlLoader.data);
        this.addChild(this.loader);
	}
}