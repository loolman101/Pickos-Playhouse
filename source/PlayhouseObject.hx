package;

import flixel.FlxSprite;

class PlayhouseObject extends FlxSprite
{
    public function new(x:Float, y:Float, sprite:String, size:Array<Float>)
    {
        super(x, y);

        loadGraphic('assets/images/' + sprite + '.png');
        if (size.length > 1)
            setGraphicSize(Std.int(width * size[0]), Std.int(width * size[1]));
        else
            setGraphicSize(Std.int(width * size[0]));
        updateHitbox();
    }
}