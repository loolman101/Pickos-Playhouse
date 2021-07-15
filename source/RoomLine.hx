package;

typedef SwagLine = {
    var tiles:Array<Int>;
}

class RoomLine
{
    public var tiles = [];

    public function new(tiles:Array<Int>)
    {
        this.tiles = tiles;
    }
}