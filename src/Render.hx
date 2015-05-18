package;

import com.terry.*;
import gamecontrol.*;
import config.*;

//
//Font is 5 high in size 1, 10 high in size 2. screen is 16 high.

class Render {
	//GRAB THEM BY THE EYES
	public static function titlerender() {
	}
	
	public static function gamerender() {
		Gfx.fillrect(0, 0, Gfx.screenwidth, Gfx.screenheight, Def.GRAY[2], Def.GRAY[2], Def.GRAY[2]);
		Gfx.drawimage("bg", 0, 0);
		
		for (k in 0...Gfx.numsigns) {
			Draw.composesign(k);
		}
		
		if (Control.boughtlcdsign) {
			switch(Control.boughtlcdsignstate) {
				case "boughtlcdsign":
					var t:String = "BOUGHT A SIGN!";
				  Gfx.normalbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t, 3) / 2), 15-(Control.boughtlcdsignstate_lerp*1), t, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
					Gfx.drawimage("signbacking", Gfx.screenwidthmid - 79 - (Control.boughtlcdsignstate_lerp * 10), Gfx.screenheightmid - 32, false);
					Gfx.drawsign(0, Gfx.screenwidthmid - 79 - (Control.boughtlcdsignstate_lerp * 10) + 7, Gfx.screenheightmid - 32 + 7, 3);
					Gfx.smallbigprint(0, Gfx.screenheight-25+(Control.boughtlcdsignstate_lerp), "CLICK TO CONTINUE", Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], true);
				case "boughtlcdsign2":
					var t:String = "BOUGHT A SIGN!";
				  Gfx.normalbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t, 3) / 2), 15-((60-Control.boughtlcdsignstate_lerp)*1), t, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
					
					Gfx.drawimage("signbacking", Gfx.screenwidthmid - 79 + ((60 - Control.boughtlcdsignstate_lerp) * 10), Gfx.screenheightmid - 32, false);
					Gfx.drawsign(0, Gfx.screenwidthmid - 79 + ((60 - Control.boughtlcdsignstate_lerp) * 10) + 7, Gfx.screenheightmid - 32 + 7, 3);
					
					Gfx.smallbigprint(0, Gfx.screenheight-25+(60-Control.boughtlcdsignstate_lerp), "CLICK TO CONTINUE", Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], true);
			}
		}
		
		if (Control.currentscreen == "intro") {
			//Gfx.fillrect(
			Gfx.normalbigprint(0, 80, "PHOTOSENSITIVITY WARNING", Def.GRAY[4]); 
			Gfx.normalprint(0, 120, "Please avoid if you are sensitive", Def.GRAY[4]); 
			Gfx.normalprint(0, 136, "to bright flashing lights", Def.GRAY[4]); 
		}else if (Control.currentscreen == "wip") {
			if(Help.slowsine%32>16){
				Gfx.normalbigprint(0, 80 - 25, "WORK IN PROGRESS", Def.GRAY[4]); 
			}else {
				Gfx.normalbigprint(0, 80 - 25, "WORK IN PROGRESS", Def.GRAY[5]); 
			}
			Gfx.normalprint(0, 120-25, "Please don't tell anyone about this", Def.GRAY[4]); 
			Gfx.normalprint(0, 136-25, "game or share any signs just yet!", Def.GRAY[4]); 
			Gfx.normalprint(0, 136, "It should be out in a few days!", Def.GRAY[4]); 
		}else if (Control.currentscreen == "menu") {
			//Gfx.drawsign(0, 0, 0, 8);
			
			Gfx.fillrect(0, 0, Gfx.screenwidth, 64 + 64, 0, 0, 0);
			Gfx.drawsign(0, 10, 0, 4);
			Gfx.drawsign(1, 192, 0, 4);
			Gfx.drawsign(2, 10, 80-16, 4);
			Gfx.drawsign(3, 192 + 10, 80 - 16, 4);
			for (i in 0...12) {
				Gfx.fillrect(0, 128 + i - 8, Gfx.screenwidth, 1, 16 + (i * 8), 16 + (i * 8), 16 + (i * 8));
			}
			
			Gfx.smallbigprint(3, 232-10, "V 1.1", Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false); 
			Gfx.smallbigprint(Std.int(Gfx.screenwidth - Text.len("TERRY CAVANAGH 2015") - 3), 232-10, "TERRY CAVANAGH 2015", Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false); 
		}else if (Control.currentscreen == "editor") {
			Gfx.drawsign(0, 0, 0, 8);
		}else if (Control.currentscreen == "export") {
			Gfx.drawsign(0, 0, 0, 8);
		}else if (Control.currentscreen == "export2") {
			Gfx.normalbigprint(0, 80, "SIGN EXPORTED!", Def.GRAY[4]); 
			
			Gfx.normalprint(0, 120, "Opening browser link...", Def.GRAY[4]); 
		}else if (Control.currentscreen == "startgame") {
			drawworld();
		}else if (Control.currentscreen == "game_shop") {
			Shopphase.shop();
		}else if (Control.currentscreen == "game_editor") {
			Edphase.rendereditorphase();
		}else if (Control.currentscreen == "game_playout") {
			drawworld();
		}else if (Control.currentscreen == "game_newday") {
			drawworld();
		}else if (Control.currentscreen == "game_result") {
			Gfx.normalbigprint(0, 100, "RESULTS FOR THE DAY", Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], true); 
		}else if (Control.currentscreen == "game_complete") {
			Gfx.normalbigprint(0, 40, "GAME OVER", Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], true); 
			
			Gfx.smallbigprint(0, 90, "Hey, thanks for playing through!".toUpperCase(), Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], true); 
			Gfx.smallbigprint(0, 115, "I'm still trying to figure out the".toUpperCase(), Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], true); 
			Gfx.smallbigprint(0, 130, "ending before I release this. Any".toUpperCase(), Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], true); 
			Gfx.smallbigprint(0, 145, "feedback or advice is very welcome!".toUpperCase(), Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], true); 
		}else if (Control.currentscreen == "game_carddep") {
			Carddep.rendercarddep();
		}
		
		if (Customercontrol.customerphase) {
			Customercontrol.drawcustomers(); 
			
			Customercontrol.drawcustomerinfo(0, 0);
		}
		
		if (Control.enddayphase) {
			switch(Control.enddaystate) {
				case "start":
					Gfx.fillrect(Gfx.screenwidthmid - 100, 0, 200, 173-(Control.enddaystate_lerp*10), 64);
					Gfx.fillrect(Gfx.screenwidthmid - 100, 183+(Control.enddaystate_lerp*10), 200, 80, 64);
				case "finish":
					Gfx.fillrect(Gfx.screenwidthmid - 100, 0, 200, 173-((30-Control.enddaystate_lerp)*10), 64);
					Gfx.fillrect(Gfx.screenwidthmid - 100, 183+((30-Control.enddaystate_lerp)*10), 200, 80, 64);
				case "showresult":
					Gfx.fillrect(Gfx.screenwidthmid - 100, 0, 200, 173, 64);
					Gfx.fillrect(Gfx.screenwidthmid - 100, 183, 200, 80, 64);
					if (Control.enddaystate_num > 0) {
						var t:String = "RESULTS AFTER DAY " + Std.string(Control.day);
						Gfx.normalbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t, 3) / 2), 10, t, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
					}
						
					//Headers
					if (Control.enddaystate_num > 1) {
						Gfx.smallprint(Gfx.screenwidthmid-25, 45, "JAY'S FOOD", Def.GRAY[2], Def.GRAY[2], Def.GRAY[2], false);	
						Gfx.smallprint(Gfx.screenwidthmid-25+12, 52, "STAND", Def.GRAY[2], Def.GRAY[2], Def.GRAY[2], false);	
						
						Gfx.smallprint(Gfx.screenwidthmid + 50, 45, "FILTHY", Def.GRAY[2], Def.GRAY[2], Def.GRAY[2], false);
						Gfx.smallprint(Gfx.screenwidthmid + 50, 52, "BURGER", Def.GRAY[2], Def.GRAY[2], Def.GRAY[2], false);
					}
					
					//Daily scores
					for (i in 0...6) {
						if (Control.enddaystate_num > 1+i) {
							Gfx.smallbigprint(Gfx.screenwidthmid - 40 - Std.int(Text.len(Control.dayname[i])), 60 + (i * 18), Control.dayname[i], Def.GRAY[3], Def.GRAY[3], Def.GRAY[3], false);	
							
							if (Control.day - 1 >= i) {
								Gfx.normalprint(Gfx.screenwidthmid - 25 + 15, 62 + (i * 18), Std.string(Control.dayscore_jay[i]), Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
								Gfx.normalprint(Gfx.screenwidthmid + 45 + 10, 62 + (i * 18), Std.string(Control.dayscore_fb[i]), Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
							}else {
								Gfx.normalprint(Gfx.screenwidthmid - 25 + 15, 62 + (i * 18), "-", Def.GRAY[2], Def.GRAY[2], Def.GRAY[2], false);
								Gfx.normalprint(Gfx.screenwidthmid + 45 + 10, 62 + (i * 18), "-", Def.GRAY[2], Def.GRAY[2], Def.GRAY[2], false);
							}
						}
					}
					
					//Show total
					if (Control.enddaystate_num > 7) {
						Gfx.smallbigprint(Gfx.screenwidthmid - 40 - Std.int(Text.len("TOTAL")), 60 + (7 * 18), "TOTAL", Def.GRAY[3], Def.GRAY[3], Def.GRAY[3], false);	
						if (Control.enddaystate_num > 8) {
							Gfx.normalprint(Gfx.screenwidthmid - 25+15, 62 + (7 * 18), Std.string(Control.totalscore_jay), Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
							Gfx.normalprint(Gfx.screenwidthmid + 45 + 10, 62 + (7 * 18), Std.string(Control.totalscore_fb), Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
						}
					}
					
					if (Control.enddaystate_num > 9) {
						Gfx.smallbigprint(0, Gfx.screenheight - 25, "CLICK TO CONTINUE", Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], true);
					}
			}
		}
		
		if (Control.showcutsceneborders) {
			Gfx.fillrect(0, 0, Gfx.screenwidth, Control.cutscenebars, 0);
			Gfx.fillrect(0, Gfx.screenheight-Control.cutscenebars, Gfx.screenwidth, 10, 0);
		}
		
		if (Control.showdayinfo > 0) {
			if (Control.showdayinfo > 150) {
				if (Control.showgamesaved) {
					Gfx.fillrect(Gfx.screenwidthmid-120-2, Gfx.screenheight - 30+(Control.showdayinfo-150)-2, 240+4, 20+4, Def.GRAY[4]);
					Gfx.fillrect(Gfx.screenwidthmid - 120, Gfx.screenheight - 30 + (Control.showdayinfo - 150), 240, 20, Def.GRAY[0]);
					Gfx.normalprint(0, Gfx.screenheight - 26+(Control.showdayinfo-150), "GAME SAVED - " + Control.dayname[Control.day-1], Def.GRAY[5]);
				}else{
					Gfx.fillrect(Gfx.screenwidthmid-80-2, Gfx.screenheight - 30+(Control.showdayinfo-150)-2, 160+4, 20+4, Def.GRAY[4]);
					Gfx.fillrect(Gfx.screenwidthmid - 80, Gfx.screenheight - 30 + (Control.showdayinfo - 150), 160, 20, Def.GRAY[0]);
					Gfx.normalprint(0, Gfx.screenheight - 26+(Control.showdayinfo-150), Control.dayname[Control.day-1], Def.GRAY[5]);
				}
			}else if (Control.showdayinfo > 30) {
				if (Control.showgamesaved) {
					Gfx.fillrect(Gfx.screenwidthmid-120-2, Gfx.screenheight - 30-2, 240+4, 20+4, Def.GRAY[4]);
					Gfx.fillrect(Gfx.screenwidthmid-120, Gfx.screenheight - 30, 240, 20, Def.GRAY[0]);
					Gfx.normalprint(0, Gfx.screenheight - 26, "GAME SAVED - " + Control.dayname[Control.day - 1], Def.GRAY[5]);
				}else {
					Gfx.fillrect(Gfx.screenwidthmid-80-2, Gfx.screenheight - 30-2, 160+4, 20+4, Def.GRAY[4]);
					Gfx.fillrect(Gfx.screenwidthmid-80, Gfx.screenheight - 30, 160, 20, Def.GRAY[0]);
					Gfx.normalprint(0, Gfx.screenheight - 26, Control.dayname[Control.day - 1], Def.GRAY[5]);					
				}
			}else {
				if (Control.showgamesaved) {
					Gfx.fillrect(Gfx.screenwidthmid-120-2, Gfx.screenheight - 30+(30-Control.showdayinfo)-2, 240+4, 20+4, Def.GRAY[4]);
					Gfx.fillrect(Gfx.screenwidthmid-120, Gfx.screenheight - 30+(30-Control.showdayinfo), 240, 20, Def.GRAY[0]);
					Gfx.normalprint(0, Gfx.screenheight - 26+(30-Control.showdayinfo), "GAME SAVED - " + Control.dayname[Control.day-1], Def.GRAY[5]);
				}else {
					Gfx.fillrect(Gfx.screenwidthmid-80-2, Gfx.screenheight - 30+(30-Control.showdayinfo)-2, 160+4, 20+4, Def.GRAY[4]);
					Gfx.fillrect(Gfx.screenwidthmid-80, Gfx.screenheight - 30+(30-Control.showdayinfo), 160, 20, Def.GRAY[0]);
					Gfx.normalprint(0, Gfx.screenheight - 26 + (30 - Control.showdayinfo), Control.dayname[Control.day - 1], Def.GRAY[5]);
				}
			}
		}
		
		if (Control.supersign) {
			Gfx.fillrect(0, 0, Gfx.screenwidth, Gfx.screenheight, 0);
			Gfx.drawsign(0, 0, Gfx.screenheightmid - 72, 8);
		}
		
		if (Control.gameoverbanner) {
			Gfx.fillrect(0, Gfx.screenheight - Control.gameoverbannerposition, Gfx.screenwidth, 40, Def.GRAY[1]);
			
			Gfx.normalbigprint(20, Gfx.screenheight - Control.gameoverbannerposition + 8, Control.gameovermessage,  Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
		}
		
		if (Control.currentscreen != "game_editor") {
			Gui.drawbuttons();
		}
		
		#if !flash
		
		if (Control.exitmenu) {
			Gfx.drawimage("tint");
			Gfx.drawimage("tint");
			Gfx.drawimage("tint");
			
			Gfx.normalbigprint(0, 80, "EXIT GAME?", Def.GRAY[4], Def.GRAY[2], Def.GRAY[2]); 
			Gfx.normalprint(0, 120, "PRESS [ESCAPE] TO QUIT OR", Def.GRAY[4]); 
			Gfx.normalprint(0, 136, "LEFT CLICK TO RETURN TO GAME", Def.GRAY[4]); 
			Gfx.smallbigprint(0, 220, "PRESS [F] TO TOGGLE FULLSCREEN", Def.GRAY[4]); 
		}
		
		#end
	}
	
	public static function drawworld():Void {
		if (Control.scene != "") {
			Gfx.drawimage(Control.scene);
			if (Control.scene == "streets") {
				if (Control.jayhascart) {
					Gfx.drawsprite(21, 33, 15, 0, 0, 0);
					Gfx.drawsprite(85, 33, 16, 0, 0, 0);
				}
				if (Control.fbhascart) {
					Gfx.drawsprite(Gfx.screenwidth-150, 33, 17, 0, 0, 0);
					Gfx.drawsprite(Gfx.screenwidth-86, 33, 18, 0, 0, 0);
				}
				if (Control.shopkeephascart) {
					Gfx.drawsprite(Gfx.screenwidth-150, 33, 17+18, 0, 0, 0);
					Gfx.drawsprite(Gfx.screenwidth-86, 33, 18+18, 0, 0, 0);
				}
			}
		}
		
		Gfx.drawentities();
		
		if (Control.scene == "streets") {
			if (Control.jayhascart) {
				//If Jay is behind the cart, draw it in front
				Control.tx = Obj.getperson("jay");
				if(Control.tx>-1){
					if (Obj.entities[Control.tx].yp < 40) {
						Gfx.drawsprite(21, 33, 15, 0, 0, 0);
						Gfx.drawsprite(85, 33, 16, 0, 0, 0);
					}
				}
			}
			if (Control.fbhascart) {
				Control.tx = Obj.getperson("hipster1");
				if(Control.tx>-1){
					if (Obj.entities[Control.tx].yp < 40) {
						Gfx.drawsprite(Gfx.screenwidth-150, 33, 17, 0, 0, 0);
						Gfx.drawsprite(Gfx.screenwidth-86, 33, 18, 0, 0, 0);
					}
				}
			}
			
			Control.tx = Obj.getperson("shopkeep");
			if (Control.tx > -1) {
				if (Obj.entities[Control.tx].hascart) {
					Obj.templates[Obj.entindex.get(Obj.entities[Control.tx].type)].drawentity(Control.tx);
				}
				if (Obj.entities[Control.tx].yp < 40) {
					//Gfx.drawsprite(Gfx.screenwidth-150, 33, 17+18, 0, 0, 0);
					//Gfx.drawsprite(Gfx.screenwidth-86, 33, 18+18, 0, 0, 0);
				}
			}
			
			if (Control.jayhassign) {
				Gfx.drawimage("signbacking", 9, 10);
				Gfx.drawsign(0, 16, 17, 3);
			}
			if (Control.fbhassign) {
				Gfx.drawimage("signbacking", 217, 10);
				Gfx.drawsign(1, 224, 17, 3);
			}
			if (Control.shopkeephassign) {
				Gfx.drawimagebig("signbacking", 217 - 79 - 4, 10 - 62 + 4);
				Gfx.fillrect(224-79, 27-62+4, 48 * 6, 16 * 6, 0, 0, 0);
				for (j in 0...16) {
					for (i in 0...48) {
						Gfx.fillrect(224-79 + (i*6), 27-62+4 + (j*6), 6,6, 64+Std.int(Math.random()*128));
					}
				}
				
			}
		}else if (Control.scene == "northstreet") {
			if (Control.shopkeephascart) {
				Gfx.drawsprite(Gfx.screenwidthmid-64, 33, 17+18, 0, 0, 0);
				Gfx.drawsprite(Gfx.screenwidthmid-0, 33, 18+18, 0, 0, 0);
			}
			if (Control.shopkeephassign) {
				Gfx.drawimagebig("signbacking", Gfx.screenwidthmid-158, 10 - 62 + 4);
				Gfx.fillrect( Gfx.screenwidthmid-158+14, 27-62+4, 48 * 6, 16 * 6, 0, 0, 0);
				for (j in 0...16) {
					for (i in 0...48) {
						Gfx.fillrect( Gfx.screenwidthmid-158 +14+ (i*6), 27-62+4 + (j*6), 6,6, 64+Std.int(Math.random()*128));
					}
				}
			}
			for (i in 0...Obj.nentity) {
				if (Obj.entities[i].active) {
					if (!Obj.entities[i].invis) {
						if(Obj.entities[i].name!="shopkeep"){
							Obj.templates[Obj.entindex.get(Obj.entities[i].type)].drawentity(i);
						}
					}
				}
			}
		}
		
		
		if (Control.scene == "shop") {
			Gfx.drawimage("frontdesk", 114, 66);
		}
		
		if(Control.zoom){
			Gfx.zoomin(Control.zoomx, Control.zoomy, 2);
		}
		
		Gfx.drawgui();
		//Gfx.normalbigprint(0, 100, "INTRO SCREEN", Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], true); 
	}
}