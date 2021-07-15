package;

import Room.CoolRoom;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

typedef JunkyLevel =
{
    var rooms:Array<CoolRoom>;
}

class Level
{
    public var rooms:Array<CoolRoom>;

    public function new(rooms)
    {
        this.rooms = rooms;
    }

    public static function loadFromJson(jsonInput:String):JunkyLevel
    {
        var rawJson = Assets.getText('assets/data/levels/' + jsonInput.toLowerCase() + '.json').trim();
    
        while (!rawJson.endsWith("}"))
        {
            rawJson = rawJson.substr(0, rawJson.length - 1);
        } 

        // trace(rawJson);

        return parseJSONjunk(rawJson);
    }
    
    public static function parseJSONjunk(rawJson:String):JunkyLevel
    {
        var thingy:JunkyLevel = cast Json.parse(rawJson).level;
        return thingy;
    }
}