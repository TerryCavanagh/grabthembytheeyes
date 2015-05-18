package gamecontrol;

import com.terry.*;

class Edphase {
	//Gui.addbutton(Gfx.screenwidthmid - 100, 140, 200, 20, "Next", "game_playout");
	public static function init():Void {
	  card_back_red.push(34);
		card_back_green.push(34);
		card_back_blue.push(34);
		card_front_red.push(143);
		card_front_green.push(143);
		card_front_blue.push(143);
		card_deck_width.push(0);
		card_name.push("MESSAGES");
		card_deck.push("message_playerdeck");
		bordercolour1.push("white");
		bordercolour2.push("red");
		colourcolour1.push("white");
		colourcolour2.push("red");
		
	  card_back_red.push(65);
		card_back_green.push(3);
		card_back_blue.push(38);
		card_front_red.push(255);
		card_front_green.push(31);
		card_front_blue.push(112);
		card_deck_width.push(0);
		card_name.push("COLOURS");
		card_deck.push("colour_playerdeck");
		bordercolour1.push("white");
		bordercolour2.push("red");
		colourcolour1.push("white");
		colourcolour2.push("red");
		
	  card_back_red.push(8);
		card_back_green.push(65);
		card_back_blue.push(3);
		card_front_red.push(31);
		card_front_green.push(255);
		card_front_blue.push(58);
		card_deck_width.push(0);
		card_name.push("BORDERS");
		card_deck.push("border_playerdeck");
		bordercolour1.push("white");
		bordercolour2.push("red");
		colourcolour1.push("white");
		colourcolour2.push("red");
		
	  card_back_red.push(20);
		card_back_green.push(27);
		card_back_blue.push(83);
		card_front_red.push(71);
		card_front_green.push(48);
		card_front_blue.push(255);
		card_deck_width.push(0);
		card_name.push("EFFECTS");
		card_deck.push("effect_playerdeck");
		bordercolour1.push("white");
		bordercolour2.push("red");
		colourcolour1.push("white");
		colourcolour2.push("red");
		
		for(i in 0...10){
			messagecard.push(new Card());
			colourcard.push(new Card());
			bordercard.push(new Card());
			effectcard.push(new Card());
		}
		
		tabsize = Std.int(Gfx.screenwidth / 5);
		changeframetext = true;
	}
	
	public static function setdeckwidths():Void {
		var maxvalue:Int = 0;
		var currentvalue:Int = 0;
		
		for (i in 0...4) {
			maxvalue = 0;
			currentvalue = 0;
			if (i == 0) {
				maxvalue = Std.int(Text.len("WRITE YOUR OWN"));
			}
			
			Control.changedeck(card_deck[i]);
			for (j in 0...Control.deck[Control.currentdeck].numcards) {
			  currentvalue = Std.int(Text.len(Control.deck[Control.currentdeck].card[j].name));
				if (currentvalue > maxvalue) {
					maxvalue = currentvalue;
				}
			}
			
			card_deck_width[i] = maxvalue + 32;
			if (card_deck_width[i] < tabsize) card_deck_width[i] = tabsize;
			if(i>0) card_deck_width[i] = tabsize;
			
		}
	}
	
	public static function initeditorphase():Void {
		if (Control.day == 1) {
		  Control.adddefaultcards();
		}
		
		currentframe = 0;
		currenttab = -1;
		numcustommessages = 0;
		
		numplayerframes = 2 + Control.extraframesin("playerdeck");
		numenemyframes = 2 + Control.extraframesin("enemydeck");
		Gfx.numsigns = numplayerframes;
		
		//For testing:
		/*
		Control.cleardeck("playerdeck");
		
		Control.cleardeck("workingdeck");
		Control.changedeck("workingdeck"); Control.changeotherdeck("masterdeck");
		Control.copy_all("message"); Control.shuffledeck();
		Control.changedeck("playerdeck"); Control.changeotherdeck("workingdeck");
		Control.copytop(4);
		
		Control.cleardeck("workingdeck");
		Control.changedeck("workingdeck"); Control.changeotherdeck("masterdeck");
		Control.copy_all("colour");	Control.shuffledeck();
		Control.changedeck("playerdeck"); Control.changeotherdeck("workingdeck");
		Control.copytop(4);
		
		Control.cleardeck("workingdeck");
		Control.changedeck("workingdeck"); Control.changeotherdeck("masterdeck");
		Control.copy_all("border");	Control.shuffledeck();
		Control.changedeck("playerdeck"); Control.changeotherdeck("workingdeck");
		Control.copytop(3);
		
		Control.cleardeck("workingdeck");
		Control.changedeck("workingdeck"); Control.changeotherdeck("masterdeck");
		Control.copy_all("effect");	Control.shuffledeck();
		Control.changedeck("playerdeck"); Control.changeotherdeck("workingdeck");
		Control.copytop(8);
		
		Control.shuffledeck();
		*/
		
		//Ok: Our player deck has some random shit in it. Let's sort it out into working decks
		
		Control.cleardeck("message_playerdeck");
		Control.changedeck("message_playerdeck"); Control.changeotherdeck("playerdeck");
		Control.copy_all("message");	Control.sortbyscore();
		
		Control.cleardeck("colour_playerdeck");
		Control.changedeck("colour_playerdeck"); Control.changeotherdeck("playerdeck");
		Control.copy_all("colour");	Control.sortbyscore();
		
		Control.cleardeck("border_playerdeck");
		Control.changedeck("border_playerdeck"); Control.changeotherdeck("playerdeck");
		Control.copy_all("border");	Control.sortbyscore();
		
		Control.cleardeck("effect_playerdeck");
		Control.changedeck("effect_playerdeck"); Control.changeotherdeck("playerdeck");
		Control.copy_all("effect");	Control.sortbyscore();
		
		setdeckwidths();
		
		Control.changeeditorstate("start");
	}
	
