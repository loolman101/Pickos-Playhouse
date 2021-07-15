package;

import Room.CoolRoom;
import Level.JunkyLevel;
import RoomLine.SwagLine;
import SpriteData.CoolSprite;
import RoomCharacter.DumbCharacter;
import RoomTrigger.TriggerWarning;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.util.FlxColor;

using StringTools;

class LevelEditState extends FlxUIState
{
    var grid:FlxSprite;
    var highlighter:FlxSprite;
    var curColor:FlxColor = 0xFF9E64B3;

    var placedTiles:Array<Array<Int>> = [
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    ];

    var renderedTiles:Array<Array<Block>> = [
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
    ];

    override function create()
    {
        grid = FlxGridOverlay.create(60, 60);
        add(grid);

        highlighter = new FlxSprite().makeGraphic(60, 60, curColor);
        highlighter.alpha = 0.5;

        for (i in 0...placedTiles.length)
        {
            for (k in 0...placedTiles[i].length)
            {
                var renderedBlock:Block = new Block(60 * k, 60 * i, FlxColor.WHITE);
                renderedBlock.color = getCol(placedTiles[i][k]);
                renderedTiles[i].push(renderedBlock);
                add(renderedBlock);
            }
        }

        // ===============
        add(highlighter);
        super.create();
    }

    var blckClrs:Array<FlxColor> = [0xFF9E64B3, 0xFF6E467D];

    function getCol(clr:Int):FlxColor
    {
        return blckClrs[clr];
    }

    override function update(t:Float)
    {
        highlighter.x = Math.floor(FlxG.mouse.x / 60) * 60;
		highlighter.y = Math.floor(FlxG.mouse.y / 60) * 60;

        for (i in renderedTiles)
        {
            for (block in i)
            {
                if (FlxG.mouse.overlaps(block))
                {
                    if (FlxG.mouse.pressed)
                    {
                        block.color = curColor;
                        block.alpha = 1;
                    }
                    else if (FlxG.mouse.pressedRight)
                        block.alpha = 0;
                }
            }
        }

        if (FlxG.keys.justPressed.Z)
            swapColor();

        super.update(t);
    }

    function saveLevel()
    {
        return null;
    }

    function swapColor()
    {
        switch (curColor)
        {
            case 0xFF9E64B3:
                curColor = 0xFF6E467D;
            case 0xFF6E467D:
                curColor = 0xFF9E64B3;
        }

        highlighter.color = curColor;
    }
}