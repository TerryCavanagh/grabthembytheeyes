package objs;

import flash.display.*;
import flash.geom.*;
import flash.events.*;
import flash.net.*;
import com.terry.*;
import com.terry.util.*;

class Ent_person extends Ent_generic {
	public function new() {
		super();
		name = "person";
	}
	
	override public function create(i:Int, xp:Float, yp:Float, para1:String = "0", para2:String = "0", para3:String = "0"):Void {
		Obj.entities[i].rule = "person";
		Obj.entities[i].name = para1;
		if (para1 == "jay") {
			Obj.entities[i].tile = 0;	
		}else if (para1 == "hipster1") {
			Obj.entities[i].tile = 20;				
		}else if (para1 == "hipster2") {
			Obj.entities[i].tile = 40;				
		}else if (para1 == "shopkeep") {
			Obj.entities[i].tile = 100;				
		}
		
		Obj.entities[i].w = 32;
		Obj.entities[i].h = 64;
	}
	
	override public function update(i:Int):Void {
		if (Obj.entities[i].state == 0) {		
		}
	}
	
	override public function animate(i:Int):Void {
		if (Obj.entities[i].vx < 0) {
			Obj.entities[i].dir = 1;
		}else if (Obj.entities[i].vx > 0) {
			Obj.entities[i].dir = 0;
		}else if (Obj.entities[i].vy < 0) {
			if (Obj.entities[i].name == "jay" || Obj.entities[i].name == "hipster1" || Obj.entities[i].name == "hipster2" || Obj.entities[i].name == "shopkeep") {
				
			}else{
				Obj.entities[i].dir = 2;
			}
		}
		
		Obj.entities[i].drawframe = Obj.entities[i].tile + (Obj.entities[i].dir * 3);
		
		if (Obj.entities[i].vx == 0 && Obj.entities[i].vy == 0) {
			//Standing still
		}else {
			//Walking
			Obj.entities[i].framedelay--;
			if (Obj.entities[i].framedelay <= 0) {
				Obj.entities[i].framedelay = 12;
				Obj.entities[i].walkingframe = (Obj.entities[i].walkingframe+1) % 2;
			}
			Obj.entities[i].drawframe = Obj.entities[i].drawframe+Obj.entities[i].walkingframe+1;
		}
		
		//Emotes!
		
		if (Obj.entities[i].emote == "jump") {
			Obj.entities[i].jump();
			Obj.entities[i].emote = "normal";
		}else if (Obj.entities[i].emote == "talk") {
			Obj.entities[i].emoteframedelay--;
			if (Obj.entities[i].emoteframedelay <= 0) {
				Obj.entities[i].emoteframedelay = 6;
				Obj.entities[i].emoteframe = (Obj.entities[i].emoteframe+1) % 2;
			}
			Obj.entities[i].drawframe = Obj.entities[i].tile + 6 + (Obj.entities[i].dir * 2) + Obj.entities[i].emoteframe;
		}else if (Obj.entities[i].emote == "alert") {
			if (Obj.entities[i].emoteframedelay == 0) {
				Obj.entities[i].jump();
			}
			Obj.entities[i].emoteframedelay++;
			if (Obj.entities[i].emoteframedelay > 75) {
				Obj.entities[i].emote = "normal";
			}
		}else if (Obj.entities[i].emote == "confused") {
			Obj.entities[i].emoteframedelay++;
			if (Obj.entities[i].emoteframedelay > 75) {
				Obj.entities[i].emote = "normal";
			}
		}else if (Obj.entities[i].emote == "sad") {
			Obj.entities[i].drawframe = Obj.entities[i].tile + 11;
		}else if (Obj.entities[i].emote == "highfive") {
			Obj.entities[i].drawframe = Obj.entities[i].tile + 10;			
			if (Help.slowsine % 32 == 0) {
				Obj.entities[i].jump();
			}
		}else if (Obj.entities[i].name == "jay") {
			//Jay specific ones
			if (Obj.entities[i].emote == "victory") {
				Obj.entities[i].emoteframedelay--;
				if (Obj.entities[i].emoteframedelay <= 0) {
					Obj.entities[i].emoteframedelay = 64;
					Obj.entities[i].emoteframe = (Obj.entities[i].emoteframe+1) % 2;
				}
				if (Help.slowsine % 32 == 0) {
					Obj.entities[i].jump();
				}
				
				Obj.entities[i].drawframe = Obj.entities[i].tile + 12 + Obj.entities[i].emoteframe;
			}else if (Obj.entities[i].emote == "angry") {
				Obj.entities[i].emoteframedelay--;
				if (Obj.entities[i].emoteframedelay <= 0) {
					Obj.entities[i].emoteframedelay = 6;
					Obj.entities[i].emoteframe = (Obj.entities[i].emoteframe+1) % 2;
				}
				if (Help.slowsine % 16 == 0) {
					Obj.entities[i].jump();
				  Music.playef("angryjump");
				}
				Obj.entities[i].drawframe = Obj.entities[i].tile + 10 + Obj.entities[i].emoteframe;
			}
		}
		
		Obj.entities[i].updatejump();
	}
	
