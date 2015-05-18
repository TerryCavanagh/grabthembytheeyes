package gamecontrol;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;
import com.terry.*;
import com.terry.util.*;
import haxe.crypto.Base64;

class Control {
	public static function init():Void {
		for (i in 0...Gfx.totalsigns) {
			finishedscrolling.push(false);
	    scrolldelay.push(0);
			textposition.push(0);
	    textsize.push(0);
	    currenttext.push("");
	    effect.push("none");
	    effectstate.push(0);
			effectdelay.push(0);
			effectintro.push(false);
			currentframe.push(0);
			frame.push(new Frame());
		}
		
		for (i in 0...5) {
			ai_score.push(0);
		}
		
		Customercontrol.init();
		
		dayname.push("TUESDAY");
		dayname.push("WEDNESDAY");
		dayname.push("THURSDAY");
		dayname.push("FRIDAY");
		dayname.push("SATURDAY");
		dayname.push("SUNDAY");
		
		for(i in 0...6){
			dayscore_fb.push(0);
			dayscore_jay.push(0);
		}
		
		totalscore_fb = 0; totalscore_jay = 0;
		
		zoomout();
		
		addsuggestion("this. sick. meat.");
		addsuggestion("I will make you full");
		
		addsuggestion("what you crave");
		addsuggestion("give in to your desire");
		addsuggestion("hunger no more");
		addsuggestion("we have what you seek");
		addsuggestion("food");
		
		addsuggestion("salvation");
		addsuggestion("you cannot fight it any longer");
		addsuggestion("hope");
		addsuggestion("best food on this street");
		addsuggestion("you require sustenance");
		
		addsuggestion("tasty");
		addsuggestion("we are different");
		addsuggestion("fish and also chips");
		addsuggestion("hot-dogs");
		addsuggestion("burgers");
		
		addsuggestion("kebabs");
		addsuggestion("bagels");
		addsuggestion("give in");
		addsuggestion("surrender");
		addsuggestion("let go");
		
		addsuggestion("food guaranteed within sell-by date");
		addsuggestion("all other food stands are terrible");
		addsuggestion("let me feed you");
		addsuggestion("don't eat that - eat this");
		addsuggestion("we are the world's greatest");
		
		addsuggestion("highly regarded by many");
		addsuggestion("\"not bad\" says famous critic");
		addsuggestion("you will never feel hunger again");
		addsuggestion("this ends here. have a burger");
		
		addsuggestion("please listen");
		addsuggestion("pay attention to me");
		addsuggestion("I want you to see me");
		addsuggestion("#yummy");
		addsuggestion("delicious");
		
		addsuggestion("please eat");
		addsuggestion("perfectly hygienic burgers");
		
		addsuggestion("edible food");
		addsuggestion("consume");
		addsuggestion("do not eat elsewhere");
		addsuggestion("we want what is best for you");
		addsuggestion("pretzels");
		addsuggestion("your tongue longs for mustard");
		addsuggestion("your moment approaches");
		addsuggestion("eat happy memories");
		
		addsuggestion("cherish me");
		
		addsuggestion("why eat anywhere else? why?");
		
		initcards();
		
		Savecookie.init();
	}
	
	public static function initcards():Void {
		for (i in 0...15) {
			deck.push(new Deck());
		}
		
		deck[0].masterdeck();
		deckindex.set("masterdeck", 0);	
		deckindex.set("playerdeck", 1);	
		deckindex.set("enemydeck", 2);
		deckindex.set("shopdeck", 3);
		deckindex.set("message_gamedeck", 4);
		deckindex.set("colour_gamedeck", 5);
		deckindex.set("border_gamedeck", 6);
		deckindex.set("effect_gamedeck", 7);
		deckindex.set("extraframe_gamedeck", 8);
		deckindex.set("workingdeck", 9);
		deckindex.set("message_playerdeck", 10);
		deckindex.set("colour_playerdeck", 11);
		deckindex.set("border_playerdeck", 12);
		deckindex.set("effect_playerdeck", 13);
		deckindex.set("daydeck", 14);
	}
	
	public static function makenewgamedeck():Void {
		//Make a deck of message cards, excluding the interesting ones for turn one
		cleardeck("workingdeck");
		
		changedeck("workingdeck"); changeotherdeck("masterdeck");
		
		copy_all("message");
		
		remove("Eat at");
		remove("Jay's");
		remove("Filthy");
		remove("Burger");
		remove("Jay Sucks");
		remove("Filthy Burger is literally filthy");
		shuffledeck();
		
		changedeck("message_gamedeck"); changeotherdeck("workingdeck");
		cleardeck("message_gamedeck");
		copytop(15);
		shuffledeck();
		
		changedeck("colour_gamedeck"); changeotherdeck("masterdeck");
		cleardeck("colour_gamedeck");
		copy_all("colour");
		remove("simple");
		remove("flash");
		shuffledeck();
		
		changedeck("border_gamedeck"); changeotherdeck("masterdeck");
		cleardeck("border_gamedeck");
		copy_all("border");
		//remove("simple");
		shuffledeck();
		
		changedeck("effect_gamedeck"); changeotherdeck("masterdeck");
		cleardeck("effect_gamedeck");
		copy_all("effect");
		shuffledeck();
		
		changedeck("extraframe_gamedeck"); changeotherdeck("masterdeck");
		cleardeck("extraframe_gamedeck");
		copy_all("extraframe");
		shuffledeck();
		
		//gamedecks now contains a complete deck, set up for turn one!
	}
	
	public static function specialcards():Void {
		//Fix special cards to be worthless if they're in the correct hands
		changedeck("playerdeck");
		knockdown("filthyburgeronly");
		
		changedeck("enemydeck");
		knockdown("jayonly");
	}
	
	public static function adddefaultcards():Void {
		//Add the default player cards before the first editor phase
		changedeck("playerdeck"); changeotherdeck("masterdeck");
		copy("Eat at", "message");
		copy("Jay's", "message");
		
		changedeck("enemydeck"); changeotherdeck("masterdeck");
		copy("Filthy", "message");
		copy("Burger", "message");
		copy("flash", "colour");
	}
	
	public static function updateforturntwo():Void {
		//Throw in the extra message cards to the game deck now
		changedeck("message_gamedeck"); changeotherdeck("masterdeck");
		copy("Jay Sucks", "message");
		copy("Filthy Burger is literally filthy", "message");
		shuffledeck();
	}
	
	public static function newshop(trn:Int):Void {
		if (trn == 2) {
			updateforturntwo();
		}
		
		changedeck("daydeck");
		cleardeck("daydeck");
		
		changedeck("shopdeck"); 
		cleardeck("shopdeck");
		switch(trn) {
			case 1:
				changeotherdeck("message_gamedeck"); boostdeal(3);
				changeotherdeck("colour_gamedeck"); deal(2);
			case 2:
				changeotherdeck("message_gamedeck"); boostdeal(3);
				changeotherdeck("border_gamedeck"); deal(2);
				changeotherdeck("extraframe_gamedeck"); deal(1);
			case 3:
				changeotherdeck("message_gamedeck"); boostdeal(2);
				changeotherdeck("colour_gamedeck"); deal(1);
				changeotherdeck("border_gamedeck"); deal(2);
				changeotherdeck("effect_gamedeck"); deal(2);
			case 4:
				changeotherdeck("message_gamedeck"); boostdeal(2);
				changeotherdeck("colour_gamedeck"); deal(1);
				changeotherdeck("border_gamedeck"); deal(1);
				changeotherdeck("effect_gamedeck"); deal(2);
				changeotherdeck("extraframe_gamedeck"); deal(1);
			case 5:
				changeotherdeck("message_gamedeck"); boostdeal(1);
				changeotherdeck("colour_gamedeck"); deal(2);
				changeotherdeck("border_gamedeck"); deal(1);
				changeotherdeck("effect_gamedeck"); deal(2);
				changeotherdeck("extraframe_gamedeck"); deal(1);
			case 6:
				changeotherdeck("message_gamedeck"); boostdeal(2);
				changeotherdeck("border_gamedeck"); deal(1);
				changeotherdeck("effect_gamedeck"); deal(2);
		}
		
		shuffledeck();
		/*
		trace("");
		trace("SHOP DECK ON TURN " + Std.string(turn));
		trace("=-=-=-=-=-=-=-=-=-=-=-=-=-");
		debuglist("shopdeck");*/
	}
	
	public static function deal(t:Int):Void {
		//Deal t cards from otherdeck to current deck. Deal means delete from the otherdeck
		copytop(t);
		deck[otherdeck].deletetop(t);
	}
	
	public static function boostdeal(t:Int):Void {
		//Deal t cards from otherdeck to current deck. Deal means delete from the otherdeck
		//Randomlly give one of them an extra point; for boosting message cards
		var r:Int = Random.int(0, t - 1);
		if (deck[otherdeck].card[r].score < 5) deck[otherdeck].card[r].score++;
		
		copytop(t);
		deck[otherdeck].deletetop(t);
	}
	
