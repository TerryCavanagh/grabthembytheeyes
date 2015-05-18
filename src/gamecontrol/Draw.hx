package gamecontrol;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;
import com.terry.*;

class Draw {
	public static function init():Void {
		
	}
	
	public static function gfxflashlight():Void {
		Gfx.backbuffer.fillRect(Gfx.backbuffer.rect, 0xFFFFFF);
	}
	
	public static function gfxscreenshake():Void {
		Gfx.screenbuffer.lock();
		Gfx.screenbuffer.copyPixels(Gfx.backbuffer, Gfx.backbuffer.rect, Gfx.tl, null, null, false);
		Gfx.settpoint(Std.int((Math.random() * 5) - 3), Std.int((Math.random() * 5) - 3));
		Gfx.screenbuffer.copyPixels(Gfx.backbuffer, Gfx.backbuffer.rect, Gfx.tpoint, null, null, false);
		Gfx.screenbuffer.unlock();
		
		Gfx.backbuffer.lock();
		Gfx.backbuffer.fillRect(Gfx.backbuffer.rect, 0x000000);
		Gfx.backbuffer.unlock();
	}
	
	public static function clicktostart():Void {
		Text.print(5, 230, "[Click to start]", Std.int(255 - (Help.glow / 2)), Std.int(255 - (Help.glow / 2)), Std.int(255 - (Help.glow / 2)), true);
	}

	public static function outoffocusrender():Void {
		Gfx.fillrect(0, 0, Gfx.screenwidth, Gfx.screenheight, 164, 164, 164);
		
		Gfx.normalbigprint(0, 100, "Game paused", 224, 224, 224, true); 
		Gfx.normalprint(0, 128, "[click to resume]", 224, 224, 224, true); 
		
		Gfx.normalrender();
	}
	
	public static function drawfade():Void {
		if (Gfx.fademode == Def.FADED_OUT) {
			Gfx.backbuffer.fillRect(Gfx.backbuffer.rect, 0x000000);
		}else if (Gfx.fademode == Def.FADING_IN) {
			for (j in 0...12) {
				if (j % 2 == 0) {
					Gfx.fillrect( -10, j * 20, Std.int(10 + (Gfx.fadeamount * (Def.SCREENWIDTH)) / 100), 20, 0, 0, 0);
				}else {
					Gfx.fillrect(Std.int(Gfx.screenwidth - ((Gfx.fadeamount * (Def.SCREENWIDTH)) / 100)), j * 20, Std.int(((Gfx.fadeamount * (Def.SCREENWIDTH)) / 100) + 10), 20, 0, 0, 0);
				}
			}
		}else if (Gfx.fademode == Def.FADING_OUT) {
			for (j in 0...12) {
				if (j % 2 == 0) {
					Gfx.fillrect(-10, j * 20, Std.int(10+(Gfx.fadeamount * (Def.SCREENWIDTH)) / 100), 20, 0, 0, 0);
				}else {
					Gfx.fillrect(Std.int(Gfx.screenwidth - ((Gfx.fadeamount * (Def.SCREENWIDTH)) / 100)), j * 20, Std.int(((Gfx.fadeamount * (Def.SCREENWIDTH)) / 100)+10), 20, 0, 0, 0);
				}
			}
		}
	}
	
	public static function textboxcol(type:Int, shade:Int):Int {
		//Color lookup function for textboxes
		switch(type) {
			case 0: //White textbox
				switch(shade) {
					case 0: return Gfx.RGB(0, 0, 0);
					case 1: return Gfx.RGB(64, 64, 64);
					case 2: return Gfx.RGB(192, 192, 192);
				}
			case 1: //Red textbox
				switch(shade) {
					case 0: return Gfx.RGB(0, 0, 0);
					case 1: return Gfx.RGB(65, 3, 19);
					case 2: return Gfx.RGB(255, 31, 41);
				}
			case 2: //Green textbox
				switch(shade) {
					case 0: return Gfx.RGB(0, 0, 0);
					case 1: return Gfx.RGB(3, 65, 5);
					case 2: return Gfx.RGB(31, 255, 84);
				}
			case 3: //Blue textbox
				switch(shade) {
					case 0: return Gfx.RGB(0, 0, 0);
					case 1: return Gfx.RGB(3, 37, 65);
					case 2: return Gfx.RGB(31, 105, 255);
				}
		}
		return Gfx.RGB(0, 0, 0);
	}
	
