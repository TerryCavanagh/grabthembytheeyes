package gamecontrol;

import com.terry.*;
import openfl.display.Stage;
import openfl.text.TextField;
import openfl.text.TextFieldType;

class Gui {
	public static function init(swfstage:Stage):Void {
		for (i in 0...maxbuttons) {
			button.push(new GuiButton());
		}
		numbuttons = 0;
		
		enabletextfield(swfstage);
	}
	
	public static function enabletextfield(swfstage:Stage):Void {
		gamestage = swfstage;
		swfstage.addChild(inputField);
		inputField.border = true;
		inputField.width = 600;
		inputField.height = 20;
		inputField.x = 5;
		inputField.y = Gfx.screenheight + 10;
		inputField.type = TextFieldType.INPUT;
		inputField.visible = false;
		
		inputField.maxChars = 100;
		//inputField.restrict = null; //Not in haxe I guess?
	}
	
	public static function inittext(t:String):Void {
		#if flash
		inputField.text = t; textfield = t;	waitfortext = true;
		#else
		inputField.text = Help.reversetext(t); textfield = Help.reversetext(t);	waitfortext = true;
		#end
	}
	
	public static var inputField:TextField = new TextField();
	public static var waitfortext:Bool;
	public static var finishtext:Bool;
	public static var textfield:String;
	public static var lastentry:String;
	
	public static function addbutton(x:Int, y:Int, w:Int, h:Int, contents:String, act:String = "", sty:String = "normal"):Void {
		var i:Int, z:Int;
		if(numbuttons == 0) {
			//If there are no active buttons, Z=0;
			z = 0; 
		}else {
			i = 0; z = -1;
			while (i < numbuttons) {
				if (!button[i].active) {
					z = i; i = numbuttons;
				}
				i++;
			}
			if (z == -1) {
				z = numbuttons;
			}
		}
		//trace("addbutton(", x, y, w, h, contents, act, sty, ")", numbuttons);
		button[z].init(x, y, w, h, contents, act, sty);
		numbuttons++;
	}
	
	public static function clear():Void {
		for (i in 0...numbuttons) {
			button[i].active = false;
		}
		numbuttons = 0;
	}
	