	public static function knockdown(t:String):Void {
		//If the current deck contains a card with the special value t, knock it down to zero!
		for (i in 0...deck[currentdeck].numcards) {
			if (deck[currentdeck].card[i].special == t) {
				deck[currentdeck].card[i].score = 0;
			}
		}
	}
	
	public static function copybyindex(i:Int):Void {
		//Copy the ith card over
		deck[currentdeck].copycard(deck[otherdeck].card[i].type, deck[otherdeck].card[i].name, deck[otherdeck].card[i].action, deck[otherdeck].card[i].score, deck[otherdeck].card[i].special);
	}
	
	public static function copytop(t:Int):Void {
		//Copy the top t cards from other deck to currentdeck.
		for (i in 0...t) {
			deck[currentdeck].copycard(deck[otherdeck].card[i].type, deck[otherdeck].card[i].name, deck[otherdeck].card[i].action, deck[otherdeck].card[i].score, deck[otherdeck].card[i].special);
		}
	}
	
	public static function extraframesin(t:String):Int {
		//How many extraframe cards are in deck t?
		var n:Int = 0;
		var cdeck:Int = deckindex.get(t);
		for (i in 0 ... deck[cdeck].numcards) {
			if (deck[cdeck].card[i].type == "extraframe") n++;
		}
		return n;
	}
	
	public static function leastof(t:String):String {
		//Which setting type does deck t contain the least of?
		var ncol:Int = 0;
		var nbor:Int = 0;
		var neff:Int = 0;
		var cdeck:Int = deckindex.get(t);
		
		for (i in 0 ... deck[cdeck].numcards) {
			if (deck[cdeck].card[i].type == "colour") ncol++;
			if (deck[cdeck].card[i].type == "border") nbor++;
			if (deck[cdeck].card[i].type == "effect") neff++;
		}
		
		if (ncol <= nbor && ncol <= neff) {
			return "colour";
		}else if (nbor <= ncol && nbor <= neff) {
			return "border";
		}else if (neff <= nbor && neff <= ncol) {
			return "effect";
		}
		return "colour";
	}
	
	public static function shuffledeck():Void {
		for (i in 0...deck[currentdeck].numcards) {
			var j = Math.floor((((deck[currentdeck].numcards - 1) + 1) * Math.random()));
			deck[currentdeck].swapcards(i, j);
		}
	}
	
	public static function sortbyscore():Void {
		//Sort the currentdeck, putting the highest scoring things on top!
		for (i in 0 ... deck[currentdeck].numcards) {
			for (j in i ... deck[currentdeck].numcards) {
				if (deck[currentdeck].card[i].score < deck[currentdeck].card[j].score) {
					deck[currentdeck].swapcards(i, j);
				}
			}
		}
	}
	
	public static function debuglist(t:String):Void {
		for (i in 0...deck[deckindex.get(t)].numcards) {
			trace(deck[deckindex.get(t)].card[i].score, deck[deckindex.get(t)].card[i].type, deck[deckindex.get(t)].card[i].name);
		}
	}
	
	public static function cleardeck(t:String):Void {
		deck[deckindex.get(t)].numcards = 0;
	}
	
	public static function keeptop(t:Int):Void {
		if (deck[currentdeck].numcards > t) deck[currentdeck].numcards = t;
	}
	
	public static function depreciate(t:Int):Void {
		//Ok: t is the index of a card in our working deck. Find this card in the real game
		//deck, and take one from it's score.
		Control.changeotherdeck("playerdeck");
		for (i in 0 ... deck[otherdeck].numcards) {
			if (deck[currentdeck].card[t].action == deck[otherdeck].card[i].action) {
				if (deck[currentdeck].card[t].name == deck[otherdeck].card[i].name) {
					if (deck[otherdeck].card[i].score > 1) {
						deck[otherdeck].card[i].score--;
					}
				}
			}
		}
	}
	
	public static function depreciate_enemy(t:Int):Void {
		//Ok: t is the index of a card in our working deck. Find this card in the real game
		//deck, and take one from it's score.
		Control.changeotherdeck("enemydeck");
		for (i in 0 ... deck[otherdeck].numcards) {
			if (deck[currentdeck].card[t].action == deck[otherdeck].card[i].action) {
				if (deck[currentdeck].card[t].name == deck[otherdeck].card[i].name) {
					if (deck[otherdeck].card[i].score > 1) {
						deck[otherdeck].card[i].score--;
					}
				}
			}
		}
	}
	
	public static function copy_all(t:String):Void {
		//Copy all cards of type t to the current deck.
		for (i in 0...deck[otherdeck].numcards) {
			if (deck[otherdeck].card[i].type == t) {
				deck[currentdeck].copycard(deck[otherdeck].card[i].type, deck[otherdeck].card[i].name, deck[otherdeck].card[i].action, deck[otherdeck].card[i].score, deck[otherdeck].card[i].special);
			}
		}
	}
	
	public static function copy(t:String, type:String):Void {
		//Copy a single named card to the current deck
		t = t.toUpperCase() + "_" + type.toUpperCase();
		var i:Int = deck[otherdeck].cardindex.get(t.toUpperCase());
		deck[currentdeck].copycard(deck[otherdeck].card[i].type, deck[otherdeck].card[i].name, deck[otherdeck].card[i].action, deck[otherdeck].card[i].score, deck[otherdeck].card[i].special);
	}
	
	public static function remove(t:String):Void {
		//Remove a card from our current deck
		deck[currentdeck].removecard(t.toUpperCase());
	}
	
	public static function removebyindex(i:Int):Void {
		//Remove a card from our current deck
		deck[currentdeck].removecardbyindex(i);
	}
	
	public static function changedeck(t:String):Void {
		currentdeck = deckindex.get(t);
	}
	
	public static function changeotherdeck(t:String):Void {
		otherdeck = deckindex.get(t);
		
	}
	public static function start(t:Int):Void {
		//Init game state from position t
		switch(t) {
			case 0:
				titlesign();
				
				//currentscreen = "wip";
				//Gui.addbutton(Gfx.screenwidthmid - 100, 160, 200, 20, "OK, terry, jeez", "gotomenu");
				
				currentscreen = "intro";
				Gui.addbutton(Gfx.screenwidthmid - 20, 160, 40, 20, "OK", "gotomenu");
				
		}
	}
	
	public static function titlesign():Void {				
		Control.frame[0].clear();
		Control.frame[0].add("grab", "gradient", "none", "bob");
		Control.frame[0].start(0);
		
		Control.frame[1].clear();
		Control.frame[1].add("them", "blue-white_stripe", "none", "bob");
		Control.frame[1].start(1);
		
		Control.frame[2].clear();
		Control.frame[2].add("by the", "white-red_flicker", "none", "pixel");
		Control.frame[2].start(2);
		textsize[2] = Def.BYTHE;
		
		Control.frame[3].clear();
		Control.frame[3].add("eyes", "white-red_flicker", "none", "teleport");
		Control.frame[3].start(3);
		
		Gfx.numsigns = 4;
	}
	