	public static function drawtextbox(xp:Int, yp:Int, w:Int, h:Int, col:Int, lerp:Float, state:Int):Void {
		//Draw a textbox at given position and size
		if (state == Textbox.STATE_BOXAPPEARING || state == Textbox.STATE_DISAPPEARING) {
			tempx = 0;
			tempy = 0;
			Gfx.settrect(0, yp + 15 - Std.int(lerp*15), Gfx.screenwidth, Std.int(lerp*30));
			Gfx.backbuffer.fillRect(Gfx.trect, Gfx.RGB(32, 32, 32));
		}else if (state >= Textbox.STATE_TEXTAPPEARING && state <= Textbox.STATE_VISABLE) {
			/*
			//Non-Backing parts
			Gfx.settrect(xp + 16, yp, w - 32, h);	        Gfx.backbuffer.fillRect(Gfx.trect, textboxcol(col, Def.TEXTBORDER));
			Gfx.settrect(xp + 16, yp + 2, w - 32, h - 4);	Gfx.backbuffer.fillRect(Gfx.trect, textboxcol(col, Def.TEXTHIGHLIGHT));
			Gfx.settrect(xp + 16, yp + 4, w - 32, h - 8);	Gfx.backbuffer.fillRect(Gfx.trect, textboxcol(col, Def.TEXTBACKING));
			
			Gfx.settrect(xp, yp + 16, w, h - 32);	        Gfx.backbuffer.fillRect(Gfx.trect, textboxcol(col, Def.TEXTBORDER));
			Gfx.settrect(xp + 2, yp + 16, w - 4, h - 32);	Gfx.backbuffer.fillRect(Gfx.trect, textboxcol(col, Def.TEXTHIGHLIGHT));
			Gfx.settrect(xp + 4, yp + 16, w - 8, h - 32);	Gfx.backbuffer.fillRect(Gfx.trect, textboxcol(col, Def.TEXTBACKING));
			
			//Corners!
			Gfx.scaleMatrix.translate(xp, yp); Gfx.backbuffer.draw(Gfx.tbsides[(col * 4) + 0], Gfx.scaleMatrix); Gfx.scaleMatrix.identity();
			Gfx.scaleMatrix.translate(xp + w - 16, yp);	Gfx.backbuffer.draw(Gfx.tbsides[(col * 4) + 1], Gfx.scaleMatrix); Gfx.scaleMatrix.identity();
			Gfx.scaleMatrix.translate(xp, yp + h - 16); Gfx.backbuffer.draw(Gfx.tbsides[(col * 4) + 2], Gfx.scaleMatrix); Gfx.scaleMatrix.identity();
			Gfx.scaleMatrix.translate(xp + w - 16, yp + h - 16);	Gfx.backbuffer.draw(Gfx.tbsides[(col * 4) + 3], Gfx.scaleMatrix); Gfx.scaleMatrix.identity();
			*/
			Gfx.settrect(0, yp, Gfx.screenwidth, 30);
			Gfx.backbuffer.fillRect(Gfx.trect, Gfx.RGB(32, 32, 32));			
		}
	}
	
	public static function drawbackground():Void {
	}
	
