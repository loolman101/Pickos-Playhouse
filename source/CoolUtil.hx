package;

import lime.utils.Assets;

using StringTools;

// CREDIT TO NINJAMUFFIN LOL
class CoolUtil
{
	public static function coolTextFile(path:String):Array<String> 
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function textFileDynamic(path:String, ?splitter:String):Array<Dynamic> 
	{
		var daListVeeTwo:Array<Dynamic>;
		if (Assets.exists(path))
			daListVeeTwo = Assets.getText(path).trim().split(splitter);
		else return null;
	
		#if !windows
		for (i in 0...daListVeeTwo.length)
		{
			daListVeeTwo[i] = daListVeeTwo[i].trim();
		}
		#end

		return daListVeeTwo;
	}
}