	public static function fadelogic():Void {
		if (Gfx.fademode == Def.FADED_OUT && !Game.running) {
			if (Gfx.fadeaction == "titlescreen") {
				Gfx.fademode = Def.FADE_IN; Gfx.fadeaction = "nothing";
				
				titlesign();
				frame[0].start(0);
				currentscreen = "menu";
				Gui.deleteall("normal");
				Gui.deleteall("flashing");
				Gui.deleteall("tiny");
				for (i in 0 ... Obj.nentity) {
					Obj.entities[i].active = false;
				}
				Obj.nentity = 0;
				
				gameoverbanner = false;
				gameoverbannerposition = 0;
				gameovershowbutton = false;
				supersign = false;
				
				if (Savecookie.saveexists == 1 && Savecookie.saveday - 1 >= 0) {
					Gui.addbutton(Gfx.screenwidthmid - 110, 140, 220, 20, "Start New Game", "startgame");
					Gui.addbutton(Gfx.screenwidthmid - 110, 170, 220, 20, "Load from " + dayname[Savecookie.saveday - 1], "loadgame");
					Gui.addbutton(Gfx.screenwidthmid - 110, 200, 220, 20, "Create a sign", "editor");
				}else{
					Gui.addbutton(Gfx.screenwidthmid - 110, 160, 220, 20, "Start New Game", "startgame");
					Gui.addbutton(Gfx.screenwidthmid - 110, 190, 220, 20, "Create a sign", "editor");
				}
				
				//Gui.addbutton(Gfx.screenwidthmid - 120, 160, 240, 60, "testing stuff", "game_editor");
			}else if (Gfx.fadeaction == "startgame") {
				//Music.play("silence");
				Gfx.fademode = Def.FADE_IN; Gfx.fadeaction = "nothing";
				
				Control.currentscreen = "startgame";
				Gui.buttonkludge = true;
				Gui.deleteall("normal");
				
				newgame();
				
				//Testing scripts
				//Script.load("tieending");
				//Script.load("supersigntest");
				
				//Actual intro:
				//-------
			  Script.load("intro");
				Gui.addbutton(Gfx.screenwidth - 44, 4, 40, 12, "SKIP >>", "skipintro", "tiny");
			}else if (Gfx.fadeaction == "loadgame") {
				//Music.play("silence");
				Gfx.fadeaction = "nothing";
				Gui.buttonkludge = true;
				Gui.deleteall("normal");
				
				loadgame();
				day--;
				
			  Gfx.fadeaction = "nothing";
				carddepphase = false;
				scene = "outsideshop";
				currentscreen = "game_newday";
			  Script.load("newday_loaded");
			}else if (Gfx.fadeaction == "starteditor") {
				//Music.play("silence");
				Gfx.fademode = Def.FADE_IN; Gfx.fadeaction = "nothing";
				Control.currentscreen = "editor";
				Gui.buttonkludge = true;
				Gui.deleteall("normal");
				Control.guitab = "message";
				
				Control.starteditmode();
			}else if (Gfx.fadeaction == "playout") {
				Gfx.fademode = Def.FADE_IN; Gfx.fadeaction = "nothing";
				Edphase.setupsigns();
				Control.currentscreen = "game_playout";
				Gui.buttonkludge = true;
				Gui.deleteall("normal");
				Gui.deleteall("colour");
				
			  Script.load("playout");
				
				//Gui.addbutton(Gfx.screenwidthmid - 100, 140, 200, 20, "Next", "game_result");
			}else if (Gfx.fadeaction == "carddep") {
				Gfx.fademode = Def.FADE_IN; Gfx.fadeaction = "nothing";
				currentscreen = "game_carddep";
				changecarddepstate("start");
				Customercontrol.customerphase = false;
				carddepphase = true;
				//Gui.addbutton(Gfx.screenwidthmid - 100, 140, 200, 20, "Next", "game_result");
			}else if (Gfx.fadeaction == "game_newday") {
			  Gfx.fadeaction = "nothing";
				carddepphase = false;
				scene = "outsideshop";
				currentscreen = "game_newday";
			  Script.load("newday");
		  }else if (Gfx.fadeaction == "doending") {
				/*
				Gfx.fademode = Def.FADE_IN; Gfx.fadeaction = "nothing";
				currentscreen = "game_complete";
				Customercontrol.customerphase = false;
				Savecookie.deletesave();
				
				Gui.addbutton(Gfx.screenwidthmid - 100, 200, 200, 20, "Next", "gotomenu");
				*/
				Gfx.fadeaction = "nothing";
				carddepphase = false;
				scene = "outsideshop";
				currentscreen = "game_newday";
				Savecookie.deletesave();
				
				if (Control.totalscore_fb == Control.totalscore_jay) {
					//Huh, weird
					Script.load("tieending");	
				}else if (Control.totalscore_fb >= Control.totalscore_jay) {
					Script.load("badending");	
				}else {
					Script.load("goodending");	
				}
			}else{
				Gfx.fademode = Def.FADE_IN; Gfx.fadeaction = "nothing";
			}
		}
	}
	
	public static function persondir(t:String):Int {
		if (t == "up") return 2;
		if (t == "left") return 1;
		if (t == "right") return 0;
		return 0;
	}
	
	public static var p:Point = new Point();
	public static function getposition(t:String):Point {
		p.setTo(0, 0);
		switch(t) {
		  case "jaycart":
				p.setTo( 72, 14);
		  case "jaycartleft":
				p.setTo( 8, 14);
		  case "jaycartright":
				p.setTo( 136, 14);
		  case "hipstercart":
				p.setTo( 282, 14);
		  case "hipstercartleft":
				p.setTo( 282 - 74, 14);
		  case "hipstercartright":
				p.setTo( 282 + 74, 14);
			case "jaycart_front":
				p.setTo( 72, 62); 
		  case "jaycartleft_front":
				p.setTo( 8, 62);
		  case "jaycartmidleft_front":
				p.setTo( 8+26, 62);
		  case "jaycartright_front":
				p.setTo( 136, 62);
		  case "hipstercart_front":
				p.setTo( 282, 62);
		  case "hipstercartleft_front":
				p.setTo( 282 - 74, 62);
			case "hipstercartmidright_front":
				p.setTo( 282 + 74-37, 62);
		  case "hipstercartright_front":
				p.setTo( 282 + 74, 62);
		  case "shopkeepcart":
				p.setTo( 182-8, 14);
		  case "left": 
				p.setTo( -128, 62); //
			case "centerleft":
				p.setTo(192-48, 62); //
			case "middlejay":
				p.setTo(180, 62); //
			case "middlejay_front":
				p.setTo(180, 58); //
			case "middlejayleft_front":
				p.setTo(180-64, 58); //
			case "middlejayright_front":
				p.setTo(180+64, 58); //
			case "topjay":
				p.setTo(180, -180); //
			case "bottomjay":
				p.setTo(180, 180); //
			case "bottomhipsters":
				p.setTo(182-6, 180); //
			case "middlehipsters_front":
				p.setTo(182-6, 80); //
			case "middlehipsters":
				p.setTo(182-6, 62); //
			case "tophipsters":
				p.setTo(182-6, -180); //
			case "middle":
				p.setTo(192, 62); //
			case "top":
				p.setTo(192, -180); //
			case "centerright":
				p.setTo(192+48, 62); //
			case "right":
				p.setTo(520, 62);
			case "rightofcart":
				p.setTo(640, 62);
			case "introcartposition":
				p.setTo(220, 62);
			case "introcartposition_right":
				p.setTo(340, 62);
			case "introcartposition_back":
				p.setTo(220, 14);
			case "introcartposition_right_back":
				p.setTo(340, 14);
			case "cameracenter":
				p.setTo(192, 120); //
			case "cameraleft":
				p.setTo(96, 120); //
			case "cameraright":
				p.setTo(288, 120); //
			case "shopright":
				p.setTo(520, 62);
			case "shop_front":
				p.setTo(226, 62);
			case "shop_enter":
				p.setTo(226, 22);
			case "camerashop":
				p.setTo(96, 60);			
			case "inshop_right":
				p.setTo(160+32, -20);				
			case "inshop_left":
				p.setTo(-50, -20);				
			case "inshop_hipstersattill":
				p.setTo(60, -20);					
			case "inshop_attill":
				p.setTo(80, -20);				
			case "inshop_jayinqueue":
				p.setTo(15, -20);					
			case "inshop_inqueue":
				p.setTo(25, -20);		
			case "inshop_shopkeep":
				p.setTo(160, -20);
		}
		return p;
	}
	
	public static function changecurrenttext(t:String):Void {
		currenttext[Gfx.sign] = t.toUpperCase();
		if (Text.len(currenttext[Gfx.sign], 2) <= 48) {
			textsize[Gfx.sign] = Def.BIG;
			finishedscrolling[Gfx.sign] = true;
		}else if (Text.len(currenttext[Gfx.sign], 1) <= 48) {
			textsize[Gfx.sign] = Def.TALL;
			finishedscrolling[Gfx.sign] = true;
		}else {
			finishedscrolling[Gfx.sign] = false;
			textsize[Gfx.sign] = Def.SCROLL;
			textposition[Gfx.sign] = 0;
			scrolldelay[Gfx.sign] = 45;
		}
	}
	
	public static function changeeffect(t:String):Void {
		effect[Gfx.sign] = t;
		effectstate[Gfx.sign] = 0;
		effectdelay[Gfx.sign] = 0;
		effectintro[Gfx.sign] = false;
		
		updateeffect();
	}
	
