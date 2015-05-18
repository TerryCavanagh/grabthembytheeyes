package gamecontrol;

import com.terry.*;

class Shopphase {
	public static function updateshop():Void {
		if (Control.shopmessagedelay > 0) {
			Control.shopmessagedelay--;
		}
		
		if (Control.shopphasestate_lerp > 0) {
			Control.shopphasestate_lerp--;
		}else {
			if (Control.shopphasestate_delay > 0) {
				Control.shopphasestate_delay--;
			}else {
				if(Control.shopphasestate_nextstate!=""){
					Control.changeshopstate(Control.shopphasestate_nextstate);
				}
			}
		}
		
		if(!Control.shopphasestate_finished){
			switch(Control.shopphasestate) {
				case "gameloop_aiplay":
					//Very special case: choose a card to play
					Control.shopphasestate_lerp = 10;
					Control.shopphasestate_delay = 10;
					if (Control.jaybudget <= 0) Control.shopphasestate_delay = 0;
					
					//First: what can I afford?
					//Choose randomly from this.
					if (Control.deck[Control.deckindex.get("shopdeck")].numcards == 0) {
						Control.shopphasestate_nextstate = "end";
					}else {
						Control.shoppickcard = Control.ai();
						
						
						if (Control.turbomode) {
							Control.shopphasestate_nextstate = "gameloop_aiplay_waitforclick";
						}else{
							if (Control.jaybudget <= 0) {
								//Don't tease if we're out of money
								Control.shopphasestate_nextstate = "gameloop_aiplay_tease9";
							}else{
								Control.shopphasestate_nextstate = "gameloop_aiplay_tease1";
							}
						}
					}
					
					Control.shopphasestate_finished = true;
				case "gameloop_aiplay_waitforclick":
					Control.teasecard = Control.shoppickcard;
				case "gameloop_aiplay_tease1", "gameloop_aiplay_tease2",
						 "gameloop_aiplay_tease3", "gameloop_aiplay_tease4",
						 "gameloop_aiplay_tease5", "gameloop_aiplay_tease6",
						 "gameloop_aiplay_tease7", "gameloop_aiplay_tease8",
						 "gameloop_aiplay_tease9":
					//Tease the player with a randomly selected card
					if (Math.random() * 100 > 50) {
						Music.playef("card2");
					}else {
						Music.playef("card3");
					}
					Control.setshopnumcards();
					if (Control.fbbudget < Control.shopnumcards)  Control.shopnumcards = Control.fbbudget;
					Control.teasecard = Std.int((Std.parseInt(Help.Right(Control.shopphasestate, 1))-1) % Control.shopnumcards);
					Control.shopphasestate_delay = 3 + Std.int((Std.parseInt(Help.Right(Control.shopphasestate, 1)) /2));
					
					if (Control.shopphasestate == "gameloop_aiplay_tease9") {
						Control.teasecard = Control.shoppickcard;
						Control.shopphasestate_delay = 30;
						Control.shopphasestate_nextstate = "gameloop_cardpicked";
					}else {
						if (Control.fbbudget == 1) {
							Control.shopphasestate_nextstate = "gameloop_aiplay_tease9";
						}else {
							if (Std.parseInt(Help.Right(Control.shopphasestate, 1)) >= 4) {
								//Wrap it up
								if (Std.parseInt(Help.Right(Control.shopphasestate, 1)) - 1 == Control.shoppickcard) {									
									Control.teasecard = Control.shoppickcard;
									Control.shopphasestate_delay = 30;
									if (Control.jaybudget <= 0) Control.shopphasestate_delay = 5;
									Control.shopphasestate_nextstate = "gameloop_cardpicked";
								}else{
									Control.shopphasestate_nextstate = Help.stringplusplus(Control.shopphasestate);
								}
							}else{
								Control.shopphasestate_nextstate = Help.stringplusplus(Control.shopphasestate);
							}
						}
					}
					Control.shopphasestate_finished = true;
				case "start":
					Control.shopphasestate_lerp = 20;
					Control.shopphasestate_delay = 15;
					
					if (Control.turbomode) {						
						Control.jaybudget += 5;
						Control.fbbudget += 5;
						Control.shopphasestate_nextstate = "start_pickturn";
						Control.shopphasestate_finished = true;
					}else{
						Control.shopphasestate_nextstate = "start_givemoney1";
						Control.shopphasestate_finished = true;
					}
				case "end":
					Music.playef("sold");
					Control.removeshopmessage();
					Control.specialcards();
					Control.shopphasestate_lerp = 20;
					Control.shopphasestate_delay = 15;
					
					Control.shopphasestate_nextstate = "end_roundover";
					Control.shopphasestate_finished = true;
				case "end_roundover":
					Control.shopphasestate_lerp = 20;
					Control.shopphasestate_delay = 60;
					
			    Control.shopphasestate_nextstate = "end_roundover2";
					Control.shopphasestate_finished = true;
				case "end_roundover2":
					Control.shopphasestate_lerp = 20;
					Control.shopphasestate_delay = 30;
					
					Control.shopphasestate_nextstate = "end_roundover3";
					Control.shopphasestate_finished = true;
				case "end_roundover3":
					Control.shopphasestate_lerp = 20;
					Control.shopphasestate_delay = 40;
					
					Control.shopphasestate_nextstate = "end_roundover4";
					Control.shopphasestate_finished = true;
				case "end_roundover4":
					Control.shopphasestate_lerp = 20;
					Control.shopphasestate_delay = 40;
					
					if (Control.turbomode) {
						Gui.addbutton(Gfx.screenwidthmid - 50, 200, 100, 20, "Ok", "skiptoscores");	
					}else {
						Gui.addbutton(Gfx.screenwidthmid - 50, 200, 100, 20, "Ok", "game_editor");	
					}
					Control.shopphasestate_finished = true;
				case "start_givemoney1", 
				     "start_givemoney2", 
						 "start_givemoney3",
						 "start_givemoney4",
						 "start_givemoney5":
					Control.jaybudget += 1;
					Control.fbbudget += 1;
					Music.playef("coin");
					Control.shopphasestate_lerp = 5;
					Control.shopphasestate_delay = 10;
					
					Control.shopphasestate_finished = true;
					Control.shopphasestate_nextstate = Help.Left(Control.shopphasestate, Control.shopphasestate.length - 1) + Std.string(Std.parseInt(Help.Right(Control.shopphasestate, 1)) + 1);
				case "start_givemoney6":
					Control.shopphasestate_delay = 5;
					
					Control.shopphasestate_nextstate = "start_pickturn";
					Control.shopphasestate_finished = true;
				case "start_pickturn":
					Control.shopphasestate_lerp = 10;
					if (Control.turbomode) {
						Control.shopphasestate_delay = 0;
					}else{
						Control.shopphasestate_delay = 60;
					}
					
					if (Control.day % 2 == 0) {
						Control.changeshopmessage("FILTHY BURGER'S TURN");
						Control.shopphasestate_nextstate = "gameloop_aiplay";
					}else {
						Control.changeshopmessage("JAY'S TURN");
						Control.shopphasestate_nextstate = "gameloop_play";
					}
					
					Control.shopphasestate_finished = true;
				case "shoptutorial":
					Control.shopphasestate_lerp = 30;
					
					Control.shopphasestate_nextstate = "shoptutorial2";
					Control.shopphasestate_finished = true;
				case "shoptutorial2":
					Control.shopphasestate_lerp = 10;
					Control.shopphasestate_delay = 20;
					
					Control.shopphasestate_nextstate = "shoptutorial3";
					Control.shopphasestate_finished = true;
				case "shoptutorial3":
					Gui.addbutton(10, 150, 300, 20, "Sure, let's hear it.", "adviceyes");
					Gui.addbutton(10, 180, 300, 20, "Nah, I'll figure it out myself.", "adviceno");
					
					Control.shopphasestate_finished = true;
				case "shoptutorial_no":
					Control.shopphasestate_lerp = 20;
					Control.shopphasestate_delay = 0;
					
					Control.changeshopmessage("JAY'S TURN");
					Control.shopphasestate_nextstate = "gameloop_play";
					Control.shopphasestate_finished = true;
				case "shoptutorial_yes":
					Control.shopphasestate_lerp = 20;
					Control.shopphasestate_delay = 0;
					
					Control.shopphasestate_nextstate = "shoptutorial_yes1";
					Control.shopphasestate_finished = true;
					
					Gfx.sign = 0;
					Control.frame[0].clear();
					Control.frame[0].add("BURGERS", "white-red_stripe", "none", "none");
					Control.frame[0].start(0);
				case "shoptutorial_yes1":
					Control.shopphasestate_lerp = 20;
					Control.shopphasestate_delay = 0;
					
					Control.shopphasestate_finished = true;
				case "shoptutorial_yes2":
					Music.playef("click");
					Control.shopphasestate_lerp = 20;
					Control.shopphasestate_delay = 0;
					
					Control.shopphasestate_finished = true;
				case "shoptutorial_yes3":
					Music.playef("click");
					Control.shopphasestate_lerp = 20;
					Control.shopphasestate_delay = 0;
					
					Control.shopphasestate_nextstate = "shoptutorial_yes4";
					Control.shopphasestate_finished = true;
				case "shoptutorial_yes4":
					Control.shopphasestate_lerp = 20;
					Control.shopphasestate_delay = 0;
					
					Control.shopphasestate_finished = true;
				case "shoptutorial_yes5":
					Music.playef("click");
					Control.shopphasestate_lerp = 20;
					Control.shopphasestate_delay = 0;
					
					Control.shopphasestate_finished = true;
				case "shoptutorial_yes6":
					Music.playef("click");
					Control.shopphasestate_lerp = 20;
					Control.shopphasestate_delay = 0;
					
					Control.shopphasestate_finished = true;
				case "shoptutorial_yes7":
					Music.playef("click");
					Control.shopphasestate_lerp = 20;
					Control.shopphasestate_delay = 0;
					
					Control.changeshopmessage("JAY'S TURN");
					Control.shopphasestate_nextstate = "gameloop_play";
					Control.shopphasestate_finished = true;
				case "gameloop_play":
					if (!Control.shoptutorial) {
						Control.shoptutorial = true;
						Control.changeshopstate("shoptutorial");
						Control.shopphasestate_lerp = 30;
					}else {
						Control.mousedovercard = -1;
						Control.shopphasestate_lerp = 10;
						Control.shopphasestate_finished = true;
					}
				case "gameloop_cardpicked":
					if (Control.turn == 0) {
					  Control.jaybudget -= Control.shoppickcard + 1;
					}else if (Control.turn == 1) {
						Control.fbbudget -= Control.shoppickcard + 1;
					}
					
					Music.playef("card1");
					Control.shopphasestate_lerp = 10;
					Control.shopphasestate_delay = 10;
					Control.shopphasestate_nextstate = "gameloop_cardpicked2";
					Control.shopphasestate_finished = true;
				case "gameloop_cardpicked2":
					Control.changeotherdeck("shopdeck");
					if(Control.turn==0){
						Control.changedeck("daydeck");
					  Control.copybyindex(Control.shoppickcard);
						Control.changedeck("playerdeck");
					}else {
						Control.changedeck("enemydeck");
					}
					Control.copybyindex(Control.shoppickcard);
					
					Control.shopphasestate_lerp = 10;
					Control.shopphasestate_delay = 10;
					
					Control.preparecheckforendofshopphase = false;
					if (Control.deck[Control.deckindex.get("shopdeck")].numcards == 1) {
						Control.changedeck("shopdeck");
						Control.removebyindex(Control.shoppickcard);
						Control.shopphasestate_nextstate = "end";
						Control.turn = 2; Control.shopmessagedelay = 0; Control.shopmessage = "";
					}else{
						if (Control.shoppickcard == 4) {
							Control.shopphasestate_nextstate = "gameloop_fixcards2";
						}else{
							Control.shopphasestate_nextstate = "gameloop_fixcards1";
						}
					}
					Control.shopphasestate_finished = true;
				case "gameloop_fixcards1":
					Control.shopphasestate_lerp = 10;
					Control.shopphasestate_delay = 0;
					
					Control.checkforendofshopphase();
					
					//Check to see if the player is out of money
					if (Control.turn == 0) { if (Control.jaybudget <= 0) { Control.shopmessagedelay = 0; }} else if (Control.turn == 1) { if (Control.fbbudget <= 0) { Control.shopmessagedelay = 0;	}	} //Incredible kludge
					
					if(Control.shopphasestate_nextstate!="end"){
						Control.shopphasestate_nextstate = "gameloop_fixcards2";
					}
					Control.shopphasestate_finished = true;
				case "gameloop_fixcards2":
					//Actually remove the card from the shop
					Control.changedeck("shopdeck");
					Control.removebyindex(Control.shoppickcard);
					
					Control.checkforendofshopphase();
					
					Control.shopphasestate_lerp = 10;
					Control.shopphasestate_delay = 0;
					
					if(Control.shopphasestate_nextstate!="end"){
						Control.shopphasestate_nextstate = "gameloop_swapturn";
						//Check to see if the player is out of money
						if (Control.turn == 0) {
							if (Control.jaybudget <= 0) {
								if (Control.fbbudget <= 0) {
									Control.shopphasestate_nextstate = "end";
									Control.turn = 2; Control.shopmessagedelay = 0; Control.shopmessage = "";
								}else{
									Control.shopphasestate_nextstate = "gameloop_broke";
								}
								Control.shopmessagedelay = 0;
							}
						}else if (Control.turn == 1) {
							if (Control.fbbudget <= 0) {
								if (Control.jaybudget <= 0) {
									Control.shopphasestate_nextstate = "end";
									Control.turn = 2; Control.shopmessagedelay = 0;  Control.shopmessage = "";
								}else{
									Control.shopphasestate_nextstate = "gameloop_broke";
								}
								Control.shopmessagedelay = 0;
							}
						}
					}
					
					Control.shopphasestate_finished = true;
				case "gameloop_broke":
					Control.shopphasestate_lerp = 0;
					Control.shopphasestate_delay = 45;
					
					Control.preparecheckforendofshopphase = false;
					Control.checkforendofshopphase();
					
					Control.shopphasestate_nextstate = "gameloop_swapturn";
					Control.shopphasestate_finished = true;
				case "gameloop_swapturn":
					Control.shopphasestate_lerp = 10;
					Control.shopphasestate_delay = 0;
					
					if (Control.deck[Control.deckindex.get("shopdeck")].numcards == 0) {
						Control.shopphasestate_nextstate = "end";
						Control.turn = 2; Control.shopmessagedelay = 0; Control.shopmessage = "";
					}else {
						if (Control.turn == 0) {
							Control.shopphasestate_nextstate = "gameloop_play";
						}else {
							Control.shopphasestate_nextstate = "gameloop_aiplay";
						}
					}
					
					Control.shopphasestate_finished = true;
					
			}
		}
	}
	