	public static function updategameeditor():Void {
		if (Control.editorphasestate_lerp > 0) {
			Control.editorphasestate_lerp--;
		}else {
			if (Control.editorphasestate_delay > 0) {
				Control.editorphasestate_delay--;
			}else {
				if(Control.editorphasestate_nextstate!=""){
					Control.changeeditorstate(Control.editorphasestate_nextstate);
				}
			}
		}
		
		if (!Control.editorphasestate_finished) {
			Control.editorphasestate_finished = true;
			switch(Control.editorphasestate) {
				case "start":
					currenttab = -1;
					currentframe = 0;
					
					//Clear all the old cards
					clearoutcards();
					
					Control.editorphasestate_delay = 45;
					Control.editorphasestate_lerp = 20;
					Control.editorphasestate_nextstate = "clearstart";
				case "clearstart":
					Control.editorphasestate_lerp = 20;
					Control.editorphasestate_nextstate = "realstart";
				case "realstart":
					Control.editorphasestate_lerp = 20;
					Control.editorphasestate_nextstate = "start2";
				case "start2":
					Control.editorphasestate_lerp = 20;
					Control.editorphasestate_nextstate = "start3";
				case "start3":
					Control.editorphasestate_nextstate = "gameloop_play";
					
					var tx:Int = 2 + Std.int((Gfx.screenwidth / 4) / 2) + Std.int((Gfx.screenwidth / 4) * 1) - Std.int(74 / 2);
					Gui.addbutton(tx, 168, 16, 20, "", "editorcolour_white", "colour");
					Gui.addbutton(tx + 18, 168, 16, 20, "", "editorcolour_red", "colour");
					Gui.addbutton(tx + 36, 168, 16, 20, "", "editorcolour_green", "colour");
					Gui.addbutton(tx + 54, 168, 16, 20, "", "editorcolour_blue", "colour");
					
					tx = 2 + Std.int((Gfx.screenwidth / 4) / 2) + Std.int((Gfx.screenwidth / 4) * 2) - Std.int(74 / 2);
					Gui.addbutton(tx, 168, 16, 20, "", "editorborder_white", "colour");
					Gui.addbutton(tx + 18, 168, 16, 20, "", "editorborder_red", "colour");
					Gui.addbutton(tx + 36, 168, 16, 20, "", "editorborder_green", "colour");
					Gui.addbutton(tx + 54, 168, 16, 20, "", "editorborder_blue", "colour");
					
					Gui.hidecolourseditorcolour();
					Gui.hidecolourseditorborder();
				case "gameloop_play":
					currenttab = -1;
				case "gameloop_tabopen":
				case "removecard":
					Control.editorphasestate_lerp = 10;
					Control.editorphasestate_nextstate = "removecard2";	
				case "removecard2":
					//Discard old card
					returnoldcardtotabs();
					
					swapoutoldcard();
					Control.editorphasestate_lerp = 10;
					Control.editorphasestate_delay = 8;
					currenttab = -1;
					Control.editorphasestate_nextstate = "removecard3";
				case "removecard3":
					updateframe(currentframe);
					Control.editorphasestate_nextstate = "gameloop_play";
				case "playcard":
					Control.editorphasestate_lerp = 10;
					if (getcurrentcardtype(finaltabselection) == "blank") {
						Control.editorphasestate_nextstate = "playcard3";	
					}else {
						Control.editorphasestate_nextstate = "playcard2";	
					}
					
				case "playcard2":
					//Discard old card
					//In play: on the baord
					//In the tab: In your hand of cards
					//New card and swap card are tempvariables
					
					//What I want to do:
					//Discard phase (animate old card being thrown out) newcard is used to animate
					//  Copy card in play to newcard and swapcard
					//  Blank out card in play
					//Play phase    (animate new card being played)
					//  Copy card to be played to newcard
					//  Remove card to be played from the tabs
					//Final phase   (make sure: chosen card played, old card in tab)
					//  Put newcard in play
					//  Put swapcard back in deck
					
					copyoutoldcard(); //Put the card from the tab into newcard AND swapcard
					blankoutoldcard();
					
					Music.playef("card1");
					
					//returnoldcardtotabs(); //Copy the card in play back into the tab
					//swapoutoldcard(); //Copy card in play to newcard, clear card in play
					Control.editorphasestate_lerp = 10;
					Control.editorphasestate_delay = 8;
					currenttab = -1;
					Control.editorphasestate_nextstate = "playcard3";
				case "playcard3":
					//Play the new card
					setcardtoplay(); //Set newcard to be the card from the tab
					removecardfromhand();
					
					//swapinnewcardfromswap(); //Copy swapcard to newcard
					Control.editorphasestate_lerp = 10;
					currenttab = -1;
					Control.editorphasestate_nextstate = "playcard4";
				case "playcard4":
					playnewcard();
					
					Music.playef("card2");
					if (swapincard.type == "custommessage") {
						numcustommessages--;
					}else if (swapincard.type != "blank") {
						returnoldcardtodeck();
					}
					//playcardfromswapcard(); //Put swapcard into play
					updateframe(currentframe);
					
					Control.editorphasestate_nextstate = "gameloop_play";
				case "opentab":
					Control.editorphasestate_lerp = 10;
					Control.editorphasestate_nextstate = "gameloop_tabopen";
				case "closetab":
					Control.editorphasestate_lerp = 10;
					Control.editorphasestate_nextstate = "gameloop_play";
				case "writeyourown":
					Control.editorphasestate_lerp = 10;
					Control.editorphasestate_nextstate = "writeyourown2";
				case "writeyourown2":
					currenttab = -1;
					Gui.addbutton(10, 140, 360, 40, "", "message_ingame", "textentry");
					var actionbutt:Int = Gui.findbuttonbyaction("message_ingame");
					Gui.dobuttonaction(actionbutt);
					Gui.button[actionbutt].selected = true;
					
					Gui.button[Gui.findbuttonbyaction("game_playout")].visable = false;
				case "writeyourown3":
					updateframe(currentframe);
					Gui.button[Gui.findbuttonbyaction("game_playout")].visable = true;
					
					Control.editorphasestate_nextstate = "gameloop_play";
			}
		}
	}
	
	public static var tempscore:Int;
	public static function drawframescore(_frame:Int, xp:Int, yp:Int):Void {
		//XP and YP are the top right corner of the frame
		tempscore = messagecard[_frame].score + colourcard[_frame].score + bordercard[_frame].score + effectcard[_frame].score;
		Gfx.fillrect(xp - 3, yp - 3 - 3, Std.int(Text.len(Std.string(tempscore))) + 5, 5 + 6, 0);
		Gfx.fillrect(xp - 2, yp - 2 - 3, Std.int(Text.len(Std.string(tempscore))) + 3, 5 + 4, 246, 221, 122);
		Gfx.smallprint(xp, yp - 3, Std.string(tempscore), 0, 0, 0, false);
	}
	