	public static function updateeffect():Void {
		if (effectdelay[Gfx.sign] <= 0) {
			if (effect[Gfx.sign] == "none") {
				effectintro[Gfx.sign] = true;
			}else if (effect[Gfx.sign] == "dropin" || effect[Gfx.sign] == "split") {
				effectstate[Gfx.sign] = effectstate[Gfx.sign]+1;
				effectdelay[Gfx.sign] = 4;
				if (effectstate[Gfx.sign] >= 20) {
					effectstate[Gfx.sign] = 20;
					effectintro[Gfx.sign] = true;
				}else {
					scrolldelay[Gfx.sign] += 4;
				}
			}else if (effect[Gfx.sign] == "zoomin") {
				effectstate[Gfx.sign] = effectstate[Gfx.sign]+1;
				effectdelay[Gfx.sign] = 2;
				if (effectstate[Gfx.sign] >= 8) {
					effectstate[Gfx.sign] = 8;
					effectintro[Gfx.sign] = true;
				}else {
					scrolldelay[Gfx.sign] += 2;
				}
			}else if (effect[Gfx.sign] == "teleport") {
				effectstate[Gfx.sign] = effectstate[Gfx.sign]+1;
				effectdelay[Gfx.sign] = 2;
				if (effectstate[Gfx.sign] >= 48) {
					effectstate[Gfx.sign] = 48;
					effectintro[Gfx.sign] = true;
				}else {
					scrolldelay[Gfx.sign] += 2;
				}
			}else if (effect[Gfx.sign] == "pixel") {
				effectstate[Gfx.sign] = effectstate[Gfx.sign] + 1;
				if (effectstate[Gfx.sign] < 4) effectstate[Gfx.sign] = 4;
				effectdelay[Gfx.sign] = 16;
				if (effectstate[Gfx.sign] >= 16) {
					effectstate[Gfx.sign] = 16;
					effectintro[Gfx.sign] = true;
				}else {
					scrolldelay[Gfx.sign] += 16;
				}
			}else if (effect[Gfx.sign] == "bob") {
				effectstate[Gfx.sign] = (effectstate[Gfx.sign]+1) % 8;
				effectdelay[Gfx.sign] = 4;
				effectintro[Gfx.sign] = true;
			}else if (effect[Gfx.sign] == "midsplit") {
				effectstate[Gfx.sign] = effectstate[Gfx.sign]+1;
				effectdelay[Gfx.sign] = 4;
				if (effectstate[Gfx.sign] >= 10) {
					effectstate[Gfx.sign] = 10;
					effectintro[Gfx.sign] = true;
				}else {
					scrolldelay[Gfx.sign] += 4;
				}
			}else if (effect[Gfx.sign] == "invert") {
				effectstate[Gfx.sign] = (effectstate[Gfx.sign]+1) % 2;
				effectdelay[Gfx.sign] = 12;
				effectintro[Gfx.sign] = true;
			}else if (effect[Gfx.sign] == "shake") {
				effectstate[Gfx.sign] = (effectstate[Gfx.sign]+1) % 8;
				effectdelay[Gfx.sign] = 4;
				effectintro[Gfx.sign] = true;
			}else if (effect[Gfx.sign] == "special_plasma") {
				effectstate[Gfx.sign]++;
				effectintro[Gfx.sign] = true;
			}else if (effect[Gfx.sign] == "special_fadein") {
				effectstate[Gfx.sign]++;
				if(effectstate[Gfx.sign]>=48){
					frame[Gfx.sign].delay = 0;
				}
				effectintro[Gfx.sign] = true;
			}else if (effect[Gfx.sign] == "special_randomgradient") {
				effectstate[Gfx.sign]++;
				if(effectstate[Gfx.sign]>=48){
					frame[Gfx.sign].delay = 0;
				}
				effectintro[Gfx.sign] = true;
			}else if (effect[Gfx.sign] == "special_static") {
				effectstate[Gfx.sign]++;
				if(effectstate[Gfx.sign]>=64){
					frame[Gfx.sign].delay = 0;
				}
				effectintro[Gfx.sign] = true;
			}else {
				effectstate[Gfx.sign]++;
				effectintro[Gfx.sign] = true;
			}
		}else {
			effectdelay[Gfx.sign]--;
		}
	}
	
	public static function createsupersign():Void {
		Gfx.sign = 0;
		Control.frame[0].clear();
		/*
		Control.frame[0].add("PREPARE", "white", "none", "special_rocket");
		Control.frame[0].add("PREPARE", "white", "none", "special_randomgradient");
		Control.frame[0].add("PREPARE", "white", "none", "special_biggradient");
		Control.frame[0].add("PREPARE", "white", "none", "special_otherbiggradient");
		Control.frame[0].add(" ", "white", "none", "special_static");
		Control.frame[0].add(" ", "white", "none", "special_bouncingbox");
		Control.frame[0].add(" ", "white", "none", "special_tunnel");
		Control.frame[0].add(" ", "white", "none", "special_plasma");
		Control.frame[0].add(" ", "white", "none", "special_explode");
		*/
		Control.frame[0].add(" ", "white", "none", "special_static");
		Control.frame[0].add(" ", "white", "none", "special_explode");
		Control.frame[0].add("PREPARE", "white", "none", "special_fadein");
		Control.frame[0].add("YOURSELF", "white", "none", "special_fadein");
		Control.frame[0].add("FOR THE", "white", "none", "special_fadein");
		Control.frame[0].add("GREATEST", "white", "none", "special_fadein");
		Control.frame[0].add("SIGNS", "white", "none", "special_randomgradient");
		Control.frame[0].add("IN THE", "white", "none", "special_randomgradient");
		Control.frame[0].add("WORLD", "white", "none", "special_randomgradient");
		Control.frame[0].add(" ", "white", "none", "special_tunnel");
		Control.frame[0].add("GET ONE TODAY", "white", "none", "special_biggradient");
		Control.frame[0].add("MAKE YOUR LIFE COMPLETE", "white", "none", "special_otherbiggradient");
		Control.frame[0].add(" ", "white", "none", "special_plasma");
		Control.frame[0].add("AL'S QUALITY SIGNS", "white", "none", "none");
		Control.frame[0].add("", "white", "none", "special_rocket");
		Control.frame[0].start(0);
		
		Control.supersign = true;
	}
	
	public static function updatescrolling(i:Int):Void {
		if (Control.textsize[i] == Def.SCROLL) {
			if (Control.scrolldelay[i] <= 0) {
				if (!Control.finishedscrolling[i]) {
					Control.textposition[i]++;
					Control.scrolldelay[i] = 1;
					
					if (Control.textposition[i] + 48 - 4 >= Text.len(Control.currenttext[i])) {
						Control.finishedscrolling[i] = true;
					}
				}
			}else{
				Control.scrolldelay[i]--;
			}
		}
	}
	
	public static function updatesigns(i:Int):Void {
		Gfx.sign = i;
		
		Gfx.updatecolour();
		Gfx.updateborder();
		updateeffect();
		updatescrolling(i);
		
		if (finishedscrolling[i] && effectintro[i]) {
			frame[i].delay--;
			if (frame[i].delay <= 0) {
				if (editmode) {
				  frame[i].repeat(i);
				}else {
					if (frame[i].getlength() == 1 && Control.textsize[i] != Def.SCROLL) {
						frame[i].delay = Control.waittime;
					}else{
						frame[i].next(i);
					}
				}
			}
		}
	}
	
	public static var finishedscrolling:Array<Bool> = new Array<Bool>();
	public static var scrolldelay:Array<Int> = new Array<Int>();
	
	public static var textposition:Array<Int> = new Array<Int>();
	public static var textsize:Array<Int> = new Array<Int>();
	public static var currenttext:Array<String> = new Array<String>();
	
	public static var effect:Array<String> = new Array<String>();
	public static var effectstate:Array<Int> = new Array<Int>();
	public static var effectdelay:Array<Int> = new Array<Int>();
	public static var effectintro:Array<Bool> = new Array<Bool>();
	
	public static var currentframe:Array<Int> = new Array<Int>();
	public static var frame:Array<Frame> = new Array<Frame>();
	public static var waittime:Int = 180;
	
	//Gui stuff
	public static function convertcolourtoaction(t:String):Void {
		//Given an internal colour string, convert it to action strings and colours.
		var tempstring:String = Help.getbranch(t, "_");
		if (tempstring== "flicker") {
			guicol1 = Help.getroot(t, "-");
			guicol2 = Help.getroot(Help.getbranch(t, "-"), "_");
			guicol = "colour_flicker";
		}else if (tempstring == "stripe") {
			guicol1 = Help.getroot(t, "-");
			guicol2 = Help.getroot(Help.getbranch(t, "-"), "_");
			guicol = "colour_stripe";
		}else if (tempstring == "flash") {
			guicol = "colour_flash";
			guicol1 = Help.getroot(t, "_");
		}else if (tempstring == "fire") {
			guicol = "colour_fire";
			guicol1 = Help.getroot(t, "_");
		}else if (t == "gradient") {
			guicol = "colour_gradient";
		}else if (t == "slow_cycle") {
			guicol = "colour_slowcycle";
		}else if (t == "fast_cycle") {
			guicol = "colour_fastcycle";
		}else if (t == "white") {
			guicol = "colour_simple"; guicol1 = "white";
		}else if (t == "red") {
			guicol = "colour_simple"; guicol1 = "red";
		}else if (t == "green") {
			guicol = "colour_simple"; guicol1 = "green";
		}else if (t == "blue") {
			guicol = "colour_simple"; guicol1 = "blue";
		}
		
		if (guicol2 == guicol1) {
			if (guicol1 == "white") {
				guicol2 = "red";
			}else {
				guicol2 = "white";
			}
		}
	}
	