	public static function composesign(k:Int):Void {
		Gfx.sign = k;
		
		#if flash
		Gfx.signcls();
		#else
		for (i in 0...5) {
			Text.tf[i].textColor = Gfx.RGB(Gfx.text_red[k], Gfx.text_green[k], Gfx.text_blue[k]);
			Gfx.signbuffer[k].draw(Text.tf[i], Gfx.shapematrix);	
		}
		Gfx.signcls();
		#end
		
		
		if (Control.frame[k].reverse) {
			Gfx.signfill();
		}else if (Control.effect[k] == "dropin") {
			if (Control.textsize[k] == Def.BIG) {
				Gfx.bigprint(0, 3-(20-Control.effectstate[k]), Control.currenttext[k], true);
			}else if (Control.textsize[k] == Def.TALL) {
				Gfx.tallprint(0, 3-(20-Control.effectstate[k]), Control.currenttext[k], true);
			}else if (Control.textsize[k] == Def.SCROLL) {
				Gfx.tallprint(2 - Control.textposition[k], 3-(20-Control.effectstate[k]), Control.currenttext[k]);
			}	
		}else if (Control.effect[k] == "zoomin") {
			if (Control.textsize[k] == Def.BIG) {
				Gfx.bigprint_crush(0, 3, Control.currenttext[k], (8-Control.effectstate[k]), true);
			}else if (Control.textsize[k] == Def.TALL) {
				Gfx.tallprint_crush(0, 3, Control.currenttext[k], (8-Control.effectstate[k]), true);
			}else if (Control.textsize[k] == Def.SCROLL) {
				Gfx.tallprint_crush(2 - Control.textposition[k], 3, Control.currenttext[k], (8-Control.effectstate[k]));
			}	
		}else if (Control.effect[k] == "teleport") {
			if (Control.textsize[k] == Def.BIG) {
				Gfx.bigprint_teleport(0, 3, Control.currenttext[k], Control.effectstate[k], true);
			}else if (Control.textsize[k] == Def.TALL) {
				Gfx.tallprint_teleport(0, 3, Control.currenttext[k], Control.effectstate[k], true);
			}else if (Control.textsize[k] == Def.SCROLL) {
				Gfx.tallprint_teleport(2 - Control.textposition[k], 3, Control.currenttext[k], Control.effectstate[k]);
			}
		}else if (Control.effect[k] == "split") {
			if (Control.textsize[k] == Def.BIG) {
				var tx:Int = Text.getbigcent(Control.currenttext[k]);
				var ch:String = "";
				var frag:String = "";
				for (i in 0...Control.currenttext[k].length) {
					ch = Help.Mid(Control.currenttext[k], i);
					frag = Help.Mid(Control.currenttext[k], 0, i);
					if (i % 2 == 0) {
						Gfx.bigprint(tx + Std.int(Text.len(frag, 2)), 3 -(20 - Control.effectstate[k]), ch);
					}else{
						Gfx.bigprint(tx + Std.int(Text.len(frag, 2)), 3 + (20 - Control.effectstate[k]), ch);
					}
				}
			}else if (Control.textsize[k] == Def.TALL) {
				var tx:Int = Text.getsmallcent(Control.currenttext[k]);
				var ch:String = "";
				var frag:String = "";
				for (i in 0...Control.currenttext[k].length) {
					ch = Help.Mid(Control.currenttext[k], i);
					frag = Help.Mid(Control.currenttext[k], 0, i);
					if (i % 2 == 0) {
						Gfx.tallprint(tx + Std.int(Text.len(frag)), 3 -(20 - Control.effectstate[k]), ch);
					}else{
						Gfx.tallprint(tx + Std.int(Text.len(frag)), 3 +(20 - Control.effectstate[k]), ch);
					}
				}
			}else if (Control.textsize[k] == Def.SCROLL) {
				var ch:String = "";
				var frag:String = "";
				for (i in 0...Control.currenttext[k].length) {
					ch = Help.Mid(Control.currenttext[k], i);
					frag = Help.Mid(Control.currenttext[k], 0, i);
					if (i % 2 == 0) {					
						Gfx.tallprint(2 + Std.int(Text.len(frag)) - Control.textposition[k], 3 -(20 - Control.effectstate[k]), ch);
					}else {
						Gfx.tallprint(2 + Std.int(Text.len(frag)) - Control.textposition[k], 3 +(20 - Control.effectstate[k]), ch);
					}
				}
			}
		}else if (Control.effect[k] == "bob") {
			if (Control.textsize[k] == Def.BIG) {
				var tx:Int = Text.getbigcent(Control.currenttext[k]);
				var ch:String = "";
				var frag:String = "";
				for (i in 0...Control.currenttext[k].length) {
					ch = Help.Mid(Control.currenttext[k], i);
					frag = Help.Mid(Control.currenttext[k], 0, i);
					if ((Control.effectstate[k] + i)%8 < 4) {
						Gfx.bigprint(tx + Std.int(Text.len(frag, 2)), 3 - 2 + ((Control.effectstate[k] + i) % 8), ch);
					}else{
						Gfx.bigprint(tx + Std.int(Text.len(frag, 2)), 3 + 6 - ((Control.effectstate[k] + i) % 8), ch);
					}
				}
			}else if (Control.textsize[k] == Def.TALL) {
				var tx:Int = Text.getsmallcent(Control.currenttext[k]);
				var ch:String = "";
				var frag:String = "";
				for (i in 0...Control.currenttext[k].length) {
					ch = Help.Mid(Control.currenttext[k], i);
					frag = Help.Mid(Control.currenttext[k], 0, i);
					if ((Control.effectstate[k] + i)%8 < 4) {
						Gfx.tallprint(tx + Std.int(Text.len(frag)), 3 - 2 + ((Control.effectstate[k] + i) % 8), ch);
					}else{
						Gfx.tallprint(tx + Std.int(Text.len(frag)), 3 + 6 - ((Control.effectstate[k] + i) % 8), ch);
					}
				}
			}else if (Control.textsize[k] == Def.SCROLL) {
				var ch:String = "";
				var frag:String = "";
				for (i in 0...Control.currenttext[k].length) {
					ch = Help.Mid(Control.currenttext[k], i);
					frag = Help.Mid(Control.currenttext[k], 0, i);
					if ((Control.effectstate[k] + i) % 8 < 4) {						
						Gfx.tallprint(2 + Std.int(Text.len(frag)) - Control.textposition[k], 3 - 2 + ((Control.effectstate[k] + i) % 8), ch);
					}else {
						Gfx.tallprint(2 + Std.int(Text.len(frag)) - Control.textposition[k], 3 +6 - ((Control.effectstate[k] + i) % 8), ch);
					}
				}
			}
		}else if (Control.effect[k] == "midsplit") {
			if (Control.textsize[k] == Def.BIG) {
				Gfx.bigprint(0, 3, Control.currenttext[k], true);
			}else if (Control.textsize[k] == Def.TALL) {
				Gfx.tallprint(0, 3, Control.currenttext[k], true);
			}else if (Control.textsize[k] == Def.SCROLL) {
				Gfx.tallprint(2 - Control.textposition[k], 3, Control.currenttext[k]);
			}
			Gfx.midsplit((10-Control.effectstate[k]));
		}else if (Control.effect[k] == "shake") {
			if(Control.effectstate[k]<4){
				if (Control.textsize[k] == Def.BIG) {
					Gfx.bigprint(0, 3+ Control.effectstate[k]-2, Control.currenttext[k], true);
				}else if (Control.textsize[k] == Def.TALL) {
					Gfx.tallprint(Control.effectstate[k]-2, 3, Control.currenttext[k], true);
				}else if (Control.textsize[k] == Def.SCROLL) {
					Gfx.tallprint(2 - Control.textposition[k], 3 + Control.effectstate[k]-2, Control.currenttext[k]);
				}
			}else{
				if (Control.textsize[k] == Def.BIG) {
					Gfx.bigprint(0, 3+ (8-Control.effectstate[k])-2, Control.currenttext[k], true);
				}else if (Control.textsize[k] == Def.TALL) {
					Gfx.tallprint((8-Control.effectstate[k])-2, 3, Control.currenttext[k], true);
				}else if (Control.textsize[k] == Def.SCROLL) {
					Gfx.tallprint(2 - Control.textposition[k], 3 + (8-Control.effectstate[k])-2, Control.currenttext[k]);
				}
			}
		}else if (Control.effect[k] == "pixel") {
			if (Control.textsize[k] == Def.BIG) {
				Gfx.bigprint(0, 3, Control.currenttext[k], true);
			}else if (Control.textsize[k] == Def.TALL) {
				Gfx.tallprint(0, 3, Control.currenttext[k], true);
			}else if (Control.textsize[k] == Def.SCROLL) {
				Gfx.tallprint(2 - Control.textposition[k], 3, Control.currenttext[k]);
			}else if (Control.textsize[k] == Def.BYTHE) {
				Gfx.bigprint(-2, 3, "BY");
				Gfx.bigprint(20, 3, "THE");
			}
			
			if (Control.effectstate[k] > 0) {
				Gfx.pixeltext(16 - Control.effectstate[k], Control.effectdelay[k]);
			}
		}else if (Control.effect[k] == "none" || Control.effect[k] == "invert") {
			if (Control.textsize[k] == Def.BIG) {
				Gfx.bigprint(0, 3, Control.currenttext[k], true);
			}else if (Control.textsize[k] == Def.TALL) {
				Gfx.tallprint(0, 3, Control.currenttext[k], true);
			}else if (Control.textsize[k] == Def.SCROLL) {
				Gfx.tallprint(2 - Control.textposition[k], 3, Control.currenttext[k]);
			}
		}else {
			if (Control.textsize[k] == Def.BIG) {
				Gfx.bigprint(0, 3, Control.currenttext[k], true);
			}else if (Control.textsize[k] == Def.TALL) {
				Gfx.tallprint(0, 3, Control.currenttext[k], true);
			}else if (Control.textsize[k] == Def.SCROLL) {
				Gfx.tallprint(2 - Control.textposition[k], 3, Control.currenttext[k]);
			}
		}
		
		if (Control.effect[k] == "invert") {
			if(Control.effectstate[k]==0){
				Gfx.invert();
			}
		}
		
		if (Gfx.stripe[k]) {
			Gfx.textstripe(Gfx.stripestart[k], Gfx.stripeend[k], Gfx.stripecol[k]);
		}
		
		if (Control.supersign) {
			if (Control.effect[k] == "special_explode") {
				Gfx.explodeeffect(Control.effectstate[k]);
			}
			
			if (Control.effect[k] == "special_bouncingbox") {
				Gfx.bouncingboxeffect(Control.effectstate[k]);
			}
			
			if (Control.effect[k] == "special_tunnel") {
				Gfx.tunneleffect(Control.effectstate[k]);
			}
			
			if (Control.effect[k] == "special_plasma") {
				Gfx.plasmaeffect(Control.effectstate[k]);
			}
			
			if (Control.effect[k] == "special_static") {
				Gfx.staticeffect(Control.effectstate[k]);
			}
			
			if (Control.effect[k] == "special_fadein") {
				Gfx.dramaticfade( -16 + Control.effectstate[k]);
			}
			
			if (Control.effect[k] == "special_biggradient") {
				Gfx.biggradient(Control.effectstate[k]);
			}
				
			if (Control.effect[k] == "special_otherbiggradient") {
				Gfx.otherbiggradient(Control.effectstate[k]);
			}
			if (Control.effect[k] == "special_randomgradient") {
				Gfx.randomgradient(Control.effectstate[k]);
			}
			if (Control.effect[k] == "special_rocket") {
				Gfx.specialrocket(Control.effectstate[k]);
			}
		}
		
		if (Gfx.gradient[k]) {
			Gfx.textgradient();
		}
		
		Gfx.drawborder();
	}
	
	public static var tempx:Int;
	public static var tempy:Int;
}