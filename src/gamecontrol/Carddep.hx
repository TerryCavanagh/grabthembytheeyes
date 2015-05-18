package gamecontrol;

import com.terry.*;

class Carddep {
	public static function updatecarddep():Void {
		if (Control.carddepphase) {
			if (Control.carddepstate_lerp > 0) {
				Control.carddepstate_lerp--;
			}else {
				if (Control.carddepstate_delay > 0) {
					Control.carddepstate_delay--;
				}else {
					if(Control.carddepstate_nextstate!=""){
						Control.changecarddepstate(Control.carddepstate_nextstate);
					}
				}
			}
			
			if (!Control.carddepstate_finished) {
				Control.carddepstate_finished = true;
				switch(Control.carddepstate) {
					case "start":
						//Make a collection of all the cards that are getting deprecated
						Control.carddepstate_lerp = 100;
						Control.carddepstate_num = 0;
						Control.changedeck("workingdeck");
						Control.cleardeck("workingdeck");
						for (i in 0 ... Edphase.numplayerframes) {
							Edphase.copyframecards(i);
						}
						//We have all the cards in use now
						//ACTUALLY deprecate the real ones
						for (i in 0 ... Control.deck[Control.currentdeck].numcards) {
							Control.depreciate(i);
						}
						//FOR TESTING {
						//Add some random cards to deprecate
						/*
						Control.changeotherdeck("masterdeck");
						Control.copy("this. sick. meat.", "message");
						Control.copy("stripe", "colour");
						Control.copy("filthy", "message");
						Control.copy("fire", "colour");
						Control.copy("alternate", "border");
						Control.copy("build", "effect");
						for (i in 0 ... Control.deck[Control.currentdeck].numcards) {
							trace(Control.deck[Control.currentdeck].card[i].name);
						}
						*/
						//FOR TESTING }
						
						if (Control.deck[Control.currentdeck].numcards == 0) {
							//Weird. Go directly to finish?
							Control.carddepstate_nextstate = "cleartext";
						}else {
							Control.carddepstate_nextstate = "deprecatecards";
						}
					case "deprecatecards":
						Control.carddepstate_lerp = 10;
						Control.carddepstate_delay = 15;
						if (Control.deck[Control.currentdeck].card[Control.carddepstate_num].score > 1) {
							Control.carddepstate_nextstate = "deprecatecards2";
						}else {
							Control.carddepstate_nextstate = "deprecatecards3";
						}
					case "deprecatecards2":
						Music.playef("reduce");
						Control.deck[Control.currentdeck].card[Control.carddepstate_num].score--;
						Control.carddepstate_lerp = 10;
						Control.carddepstate_delay = 15;
						Control.carddepstate_nextstate = "deprecatecards3";
					case "deprecatecards3":
						Control.carddepstate_delay = 5;
						Control.carddepstate_nextstate = "deprecatecards";
						Control.carddepstate_num++;
						if (Control.carddepstate_num >= Control.deck[Control.currentdeck].numcards) {
							Control.carddepstate_nextstate = "clearscreen";
						}
					case "clearscreen":
						Control.carddepstate_lerp = 100;
						Control.carddepstate_nextstate = "cleartext";
					case "cleartext":
						Control.carddepstate_lerp = 10;
						Control.carddepstate_nextstate = "finish";
					case "finish":
						//Start new day!
						Gfx.fademode = Def.FADE_OUT;
						Gfx.fadeaction = "game_newday";
				}
			}
		}
	}
	