	override public function drawentity(i:Int):Void {
		if (Obj.entities[i].hascart) {
			//Draw the FB cart in front of hipster 1
			if (Obj.entities[i].name == "shopkeep") {
				Gfx.drawsprite(Std.int(Obj.entities[i].xp - 16), Std.int(Obj.entities[i].yp) - Obj.entities[i].jumpframe, Obj.entities[i].drawframe, 0, 0, 0);
				
				Gfx.drawsprite(Std.int(Obj.entities[i].xp - 16) -16+44, Std.int(Obj.entities[i].yp) - Obj.entities[i].jumpframe + 4, 17+18, 0, 0, 0);
				Gfx.drawsprite(Std.int(Obj.entities[i].xp - 16) - 16 + 64 + 44, Std.int(Obj.entities[i].yp) - Obj.entities[i].jumpframe + 4, 18+18, 0, 0, 0);
			}else{
				Gfx.drawsprite(Std.int(Obj.entities[i].xp - 16), Std.int(Obj.entities[i].yp) - Obj.entities[i].jumpframe, Obj.entities[i].drawframe-3, 0, 0, 0);
				
				Gfx.drawsprite(Std.int(Obj.entities[i].xp - 16) -16+44, Std.int(Obj.entities[i].yp) - Obj.entities[i].jumpframe + 4, 17, 0, 0, 0);
				Gfx.drawsprite(Std.int(Obj.entities[i].xp - 16) - 16 + 64 + 44, Std.int(Obj.entities[i].yp) - Obj.entities[i].jumpframe + 4, 18, 0, 0, 0);
			}
		}else {
			Gfx.drawsprite(Std.int(Obj.entities[i].xp - 16), Std.int(Obj.entities[i].yp) - Obj.entities[i].jumpframe, Obj.entities[i].drawframe, 0, 0, 0);
		}
		
		if (Obj.entities[i].emote == "confused") {
			if (Obj.entities[i].emoteframedelay < 32) {
				for (jj in -1...2) {
					for(ii in -1...2){
						Gfx.normalbigprint(Std.int(Obj.entities[i].xp) +16- 2 + (ii*2),16+(jj*2) + Std.int(Obj.entities[i].yp) - Obj.entities[i].jumpframe + 16 - Std.int(Obj.entities[i].emoteframedelay / 8), "?", 0, 0, 0, false);
					}
				}
				Gfx.normalbigprint(Std.int(Obj.entities[i].xp) +16- 2, 16+Std.int(Obj.entities[i].yp) - Obj.entities[i].jumpframe + 16 - Std.int(Obj.entities[i].emoteframedelay / 8), "?", 255, 255, 0, false);
			}else {
				for (jj in -1...2) {
					for(ii in -1...2){
						Gfx.normalbigprint(Std.int(Obj.entities[i].xp) +16- 2 + (ii*2), 16+(jj*2) + Std.int(Obj.entities[i].yp) - Obj.entities[i].jumpframe + 16 - 4, "?", 0 , 0 , 0, false);
					}
				}
				Gfx.normalbigprint(Std.int(Obj.entities[i].xp)+16 - 2, 16+Std.int(Obj.entities[i].yp) - Obj.entities[i].jumpframe + 16 - 4, "?", 255, 255, 0, false);
			}
		}else	if (Obj.entities[i].emote == "alert") {
			if (Obj.entities[i].emoteframedelay < 16) {
				for (jj in -1...2) {
					for(ii in -1...2){
						Gfx.normalbigprint(Std.int(Obj.entities[i].xp)+16 + (ii*2), 16+(jj*2) + Std.int(Obj.entities[i].yp) - Obj.entities[i].jumpframe + 16 - Std.int(Obj.entities[i].emoteframedelay / 4), "!", 0, 0, 0, false);
					}
				}
				Gfx.normalbigprint(Std.int(Obj.entities[i].xp)+16, 16+Std.int(Obj.entities[i].yp) - Obj.entities[i].jumpframe + 16 - Std.int(Obj.entities[i].emoteframedelay / 4), "!", 255, 0, 0, false);
			}else {
				for (jj in -1...2) {
					for(ii in -1...2){
						Gfx.normalbigprint(Std.int(Obj.entities[i].xp)+16 + (ii*2),16+ (jj*2) + Std.int(Obj.entities[i].yp) - Obj.entities[i].jumpframe + 16 - 4, "!", 0 , 0 , 0, false);
					}
				}
				
				Gfx.normalbigprint(Std.int(Obj.entities[i].xp)+16, 16+Std.int(Obj.entities[i].yp) - Obj.entities[i].jumpframe + 16 - 4, "!", 255, 0, 0, false);
			}
		}
	}
	
	override public function drawinit(i:Int, xoff:Int, yoff:Int, frame:Int):Void {
		Gfx.draw_defaultinit(i, xoff, yoff, frame);
	}
	
	override public function collision(i:Int, j:Int):Void {
		//i is this entity, j is the other
	}
}