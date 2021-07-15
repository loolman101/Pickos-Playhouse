package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.FlxObject;

using StringTools;

class Player extends FlxSprite
{
    var SPEED:Float = 200;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        makeGraphic(55, 55, 0xFF000000);
        alpha = 0;
        drag.x = drag.y = 1600;
    }

    var buttonUP:Bool = false;
    var buttonDOWN:Bool = false;
    var buttonLEFT:Bool = false;
    var buttonRIGHT:Bool = false;

    var curAngle:Float;

    var inputArray:Array<Bool> = [];

    public function checkForInput()
    {
        if (0 == 0) // gonna change this later to allow for story and junk
        {
            buttonUP = FlxG.keys.anyPressed([UP, W]);
            buttonDOWN = FlxG.keys.anyPressed([DOWN, S]);
            buttonLEFT = FlxG.keys.anyPressed([LEFT, A]);
            buttonRIGHT = FlxG.keys.anyPressed([RIGHT, D]);

            if (buttonUP && buttonDOWN)
                buttonUP = buttonDOWN = false;
            if (buttonLEFT && buttonRIGHT)
                buttonLEFT = buttonRIGHT = false;

            checkCollision();

            inputArray = [buttonUP, buttonDOWN, buttonLEFT, buttonRIGHT];

            curAngle = calcAngle(inputArray);

            if (FlxG.keys.pressed.SPACE)
                SPEED = 425;
            else 
                SPEED = 300;

            move(inputArray);
        }
    }

    function calcAngle(daInputs:Array<Bool>)
    {
        switch (daInputs)
        {
            case [true, false, false, false]:
                return -90;
            case [true, false, true, false]:
                return -135;
            case [true, false, false, true]:
                return -45;
            case [false, true, false, false]:
                return 90;
            case [false, true, true, false]:
                return 135;
            case [false, true, false, true]:
                return 45;
            case [false, false, true, false]:
                return 180;
            default:
                return 0;
        }
    }

    function checkCollision()
    {
        if (isTouching(FlxObject.DOWN))
            buttonDOWN = false;
        if (isTouching(FlxObject.UP))
            buttonUP = false;
        if (isTouching(FlxObject.LEFT))
            buttonLEFT = false;
        if (isTouching(FlxObject.RIGHT))
            buttonRIGHT = false;
    }

    function move(daInputs:Array<Bool>)
    {
        if (daInputs.contains(true))
        {
            velocity.set(SPEED, 0);
            velocity.rotate(FlxPoint.weak(0, 0), curAngle);
        }
    }
}