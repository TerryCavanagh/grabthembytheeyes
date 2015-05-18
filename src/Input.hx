package;

import com.terry.*;
import gamecontrol.*;
import config.*;
import openfl.system.System;

class Input {
	public static function titleinput() {
		
	}
	
	public static function gameinput() {
		#if !flash
		
		if (Control.exitmenu) {
			if (Key.justPressed("ESCAPE")) {
				System.exit(0);
			}
			
			if (Mouse.justleftpressed()) {
				Control.exitmenu = !Control.exitmenu;
				if (Control.exitmenu) {
					Control.addexitmenu();
				}else {
					Control.removeexitmenu();
				}
			}
			
			if (Key.justPressed("F")) {
				Game.fullscreen = !Game.fullscreen;
			  Game.updategraphicsmode();
				Savecookie.savefullscreensettings(Game.fullscreen);
			}
		}else{
			if (Key.justPressed("ESCAPE")) {
				Control.exitmenu = !Control.exitmenu;
				if (Control.exitmenu) {
					Control.addexitmenu();
				}else {
					Control.removeexitmenu();
				}
			}
		}
		
		#end
		
		if (Control.exitmenu) {
			
		}else{
			//Special for export link
			Mouse.visitsite("");
			for (i in 0...Gui.numbuttons) {
				if (Gui.button[i].active) {
					if (Gui.button[i].style == "flashing") {
						if (Gui.button[i].mouseover) {
							Mouse.visitsite(Control.signstring);
						}
					}
				}
			}
			
			if (Gfx.fademode == Def.FADED_IN) Gui.checkinput();
			
			if (Game.pausescript) {
				//Advance text
				if(Mouse.justleftpressed()){
					Game.pausescript = false;
					Textbox.textboxremove();
					
					for (i in 0...Obj.nentity) {
						if (Obj.entities[i].active) {
							if (Obj.entities[i].emote == "talk") {
								Obj.entities[i].emote = "normal";
							}
						}
					}
				}
			}
			
			if (Control.currentscreen == "game_shop") {
				checkshop();
			}else if (Control.currentscreen == "game_editor") {
				gameeditorinput();
			}else if (Control.enddayphase) {
				if (Control.enddaystate == "showresult") {
					if (Control.enddaystate_num >= 10) {
						if (Mouse.justleftpressed()) {
							Control.changeenddaystate("finish");
						}
					}
				}
			}else if (Control.boughtlcdsign) {
				if(Control.boughtlcdsignstate=="boughtlcdsign"){
					if (Mouse.justleftpressed()) {
						Control.changeboughtlcdsignstate("boughtlcdsign2");
					}
				}
			}
		}
	}
		
	public static function checkshop():Void {
		switch(Control.shopphasestate) {
			case "gameloop_aiplay_waitforclick":
				if (Mouse.justleftpressed()) Control.changeshopstate("gameloop_cardpicked");
			case "shoptutorial_yes1":
				if (Mouse.justleftpressed()) Control.changeshopstate("shoptutorial_yes2");
			case "shoptutorial_yes2":
				if (Mouse.justleftpressed()) Control.changeshopstate("shoptutorial_yes3");
			case "shoptutorial_yes4":
				if (Mouse.justleftpressed()) Control.changeshopstate("shoptutorial_yes5");
			case "shoptutorial_yes5":
				if (Mouse.justleftpressed()) Control.changeshopstate("shoptutorial_yes6");
			case "shoptutorial_yes6":
				if (Mouse.justleftpressed()) Control.changeshopstate("shoptutorial_yes7");
				case "gameloop_play":
				if (Mouse.justleftpressed()) {
					Control.shoppickcard = Control.getmouseovercard();
					if (Control.shoppickcard > -1) {
						if (Control.deck[Control.deckindex.get("shopdeck")].numcards > Control.shoppickcard) {
							if (Control.jaybudget >= Control.shoppickcard + 1) {
								Control.changeshopstate("gameloop_cardpicked");
							}
						}
					}
				}
		}
	}
	
