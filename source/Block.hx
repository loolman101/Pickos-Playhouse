package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Block extends FlxSprite
{
    var posX:Float;
    var posY:Float;

    public function new(x:Float, y:Float, colour:FlxColor)
    {
        super(x, y);
        posX = x;
        posY = y;

        makeGraphic(60, 60, colour);
    }

    public function stayInPlace()
    {
        this.x = posX;
        this.y = posY;
    }
}