	public static function drawupnext(xoff:Int, yoff:Int):Void {
		Control.changedeck("shopdeck");
		if (Control.deck[Control.currentdeck].numcards > 5) {
			var i:Int = Control.deck[Control.currentdeck].numcards - 1;
			while(i>=5){
				Gfx.drawminicard(3 + ((i - 5) * 3) + xoff, 4 + yoff, Control.deck[Control.currentdeck].card[i], true);
				i--;
			}
			Gfx.smallbigprint(3 + ((Control.deck[Control.currentdeck].numcards - 5) * 3) + 20 + xoff, 14 + yoff, "NEXT UP", Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
		}
	}
	
	public static function drawcardsforsale(xoff:Int, yoff:Int, allowmouseover:Bool = false, cardoffset:Int=0):Void {
		Control.setshopnumcards();
		for (i in 0...Control.shopnumcards) {
			if (Control.mouseovercard(i) && allowmouseover) {
				if (Control.mousedovercard != i) {
					Control.mousedovercard = i;
					Music.playef("card4");
				}
				Gfx.drawcard(3 + (76 * i) + xoff, 30 + yoff + cardoffset, Control.deck[Control.currentdeck].card[i]);
			}else{
				Gfx.drawcard(3 + (76 * i) + xoff, 30 + yoff, Control.deck[Control.currentdeck].card[i]);
			}
		}
	}
	
	public static function drawaicardsforsale(xoff:Int, yoff:Int, t:Int, cardoffset:Int=0):Void {
		Control.setshopnumcards();
		for (i in 0...Control.shopnumcards) {
			if (i == t) {
				Gfx.drawcard(3 + (76 * i) + xoff, 30 + yoff + cardoffset, Control.deck[Control.currentdeck].card[i]);
			}else{
				Gfx.drawcard(3 + (76 * i) + xoff, 30 + yoff, Control.deck[Control.currentdeck].card[i]);
			}
		}
	}
	
	public static function drawprices(xoff:Int, yoff:Int, highlight:Int = -1):Void {
		for (i in 0...5) {
			if (highlight == i && Help.slowsine % 16 >= 8) {
				Gfx.normalbigprint(3 + (76 * i) + 24 + xoff, 140 + yoff, "$" + Std.string(i + 1) + "0", 255, 255, 0, false);
			}else{
				Gfx.normalbigprint(3 + (76 * i) + 24 + xoff, 140 + yoff, "$" + Std.string(i + 1) + "0", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
			}
		}
	}
	
	public static function drawshopmessage(xoff:Int, yoff:Int, t:String):Void {
	  Gfx.normalbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t, 3) / 2) + xoff, 210 + yoff, t, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
	}
	
