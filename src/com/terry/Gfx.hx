package com.terry;
	
import haxe.ds.IntMap;
import openfl._v2.geom.Point;
import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;
import openfl.text.*;
import openfl.Assets;
import gamecontrol.*;

class Gfx {
	public static function init(stage:Stage):Void {
		initgfx();
		Text.init();
		
		for (i in 0...20) messagelines.push(new String(""));
		nummessagelines = 0;
		
		stage.addChild(screen);
	}
	
	//Initialise arrays here
	public static function initgfx():Void {
		//We initialise a few things
		screenwidth = Def.SCREENWIDTH; screenheight = Def.SCREENHEIGHT;
		screenwidthmid = Std.int(screenwidth / 2); screenheightmid = Std.int(screenheight / 2);
		screenviewwidth = screenwidth; screenviewheight = screenheight;
		
		tiles_rect = new Rectangle(0, 0, Def.TILESIZE, Def.TILESIZE);
		sprites_rect = new Rectangle(0, 0, Def.SPRITESIZEWIDTH, Def.SPRITESIZEHEIGHT);
		cards_rect = new Rectangle(0, 0, 74, 96);
		minicards_rect = new Rectangle(0, 0, 18, 24);
		trect = new Rectangle(); tpoint = new Point();
		tbuffer = new BitmapData(1, 1, true);
		ct = new ColorTransform(0, 0, 0, 1, 255, 255, 255, 1); //Set to white
		temptile = new BitmapData(Def.TILESIZE, Def.TILESIZE, true, 0x000000);
		fademode = 0; fadeamount = 0; fadeaction = "nothing";
		
		tbsides_rect=new Rectangle(0,0,16,16);
		
		//Scaling stuff
		bigbuffer = new BitmapData(screenwidth, screenheight, true, 0x000000);
		bigbufferscreen = new Bitmap(bigbuffer);
		bigbufferscreen.width = screenwidth * 2;
		bigbufferscreen.height = 64;
		scaleMatrix = new Matrix();
		
		backbuffer = new BitmapData(screenwidth, screenheight, false, 0x000000);
		screenbuffer = new BitmapData(screenwidth, screenheight, false, 0x000000);
		textboxbuffer = new BitmapData(screenwidth, screenheight, false, 0x00000000);
		
		numsigns = 1;
		totalsigns = 6;
		supersignbuffer = new BitmapData(48, 16, false, 0x000000);
		for (i in 0...totalsigns) {
			signbuffer.push(new BitmapData(48, 16, false, 0x000000));
			
			text_red.push(0);
			text_green.push(0);
			text_blue.push(0);
			
			gradient.push(false);
			currentcol.push("white");
			stripe.push(false);
			stripestart.push(0);
			stripeend.push(0);
			stripecol.push("white");
			
			fire.push(false);
			firex.push(0);
			
			colourstate.push(0);
			colourdelay.push(0);
			
			border.push("none");
			borderstate.push(0);
			borderdelay.push(0);
		}
		tempbuffer = new BitmapData(48, 16, false, 0x000000);
		
		screen = new Bitmap(screenbuffer);
		screen.width = screenwidth * Def.SCREENSCALE;
		screen.height = screenheight * Def.SCREENSCALE;
	}
	
	public static function settrect(x:Int, y:Int, w:Int, h:Int):Void {
		trect.x = x;
		trect.y = y;
		trect.width = w;
		trect.height = h;
	}
	
	public static function settpoint(x:Int, y:Int):Void {
		tpoint.x = x;
		tpoint.y = y;
	}
	
	public static function maketilearray(filename:String):Void {
		buffer = new Bitmap(Assets.getBitmapData(filename)).bitmapData;
		
		for (j in 0...Def.TILEROWS) {
			for (i in 0...Def.TILECOLUMNS) {
				var t:BitmapData = new BitmapData(Def.TILESIZE, Def.TILESIZE, true, 0x000000);
				settrect(i * Def.TILESIZE, j * Def.TILESIZE, Def.TILESIZE, Def.TILESIZE);
				var temprect:Rectangle = trect;	
				t.copyPixels(buffer, temprect, tl);
				tiles.push(t);
			}
		}
	}	
	
	public static function makecardsarray(filename:String):Void {
		buffer = new Bitmap(Assets.getBitmapData(filename)).bitmapData;
		
		for (j in 0...1) {
			for (i in 0...6) {
				var t:BitmapData = new BitmapData(Std.int(cards_rect.width), Std.int(cards_rect.height), true, 0x000000);
				settrect(Std.int(i * cards_rect.width), Std.int(j * cards_rect.height), Std.int(cards_rect.width), Std.int(cards_rect.height));
				var temprect:Rectangle = trect;	
				t.copyPixels(buffer, temprect, tl);
				cards.push(t);
			}
		}
	}
	
	
	public static function makeminicardsarray(filename:String):Void {
		buffer = new Bitmap(Assets.getBitmapData(filename)).bitmapData;
		
		for (j in 0...1) {
			for (i in 0...5) {
				var t:BitmapData = new BitmapData(Std.int(minicards_rect.width), Std.int(minicards_rect.height), true, 0x000000);
				settrect(Std.int(i * minicards_rect.width), Std.int(j * minicards_rect.height), Std.int(minicards_rect.width), Std.int(minicards_rect.height));
				var temprect:Rectangle = trect;	
				t.copyPixels(buffer, temprect, tl);
				minicards.push(t);
			}
		}
	}
	
	public static var stringbreak:String;
	public static var stringbreakcounter:Int;
	public static var stringbreakline:Int;
	
	public static var messagelines:Array<String> = new Array<String>();
	public static var nummessagelines = 0;
	
	public static function splitmessage(t:String, limit:Int):Void {
		//tb[m].addline(t);
		stringbreak = ""; stringbreakcounter = 0; stringbreakline = 0;
		nummessagelines = 0;
		
		while (stringbreakcounter < Text.len(t)) {
			stringbreak += Help.Mid(t, stringbreakcounter);
			if (Text.len(stringbreak) >= limit) {
				//Ok: stringbreak now contains a chunk of a sentence.
				//We need to work back and find the last space in this, then readjust everything.
				while (Help.Mid(stringbreak, stringbreak.length-1) != " ") {
					stringbreak = Help.Mid(stringbreak, 0, stringbreak.length - 1);
					stringbreakcounter--;
					if (stringbreakcounter < 0) {						
						//Ok, I guess there's no nice place to break this line. Let's just do it
						//The nasty way instead
						nastybreak(t, limit);
						return;
					}
				}
				messagelines[nummessagelines] = stringbreak;
				nummessagelines++;
				stringbreakline++;
				stringbreak = "";
			}
			stringbreakcounter++;
		}
		
		
		//Anything leftover?
		if (Text.len(stringbreak) > 0) {
			messagelines[nummessagelines] = stringbreak;
			nummessagelines++;
			stringbreakline++;
			stringbreak = "";
		}
	}
	
	public static function nastybreak(t:String, limit:Int):Void {
		//Just break at the limit, without trying to break at spaces
		stringbreak = ""; stringbreakcounter = 0; stringbreakline = 0;
		nummessagelines = 0;
		
		while (Text.len(t) > stringbreakline + limit) {
			stringbreak = "";
			while (Text.len(stringbreak) < limit) {
				stringbreak += Help.Mid(t, stringbreakcounter, 1);
				stringbreakcounter++;
			}
			stringbreak = Help.Left(stringbreak, stringbreak.length - 1);
			stringbreakcounter--;
			messagelines[nummessagelines] = stringbreak;
			nummessagelines++;
			
			stringbreakline += Std.int(Text.len(stringbreak));
			
		}
		
		//The left overs
		messagelines[nummessagelines] = t.substr(stringbreakcounter);
		nummessagelines++;
	}
	
