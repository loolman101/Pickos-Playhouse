package;

import RoomLine.SwagLine;
import SpriteData.CoolSprite;
import RoomCharacter.DumbCharacter;
import RoomTrigger.TriggerWarning;

typedef CoolRoom =
{
    var lines:Array<SwagLine>;
    var sprites:Array<CoolSprite>;
    var characters:Array<DumbCharacter>;
    var triggers:Array<TriggerWarning>;
}

class Room
{
    public var lines:Array<SwagLine>;
    public var sprites:Array<CoolSprite>;
    public var characters:Array<DumbCharacter>;
    public var triggers:Array<TriggerWarning>;

    public function new(lines, sprites, characters, triggers)
    {
        this.lines = lines;
        this.sprites = sprites;
        this.characters = characters;
        this.triggers = triggers;
    }
}