package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

using StringTools;

class Trigger extends FlxSprite
{
    public var assignedRoom:Int;

    public var assignedPos:Array<Float>;

    public function new(posX:Float, posY:Float, width:Float, height:Float, location:Int, playerX:Float, playerY:Float)
    {
        super(posX, posY);

        this.assignedRoom = location;

        this.assignedPos = [playerX, playerY];

        makeGraphic(Std.int(width), Std.int(height), 0xFF000000);
        alpha = 0;
    }
}