	public static function drawplayerminideck(xoff:Int, yoff:Int, showlast:Bool = true):Void {
		Control.changedeck("playerdeck");
		if (showlast) {
			if (Control.deck[Control.currentdeck].numcards <= Control.minipilesize) {
				for (i in 0...Control.deck[Control.currentdeck].numcards) {
					Gfx.drawminicard(3 + (i * Control.minipilegap) + xoff, 178 + yoff, Control.deck[Control.currentdeck].card[i]);
				}	
			}else {
				for (i in 0...Control.deck[Control.currentdeck].numcards) {
					if(i<Control.minipilesize){
						Gfx.drawminicard(3 + (i * Control.minipilegap) + xoff, 178 + yoff-Control.minipileyoff, Control.deck[Control.currentdeck].card[i]);
					}else {
						Gfx.drawminicard(3 + ((i-Control.minipilesize) * Control.minipilegap) + xoff, 178 + yoff+3, Control.deck[Control.currentdeck].card[i]);
					}
				}
			}
		}else {
			if (Control.deck[Control.currentdeck].numcards <= Control.minipilesize) {
				for (i in 0...Control.deck[Control.currentdeck].numcards - 1) {
					Gfx.drawminicard(3 + (i * Control.minipilegap) + xoff, 178 + yoff, Control.deck[Control.currentdeck].card[i]);
				}	
			}else{
				for (i in 0...Control.deck[Control.currentdeck].numcards - 1) {
					if(i<Control.minipilesize){
						Gfx.drawminicard(3 + (i * Control.minipilegap) + xoff, 178 + yoff-Control.minipileyoff, Control.deck[Control.currentdeck].card[i]);
					}else {
						Gfx.drawminicard(3 + ((i-Control.minipilesize) * Control.minipilegap) + xoff, 178 + yoff+3, Control.deck[Control.currentdeck].card[i]);
					}
				}	
			}
		}
	}
	
	public static function drawenemyminideck(xoff:Int, yoff:Int, showlast:Bool = true):Void {
		Control.changedeck("enemydeck");
		var i:Int = 0;
		if (showlast) {
			i = Control.deck[Control.currentdeck].numcards - 1;
		}else {
			i = Control.deck[Control.currentdeck].numcards - 2;
		}
		if (Control.deck[Control.currentdeck].numcards <= Control.minipilesize) {
			while (i >= 0) {
				Gfx.drawminicard(Gfx.screenwidth - 3 - (i * Control.minipilegap) - 18 + xoff, 178 + yoff, Control.deck[Control.currentdeck].card[i]);
				i--;
			}
		}else {
			while (i >= 0) {
				if (i < Control.minipilesize) {
					Gfx.drawminicard(Gfx.screenwidth - 3 - (i * Control.minipilegap) - 18 + xoff, 178 + yoff -15, Control.deck[Control.currentdeck].card[i]);
				}
				i--;
			}
			if (showlast) {
				i = Control.deck[Control.currentdeck].numcards - 1;
			}else {
				i = Control.deck[Control.currentdeck].numcards - 2;
			}
			while (i >= 0) {
				if (i >= Control.minipilesize) {
					Gfx.drawminicard(Gfx.screenwidth - 3 - ((i-Control.minipilesize) * Control.minipilegap) - 18 + xoff, 178 + yoff + 3, Control.deck[Control.currentdeck].card[i]);
				}
				i--;
			}
		}
	}
	