	public static function drawframes(xoff:Int, yoff:Int):Void {
		//Draw frames
		Gfx.fillrect(0+xoff, 0+yoff, Gfx.screenwidth, 65, Def.GRAY[0]);
		
		if (numplayerframes == 2) {
			Gfx.drawsign(0, Std.int(Gfx.screenwidthmid / 2) - 48 - 24 + xoff, 5 + yoff, 3);
			Gfx.drawsign(1, Gfx.screenwidthmid + Std.int(Gfx.screenwidthmid / 2) - 48 -24 + xoff, 5 + yoff, 3);
			
			if (currentframe == 0) {
				if(Help.slowsine%32>=16){
					Gfx.drawbox(Std.int(Gfx.screenwidthmid / 2) - 48 - 24 + xoff-1, 5 + yoff-1, 2+ 48 * 3, 2+16 * 3, Def.GRAY[4]);
				}else {
					Gfx.drawbox(Std.int(Gfx.screenwidthmid / 2) - 48 - 24 + xoff-1, 5 + yoff-1,2+ 48 * 3,2+ 16 * 3, Def.GRAY[5]);
				}
				
				Gfx.smallprint(Std.int(Gfx.screenwidthmid / 2) - Std.int(Text.len("CURRENT FRAME") / 2) + xoff, 55 + yoff, "CURRENT FRAME", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
			  if (changeframetext) {
					Gfx.drawbox(Gfx.screenwidthmid + Std.int(Gfx.screenwidthmid / 2) - 48 -24 + xoff - 1, 5 + yoff - 1, 2 + 48 * 3, 2 + 16 * 3, Def.GRAY[2], Def.GRAY[2], Def.GRAY[5]-Help.glow);
					Gfx.smallprint(Gfx.screenwidthmid + Std.int(Gfx.screenwidthmid / 2) - Std.int(Text.len("CLICK TO CHANGE FRAME") / 2) + xoff, 5 + yoff - 1 + 24, "CLICK TO CHANGE FRAME", Def.GRAY[2], Def.GRAY[2], Def.GRAY[5]-Help.glow, false);
				}
			}else if (currentframe == 1) {
				if(Help.slowsine%32>=16){
					Gfx.drawbox(Gfx.screenwidthmid + Std.int(Gfx.screenwidthmid / 2) - 48 -24 + xoff-1, 5 + yoff-1, 2+48 * 3, 2+16 * 3, Def.GRAY[4]);
				}else {
					Gfx.drawbox(Gfx.screenwidthmid + Std.int(Gfx.screenwidthmid / 2) - 48 -24 + xoff-1, 5 + yoff-1, 2+48 * 3, 2+16 * 3, Def.GRAY[5]);
				}
				
				if(changeframetext) Gfx.smallprint(Std.int(Gfx.screenwidthmid / 2) - Std.int(Text.len("CLICK TO CHANGE FRAME") / 2) + xoff, 55 + yoff, "CLICK TO CHANGE FRAME", Def.GRAY[2], Def.GRAY[2], Def.GRAY[5], false);
				Gfx.smallprint(Gfx.screenwidthmid + Std.int(Gfx.screenwidthmid / 2) - Std.int(Text.len("CURRENT FRAME") / 2) + xoff, 55 + yoff, "CURRENT FRAME", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
			}
			
			drawframescore(0, Std.int(Gfx.screenwidthmid / 2) - 48 - 24 + xoff + (3 * 48), 5 + yoff);
			drawframescore(1, Gfx.screenwidthmid + Std.int(Gfx.screenwidthmid / 2) - 48 -24 + xoff + (3 * 48), 5 + yoff);
		}else if (numplayerframes == 3) {
			for(i in 0...numplayerframes){
				Gfx.drawsign(i, Std.int((Gfx.screenwidth / numplayerframes) / 2) + Std.int((Gfx.screenwidth / numplayerframes) * i) - 48 + xoff, 16 + yoff, 2);
				if (i == currentframe) {
					Gfx.smallprint(Std.int((Gfx.screenwidth / numplayerframes) / 2) + Std.int((Gfx.screenwidth / numplayerframes) * i) - Std.int(Text.len("CURRENT FRAME") / 2) + xoff, 50 + yoff, "CURRENT FRAME", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
				}else{
					if(changeframetext) Gfx.smallprint(Std.int((Gfx.screenwidth / numplayerframes) / 2) + Std.int((Gfx.screenwidth / numplayerframes) * i) - Std.int(Text.len("FRAME " + Std.string(i + 1)) / 2) + xoff, 50 + yoff, "FRAME " + Std.string(i + 1), Def.GRAY[2], Def.GRAY[2], Def.GRAY[5], false);
				}
				
				if (currentframe == i){
					if(Help.slowsine%32>=16){
						Gfx.drawbox(Std.int((Gfx.screenwidth / numplayerframes) / 2) + Std.int((Gfx.screenwidth / numplayerframes) * i) - 48 + xoff-1, 16 + yoff-1, 2+48 * 2, 2+16 * 2, Def.GRAY[4]);
					}else {
						Gfx.drawbox(Std.int((Gfx.screenwidth / numplayerframes) / 2) + Std.int((Gfx.screenwidth / numplayerframes) * i) - 48 + xoff-1, 16 + yoff-1, 2+48 * 2, 2+16 * 2, Def.GRAY[5]);
					}
				}
				
				drawframescore(i, Std.int((Gfx.screenwidth / numplayerframes) / 2) + Std.int((Gfx.screenwidth / numplayerframes) * i) - 48 + xoff + (48 * 2), 16 + yoff);
			}
		}else if (numplayerframes >=4) {
			for(i in 0...numplayerframes){
				Gfx.drawsign(i, Std.int((Gfx.screenwidth / numplayerframes) / 2) + Std.int((Gfx.screenwidth / numplayerframes) * i) - 24 + xoff, 24 + yoff, 1);
				if (i == currentframe) {
					Gfx.smallprint(Std.int((Gfx.screenwidth / numplayerframes) / 2) + Std.int((Gfx.screenwidth / numplayerframes) * i) - Std.int(Text.len("CURRENT FRAME") / 2) + xoff, 42 + yoff, "CURRENT FRAME", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
				}else{
					if(changeframetext) Gfx.smallprint(Std.int((Gfx.screenwidth / numplayerframes) / 2) + Std.int((Gfx.screenwidth / numplayerframes) * i) - Std.int(Text.len("FRAME " + Std.string(i + 1)) / 2) + xoff, 42 + yoff, "FRAME " + Std.string(i + 1), Def.GRAY[2], Def.GRAY[2], Def.GRAY[5], false);
				}
				
				if (currentframe == i){
					if(Help.slowsine%32>=16){
						Gfx.drawbox(Std.int((Gfx.screenwidth / numplayerframes) / 2) + Std.int((Gfx.screenwidth / numplayerframes) * i) - 24 + xoff-1, 24 + yoff-1, 2+48, 2+16, Def.GRAY[4]);
					}else {
						Gfx.drawbox(Std.int((Gfx.screenwidth / numplayerframes) / 2) + Std.int((Gfx.screenwidth / numplayerframes) * i) - 24 + xoff-1, 24 + yoff-1, 2+48, 2+16, Def.GRAY[5]);
					}
				}
				
				drawframescore(i, Std.int((Gfx.screenwidth / numplayerframes) / 2) + Std.int((Gfx.screenwidth / numplayerframes) * i) - 24 + xoff + 48, 24 + yoff);
			}
		}
	}
	
	public static function drawcardplaces(xoff:Int, yoff:Int):Void {
		var tx:Int, ty:Int;
		
		//Draw cards for frame
		for (i in 0...4) {
			tx = Std.int((Gfx.screenwidth / 4) / 2) + Std.int((Gfx.screenwidth / 4) * i) - Std.int(74/2);
			ty = 0;
			Gfx.drawcardgraphic(tx + xoff, Gfx.screenheightmid -50 + yoff, 5, 0);
			var t:String = "";
			if (i == 0) t = "MESSAGE";
			if (i == 1) t = "COLOUR";
			if (i == 2) t = "BORDER";
			if (i == 3) t = "EFFECT";
			Gfx.smallbigprint(Std.int((Gfx.screenwidth / 4) / 2) + Std.int((Gfx.screenwidth / 4) * i) - Std.int(Text.len(t) / 2) + xoff, Gfx.screenheightmid -50 - 7 + Std.int(94 / 2) + yoff, t, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
		}
		
		for (i in 0...4) {
			tx = Std.int((Gfx.screenwidth / 4) / 2) + Std.int((Gfx.screenwidth / 4) * i) - Std.int(74/2);
			ty = 0;
			if (i == 0) {
				if (messagecard[currentframe].type != "blank") {
					Gfx.drawcard(tx + xoff, Gfx.screenheightmid -50 + yoff, messagecard[currentframe]);
				}
			}else if (i == 1) {
				if (colourcard[currentframe].type != "blank") {
					Gfx.drawcard(tx + xoff, Gfx.screenheightmid -50 + yoff, colourcard[currentframe]);
				}
			}else if (i == 2) {
				if (bordercard[currentframe].type != "blank") {
					Gfx.drawcard(tx + xoff, Gfx.screenheightmid -50 + yoff, bordercard[currentframe]);
				}
			}else if (i == 3) {
				if (effectcard[currentframe].type != "blank") {
					Gfx.drawcard(tx + xoff, Gfx.screenheightmid -50 + yoff, effectcard[currentframe]);
				}
			}
		}
		
		drawscoretext();
	}
	
	public static var tempscorestring:String;
	public static var tempscore2:Int;
	
	public static function drawscoretext():Void {
		tempscorestring = "TOTAL CUSTOMERS: ";
		tempscore2 = 0;
		for (i in 0...numplayerframes) {
			tempscore = messagecard[i].score + colourcard[i].score + bordercard[i].score + effectcard[i].score;
			tempscorestring += Std.string(tempscore);
			if (i != numplayerframes - 1) {
				tempscorestring += " + ";
			}else {
				tempscorestring += " = ";
			}
			tempscore2 += tempscore;
		}
		tempscorestring += "   ";
		
		Gfx.smallbigprint(0, Gfx.screenheightmid +75, tempscorestring, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], true);
		Gfx.normalbigprint(Gfx.screenwidthmid + Std.int(Text.len(tempscorestring) / 2) -8, Gfx.screenheightmid +75 - 4, Std.string(tempscore2), Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
	}
	
	public static function drawoldcard(xoff:Int, yoff:Int):Void {
		for (i in 0...4) {
			if (finaltabselection == i) {
				var tx:Int = Std.int((Gfx.screenwidth / 4) / 2) + Std.int((Gfx.screenwidth / 4) * i) - Std.int(74 / 2);
				Gfx.drawcard(tx + xoff, Gfx.screenheightmid -50 + yoff, newcard);
			}
		}
	}
	
	
	public static function drawcardtabs(xoff:Int, yoff:Int):Void {
		//Ok, draw tabs!
		var t:Int;
		
		for (i in 0...4) {
			Control.changedeck(card_deck[i]);
			t = Control.deck[Control.currentdeck].numcards;
			if (currenttab != i) {
				if (Mouse.x > (tabsize * i) && Mouse.x < (tabsize * (i+1)) && Mouse.y > Gfx.screenheight-24) {
					Gfx.fillrect((tabsize*i) + 0 + xoff, Gfx.screenheight - 24-4 + yoff, tabsize, 28, 0);
					Gfx.fillrect((tabsize*i) + 2 + xoff, Gfx.screenheight - 24 + 2-4 + yoff, tabsize - 4, 28, Std.int(card_front_red[i]*1.5), Std.int(card_front_green[i]*1.5), Std.int(card_front_blue[i]*1.5));	
					Gfx.smallbigprint((tabsize*i) + 8 + xoff, Gfx.screenheight - 18-4 + yoff, card_name[i], Std.int(card_back_red[i]*1.5), Std.int(card_back_green[i]*1.5), Std.int(card_back_blue[i]*1.5), false);
					//Gfx.drawtile((tabsize*i) + tabsize - 20 + xoff, Gfx.screenheight - 15-4 + yoff, 20);
					//Gfx.drawtile((tabsize * i) + tabsize - 20 + xoff, Gfx.screenheight - 15 - 4 + yoff, 20);
					Gfx.smallbigprint((tabsize * i) + tabsize - 10 + xoff - Std.int(Text.len(Std.string(t))), Gfx.screenheight - 18-4 + yoff, Std.string(t), Std.int(card_back_red[i]*1.5), Std.int(card_back_green[i]*1.5), Std.int(card_back_blue[i]*1.5), false);
				}else {
					Gfx.fillrect((tabsize*i) + 0 + xoff, Gfx.screenheight - 24 + yoff, tabsize, 24, 0);	
					Gfx.fillrect((tabsize*i) + 2 + xoff, Gfx.screenheight - 24 + 2 + yoff, tabsize - 4, 24, card_front_red[i], card_front_green[i], card_front_blue[i]);
					Gfx.smallbigprint((tabsize*i) + 8 + xoff, Gfx.screenheight - 18 + yoff, card_name[i], card_back_red[i], card_back_green[i], card_back_blue[i], false);
					//Gfx.drawtile((tabsize * i) + tabsize - 20 + xoff, Gfx.screenheight - 15 + yoff, 20);
					//Gfx.drawtile((tabsize * i) + tabsize - 20 + xoff, Gfx.screenheight - 15 + yoff, 20);
					Gfx.smallbigprint((tabsize * i) + tabsize - 10 + xoff - Std.int(Text.len(Std.string(t))), Gfx.screenheight - 18 + yoff, Std.string(t), card_back_red[i], card_back_green[i], card_back_blue[i], false);
				}
			}
		}
	}
	
	
	public static function drawcurrenttab(xoff:Int, yoff:Int, takeinput:Bool = true, showselected:Bool = true):Void {
		//Yoff is actually a value between 0 and 5, where 5 is full and 0 is down
		if (currenttab > -1) {
			Gfx.drawimage("tint");
			
			Control.changedeck(card_deck[currenttab]);
			if (currenttab == 0 ) {
				if (getcurrentcardtype(currenttab) == "blank") {
					ty = Std.int(((Control.deck[Control.currentdeck].numcards * 15) + 30 + 30) * (10 - yoff) / 10);
				}else{
					ty = Std.int(((Control.deck[Control.currentdeck].numcards * 15) + 30 + 45) * (10 - yoff) / 10);
				}
			}else{
				if (getcurrentcardtype(currenttab) == "blank") {
					ty = Std.int(((Control.deck[Control.currentdeck].numcards * 15) + 30) * (10 - yoff) / 10);
				}else{
					ty = Std.int(((Control.deck[Control.currentdeck].numcards * 15) + 30 + 30) * (10 - yoff) / 10);
				}
			}
			yoff = 0;
			
			Gfx.fillrect((tabsize * currenttab) + 0+xoff, Gfx.screenheight - ty+yoff, card_deck_width[currenttab], ty, 0, 0, 0);
			Gfx.fillrect((tabsize * currenttab) + 2+xoff, Gfx.screenheight - ty+2+yoff, card_deck_width[currenttab]-4, ty, card_back_red[currenttab], card_back_green[currenttab], card_back_blue[currenttab]);
			
			cardselection = -1;
			var extraspace:Int = 0;
			if (currenttab == 0) {
				if(getcurrentcardtype(currenttab) == "blank") {
					extraspace = 2;
				}else {
					extraspace = 3;
				}
			}else{
				if(getcurrentcardtype(currenttab) == "blank") {
					extraspace = 0;
				}else {
					extraspace = 2;
				}
			}
			
			for (i in 0...Control.deck[Control.currentdeck].numcards + extraspace) {
				if(i<Control.deck[Control.currentdeck].numcards){
					if (Mouse.x >= (tabsize * currenttab) &&
							Mouse.x <= (tabsize * currenttab) + card_deck_width[currenttab] &&
							Mouse.y >= Gfx.screenheight - ty + (i * 15) + 4 + yoff &&
							Mouse.y < Gfx.screenheight - ty + ((i + 1) * 15) + 4 + yoff && takeinput) {
						cardselection = i;
					}
					
					if (!showselected && i == finaltabselection) {
						Gfx.fillrect((tabsize * currenttab) + 2+xoff, Gfx.screenheight - ty + (i * 15) + 4 + yoff, card_deck_width[currenttab]-4, 15, Std.int(card_front_red[currenttab]/2), Std.int(card_front_green[currenttab]/2), Std.int(card_front_blue[currenttab]/2));
					}else if (i == cardselection) {
						Gfx.fillrect((tabsize * currenttab) + 2+xoff, Gfx.screenheight - ty + (i * 15) + 4 + yoff, card_deck_width[currenttab]-4, 15, Std.int(card_front_red[currenttab]/2), Std.int(card_front_green[currenttab]/2), Std.int(card_front_blue[currenttab]/2));
						Gfx.smallbigprint((tabsize * currenttab) + 4+xoff, Gfx.screenheight - ty + (i * 15) + 4+yoff, Std.string(Control.deck[Control.currentdeck].card[i].score), Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
						if(currenttab==0){
							Gfx.smallbigprint((tabsize * currenttab) + 4 + 10+xoff, Gfx.screenheight - ty + (i * 15) + 4+yoff, "\"" + Control.deck[Control.currentdeck].card[i].name + "\"", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
						}else {
							Gfx.smallbigprint((tabsize * currenttab) + 4 + 10+xoff, Gfx.screenheight - ty + (i * 15) + 4+yoff, Control.deck[Control.currentdeck].card[i].name, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
						}
					}else{
						Gfx.smallbigprint((tabsize * currenttab) + 4+xoff, Gfx.screenheight - ty + (i * 15) + 4+yoff, Std.string(Control.deck[Control.currentdeck].card[i].score), Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
						if(currenttab==0){
							Gfx.smallbigprint((tabsize * currenttab) + 4 + 10+xoff, Gfx.screenheight - ty + (i * 15) + 4+yoff, "\"" + Control.deck[Control.currentdeck].card[i].name + "\"", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
						}else {
							Gfx.smallbigprint((tabsize * currenttab) + 4 + 10+xoff, Gfx.screenheight - ty + (i * 15) + 4+yoff, Control.deck[Control.currentdeck].card[i].name, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
						}
					}
				}else if (i == Control.deck[Control.currentdeck].numcards + 1) {
					if (Mouse.x >= (tabsize * currenttab) &&
							Mouse.x <= (tabsize * currenttab) + card_deck_width[currenttab] &&
							Mouse.y >= Gfx.screenheight - ty + (i * 15) + 4 + yoff &&
							Mouse.y < Gfx.screenheight - ty + ((i + 1) * 15) + 4 + yoff && takeinput) {
						cardselection = i;
					}
					
					if (!showselected && i == finaltabselection) {
						Gfx.fillrect((tabsize * currenttab) + 2+xoff, Gfx.screenheight - ty + (i * 15) + 4 + yoff, card_deck_width[currenttab]-4, 15, Std.int(card_front_red[currenttab]/2), Std.int(card_front_green[currenttab]/2), Std.int(card_front_blue[currenttab]/2));
					}else if (i == cardselection) {
						Gfx.fillrect((tabsize * currenttab) + 2+xoff, Gfx.screenheight - ty + (i * 15) + 4 + yoff, card_deck_width[currenttab]-4, 15, Std.int(card_front_red[currenttab]/2), Std.int(card_front_green[currenttab]/2), Std.int(card_front_blue[currenttab]/2));
						if(currenttab==0){
							//Gfx.smallbigprint((tabsize * currenttab) + 4 + 10 + xoff, Gfx.screenheight - ty + (i * 15) + 4 + yoff, "\"" + Control.deck[Control.currentdeck].card[i].name + "\"", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
							if(numcustommessages==0){
								Gfx.smallbigprint((tabsize * currenttab) + 4 + xoff, Gfx.screenheight - ty + (i * 15) + 4 + yoff, "2", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
							}else {
								Gfx.smallbigprint((tabsize * currenttab) + 4 + xoff, Gfx.screenheight - ty + (i * 15) + 4 + yoff, "1", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
							}
							Gfx.smallbigprint((tabsize * currenttab) + 4 + 10+xoff, Gfx.screenheight - ty + (i * 15) + 4+yoff, "WRITE YOUR OWN", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
						}else {
							//Gfx.smallbigprint((tabsize * currenttab) + 4 + 10+xoff, Gfx.screenheight - ty + (i * 15) + 4+yoff, Control.deck[Control.currentdeck].card[i].name, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
							Gfx.smallbigprint((tabsize * currenttab) + 4+xoff, Gfx.screenheight - ty + (i * 15) + 4+yoff, "REMOVE", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
						}
					}else{
						if (currenttab == 0) {
							if (numcustommessages == 0) {
								Gfx.smallbigprint((tabsize * currenttab) + 4 + xoff, Gfx.screenheight - ty + (i * 15) + 4 + yoff, "2", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
							}else{
								Gfx.smallbigprint((tabsize * currenttab) + 4 + xoff, Gfx.screenheight - ty + (i * 15) + 4 + yoff, "1", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
							}
							Gfx.smallbigprint((tabsize * currenttab) + 4 + 10+xoff, Gfx.screenheight - ty + (i * 15) + 4+yoff, "WRITE YOUR OWN", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
						}else {
							Gfx.smallbigprint((tabsize * currenttab) + 4+xoff, Gfx.screenheight - ty + (i * 15) + 4+yoff, "REMOVE", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
						}
					}
				}else if (i == Control.deck[Control.currentdeck].numcards + 2) {
					if (Mouse.x >= (tabsize * currenttab) &&
							Mouse.x <= (tabsize * currenttab) + card_deck_width[currenttab] &&
							Mouse.y >= Gfx.screenheight - ty + (i * 15) + 4 + yoff &&
							Mouse.y < Gfx.screenheight - ty + ((i + 1) * 15) + 4 + yoff && takeinput) {
						cardselection = i;
					}
					
					if (!showselected && i == finaltabselection) {
						Gfx.fillrect((tabsize * currenttab) + 2+xoff, Gfx.screenheight - ty + (i * 15) + 4 + yoff, card_deck_width[currenttab]-4, 15, Std.int(card_front_red[currenttab]/2), Std.int(card_front_green[currenttab]/2), Std.int(card_front_blue[currenttab]/2));
					}else if (i == cardselection) {
						Gfx.fillrect((tabsize * currenttab) + 2+xoff, Gfx.screenheight - ty + (i * 15) + 4 + yoff, card_deck_width[currenttab]-4, 15, Std.int(card_front_red[currenttab]/2), Std.int(card_front_green[currenttab]/2), Std.int(card_front_blue[currenttab]/2));
							//Gfx.smallbigprint((tabsize * currenttab) + 4 + 10+xoff, Gfx.screenheight - ty + (i * 15) + 4+yoff, Control.deck[Control.currentdeck].card[i].name, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
							Gfx.smallbigprint((tabsize * currenttab) + 4+xoff, Gfx.screenheight - ty + (i * 15) + 4+yoff, "REMOVE", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
					}else{
						Gfx.smallbigprint((tabsize * currenttab) + 4+xoff, Gfx.screenheight - ty + (i * 15) + 4+yoff, "REMOVE", Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
					}
				}
			}
			
			Gfx.fillrect((tabsize*currenttab) + 0+xoff, Gfx.screenheight - 24 - ty+yoff, tabsize, 24, 0);	
			Gfx.fillrect((tabsize*currenttab) + 2+xoff, Gfx.screenheight - 24 + 2- ty+yoff, tabsize - 4, 24, card_front_red[currenttab], card_front_green[currenttab], card_front_blue[currenttab]);
			Gfx.smallbigprint((tabsize*currenttab) + 8+xoff, Gfx.screenheight - 18 - ty+yoff, card_name[currenttab], card_back_red[currenttab], card_back_green[currenttab], card_back_blue[currenttab], false);
			Gfx.drawtile((tabsize * currenttab) + tabsize - 20+xoff, Gfx.screenheight - 15 - ty+yoff, 21);
		}
	}
	
	public static function rendereditorphase():Void {
	  Gui.drawbuttons();
		
		switch(Control.editorphasestate) {
			case "realstart":
				drawcardplaces(0, -(Control.editorphasestate_lerp*9));
				drawframes(0, -(Control.editorphasestate_lerp*5));
			case "start":
				var t:String = "PREPARE YOUR SIGN!";
				Gfx.normalbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t, 3) / 2), Std.int((Gfx.screenheight / 2) - (14) +Control.editorphasestate_lerp * 10), t, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
			case "clearstart":
				var t:String = "PREPARE YOUR SIGN!";
				Gfx.normalbigprint(Std.int(Gfx.screenwidth / 2) - Std.int(Text.len(t, 3) / 2), Std.int((Gfx.screenheight / 2) - (14) -(20 - Control.editorphasestate_lerp) * 10), t, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
			case "start2", "start3":
				drawcardplaces(0, 0);
				drawframes(0, 0);
				drawcardtabs(0, (Control.editorphasestate_lerp*2));
			case "gameloop_play", "gameloop_tabopen":
				drawcardplaces(0, 0);
				drawframes(0, 0);
				drawcurrenttab(0, 0);
				drawcardtabs(0, 0);
			case "removecard":
				drawcardplaces(0, 0);
				drawframes(0, 0);
				drawcurrenttab(0, 10-Control.editorphasestate_lerp, false, false);
				drawcardtabs(0, 0);
			case "removecard2":
				drawcardplaces(0, 0);
				drawframes(0, 0);
				drawoldcard(0, (10 - Control.editorphasestate_lerp)*18);
				drawcardtabs(0, 0);
			case "removecard3":
				drawcardplaces(0, 0);
				drawframes(0, 0);
				drawcardtabs(0, 0);
			case "playcard":
				drawcardplaces(0, 0);
				drawframes(0, 0);
				drawcurrenttab(0, 10-Control.editorphasestate_lerp, false, false);
				drawcardtabs(0, 0);
			case "playcard2":
				drawcardplaces(0, 0);
				drawframes(0, 0);
				drawoldcard(0, (10 - Control.editorphasestate_lerp)*18);
				drawcardtabs(0, 0);
			case "playcard3":
				drawcardplaces(0, 0);
				drawframes(0, 0);
				drawoldcard(0, (Control.editorphasestate_lerp)*18);
				drawcardtabs(0, 0);
			case "playcard4":
				drawcardplaces(0, 0);
				drawframes(0, 0);
				drawcardtabs(0, 0);
			case "opentab":
				drawcardplaces(0, 0);
				drawframes(0, 0);
				drawcurrenttab(0, Control.editorphasestate_lerp, false);
				drawcardtabs(0, 0);
			case "closetab":
				drawcardplaces(0, 0);
				drawframes(0, 0);
				drawcurrenttab(0, 10-Control.editorphasestate_lerp, false);
				drawcardtabs(0, 0);
			case "writeyourown":
				drawcardplaces(0, 0);
				drawframes(0, 0);
				drawcurrenttab(0, 10-Control.editorphasestate_lerp, false);
				drawcardtabs(0, 0);
			case "writeyourown2":
				drawcardplaces(0, 0);
				drawframes(0, 0);
				
				Gfx.drawimage("tint");
				
				Gfx.fillrect(10 - 7, 140 - 17-10, 360 + 14, 40 +10+ (17 * 2), 0);
				Gfx.fillrect(10 - 5, 140 - 15 - 10, 360 + 10, 40 +10 + (15 * 2), Def.GRAY[3]);
				
				if(numcustommessages==0){
					Gfx.smallbigprint(0, 140 - 20, "WRITE YOUR OWN MESSAGE FOR 2 POINTS", Def.GRAY[5]);
				}else {
					Gfx.smallbigprint(0, 140 - 20, "FURTHER CUSTOM MESSAGES ARE WORTH 1 POINT", Def.GRAY[5]);
				}
				Gfx.smallprint(0, 185, "PRESS ENTER WHEN FINISHED", Def.GRAY[5]);
				Gui.drawbuttons(true);
				//drawcardtabs(0, 0);
			case "writeyourown3":
				drawcardplaces(0, 0);
				drawframes(0, 0);
				drawcardtabs(0, 0);
		}
	}
	
	public static function playcardfrommenu():Void {
		if(finaltabselection==0){
			Control.changedeck("message_playerdeck");
			messagecard[currentframe].copy(Control.deck[Control.currentdeck].card[finalcardselection].type, Control.deck[Control.currentdeck].card[finalcardselection].name, Control.deck[Control.currentdeck].card[finalcardselection].action, Control.deck[Control.currentdeck].card[finalcardselection].score, Control.deck[Control.currentdeck].card[finalcardselection].special);
		}else if(finaltabselection==1){
			Control.changedeck("colour_playerdeck");
			colourcard[currentframe].copy(Control.deck[Control.currentdeck].card[finalcardselection].type, Control.deck[Control.currentdeck].card[finalcardselection].name, Control.deck[Control.currentdeck].card[finalcardselection].action, Control.deck[Control.currentdeck].card[finalcardselection].score, Control.deck[Control.currentdeck].card[finalcardselection].special);
		}else if(finaltabselection==2){
			Control.changedeck("border_playerdeck");
			bordercard[currentframe].copy(Control.deck[Control.currentdeck].card[finalcardselection].type, Control.deck[Control.currentdeck].card[finalcardselection].name, Control.deck[Control.currentdeck].card[finalcardselection].action, Control.deck[Control.currentdeck].card[finalcardselection].score, Control.deck[Control.currentdeck].card[finalcardselection].special);
		}else if(finaltabselection==3){
			Control.changedeck("effect_playerdeck");
			effectcard[currentframe].copy(Control.deck[Control.currentdeck].card[finalcardselection].type, Control.deck[Control.currentdeck].card[finalcardselection].name, Control.deck[Control.currentdeck].card[finalcardselection].action, Control.deck[Control.currentdeck].card[finalcardselection].score, Control.deck[Control.currentdeck].card[finalcardselection].special);
		}
	}
	
	public static function playcardfromswapcard():Void {
		if(finaltabselection==0){
			Control.changedeck("message_playerdeck");
			messagecard[currentframe].copy(swapincard.type, swapincard.name, swapincard.action, swapincard.score, swapincard.special);
		}else if(finaltabselection==1){
			Control.changedeck("colour_playerdeck");
			colourcard[currentframe].copy(swapincard.type, swapincard.name, swapincard.action, swapincard.score, swapincard.special);
		}else if(finaltabselection==2){
			Control.changedeck("border_playerdeck");
			bordercard[currentframe].copy(swapincard.type, swapincard.name, swapincard.action, swapincard.score, swapincard.special);
		}else if(finaltabselection==3){
			Control.changedeck("effect_playerdeck");
			effectcard[currentframe].copy(swapincard.type, swapincard.name, swapincard.action, swapincard.score, swapincard.special);
		}
	}
	
	public static function custommessage(t:String):Void {
	  Control.changeeditorstate("writeyourown3");
		
		returnoldcardtotabs();
		if(numcustommessages==0){
			messagecard[currentframe].copy("message", t, "custommessage", 2, "none");
			numcustommessages++;
		}else {
			messagecard[currentframe].copy("message", t, "custommessage", 1, "none");
			numcustommessages++;
		}
	}
	
	public static function copyoutoldcard():Void {
		if(finaltabselection==0){
			newcard.copy(messagecard[currentframe].type, messagecard[currentframe].name, messagecard[currentframe].action, messagecard[currentframe].score, messagecard[currentframe].special);
		}else if(finaltabselection==1){
			newcard.copy(colourcard[currentframe].type, colourcard[currentframe].name, colourcard[currentframe].action, colourcard[currentframe].score, colourcard[currentframe].special);
		}else if(finaltabselection==2){
			newcard.copy(bordercard[currentframe].type, bordercard[currentframe].name, bordercard[currentframe].action, bordercard[currentframe].score, bordercard[currentframe].special);
		}else if(finaltabselection==3){
			newcard.copy(effectcard[currentframe].type, effectcard[currentframe].name, effectcard[currentframe].action, effectcard[currentframe].score, effectcard[currentframe].special);
		}
		
		swapincard.copy(newcard.type, newcard.name, newcard.action, newcard.score, newcard.special);
	}
	
	public static function blankoutoldcard():Void {
		if(finaltabselection==0){
			messagecard[currentframe].type = "blank";
			messagecard[currentframe].name = "";
			messagecard[currentframe].action = "none";
			messagecard[currentframe].score = 0;
			messagecard[currentframe].special = "none";
		}else if (finaltabselection == 1) {
			Gui.hidecolourseditorcolour();
			colourcard[currentframe].type = "blank";
			colourcard[currentframe].name = "";
			colourcard[currentframe].action = "none";
			colourcard[currentframe].score = 0;
			colourcard[currentframe].special = "none";
		}else if (finaltabselection == 2) {
			Gui.hidecolourseditorborder();
			bordercard[currentframe].type = "blank";
			bordercard[currentframe].name = "";
			bordercard[currentframe].action = "none";
			bordercard[currentframe].score = 0;
			bordercard[currentframe].special = "none";
		}else if (finaltabselection == 3) {
			effectcard[currentframe].type = "blank";
			effectcard[currentframe].name = "";
			effectcard[currentframe].action = "none";
			effectcard[currentframe].score = 0;
			effectcard[currentframe].special = "none";
		}
	}
	
	public static function setcardtoplay():Void {
		if(finaltabselection==0){
			Control.changedeck("message_playerdeck");
			newcard.copy(Control.deck[Control.currentdeck].card[finalcardselection].type, Control.deck[Control.currentdeck].card[finalcardselection].name, Control.deck[Control.currentdeck].card[finalcardselection].action, Control.deck[Control.currentdeck].card[finalcardselection].score, Control.deck[Control.currentdeck].card[finalcardselection].special);
		}else if(finaltabselection==1){
			Control.changedeck("colour_playerdeck");
			newcard.copy(Control.deck[Control.currentdeck].card[finalcardselection].type, Control.deck[Control.currentdeck].card[finalcardselection].name, Control.deck[Control.currentdeck].card[finalcardselection].action, Control.deck[Control.currentdeck].card[finalcardselection].score, Control.deck[Control.currentdeck].card[finalcardselection].special);
		}else if(finaltabselection==2){
			Control.changedeck("border_playerdeck");
			newcard.copy(Control.deck[Control.currentdeck].card[finalcardselection].type, Control.deck[Control.currentdeck].card[finalcardselection].name, Control.deck[Control.currentdeck].card[finalcardselection].action, Control.deck[Control.currentdeck].card[finalcardselection].score, Control.deck[Control.currentdeck].card[finalcardselection].special);
		}else if(finaltabselection==3){
			Control.changedeck("effect_playerdeck");
			newcard.copy(Control.deck[Control.currentdeck].card[finalcardselection].type, Control.deck[Control.currentdeck].card[finalcardselection].name, Control.deck[Control.currentdeck].card[finalcardselection].action, Control.deck[Control.currentdeck].card[finalcardselection].score, Control.deck[Control.currentdeck].card[finalcardselection].special);
		}
	}
	
	public static function removecardfromhand():Void {
		Control.removebyindex(finalcardselection);
	}
	
	public static function playnewcard():Void {
		if(finaltabselection==0){
			Control.changedeck("message_playerdeck");
			messagecard[currentframe].copy(newcard.type, newcard.name, newcard.action, newcard.score, newcard.special);
		}else if(finaltabselection==1){
			Control.changedeck("colour_playerdeck");
			colourcard[currentframe].copy(newcard.type, newcard.name, newcard.action, newcard.score, newcard.special);
		}else if(finaltabselection==2){
			Control.changedeck("border_playerdeck");
			bordercard[currentframe].copy(newcard.type, newcard.name, newcard.action, newcard.score, newcard.special);
		}else if(finaltabselection==3){
			Control.changedeck("effect_playerdeck");
			effectcard[currentframe].copy(newcard.type, newcard.name, newcard.action, newcard.score, newcard.special);
		}
	}
	
	public static function returnoldcardtodeck():Void {
	  //Take whatever card is currently in swapcard and put it back in your hand, then sort.
		if (finaltabselection == 0) {
			if (swapincard.action != "custommessage") {
				Control.deck[Control.currentdeck].copycard(swapincard.type, swapincard.name, swapincard.action, swapincard.score, swapincard.special);
			}else {
				numcustommessages--;
				if (numcustommessages < 0)	numcustommessages = 0;
			}
		}else if (finaltabselection == 1) {
			Control.deck[Control.currentdeck].copycard(swapincard.type, swapincard.name, swapincard.action, swapincard.score, swapincard.special);
		}else if (finaltabselection == 2) {
			Control.deck[Control.currentdeck].copycard(swapincard.type, swapincard.name, swapincard.action, swapincard.score, swapincard.special);
		}else if (finaltabselection == 3) {
			Control.deck[Control.currentdeck].copycard(swapincard.type, swapincard.name, swapincard.action, swapincard.score, swapincard.special);
		}
		Control.sortbyscore();
		
		swapincard.type = "blank";
		swapincard.name = "";
		swapincard.action = "none";
		swapincard.score = 0;
		swapincard.special = "none";
	}
	
	public static function swapinnewcard():Void {
		if(finaltabselection==0){
			Control.changedeck("message_playerdeck");
			newcard.copy(Control.deck[Control.currentdeck].card[finalcardselection].type, Control.deck[Control.currentdeck].card[finalcardselection].name, Control.deck[Control.currentdeck].card[finalcardselection].action, Control.deck[Control.currentdeck].card[finalcardselection].score, Control.deck[Control.currentdeck].card[finalcardselection].special);
		}else if(finaltabselection==1){
			Control.changedeck("colour_playerdeck");
			newcard.copy(Control.deck[Control.currentdeck].card[finalcardselection].type, Control.deck[Control.currentdeck].card[finalcardselection].name, Control.deck[Control.currentdeck].card[finalcardselection].action, Control.deck[Control.currentdeck].card[finalcardselection].score, Control.deck[Control.currentdeck].card[finalcardselection].special);
		}else if(finaltabselection==2){
			Control.changedeck("border_playerdeck");
			newcard.copy(Control.deck[Control.currentdeck].card[finalcardselection].type, Control.deck[Control.currentdeck].card[finalcardselection].name, Control.deck[Control.currentdeck].card[finalcardselection].action, Control.deck[Control.currentdeck].card[finalcardselection].score, Control.deck[Control.currentdeck].card[finalcardselection].special);
		}else if(finaltabselection==3){
			Control.changedeck("effect_playerdeck");
			newcard.copy(Control.deck[Control.currentdeck].card[finalcardselection].type, Control.deck[Control.currentdeck].card[finalcardselection].name, Control.deck[Control.currentdeck].card[finalcardselection].action, Control.deck[Control.currentdeck].card[finalcardselection].score, Control.deck[Control.currentdeck].card[finalcardselection].special);
		}
		
		swapincard.copy(newcard.type, newcard.name, newcard.action, newcard.score, newcard.special);
	}
	
	public static function swapinnewcardfromswap():Void {
		newcard.copy(swapincard.type, swapincard.name, swapincard.action, swapincard.score, swapincard.special);
	}
	
	public static function returnoldcardtotabs():Void {
	  //Take whatever card is currently in position and put it back in your hand, then sort.
		if (finaltabselection == 0) {
			Control.changedeck("message_playerdeck");
			if (messagecard[currentframe].action != "custommessage" && messagecard[currentframe].type != "blank") {
				Control.deck[Control.currentdeck].copycard(messagecard[currentframe].type, messagecard[currentframe].name, messagecard[currentframe].action, messagecard[currentframe].score, messagecard[currentframe].special);
			}else if (messagecard[currentframe].action == "custommessage") {
				numcustommessages--;
			}
		}else if (finaltabselection == 1) {
			Control.changedeck("colour_playerdeck");
			Gui.hidecolourseditorcolour();
			Control.deck[Control.currentdeck].copycard(colourcard[currentframe].type, colourcard[currentframe].name, colourcard[currentframe].action, colourcard[currentframe].score, colourcard[currentframe].special);
		}else if (finaltabselection == 2) {
			Control.changedeck("border_playerdeck");
			Gui.hidecolourseditorborder();
			Control.deck[Control.currentdeck].copycard(bordercard[currentframe].type, bordercard[currentframe].name, bordercard[currentframe].action, bordercard[currentframe].score, bordercard[currentframe].special);
		}else if (finaltabselection == 3) {
			Control.changedeck("effect_playerdeck");
			Control.deck[Control.currentdeck].copycard(effectcard[currentframe].type, effectcard[currentframe].name, effectcard[currentframe].action, effectcard[currentframe].score, effectcard[currentframe].special);
		}
		Control.sortbyscore();
	}
	
	public static function clearoutcards():Void {
		for (i in 0...numplayerframes) {
			messagecard[i].type = "blank";
			messagecard[i].name = "";
			messagecard[i].action = "none";
			messagecard[i].score = 0;
			messagecard[i].special = "none";
			
			colourcard[i].type = "blank";
			colourcard[i].name = "";
			colourcard[i].action = "none";
			colourcard[i].score = 0;
			colourcard[i].special = "none";
			
			bordercard[i].type = "blank";
			bordercard[i].name = "";
			bordercard[i].action = "none";
			bordercard[i].score = 0;
			bordercard[i].special = "none";
			
			effectcard[i].type = "blank";
			effectcard[i].name = "";
			effectcard[i].action = "none";
			effectcard[i].score = 0;
			effectcard[i].special = "none";
			
			Control.frame[i].clear();
			Control.frame[i].add("", "white", "none", "none");
			Control.frame[i].start(i);
		}
	}
	
	public static function swapoutoldcard():Void {
		if(finaltabselection==0){
			newcard.copy(messagecard[currentframe].type, messagecard[currentframe].name, messagecard[currentframe].action, messagecard[currentframe].score, messagecard[currentframe].special);
			messagecard[currentframe].type = "blank";
			messagecard[currentframe].name = "";
			messagecard[currentframe].action = "none";
			messagecard[currentframe].score = 0;
			messagecard[currentframe].special = "none";
		}else if (finaltabselection == 1) {
			newcard.copy(colourcard[currentframe].type, colourcard[currentframe].name, colourcard[currentframe].action, colourcard[currentframe].score, colourcard[currentframe].special);
			colourcard[currentframe].type = "blank";
			colourcard[currentframe].name = "";
			colourcard[currentframe].action = "none";
			colourcard[currentframe].score = 0;
			colourcard[currentframe].special = "none";
		}else if (finaltabselection == 2) {
			newcard.copy(bordercard[currentframe].type, bordercard[currentframe].name, bordercard[currentframe].action, bordercard[currentframe].score, bordercard[currentframe].special);
			bordercard[currentframe].type = "blank";
			bordercard[currentframe].name = "";
			bordercard[currentframe].action = "none";
			bordercard[currentframe].score = 0;
			bordercard[currentframe].special = "none";
		}else if (finaltabselection == 3) {
			newcard.copy(effectcard[currentframe].type, effectcard[currentframe].name, effectcard[currentframe].action, effectcard[currentframe].score, effectcard[currentframe].special);
			effectcard[currentframe].type = "blank";
			effectcard[currentframe].name = "";
			effectcard[currentframe].action = "none";
			effectcard[currentframe].score = 0;
			effectcard[currentframe].special = "none";
		}
	}
	
	public static function getcurrentcardtype(t:Int):String {
		if(t==0){
		  return messagecard[currentframe].type;
		}else if(t==1){
		  return colourcard[currentframe].type;
		}else if(t==2){
		  return bordercard[currentframe].type;
		}else if(t==3){
		  return effectcard[currentframe].type;
		}
		return "blank";
	}
	
	public static function numcardsintab(t:Int):Int {
		return Control.deck[Control.deckindex.get(card_deck[t])].numcards;
	}
	
	public static function changeframe(t:Int):Void {
		if(currentframe!=t){
			currentframe = t;
			updateframe(t);
			changeframetext = false;
			
			if(!Gui.buttonexists("game_playout")){
				Gui.addbutton(Gfx.screenwidth - 75, Gfx.screenheight - 22, 70, 20, "DONE", "game_playout");
			}
		}
	}
	
	public static function updateframe(t:Int):Void {
		Control.frame[t].change(0, messagecard[t].name, Control.docolour(colourcard[t].action), Control.doborder(bordercard[t].action), Control.doeffect(effectcard[t].action));
		Control.frame[t].start(t);
	}
	
	public static function copyframecards(t:Int):Void {
		if (messagecard[t].type != "blank" && messagecard[t].action != "custommessage") {
			Control.deck[Control.currentdeck].copycard(messagecard[t].type, messagecard[t].name, messagecard[t].action, messagecard[t].score, messagecard[t].special);
		}
		if (colourcard[t].type != "blank") {
			Control.deck[Control.currentdeck].copycard(colourcard[t].type, colourcard[t].name, colourcard[t].action, colourcard[t].score, colourcard[t].special);
		}
		if (bordercard[t].type != "blank") {
			Control.deck[Control.currentdeck].copycard(bordercard[t].type, bordercard[t].name, bordercard[t].action, bordercard[t].score, bordercard[t].special);
		}
		if (effectcard[t].type != "blank") {
			Control.deck[Control.currentdeck].copycard(effectcard[t].type, effectcard[t].name, effectcard[t].action, effectcard[t].score, effectcard[t].special);
		}
	}
	
	public static function pickplayersigns():Void {
		//For testing: Automatically pick the best sign you can
		Control.cleardeck("message_playerdeck");
		Control.changedeck("message_playerdeck"); Control.changeotherdeck("playerdeck");
		Control.copy_all("message");	Control.sortbyscore();
		Control.keeptop(numplayerframes); Control.shuffledeck();
		
		Control.cleardeck("colour_playerdeck");
		Control.changedeck("colour_playerdeck"); Control.changeotherdeck("playerdeck");
		Control.copy_all("colour");	Control.sortbyscore();
		Control.keeptop(numplayerframes); Control.shuffledeck();
		
		Control.cleardeck("border_playerdeck");
		Control.changedeck("border_playerdeck"); Control.changeotherdeck("playerdeck");
		Control.copy_all("border");	Control.sortbyscore();
		Control.keeptop(numplayerframes); Control.shuffledeck();
		
		Control.cleardeck("effect_playerdeck");
		Control.changedeck("effect_playerdeck"); Control.changeotherdeck("playerdeck");
		Control.copy_all("effect");	Control.sortbyscore();
		Control.keeptop(numplayerframes); Control.shuffledeck();
		
		for (i in 0 ... numplayerframes) {
		  Control.changedeck("message_playerdeck");
			if (Control.deck[Control.currentdeck].numcards > i) {
				messagecard[i].copy(Control.deck[Control.currentdeck].card[i].type, Control.deck[Control.currentdeck].card[i].name, Control.deck[Control.currentdeck].card[i].action, Control.deck[Control.currentdeck].card[i].score, Control.deck[Control.currentdeck].card[i].special);
			}else {
				messagecard[i].type = "blank";
				messagecard[i].name = "";
				messagecard[i].action = "none";
				messagecard[i].score = 0;
				messagecard[i].special = "none";
			}
			
		  Control.changedeck("colour_playerdeck");
			if (Control.deck[Control.currentdeck].numcards > i) {
				colourcard[i].copy(Control.deck[Control.currentdeck].card[i].type, Control.deck[Control.currentdeck].card[i].name, Control.deck[Control.currentdeck].card[i].action, Control.deck[Control.currentdeck].card[i].score, Control.deck[Control.currentdeck].card[i].special);
		  }else {
				colourcard[i].type = "blank";
				colourcard[i].name = "";
				colourcard[i].action = "none";
				colourcard[i].score = 0;
				colourcard[i].special = "none";
			}
			
		  Control.changedeck("border_playerdeck");
			if (Control.deck[Control.currentdeck].numcards > i) {
				bordercard[i].copy(Control.deck[Control.currentdeck].card[i].type, Control.deck[Control.currentdeck].card[i].name, Control.deck[Control.currentdeck].card[i].action, Control.deck[Control.currentdeck].card[i].score, Control.deck[Control.currentdeck].card[i].special);
			}else{
				bordercard[i].type = "blank";
				bordercard[i].name = "";
				bordercard[i].action = "none";
				bordercard[i].score = 0;
				bordercard[i].special = "none";
			}
			
			
		  Control.changedeck("effect_playerdeck");
			if (Control.deck[Control.currentdeck].numcards > i) {
				effectcard[i].copy(Control.deck[Control.currentdeck].card[i].type, Control.deck[Control.currentdeck].card[i].name, Control.deck[Control.currentdeck].card[i].action, Control.deck[Control.currentdeck].card[i].score, Control.deck[Control.currentdeck].card[i].special);
			}else {				
				effectcard[i].type = "blank";
				effectcard[i].name = "";
				effectcard[i].action = "none";
				effectcard[i].score = 0;
				effectcard[i].special = "none";
			}
		}
		
		Control.changedeck("message_playerdeck"); 
		for (i in 0 ... Control.deck[Control.currentdeck].numcards)	Control.depreciate(i);
		Control.changedeck("colour_playerdeck"); 
		for (i in 0 ... Control.deck[Control.currentdeck].numcards)	Control.depreciate(i);
		Control.changedeck("border_playerdeck"); 
		for (i in 0 ... Control.deck[Control.currentdeck].numcards)	Control.depreciate(i);
		Control.changedeck("effect_playerdeck"); 
		for (i in 0 ... Control.deck[Control.currentdeck].numcards)	Control.depreciate(i);
		
	}
	
	public static function setupsigns():Void {
		//Set up a complete sign for the next phase
		
		//Jay first:
		Gfx.sign = 0;
		Control.frame[0].clear();
		for(i in 0...numplayerframes){
			Control.frame[0].add(messagecard[i].name, Control.docolour(colourcard[i].action), Control.doborder(bordercard[i].action), Control.doeffect(effectcard[i].action));
		}
		Control.frame[0].start(0);
		
		jaycardscore = 0;
		//trace("jay's score");
		for (i in 0...numplayerframes) {
			jaycardscore+= messagecard[i].score;
			//trace(messagecard[i].score);
			jaycardscore+= colourcard[i].score;
			//trace(colourcard[i].score);
			jaycardscore+= bordercard[i].score;
			//trace(bordercard[i].score);
			jaycardscore+= effectcard[i].score;
			//trace(effectcard[i].score);
		}
		
		//Then Filthy Burger... Right.
		//Maybe figure out how to do this tastefully in the future - for now, just create
		//decks of the most powerful cards, and randomise them.
		Control.cleardeck("message_playerdeck");
		Control.changedeck("message_playerdeck"); Control.changeotherdeck("enemydeck");
		Control.copy_all("message");	Control.sortbyscore();
		Control.keeptop(numenemyframes); Control.shuffledeck();
		
		Control.cleardeck("colour_playerdeck");
		Control.changedeck("colour_playerdeck"); Control.changeotherdeck("enemydeck");
		Control.copy_all("colour");	Control.sortbyscore();
		Control.keeptop(numenemyframes); Control.shuffledeck();
		
		Control.cleardeck("border_playerdeck");
		Control.changedeck("border_playerdeck"); Control.changeotherdeck("enemydeck");
		Control.copy_all("border");	Control.sortbyscore();
		Control.keeptop(numenemyframes); Control.shuffledeck();
		
		Control.cleardeck("effect_playerdeck");
		Control.changedeck("effect_playerdeck"); Control.changeotherdeck("enemydeck");
		Control.copy_all("effect");	Control.sortbyscore();
		Control.keeptop(numenemyframes); Control.shuffledeck();
		
		//Depreciate the enemy cards from the actual decks
		
		Control.changedeck("message_playerdeck"); 
		for (i in 0 ... Control.deck[Control.currentdeck].numcards)	Control.depreciate_enemy(i);
		Control.changedeck("colour_playerdeck"); 
		for (i in 0 ... Control.deck[Control.currentdeck].numcards)	Control.depreciate_enemy(i);
		Control.changedeck("border_playerdeck"); 
		for (i in 0 ... Control.deck[Control.currentdeck].numcards)	Control.depreciate_enemy(i);
		Control.changedeck("effect_playerdeck"); 
		for (i in 0 ... Control.deck[Control.currentdeck].numcards)	Control.depreciate_enemy(i);
		
		
		Gfx.sign = 1;
		fbcardscore = 0;
		Control.frame[1].clear();
		for (i in 0...numenemyframes) {
			Control.changedeck("message_playerdeck"); 
			if (Control.deck[Control.currentdeck].numcards > i) {
				tempfbmessage = Control.deck[Control.currentdeck].card[i].name;
				fbcardscore+= Control.deck[Control.deckindex.get("message_playerdeck")].card[i].score;
				//trace(Control.deck[Control.deckindex.get("message_playerdeck")].card[i].name, Control.deck[Control.deckindex.get("message_playerdeck")].card[i].score);
			}else{
				tempfbmessage = Control.randomsuggestions[Std.int(Math.random() * Control.numsuggestions)];
				//trace("0");
			}
			
			Control.changedeck("colour_playerdeck"); 
			if (Control.deck[Control.currentdeck].numcards > i) {
				tempfbcolour = Control.deck[Control.currentdeck].card[i].action;
				fbcardscore+= Control.deck[Control.deckindex.get("colour_playerdeck")].card[i].score;
				//trace(Control.deck[Control.deckindex.get("colour_playerdeck")].card[i].score);
			}else{
			  tempfbcolour = "white";
				//trace("0");
			}
			
			Control.changedeck("border_playerdeck"); 
			if (Control.deck[Control.currentdeck].numcards > i) {
				tempfbborder = Control.deck[Control.currentdeck].card[i].action;
				fbcardscore+= Control.deck[Control.deckindex.get("border_playerdeck")].card[i].score;
				//trace(Control.deck[Control.deckindex.get("border_playerdeck")].card[i].name, Control.deck[Control.deckindex.get("border_playerdeck")].card[i].score);
			}else{
				tempfbborder = "none";
				//trace("0");
			}
			
			Control.changedeck("effect_playerdeck"); 
			if (Control.deck[Control.currentdeck].numcards > i) {
				tempfbeffect = Control.deck[Control.currentdeck].card[i].action;
				fbcardscore+= Control.deck[Control.deckindex.get("effect_playerdeck")].card[i].score;
				//trace(Control.deck[Control.deckindex.get("effect_playerdeck")].card[i].name, Control.deck[Control.deckindex.get("effect_playerdeck")].card[i].score);
			}else{
				tempfbeffect = "none";
				//trace("0");
			}
			
			Control.frame[1].add(tempfbmessage, Control.docolour(tempfbcolour), Control.doborder(tempfbborder), Control.doeffect(tempfbeffect));
		}
		Control.frame[1].start(1);
	}
	
	public static var tempfbmessage:String;
	public static var tempfbcolour:String;
	public static var tempfbborder:String;
	public static var tempfbeffect:String;
	
	public static var jaycardscore:Int;
	public static var fbcardscore:Int;
	
	public static var numplayerframes:Int;
	public static var numenemyframes:Int;
	
	public static var currentframe:Int;
	public static var currenttab:Int;
	
	public static var tabsize:Int;
	public static var cardselection:Int;
	public static var finaltabselection:Int;
	public static var finalcardselection:Int;
	public static var tx:Int;
	public static var ty:Int;
	
	public static var card_back_red:Array<Int> = new Array<Int>();
	public static var card_back_green:Array<Int> = new Array<Int>();
	public static var card_back_blue:Array<Int> = new Array<Int>();
	
	public static var card_front_red:Array<Int> = new Array<Int>();
	public static var card_front_green:Array<Int> = new Array<Int>();
	public static var card_front_blue:Array<Int> = new Array<Int>();
	
	public static var card_name:Array<String> = new Array<String>();
	public static var card_deck:Array<String> = new Array<String>();
	public static var card_deck_width:Array<Int> = new Array<Int>();
	
	public static var messagecard:Array<Card> = new Array<Card>();
	public static var colourcard:Array<Card> = new Array<Card>();
	public static var bordercard:Array<Card> = new Array<Card>();
	public static var effectcard:Array<Card> = new Array<Card>();
	public static var newcard:Card = new Card();
	public static var swapincard:Card = new Card();
	
	public static var bordercolour1:Array<String> = new Array<String>();
	public static var bordercolour2:Array<String> = new Array<String>();
	
	public static var colourcolour1:Array<String> = new Array<String>();
	public static var colourcolour2:Array<String> = new Array<String>();
	
	public static var changeframetext:Bool;
	
	public static var numcustommessages:Int;
}