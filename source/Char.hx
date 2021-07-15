package;

import flixel.FlxSprite;
import flixel.FlxG;

using StringTools;

class Char extends FlxSprite
{
    var character:String;

    public function new(x:Float, y:Float, character:String = 'picko')
    {
        super(x, y);

        this.character = character;

        switch (character)
        {
            case 'picko':
                loadGraphic('assets/images/PICKO.png', true, 76, 189);
                animation.add('idle', [0], 0, false);
                animation.add('walk', [2, 3], 12, true);
                animation.add('run', [2, 3], 24, true);
                animation.play('idle');
            case 'losre':
                loadGraphic('assets/images/losreStupidIdiot.png', true, 76, 189);
                animation.add('idle', [0], 0, false);
                animation.add('walk', [1, 2], 12, true);
                animation.add('gasp', [3], 0, false);
                animation.play('idle');
        }
        
    }

    override function update(elapsed:Float)
    {
        if (character == 'picko')
        {
            if (FlxG.keys.anyPressed([UP, W, LEFT, A, RIGHT, D, DOWN, S]))
            {
                if (FlxG.keys.pressed.SPACE)
                    animation.play('run', false);
                else
                    animation.play('walk', false);
            }
            else
                animation.play('idle');

            if (FlxG.keys.anyPressed([RIGHT, D]))
                flipX = false;
            else if (FlxG.keys.anyPressed([LEFT, A]))
                flipX = true;
        }

        super.update(elapsed);
    }
}