	public static function drawenemyminideckbottom(xoff:Int, yoff:Int, showlast:Bool = true):Void {
			Control.changedeck("enemydeck");
		var i:Int = 0;
		if (showlast) {
			i = Control.deck[Control.currentdeck].numcards - 1;
		}else {
			i = Control.deck[Control.currentdeck].numcards - 2;
		}
		if (Control.deck[Control.currentdeck].numcards <= Control.minipilesize) {
		}else {
			while (i >= 0) {
				if (i >= Control.minipilesize) {
					Gfx.drawminicard(Gfx.screenwidth - 3 - ((i-Control.minipilesize) * Control.minipilegap) - 18 + xoff, 178 + yoff + 3, Control.deck[Control.currentdeck].card[i]);
				}
				i--;
			}
		}
	}
	
	public static function drawplayerinfo(xoff:Int, yoff:Int, forceturn:Bool=false):Void {
	 if (Control.turn == 0 && !forceturn) {
			Gfx.fillrect(0 + xoff, Gfx.screenheight - 35 + yoff, Gfx.screenwidth, 40, Def.GRAY[1]);
			Gfx.fillrect(0 + xoff, Gfx.screenheight - 35 + yoff, 80, 40, Def.GRAY[2]);
			
			Gfx.normalprint(5 + xoff, Gfx.screenheight - 32 + yoff, Control.playercash(), 255, 255, 255, false);
			Gfx.smallbigprint(5 + xoff, Gfx.screenheight - 20 + yoff, "JAY'S FOOD STAND", Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
			
			Gfx.normalprint(Gfx.screenwidth-5 - Std.int(Text.len(Control.enemycash(),3))+xoff, Gfx.screenheight - 32+ yoff, Control.enemycash(), Def.GRAY[3], Def.GRAY[3], Def.GRAY[3], false);
			Gfx.smallbigprint(Gfx.screenwidth - 5 - Std.int(Text.len("FILTHY BURGER"))+xoff, Gfx.screenheight - 20 + yoff, "FILTHY BURGER", Def.GRAY[2], Def.GRAY[2], Def.GRAY[2], false);
		}else if (Control.turn == 1 && !forceturn) {
			Gfx.fillrect(0+xoff, Gfx.screenheight - 35 + yoff, Gfx.screenwidth, 40, Def.GRAY[1]);
			Gfx.fillrect(Gfx.screenwidth - 80+xoff, Gfx.screenheight - 35 + yoff, 80, 40, Def.GRAY[2]);
			
			Gfx.normalprint(5+xoff, Gfx.screenheight - 32 + yoff, Control.playercash(), Def.GRAY[3], Def.GRAY[3], Def.GRAY[3], false);
			Gfx.smallbigprint(5+xoff, Gfx.screenheight - 20 + yoff, "JAY'S FOOD STAND", Def.GRAY[2], Def.GRAY[2], Def.GRAY[2], false);				
			
			Gfx.normalprint(Gfx.screenwidth-5 - Std.int(Text.len(Control.enemycash(),3))+xoff, Gfx.screenheight - 32 + yoff, Control.enemycash(), 255, 255, 255, false);
			Gfx.smallbigprint(Gfx.screenwidth - 5 - Std.int(Text.len("FILTHY BURGER"))+xoff, Gfx.screenheight - 20 + yoff, "FILTHY BURGER", Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
		}else if (Control.turn == 2 || forceturn) {
			Gfx.fillrect(0+xoff, Gfx.screenheight - 35 + yoff, Gfx.screenwidth, 40, Def.GRAY[1]);
			
			Gfx.normalprint(5+xoff, Gfx.screenheight - 32 + yoff, Control.playercash(), Def.GRAY[3], Def.GRAY[3], Def.GRAY[3], false);
			Gfx.smallbigprint(5+xoff, Gfx.screenheight - 20 + yoff, "JAY'S FOOD STAND", Def.GRAY[2], Def.GRAY[2], Def.GRAY[2], false);				
			
			Gfx.normalprint(Gfx.screenwidth-5 - Std.int(Text.len(Control.enemycash(),3))+xoff, Gfx.screenheight - 32+ yoff, Control.enemycash(), Def.GRAY[3], Def.GRAY[3], Def.GRAY[3], false);
			Gfx.smallbigprint(Gfx.screenwidth - 5 - Std.int(Text.len("FILTHY BURGER"))+xoff, Gfx.screenheight - 20 + yoff, "FILTHY BURGER", Def.GRAY[2], Def.GRAY[2], Def.GRAY[2], false);
		}
	}
	
	public static function shop():Void {
		//Text.normalprint(Gfx.screenwidth - Std.int(Text.len("AL'S QUALITY SIGNS", 3))-5, 1, "AL'S QUALITY SIGNS", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
		switch(Control.shopphasestate) {
			case "start":
				drawplayerinfo(0, Control.shopphasestate_lerp*2);
			case "end":
				drawupnext(0, -(20-Control.shopphasestate_lerp)*10);
				drawcardsforsale(0, -(20-Control.shopphasestate_lerp)*10);
				drawprices(0, -(20-Control.shopphasestate_lerp)*10);
				
				drawplayerminideck(0, (20-Control.shopphasestate_lerp)*5);
				drawenemyminideck(0, (20-Control.shopphasestate_lerp)*5);
				
				drawplayerinfo(0, (20-Control.shopphasestate_lerp)*5);
			case "end_roundover":	
				var t:String = "CLOSED FOR TODAY - COME BACK TOMORROW!";
				Gfx.normalbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t, 3) / 2), Std.int((Gfx.screenheight/2) - (14) +Control.shopphasestate_lerp*10), t, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
			case "end_roundover2":	
				var t:String = "CLOSED FOR TODAY - COME BACK TOMORROW!";
				Gfx.normalbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t, 3) / 2) + ((20 - Control.shopphasestate_lerp) * 20), Std.int(Gfx.screenheight / 2) - (14), t, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
				var t:String = "YOUR PURCHASES FOR DAY " + Std.string(Control.day);
				Gfx.normalbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t, 3) / 2), 15-(Control.shopphasestate_lerp*2), t, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
		  case "end_roundover3":	
				var t:String = "YOUR PURCHASES FOR DAY " + Std.string(Control.day);
				Gfx.normalbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t, 3) / 2), 15, t, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
				
				Control.changedeck("daydeck");
				var tx = Std.int((Gfx.screenwidth / Control.deck[Control.currentdeck].numcards + 1));
				var ty:Int;
				for (i in 0...Control.deck[Control.currentdeck].numcards) {
					ty = Control.shopphasestate_lerp + i - Control.deck[Control.currentdeck].numcards;
					if (ty < 0) ty = 0;
					Gfx.drawcard(Std.int(tx / 2) + (tx * i) - Std.int(74 / 2), Gfx.screenheightmid - Std.int(96 / 2) - (ty * 10), Control.deck[Control.currentdeck].card[i]);
				}
		  case "end_roundover4":	
				var t:String = "YOUR PURCHASES FOR DAY " + Std.string(Control.day);
				Gfx.normalbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t, 3) / 2), 15, t, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
				
				Control.changedeck("daydeck");
				var tx = Std.int((Gfx.screenwidth / Control.deck[Control.currentdeck].numcards + 1));
				var ty:Int;
				for (i in 0...Control.deck[Control.currentdeck].numcards) {
					ty = 0;
					Gfx.drawcard(Std.int(tx / 2) + (tx * i) - Std.int(74 / 2), Gfx.screenheightmid - Std.int(96 / 2) - (ty * 10), Control.deck[Control.currentdeck].card[i]);
				}
		  case "start_givemoney1",
			     "start_givemoney2",
					 "start_givemoney3",
					 "start_givemoney4",
					 "start_givemoney5":
				drawplayerinfo(0, 0);
				if (Control.shopphasestate_delay % 10 >= 5) {
					Gfx.normalprint(5, Gfx.screenheight - 32 - 20 - ((5 - Control.shopphasestate_lerp) * 2), "+$10", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
					Gfx.normalprint(Gfx.screenwidth - 5 - Std.int(Text.len("+$10", 3)), Gfx.screenheight - 32 -20 - ((5 - Control.shopphasestate_lerp) * 2), "+$10", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
				}else{
					Gfx.normalprint(5, Gfx.screenheight - 32 - 20 - ((5 - Control.shopphasestate_lerp) * 2), "+$10", 255, 255, 255, false);
					Gfx.normalprint(Gfx.screenwidth - 5 - Std.int(Text.len("+$10", 3)), Gfx.screenheight - 32 -20 - ((5 - Control.shopphasestate_lerp) * 2), "+$10", 255, 255, 255, false);
				}
			case "start_givemoney6":
				drawplayerinfo(0, 0);
			case "start_pickturn":
				if (Control.shopphasestate_delay % 20 >= 10 || Control.shopphasestate_delay < 60) {
					Control.turn = ((Control.day+1) % 2);
				}else {
					Control.turn = 2;
				}
				
				drawplayerinfo(0, 0);
				
				if (Control.shopphasestate_delay < 60) {
				  drawprices(-Std.int((Control.shopphasestate_delay) * 10), 0);
					drawupnext(0, -Std.int((Control.shopphasestate_delay) * 5));
					drawcardsforsale(0, -Std.int((Control.shopphasestate_delay) * 5));
					
					drawplayerminideck(-((Control.shopphasestate_delay) * 5), 0);
					drawenemyminideck((Control.shopphasestate_delay) * 5, 0);
				}
			case "shoptutorial":
				drawupnext(0, 0);
				drawcardsforsale(0, 0);
				drawprices(0, 0);
				
				drawplayerminideck(0, 0);
				drawenemyminideck(0, 0);
				
				drawplayerinfo(0, 0);
				
				//Draw the tutorial stuff over everything
				Gfx.drawimage("tint");
				Gfx.drawimage("tint");
				
	      Gfx.bigdrawsprite(280+(Control.shopphasestate_lerp*5), -32, 103, 0, 0, 0, 2);
			case "shoptutorial2":
				drawupnext(0, 0);
				drawcardsforsale(0, 0);
				drawprices(0, 0);
				
				drawplayerminideck(0, 0);
				drawenemyminideck(0, 0);
				
				drawplayerinfo(0, 0);
				
				//Draw the tutorial stuff over everything
				Gfx.drawimage("tint");
				Gfx.drawimage("tint");
				
				Gfx.fillrect(0, 120 +(Control.shopphasestate_lerp*14), Gfx.screenwidth, 15, 64);
				Gfx.smallbigprint(14, 120 +(Control.shopphasestate_lerp*14), "Hey, new guy. Do you want some quick advice?", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
				
	      Gfx.bigdrawsprite(280, -32, 103, 0, 0, 0, 2);
			case "shoptutorial3":
				drawupnext(0, 0);
				drawcardsforsale(0, 0);
				drawprices(0, 0);
				
				drawplayerminideck(0, 0);
				drawenemyminideck(0, 0);
				
				drawplayerinfo(0, 0);
				
				//Draw the tutorial stuff over everything
				Gfx.drawimage("tint");
				Gfx.drawimage("tint");
				
				Gfx.fillrect(0, 120, Gfx.screenwidth, 16, 64);
				Gfx.smallbigprint(14, 120, "Hey, new guy. Do you want some quick advice?", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
				
	      Gfx.bigdrawsprite(280, -32, 103, 0, 0, 0, 2);
			case "shoptutorial_no", "shoptutorial_yes":
				drawupnext(0, 0);
				drawcardsforsale(0, 0);
				drawprices(0, 0);
				
				drawplayerminideck(0, 0);
				drawenemyminideck(0, 0);
				
				drawplayerinfo(0, 0);
				
				//Draw the tutorial stuff over everything
				Gfx.drawimage("tint");
				Gfx.drawimage("tint");
				
				Gfx.fillrect(0, 120 -((20-Control.shopphasestate_lerp)*14), Gfx.screenwidth, 16, 64);
				Gfx.smallbigprint(14, 120 -((20-Control.shopphasestate_lerp)*14), "Hey, new guy. Do you want some quick advice?", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
				
	      Gfx.bigdrawsprite(280+((20-Control.shopphasestate_lerp)*5), -32, 103, 0, 0, 0, 2);
			case "shoptutorial_yes1":
				drawupnext(0, 0);
				drawcardsforsale(0, 0);
				drawprices(0, 0);
				
				drawplayerminideck(0, 0);
				drawenemyminideck(0, 0);
				
				drawplayerinfo(0, 0);
				
				//Draw the tutorial stuff over everything
				Gfx.drawimage("tint");
				Gfx.drawimage("tint");
				
				Gfx.drawimage("help1", 0, Gfx.screenheightmid - 64-20-(Control.shopphasestate_lerp*14), false);
				Gfx.drawsign(0, 213, Gfx.screenheightmid - 64 + 40-20-(Control.shopphasestate_lerp*14), 3);
				
				Gfx.fillrect(0, Gfx.screenheightmid - 85-30-(Control.shopphasestate_lerp*14), Gfx.screenwidth, 16, 64);
				Gfx.smallbigprint(0, Gfx.screenheightmid - 85-30-(Control.shopphasestate_lerp*14), "Make the best sign you can by combining message and colour punch cards.", Def.GRAY[5]);
				
				Gfx.fillrect(0, Gfx.screenheight - 20, Gfx.screenwidth, 16, 64);
				Gfx.smallbigprint(0, Gfx.screenheight - 20, "CLICK TO CONTINUE", Def.GRAY[5]);
			case "shoptutorial_yes2":
				drawupnext(0, 0);
				drawcardsforsale(0, 0);
				drawprices(0, 0);
				
				drawplayerminideck(0, 0);
				drawenemyminideck(0, 0);
				
				drawplayerinfo(0, 0);
				
				//Draw the tutorial stuff over everything
				Gfx.drawimage("tint");
				Gfx.drawimage("tint");
				
				if (Control.shopphasestate_lerp > 0) {
					if (Help.slowsine % 8 >= 4) {
						Gfx.drawimage("help1", 0, Gfx.screenheightmid - 64-20, false);
					}else {
						Gfx.drawimage("help2", 0, Gfx.screenheightmid - 64-20, false);
					}
				}else {
					Gfx.drawimage("help2", 0, Gfx.screenheightmid - 64-20, false);
				}
				
				Gfx.drawsign(0, 213, Gfx.screenheightmid - 64 + 40-20, 3);
				
				Gfx.fillrect(0, Gfx.screenheightmid - 85-30, Gfx.screenwidth, 16, 64);
				Gfx.smallbigprint(0, Gfx.screenheightmid - 85-30, "Make the best sign you can by combining message and colour punch cards.", Def.GRAY[5]);
				
				Gfx.fillrect(0, Gfx.screenheightmid + 70-15+(Control.shopphasestate_lerp*7), Gfx.screenwidth, 16, 64);
				Gfx.smallbigprint(0, Gfx.screenheightmid + 70-15+(Control.shopphasestate_lerp*7), "The number at the top is how many customers you get for using it.", Def.GRAY[5]);
				
				Gfx.fillrect(0, Gfx.screenheightmid + 90-15+(Control.shopphasestate_lerp*7), Gfx.screenwidth, 16, 64);
				Gfx.smallbigprint(0, Gfx.screenheightmid + 90-15+(Control.shopphasestate_lerp*7), "Your total customers for each day is all the cards in each frame added together.", Def.GRAY[5]);
				
				Gfx.fillrect(0, Gfx.screenheight - 20, Gfx.screenwidth, 16, 64);
				Gfx.smallbigprint(0, Gfx.screenheight - 20, "CLICK TO CONTINUE", Def.GRAY[5]);
			case "shoptutorial_yes3":
				drawupnext(0, 0);
				drawcardsforsale(0, 0);
				drawprices(0, 0);
				
				drawplayerminideck(0, 0);
				drawenemyminideck(0, 0);
				
				drawplayerinfo(0, 0);
				
				//Draw the tutorial stuff over everything
				Gfx.drawimage("tint");
				Gfx.drawimage("tint");
				
				Gfx.drawimage("help2", 0, Gfx.screenheightmid - 64-20-((20-Control.shopphasestate_lerp)*14), false);
				Gfx.drawsign(0, 213, Gfx.screenheightmid - 64 + 40-20-((20-Control.shopphasestate_lerp)*14), 3);
				
				Gfx.fillrect(0, Gfx.screenheightmid - 85-30-((20-Control.shopphasestate_lerp)*14), Gfx.screenwidth, 16, 64);
				Gfx.smallbigprint(0, Gfx.screenheightmid - 85-30-((20-Control.shopphasestate_lerp)*14), "Make the best sign you can by combining message and colour punch cards.", Def.GRAY[5]);
				
				Gfx.fillrect(0, Gfx.screenheightmid + 70-15+((20-Control.shopphasestate_lerp)*14), Gfx.screenwidth, 16, 64);
				Gfx.smallbigprint(0, Gfx.screenheightmid + 70-15+((20-Control.shopphasestate_lerp)*14), "The number at the top is how many customers you get for using it.", Def.GRAY[5]);
				
				Gfx.fillrect(0, Gfx.screenheightmid + 90-15+((20-Control.shopphasestate_lerp)*14), Gfx.screenwidth, 16, 64);
				Gfx.smallbigprint(0, Gfx.screenheightmid + 90-15+((20-Control.shopphasestate_lerp)*14), "Your total customers for each day is all the cards in each frame added together.", Def.GRAY[5]);
				
				Gfx.fillrect(0, Gfx.screenheight - 20, Gfx.screenwidth, 16, 64);
				Gfx.smallbigprint(0, Gfx.screenheight - 20, "CLICK TO CONTINUE", Def.GRAY[5]);
			case "shoptutorial_yes4":
				drawupnext(0, 0);
				drawcardsforsale(0, 0);
				drawprices(0, 0);
				
				drawplayerminideck(0, 0);
				drawenemyminideck(0, 0);
				
				drawplayerinfo(0, 0);
				
				//Draw the tutorial stuff over everything
				Gfx.drawimage("tint");
				Gfx.drawimage("tint");
				
				Gfx.fillrect(0, Gfx.screenheight - 20, Gfx.screenwidth, 16, 64);
				Gfx.smallbigprint(0, Gfx.screenheight - 20, "CLICK TO CONTINUE", Def.GRAY[5]);
				
				Gfx.fillrect(0, 30-(Control.shopphasestate_lerp*14), Gfx.screenwidth, 32, 64);
				Gfx.smallbigprint(0, 30-(Control.shopphasestate_lerp*14), "Right now, you're just trying to get the best punch cards", Def.GRAY[5]);
				Gfx.smallbigprint(0, 30+16-(Control.shopphasestate_lerp*14), "before Filthy Burger does.", Def.GRAY[5]);
				
				Gfx.bigdrawsprite(280 + (Control.shopphasestate_lerp * 5), -32, 103, 0, 0, 0, 2);
			case "shoptutorial_yes5":
				drawupnext(0, 0);
				drawcardsforsale(0, 0);
				drawprices(0, 0);
				
				drawplayerminideck(0, 0);
				drawenemyminideck(0, 0);
				
				drawplayerinfo(0, 0);
				
				//Draw the tutorial stuff over everything
				Gfx.drawimage("tint");
				Gfx.drawimage("tint");
				
				Gfx.fillrect(0, Gfx.screenheight - 20, Gfx.screenwidth, 16, 64);
				Gfx.smallbigprint(0, Gfx.screenheight - 20, "CLICK TO CONTINUE", Def.GRAY[5]);
				
				Gfx.fillrect(0, 30, Gfx.screenwidth, 32, 64);
				Gfx.smallbigprint(0, 30, "Right now, you're just trying to get the best punch cards", Def.GRAY[5]);
				Gfx.smallbigprint(0, 30+16, "before Filthy Burger does.", Def.GRAY[5]);
				
				Gfx.fillrect(0, 80-(Control.shopphasestate_lerp*14), Gfx.screenwidth, 16, 64);
				Gfx.smallbigprint(0, 80-(Control.shopphasestate_lerp*14), "You'll take turns choosing cards.", Def.GRAY[5]);
				
				Gfx.bigdrawsprite(280, -32, 103, 0, 0, 0, 2);
			case "shoptutorial_yes6":
				drawupnext(0, 0);
				drawcardsforsale(0, 0);
				drawprices(0, 0);
				
				drawplayerminideck(0, 0);
				drawenemyminideck(0, 0);
				
				drawplayerinfo(0, 0);
				
				//Draw the tutorial stuff over everything
				Gfx.drawimage("tint");
				Gfx.drawimage("tint");
				
				Gfx.fillrect(0, Gfx.screenheight - 20, Gfx.screenwidth, 16, 64);
				Gfx.smallbigprint(0, Gfx.screenheight - 20, "CLICK TO CONTINUE", Def.GRAY[5]);
				
				Gfx.fillrect(0, 30, Gfx.screenwidth, 32, 64);
				Gfx.smallbigprint(0, 30, "Right now, you're just trying to get the best punch cards", Def.GRAY[5]);
				Gfx.smallbigprint(0, 30+16, "before Filthy Burger does.", Def.GRAY[5]);
				
				Gfx.fillrect(0, 80, Gfx.screenwidth, 16, 64);
				Gfx.smallbigprint(0, 80, "You'll take turns choosing cards.", Def.GRAY[5]);
				
				Gfx.fillrect(0, 120 -(Control.shopphasestate_lerp*14), Gfx.screenwidth, 32, 64);
				Gfx.smallbigprint(14, 120 -(Control.shopphasestate_lerp * 14), "If I were you, I'd try to grab one of those", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
				Gfx.smallbigprint(40+14, 120 -(Control.shopphasestate_lerp*14)+16, "colour cards before someone else does...", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
				Gfx.bigdrawsprite(280, -32, 103, 0, 0, 0, 2);
			case "shoptutorial_yes7":
				drawupnext(0, 0);
				drawcardsforsale(0, 0);
				drawprices(0, 0);
				
				drawplayerminideck(0, 0);
				drawenemyminideck(0, 0);
				
				drawplayerinfo(0, 0);
				
				//Draw the tutorial stuff over everything
				Gfx.drawimage("tint");
				Gfx.drawimage("tint");
				
				Gfx.fillrect(0, Gfx.screenheight - 20+((20-Control.shopphasestate_lerp)*14), Gfx.screenwidth, 16, 64);
				Gfx.smallbigprint(0, Gfx.screenheight - 20+((20-Control.shopphasestate_lerp)*14), "CLICK TO CONTINUE", Def.GRAY[5]);
				
				Gfx.fillrect(0, 30-((20-Control.shopphasestate_lerp)*14), Gfx.screenwidth, 32, 64);
				Gfx.smallbigprint(0, 30-((20-Control.shopphasestate_lerp)*14), "Right now, you're just trying to get the best punch cards", Def.GRAY[5]);
				Gfx.smallbigprint(0, 30+16-((20-Control.shopphasestate_lerp)*14), "before Filthy Burger does.", Def.GRAY[5]);
				
				Gfx.fillrect(0, 80-((20-Control.shopphasestate_lerp)*14), Gfx.screenwidth, 16, 64);
				Gfx.smallbigprint(0, 80-((20-Control.shopphasestate_lerp)*14), "You'll take turns choosing cards.", Def.GRAY[5]);
				
				Gfx.fillrect(0, 120 -((20-Control.shopphasestate_lerp)*14), Gfx.screenwidth, 32, 64);
				Gfx.smallbigprint(14, 120 -((20-Control.shopphasestate_lerp) * 14), "If I were you, I'd try to grab one of those", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
				Gfx.smallbigprint(40+14, 120 -((20-Control.shopphasestate_lerp)*14)+16, "colour cards before someone else does...", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
				Gfx.bigdrawsprite(280+((20-Control.shopphasestate_lerp)*5), -32, 103, 0, 0, 0, 2);
			case "gameloop_play":
				drawupnext(0, 0);
				drawcardsforsale(0, 0, true, -10);
				drawprices(0, 0);
				
				drawplayerminideck(0, 0);
				drawenemyminideck(0, 0);
				
				drawplayerinfo(0, 0);
			case "gameloop_aiplay_waitforclick":
				drawupnext(0, 0);
				drawaicardsforsale(0, 0, Control.teasecard, -Std.int((Help.slowsine % 16)));
				
				drawprices(0, 0);
				
				drawplayerminideck(0, 0);
				drawenemyminideck(0, 0);
				
				drawplayerinfo(0, 0);
			case "gameloop_aiplay_tease1", "gameloop_aiplay_tease2",
					 "gameloop_aiplay_tease3", "gameloop_aiplay_tease4",
					 "gameloop_aiplay_tease5", "gameloop_aiplay_tease6",
					 "gameloop_aiplay_tease7", "gameloop_aiplay_tease8", "gameloop_aiplay_tease9":
				drawupnext(0, 0);
				drawaicardsforsale(0, 0, Control.teasecard, -10);
				drawprices(0, 0);
				
				drawplayerminideck(0, 0);
				drawenemyminideck(0, 0);
				
				drawplayerinfo(0, 0);
			case "gameloop_aiplay":
				drawupnext(0, 0);
				drawaicardsforsale(0, 0, -1);
				drawprices(0, 0);
				
				drawplayerminideck(0, 0);
				drawenemyminideck(0, 0);
				
				drawplayerinfo(0, 0);
			case "gameloop_cardpicked":
				drawupnext(0, 0);
				
				Control.setshopnumcards();
				for (i in 0...Control.shopnumcards) {
					if (Control.shoppickcard == i) {
						Gfx.drawcard(3 + (76 * i), 30 - ((10-Control.shopphasestate_lerp)*15), Control.deck[Control.currentdeck].card[i]);
					}else{
						Gfx.drawcard(3 + (76 * i), 30, Control.deck[Control.currentdeck].card[i]);
					}
				}
				drawprices(0, 0, Control.shoppickcard);
				
				drawplayerminideck(0, 0);
				drawenemyminideck(0, 0);
				
				if(Control.turn==0)	Gfx.normalprint(5+1, 1+Gfx.screenheight - 32 - 20 - ((5 - Control.shopphasestate_lerp) * 2), "-$"+Std.string(Control.shoppickcard+1)+"0", 0, 0, 0, false);
				if (Control.turn == 1) Gfx.normalprint(1+Gfx.screenwidth - 5 - Std.int(Text.len("-$" + Std.string(Control.shoppickcard + 1) + "0", 3)), 1+Gfx.screenheight - 32 -20 - ((5 - Control.shopphasestate_lerp) * 2), "-$" + Std.string(Control.shoppickcard + 1) + "0", 0, 0, 0, false);
					
				if (Control.shopphasestate_delay % 10 >= 5) {
					if(Control.turn==0)	Gfx.normalprint(5, Gfx.screenheight - 32 - 20 - ((5 - Control.shopphasestate_lerp) * 2), "-$"+Std.string(Control.shoppickcard+1)+"0", Def.GRAY[5], Def.GRAY[5], 0, false);
					if(Control.turn==1) Gfx.normalprint(Gfx.screenwidth - 5 - Std.int(Text.len("-$"+Std.string(Control.shoppickcard+1)+"0", 3)), Gfx.screenheight - 32 -20 - ((5 - Control.shopphasestate_lerp) * 2), "-$"+Std.string(Control.shoppickcard+1)+"0", Def.GRAY[5], Def.GRAY[5], 0, false);
				}else{
					if(Control.turn==0) Gfx.normalprint(5, Gfx.screenheight - 32 - 20 - ((5 - Control.shopphasestate_lerp) * 2), "-$"+Std.string(Control.shoppickcard+1)+"0", 255, 255, 0, false);
					if(Control.turn==1) Gfx.normalprint(Gfx.screenwidth - 5 - Std.int(Text.len("-$"+Std.string(Control.shoppickcard+1)+"0", 3)), Gfx.screenheight - 32 -20 - ((5 - Control.shopphasestate_lerp) * 2), "-$"+Std.string(Control.shoppickcard+1)+"0", 255, 255, 0, false);
				}
				drawplayerinfo(0, 0);
			case "gameloop_cardpicked2":
				drawupnext(0, 0);
				
				if(Control.turn==0){
					drawplayerminideck(0, 0, false);
				}else if (Control.turn == 1) {
					drawplayerminideck(0, 0);
					drawenemyminideck(0, 0, false);
				}else {
					drawplayerminideck(0, 0);
				}
				
				Control.setshopnumcards();
				for (i in 0...Control.shopnumcards) {
					if (Control.shoppickcard == i) {
						if(Control.turn==0){
							Control.changedeck("playerdeck");
							var j:Int = Control.deck[Control.currentdeck].numcards - 1;
							if (Control.deck[Control.currentdeck].numcards <= Control.minipilesize) {
								Gfx.drawminicard(3 + (j * Control.minipilegap), 178 + Control.shopphasestate_lerp * 4, Control.deck[Control.currentdeck].card[j]);
							}else{
								if(j < Control.minipilesize){
									Gfx.drawminicard(3 + (j * Control.minipilegap), 178 -Control.minipileyoff+ Control.shopphasestate_lerp * 4, Control.deck[Control.currentdeck].card[j]);
								}else {
									Gfx.drawminicard(3 + ((j-Control.minipilesize) * Control.minipilegap), 178 +3+ Control.shopphasestate_lerp * 4, Control.deck[Control.currentdeck].card[j]);
								}
							}
						}else {
							Control.changedeck("enemydeck");
							var j:Int = Control.deck[Control.currentdeck].numcards - 1;
							
							if (Control.deck[Control.currentdeck].numcards <= Control.minipilesize) {
								Gfx.drawminicard(Gfx.screenwidth - 3 - (j * Control.minipilegap) - 18, 178 + Control.shopphasestate_lerp * 4, Control.deck[Control.currentdeck].card[j]);
							}else{
								if (j < Control.minipilesize) {
									Gfx.drawminicard(Gfx.screenwidth - 3 - (j * Control.minipilegap) - 18, 178 - Control.minipileyoff+ Control.shopphasestate_lerp * 4, Control.deck[Control.currentdeck].card[j]);
								}else {
									Gfx.drawminicard(Gfx.screenwidth - 3 - ((j-Control.minipilesize) * Control.minipilegap) - 18, 178 +3+ Control.shopphasestate_lerp * 4, Control.deck[Control.currentdeck].card[j]);
								}
							}
						}
					}else{
						Control.changedeck("shopdeck");
						Gfx.drawcard(3 + (76 * i), 30, Control.deck[Control.currentdeck].card[i]);
					}
				}
				drawprices(0, 0);
				
				if(Control.turn==0){
					drawenemyminideck(0, 0);
				}else if (Control.turn == 1) {
					Control.changedeck("enemydeck");
					if (Control.deck[Control.currentdeck].numcards <= Control.minipilesize) {
						drawenemyminideck(0, 0, false);
					}
					drawenemyminideckbottom(0, 0, false);
				}else {
					drawenemyminideck(0, 0);
				}
				
				drawplayerinfo(0, 0);
			case "gameloop_fixcards1":
				drawupnext(0, 0);
				
				Control.setshopnumcards();
				for (i in 0...Control.shopnumcards) {
					if (Control.shoppickcard == i) {
					}else if (Control.shoppickcard < i) {
						Control.changedeck("shopdeck");
						Gfx.drawcard(Std.int(3 + (76 * i) - (76 * ((10 - Control.shopphasestate_lerp) / 10))), 30, Control.deck[Control.currentdeck].card[i]);
					}else{
						Gfx.drawcard(3 + (76 * i), 30, Control.deck[Control.currentdeck].card[i]);
					}
				}
				drawprices(0, 0);
				
				drawplayerminideck(0, 0);
				drawenemyminideck(0, 0);
				
				drawplayerinfo(0, 0);
			case "gameloop_fixcards2":
				drawupnext(0, 0);
				
				Control.setshopnumcards();
				for (i in 0...Control.shopnumcards) {
					if (i == 4) {
						Gfx.drawcard(3 + (76 * i) + (Control.shopphasestate_lerp * 10), 30, Control.deck[Control.currentdeck].card[i]);
						Gfx.drawminicard(3 - ((10-Control.shopphasestate_lerp) * 2), 4, Control.deck[Control.currentdeck].card[i], true);
					}else{
						Gfx.drawcard(3 + (76 * i), 30, Control.deck[Control.currentdeck].card[i]);
					}
				}
				drawprices(0, 0);
				
				drawplayerminideck(0, 0);
				drawenemyminideck(0, 0);
				
				drawplayerinfo(0, 0);
			case "gameloop_swapturn":
				drawupnext(0, 0);
				drawcardsforsale(0, 0);
				drawprices(0, 0);
				
				drawplayerminideck(0, 0);
				drawenemyminideck(0, 0);
				
				drawplayerinfo(0, 0);
			case "gameloop_broke":
				drawupnext(0, 0);
				drawcardsforsale(0, 0);
				drawprices(0, 0);
				
				drawplayerminideck(0, 0);
				drawenemyminideck(0, 0);
				
				drawplayerinfo(0, 0, true);
			case "everything":
				drawupnext(0, 0);
				drawprices(0, 0);
				
				drawplayerminideck(0, 0);
				drawenemyminideck(0, 0);
				
				drawplayerinfo(0, 0);
		}
		
		if (Control.shopphasestate == "gameloop_broke") {
			Control.shopmessagedelay = 180;
			if (Help.slowsine % 16 >= 8) {
				if (Control.jaybudget <= 0) {
					drawshopmessage(0, 0, "JAY IS OUT OF CASH");
				}else if (Control.fbbudget <= 0) {
					drawshopmessage(0, 0, "FILTHY BURGER OUT OF CASH");
				}
			}
		}else{
			if (Control.shopmessagedelay > 160) {
				drawshopmessage(0, ((Control.shopmessagedelay-160)*3), Control.shopmessage);	
			}else if (Control.shopmessagedelay >= 20) {	
				drawshopmessage(0, 0, Control.shopmessage);
			}else if (Control.shopmessagedelay < 20 && Control.shopmessagedelay > 0) {
				drawshopmessage(0, ((20-Control.shopmessagedelay)*3), Control.shopmessage);
			}
		}
	}
}