	public static function drawcard(xp:Int, yp:Int, c:Card, downscore:Bool=false):Void {
		if (c.type == "message") {
			Gfx.drawcardgraphic(xp, yp, 0, 0);
			//Gfx.smallbigprint(xp + 7, yp + 5, "MESSAGE", 65, 24, 3, false);
			Gfx.smallbigprint(xp + 7, yp + 5, "MESSAGE", 58, 58, 58, false);
			
			if (downscore) {
				Gfx.smallbigprint(xp + 62, yp + 5, Std.string(c.score), 255, 0, 0, false);
			}else{
				Gfx.smallbigprint(xp + 62, yp + 5, Std.string(c.score), 255, 255, 255, false);
			}
			
			if(c.special=="none"){
				splitmessage("\"" + c.name + "\"", 62);
			}else {
				splitmessage("\"" + c.name +"\"" + "*", 60);
			}
			
			for (i in 0...nummessagelines) {
				tx = Std.int((74 / 2) - ((Text.len(messagelines[i])) / 2))+1;
				ty = Std.int(26 + (62 / 2) + (i * 14) - (nummessagelines * 7));
				Gfx.smallbigprint(xp + tx, yp + ty, messagelines[i], Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
			}
			
			if (c.special == "filthyburgeronly") {
				Gfx.smallprint(xp+4, yp + 94+4, "*USELESS TO JAY", Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
			}else if (c.special == "jayonly") {
				Gfx.smallprint(xp + 4, yp + 94+4, "*USELESS TO", Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
				Gfx.smallprint(xp+4, yp + 94+6+4, " FILTHY BURGER", Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
			}
			
		}else if (c.type == "colour") {
			Gfx.drawcardgraphic(xp, yp, 1, 0);
			Gfx.smallbigprint(xp + 7, yp + 5, "COLOUR", 65, 3, 38, false);
			
			if (downscore) {
				Gfx.smallbigprint(xp + 62, yp + 5, Std.string(c.score), 255, 0, 0, false);
			}else {
				Gfx.smallbigprint(xp + 62, yp + 5, Std.string(c.score), 255, 255, 255, false);
			}
			
			if (Text.len(c.name,3) < 64) {
				tx = Std.int((74 / 2) - ((Text.len(c.name, 3)) / 2)) + 1;
				ty = Std.int(26 + (62 / 2) - (24 / 2));
				Gfx.normalbigprint(xp + tx, yp + ty, c.name, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
			}else{
				tx = Std.int((74 / 2) - ((Text.len(c.name)) / 2))+1;
				ty = Std.int(26 + (62 / 2) - (14 / 2));
				Gfx.smallbigprint(xp + tx, yp + ty, c.name, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
			}
		}else if (c.type == "border") {
			Gfx.drawcardgraphic(xp, yp, 2, 0);
			Gfx.smallbigprint(xp + 7, yp + 5, "BORDER", 8, 65, 3, false);
			
			if (downscore) {
				Gfx.smallbigprint(xp + 62, yp + 5, Std.string(c.score), 255, 0, 0, false);
			}else {
				Gfx.smallbigprint(xp + 62, yp + 5, Std.string(c.score), 255, 255, 255, false);
			}
			
			if (Text.len(c.name,3) < 64) {
				tx = Std.int((74 / 2) - ((Text.len(c.name, 3)) / 2)) + 1;
				ty = Std.int(26 + (62 / 2) - (24 / 2));
				Gfx.normalbigprint(xp + tx, yp + ty, c.name, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
			}else{
				tx = Std.int((74 / 2) - ((Text.len(c.name)) / 2))+1;
				ty = Std.int(26 + (62 / 2) - (14 / 2));
				Gfx.smallbigprint(xp + tx, yp + ty, c.name, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
			}
		}else if (c.type == "effect") {
			Gfx.drawcardgraphic(xp, yp, 3, 0);
			Gfx.smallbigprint(xp + 7, yp + 5, "EFFECT", 20, 27, 83, false);
			
			if (downscore) {
				Gfx.smallbigprint(xp + 62, yp + 5, Std.string(c.score), 255, 0, 0, false);
			}else {
				Gfx.smallbigprint(xp + 62, yp + 5, Std.string(c.score), 255, 255, 255, false);
			}
			
			if (Text.len(c.name,3) < 64) {
				tx = Std.int((74 / 2) - ((Text.len(c.name, 3)) / 2)) + 1;
				ty = Std.int(26 + (62 / 2) - (24 / 2));
				Gfx.normalbigprint(xp + tx, yp + ty, c.name, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
			}else{
				tx = Std.int((74 / 2) - ((Text.len(c.name)) / 2))+1;
				ty = Std.int(26 + (62 / 2) - (14 / 2));
				Gfx.smallbigprint(xp + tx, yp + ty, c.name, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
			}
		}else if (c.type == "extraframe") {
			Gfx.drawcardgraphic(xp, yp, 4, 0);
			
			tx = Std.int((74 / 2) - ((Text.len("EXTRA", 3)) / 2)) + 1;
			ty = Std.int((96 / 2) - (24 / 2)-12);
			Gfx.normalbigprint(xp + tx, yp + ty, "EXTRA", 0 ,0 ,0 , false);
			
			tx = Std.int((74 / 2) - ((Text.len("FRAME", 3)) / 2)) + 1;
			ty = Std.int((96 / 2) - (24 / 2)+12);
			Gfx.normalbigprint(xp + tx, yp + ty, "FRAME",  0 ,0 ,0, false);
		}
	}
	
	public static function drawminicard(xp:Int, yp:Int, c:Card, mystery:Bool = false):Void {
		if (c.type == "message") {
			Gfx.drawminicardgraphic(xp, yp, 0, 0);
			if (mystery) {
				Gfx.smallbigprint(xp + 7, yp + 4, "?", 255, 255, 255, false);
			}else{
				Gfx.smallbigprint(xp + 7, yp + 4, Std.string(c.score), 255, 255, 255, false);
			}
		}else if (c.type == "colour") {
			Gfx.drawminicardgraphic(xp, yp, 1, 0);
			if (mystery) {
				Gfx.smallbigprint(xp + 7, yp + 4, "?", 255, 255, 255, false);
			}else{
				Gfx.smallbigprint(xp + 7, yp + 4, Std.string(c.score), 255, 255, 255, false);
			}
		}else if (c.type == "border") {
			Gfx.drawminicardgraphic(xp, yp, 2, 0);
			if (mystery) {
				Gfx.smallbigprint(xp + 7, yp + 4, "?", 255, 255, 255, false);
			}else{
				Gfx.smallbigprint(xp + 7, yp + 4, Std.string(c.score), 255, 255, 255, false);
			}
		}else if (c.type == "effect") {
			Gfx.drawminicardgraphic(xp, yp, 3, 0);
			if (mystery) {
				Gfx.smallbigprint(xp + 7, yp + 4, "?", 255, 255, 255, false);
			}else{
				Gfx.smallbigprint(xp + 7, yp + 4, Std.string(c.score), 255, 255, 255, false);
			}
		}else if (c.type == "extraframe") {
			Gfx.drawminicardgraphic(xp, yp, 4, 0);
		}
	}
	
	public static function makespritearray(filename:String):Void {
		buffer = new Bitmap(Assets.getBitmapData(filename)).bitmapData;
		
		for (j in 0...Def.SPRITEROWS) {
			for (i in 0...Def.SPRITECOLUMNS) {
				var t:BitmapData = new BitmapData(Def.SPRITESIZEWIDTH, Def.SPRITESIZEHEIGHT, true, 0x000000);
				settrect(i * Def.SPRITESIZEWIDTH, j * Def.SPRITESIZEHEIGHT, Def.SPRITESIZEWIDTH, Def.SPRITESIZEHEIGHT);	
				var temprect:Rectangle = trect;
				t.copyPixels(buffer, temprect, tl);
				sprites.push(t);
			}
		}
	}
	
	public static function zoomin(xp:Int, yp:Int,z:Float):Void {
		//Zoom in on a point!
		bigbuffer.fillRect(bigbuffer.rect, 0x000000);
		settpoint(0, 0);
		settrect(Std.int(xp - (screenwidthmid / z)), Std.int(yp - (screenheightmid / z)), Std.int((screenwidthmid / z)*2), Std.int((screenheightmid / z)*2));
		bigbuffer.copyPixels(backbuffer, trect, tpoint);
		scaleMatrix.identity();
		scaleMatrix.scale(z, z);
		backbuffer.draw(bigbufferscreen, scaleMatrix);
		scaleMatrix.identity();
		
	}

	public static function addimage(imagename:String, filename:String):Void {
		buffer = new Bitmap(Assets.getBitmapData(filename)).bitmapData;
		imageindex.set(imagename, images.length);
		
		var t:BitmapData = new BitmapData(buffer.width, buffer.height, true, 0x000000);
		settrect(0, 0, buffer.width, buffer.height);			
		t.copyPixels(buffer, trect, tl);
		images.push(t);
	}
	
	// Draw Primatives
	public static function drawline(x1:Int, y1:Int, x2:Int, y2:Int, r:Int, g:Int, b:Int):Void {
		tempshape.graphics.clear();
		tempshape.graphics.lineStyle(1, RGB(r, g, b));
		tempshape.graphics.lineTo(x2 - x1, y2 - y1);
		
		shapematrix.translate(x1, y1);
		backbuffer.draw(tempshape, shapematrix);
		shapematrix.translate(-x1, -y1);
	}

	public static function drawbox(x1:Int, y1:Int, w1:Int, h1:Int, r:Int, g:Int=-1, b:Int=-1):Void {
		if (g == -1 && b == -1) {	g = r; b = r;	}
		if (w1 < 0) {
			w1 = -w1;
			x1 = x1 - w1;
		}
		if (h1 < 0) {
			h1 = -h1;
			y1 = y1 - h1;
		}
		settrect(x1, y1, w1, 1); backbuffer.fillRect(trect, RGB(r, g, b));
		settrect(x1, y1 + h1 - 1, w1, 1); backbuffer.fillRect(trect, RGB(r, g, b));
		settrect(x1, y1, 1, h1); backbuffer.fillRect(trect, RGB(r, g, b));
		settrect(x1 + w1 - 1, y1, 1, h1); backbuffer.fillRect(trect, RGB(r, g, b));
	}

	public static function cls():Void {
		fillrect(0, 0, screenwidth, screenheight, 0, 0, 0);
	}

	public static function signcls():Void {
		settrect(0, 0, 48, 16);
		signbuffer[sign].fillRect(trect, RGBA(0, 0, 0));
	}
	
  public static function signfill():Void {
		settrect(0, 0, 48, 16);
		signbuffer[sign].fillRect(trect, RGB(text_red[sign], text_green[sign], text_blue[sign]));
	}
	
	public static function fillrect(x1:Int, y1:Int, w1:Int, h1:Int, r:Int, g:Int = -1, b:Int = -1):Void {
		if (g == -1 && b == -1) {	g = r; b = r;	}
		if (r > 255) r = 255;
		if (g > 255) g = 255;
		if (b > 255) b = 255;
		settrect(x1, y1, w1, h1);
		backbuffer.fillRect(trect, RGB(r, g, b));
	}
	
	#if flash
	public static function drawimage(imagename:String, xp:Int = 0, yp:Int = 0, cent:Bool = false):Void {
		var t:Int = imageindex.get(imagename);
		if (cent) {
			settrect(0, 0, images[t].width, images[t].height);
			settpoint(80 - Std.int(images[t].width / 2), yp);
			backbuffer.copyPixels(images[t], trect, tpoint);
		}else {
			settrect(0, 0, images[t].width, images[t].height);
			settpoint(xp, yp);
			backbuffer.copyPixels(images[t], trect, tpoint);
		}
	}
	#else
	public static function drawimage(imagename:String, xp:Int = 0, yp:Int = 0, cent:Bool = false):Void {
		var t:Int = imageindex.get(imagename);
		if (cent) {
			settrect(0, 0, images[t].width, images[t].height);
			settpoint(80 - Std.int(images[t].width / 2), yp);
			
			shapematrix.identity();
			shapematrix.translate(tpoint.x, tpoint.y);
			backbuffer.draw(images[t], shapematrix);
			shapematrix.identity();
		}else {
			shapematrix.identity();
			shapematrix.translate(xp, yp);
			backbuffer.draw(images[t], shapematrix);
			shapematrix.identity();
		}
	}
	#end
	
	public static function drawimagebig(imagename:String, xp:Int = 0, yp:Int = 0, cent:Bool = false):Void {
		var t:Int = imageindex.get(imagename);
		if (cent) {
			settrect(0, 0, images[t].width, images[t].height);
			settpoint(80 - Std.int(images[t].width / 2), yp);
			backbuffer.copyPixels(images[t], trect, tpoint);
		}else {
			scaleMatrix.scale(2, 2);
			scaleMatrix.translate(xp, yp);
			
			backbuffer.draw(images[t], scaleMatrix);
			scaleMatrix.identity();
		}
	}
	
	public static function drawbuffertile(x:Int, y:Int, t:Int):Void {
		settpoint(x, y);
		buffer.copyPixels(tiles[t], tiles_rect, tpoint);
	}
	
	#if flash
	public static function drawtile(x:Int, y:Int, t:Int):Void {
		settpoint(x, y);
		backbuffer.copyPixels(tiles[t], tiles_rect, tpoint);
	}
	#else
	public static function drawtile(x:Int, y:Int, t:Int):Void {
		shapematrix.identity();
		shapematrix.translate(x, y);
		backbuffer.draw(tiles[t], shapematrix);
		shapematrix.identity();
	}
	#end
	
	public static function drawsprite(x:Int, y:Int, t:Int, rot:Int = 0, transx:Int = 0, transy:Int = 0):Void {
		scaleMatrix.translate(-transx, -transy);
		scaleMatrix.rotate((rot * 3.1415) / 180);
		scaleMatrix.translate(x + transx, y + transy);
		
		backbuffer.draw(sprites[t], scaleMatrix);
		scaleMatrix.identity();
	}
	
	
	
	public static function drawminicardgraphic(x:Int, y:Int, t:Int, rot:Int):Void {
		scaleMatrix.translate(-(minicards_rect.width/2), -(minicards_rect.height/2));
		scaleMatrix.rotate((rot * 3.1415) / 180);
		scaleMatrix.translate(x + (minicards_rect.width/2), y + (minicards_rect.height/2));
		
		backbuffer.draw(minicards[t], scaleMatrix);
		scaleMatrix.identity();
	}
	
	public static function drawcardgraphic(x:Int, y:Int, t:Int, rot:Int):Void {
		scaleMatrix.translate(-(cards_rect.width/2), -(cards_rect.height/2));
		scaleMatrix.rotate((rot * 3.1415) / 180);
		scaleMatrix.translate(x + (cards_rect.width/2), y + (cards_rect.height/2));
		
		backbuffer.draw(cards[t], scaleMatrix);
		scaleMatrix.identity();
	}
	
	public static function bigdrawtile(x:Int, y:Int, t:Int, sc:Float = 2):Void {
		scaleMatrix.scale(sc, sc);
		
		bigbuffer.fillRect(bigbuffer.rect, 0x000000);
		settpoint(0, 0);
		bigbuffer.copyPixels(tiles[t], tiles_rect, tpoint);
		scaleMatrix.translate(x, y);
		backbuffer.draw(bigbufferscreen, scaleMatrix);
		scaleMatrix.identity();
	}
	
	public static function bigdrawsprite(x:Int, y:Int, t:Int, rot:Int, transx:Int, transy:Int, sc:Float = 2):Void {
		scaleMatrix.translate(-transx, -transy);
		scaleMatrix.rotate((rot * 3.1415) / 180);
		scaleMatrix.scale(sc, sc);
		scaleMatrix.translate(x + transx, y + transy);
		
		backbuffer.draw(sprites[t], scaleMatrix);
		scaleMatrix.identity();
	}
	
	public static function drawtile_col(x:Int, y:Int, t:Int, col:Int):Void {
		scaleMatrix.translate(x, y);
		ct.color = col;
		backbuffer.draw(tiles[t], scaleMatrix, ct);
		scaleMatrix.identity();
	}
	
	public static function drawsprite_col(x:Int, y:Int, t:Int, rot:Int, transx:Int, transy:Int, col:Int):Void {
		scaleMatrix.translate(-transx, -transy);
		scaleMatrix.rotate((rot * 3.1415) / 180);
		scaleMatrix.translate(x + transx, y + transy);
		
		ct.color = col;
		backbuffer.draw(sprites[t], scaleMatrix, ct);
		scaleMatrix.identity();
	}
	
	public function bigdrawtile_col(x:Int, y:Int, t:Int, sc:Float, col:Int):Void {
		scaleMatrix.scale(sc, sc);
		
		bigbuffer.fillRect(bigbuffer.rect, 0x000000);
		settpoint(0, 0);
		bigbuffer.copyPixels(tiles[t], tiles_rect, tpoint);
		scaleMatrix.translate(x, y);
		
		ct.color = col;
		backbuffer.draw(bigbufferscreen, scaleMatrix, ct);
		scaleMatrix.identity();
	}
	
	public static function bigdrawsprite_col(x:Int, y:Int, t:Int, rot:Int, transx:Int, transy:Int, sc:Float, col:Int):Void {
		scaleMatrix.translate(-transx, -transy);
		scaleMatrix.rotate((rot * 3.1415) / 180);
		scaleMatrix.scale(sc, sc);
		scaleMatrix.translate(x + transx, y + transy);
		
		ct.color = col;
		backbuffer.draw(sprites[t], scaleMatrix, ct);
		scaleMatrix.identity();
	}
	
	public static function draw_default(i:Int):Void {
		drawsprite(Std.int(Obj.entities[i].xp), Std.int(Obj.entities[i].yp), Obj.entities[i].drawframe,
	  					 Std.int(Obj.entities[i].rot), Obj.entities[i].transx, Obj.entities[i].transy);
	}
	
	public static function draw_defaultinit(i:Int, xoff:Int, yoff:Int, t:Int):Void {
		drawsprite(Std.int(Obj.initentities[i].xp - xoff), Std.int(Obj.initentities[i].yp - yoff), t, 0, 0, 0);
	}
	
	public static function drawentities():Void {			
		for (i in 0...Obj.nentity) {
			if (Obj.entities[i].active) {
				if (!Obj.entities[i].invis) {
					Obj.templates[Obj.entindex.get(Obj.entities[i].type)].drawentity(i);
				}
			}
		}
	}
	
	//Fade functions
	public static function processfade():Void {
		if (fademode > Def.FADED_OUT) {
			if (fademode == Def.FADE_OUT) {
				//prepare fade out
				fadeamount = 0;
				fademode = Def.FADING_OUT;
			}else if (fademode == Def.FADING_OUT) {
				fadeamount += 5;
				if (fadeamount > 100) {
					fademode = Def.FADED_OUT; //faded
				}
			}else if (fademode == Def.FADE_IN) {
				//prepare fade in
				fadeamount = 100;
				fademode = Def.FADING_IN;
			}else if (fademode == Def.FADING_IN) {
				fadeamount -= 5;
				if (fadeamount <= 0) {
					fademode = Def.FADED_IN; //normal
				}
			}
		}
	}
	
	public static function getred(c:Int):Int {
		return (( c >> 16 ) & 0xFF);
	}
	
	public static function getgreen(c:Int):Int {
		return ( (c >> 8) & 0xFF );
	}
	
	public static function getblue(c:Int):Int {
		return ( c & 0xFF );
	}
	
	public static function RGB(red:Int, green:Int, blue:Int):Int {
		return (blue | (green << 8) | (red << 16));
	}
	
	public static function RGBA(red:Int, green:Int, blue:Int):Int {
		return (blue | (green << 8) | (red << 16)) + 0xFF000000;
	}
	
	public static function shade(ccol:Int, a:Float):Int {
		if (a > 1.0) a = 1.0;	if (a < 0.0) a = 0.0;
		return RGB(Std.int((getred(ccol) * a)), Std.int((getgreen(ccol) * a)), Std.int((getblue(ccol) * a)));
	}
	
	//Text functions
	public static var text_red:Array<Int> = new Array<Int>();
	public static var text_green:Array<Int> = new Array<Int>();
	public static var text_blue:Array<Int> = new Array<Int>();
	
	public static var temp:Int = 0;
	public static var tempstring:String = "";
	
	
	public static var gradient:Array<Bool> = new Array<Bool>();
	
	public static var currentcol:Array<String> = new Array<String>();
	public static var stripe:Array<Bool> = new Array<Bool>();
	public static var stripestart:Array<Int> = new Array<Int>();
	public static var stripeend:Array<Int> = new Array<Int>();
	public static var stripecol:Array<String> = new Array<String>();
	
	public static var fire:Array<Bool> = new Array<Bool>();
	public static var firex:Array<Int> = new Array<Int>();
	
	public static var colourstate:Array<Int> = new Array<Int>();
	public static var colourdelay:Array<Int> = new Array<Int>();
	
	public static var border:Array<String> = new Array<String>();
	public static var borderstate:Array<Int> = new Array<Int>();
	public static var borderdelay:Array<Int> = new Array<Int>();
	
	public static function changeborder(t:String) {
		border[sign] = t;
		
		borderstate[sign] = 0;
		borderdelay[sign] = 0;
	}
	
	public static function updateborder():Void {
		if (borderdelay[sign] <= 0) {
			if (border[sign] == "gradient") {
				borderstate[sign] = (borderstate[sign]+1) % 3;
				borderdelay[sign] = 8;
			}else if (border[sign] == "longgradient") {
				borderstate[sign] = (borderstate[sign]+1) % 12;
				borderdelay[sign] = 2;
			}else if (Help.getbranch(border[sign], "_") == "flash") {
				borderstate[sign] = (borderstate[sign]+1) % 2;
				borderdelay[sign] = 20;
			}else if (Help.getbranch(border[sign], "_") == "flicker") {
				borderstate[sign] = (borderstate[sign]+1) % 2;
				borderdelay[sign] = 8;
			}else if (Help.getbranch(border[sign], "_") == "gap") {
				borderstate[sign] = (borderstate[sign]+1) % 2;
				borderdelay[sign] = 4;
			}else if (Help.getbranch(border[sign], "_") == "alternate") {
				borderstate[sign] = (borderstate[sign]+1) % 2;
				borderdelay[sign] = 4;
			}else if (Help.getbranch(border[sign], "_") == "particles") {
				borderstate[sign] = (borderstate[sign] + 1) % (48 + 16);
				borderdelay[sign] = 1;
			}
		}else {
			borderdelay[sign]--;
		}
	}
	
	public static function topborderpset(x:Int):Void {
		if(x<48){
			signbuffer[sign].setPixel(x, 0, RGB(text_red[sign], text_green[sign], text_blue[sign]));
		}else {
			signbuffer[sign].setPixel(47, x - 48, RGB(text_red[sign], text_green[sign], text_blue[sign]));
		}
	}
	
	public static function bottomborderpset(x:Int):Void {
		if(x<48){
			signbuffer[sign].setPixel(48-x, 15, RGB(text_red[sign], text_green[sign], text_blue[sign]));
		}else {
			signbuffer[sign].setPixel(0, 15-(x - 48), RGB(text_red[sign], text_green[sign], text_blue[sign]));
		}
	}
	
	
	public static function pset(x:Int, y:Int):Void {
		signbuffer[sign].setPixel(x, y, RGB(text_red[sign], text_green[sign], text_blue[sign]));
	}
	
	public static function clearset(x:Int, y:Int):Void {
		signbuffer[sign].setPixel(x, y, RGB(0, 0, 0));
	}
	
	public static function fillsignrect(x1:Int, y1:Int, w1:Int, h1:Int):Void {
		settrect(x1, y1, w1, h1);
		signbuffer[sign].fillRect(trect, RGB(text_red[sign], text_green[sign], text_blue[sign]));
	}
	
	public static function clearsignrect(x1:Int, y1:Int, w1:Int, h1:Int):Void {
		settrect(x1, y1, w1, h1);
		signbuffer[sign].fillRect(trect, RGB(0, 0, 0));
	}
	
	public static function drawborder():Void {
		switch(border[sign]) {
			case "none":
			case                     "white-red_alternate", "white-green_alternate", "white-blue_alternate", 
					 "red-white_alternate",                     "red-green_alternate", "red-blue_alternate",
					 "green-white_alternate", "green-red_alternate",                   "green-blue_alternate",
					 "blue-white_alternate", "blue-red_alternate", "blue-green_alternate":
				
				settextstring(Help.getroot(border[sign],"-"));
				
				fillsignrect(0, 0, 48, 1);
				fillsignrect(0, 15, 48, 1);
				fillsignrect(0, 0, 1, 16);
				fillsignrect(47, 0, 1, 16);
				
				settextstring(Help.getroot(Help.getbranch(border[sign], "-"), "_"));
				for (i in 0...48) {
					if ((i + borderstate[sign]) % 2 == 0) pset(i, 0);
					if ((i + borderstate[sign]) % 2 == 1) pset(i, 15);
				}
				for (j in 0...16) {
					if ((j + borderstate[sign]) % 2 == 0) pset(0, j);
					if ((j + borderstate[sign]) % 2 == 1) pset(47, j);
				}
			case                     "white-red_particles", "white-green_particles", "white-blue_particles", 
					 "red-white_particles",                     "red-green_particles", "red-blue_particles",
					 "green-white_particles", "green-red_particles",                   "green-blue_particles",
					 "blue-white_particles", "blue-red_particles", "blue-green_particles":
				
				clearsignrect(0, 0, 48, 1);
				clearsignrect(0, 15, 48, 1);
				clearsignrect(0, 0, 1, 16);
				clearsignrect(47, 0, 1, 16);
				
				for(i in 0...8){
					settextstring(Help.getroot(border[sign],"-"));
					topborderpset((borderstate[sign] + 0 + (i*8)) % 64);
					bottomborderpset((borderstate[sign] + 0+ (i*8)) % 64);
					
					settextstring(Help.getroot(Help.getbranch(border[sign], "-"), "_"));
					topborderpset((borderstate[sign] + 4+ (i*8)) % 64);
					bottomborderpset((borderstate[sign] + 4+ (i*8)) % 64);
				}
				
			case "red_gap", "green_gap", "blue_gap", "white_gap":
				settextstring(Help.getroot(border[sign], "_"));
				clearsignrect(0, 0, 48, 1);
				clearsignrect(0, 15, 48, 1);
				clearsignrect(0, 0, 1, 16);
				clearsignrect(47, 0, 1, 16);
				for (i in 0...48) {
					if ((i + borderstate[sign]) % 2 == 0) pset(i, 0);
					if ((i + borderstate[sign]) % 2 == 1) pset(i, 15);
				}
				for (j in 0...16) {
					if ((j + borderstate[sign]) % 2 == 0) pset(0, j);
					if ((j + borderstate[sign]) % 2 == 1) pset(47, j);
				}
			case "gradient":
				temp = borderstate[sign] % 3;
				for (i in 0...48) {
					temp = (temp + 1) % 3;
					if (temp == 0) settextstring("red");
					if (temp == 1) settextstring("green");
					if (temp == 2) settextstring("blue");
					pset(i, 0);
				}
				
				for (j in 0...16) {
					temp = (temp + 1) % 3;
					if (temp == 0) settextstring("red");
					if (temp == 1) settextstring("green");
					if (temp == 2) settextstring("blue");
					pset(47, j);
				}
				
				var i:Int = 48;
				while (i > 0) {
					i--;
					temp = (temp + 1) % 3;
					if (temp == 0) settextstring("red");
					if (temp == 1) settextstring("green");
					if (temp == 2) settextstring("blue");
					pset(i, 15);
				}
				
				i = 16;
				while (i > 0) {
					i--;
					temp = (temp + 1) % 3;
					if (temp == 0) settextstring("red");
					if (temp == 1) settextstring("green");
					if (temp == 2) settextstring("blue");
					pset(0, i);
				}
			case "longgradient":
				temp = borderstate[sign] % 12;
				for (i in 0...48) {
					temp = (temp + 1) % 12;
					if (temp < 12) settextstring("red");
					if (temp < 8) settextstring("green");
					if (temp < 4) settextstring("blue");
					pset(i, 0);
				}
				
				for (j in 0...16) {
					temp = (temp + 1) % 12;
					if (temp < 12) settextstring("red");
					if (temp < 8) settextstring("green");
					if (temp < 4) settextstring("blue");
					pset(47, j);
				}
				
				var i:Int = 48;
				while (i > 0) {
					i--;
					temp = (temp + 1) % 12;
					if (temp < 12) settextstring("red");
					if (temp < 8) settextstring("green");
					if (temp < 4) settextstring("blue");
					pset(i, 15);
				}
				
				i = 16;
				while (i > 0) {
					i--;
					temp = (temp + 1) % 12;
					if (temp < 12) settextstring("red");
					if (temp < 8) settextstring("green");
					if (temp < 4) settextstring("blue");
					pset(0, i);
				}
				
			case "red", "green", "blue", "white":
				settextstring(border[sign]);
				fillsignrect(0, 0, 48, 1);
				fillsignrect(0, 15, 48, 1);
				fillsignrect(0, 0, 1, 16);
				fillsignrect(47, 0, 1, 16);
			case "red_flash", "green_flash", "blue_flash", "white_flash":
				if (borderstate[sign] == 0) {
					settextstring(Help.getroot(border[sign], "_"));
					fillsignrect(0, 0, 48, 1);
					fillsignrect(0, 15, 48, 1);
					fillsignrect(0, 0, 1, 16);
					fillsignrect(47, 0, 1, 16);
				}
			case "red_flicker", "green_flicker", "blue_flicker", "white_flicker":
				if (borderstate[sign] == 0) {
					settextstring(Help.getroot(border[sign], "_"));
					fillsignrect(0, 0, 48, 1);
					fillsignrect(0, 15, 48, 1);
					fillsignrect(0, 0, 1, 16);
					fillsignrect(47, 0, 1, 16);
				}else {
					if (Help.getroot(border[sign], "_") == "white") {
						settextstring("red");
					}else{
						settextstring("white");
					}
					fillsignrect(0, 0, 48, 1);
					fillsignrect(0, 15, 48, 1);
					fillsignrect(0, 0, 1, 16);
					fillsignrect(47, 0, 1, 16);
				}
		}
	}
	
	public static function textgradient():Void {
		for (j in 0...16) {
			for (i in 0...48) {
				temp = signbuffer[sign].getPixel(i, j);
				if (getred(temp) > 0 || getgreen(temp) > 0) {
					temp = Std.int((i - j + firex[sign]) / 8);
					while (temp < 0) temp += 3;
					if (temp % 3 == 0)	tempstring = "blue";
					if (temp % 3 == 1)	tempstring = "red";
					if (temp % 3 == 2)	tempstring = "green";
					settextstring(tempstring);
					pset(i, j);
				}
			}
		}
	}
	
	public static function invert():Void {
		settextstring("white");
		switch(currentcol[sign]) {
			case "red":
				settextstring("red");
			case "green":
				settextstring("green");
			case "blue":
				settextstring("blue");
			case "red_flash":
				settextstring("red");
			case "green_flash":
				settextstring("green");
			case "blue_flash":
				settextstring("blue");
			case "white-red_flicker", "red-white_flicker":
				if (colourstate[sign] == 0) {
					settextstring("white");
				}else {
					settextstring("red");
				}
			case "white-green_flicker", "green-white_flicker":
				if (colourstate[sign] == 0) {
					settextstring("white");
				}else {
					settextstring("green");
				}
			case "red-blue_flicker", "blue-red_flicker":
				if (colourstate[sign] == 0) {
					settextstring("red");
				}else {
					settextstring("blue");
				}
			case "red-green_flicker", "green-red_flicker":
				if (colourstate[sign] == 0) {
					settextstring("red");
				}else {
					settextstring("green");
				}
			case "green-blue_flicker", "blue-green_flicker":
				if (colourstate[sign] == 0) {
					settextstring("green");
				}else {
					settextstring("blue");
				}
			case "blue-white_flicker", "white-blue_flicker":
				if (colourstate[sign] == 0) {
					settextstring("blue");
				}else {
					settextstring("white");
				}
			case "slow_cycle", "fast_cycle":
				if (colourstate[sign] == 0) {
					settextstring("white");
				}else if (colourstate[sign] == 1) {
					settextstring("red");
				}else if (colourstate[sign] == 2) {
					settextstring("green");
				}else if (colourstate[sign] == 3) {
					settextstring("blue");
				}
		}
		
		for (j in 0...16) {
			for (i in 0...48) {
				temp = signbuffer[sign].getPixel(i, j);
				if (getred(temp) > 0 || getgreen(temp) > 0) {
					clearset(i, j);
				}else {
					pset(i, j);
				}
			}
		}
	}
	
	public static function textstripe(start:Int, end:Int, col:String):Void {
		settextstring(col);
		for(j in start...end){
			for (i in 0...48) {
				if (fire[sign]) {
					for (k in 0...(i + Std.int(firex[sign]/3) + Control.textposition[sign]) % 8) {
						if (j - k >= 0) {
							temp = signbuffer[sign].getPixel(i, j - k);
							if (getred(temp) > 0 || getgreen(temp) > 0) {
								pset(i, j - k);
							}
						}
					}
				}
				
				temp = signbuffer[sign].getPixel(i, j);
				if (getred(temp) > 0 || getgreen(temp) > 0) {
					pset(i, j);
				}
			}
		}
	}
	
	public static function staticeffect(fout:Int = 0): Void {
		for (j in 0...16) {
			for (i in 0...48) {
				tx = 64 + Std.int(Math.random() * 128) - (fout * 2);
				if (tx < 0) tx = 0;
				signbuffer[0].setPixel(i, j, RGB(tx, tx, tx));
			}
		}
	}
	
	public static var supersignbuffer:BitmapData;
	
	public static function copysupersign():Void {
		supersignbuffer.copyPixels(signbuffer[0], signbuffer[0].rect, tl);
	}
	
	public static function pastesupersign():Void {
		signbuffer[0].copyPixels(supersignbuffer, supersignbuffer.rect, tl);
	}
	
	public static function clearsupersign():Void {
		supersignbuffer.fillRect(supersignbuffer.rect, RGB(0, 0, 0));
	}
	
	public static function spset(x:Int, y:Int, col:Int):Void {
		if (Help.inboxw(x, y, 0, 0, 48, 16)) supersignbuffer.setPixel(x, y, col);
	}
	
	public static function spset_add(x:Int, y:Int, col:Int):Void {
		if (Help.inboxw(x, y, 0, 0, 48, 16)) {
			var t:Int = spget(x, y);
			var tr:Int = getred(col) + getred(t);
			var tg:Int = getgreen(col) + getgreen(t);
			var tb:Int = getblue(col) + getblue(t);
			if (tr > 255) tr = 255;
			if (tg > 255) tg = 255;
			if (tb > 255) tb = 255;
			col = RGB(tr, tg, tb);
			
			supersignbuffer.setPixel(x, y, col);
		}
	}
	
	public static function spget(x:Int, y:Int):Int {
		if (Help.inboxw(x, y, 0, 0, 48, 16)) return signbuffer[0].getPixel(x, y);
		return RGB(0, 0, 0);
	}
	
	public static function explodeeffect(fout:Int = 0): Void {
		if (fout >= 1) {
			pastesupersign();
		}else {
			for (j in 0...16) {
				for (i in 0...48) {
					spset(i, j, RGB(0, 0, 0));
				}
			}
		}
		clearsupersign();
		if (fout % 2 == 1) {
			supersignbuffer.setPixel(Std.int((fout - 1) / 2) % 48, 15, RGB(Std.int(255 * Math.random()), Std.int(255 * Math.random()), Std.int(255 * Math.random())));
			supersignbuffer.setPixel((1 + Std.int((fout - 1) / 2)) % 48, 15, RGB(Std.int(255 * Math.random()), Std.int(255 * Math.random()), Std.int(255 * Math.random())));
			
			supersignbuffer.setPixel(48-(Std.int((fout - 1) / 2) % 48), 15, RGB(Std.int(255 * Math.random()), Std.int(255 * Math.random()), Std.int(255 * Math.random())));
			supersignbuffer.setPixel(48-((1+Std.int((fout-1) / 2)) % 48), 15, RGB(Std.int(255 * Math.random()), Std.int(255 * Math.random()), Std.int(255 * Math.random())));
		}
		
		for (j in 0...16) {
			for (i in 0...48) {
				tx = spget(i, j);
			  if (getred(tx) > 0) {
					spset(i, j, RGB(Std.int(getred(tx)*0.5), Std.int(getgreen(tx)*0.25), Std.int(getblue(tx)*0.25)));
					spset_add(i, j-1, RGB(Std.int(getred(tx)*0.5), Std.int(getgreen(tx)*0.25), Std.int(getblue(tx)*0.25)));	
					spset_add(i, j+1, RGB(Std.int(getred(tx)*0.5), Std.int(getgreen(tx)*0.25), Std.int(getblue(tx)*0.25)));	
					//spset_add(i-1, j, RGB(Std.int(getred(tx)*0.5), Std.int(getgreen(tx)*0.5), Std.int(getblue(tx)*0.5)));	
					//spset_add(i+1, j, RGB(Std.int(getred(tx)*0.5), Std.int(getgreen(tx)*0.5), Std.int(getblue(tx)*0.5)));	
				}
			}
		}
		
		if (fout >= 1) {
			pastesupersign();
		}
	}
	
	public static function plasmaeffect(fout:Int = 0): Void {
		clearsupersign();
		
		fout = Std.int(fout / 3);
		for (j in 0...16) {
			for (i in 0...48) {
				tx = Std.int((Math.sin((i + fout) / Math.PI / 2) * 64) + (Math.cos(((j + (fout * 1.4)) / Math.PI / 2) * 1.5) * 64));
				ty = Std.int((Math.sin(((i * 1.4) + fout) / Math.PI / 2) * 64) + (Math.cos((((j * 0.5) + (fout * 1.4)) / Math.PI / 2) * 1.5) * 64));
				
				if (tx < 0) tx = 0;
				if (tx > 255) tx = 255;
				if (ty < 0) ty = 0;
				if (ty > 255) ty = 255;
				spset(i, j, RGB(tx, ty, tx+ty));
			}
		}
		
		pastesupersign();
	}
	
	public static function tunneleffect(fout:Int = 0): Void {
		clearsupersign();
		
		fout = Std.int(fout / 4);
		for (j in 0...16) {
			for (i in 0...48) {
				//Get distance from center
				tx = Std.int(Math.abs(24 - i));
				tx = (tx+fout) % 8;
				tx = tx * 16;
				ty = Std.int(Math.abs(8 - j));
				ty = (ty+fout) % 8;
				ty = ty * 16;
				spset(i, j, RGB(tx+ty, tx+ty, tx+ty));
			}
		}
		
		pastesupersign();
	}
	
	public static function specialrocket(fout:Int = 0): Void {
		clearsupersign();
		
		fout = Std.int(fout/2);
		
		scaleMatrix.identity();
		scaleMatrix.translate(fout - 32, 0);
		if (fout % 8 >= 4) {
			supersignbuffer.draw(sprites[53], scaleMatrix);
		}else{
			supersignbuffer.draw(sprites[52], scaleMatrix);
		}
		scaleMatrix.identity();
		
		pastesupersign();
	}
	
	public static function bouncingboxeffect(fout:Int = 0): Void {
		clearsupersign();
		
		var tx2:Int = 0;
		var ty2:Int = 0;
		
		//fout = Std.int(fout / 4);
		tx = (fout + 4) % 48;
		tx2 = Std.int(((fout + 4) - tx)/48) % 2;
		
		ty = fout % 16;
		ty2 = Std.int((fout - ty)/16) % 2;
		
		if (tx2 == 1) tx = 48 - tx;
		if (ty2 == 1) ty = 16 - ty;
		
		spset(tx, ty, RGB(255, 255, 255));
		spset(tx-1, ty, RGB(255, 0, 0));
		spset(tx+1, ty, RGB(255, 0, 0));
		spset(tx, ty-1, RGB(255, 0, 0));
		spset(tx, ty + 1, RGB(255, 0, 0));
		
		//
		tx = (fout +84+48) % 48;
		tx2 = Std.int(((fout + 84+48) - tx)/48) % 2;
		
		ty = (fout+5) % 16;
		ty2 = Std.int(((fout+5) - ty)/16) % 2;
		
		if (tx2 == 1) tx = 48 - tx;
		if (ty2 == 1) ty = 16 - ty;
		
		spset(tx, ty, RGB(255, 255, 255));
		spset(tx-1, ty, RGB(255, 255, 0));
		spset(tx+1, ty, RGB(255, 255, 0));
		spset(tx, ty-1, RGB(255, 255, 0));
		spset(tx, ty+1, RGB(255, 255, 0));
		
		//
		tx = (fout +184) % 48;
		tx2 = Std.int(((fout + 184) - tx)/48) % 2;
		
		ty = (fout+15) % 16;
		ty2 = Std.int(((fout+15) - ty)/16) % 2;
		
		if (tx2 == 1) tx = 48 - tx;
		if (ty2 == 1) ty = 16 - ty;
		
		spset(tx, ty, RGB(255, 255, 255));
		spset(tx-1, ty, RGB(255, 0, 255));
		spset(tx+1, ty, RGB(255, 0, 255));
		spset(tx, ty-1, RGB(255, 0, 255));
		spset(tx, ty+1, RGB(255, 0, 255));
		
		
		pastesupersign();
	}
	
	public static function dramaticfade(n:Int):Void {
		tx = 0;
		for(j in 0...16){
			for (i in 0...48) {
				tx = Std.int((255 * ((16 - j) + n)) / 16);
				if (tx < 0) tx = 0;
				if (tx > 255) tx = 255;
				temp = signbuffer[sign].getPixel(i, j);
				if (getred(temp) > 0 || getgreen(temp) > 0) {
					signbuffer[sign].setPixel(i, j, RGB(tx, tx, tx));
				}
			}
		}
	}
	
	public static function biggradient(n:Int):Void {
		tx = 0; ty = 0; 
		var tz:Int = 0;
		for(j in 0...16){
			for (i in 0...48) {
				tx = Std.int((i+n) + j) * 2;
				ty = Std.int((i+n) + (j * 2)) * 2;
				tz = Std.int(((i+n)*2) + j) * 2;
				if (tx < 0) tx = 0; tx = tx % 63;
				if (ty < 0) ty = 0; ty = ty % 63;
				if (tz < 0) tz = 0; tz = tz % 63;
				temp = signbuffer[sign].getPixel(i, j);
				if (getred(temp) > 0 || getgreen(temp) > 0) {
					signbuffer[sign].setPixel(i, j, RGB(128+tx+ty, 128+ty+tz, 64+tz+tx));
				}
			}
		}
	}
	
	public static function otherbiggradient(n:Int):Void {
		tx = 0; ty = 0; 
		var tz:Int = 0;
		for(j in 0...16){
			for (i in 0...48) {
				tx = Std.int((i+n) + j) * 2;
				ty = Std.int((i+n) + (j * 2)) * 2;
				tz = Std.int(((i+n)*2) + j) * 2;
				if (tx < 0) tx = 0; tx = tx % 63;
				if (ty < 0) ty = 0; ty = ty % 63;
				if (tz < 0) tz = 0; tz = tz % 63;
				temp = signbuffer[sign].getPixel(i, j);
				if (getred(temp) > 0 || getgreen(temp) > 0) {
					signbuffer[sign].setPixel(i, j, RGB(255, 128 - ty + tz, (64 + (tz * 2)) % 255));
				}
			}
		}
	}
	
	public static function randomgradient(n:Int):Void {
		tx = 0; ty = 0; 
		var tz:Int = 0;
		for(j in 0...16){
			for (i in 0...48) {
				tx = Std.int(Math.random() * 127);
				ty = Std.int(Math.random() * 127);
				tz = Std.int(Math.random() * 127);
				temp = signbuffer[sign].getPixel(i, j);
				if (getred(temp) > 0 || getgreen(temp) > 0) {
					signbuffer[sign].setPixel(i, j, RGB(64 + tx, 64 + ty, 128 + tz));
				}
			}
		}
	}
	
	public static function changecolour(t:String):Void {
		currentcol[sign] = t;
		colourstate[sign] = 0;
		colourdelay[sign] = 0;
		firex[sign] = 0;
	}
	
	public static function settextstring(t:String):Void {
		if (t == "white") settextrgb(255, 255, 255);
		if (t == "red") settextrgb(255, 0, 0);
		if (t == "green") settextrgb(0, 255, 0);
		if (t == "blue") settextrgb(16, 16, 255);
	}
	
	public static function settextrgb(r:Int, g:Int, b:Int):Void {
		text_red[sign] = r;
		text_green[sign] = g;
		text_blue[sign] = b;
	}
	
	public static function updatecolour():Void {
		if (colourdelay[sign] <= 0) {
			if (Help.getbranch(currentcol[sign], "_") == "flash") {
				colourstate[sign] = (colourstate[sign]+1) % 2;
				colourdelay[sign] = 20;
			}else if (Help.getbranch(currentcol[sign], "_") == "flicker") {
				colourstate[sign] = (colourstate[sign]+1) % 2;
				colourdelay[sign] = 8;
			}else if (Help.getbranch(currentcol[sign], "_") == "stripe") {
				colourstate[sign] = (colourstate[sign]+1) % 24;
				colourdelay[sign] = 1;
			}else if (Help.getbranch(currentcol[sign], "_") == "fire") {
				colourstate[sign] = (colourstate[sign]+1) % 16;
				colourdelay[sign] = 4;
			}else if (currentcol[sign] == "slow_cycle") {
				colourstate[sign] = (colourstate[sign]+1) % 4;
				colourdelay[sign] = 16;
			}else if (currentcol[sign] == "fast_cycle") {
				colourstate[sign] = (colourstate[sign]+1) % 4;
				colourdelay[sign] = 8;
			}
		}else {
			colourdelay[sign]--;
		}
		
		stripe[sign] = false; stripestart[sign] = 0; stripeend[sign] = 0; stripecol[sign] = "white";
		fire[sign] = false; gradient[sign] = false;
		text_red[sign] = 0; text_green[sign] = 0; text_blue[sign] = 0;
		
		switch(currentcol[sign]) {
			case "special1", "special2", "special3", "special4":
				settextrgb(255, 255, 255);
			case "white":
				settextrgb(255, 255, 255);
			case "red":
				settextrgb(255, 0, 0);
			case "green":
				settextrgb(0, 255, 0);
			case "blue":
				settextrgb(16, 16, 255);
			case "white_flash":
				if (colourstate[sign] == 0)	settextrgb(255, 255, 255);
			case "red_flash":
				if (colourstate[sign] == 0) settextrgb(255, 0, 0);
			case "green_flash":
				if (colourstate[sign] == 0) settextrgb(0, 255, 0);
			case "blue_flash":
				if (colourstate[sign] == 0) settextrgb(16, 16, 255);
			case "white-red_flicker", "red-white_flicker":
				if (colourstate[sign] == 0) {
					settextrgb(255, 255, 255);
				}else {
					settextrgb(255, 0, 0);
				}
			case "white-green_flicker", "green-white_flicker":
				if (colourstate[sign] == 0) {
					settextrgb(255, 255, 255);
				}else {
					settextrgb(0, 255, 0);
				}
			case "red-blue_flicker", "blue-red_flicker":
				if (colourstate[sign] == 0) {
					settextrgb(255, 0, 0);
				}else {
					settextrgb(16, 16, 255);
				}
			case "red-green_flicker", "green-red_flicker":
				if (colourstate[sign] == 0) {
					settextrgb(255, 0, 0);
				}else {
					settextrgb(0, 255, 0);
				}
			case "green-blue_flicker", "blue-green_flicker":
				if (colourstate[sign] == 0) {
					settextrgb(0, 255, 0);
				}else {
					settextrgb(16, 16, 255);
				}
			case "blue-white_flicker", "white-blue_flicker":
				if (colourstate[sign] == 0) {
					settextrgb(16, 16, 255);
				}else {
					settextrgb(255, 255, 255);
				}
			case "slow_cycle", "fast_cycle":
				if (colourstate[sign] == 0) {
					settextrgb(255, 255, 255);
				}else if (colourstate[sign] == 1) {
					settextrgb(255, 0, 0);
				}else if (colourstate[sign] == 2) {
					settextrgb(0, 255, 0);
				}else if (colourstate[sign] == 3) {
					settextrgb(16, 16, 255);
				}
			case                     "white-red_stripe", "white-green_stripe", "white-blue_stripe", 
					 "red-white_stripe",                     "red-green_stripe", "red-blue_stripe",
					 "green-white_stripe", "green-red_stripe",                   "green-blue_stripe",
					 "blue-white_stripe", "blue-red_stripe", "blue-green_stripe":
				stripe[sign] = true;
				settextstring(Help.getroot(currentcol[sign],"-"));
				stripecol[sign] = Help.getroot(Help.getbranch(currentcol[sign], "-"), "_");
				if (colourstate[sign] < 12) {
					stripestart[sign] = colourstate[sign];
					stripeend[sign] = colourstate[sign]+6;
				}else {
					stripestart[sign] = 24-colourstate[sign];
					stripeend[sign] = 24-colourstate[sign]+6;
				}
			case "gradient":
				settextrgb(255, 255, 255);
				gradient[sign] = true;
				firex[sign]++;
			case "white_fire", "red_fire", "green_fire", "blue_fire":				
				settextrgb(255, 255, 255);
				stripecol[sign] = Help.getroot(currentcol[sign], "_");
				if (stripecol[sign] == "white") {
					if(firex[sign]%12<4){
						settextstring("red");
					}else if (firex[sign] % 12 < 8) {
						settextstring("green");
					}else {
						settextstring("blue");
					}
				}
				stripe[sign] = true;
				fire[sign] = true;
				firex[sign]++;
				stripestart[sign] = 15-colourstate[sign];
				stripeend[sign] = 16;
		}
	}
	
	public static function pixeltext(copyline:Int, copyheight:Int):Void {
		settrect(0, copyline, 48, 1);
		tempbuffer.copyPixels(signbuffer[sign], trect, tl);
		
		clearsignrect(0, 0, 48, copyline+1);
		
		settrect(0, 0, 48, 1);
		signbuffer[sign].copyPixels(tempbuffer, trect, new Point(0, copyline - copyheight));
	}
	
	public static function crushtext():Void {
		settrect(0, 0, 48, 7);
		tempbuffer.copyPixels(signbuffer[sign], trect, tl);
		signbuffer[sign].copyPixels(tempbuffer, trect, new Point(0, 1));
		
		settrect(0, 9, 48, 7);
		tempbuffer.copyPixels(signbuffer[sign], trect, tl);
		settrect(0, 0, 48, 7);
		signbuffer[sign].copyPixels(tempbuffer, trect, new Point(0, 8));
	}
	
	
	public static function midsplit(t:Int):Void {
		for (j in 0...8) {
			settrect(0, j, 48, 1);
			tempbuffer.copyPixels(signbuffer[sign], trect, tl);
			settrect(0, 0, 48, 1);
			signbuffer[sign].copyPixels(tempbuffer, trect, new Point(t * (4 - (j / 2)), j));
			clearsignrect(0, j, Std.int(t * (4 - (j / 2))), 1);
		}
		
		for (j in 0...8) {
			settrect(0, j+8, 48, 1);
			tempbuffer.copyPixels(signbuffer[sign], trect, tl);
			settrect(0, 0, 48, 1);
			signbuffer[sign].copyPixels(tempbuffer, trect, new Point(-t*(j/2), j + 8));
			clearsignrect(Std.int( -t * (j / 2)) + 48, j + 8, 48, 1);
		}
	}
	
	#if html5
	public static var fontxoff:Int = 2;
	public static var fontyoff:Int = 4;
	public static var bigfontxoff:Int = 4;
	public static var bigfontyoff:Int = 6;
	#else
	public static var fontxoff:Int = 2;
	public static var fontyoff:Int = 3;
	public static var bigfontxoff:Int = 0;
	public static var bigfontyoff:Int = 4;
	#end
	
	public static function rprint(x:Int, y:Int, t:String):Void {
		Text.rprint(x-fontxoff, y-fontyoff, t, text_red[sign], text_green[sign], text_blue[sign]);
	}
	
	public static function smallprint(x:Int, y:Int, t:String, r:Int, g:Int = -1, b:Int = -1, cen:Bool = true):Void {
		if (g == -1 && b == -1) {	g = r; b = r;	}
		t = t.toUpperCase();
		Text.smallprint(x - fontxoff, y - fontyoff, t, r, g, b, cen);
	}
	
	public static function smallbigprint(x:Int, y:Int, t:String, r:Int, g:Int = -1, b:Int = -1, cen:Bool = true):Void {
		if (g == -1 && b == -1) {	g = r; b = r;	}
		t = t.toUpperCase();
		Text.smallbigprint(x - fontxoff, y - fontyoff, t, r, g, b, cen);
	}
	
	public static function normalprint(x:Int, y:Int, t:String, r:Int, g:Int = -1, b:Int = -1, cen:Bool = true):Void {
		if (g == -1 && b == -1) {	g = r; b = r;	}
		t = t.toUpperCase();
		Text.normalprint(x - fontxoff, y - fontyoff, t, r, g, b, cen);
	}
	
	public static function normalbigprint(x:Int, y:Int, t:String, r:Int, g:Int=-1, b:Int=-1, cen:Bool = true):Void {
		if (g == -1 && b == -1) {	g = r; b = r;	}
		t = t.toUpperCase();
		Text.normaltallprint(x - fontxoff, y - (2 * fontyoff), t, r, g, b, cen);
	}
	
	public static function print(x:Int, y:Int, t:String, cen:Bool = false):Void {
		t = t.toUpperCase();
		Text.print(x-fontxoff, y-fontyoff, t, text_red[sign], text_green[sign], text_blue[sign], cen);
	}
	
	public static function tallprint(x:Int, y:Int, t:String, cen:Bool = false):Void {
		t = t.toUpperCase();
		Text.tallprint(x - fontxoff, y - (2*fontyoff), t, text_red[sign],text_green[sign], text_blue[sign], cen);
	}
	
	public static function tallprint_teleport(x:Int, y:Int, t:String, tele:Int, cen:Bool = false):Void {
		t = t.toUpperCase();
		Text.tallprint(x - fontxoff, y - (2 * fontyoff), t, text_red[sign], text_green[sign], text_blue[sign], cen);
		
		//Copy column tele all the way over
		settrect(tele, 0, 2, 16);
		tempbuffer.copyPixels(signbuffer[sign], trect, tl);
		
		settrect(0, 0, 2, 16);
		for (i in tele...48) {
			signbuffer[sign].copyPixels(tempbuffer, trect, new Point(i, 0));
		}
	}
	
	public static function tallprint_crush(x:Int, y:Int, t:String, crush:Int, cen:Bool = false):Void {
		t = t.toUpperCase();
		Text.tallprint_crush(x - fontxoff, y - (2*fontyoff), t, crush, text_red[sign],text_green[sign], text_blue[sign], cen);
	}
	
	public static function len(t:String, sz:Int = 1):Float {
		return Text.len(t, sz);
	}
	
	public static function hig(t:String, sz:Int = 1):Float {
		return Text.hig(t, sz);
	}
	
	public static function rbigprint(x:Int, y:Int, t:String, cen:Bool = false, sc:Int = 2):Void {
		Text.rbigprint(x-bigfontxoff, y-bigfontyoff, t, text_red[sign], text_green[sign], text_blue[sign], cen, sc);
	}
	
	public static function bigprint(x:Int, y:Int, t:String, cen:Bool = false, sc:Int = 2):Void {
		t = t.toUpperCase();
		Text.bigprint(x-bigfontxoff, y-bigfontyoff, t, text_red[sign], text_green[sign], text_blue[sign], cen, sc);
	}
	
	public static function bigprint_teleport(x:Int, y:Int, t:String, tele:Int, cen:Bool = false, sc:Int = 2):Void {
		t = t.toUpperCase();
		Text.bigprint(x - bigfontxoff, y - bigfontyoff, t, text_red[sign], text_green[sign], text_blue[sign], cen, sc);
		
		
		//Copy column tele all the way over
		settrect(tele, 0, 1, 16);
		tempbuffer.copyPixels(signbuffer[sign], trect, tl);
		
		settrect(0, 0, 1, 16);
		for (i in tele...48) {
			signbuffer[sign].copyPixels(tempbuffer, trect, new Point(i, 0));
		}
	}
	
	public static function bigprint_crush(x:Int, y:Int, t:String, crush:Int, cen:Bool = false, sc:Int = 2):Void {
		t = t.toUpperCase();
		Text.bigprint_crush(x-bigfontxoff, y-bigfontyoff, t, crush, text_red[sign], text_green[sign], text_blue[sign], cen, sc);
	}
	
	public static function drawgui():Void {
		Textbox.textboxcleanup();
		//Draw all the textboxes to the screen
		for (i in 0...Textbox.ntextbox) {
			if (Textbox.tb[i].active) {
				Draw.drawtextbox(Std.int(Textbox.tb[i].xp), Std.int(Textbox.tb[i].yp), Std.int(Textbox.tb[i].width), Std.int(Textbox.tb[i].height), Textbox.tb[i].col, Textbox.tb[i].lerp, Textbox.tb[i].textboxstate);
				if (Textbox.tb[i].textboxstate >= Textbox.STATE_TEXTAPPEARING && 
					  Textbox.tb[i].textboxstate < Textbox.STATE_DISAPPEARING) {
          if(Textbox.tb[i].showname){
						for (j in 0...Textbox.tb[i].numlines) {
							Textbox.tbprint(j, Textbox.tb[i].tbline, Textbox.tb[i].tbcursor, 
															Textbox.tb[i].xp + 14, 
															Textbox.tb[i].yp + 3, 
															Textbox.tb[i].line[j], 196, 196, 255);					
						}
						
						settrect(0, Textbox.tb[i].yp + 30, 40, 8);
						backbuffer.fillRect(trect, RGB(32, 32, 32));
						smallprint(10, Textbox.tb[i].yp + 30, "CLICK", Def.GRAY[3], Def.GRAY[3], Def.GRAY[3], false);
					}else {
						for (j in 0...Textbox.tb[i].numlines) {
							Textbox.rtbprint(j, Textbox.tb[i].tbline, Textbox.tb[i].tbcursor, 
															Gfx.screenwidth - 14, 
															Textbox.tb[i].yp + 3, 
															Textbox.tb[i].line[j], 255, 196, 196);					
						}
						
						settrect(screenwidth - 40, Textbox.tb[i].yp + 30, 40, 8);
						backbuffer.fillRect(trect, RGB(32, 32, 32));
						smallprint(screenwidth - 30, Textbox.tb[i].yp + 30, "CLICK", Def.GRAY[3], Def.GRAY[3], Def.GRAY[3], false);
					}
				}
			}
		}
	}
	
	public static function maketbsidesarray(filename:String):Void {
		buffer = new Bitmap(Assets.getBitmapData(filename)).bitmapData;
		
		for (j in 0...4) {
			for (i in 0...4) {
				var t:BitmapData = new BitmapData(16, 16, true, 0x000000);
				var temprect:Rectangle = new Rectangle(i * 16, j * 16, 16, 16);	
				t.copyPixels(buffer, temprect, tl);
				tbsides.push(t);
			}
		}
	}	
	
	public static function drawsign(sign:Int, x:Int, y:Int, s:Int):Void {
		shapematrix.identity();
		shapematrix.scale(s, s);
		shapematrix.translate(x, y);
		backbuffer.draw(signbuffer[sign], Gfx.shapematrix);
	}
	
	
	//Render functions
	public static function normalrender():Void {
		backbuffer.unlock();
		
		screenbuffer.lock();
		screenbuffer.copyPixels(backbuffer, backbuffer.rect, tl, null, null, false);
		screenbuffer.unlock();
		
		backbuffer.lock();
	}

	public static function screenrender():Void {
		if (Game.test) Text.print(5, 5, Game.teststring, 196, 196, 196, false);
		
		if (flashlight > 0) { flashlight--; Draw.gfxflashlight(); }
		if (screenshake > 0) {	screenshake--;	Draw.gfxscreenshake();}else{
			normalrender();
		}
	}
	
	public static var screenwidth:Int;
	public static var screenheight:Int;
	public static var screenwidthmid:Int;
	public static var screenheightmid:Int;
	public static var screenviewwidth:Int;
	public static var screenviewheight:Int;
	
	public static var images:Array<BitmapData> = new Array<BitmapData>();
	public static var tiles:Array<BitmapData> = new Array<BitmapData>();
	public static var sprites:Array<BitmapData> = new Array<BitmapData>();
	public static var cards:Array<BitmapData> = new Array<BitmapData>();
	public static var minicards:Array<BitmapData> = new Array<BitmapData>();
	public static var cards_rect:Rectangle;
	public static var minicards_rect:Rectangle;
	public static var ct:ColorTransform;
	public static var tiles_rect:Rectangle;
	public static var sprites_rect:Rectangle;
	public static var images_rect:Rectangle;
	public static var tl:Point = new Point(0, 0);
	public static var trect:Rectangle;
	public static var tpoint:Point;
	public static var tbuffer:BitmapData;
	public static var imageindex:Map<String, Int> = new Map<String, Int>();
	public static var tx:Int;
	public static var ty:Int;
	
	public static var buffer:BitmapData;
	
	public static var temptile:BitmapData;
	//Actual backgrounds
	public static var tempbuffer:BitmapData;
	public static var signbuffer:Array<BitmapData> = new Array<BitmapData>();
	public static var backbuffer:BitmapData;
	public static var screenbuffer:BitmapData;
	public static var screen:Bitmap;
	//Sprite Scaling Stuff
	public static var bigbuffer:BitmapData;
	public static var bigbufferscreen:Bitmap;
	public static var scaleMatrix:Matrix = new Matrix();
	//Tempshape
	public static var tempshape:Shape = new Shape();
	public static var shapematrix:Matrix = new Matrix();
	//Fade Transition (room changes, game state changes etc)
	public static var fademode:Int;
	public static var fadeamount:Int;
	public static var fadeaction:String;
	
	public static var screenshake:Int;
	public static var flashlight:Int;
	
	public static var numsigns:Int;
	public static var totalsigns:Int;
	public static var sign:Int = 0;
	
	public static var alphamult:Int;
	public static var textboxbuffer:BitmapData;
	public static var tbsides_rect:Rectangle;
	public static var tbsides:Array<BitmapData> = new Array<BitmapData>();
}