	public static function convertbordertoaction(t:String):Void {
		//Given an internal border string, convert it to action strings and colours.
		var tempstring:String = Help.getbranch(t, "_");
		if (tempstring== "alternate") {
			guibordercol1 = Help.getroot(t, "-");
			guibordercol2 = Help.getroot(Help.getbranch(t, "-"), "_");
			guiborder = "border_alternate";
		}else if (tempstring== "particles") {
			guibordercol1 = Help.getroot(t, "-");
			guibordercol2 = Help.getroot(Help.getbranch(t, "-"), "_");
			guiborder = "border_particles";
		}else if (tempstring == "gap") {
			guiborder = "border_gap";
			guibordercol1 = Help.getroot(t, "_");
		}else if (tempstring == "flash") {
			guiborder = "border_flash";
			guibordercol1 = Help.getroot(t, "_");
		}else if (tempstring == "flicker") {
			guiborder = "border_flicker";
			guibordercol1 = Help.getroot(t, "_");
		}else if (tempstring == "none") {
			guiborder = "border_none";
		}else if (tempstring == "gradient") {
			guiborder = "border_gradient1";
		}else if (tempstring == "longgradient") {
			guiborder = "border_gradient2";
		}
		
		if (guibordercol2 == guibordercol1) {
			if (guibordercol1 == "white") {
				guibordercol2 = "red";
			}else {
				guibordercol2 = "white";
			}
		}
	}
	
	public static function converteffecttoaction(t:String):Void {
		//Given an internal effect string, convert it to action strings and colours.
		if (t == "none") {
			guieffect = "effect_none";
		}else if (t == "dropin") {
			guieffect = "effect_dropin";
		}else if (t == "split") {
			guieffect = "effect_split";
		}else if (t == "zoomin") {
			guieffect = "effect_zoomin";
		}else if (t == "teleport") {
			guieffect = "effect_teleport";
		}else if (t == "pixel") {
			guieffect = "effect_pixel";
		}else if (t == "bob") {
			guieffect = "effect_bob";
		}else if (t == "midsplit") {
			guieffect = "effect_midsplit";
		}else if (t == "invert") {
			guieffect = "effect_invert";
		}
	}
	
	public static function editorchangeframe():Void {
		//Set tabs to be what's currently being animated. 
		guimessage = frame[Gfx.sign].message[currentframe[Gfx.sign]];
		convertcolourtoaction(frame[Gfx.sign].colour[currentframe[Gfx.sign]]);
		convertbordertoaction(frame[Gfx.sign].border[currentframe[Gfx.sign]]);
		converteffecttoaction(frame[Gfx.sign].effect[currentframe[Gfx.sign]]);
		
		Gui.changetab(guitab);
	}
	
	public static function starteditmode():Void {
		currentscreen = "editor";
		Gui.addbutton(Std.int(0 * ((Gfx.screenwidth-4) / 5)), 220, Std.int(((Gfx.screenwidth-4) / 5)), 20, "message", "changetab_message", "tab");
		Gui.addbutton(Std.int(1 * ((Gfx.screenwidth-4) / 5)), 220, Std.int(((Gfx.screenwidth-4) / 5)), 20, "colour", "changetab_colour", "tab");
		Gui.addbutton(Std.int(2 * ((Gfx.screenwidth-4) / 5)), 220, Std.int(((Gfx.screenwidth-4) / 5)), 20, "border", "changetab_border", "tab");
		Gui.addbutton(Std.int(3 * ((Gfx.screenwidth-4) / 5)), 220, Std.int(((Gfx.screenwidth-4) / 5)), 20, "effect", "changetab_effect", "tab");
		Gui.addbutton(Std.int(4 * ((Gfx.screenwidth - 4) / 5)), 220, Std.int(((Gfx.screenwidth - 4) / 5)) + 2, 20, "frame", "changetab_frame", "tab");
		
		editmode = true;
		
		frame[0].clear();
		frame[0].add("enter text", "white", "none", "none");
		frame[0].start(0);
		Gfx.numsigns = 1;
		
		editorchangeframe();
	}
	
	public static function endeditmode():Void {
		currentscreen = "export";
		editmode = false;
		
		encode_signstring();
		
		frame[Gfx.sign].start(Gfx.sign);
		
		Gui.addbutton(Gfx.screenwidthmid - 100, 150, 200, 20, "Export your sign", "exportsign", "flashing");
		Gui.addbutton(Gfx.screenwidthmid - 80, 200, 160, 20, "main menu", "gotomenu");
	}
	
	public static function addsuggestion(t:String):Void {
		t = t.toUpperCase();
		randomsuggestions.push(t);
		randomsuggestionscore.push(0);
		numsuggestions++;
	}
	
	public static function encodebase64(t:String):String {
		return Base64.encode(haxe.io.Bytes.ofString(t));
	}
	
	public static function decodebase64(t:String):String {
		return Base64.decode(t).toString();
	}
	
	public static function encode_signchar_effect(t:String):String {
		if (t == "none") { return "0";
		}else if (t == "dropin") { return "1";
		}else if (t == "split") { return "2";
		}else if (t == "zoomin") { return "3";
		}else if (t == "teleport") { return "4";
		}else if (t == "pixel") { return "5";
		}else if (t == "bob") { return "6";
		}else if (t == "midsplit") { return "7";
		}else if (t == "invert") { return "8";
		}
		
		return "0";
	}
	
	
	public static function encode_signchar_border(t:String):String {
		if (t == "white-red_alternate") { return "0";
		}else if (t == "white-green_alternate") { return "1";
		}else if (t == "white-blue_alternate") { return "2";
		}else if (t == "red-white_alternate") { return "3";
		}else if (t == "red-green_alternate") { return "4";
		}else if (t == "red-blue_alternate") { return "5";
		}else if (t == "green-white_alternate") { return "6";
		}else if (t == "green-red_alternate") { return "7";
		}else if (t == "green-blue_alternate") { return "8";
		}else if (t == "blue-white_alternate") { return "9";
		}else if (t == "blue-red_alternate") { return "A";
		}else if (t == "blue-green_alternate") { return "B";
		}else if (t == "white-red_particles") { return "C";
		}else if (t == "white-green_particles") { return "D";
		}else if (t == "white-blue_particles") { return "E";
		}else if (t == "red-white_particles") { return "F";
		}else if (t == "red-green_particles") { return "G";
		}else if (t == "red-blue_particles") { return "H";
		}else if (t == "green-white_particles") { return "I";
		}else if (t == "green-red_particles") { return "J";
		}else if (t == "green-blue_particles") { return "K";
		}else if (t == "blue-white_particles") { return "L";
		}else if (t == "blue-red_particles") { return "M";
		}else if (t == "blue-green_particles") { return "N";
		}else if (t == "white_gap") { return "O";
		}else if (t == "red_gap") { return "P";
		}else if (t == "green_gap") { return "Q";
		}else if (t == "blue_gap") { return "R";
		}else if (t == "white_flash") { return "S";
		}else if (t == "red_flash") { return "T";
		}else if (t == "green_flash") { return "U";
		}else if (t == "blue_flash") { return "V";
		}else if (t == "white_flicker") { return "W";
		}else if (t == "red_flicker") { return "X";
		}else if (t == "green_flicker") { return "Y";
		}else if (t == "blue_flicker") { return "Z";
		}else if (t == "none") { return "a";
		}else if (t == "gradient") { return "b";
		}else if (t == "longgradient") { return "c";
		}
		return "a";
	}
	
	public static function encode_signchar_colour(t:String):String {
		if (t == "white-red_stripe") { return "0";
		}else if (t == "white-green_stripe") { return "1";
		}else if (t == "white-blue_stripe") { return "2";
		}else if (t == "red-white_stripe") { return "3";
		}else if (t == "red-green_stripe") { return "4";
		}else if (t == "red-blue_stripe") { return "5";
		}else if (t == "green-white_stripe") { return "6";
		}else if (t == "green-red_stripe") { return "7";
		}else if (t == "green-blue_stripe") { return "8";
		}else if (t == "blue-white_stripe") { return "9";
		}else if (t == "blue-red_stripe") { return "A";
		}else if (t == "blue-green_stripe") { return "B";
		}else if (t == "white-red_flicker") { return "C";
		}else if (t == "white-green_flicker") { return "D";
		}else if (t == "white-blue_flicker") { return "E";
		}else if (t == "red-white_flicker") { return "F";
		}else if (t == "red-green_flicker") { return "G";
		}else if (t == "red-blue_flicker") { return "H";
		}else if (t == "green-white_flicker") { return "I";
		}else if (t == "green-red_flicker") { return "J";
		}else if (t == "green-blue_flicker") { return "K";
		}else if (t == "blue-white_flicker") { return "L";
		}else if (t == "blue-red_flicker") { return "M";
		}else if (t == "blue-green_flicker") { return "N";
		}else if (t == "white_flash") { return "O";
		}else if (t == "red_flash") { return "P";
		}else if (t == "green_flash") { return "Q";
		}else if (t == "blue_flash") { return "R";
		}else if (t == "white_fire") { return "S";
		}else if (t == "red_fire") { return "T";
		}else if (t == "green_fire") { return "U";
		}else if (t == "blue_fire") { return "V";
		}else if (t == "gradient") { return "W";
		}else if (t == "slow_cycle") { return "X";
		}else if (t == "fast_cycle") { return "Y";
		}else if (t == "white") { return "Z";
		}else if (t == "red") { return "a";
		}else if (t == "green") { return "b";
		}else if (t == "blue") { return "c";
		}
		return "Z";
	}
	