	public static function rendercarddep():Void{
	  if (Control.carddepphase) {
			switch(Control.carddepstate) {
				case "start":
					var t:String = "THE PEOPLE DEMAND NOVELTY!";
				  Gfx.normalbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t, 3) / 2), 15, t, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
					
					t = "MESSAGES AND SETTINGS BECOME LESS EFFECTIVE";
					Gfx.smallbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t) / 2), Gfx.screenheight-45, t, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
					t = "AS YOUR CUSTOMERS GET USED TO THEM";
					Gfx.smallbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t) / 2),  Gfx.screenheight - 30, t, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
					
					if (Control.deckindex.get("workingdeck") == Control.currentdeck) {
						for(i in 0 ... Control.deck[Control.currentdeck].numcards){
							Gfx.drawcard(Gfx.screenwidthmid - Std.int(74 / 2) + Std.int(Control.carddepstate_lerp * 8) + (i * 80) + 80, Gfx.screenheightmid - Std.int(96 / 2), Control.deck[Control.currentdeck].card[i]);
						}
					}
				case "deprecatecards":
					var t:String = "THE PEOPLE DEMAND NOVELTY!";
				  Gfx.normalbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t, 3) / 2), 15, t, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
					
					t = "MESSAGES AND SETTINGS BECOME LESS EFFECTIVE";
					Gfx.smallbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t) / 2), Gfx.screenheight-45, t, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
					t = "AS YOUR CUSTOMERS GET USED TO THEM";
					Gfx.smallbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t) / 2),  Gfx.screenheight - 30, t, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
					
					for(i in 0 ... Control.deck[Control.currentdeck].numcards){
						Gfx.drawcard(Gfx.screenwidthmid - Std.int(74 / 2) + Std.int(Control.carddepstate_lerp * 8) - (Control.carddepstate_num * 80) + (i * 80), Gfx.screenheightmid - Std.int(96 / 2), Control.deck[Control.currentdeck].card[i]);
					}
				case "deprecatecards2":
					var t:String = "THE PEOPLE DEMAND NOVELTY!";
				  Gfx.normalbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t, 3) / 2), 15, t, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
					
					t = "MESSAGES AND SETTINGS BECOME LESS EFFECTIVE";
					Gfx.smallbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t) / 2), Gfx.screenheight-45, t, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
					t = "AS YOUR CUSTOMERS GET USED TO THEM";
					Gfx.smallbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t) / 2),  Gfx.screenheight - 30, t, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
					
					for (i in 0 ... Control.deck[Control.currentdeck].numcards) {
						if (i == Control.carddepstate_num) {
							Gfx.drawcard(Gfx.screenwidthmid - Std.int(74 / 2) - (Control.carddepstate_num * 80) + (i * 80), Gfx.screenheightmid - Std.int(96 / 2)-10, Control.deck[Control.currentdeck].card[i], true);
						}else{
							Gfx.drawcard(Gfx.screenwidthmid - Std.int(74 / 2) - (Control.carddepstate_num * 80) + (i * 80), Gfx.screenheightmid - Std.int(96 / 2), Control.deck[Control.currentdeck].card[i]);
						}
					}
					Gfx.normalprint(Gfx.screenwidthmid+20, Gfx.screenheightmid - 65 - ((5 - Control.carddepstate_lerp) * 2), "-1", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
				case "deprecatecards3":
					var t:String = "THE PEOPLE DEMAND NOVELTY!";
				  Gfx.normalbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t, 3) / 2), 15, t, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
					
					t = "MESSAGES AND SETTINGS BECOME LESS EFFECTIVE";
					Gfx.smallbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t) / 2), Gfx.screenheight-45, t, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
					t = "AS YOUR CUSTOMERS GET USED TO THEM";
					Gfx.smallbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t) / 2),  Gfx.screenheight - 30, t, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
					
					for(i in 0 ... Control.deck[Control.currentdeck].numcards){
						Gfx.drawcard(Gfx.screenwidthmid - Std.int(74 / 2) - (Control.carddepstate_num * 80) + (i * 80) + 80, Gfx.screenheightmid - Std.int(96 / 2), Control.deck[Control.currentdeck].card[i]);
					}
				case "clearscreen":
					var t:String = "THE PEOPLE DEMAND NOVELTY!";
				  Gfx.normalbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t, 3) / 2), 15, t, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
					
					t = "MESSAGES AND SETTINGS BECOME LESS EFFECTIVE";
					Gfx.smallbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t) / 2), Gfx.screenheight-45, t, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
					t = "AS YOUR CUSTOMERS GET USED TO THEM";
					Gfx.smallbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t) / 2),  Gfx.screenheight - 30, t, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
					
					for(i in 0 ... Control.deck[Control.currentdeck].numcards){
						Gfx.drawcard(Gfx.screenwidthmid - Std.int(74 / 2) - Std.int((100-Control.carddepstate_lerp) * 8) - (Control.carddepstate_num * 80) + (i * 80) + 80, Gfx.screenheightmid - Std.int(96 / 2), Control.deck[Control.currentdeck].card[i]);
					}
				case "cleartext":
					var t:String = "THE PEOPLE DEMAND NOVELTY!";
				  Gfx.normalbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t, 3) / 2), 15- Std.int((10-Control.carddepstate_lerp) * 10), t, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
					
					t = "MESSAGES AND SETTINGS BECOME LESS EFFECTIVE";
					Gfx.smallbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t) / 2), Gfx.screenheight-45+ Std.int((10-Control.carddepstate_lerp) * 10), t, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
					t = "AS YOUR CUSTOMERS GET USED TO THEM";
					Gfx.smallbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t) / 2),  Gfx.screenheight - 30+ Std.int((10-Control.carddepstate_lerp) * 10), t, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
				case "finish":
			}
		}
	}
}