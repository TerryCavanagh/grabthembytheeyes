package com.terry;
	
import openfl.Assets;
import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;
import openfl.text.*;

class Text{
	public static function init():Void {
		initfont();
	}
	
	//Text Functions
	public static function initfont():Void {
		for (i in 0...5){
			fontsize.push(0); 
			tf.push(new TextField());
			#if !flash
			tfbuf.push(new BitmapData(768, 25, true, 0));
			#end
		}
		
		fontsize[0] = 8;
		fontsize[1] = 16;
		fontsize[2] = 16;
		fontsize[3] = 32;
		fontsize[4] = 48;
		var font = Assets.getFont(Init.fontlocation);
		fontname = font.fontName;
		
		for (i in 0...5){
			tf[i].embedFonts = true;
			tf[i].defaultTextFormat = new TextFormat(fontname, fontsize[i], 0, false);
			tf[i].selectable = false;
			tf[i].width = Gfx.screenwidth * 100; tf[i].height = 48;
			tf[i].antiAliasType = AntiAliasType.NORMAL;
		}
	}
	
	//Text functions
	public static function rprint(x:Int, y:Int, t:String, r:Int, g:Int, b:Int):Void {
		x = Std.int(x - len(t));
		print(x, y, t, r, g, b, false);
	}
	
	public static function print(x:Int, y:Int, t:String, r:Int, g:Int, b:Int, cen:Bool = false):Void {
		if (r < 0) r = 0; if (g < 0) g = 0; if (b < 0) b = 0;
		if (r > 255) r = 255; if (g > 255) g = 255; if (b > 255) b = 255;
		
		tf[0].textColor = Gfx.RGB(r, g, b);
		tf[0].text = t;
		if (cen) x = Gfx.screenwidthmid - Std.int(tf[0].textWidth / 2) + x;
		
		Gfx.shapematrix.identity();
		Gfx.shapematrix.translate(x, y);
		tf[0].textColor = Gfx.RGB(r, g, b);
		Gfx.backbuffer.draw(tf[0], Gfx.shapematrix);
	}
	
	public static function getsmallcent(t:String):Int {
		tf[0].text = t;
		return 24 - Std.int(tf[0].textWidth / 2);
	}
	
	public static function getbigcent(t:String):Int {
		tf[1].text = t;
		#if html5
		return Std.int(24 - (tf[1].textWidth / 2)) - 2;
		#else
		return Std.int(24 - (tf[1].textWidth / 2)) - 1;
		#end
	}
	
		public static function smallprint(x:Int, y:Int, t:String, r:Int, g:Int, b:Int, cen:Bool = false):Void {
		if (r < 0) r = 0; if (g < 0) g = 0; if (b < 0) b = 0;
		if (r > 255) r = 255; if (g > 255) g = 255; if (b > 255) b = 255;
		
		tf[0].textColor = Gfx.RGB(r, g, b);
		tf[0].text = t;
		if (cen) x = Gfx.screenwidthmid - Std.int(tf[0].textWidth / 2) + x;
		
		Gfx.shapematrix.identity();
		Gfx.shapematrix.translate(x, y);
		tf[0].textColor = Gfx.RGB(r, g, b);
		Gfx.backbuffer.draw(tf[0], Gfx.shapematrix);
	}
	
	public static function smallbigprint(x:Int, y:Int, t:String, r:Int, g:Int, b:Int, cen:Bool = false):Void {
		if (r < 0) r = 0; if (g < 0) g = 0; if (b < 0) b = 0;
		if (r > 255) r = 255; if (g > 255) g = 255; if (b > 255) b = 255;
		
		tf[0].textColor = Gfx.RGB(r, g, b);
		tf[0].text = t;
		if (cen) x = Gfx.screenwidthmid - Std.int(tf[0].textWidth / 2) + x;
		
		#if flash
		Gfx.shapematrix.identity();
		Gfx.shapematrix.scale(1, 2);
		Gfx.shapematrix.translate(x, y);
		tf[0].textColor = Gfx.RGB(r, g, b);
		Gfx.backbuffer.draw(tf[0], Gfx.shapematrix);
		
		Gfx.shapematrix.translate( -x, -y);
		#else
		tfbuf[0].fillRect(tfbuf[0].rect, 0);
		Gfx.shapematrix.identity();
		tf[0].textColor = Gfx.RGB(r, g, b);
		tfbuf[0].draw(tf[0], Gfx.shapematrix);
		
		Gfx.shapematrix.scale(1, 2);
		Gfx.shapematrix.translate(x, y);
		Gfx.backbuffer.draw(tfbuf[0], Gfx.shapematrix);
		
		Gfx.shapematrix.translate(-x, -y);
		#end
	}
	