	public static function removepipes(t:String):String {
		var fixedstring:String = "";
		for (i in 0...t.length) {
			if (Help.Mid(t, i) == "|") {
				fixedstring += " ";
			}else {
				fixedstring += Help.Mid(t, i);
			}
		}
		return fixedstring;
	}
	
	public static function encode_signstring():Void {
		signstring = "";
		//First add the number of frames:
		signstring += Std.string(frame[Gfx.sign].getlength());
		//Next, add the colours, borders and effects
		for (i in 0...frame[Gfx.sign].getlength()) {
			signstring += encode_signchar_colour(frame[Gfx.sign].colour[i]);
			signstring += encode_signchar_border(frame[Gfx.sign].border[i]);
			signstring += encode_signchar_effect(frame[Gfx.sign].effect[i]);
		}
		//Finally, add the messages, divided by pipes.
		for (i in 0...frame[Gfx.sign].getlength()) {
			signstring += removepipes(frame[Gfx.sign].message[i]);
			signstring += "|";
		}
		//Remove that last pipe, oops
		signstring = Help.Left(signstring, signstring.length - 1);
		signstring = encodebase64(signstring);
		
		signstring = "http://www.terrycavanaghgames.com/grabthembytheeyes/signs/index.html?sign=" + signstring;
	}
	
	public static var randomsuggestions:Array<String> = new Array<String>();
	public static var randomsuggestionscore:Array<Int> = new Array<Int>();
	public static var numsuggestions:Int=0;
	
	public static var currentscreen:String = "";
	
	public static var guitab:String = "message";
	public static var guimessage:String = "new sign";
	
	public static var guicol:String = "colour_simple";
	public static var guicol1:String = "white";
	public static var guicol2:String = "red";
	
	public static var guiborder:String = "border_none";
	public static var guibordercol1:String = "white";
	public static var guibordercol2:String = "red";
	
	public static var guieffect:String = "effect_none";
	
	public static var editmode:Bool = false;
	
	public static var signstring:String = "";
	
	public static var deck:Array<Deck> = new Array<Deck>();
	public static var deckindex:Map<String, Int> = new Map<String, Int>();
	public static var currentdeck:Int;
	public static var otherdeck:Int;
	
	//Game variables
	public static function newgame():Void {
		//Ok! Load up the game deck
		cleardeck("playerdeck");
		cleardeck("enemydeck");
		
		makenewgamedeck();
		day = 0; shopmessage = "";
		showdayinfo = 0;
		
		jaybudget = 0;
		fbbudget = 0;
		turn = 0;
		showcutsceneborders = false;
		
		gameoverbanner = false;
		gameoverbannerposition = 0;
		gameovershowbutton = false;
		
		for (i in 0...6) {
			dayscore_jay[i] = 0;
			dayscore_fb[i] = 0;
		}
		
		totalscore_jay = 0;
		totalscore_fb = 0;
		
		mousedovercard = -1;
		
		jayhascart = true;
		jayhassign = false;
		fbhascart = false;
		fbhassign = false;
		shopkeephascart = false;
		shopkeephassign = false;
		supersign = false;
		
		shoptutorial = false;
	}
	
	public static function loadgame():Void {
		//Initilise a game from savecookie values
		//Ok! Load up the game deck
		shopmessage = "";
		showdayinfo = 0;
		turn = 0;
		
		showcutsceneborders = false;
		
		gameoverbanner = false;
		gameoverbannerposition = 0;
		gameovershowbutton = false;
		
		for (i in 0...6) {
			dayscore_jay[i] = 0;
			dayscore_fb[i] = 0;
		}
		
		totalscore_jay = 0;
		totalscore_fb = 0;
		
		mousedovercard = -1;
		
		jayhascart = true;
		jayhassign = true;
		fbhascart = true;
		fbhassign = true;
		shopkeephascart = false;
		shopkeephassign = false;
		supersign = false;
		
		shoptutorial = true;
		
		Savecookie.loaddata();
		jaybudget = Savecookie.savejaymoney;
		fbbudget = Savecookie.savefbmoney;
		day = Savecookie.saveday;
	}
	
	public static function changeshopstate(t:String):Void {
	  shopphasestate = t;
	  shopphasestate_lerp = 0;
	  shopphasestate_delay = 0;
	  shopphasestate_finished = false;
		shopphasestate_nextstate = "";
	}
	
	public static function playercash():String {
		if (jaybudget > 0) {
			return "$" + Std.string(jaybudget) + "0";
		}else {
			return "$0";
		}
	}
	
	public static function enemycash():String {
		if (fbbudget > 0) {
			return "$" + Std.string(fbbudget) + "0";
		}else {
			return "$0";
		}
	}
	
	public static function initshop():Void {
		turn = 2;
	}
	
	public static function getmouseovercard():Int {
		if (Mouse.y < 124) {
			for(i in 0...5){
			  if(Mouse.x > (Gfx.screenwidth / 5) * i && Mouse.x < (Gfx.screenwidth / 5) * (i + 1)) {
					return i;
				}
			}
		}
		return -1;
	}
	
	public static function mouseovercard(t:Int):Bool {
		if (Mouse.y < 124) {
			if (Mouse.x > (Gfx.screenwidth / 5) * t && Mouse.x < (Gfx.screenwidth / 5) * (t + 1)) {
				return true;
			}
		}
		return false;
	}
	
	public static function setshopnumcards():Void {
		shopnumcards = deck[deckindex.get("shopdeck")].numcards;
		if (shopnumcards > 5) shopnumcards = 5;
	}
	
	public static function changeshopmessage(t:String):Void {
		shopmessage = t;
		shopmessagedelay = 180;
	}
	
	public static function removeshopmessage():Void {
		shopmessagedelay = 19;
	}
	
	public static function checkforendofshopphase():Void {
		if (!preparecheckforendofshopphase) {
			preparecheckforendofshopphase = true;
			if (deck[deckindex.get("shopdeck")].numcards == 0) {
				shopphasestate_nextstate = "end";
				turn = 2; shopmessagedelay = 0; shopmessage = "";
			}else {
				turn = (turn + 1) % 2;
				if (turn % 2 == 0) {
					changeshopmessage("JAY'S TURN");
				}else {
					changeshopmessage("FILTHY BURGER'S TURN");
				}
			}
		}
	}
	
	public static var preparecheckforendofshopphase:Bool; //jesus this is getting messy
	
	public static var shoppickcard:Int;
	public static var teasecard:Int;
	
	public static var day:Int;
	public static var jaybudget:Int;
	public static var fbbudget:Int;
	public static var turn:Int;
	
	public static var shopphasestate:String;
	public static var shopphasestate_nextstate:String;
	public static var shopphasestate_lerp:Int;
	public static var shopphasestate_delay:Int;
	public static var shopphasestate_finished:Bool;
	
	public static var shopmessage:String;
	public static var shopnumcards:Int;
	public static var shopmessagedelay:Int;
	
	public static var minipilesize:Int = 10;
	public static var minipilegap:Int = 12;
	public static var minipileyoff:Int = 16;
	
	public static function changeeditorstate(t:String):Void {
	  editorphasestate = t;
	  editorphasestate_lerp = 0;
	  editorphasestate_delay = 0;
	  editorphasestate_finished = false;
		editorphasestate_nextstate = "";
	}
	
	public static function numtocol(i:Int):String {
		if (i == 0) return "white";
		if (i == 1) return "red";
		if (i == 2) return "green";
		if (i == 3) return "blue";
		return "white";
	}
	