	public static function buttonexists(t:String):Bool {
		//Return true if there is an active button with action t
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (button[i].action == t) {
					return true;
				}
			}
		}
		
		return false;
	}
	
	public static function checkinput():Void {
		for (i in 0...numbuttons) {
			if (button[i].active && button[i].visable) {
				if (Help.inboxw(Mouse.x, Mouse.y, Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height))) {
					button[i].mouseover = true;
				}else {
					button[i].mouseover = false;
				}
				
				if (Mouse.justleftpressed()) {
					if (button[i].mouseover) {
						if (button[i].action == "frame_finish") {
							Music.playef("menu_select");
						}else{
							Music.playef("click");
						}
						dobuttonaction(i);
						if (buttonkludge) {
							buttonkludge = false;
						}else{
							button[i].selected = true;
						}
						if (button[i].action == "random suggestion") button[i].selected = false;
					}
				}
			}
		}
		
		if (waitfortext) {
			if(!finishtext){
				gettext();
			}
		}
		
		#if !flash
		//Workaround for backwards typing
		if (Key.justPressed("BACKSPACE")) {			
			for (i in 0...numbuttons) {
				if (button[i].active && button[i].visable) {
					if (button[i].style == "textentry") {
						if (button[i].text.length >= 1) {
							inittext(Help.Left(button[i].text, button[i].text.length - 1));
						}
					}
				}
			}
		}
		#end
		
		cleanup();
	}
	
	public static function entertext():Void {
		lastentry = Help.Left(textfield, 38);
		textfield = "";
		inputField.text = "";
		finishtext = true;
		
		finishtext = false; waitfortext = false;
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (button[i].style == "textentry") {
					button[i].selected = false;
				}
			}
		}
		Control.guimessage = lastentry;
		Control.frame[Gfx.sign].message[Control.currentframe[Gfx.sign]] = lastentry;
		Control.changecurrenttext(lastentry);
		
		Control.changeeffect(Control.frame[Gfx.sign].effect[Control.currentframe[Gfx.sign]]);
		Control.frame[Gfx.sign].delay = Control.waittime;
	}
	
	public static function entertext_ingame():Void {
		//Special version for the in-game editor
		lastentry = Help.Left(textfield, 38).toUpperCase();
		textfield = "";
		inputField.text = "";
		finishtext = true;
		
		finishtext = false; waitfortext = false;
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (button[i].style == "textentry") {
					button[i].active = false;
				}
			}
		}
		
		Edphase.custommessage(lastentry);
	}
	
	public static var thetextentrybutton:Int;
	public static function gettext():Void {
		thetextentrybutton = -1;
		gamestage.focus = inputField;
		#if flash
		inputField.setSelection(inputField.text.length, inputField.text.length);
		#else
		inputField.setSelection(inputField.text.length, inputField.text.length);
		#end
		inputField.text = inputField.text.toUpperCase();
		inputField.text = Help.Left(inputField.text, 38);
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (button[i].style == "textentry") {
					thetextentrybutton = i;
					#if flash
					button[i].text = inputField.text;
					textfield = inputField.text;
					#else
					button[i].text = Help.reversetext(inputField.text);
					textfield = Help.reversetext(inputField.text);
					#end
				}
			}
		}
		
		if(thetextentrybutton > -1){
			if (Key.justPressed("ENTER") && !Game.keyheld) {
				if(button[thetextentrybutton].action == "message"){
					entertext();
				}else if (button[thetextentrybutton].action == "message_ingame") {
					entertext_ingame();
				}
				Game.keyheld = true;
			}
		}
	}
	
	public static function cleanup():Void {
		var i:Int = 0;
		i = numbuttons - 1; while (i >= 0 && !button[i].active) { numbuttons--; i--; }
	}
	
	public static function drawbuttons(onlytextentry:Bool = false):Void {
		for (i in 0...numbuttons) {
			if (button[i].active && button[i].visable) {
				if (onlytextentry) {
					if (button[i].selected) {
						switch(button[i].style) {
							case "textentry":
								Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[1]);
								Gfx.drawbox(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[4]);
								
								tx = Std.int(button[i].position.x) + Std.int((button[i].position.width - Text.normallen(button[i].text)) / 2);
								ty = Std.int(button[i].position.y) + Std.int(((button[i].position.height) - 24) / 2);
								Gfx.normalbigprint(tx, ty, button[i].text, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
								if (Help.slowsine % 32 >= 16) {
									Gfx.normalbigprint(tx + Std.int(Text.normallen(button[i].text))+2, ty, "_", Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
								}
						}
					}else {
						switch(button[i].style) {
							case "textentry":
								if(button[i].mouseover){
									Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[1]);
								}else {
									Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[0]);
								}
								
								tx = Std.int(button[i].position.x) + Std.int((button[i].position.width - Text.normallen(button[i].text)) / 2);
								ty = Std.int(button[i].position.y) + Std.int(((button[i].position.height) - 24) / 2);
								if(button[i].mouseover){
									Gfx.normalbigprint(tx, ty, button[i].text, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
								}else {
									Gfx.normalbigprint(tx, ty, button[i].text, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
								}
						}
					}
				}else{
					if (button[i].selected) {
						switch(button[i].style) {
							case "textentry":
								Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[1]);
								Gfx.drawbox(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[4]);
								
								tx = Std.int(button[i].position.x) + Std.int((button[i].position.width - Text.normallen(button[i].text)) / 2);
								ty = Std.int(button[i].position.y) + Std.int(((button[i].position.height) - 24) / 2);
								Gfx.normalbigprint(tx, ty, button[i].text, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
								if (Help.slowsine % 32 >= 16) {
									Gfx.normalbigprint(tx + Std.int(Text.normallen(button[i].text))+2, ty, "_", Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
								}
							case "colour":
								if(Help.getbranch(button[i].action, "_") =="white"){
									Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y)+1, Std.int(button[i].position.width), Std.int(button[i].position.height)-1, Def.GRAY[5]);
								}else if (Help.getbranch(button[i].action, "_") == "red") {
									Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y)+1, Std.int(button[i].position.width), Std.int(button[i].position.height)-1, 255, 0, 0);
								}else if (Help.getbranch(button[i].action, "_") == "green") {
									Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y)+1, Std.int(button[i].position.width), Std.int(button[i].position.height)-1, 0, 255, 0);
								}else if (Help.getbranch(button[i].action, "_") == "blue") {
									Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y)+1, Std.int(button[i].position.width), Std.int(button[i].position.height)-1, 16, 16, 255);
								}
								
								tx = Std.int(button[i].position.x) + Std.int((button[i].position.width - Text.normallen(button[i].text)) / 2);
								ty = Std.int(button[i].position.y) + Std.int(((button[i].position.height) - 14) / 2) + 1;
								if (Help.getbranch(button[i].action, "_") == "white") {
									Gfx.normalprint(tx, ty, button[i].text, 0, 0, 0, false);
								}else{
									Gfx.normalprint(tx, ty, button[i].text, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
								}
							case "normal", "flashing":
								Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y)+1, Std.int(button[i].position.width), Std.int(button[i].position.height)-1, Def.GRAY[3]);
								Gfx.drawbox(Std.int(button[i].position.x), Std.int(button[i].position.y) + 1, Std.int(button[i].position.width), Std.int(button[i].position.height)-1, Def.GRAY[4]);
								
								tx = Std.int(button[i].position.x) + Std.int((button[i].position.width - Text.normallen(button[i].text)) / 2);
								ty = Std.int(button[i].position.y) + Std.int(((button[i].position.height) - 14) / 2)+1;
								Gfx.normalprint(tx, ty, button[i].text, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
							case "tiny":
								Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y)+1, Std.int(button[i].position.width), Std.int(button[i].position.height)-1, Def.GRAY[3]);
								Gfx.drawbox(Std.int(button[i].position.x), Std.int(button[i].position.y) + 1, Std.int(button[i].position.width), Std.int(button[i].position.height)-1, Def.GRAY[4]);
								
								tx = Std.int(button[i].position.x) + Std.int((button[i].position.width - Text.len(button[i].text)) / 2);
								ty = Std.int(button[i].position.y) + Std.int(((button[i].position.height) - 7) / 2)+1;
								Gfx.smallprint(tx, ty, button[i].text, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
							case "tab":
								Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y)-1, Std.int(button[i].position.width), Std.int(button[i].position.height)+2, Def.GRAY[3]);
								Gfx.drawbox(Std.int(button[i].position.x), Std.int(button[i].position.y) - 1, Std.int(button[i].position.width), Std.int(button[i].position.height)+2, Def.GRAY[4]);
								
								tx = Std.int(button[i].position.x) + Std.int((button[i].position.width - Text.normallen(button[i].text)) / 2);
								ty = Std.int(button[i].position.y) + Std.int(((button[i].position.height) - 14) / 2)-1;
								Gfx.normalprint(tx, ty, button[i].text, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
						}
					}else {
						switch(button[i].style) {
							case "flashing":
								if (button[i].mouseover) {
									switch(Std.int(Help.glow / 8)%4) {
										case 0:
											Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[5]);
										case 1:
											Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[4]);
										case 2:
											Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[5]);
										case 3:
											Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[4]);
									}
								}else{
									switch(Std.int(Help.glow / 16)%4) {
										case 0:
											Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[4]);
										case 1:
											Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[3]);
										case 2:
											Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[4]);
										case 3:
											Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[3]);
									}
								}
								Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y + button[i].position.height) - 2, Std.int(button[i].position.width), 2, Def.GRAY[0]);
								
								tx = Std.int(button[i].position.x) + Std.int((button[i].position.width - Text.normallen(button[i].text)) / 2);
								ty = Std.int(button[i].position.y) + Std.int(((button[i].position.height) - 14) / 2);
								
								Gfx.normalprint(tx, ty, button[i].text, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
							case "colour":
								if(Help.getbranch(button[i].action, "_") =="white"){
									Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[5]);
								}else if (Help.getbranch(button[i].action, "_") == "red") {
									Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), 255, 0, 0);
								}else if (Help.getbranch(button[i].action, "_") == "green") {
									Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), 0, 255, 0);
								}else if (Help.getbranch(button[i].action, "_") == "blue") {
									Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), 16, 16, 255);
								}
								Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y + button[i].position.height) - 2, Std.int(button[i].position.width), 2, Def.GRAY[0]);
								
								tx = Std.int(button[i].position.x) + Std.int((button[i].position.width - Text.normallen(button[i].text)) / 2);
								ty = Std.int(button[i].position.y) + Std.int(((button[i].position.height) - 10) / 2);
								if(Help.getbranch(button[i].action, "_") =="white"){
									Gfx.normalprint(tx, ty, button[i].text, 0, 0, 0, false);
								}else {
									Gfx.normalprint(tx, ty, button[i].text, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
								}
							case "textentry":
								if(button[i].mouseover){
									Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[1]);
								}else {
									Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[0]);
								}
								
								tx = Std.int(button[i].position.x) + Std.int((button[i].position.width - Text.normallen(button[i].text)) / 2);
								ty = Std.int(button[i].position.y) + Std.int(((button[i].position.height) - 24) / 2);
								if(button[i].mouseover){
									Gfx.normalbigprint(tx, ty, button[i].text, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
								}else {
									Gfx.normalbigprint(tx, ty, button[i].text, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
								}
							case "normal":
								if(button[i].mouseover){
									Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[4]);
								}else {
									Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[3]);
								}
								Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y + button[i].position.height) - 2, Std.int(button[i].position.width), 2, Def.GRAY[0]);
								
								tx = Std.int(button[i].position.x) + Std.int((button[i].position.width) / 2) - Std.int(Text.normallen(button[i].text) / 2);
								ty = Std.int(button[i].position.y) + Std.int(((button[i].position.height) - 14) / 2);
								if(button[i].mouseover){
									Gfx.normalprint(tx, ty, button[i].text, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
								}else {
									Gfx.normalprint(tx, ty, button[i].text, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
								}
							case "tiny":
								if(button[i].mouseover){
									Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[4]);
								}else {
									Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[3]);
								}
								Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y + button[i].position.height) - 2, Std.int(button[i].position.width), 2, Def.GRAY[0]);
								
								tx = Std.int(button[i].position.x) + Std.int((button[i].position.width) / 2) - Std.int(Text.len(button[i].text) / 2);
								ty = Std.int(button[i].position.y) + Std.int(((button[i].position.height) - 7) / 2);
								if(button[i].mouseover){
									Gfx.smallprint(tx, ty, button[i].text, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
								}else {
									Gfx.smallprint(tx, ty, button[i].text, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
								}
							case "tab":
								if(button[i].mouseover){
									Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[4]);
								}else {
									Gfx.fillrect(Std.int(button[i].position.x), Std.int(button[i].position.y), Std.int(button[i].position.width), Std.int(button[i].position.height), Def.GRAY[3]);
								}
								
								tx = Std.int(button[i].position.x) + Std.int((button[i].position.width - Text.normallen(button[i].text)) / 2);
								ty = Std.int(button[i].position.y) + Std.int(((button[i].position.height) - 10) / 2);
								if(button[i].mouseover){
									Gfx.normalprint(tx, ty, button[i].text, Def.GRAY[5], Def.GRAY[5], Def.GRAY[5], false);
								}else {
									Gfx.normalprint(tx, ty, button[i].text, Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
								}
						}
					}
				}
			}
		}
	}
	
	public static function deleteall(t:String):Void {
		//Deselect any buttons with stype t
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (button[i].style == t) {
					button[i].active = false;
				}
			}
		}
	}
	
	public static function clearcolourtext():Void {
		//Special function to remove numbers from colour buttons
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (button[i].style == "colour") {
					button[i].text = "";
					button[i].visable = true;
				}
			}
		}
	}
	
	public static function clearcolourtexteditorborder():Void {
		//Special function to remove numbers from colour buttons
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (Help.getroot(button[i].action, "_") == "editorborder"){
					button[i].text = "";
					button[i].visable = true;
				}
			}
		}
	}
	
	public static function clearcolourtexteditorcolour():Void {
		//Special function to remove numbers from colour buttons
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (Help.getroot(button[i].action, "_") == "editorcolour"){
					button[i].text = "";
					button[i].visable = true;
				}
			}
		}
	}
	
	public static function hidecolourseditorborder():Void {
		//Special function to hide the colour buttons completely
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (Help.getroot(button[i].action, "_") == "editorborder") {
					button[i].visable = false;
				}
			}
		}
	}
	
	public static function hidecolourseditorcolour():Void {
		//Special function to hide the colour buttons completely
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (Help.getroot(button[i].action, "_") == "editorcolour") {
					button[i].visable = false;
				}
			}
		}
	}
	
	public static function hidecolours():Void {
		//Special function to hide the colour buttons completely
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (button[i].style == "colour") {
					button[i].visable = false;
				}
			}
		}
	}
	
	public static function showtwocolourtexteditorborder():Void {
		//Special function to add numbers to colour buttons
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (Help.getroot(button[i].action, "_") == "editorborder") {
					button[i].text = "";
					if (Edphase.bordercolour1[Edphase.currentframe] == Help.getbranch(button[i].action, "_")) {
						button[i].text = "1";
					}
					if (Edphase.bordercolour2[Edphase.currentframe] == Help.getbranch(button[i].action, "_")) {
						button[i].text = "2";
					}
					button[i].visable = true;
				}
			}
		}
	}
	
	public static function showtwocolourtexteditorcolour():Void {
		//Special function to add numbers to colour buttons
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (Help.getroot(button[i].action, "_") == "editorcolour") {
					button[i].text = "";
					if (Edphase.colourcolour1[Edphase.currentframe] == Help.getbranch(button[i].action, "_")) {
						button[i].text = "1";
					}
					if (Edphase.colourcolour2[Edphase.currentframe] == Help.getbranch(button[i].action, "_")) {
						button[i].text = "2";
					}
					button[i].visable = true;
				}
			}
		}
	}
	
	public static function showtwocolourtext():Void {
		//Special function to add numbers to colour buttons
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (button[i].style == "colour") {
					button[i].text = "";
					if (Control.guicol1 == Help.getbranch(button[i].action, "_")) {
						button[i].text = "1";
					}
					if (Control.guicol2 == Help.getbranch(button[i].action, "_")) {
						button[i].text = "2";
					}
					button[i].visable = true;
				}
			}
		}
	}
	
	public static function showtwocolourtext_border():Void {
		//Special function to add numbers to colour buttons
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (button[i].style == "colour") {
					button[i].text = "";
					if (Control.guibordercol1 == Help.getbranch(button[i].action, "_")) {
						button[i].text = "1";
					}
					if (Control.guibordercol2 == Help.getbranch(button[i].action, "_")) {
						button[i].text = "2";
					}
					button[i].visable = true;
				}
			}
		}
	}
	
	public static function selectbutton(t:String):Void {
		//select any buttons with action t
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (button[i].action == t) {
					dobuttonaction(i);
					button[i].selected = true;
				}
			}
		}
	}
	
	
	public static function deselect(t:String):Void {
		//Deselect any buttons with action t
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (button[i].action == t) {
					button[i].selected = false;
				}
			}
		}
	}
	
	public static function deselectall(t:String):Void {
		//Deselect any buttons with style t
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (button[i].style == t) {
					button[i].selected = false;
				}
			}
		}
	}
	
	public static function changetab(t:String):Void {
		if (waitfortext) entertext();
		
		for (i in 0...Gui.numbuttons) {
			if (Gui.button[i].active) {
				if (Gui.button[i].text == t.toUpperCase()) {
					Gui.button[i].selected = true;
				}
			}
		}
		
		switch(t) {
			case "message":
				addbutton(10, 140, 360, 40, Control.guimessage, "message", "textentry");
				addbutton(Std.int((Gfx.screenwidth / 2) - 100), 192, 200, 20, "random suggestion");
			case "colour":
				addbutton(10, 140, 108, 20, "simple", "colour_simple");
				addbutton(10, 166, 108, 20, "flash", "colour_flash");
				addbutton(10, 192, 108, 20, "fire", "colour_fire");
				
				addbutton(136, 140, 108, 20, "slow cycle", "colour_slowcycle");
				addbutton(136, 166, 108, 20, "fast cycle", "colour_fastcycle");
				addbutton(136, 192, 108, 20, "gradient", "colour_gradient");
				
				addbutton(262, 140, 108, 20, "flicker", "colour_flicker");
				addbutton(262, 166, 108, 20, "stripe", "colour_stripe");
				
				addbutton(262, 192, 24, 20, "", "colour_white", "colour");
				addbutton(290, 192, 24, 20, "", "colour_red", "colour");
				addbutton(318, 192, 24, 20, "", "colour_green", "colour");
				addbutton(346, 192, 24, 20, "", "colour_blue", "colour");
				
				//Highlight the button and colours already in use
				selectbutton("colour_" + Control.guicol1);
				selectbutton(Control.guicol);
			case "border":
				addbutton(10, 140, 108, 20, "none", "border_none");
				addbutton(10, 166, 108, 20, "colourful", "border_gradient1");
				addbutton(10, 192, 108, 20, "rainbow", "border_gradient2");
				
				addbutton(136, 140, 108, 20, "flash", "border_flash");
				addbutton(136, 166, 108, 20, "gap", "border_gap");
				addbutton(136, 192, 108, 20, "flicker", "border_flicker");
				
				addbutton(262, 140, 108, 20, "alternate", "border_alternate");
				addbutton(262, 166, 108, 20, "particles", "border_particles");
				
				addbutton(262, 192, 24, 20, "", "border_white", "colour");
				addbutton(290, 192, 24, 20, "", "border_red", "colour");
				addbutton(318, 192, 24, 20, "", "border_green", "colour");
				addbutton(346, 192, 24, 20, "", "border_blue", "colour");
				
				//Highlight the button and colours already in use
				selectbutton("border_" + Control.guibordercol1);
				selectbutton(Control.guiborder);
			case "effect":
				addbutton(10, 140, 108, 20, "none", "effect_none");
				addbutton(10, 166, 108, 20, "fall down", "effect_dropin");
				addbutton(10, 192, 108, 20, "join", "effect_split");
				
				addbutton(136, 140, 108, 20, "open", "effect_zoomin");
				addbutton(136, 166, 108, 20, "teleport", "effect_teleport");
				addbutton(136, 192, 108, 20, "build", "effect_pixel");
				
				addbutton(262, 140, 108, 20, "wave", "effect_bob");
				addbutton(262, 166, 108, 20, "twist", "effect_midsplit");
				addbutton(262, 192, 108, 20, "invert", "effect_invert");
				
				//Highlight the button already in use
				selectbutton(Control.guieffect);
			case "frame":
				for (i in 0...Control.frame[Gfx.sign].getlength()) {
					addbutton(18 + (i * 40), 140, 28, 20, Std.string(i + 1), "frame_" + Std.string(i));
				}
				
				if(Control.frame[Gfx.sign].getlength()>1){
				  addbutton(18 + (Control.currentframe[Gfx.sign] * 40) + 4, 164, 20, 16, "-", "frame_delete");
				}
				if(Control.frame[Gfx.sign].getlength()<9){
					addbutton(18 + ((Control.frame[Gfx.sign].getlength()) * 40), 142, 20, 16, "+", "frame_add");
				}
				
				addbutton(Std.int((Gfx.screenwidth / 2) - 70), 192, 140, 20, "finish", "frame_finish");
				
				//Highlight the button already in use
				for (i in 0...numbuttons) {
					if (button[i].active) {
						if (button[i].action == "frame_" + Std.string(Control.currentframe[Gfx.sign])) {
							button[i].selected = true;
						}
					}
				}
		}
	}
	
	public static function findbuttonbyaction(t:String):Int {
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (button[i].action == t) {
					return i;
				}
			}
		}
		return 0;
	}
	
	public static function dobuttonaction(i:Int):Void {
		//Deselect other buttons in the same category. In the future, figure out a nice
		//way to do this!
		buttonkludge = false;
		deselectall("textentry");
		
		switch(button[i].style) {
			case "colour":
				deselectall("colour");
			case "normal":
				deselectall("normal");
			case "tab":
				deselectall("tab");
				deleteall("normal");
				deleteall("colour");
				deleteall("textentry");
				
				changetab(Help.getbranch(button[i].action, "_"));
		}
		
		if (button[i].style == "colour") {
			if (Help.getroot(button[i].action, "_") == "colour") {
				if (Help.getbranch(button[i].action, "_") != Control.guicol1) Control.guicol2 = Control.guicol1;
				Control.guicol1 = Help.getbranch(button[i].action, "_");	
			}else if (Help.getroot(button[i].action, "_") == "border") {
				if (Help.getbranch(button[i].action, "_") != Control.guibordercol1) Control.guibordercol2 = Control.guibordercol1;
				Control.guibordercol1 = Help.getbranch(button[i].action, "_");	
			}else if (Help.getroot(button[i].action, "_") == "editorborder") {
				if (Help.getbranch(button[i].action, "_") != Edphase.bordercolour1[Edphase.currentframe]) Edphase.bordercolour2[Edphase.currentframe] = Edphase.bordercolour1[Edphase.currentframe];
				Edphase.bordercolour1[Edphase.currentframe] = Help.getbranch(button[i].action, "_");	
				Edphase.updateframe(Edphase.currentframe);
			}else if (Help.getroot(button[i].action, "_") == "editorcolour") {
				if (Help.getbranch(button[i].action, "_") != Edphase.colourcolour1[Edphase.currentframe]) Edphase.colourcolour2[Edphase.currentframe] = Edphase.colourcolour1[Edphase.currentframe];
				Edphase.colourcolour1[Edphase.currentframe] = Help.getbranch(button[i].action, "_");	
				Edphase.updateframe(Edphase.currentframe);
			}
		}
		
		if (Help.getroot(button[i].action, "_") == "colour") {
			//Change colours!
			tempstring = button[i].action;
			if (button[i].action == "colour_white" || button[i].action == "colour_red"
			  ||button[i].action == "colour_green" || button[i].action == "colour_blue") {
				tempstring = Control.guicol;
			}else {
				Control.guicol = button[i].action;
			}
			
			switch(tempstring) {
				case "colour_simple":
					Control.frame[Gfx.sign].colour[Control.currentframe[Gfx.sign]] = Control.guicol1;
					clearcolourtext();
				case "colour_flash":
					Control.frame[Gfx.sign].colour[Control.currentframe[Gfx.sign]] = Control.guicol1 + "_flash";
					clearcolourtext();
				case "colour_flicker":
					Control.frame[Gfx.sign].colour[Control.currentframe[Gfx.sign]] = Control.guicol1 + "-" +Control.guicol2 + "_flicker";
					showtwocolourtext();
				case "colour_fire":
					Control.frame[Gfx.sign].colour[Control.currentframe[Gfx.sign]] = Control.guicol1 + "_fire";
					clearcolourtext();
				case "colour_stripe":
					Control.frame[Gfx.sign].colour[Control.currentframe[Gfx.sign]] = Control.guicol1 + "-" +Control.guicol2 + "_stripe";
					showtwocolourtext();
				case "colour_gradient":
					Control.frame[Gfx.sign].colour[Control.currentframe[Gfx.sign]] = "gradient";
					hidecolours();
				case "colour_slowcycle":
					Control.frame[Gfx.sign].colour[Control.currentframe[Gfx.sign]] = "slow_cycle";
					hidecolours();
				case "colour_fastcycle":
					Control.frame[Gfx.sign].colour[Control.currentframe[Gfx.sign]] = "fast_cycle";
					hidecolours();
			}
			
			Gfx.changecolour(Control.frame[Gfx.sign].colour[Control.currentframe[Gfx.sign]]);
		}
		
		if (Help.getroot(button[i].action, "_") == "border") {
			//Change borders!
			tempstring = button[i].action;
			if (button[i].action == "border_white" || button[i].action == "border_red"
			  ||button[i].action == "border_green" || button[i].action == "border_blue") {
				tempstring = Control.guiborder;
			}else {
				Control.guiborder = button[i].action;
			}
			
			switch(tempstring) {
				case "border_none":
					Control.frame[Gfx.sign].border[Control.currentframe[Gfx.sign]] = "none";
					hidecolours();
				case "border_gradient1":
					Control.frame[Gfx.sign].border[Control.currentframe[Gfx.sign]] = "gradient";
					hidecolours();
				case "border_gradient2":
					Control.frame[Gfx.sign].border[Control.currentframe[Gfx.sign]] = "longgradient";
					hidecolours();
				case "border_flash":
					Control.frame[Gfx.sign].border[Control.currentframe[Gfx.sign]] = Control.guibordercol1 + "_flash";
					clearcolourtext();
				case "border_gap":
					Control.frame[Gfx.sign].border[Control.currentframe[Gfx.sign]] = Control.guibordercol1 + "_gap";
					clearcolourtext();
				case "border_flicker":
					Control.frame[Gfx.sign].border[Control.currentframe[Gfx.sign]] = Control.guibordercol1 + "_flicker";
					clearcolourtext();
				case "border_alternate":
					Control.frame[Gfx.sign].border[Control.currentframe[Gfx.sign]] = Control.guibordercol1 + "-" +Control.guibordercol2 + "_alternate";
					showtwocolourtext_border();
				case "border_particles":
					Control.frame[Gfx.sign].border[Control.currentframe[Gfx.sign]] = Control.guibordercol1 + "-" +Control.guibordercol2 + "_particles";
					showtwocolourtext_border();
			}
			
			Gfx.changeborder(Control.frame[Gfx.sign].border[Control.currentframe[Gfx.sign]]);
		}
		
		if (Help.getroot(button[i].action, "_") == "effect") {
			//Change effects!
			tempstring = button[i].action;			
			Control.guieffect = button[i].action;
			
			switch(Control.guieffect) {
				case "effect_none":
					Control.frame[Gfx.sign].effect[Control.currentframe[Gfx.sign]] = "none";
				case "effect_dropin":
					Control.frame[Gfx.sign].effect[Control.currentframe[Gfx.sign]] = "dropin";
				case "effect_split":
					Control.frame[Gfx.sign].effect[Control.currentframe[Gfx.sign]] = "split";
				case "effect_zoomin":
					Control.frame[Gfx.sign].effect[Control.currentframe[Gfx.sign]] = "zoomin";
				case "effect_teleport":
					Control.frame[Gfx.sign].effect[Control.currentframe[Gfx.sign]] = "teleport";
				case "effect_pixel":
					Control.frame[Gfx.sign].effect[Control.currentframe[Gfx.sign]] = "pixel";
				case "effect_bob":
					Control.frame[Gfx.sign].effect[Control.currentframe[Gfx.sign]] = "bob";
				case "effect_midsplit":
					Control.frame[Gfx.sign].effect[Control.currentframe[Gfx.sign]] = "midsplit";
				case "effect_invert":
					Control.frame[Gfx.sign].effect[Control.currentframe[Gfx.sign]] = "invert";
			}
			
			Control.changeeffect(Control.frame[Gfx.sign].effect[Control.currentframe[Gfx.sign]]);
			Control.frame[Gfx.sign].delay = Control.waittime;
			
			Control.changecurrenttext(Control.frame[Gfx.sign].message[Control.currentframe[Gfx.sign]]);
		}
		
		if (button[i].action == "message" || button[i].action == "message_ingame") {
			//Change text!
			inittext(button[i].text);
		}
		
		
		if (Help.getroot(button[i].action, "_") == "frame") {
			switch(button[i].action) {
				case "frame_0", "frame_1", "frame_2", "frame_3", "frame_4", 
				     "frame_5", "frame_6", "frame_7", "frame_8", "frame_9":
					Control.currentframe[Gfx.sign] = Std.parseInt(Help.getbranch(button[i].action, "_"));
					Control.guitab = "frame";
					deleteall("normal");
					Control.editorchangeframe();
					
					Gfx.changecolour(Control.frame[Gfx.sign].colour[Control.currentframe[Gfx.sign]]);
					Gfx.changeborder(Control.frame[Gfx.sign].border[Control.currentframe[Gfx.sign]]);
					Control.changeeffect(Control.frame[Gfx.sign].effect[Control.currentframe[Gfx.sign]]);
					Control.frame[Gfx.sign].delay = Control.waittime;
					
					Control.changecurrenttext(Control.frame[Gfx.sign].message[Control.currentframe[Gfx.sign]]);
					buttonkludge = true;
				case "frame_delete":
					Control.frame[Gfx.sign].delete(Control.currentframe[Gfx.sign]);
					
					Control.guitab = "frame";
					deselectall("tab");
					deleteall("normal");
					Control.editorchangeframe();
					
					Gfx.changecolour(Control.frame[Gfx.sign].colour[Control.currentframe[Gfx.sign]]);
					Gfx.changeborder(Control.frame[Gfx.sign].border[Control.currentframe[Gfx.sign]]);
					Control.changeeffect(Control.frame[Gfx.sign].effect[Control.currentframe[Gfx.sign]]);
					Control.frame[Gfx.sign].delay = Control.waittime;
					
					Control.changecurrenttext(Control.frame[Gfx.sign].message[Control.currentframe[Gfx.sign]]);
					buttonkludge = true;
				case "frame_add":
					Control.frame[Gfx.sign].add("new", "white", "none", "none");
					Control.currentframe[Gfx.sign] = Control.frame[Gfx.sign].getlength() - 1;
					
					Control.guitab = "frame";
					deleteall("normal");
					Control.editorchangeframe();
					
					Gfx.changecolour(Control.frame[Gfx.sign].colour[Control.currentframe[Gfx.sign]]);
					Gfx.changeborder(Control.frame[Gfx.sign].border[Control.currentframe[Gfx.sign]]);
					Control.changeeffect(Control.frame[Gfx.sign].effect[Control.currentframe[Gfx.sign]]);
					Control.frame[Gfx.sign].delay = Control.waittime;
					
					Control.changecurrenttext(Control.frame[Gfx.sign].message[Control.currentframe[Gfx.sign]]);
					buttonkludge = true;
				case "frame_finish":
					deleteall("normal");
					deleteall("tab");
					Control.endeditmode();
			}
		}
		
		if (button[i].action == "random suggestion") {
			if (waitfortext) entertext();
			inputField.text = "";
			for (j in 0...numbuttons) {
				if (button[j].active) {
					if (button[j].style == "textentry") {
						lastentry = Control.randomsuggestions[Std.int(Math.random() * Control.numsuggestions)];
						while(lastentry == button[j].text){
							lastentry = Control.randomsuggestions[Std.int(Math.random() * Control.numsuggestions)];
					  }
						
						tx = Std.int(Math.random() * Control.numsuggestions);
						ty = (tx + 1) % Control.numsuggestions;
						if (Control.randomsuggestionscore[ty] < Control.randomsuggestionscore[tx]) {
							lastentry = Control.randomsuggestions[ty];
							Control.randomsuggestionscore[ty]++;
						}	else {
							lastentry = Control.randomsuggestions[tx];
							Control.randomsuggestionscore[tx]++;
						}
						button[j].text = lastentry;
					}
				}
			}
			
			Control.guimessage = lastentry;
			Control.frame[Gfx.sign].message[Control.currentframe[Gfx.sign]] = lastentry;
			Control.changecurrenttext(lastentry);
			
			Control.changeeffect(Control.frame[Gfx.sign].effect[Control.currentframe[Gfx.sign]]);
			Control.frame[Gfx.sign].delay = Control.waittime;
			buttonkludge = true;
		}
		
		if (button[i].action == "skipintro") {
			deleteall("tiny");
		  Script.load("skipintro");
			if (Gfx.fademode == Def.FADED_IN) {
				Gfx.fademode = Def.FADE_OUT;
			}
		}else	if (button[i].action == "gotomenu") {
			Gfx.fademode = Def.FADE_OUT;
			Gfx.fadeaction = "titlescreen";
		}else if (button[i].action == "startgame") {
			Gfx.fademode = Def.FADE_OUT;
			Gfx.fadeaction = "startgame";
		}else if (button[i].action == "loadgame") {
			Gfx.fademode = Def.FADE_OUT;
			Gfx.fadeaction = "loadgame";
		}else if (button[i].action == "editor") {
			Gfx.fademode = Def.FADE_OUT;
			Gfx.fadeaction = "starteditor";
		}else if (button[i].action == "exportsign") {
			Control.currentscreen = "export2";
			buttonkludge = true;
			deleteall("normal");
			deleteall("flashing");
			Gui.addbutton(Gfx.screenwidthmid - 20, 160, 40, 20, "OK", "gotomenu");
		}else if (button[i].action == "game_shop") {
			Control.currentscreen = "game_shop";
			buttonkludge = true;
			deleteall("normal");
			
			Control.initshop();
		}else if (button[i].action == "game_editor") {
			Control.currentscreen = "game_editor";
			buttonkludge = true;
			deleteall("normal");
			
			Edphase.initeditorphase();
		}else if (button[i].action == "skiptoscores") {
			//Ok, just make the best sign you can automatically
			Edphase.initeditorphase();
			Edphase.pickplayersigns();
			
			Gfx.fademode = Def.FADE_OUT;
			Gfx.fadeaction = "playout";
		}else if (button[i].action == "game_playout") {
			Gfx.fademode = Def.FADE_OUT;
			Gfx.fadeaction = "playout";
		}else if (button[i].action == "adviceyes") {
			deleteall("normal");
			Control.changeshopstate("shoptutorial_yes");
		}else if (button[i].action == "adviceno") {
			deleteall("normal");
			Control.changeshopstate("shoptutorial_no");
		}
	}
	
	public static var button:Array<GuiButton> = new Array<GuiButton>();
	public static var numbuttons:Int = 0;
	public static var maxbuttons:Int = 100;
	
	public static var gamestage:Stage;
	
	public static var buttonkludge:Bool = false;
	public static var tempstring:String;
	public static var tx:Int;
	public static var ty:Int;
}