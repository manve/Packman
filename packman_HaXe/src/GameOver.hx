package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.display.Loader;
import flash.net.URLLoaderDataFormat;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.StyleSheet;

/**
 * ...
 * @author denis sychev
 */

class GameOver extends Sprite implements IDispose
{
		private var urlrequest:URLRequest;
		private var urlLoader:URLLoader;
		private var loader:Loader;
		
		//private var enterNameTitle:TextField;
		private var enterNameField:TextField;
		
	public function new() 
	{
		super();
		
		this.urlrequest = new URLRequest("http://localhost:1444/img/game-over-black-wallpaper.jpg");
		this.urlLoader = new URLLoader();
		this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
	
		this.urlLoader.addEventListener(Event.COMPLETE, onDataLoaded);
		this.urlLoader.load(this.urlrequest);
		
		this.enterNameField = new TextField();
	}
	
	public function dispose():Void {
		this.urlLoader.removeEventListener(Event.COMPLETE, onDataLoaded);
        this.removeChild(this.loader);		
	}
	
	private function onDataLoaded(e:Event):Void {
		this.loader = new Loader();
        this.loader.loadBytes(this.urlLoader.data);
        this.addChild(this.loader);
		
		this.showEnterName();
	}
	
	private function showEnterName() {
		var style:StyleSheet = new StyleSheet();
		var fontSize:String = "font-size:20";
		
		//style.setStyle();
		style.parseCSS(fontSize);
		
		this.enterNameField.type = TextFieldType.INPUT;
		this.enterNameField.text = "Enter your name";
		this.enterNameField.x = 950;
		this.enterNameField.y = 200;
		this.enterNameField.borderColor = 0xff0000;
		this.enterNameField.border = true;
		this.enterNameField.height = 40;
		
		this.addChild(this.enterNameField);
	}
}