	public static function docolour(t:String):String {
		//Given a colourcard with action t, return a internal string for the colour
		switch(t) {
			case "message", "none":
				Gui.hidecolourseditorcolour();
				return "white";
				
			case "colour_stripe":
				Gui.showtwocolourtexteditorcolour();
				return Edphase.colourcolour1[Edphase.currentframe] + "-" + Edphase.colourcolour2[Edphase.currentframe] + "_stripe";
			
			case "colour_fire":
				Gui.clearcolourtexteditorcolour();
				return Edphase.colourcolour1[Edphase.currentframe] + "_fire";
			
			case "colour_fastcycle":
				Gui.hidecolourseditorcolour();
				return "fast_cycle";
				
			case "colour_gradient":
				Gui.hidecolourseditorcolour();
				return "gradient";
				
			case "colour_slowcycle":
				Gui.hidecolourseditorcolour();
				return "slow_cycle";
				
			case "colour_flicker":
				Gui.showtwocolourtexteditorcolour();
				return Edphase.colourcolour1[Edphase.currentframe] + "-" + Edphase.colourcolour2[Edphase.currentframe] + "_flicker";
				
			case "colour_flash":
				Gui.clearcolourtexteditorcolour();
				return Edphase.colourcolour1[Edphase.currentframe] + "_flash";
				
			case "colour_simple":
				Gui.clearcolourtexteditorcolour();
				return Edphase.colourcolour1[Edphase.currentframe];
		}
		return "white";
	}
	
	public static function doborder(t:String):String {
		//Given a bordercard with action t, return a internal string for the colour
		switch(t) {
			case "message", "none":
				Gui.hidecolourseditorborder();
				return "none";
			case "border_particles":
				Gui.showtwocolourtexteditorborder();
				return Edphase.bordercolour1[Edphase.currentframe] + "-" + Edphase.bordercolour2[Edphase.currentframe] + "_particles";
			case "border_gradient2":
				Gui.hidecolourseditorborder();
				return "longgradient";
			case "border_gradient1":
				Gui.hidecolourseditorborder();
				return "gradient";
			case "border_alternate":
				Gui.showtwocolourtexteditorborder();
				return Edphase.bordercolour1[Edphase.currentframe] + "-" + Edphase.bordercolour2[Edphase.currentframe] + "_alternate";
			case "border_gap":
				Gui.clearcolourtexteditorborder();
				return Edphase.bordercolour1[Edphase.currentframe] + "_gap";
			case "border_flicker":
				Gui.clearcolourtexteditorborder();
				return Edphase.bordercolour1[Edphase.currentframe] + "_flicker";
			case "border_flash":
				Gui.clearcolourtexteditorborder();
				return Edphase.bordercolour1[Edphase.currentframe] + "_flash";
		}
		return "none";
	}
	
	
	public static function doeffect(t:String):String {
		//Given an effect card with action t, return a internal string for the effect
		switch(t) {
			case "effect_bob":
				return "bob";
			case "effect_invert":
				return "invert";
			case "effect_split":
				return "split";
			case "effect_teleport":
				return "teleport";
			case "effect_pixel":
				return "pixel";
			case "effect_midsplit":
				return "midsplit";
			case "effect_dropin":
				return "dropin";
			case "effect_zoomin":
				return "zoomin";
		}
		return "none";
	}
	
	public static var editorphasestate:String;
	public static var editorphasestate_nextstate:String;
	public static var editorphasestate_lerp:Int;
	public static var editorphasestate_delay:Int;
	public static var editorphasestate_finished:Bool;
	
	public static function zoomin(xp:Int, yp:Int):Void {
		zoom = true;
		zoomx = xp;
		zoomy = yp;
	}
	
	public static function zoomout():Void {
		zoom = false;
	}
	
	public static var zoom:Bool;
	public static var zoomx:Int;
	public static var zoomy:Int;
	
	public static var scene:String = "";
	public static var shoptutorial:Bool = false;
	
	public static var jayhascart:Bool = true;
	public static var jayhassign:Bool = false;
	public static var fbhascart:Bool = false;
	public static var fbhassign:Bool = false;
	public static var shopkeephascart:Bool = false;
	public static var shopkeephassign:Bool = false;
	
	public static var tx:Int;
	
	
	public static function changeboughtlcdsignstate(t:String):Void {
	  boughtlcdsignstate = t;
	  boughtlcdsignstate_lerp = 0;
	  boughtlcdsignstate_delay = 0;
	  boughtlcdsignstate_finished = false;
		boughtlcdsignstate_nextstate = "";
	}
	
	public static var boughtlcdsign:Bool = false;
	public static var boughtlcdsignstate:String;
	public static var boughtlcdsignstate_nextstate:String;
	public static var boughtlcdsignstate_lerp:Int;
	public static var boughtlcdsignstate_delay:Int;
	public static var boughtlcdsignstate_finished:Bool;
	
	public static var showcutsceneborders:Bool = false;
	public static var cutscenebars:Int = 0;
	
	public static var dayname:Array<String> = new Array<String>();
	public static var dayscore_jay:Array<Int> = new Array<Int>();
	public static var dayscore_fb:Array<Int> = new Array<Int>();
	public static var totalscore_jay:Int;
	public static var totalscore_fb:Int;
	
	public static function changecarddepstate(t:String):Void {
	  carddepstate = t;
	  carddepstate_lerp = 0;
	  carddepstate_delay = 0;
	  carddepstate_finished = false;
		carddepstate_nextstate = "";
	}
	
	public static var carddepphase:Bool = false;
	public static var carddepstate:String;
	public static var carddepstate_num:Int;
	public static var carddepstate_nextstate:String;
	public static var carddepstate_lerp:Int;
	public static var carddepstate_delay:Int;
	public static var carddepstate_finished:Bool;
	
	public static function changeenddaystate(t:String):Void {
	  enddaystate = t;
	  enddaystate_lerp = 0;
	  enddaystate_delay = 0;
	  enddaystate_finished = false;
		enddaystate_nextstate = "";
	}
	
	public static var enddayphase:Bool = false;
	public static var enddaystate:String;
	public static var enddaystate_num:Int;
	public static var enddaystate_nextstate:String;
	public static var enddaystate_lerp:Int;
	public static var enddaystate_delay:Int;
	public static var enddaystate_finished:Bool;
	
	public static var showdayinfo:Int = 0;
	public static var showgamesaved:Bool = false;
	
	public static function ai_cardcount(cardtype:String, deckinuse:String, numframes:Int, extrascore:Int = 0):Int {
		Control.cleardeck(cardtype + "_playerdeck");
		Control.changedeck(cardtype + "_playerdeck"); Control.changeotherdeck(deckinuse);
		Control.copy_all(cardtype);	
		if (extrascore > 0) {
			//Copy in a new card with this score and add it to the mix
			deck[currentdeck].copycard(deck[otherdeck].card[0].type, deck[otherdeck].card[0].name, deck[otherdeck].card[0].action, extrascore, deck[otherdeck].card[0].special);
		}
		Control.sortbyscore();
		Control.keeptop(numframes);
		tx = 0;
		for (i in 0 ... Control.deck[Control.currentdeck].numcards) {
			tx += deck[currentdeck].card[i].score;
		}
		return tx;
	}
	
	public static function getbasescores():Void {
		ai_basescore_jay = 0;
		ai_basescore_fb = 0;
		ai_expectedscore_jay = 0;
		ai_expectedscore_fb = 0;
		
		ai_numframes_jay = 2 + Control.extraframesin("playerdeck");
		ai_numframes_fb = 2 + Control.extraframesin("enemydeck");
		
		//Ok: expected score is the sum of the scores of the top N cards for each category
		ai_basescore_jay += ai_cardcount("message", "playerdeck", ai_numframes_jay);
		ai_basescore_jay += ai_cardcount("colour", "playerdeck", ai_numframes_jay);
		ai_basescore_jay += ai_cardcount("border", "playerdeck", ai_numframes_jay);
		ai_basescore_jay += ai_cardcount("effect", "playerdeck", ai_numframes_jay);
		
		ai_basescore_fb += ai_cardcount("message", "enemydeck", ai_numframes_fb);
		ai_basescore_fb += ai_cardcount("colour", "enemydeck", ai_numframes_fb);
		ai_basescore_fb += ai_cardcount("border", "enemydeck", ai_numframes_fb);
		ai_basescore_fb += ai_cardcount("effect", "enemydeck", ai_numframes_fb);
		
		//trace("Base score for Jay: ", ai_basescore_jay);
		//trace("Base score for FB: ", ai_basescore_fb);
	}
	
