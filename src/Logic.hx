package;

import com.terry.*;
import gamecontrol.*;
import config.*;

class Logic {
	public static function titlelogic() {
		
	}
	
	public static function gamelogic():Void {
		for (i in 0...Obj.nentity) {
			Obj.animateentities(i);
		}
		
		if (Control.gameoverbanner) {
			Control.gameoverbannerposition++;
			if (Control.gameoverbannerposition > 40) {
				Control.gameoverbannerposition = 40;
				if (!Control.gameovershowbutton) {
					Control.gameovershowbutton = true;
					Gui.addbutton(Gfx.screenwidth - 160, Gfx.screenheight-30, 140, 20, "GO TO MENU", "gotomenu");
				}
			}
		}
		
		if (Control.characterswalking()) {
			if (Control.walkingdelay <= 0) {
				Music.playef("walking");
				Control.walkingdelay = Control.walkingdelaysize;
			}else {
				Control.walkingdelay--;
			}
		}
		
		if (Control.showdayinfo > 0) Control.showdayinfo--;
		
		if (Game.running) {
			Control.cutscenebars++;
			if (Control.cutscenebars > 10) Control.cutscenebars = 10;
		}else {
			if (Control.cutscenebars > 0) {
				Control.cutscenebars -= 2;
				if (Control.cutscenebars < 0) Control.cutscenebars = 0;
			}
		}
		
		for (i in 0...Gfx.numsigns) {
			Control.updatesigns(i);
		}
		
		for (i in 0...Obj.nentity) {
			if (Obj.entities[i].doscriptmove) {
				if (Obj.entities[i].scriptmovedestx > Obj.entities[i].xp + 3) {
					Obj.entities[i].vx = 2;
				}else if (Obj.entities[i].scriptmovedestx < Obj.entities[i].xp - 3) {
					Obj.entities[i].vx = -2;
				}else {
					Obj.entities[i].vx = 0;
				}
				
				if (Obj.entities[i].scriptmovedesty > Obj.entities[i].yp + 3) {
					Obj.entities[i].vy = 2;
				}else if (Obj.entities[i].scriptmovedesty < Obj.entities[i].yp - 3) {
					Obj.entities[i].vy = -2;
				}else {
					Obj.entities[i].vy = 0;
				}
				
				if (Obj.entities[i].vy == 0 && Obj.entities[i].vx == 0) {
					Obj.entities[i].doscriptmove = false;
				}
			}
		}
		
		for (i in 0...Obj.nentity) {
			Obj.updateentities(i);          // Behavioral logic
			Obj.updateentitylogic(i);       // Basic Physics
		}
		
		Customercontrol.updatecustomers();
		
		if (Control.currentscreen == "game_shop") {
			Shopphase.updateshop();
		}else if (Control.currentscreen == "game_carddep") {
			Carddep.updatecarddep();
		}else if (Control.currentscreen == "game_editor") {
			Edphase.updategameeditor();
		}else if (Control.enddayphase) {
			if (Control.enddaystate_lerp > 0) {
				Control.enddaystate_lerp--;
			}else {
				if (Control.enddaystate_delay > 0) {
					Control.enddaystate_delay--;
				}else {
					if(Control.enddaystate_nextstate!=""){
						Control.changeenddaystate(Control.enddaystate_nextstate);
					}
				}
			}
			
			if (!Control.enddaystate_finished) {
				Control.enddaystate_finished = true;
				switch(Control.enddaystate) {
					case "start":
						Control.enddaystate_num = 0;
						if (Control.turbomode) {
							Control.enddaystate_num = 8;
						}
						Control.enddaystate_lerp = 30;
						Control.enddaystate_delay = 45;
						Control.enddaystate_nextstate = "showresult";
					case "showresult":
						if (Control.enddaystate_delay == 0) {
							if (Control.enddaystate_num == 0) {
								Control.enddaystate_delay = 60;
							}else if (Control.enddaystate_num == 7) {
								Music.playef("drumroll");
								Music.playef("dayscore");
								Control.enddaystate_delay = 150;
							}else if (Control.enddaystate_num == 8) {
								Control.enddaystate_delay = 60;
								
								if (Control.totalscore_fb > Control.totalscore_jay) {
									Music.playef("lose");
									Obj.entities[Obj.getperson("jay")].dir = 1;
									Obj.entities[Obj.getperson("hipster1")].xp++;
									Obj.entities[Obj.getperson("hipster1")].emote = "highfive";
									Obj.entities[Obj.getperson("hipster1")].emoteframe = 0;
									Obj.entities[Obj.getperson("hipster1")].emoteframedelay = 0;
									Obj.entities[Obj.getperson("hipster2")].xp--;
									Obj.entities[Obj.getperson("hipster2")].emote = "highfive";
									Obj.entities[Obj.getperson("hipster2")].emoteframe = 0;
									Obj.entities[Obj.getperson("hipster2")].emoteframedelay = 0;
								}else if (Control.totalscore_fb < Control.totalscore_jay) {
									Music.playef("win");
									Obj.entities[Obj.getperson("jay")].emote = "victory";
									Obj.entities[Obj.getperson("jay")].emoteframe = 0;
									Obj.entities[Obj.getperson("jay")].emoteframedelay = 0;
									Obj.entities[Obj.getperson("hipster1")].emote = "sad";
									Obj.entities[Obj.getperson("hipster1")].emoteframe = 0;
									Obj.entities[Obj.getperson("hipster1")].emoteframedelay = 0;
									Obj.entities[Obj.getperson("hipster2")].emote = "sad";
									Obj.entities[Obj.getperson("hipster2")].emoteframe = 0;
									Obj.entities[Obj.getperson("hipster2")].emoteframedelay = 0;
								}else {
									Obj.entities[Obj.getperson("jay")].emote = "confused";
									Obj.entities[Obj.getperson("jay")].emoteframe = 0;
									Obj.entities[Obj.getperson("jay")].emoteframedelay = 0;
									Obj.entities[Obj.getperson("hipster1")].emote = "confused";
									Obj.entities[Obj.getperson("hipster1")].emoteframe = 0;
									Obj.entities[Obj.getperson("hipster1")].emoteframedelay = 0;
									Obj.entities[Obj.getperson("hipster2")].emote = "confused";
									Obj.entities[Obj.getperson("hipster2")].emoteframe = 0;
									Obj.entities[Obj.getperson("hipster2")].emoteframedelay = 0;
								}
							}else {
								if (Control.enddaystate_num < 8)	Music.playef("dayscore");
								Control.enddaystate_delay = 20;
							}
							Control.enddaystate_num++;
						}
						
						if (Control.enddaystate_num >= 10) {
							Control.enddaystate_delay = 0;
						}else{
							Control.enddaystate_finished = false;
						}
					case "finish":
						Control.enddaystate_num = 0;
						Control.enddaystate_lerp = 30;
						Control.enddaystate_delay = 30;
						Control.enddaystate_nextstate = "finish2";
					case "finish2":
						Control.enddayphase = false;
					
				}
			}
		}else if (Control.boughtlcdsign) {
			if (Control.boughtlcdsignstate_lerp > 0) {
				Control.boughtlcdsignstate_lerp--;
			}else {
				if (Control.boughtlcdsignstate_delay > 0) {
					Control.boughtlcdsignstate_delay--;
				}else {
					if(Control.boughtlcdsignstate_nextstate!=""){
						Control.changeboughtlcdsignstate(Control.boughtlcdsignstate_nextstate);
					}
				}
			}
			
			if (!Control.boughtlcdsignstate_finished) {
				Control.boughtlcdsignstate_finished = true;
				switch(Control.boughtlcdsignstate) {
					case "boughtlcdsign":
						Gfx.sign = 0;
						Control.frame[0].clear();
						Control.frame[0].add("EAT AT", "white", "none", "none");
						Control.frame[0].add("JAY'S", "white", "none", "none");
						Control.frame[0].start(0);
						Control.frame[0].delay = 90;
						
						Music.playef("sold");
						Control.boughtlcdsignstate_lerp = 60;
					case "boughtlcdsign2":
						Control.boughtlcdsignstate_lerp = 60;
						Control.boughtlcdsignstate_delay = 40;
						Control.boughtlcdsignstate_nextstate = "boughtlcdsign3";
					case "boughtlcdsign3":
						Control.boughtlcdsign = false;
				}
			}
		}
	}
}