	public static function rsmallbigprint(x:Int, y:Int, t:String, r:Int, g:Int, b:Int, cen:Bool = false):Void {
		if (r < 0) r = 0; if (g < 0) g = 0; if (b < 0) b = 0;
		if (r > 255) r = 255; if (g > 255) g = 255; if (b > 255) b = 255;
		
		tf[0].textColor = Gfx.RGB(r, g, b);
		tf[0].text = t;
		if (cen) x = Gfx.screenwidthmid - Std.int(tf[0].textWidth / 2) + x;
		x = x - Std.int(tf[0].textWidth);
		
		#if flash
		Gfx.shapematrix.identity();
		Gfx.shapematrix.scale(1, 2);
		Gfx.shapematrix.translate(x, y);
		tf[0].textColor = Gfx.RGB(r, g, b);
		Gfx.backbuffer.draw(tf[0], Gfx.shapematrix);
		
		Gfx.shapematrix.translate( -x, -y);
		
		#else
		tfbuf[0].fillRect(tfbuf[2].rect, 0);
		Gfx.shapematrix.identity();
		tf[0].textColor = Gfx.RGB(r, g, b);
		tfbuf[0].draw(tf[0], Gfx.shapematrix);
		
		Gfx.shapematrix.scale(1, 2);
		Gfx.shapematrix.translate(x, y);
		Gfx.backbuffer.draw(tfbuf[0], Gfx.shapematrix);
		
		Gfx.shapematrix.translate(-x, -y);
		#end
	}
	
	public static function normalprint(x:Int, y:Int, t:String, r:Int, g:Int, b:Int, cen:Bool = false):Void {
		if (r < 0) r = 0; if (g < 0) g = 0; if (b < 0) b = 0;
		if (r > 255) r = 255; if (g > 255) g = 255; if (b > 255) b = 255;
		
		tf[2].textColor = Gfx.RGB(r, g, b);
		tf[2].text = t;
		if (cen) x = Gfx.screenwidthmid - Std.int(tf[2].textWidth / 2) + x;
		
		Gfx.shapematrix.identity();
		Gfx.shapematrix.translate(x, y);
		tf[2].textColor = Gfx.RGB(r, g, b);
		Gfx.backbuffer.draw(tf[2], Gfx.shapematrix);
	}
	
	public static function normaltallprint(x:Int, y:Int, t:String, r:Int, g:Int, b:Int, cen:Bool = false):Void {
		if (r < 0) r = 0; if (g < 0) g = 0; if (b < 0) b = 0;
		if (r > 255) r = 255; if (g > 255) g = 255; if (b > 255) b = 255;
		
		tf[2].textColor = Gfx.RGB(r, g, b);
		tf[2].text = t;
		if (cen) x = Gfx.screenwidthmid - Std.int(tf[2].textWidth / 2) + x;
		
		#if flash
		Gfx.shapematrix.identity();
		Gfx.shapematrix.scale(1, 2);
		Gfx.shapematrix.translate(x, y);
		tf[2].textColor = Gfx.RGB(r, g, b);
		Gfx.backbuffer.draw(tf[2], Gfx.shapematrix);
		
		Gfx.shapematrix.translate( -x, -y);
		#else
		tfbuf[2].fillRect(tfbuf[2].rect, 0);
		Gfx.shapematrix.identity();
		tf[2].textColor = Gfx.RGB(r, g, b);
		tfbuf[2].draw(tf[2], Gfx.shapematrix);
		
		Gfx.shapematrix.scale(1, 2);
		Gfx.shapematrix.translate(x, y);
		Gfx.backbuffer.draw(tfbuf[2], Gfx.shapematrix);
		
		Gfx.shapematrix.translate(-x, -y);
		#end
	}
	
	
	public static function tallprint(x:Int, y:Int, t:String, r:Int, g:Int, b:Int, cen:Bool = false):Void {
		if (r < 0) r = 0; if (g < 0) g = 0; if (b < 0) b = 0;
		if (r > 255) r = 255; if (g > 255) g = 255; if (b > 255) b = 255;
		
		tf[0].textColor = Gfx.RGB(r, g, b);
		tf[0].text = t;
		if (cen) x = 24 - Std.int(tf[0].textWidth / 2) + x;
		
		#if flash
		Gfx.shapematrix.identity();
		Gfx.shapematrix.scale(1, 2);
		Gfx.shapematrix.translate(x, y);
		tf[0].textColor = Gfx.RGB(r, g, b);
		Gfx.signbuffer[Gfx.sign].draw(tf[0], Gfx.shapematrix);
		
		Gfx.shapematrix.translate( -x, -y);
		#else
		tfbuf[0].fillRect(tfbuf[0].rect, 0);
		Gfx.shapematrix.identity();
		tf[0].textColor = Gfx.RGB(r, g, b);
		tfbuf[0].draw(tf[0], Gfx.shapematrix);
		
		Gfx.shapematrix.scale(1, 2);
		Gfx.shapematrix.translate(x, y);
		Gfx.signbuffer[Gfx.sign].draw(tfbuf[0], Gfx.shapematrix);
		
		Gfx.shapematrix.translate(-x, -y);
		#end
	}
	