	public static function getexpectedscores_jay(cardtype:String, cardscore:Int):Void {
		//Work out expected scores for the deck that contains this new card for jay
		ai_expectedscore_jay = 0;
		
		ai_numframes_jay = 2 + Control.extraframesin("playerdeck");
		if (cardtype == "extraframe") {
			ai_numframes_jay++;
			ai_expectedscore_jay += 8 - day;
		}
		
		//Ok: expected score is the sum of the scores of the top N cards for each category
		if (cardtype == "message") {
			ai_expectedscore_jay += ai_cardcount("message", "playerdeck", ai_numframes_jay, cardscore);
		}else{
			ai_expectedscore_jay += ai_cardcount("message", "playerdeck", ai_numframes_jay);
		}
		if (cardtype == "colour") {
			ai_expectedscore_jay += ai_cardcount("colour", "playerdeck", ai_numframes_jay, cardscore);
		}else {
			ai_expectedscore_jay += ai_cardcount("colour", "playerdeck", ai_numframes_jay);
		}
		if (cardtype == "border") {
			ai_expectedscore_jay += ai_cardcount("border", "playerdeck", ai_numframes_jay, cardscore);
		}else {
			ai_expectedscore_jay += ai_cardcount("border", "playerdeck", ai_numframes_jay);
		}
		if (cardtype == "effect") {
			ai_expectedscore_jay += ai_cardcount("effect", "playerdeck", ai_numframes_jay, cardscore);
		}else {
			ai_expectedscore_jay += ai_cardcount("effect", "playerdeck", ai_numframes_jay);
		}
	}
	
	public static function getexpectedscores_fb(cardtype:String, cardscore:Int):Void {
		//Work out expected scores for the deck that contains this new card for jay
		ai_expectedscore_fb = 0;
		
		ai_numframes_fb = 2 + Control.extraframesin("enemydeck");
		if (cardtype == "extraframe") {
			ai_numframes_fb++;
			ai_expectedscore_fb += 8 - day;
		}
		
		//Ok: expected score is the sum of the scores of the top N cards for each category
		if (cardtype == "message") {
			ai_expectedscore_fb += ai_cardcount("message", "enemydeck", ai_numframes_fb, cardscore);
		}else{
			ai_expectedscore_fb += ai_cardcount("message", "enemydeck", ai_numframes_fb);
		}
		if (cardtype == "colour") {
			ai_expectedscore_fb += ai_cardcount("colour", "enemydeck", ai_numframes_fb, cardscore);
		}else {
			ai_expectedscore_fb += ai_cardcount("colour", "enemydeck", ai_numframes_fb);
		}
		if (cardtype == "border") {
			ai_expectedscore_fb += ai_cardcount("border", "enemydeck", ai_numframes_fb, cardscore);
		}else {
			ai_expectedscore_fb += ai_cardcount("border", "enemydeck", ai_numframes_fb);
		}
		if (cardtype == "effect") {
			ai_expectedscore_fb += ai_cardcount("effect", "enemydeck", ai_numframes_fb, cardscore);
		}else {
			ai_expectedscore_fb += ai_cardcount("effect", "enemydeck", ai_numframes_fb);
		}
	}
		
	public static function ai():Int {
		//Return the card that the enemy chooses.
		//Basic idea: every turn we start with a default state, which changes
		//based on the situation. In that situation, we look through all the cards
		//and score them. Choose the best one.
		ai_mode = "normal";
		
		//Special modes:
		//It's the first day
		if (day==1) ai_mode = "first_day";
		//The player is out of money
		if (jaybudget == 0) ai_mode = "jay_is_broke";
		
		setshopnumcards();
		for (i in 0...5) ai_score[i] = 0;
		changedeck("shopdeck");
		
		switch(ai_mode) {
			case "normal":
				getbasescores();
				for (i in 0...Control.shopnumcards) {
					//Score the cards
					ai_score[i] = 0;
					
					if (Control.deck[Control.currentdeck].card[i].special == "filthyburgeronly") {
						changedeck("shopdeck"); getexpectedscores_fb(Control.deck[Control.currentdeck].card[i].type, Control.deck[Control.currentdeck].card[i].score);
						changedeck("shopdeck");	getexpectedscores_jay(Control.deck[Control.currentdeck].card[i].type, 0);	
					}else if (Control.deck[Control.currentdeck].card[i].special == "jayonly") {
						changedeck("shopdeck"); getexpectedscores_fb(Control.deck[Control.currentdeck].card[i].type, 0);
						changedeck("shopdeck");	getexpectedscores_jay(Control.deck[Control.currentdeck].card[i].type, Control.deck[Control.currentdeck].card[i].score);
					}else {
						changedeck("shopdeck"); getexpectedscores_fb(Control.deck[Control.currentdeck].card[i].type, Control.deck[Control.currentdeck].card[i].score);
						changedeck("shopdeck");	getexpectedscores_jay(Control.deck[Control.currentdeck].card[i].type, Control.deck[Control.currentdeck].card[i].score);						
					}
					changedeck("shopdeck");	
					//trace(Control.deck[Control.currentdeck].card[i].name + " " + Control.deck[Control.currentdeck].card[i].action + " is worth " + Std.string(ai_expectedscore_fb - ai_basescore_fb) + " to Filthy Burger and " + Std.string(ai_expectedscore_jay - ai_basescore_jay) + " to Jay.");
					
					if (day <= 3) {
						ai_score[i] = (ai_expectedscore_fb - ai_basescore_fb);
					}else {
						ai_score[i] = (ai_expectedscore_fb - ai_basescore_fb) + (ai_expectedscore_jay - ai_basescore_jay);
					}
					
					if (fbbudget >= 9) {
						if (i < 4) ai_score[i]++;
					}else{
						ai_score[i] += Std.int((5 - i));
						if (i >= 4) ai_score[i] = 0;
					}
					
					if (jaybudget == 1 && i >= 2) ai_score[i] = 0; //Don't consider cards jay can't afford
					if (i > fbbudget - 1) ai_score[i] = 0;
				}
				
				return bestoption();
			case "first_day":
				// - Only consider cards valued $40 or less.
				// - Grab the best colour card you can.
				// - Otherwise, grab the best message card
				for (i in 0...Control.shopnumcards) {
					//Score the cards
					ai_score[i] = 0;
					
					if (Control.deck[Control.currentdeck].card[i].type == "colour")	ai_score[i] += 100;
					ai_score[i] += (Control.deck[Control.currentdeck].card[i].score * 3);
				  ai_score[i] += (5 - i) * 2;
					
					if (i >= 4) ai_score[i] = 0;
					if (jaybudget == 1 && i >= 2) ai_score[i] = 0; //Don't consider cards jay can't afford
					if (i > fbbudget - 1) ai_score[i] = 0;
				}
				return bestoption();
			case "jay_is_broke":
				//Just always pick the cheapest card you can.
				return 0;
		}
		
		//in case something goes wrong, just pick the first card.
		//trace("something went wrong");
		return 0;
	}
	
	public static function bestoption():Int {
		ai_topscore_num = 0;
		ai_topscore = ai_score[0];
		//trace("=-=-=-=-=-=-=-=-");
		//trace("deciding on best option: AI is in mode \"" + ai_mode + "\", FB has " + Std.string(fbbudget));
		for (i in 0...5) {
			//trace("Card " + Std.string(i + 1) + ": " + Std.string(ai_score[i]));
			if (ai_score[i] > ai_topscore) {
				ai_topscore = ai_score[i];
				ai_topscore_num = i;
			}
		}
		//trace("Choosing card " + Std.string(ai_topscore_num+1));
		return ai_topscore_num;
	}
	
	public static var ai_mode:String;
	public static var ai_score:Array<Int> = new Array<Int>();
	public static var ai_topscore:Int;
	public static var ai_topscore_num:Int;
	public static var ai_temp:Int;
	
	public static var ai_basescore_jay:Int;
	public static var ai_basescore_fb:Int;
	public static var ai_expectedscore_jay:Int;
	public static var ai_expectedscore_fb:Int;
	public static var ai_numframes_jay:Int;
	public static var ai_numframes_fb:Int;
	
	
	public static function tickervoice():Void {
		switch(voice) {
			case "jay": Music.playef("voice_mid");
			case "hipster1": Music.playef("voice_low");
			case "hipster2": Music.playef("voice_low2");
			case "hipsters": Music.playef("voice_low2");
			case "shopkeep": Music.playef("voice_high");
		}
	}
	public static var voice:String = "";
	
	public static function characterswalking():Bool {
		for (i in 0...Obj.nentity) {
			if (Obj.entities[i].active) {
				if (Obj.entities[i].doscriptmove) {
					return true;
				}
			}
		}
		return false;
	}
	
	public static var mousedovercard:Int = -1;
	public static var walkingdelay:Int = 0;
	public static var walkingdelaysize:Int = 36;
	
	public static var gameoverbanner:Bool = false;
	public static var gameoverbannerposition:Int = 0;
	public static var gameovershowbutton:Bool = false;
	public static var gameovermessage:String = "";
	
	public static var supersign = false;
	
	public static var turbomode:Bool = false;
	
	public static var exitmenu:Bool = false;
	
	#if !flash
	public static function addexitmenu():Void {
		//Create the exit and full screen buttons
	}
	
	public static function removeexitmenu():Void {
		//Remove the exit and fullscreen buttons
	}
	#end
}