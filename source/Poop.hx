import openfl.Event;

class Poop
{
    public function new()
    {
        addEventListener(Event.ENTER_FRAME, junk));
    }

    private function junk():Void
    {
        trace('deez');
    }
}