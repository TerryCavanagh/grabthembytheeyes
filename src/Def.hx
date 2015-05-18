package;

import flash.display.*;
import flash.geom.*;
import flash.events.*;
import flash.net.*;
import com.terry.*;
	
class Def {
	public static var TITLEMODE:Int = 0;
	public static var CLICKTOSTART:Int = 1;
	public static var FOCUSMODE:Int = 2;
	public static var GAMEMODE:Int = 3;
	public static var EDITORMODE:Int = 4;
	
	public static var BIG:Int = 0;
	public static var TALL:Int = 1;
	public static var SCROLL:Int = 2;
	public static var BYTHE:Int = 3;
	
	public static var GRAY:Array<Int> = [64, 96, 128, 140, 192, 224];
	
	public static var TILESIZE:Int = 16;
	public static var SPRITESIZEWIDTH:Int = 64;
	public static var SPRITESIZEHEIGHT:Int = 128;
	public static var TILECOLUMNS:Int = 20;
	public static var TILEROWS:Int = 15;
	public static var SPRITECOLUMNS:Int = 20;
	public static var SPRITEROWS:Int = 6;
	public static var SCREENWIDTH:Int = Std.int(768/2);
	public static var SCREENHEIGHT:Int = Std.int(480/2);
	public static var SCREENTILEWIDTH:Int = 25;
	public static var SCREENTILEHEIGHT:Int = 15;
	public static var SCREENSCALE:Int = 2;
	
	public static var QUEUE_OFFSCREEN:Int = 0;
	public static var QUEUE_CENTER:Int = 1;
	public static var QUEUE_LEFT:Int = 2;
	public static var QUEUE_RIGHT:Int = 3;
	
	public static var MALE:Int = 0;
	public static var FEMALE:Int = 1;
	
	public static var FADED_IN:Int = 0;
	public static var FADED_OUT:Int = 1;
	public static var FADE_OUT:Int = 2;
	public static var FADING_OUT:Int = 3;
	public static var FADE_IN:Int = 4;
	public static var FADING_IN:Int = 5;
	
	public static var NODIRECTION:Int = -1;
	public static var UP:Int = 0;
	public static var DOWN:Int = 1;
	public static var LEFT:Int = 2;
	public static var RIGHT:Int = 3;
	
	public static var TEXTBORDER:Int = 0;
	public static var TEXTBACKING:Int = 1;
	public static var TEXTHIGHLIGHT:Int = 2;
	
	public static var DEVICEXRES:Int;
	public static var DEVICEYRES:Int;
}
