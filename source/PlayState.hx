package;

import Room.CoolRoom;
import Level.JunkyLevel;
import RoomLine.SwagLine;
import SpriteData.CoolSprite;
import RoomCharacter.DumbCharacter;
import RoomTrigger.TriggerWarning;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUIState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;

using StringTools;

class PlayState extends FlxUIState
{
    var blocks:FlxTypedGroup<Block>;
    var groundBlocks:FlxTypedGroup<Block>;
    var sprites:FlxTypedGroup<PlayhouseObject>;
    var triggers:FlxTypedGroup<Trigger>;
    var players:FlxTypedGroup<Player>;

    public static var curLevel:JunkyLevel;
    var roomData:Array<Dynamic> = [];
    var curRoom:String = 'room1';

    var isPaused:Bool = false;

    var pickoChar:Char;

    var everyOtherCharacter:FlxTypedGroup<Char>;

    var pickoPlayer:Player;

    override function create()
    {
        if (curLevel == null)
           curLevel = Level.loadFromJson('level1');

        // trace(curLevel);

        var literalTextDude:Array<String> = CoolUtil.coolTextFile('assets/data/theCoolTest.txt');
        for (i in 0...literalTextDude.length)
        {
            literalTextDude[i] = checkForReturn(literalTextDude[i]);
        }

        blocks = new FlxTypedGroup<Block>();
        groundBlocks = new FlxTypedGroup<Block>();
        sprites = new FlxTypedGroup<PlayhouseObject>();
        triggers = new FlxTypedGroup<Trigger>();
        everyOtherCharacter = new FlxTypedGroup<Char>();
        
        // layering
        add(groundBlocks);
        add(blocks);
        add(sprites);
        add(everyOtherCharacter);
        add(triggers);

        generateRoom(0);

        players = new FlxTypedGroup<Player>(); // not sure if i need to do this but whatever lol maybe ill add 2 player support later
        add(players);

        pickoPlayer = new Player(100, 100);
        pickoPlayer.solid = true;
        players.add(pickoPlayer);

        pickoChar = new Char(pickoPlayer.x, pickoPlayer.y, 'picko');
        add(pickoChar);
    }

    function generateRoom(daRoom:Int)
    {
        var roomLines:Array<SwagLine> = curLevel.rooms[daRoom].lines;
        var spritesToDisplay:Array<CoolSprite> = curLevel.rooms[daRoom].sprites;
        var stupidCharacters:Array<DumbCharacter> = curLevel.rooms[daRoom].characters;
        var roomTriggers:Array<TriggerWarning> = curLevel.rooms[daRoom].triggers;

        for (k in 0...roomLines.length)
        {
            var curTiles = roomLines[k].tiles;
            
            for (i in 0...curTiles.length)
            {
                switch (curTiles[i])
                {
                    case 0:
                        var ground:Block = new Block(60 * i, 60 * k, 0xFF9E64B3);
                        groundBlocks.add(ground);
                    case 1:
                        var block:Block = new Block(60 * i, 60 * k, 0xFF6E467D);
                        block.solid = true;
                        block.immovable = true;
                        blocks.add(block);
                }
            }
        }

        for (k in 0...spritesToDisplay.length)
        {
            var spriteData:CoolSprite = spritesToDisplay[k];

            var obj:PlayhouseObject = new PlayhouseObject(spriteData.spritePos[0], spriteData.spritePos[1], spriteData.spriteName, spriteData.spriteSize);
            sprites.add(obj);
        }

        if (stupidCharacters != null)
        {
            for (char in stupidCharacters)
            {
                var realCharacter:Char = new Char(char.location[0], char.location[1], char.name);
                everyOtherCharacter.add(realCharacter);
            }
        }

        for (trigger in roomTriggers)
        {
            var newTrigger:Trigger = new Trigger(
                trigger.bounds[0], trigger.bounds[1], // position of the trigger
                trigger.bounds[2], trigger.bounds[3], // width and height of the trigger
                trigger.destination, 
                trigger.coords[0], trigger.coords[1]); // coords the player should be place at when touching the trigger
            triggers.add(newTrigger);
        }
    }

    // what
    var daPosX:Float;
    var daPosY:Float;

    override function update(elapsed:Float)
    {
        if (!isPaused)
            pickoPlayer.checkForInput();

        FlxG.collide(players, blocks);

        triggers.forEachAlive(function(newTrigger:Trigger)
        {
            checkForTrigger(newTrigger.x, newTrigger.y, 
                newTrigger.x + newTrigger.width, newTrigger.y + newTrigger.height, 
                newTrigger.assignedRoom, newTrigger.assignedPos);
        });

        pickoChar.setPosition(pickoPlayer.x - 11, pickoPlayer.y + pickoPlayer.height - pickoChar.height + 4);

        if (FlxG.keys.justPressed.SEVEN)
            FlxG.switchState(new LevelEditState());

        super.update(elapsed);
    }

    function checkForTrigger(x:Float, y:Float, x2:Float, y2:Float, nextRoom:Int, newPlayerCoords:Array<Float>)
    {
        var playerBoundingX:Float = pickoPlayer.x + pickoPlayer.width;
        var playerBoundingY:Float = pickoPlayer.y + pickoPlayer.height;

        if (playerBoundingX > x && playerBoundingX < x2 && playerBoundingY > y && playerBoundingY < y2 
            || pickoPlayer.x > x && pickoPlayer.x < x2 && pickoPlayer.y > y && pickoPlayer.y < y2
            || pickoPlayer.x > x && pickoPlayer.x < x2 && playerBoundingY > y && playerBoundingY < y2
            || playerBoundingX > x && playerBoundingX < x2 && pickoPlayer.y > y && pickoPlayer.y < y2)
            toNextRoom(nextRoom, newPlayerCoords);
    }
    
	function checkForReturn(oldText:String)
	{
		return oldText.replace('\\n', '\n');
	}

    function toNextRoom(daRoom:Int, daCoords:Array<Float>)
    {
        FlxG.log.add(daCoords);

        groundBlocks.kill();
        blocks.kill();
        sprites.kill();
        triggers.kill();
        everyOtherCharacter.kill();

        /*groundBlocks.destroy();
        blocks.destroy();
        sprites.destroy();
        triggers.destroy();*/

        remove(groundBlocks);
        remove(blocks);
        remove(sprites);
        remove(triggers);
        remove(everyOtherCharacter);

        blocks = new FlxTypedGroup<Block>();
        groundBlocks = new FlxTypedGroup<Block>();
        sprites = new FlxTypedGroup<PlayhouseObject>();
        triggers = new FlxTypedGroup<Trigger>();
        everyOtherCharacter = new FlxTypedGroup<Char>();

        pickoPlayer.setPosition(Std.int(daCoords[0]), Std.int(daCoords[1]));

        add(groundBlocks);
        add(blocks);
        add(sprites);
        add(triggers);
        add(everyOtherCharacter);
        
        generateRoom(daRoom);
    }
}