	public static function gameeditorinput():Void {
		switch(Control.editorphasestate) {
			case "gameloop_play":
				if (Mouse.justleftpressed()) {
					var clickedtab:Bool = false;
					for(i in 0...4){
						if (Mouse.x > (Edphase.tabsize * i) && Mouse.x < (Edphase.tabsize * (i + 1)) && Mouse.y > Gfx.screenheight - 24) {
							Edphase.currenttab = i;
							Control.changeeditorstate("opentab");
							clickedtab = true;
						}
						
						if (Mouse.x > Std.int((Gfx.screenwidth / 4) / 2) + Std.int((Gfx.screenwidth / 4) * i) - Std.int(74 / 2) && Mouse.x < Std.int((Gfx.screenwidth / 4) / 2) + Std.int((Gfx.screenwidth / 4) * i) - Std.int(74 / 2) + 74 && Mouse.y > Gfx.screenheightmid -50 && Mouse.y < Gfx.screenheightmid -50 + 94) {
							//Clicked on the actual card
							Edphase.currenttab = i;
							Control.changeeditorstate("opentab");
							clickedtab = true;
						}
					}
					
					if (!clickedtab) {
						//Check for frame change
						if (Edphase.numplayerframes == 2) {
							if (Help.inboxw(Mouse.x, Mouse.y,  Std.int(Gfx.screenwidthmid / 2) - 48 - 24, 5, 48 * 3, 10+16 * 3)) {
								Edphase.changeframe(0);
							}else if (Help.inboxw(Mouse.x, Mouse.y, Gfx.screenwidthmid + Std.int(Gfx.screenwidthmid / 2) - 48 -24, 5, 48 * 3, 10+16 * 3)) {
								Edphase.changeframe(1);
							}
						}else if (Edphase.numplayerframes == 3 || Edphase.numplayerframes == 4) {
							for (i in 0...Edphase.numplayerframes) {
								if (Help.inboxw(Mouse.x, Mouse.y, Std.int((Gfx.screenwidth / Edphase.numplayerframes) / 2) + Std.int((Gfx.screenwidth / Edphase.numplayerframes) * i) - 48, 16, 48 * 2, 10 + 16 * 2)) {
									Edphase.changeframe(i);
								}
							}
						}else {
							for (i in 0...Edphase.numplayerframes) {
								if (Help.inboxw(Mouse.x, Mouse.y, Std.int((Gfx.screenwidth / Edphase.numplayerframes) / 2) + Std.int((Gfx.screenwidth / Edphase.numplayerframes) * i) - 24, 24, 48, 10 + 16)) {
									Edphase.changeframe(i);
								}
							}
						}
					}
				}
			case "gameloop_tabopen":
				if (Mouse.justleftpressed()) {
					var clickedtab:Bool = false;
					for(i in 0...4){
						if (Mouse.x > (Edphase.tabsize * i) && Mouse.x < (Edphase.tabsize * (i + 1)) && Mouse.y > Gfx.screenheight - 24) {
							if (Edphase.currenttab != i) {
								Edphase.currenttab = i;
								Control.changeeditorstate("opentab");
								clickedtab = true;
							}
						}
					}
					
					if (!clickedtab) {
						if (Edphase.cardselection == -1) {
							Control.changeeditorstate("closetab");
						}else if (Edphase.cardselection > Edphase.numcardsintab(Edphase.currenttab)) {
							Edphase.finalcardselection = Edphase.cardselection;
							Edphase.finaltabselection = Edphase.currenttab;
							if (Edphase.currenttab == 0) {
								if(Edphase.cardselection == Edphase.numcardsintab(Edphase.currenttab)+1){
									Control.changeeditorstate("writeyourown");
								}else if (Edphase.cardselection == Edphase.numcardsintab(Edphase.currenttab)+2) {
									Control.changeeditorstate("removecard");
								}
							}else{
								Control.changeeditorstate("removecard");
							}
						}else {
							Edphase.finalcardselection = Edphase.cardselection;
							Edphase.finaltabselection = Edphase.currenttab;
							Control.changeeditorstate("playcard");
						}
					}
				}
		}
	}
}