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
import haxe.Json;
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import flixel.text.FlxText;
import lime.app.Application;
import flixel.FlxCamera;
import openfl.text.TextField;
import openfl.display.Stage;

using StringTools;

class LevelEditState extends FlxUIState
{
    var grid:FlxSprite;
    var highlighter:FlxSprite;
    var curColor:FlxColor = 0xFF9E64B3;

    var _level:JunkyLevel = new Level([]);
    var _file:FileReference;

    var camLevel:FlxCamera;
    var camHUD:FlxCamera;

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

    var modeText:FlxText;
    var modes:Array<String> = [
        'Block Edit',
        'Sprite Edit',
        'Trigger Edit',
        'Char Edit'
    ];
    var curMode:Int = 0;

    var sprites:Array<FlxSprite> = [];

    override function create()
    {
        camLevel = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);
        camHUD = new FlxCamera();
        FlxG.cameras.add(camLevel);
        FlxG.cameras.add(camHUD);
        FlxG.cameras.setDefaultDrawTarget(camLevel, true);

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

        modeText = new FlxText(0, 0, 0, '', 24);
        modeText.cameras = [camHUD];
        add(modeText);

        // ===============
        add(highlighter);
        super.create();
    }

    var blckClrs:Array<FlxColor> = [0xFF9E64B3, 0xFF6E467D];

    function getCol(clr:Int):FlxColor
    {
        return blckClrs[clr];
    }

    function getColNum(clr:FlxColor):Int
    {
        return blckClrs.indexOf(clr);
    }

    override function update(t:Float)
    {
        highlighter.x = Math.floor(FlxG.mouse.x / 60) * 60;
		highlighter.y = Math.floor(FlxG.mouse.y / 60) * 60;

        if (!doingSomething)
        {
            switch (curMode)
            {
                case 0:
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
                case 1:
                    if (FlxG.keys.justPressed.K)
                        addSprite();

                    for (spr in sprites)
                    {
                        // nothgin
                    }
            }

            if (FlxG.keys.justPressed.LBRACKET)
                changeMode(-1);
            if (FlxG.keys.justPressed.RBRACKET)
                changeMode(1);

            if (FlxG.keys.justPressed.Z)
                swapColor();

            if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.S)
                saveLevel();
        }

        modeText.text = modes[curMode] + ' Mode';

        super.update(t);
    }

    var doingSomething:Bool = false;

    function addSprite():Void
    {
        doingSomething = true;
        Application.current.createWindow({
            y: 100,
            x: 100,
            width: 500,
            height: 250,
            title: 'ENTER SPRITE NAME',
            resizable: false,
            alwaysOnTop: true
        });
        Application.current.windows[1].onClose.add(function() doingSomething = false);
        // Application.current.windows[1].addChild(new TextField());
    }

    function changeMode(change:Int):Void
    {
        curMode += change;
        if (curMode >= modes.length)
            curMode = 0;
        if (curMode < 0)
            curMode = modes.length - 1;
    }

    function saveLevel():Void
    {
        _level = new Level([]);
        placedTiles = [];
        var allLines:Array<SwagLine> = [];
        for (i in renderedTiles)
        {
            var coolLine:Array<Int> = [];
            for (block in i)
            {
                if (block.alpha > 0)
                    coolLine.push(getColNum(block.color));
                else
                    coolLine.push(-1);
            }
            placedTiles.push(coolLine);
            allLines.push(new RoomLine(coolLine));
        }
        var daRoom:Room = new Room(allLines, [], [], []);
        _level.rooms.push(daRoom);

        var json = {
            "level": _level
        };

        var saveData:String = Json.stringify(json);

        if ((saveData != null) && (saveData.length > 0))
		{
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(saveData.trim(), "level.json");
		}
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

    function onSaveComplete(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved LEVEL DATA.");
	}

	/**
	 * Called when the save file dialog is cancelled.
	 */
	function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	/**
	 * Called if there is an error while saving the gameplay recording.
	 */
	function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving Level data");
	}
}