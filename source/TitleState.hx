package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUIState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;
import io.newgrounds.NG;

using StringTools;

class TitleState extends FlxUIState
{
    static var initialized:Bool = false;
    static public var soundExt:String = ".mp3";

    override public function create()
    {
        #if (!web)
		TitleState.soundExt = '.ogg';
		#end

        if (!initialized)
        {
            var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
            diamond.persist = true;
            diamond.destroyOnNoUse = false;
    
            FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
                new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
            FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
                {asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
    
            transIn = FlxTransitionableState.defaultTransIn;
            transOut = FlxTransitionableState.defaultTransOut;
    
            // HAD TO MODIFY SOME BACKEND SHIT
            // IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
            // https://github.com/HaxeFlixel/flixel-addons/pull/348
        }

        var bg:FlxSprite = new FlxSprite(0).loadGraphic('assets/images/titleBG.png');
        add(bg);

        var pickoTitle:FlxSprite = new FlxSprite(274, 116).loadGraphic('assets/images/Picko_Title.png');
        add(pickoTitle);

        var logo:FlxSprite =  new FlxSprite(111, 516);
        logo.frames = FlxAtlasFrames.fromSparrow('assets/images/logo.png', 'assets/images/logo.xml');
        logo.animation.addByPrefix('idle', 'logo spin', 24, true);
        logo.animation.play('idle');
        add(logo);

        FlxG.sound.playMusic('assets/music/title' + TitleState.soundExt);

        initialized = true;
    }

    override public function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.ENTER)
            FlxG.switchState(new PlayState());

        super.update(elapsed);
    }
}