	public static function tallprint_crush(x:Int, y:Int, t:String, crush:Int, r:Int, g:Int, b:Int, cen:Bool = false):Void {
		if (r < 0) r = 0; if (g < 0) g = 0; if (b < 0) b = 0;
		if (r > 255) r = 255; if (g > 255) g = 255; if (b > 255) b = 255;
		
		tf[0].textColor = Gfx.RGB(r, g, b);
		tf[0].text = t;
		if (cen) x = 24 - Std.int(tf[0].textWidth / 2) + x;
		
		#if flash
		Gfx.shapematrix.identity();
		Gfx.shapematrix.scale(1, 2);
		Gfx.shapematrix.translate(x, y);
		tf[0].textColor = Gfx.RGB(r, g, b);
		Gfx.signbuffer[Gfx.sign].draw(tf[0], Gfx.shapematrix);
		
		Gfx.shapematrix.translate( -x, -y);
		#else
		tfbuf[0].fillRect(tfbuf[0].rect, 0);
		Gfx.shapematrix.identity();
		tf[0].textColor = Gfx.RGB(r, g, b);
		tfbuf[0].draw(tf[0], Gfx.shapematrix);
		
		Gfx.shapematrix.scale(1, 2);
		Gfx.shapematrix.translate(x, y);
		Gfx.signbuffer[Gfx.sign].draw(tfbuf[0], Gfx.shapematrix);
		
		Gfx.shapematrix.translate(-x, -y);
		#end
		
		while(crush>0){
			Gfx.crushtext();
			crush--;
		}
	}
	
	
	public static function normallen(t:String, sz:Int = 3):Float {
		if (sz > 0 && sz <= 5) {
			tf[sz-1].text = t;
			return tf[sz - 1].textWidth;
		}
		
		tf[0].text = t;
		return tf[0].textWidth;
	}
	
	public static function normalhig(t:String, sz:Int = 3):Float {
		if (sz > 0 && sz <= 5) {
			tf[sz-1].text = t;
			return tf[sz-1].textHeight;
		}
		
		tf[0].text = t;
		return tf[0].textHeight;
	}
	
	public static function len(t:String, sz:Int = 1):Float {
		if (sz > 0 && sz <= 5) {
			tf[sz-1].text = t;
			return tf[sz - 1].textWidth;
		}
		
		tf[0].text = t;
		return tf[0].textWidth;
	}
	
	public static function hig(t:String, sz:Int = 1):Float {
		if (sz > 0 && sz <= 5) {
			tf[sz-1].text = t;
			return tf[sz-1].textHeight;
		}
		
		tf[0].text = t;
		return tf[0].textHeight;
	}
	
	public static function rbigprint(x:Int, y:Int, t:String, r:Int, g:Int, b:Int, cen:Bool = false, sc:Int = 2):Void {
		x = Std.int(x - len(t, sc));
		bigprint(x, y, t, r, g, b, cen, sc);
	}
	
	public static function bigprint(x:Int, y:Int, t:String, r:Int, g:Int, b:Int, cen:Bool = false, sc:Int = 2):Void {
		if (r < 0) r = 0; if (g < 0) g = 0; if (b < 0) b = 0;
		if (r > 255) r = 255; if (g > 255) g = 255; if (b > 255) b = 255;
		
		tf[sc - 1].text = t;
		#if html5
		if (cen) x = Std.int(24 - (tf[sc - 1].textWidth / 2)) - 2;
		#else
		if (cen) x = Std.int(24 - (tf[sc - 1].textWidth / 2)) - 1;
		#end
		
		Gfx.shapematrix.identity();
		Gfx.shapematrix.translate(x, y);
		tf[sc-1].textColor = Gfx.RGB(r, g, b);
		Gfx.signbuffer[Gfx.sign].draw(tf[sc-1], Gfx.shapematrix);
		
		Gfx.shapematrix.translate( -x, -y);
	}
	
	public static function bigprint_crush(x:Int, y:Int, t:String, crush:Int, r:Int, g:Int, b:Int, cen:Bool = false, sc:Int = 2):Void {
		if (r < 0) r = 0; if (g < 0) g = 0; if (b < 0) b = 0;
		if (r > 255) r = 255; if (g > 255) g = 255; if (b > 255) b = 255;
		
		tf[sc - 1].text = t;
		#if html5
		if (cen) x = Std.int(24 - (tf[sc - 1].textWidth / 2)) - 2;
		#else
		if (cen) x = Std.int(24 - (tf[sc - 1].textWidth / 2)) - 1;
		#end
		
		Gfx.shapematrix.identity();
		Gfx.shapematrix.translate(x, y);
		tf[sc-1].textColor = Gfx.RGB(r, g, b);
		Gfx.signbuffer[Gfx.sign].draw(tf[sc-1], Gfx.shapematrix);
		
		Gfx.shapematrix.translate(-x, -y);
		
		while(crush>0){
			Gfx.crushtext();
			crush--;
		}
	}
	
	#if !flash
	public static var tfbuf:Array<BitmapData> = new Array<BitmapData>();
	#end
	public static var tf:Array<TextField> = new Array<TextField>();
	public static var fontsize:Array<Int> = new Array<Int>();
	public static var fontname:String;
}