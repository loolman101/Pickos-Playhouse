package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		#if debug
		addChild(new FlxGame(0, 0, PlayState)); // AMONG US
		#else
		addChild(new FlxGame(0, 0, TitleState)); // SUSSY
		#end

		#if !mobile
		addChild(new FPS(10, 3, 0xFFFFFF));
		#end
	}
}
