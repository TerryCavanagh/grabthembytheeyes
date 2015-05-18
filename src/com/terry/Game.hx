package com.terry;

import com.terry.util.*;
import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.Lib;
import openfl.system.Capabilities;
	
class Game {
	public static function init(_stage:Stage):Void {
		gamestage = _stage;
		gamestage.addEventListener(Event.DEACTIVATE, windowNotActive);
		gamestage.addEventListener(Event.ACTIVATE, windowActive);
		
		infocus = true; paused = false; muted = false; globalsound = 1;
		gamestate = Def.TITLEMODE; completestop = false;
		hascontrol = true; jumpheld = false; jumppressed = 0;
		roomname = ""; roomnamemode = 0;
		pausescript = false; speaker = "";
		parsetext = false;
		
		Def.DEVICEXRES = Std.int(flash.system.Capabilities.screenResolutionX);
		Def.DEVICEYRES = Std.int(flash.system.Capabilities.screenResolutionY);
		//Lib.current.stage.stageWidth?
		
		deathseq = 0;
		
		test = false; teststring = "TEST = True";
		
		//Init scripting
		for (i in 0...500) {
			commands.push(new String(""));
		}
		
		for (i in 0...100) {
			words.push(new String(""));
			txt.push(new String(""));
		}
		
		position = 0; scriptlength = 0; scriptdelay = 0;
		running = false;
	}
	
	public static function windowNotActive(e:Event):Void{ infocus = false; }
  public static function windowActive(e:Event):Void { infocus = true; }
	
	public static function justpressed_up():Bool {
		if (Key.justPressed("UP") || Key.justPressed("W")) return true;
		return false;
	}
	
	public static function justpressed_down():Bool {
		if (Key.justPressed("DOWN") || Key.justPressed("S")) return true;
		return false;
	}
	
	public static function justpressed_left():Bool {
		if (Key.justPressed("LEFT") || Key.justPressed("A")) return true;
		return false;
	}
	
	public static function justpressed_right():Bool {
		if (Key.justPressed("RIGHT") || Key.justPressed("D")) return true;
		return false;
	}
	
	public static function justpressed_action():Bool {
		if (Key.justPressed("Z") || Key.justPressed("SPACE")) return true;
		return false;
	}
	
	public static function justpressed_map():Bool {
		if (Key.justPressed("ENTER") || Key.justPressed("X")) return true;
		return false;
	}
	
	public static function keypoll():Void {
		press_up = false; press_down = false; 
		press_left = false; press_right = false; press_action = false; press_map = false;
		
		if (Key.pressed("LEFT") || Key.pressed("A")) press_left = true;
		if (Key.pressed("RIGHT") || Key.pressed("D")) press_right = true;
		if (Key.pressed("UP") || Key.pressed("W")) press_up= true;
		if (Key.pressed("DOWN") || Key.pressed("S")) press_down = true;
		if (Key.pressed("Z") || Key.pressed("SPACE")) press_action = true;
		if (Key.pressed("ENTER") || Key.pressed("X")) press_map = true;
		
		if (haspriority) {
			if (press_left || press_right) {
				if (press_up || press_down) {
					//Both horizontal and vertical are being pressed: one must take priority
					if (keypriority == 1) { keypriority = 4;
					}else if (keypriority == 2) { keypriority = 3;
					}else if (keypriority == 0) { keypriority = 3;
					}
				}else {keypriority = 1;}
			}else if (press_up || press_down) {keypriority = 2;}else {keypriority = 0;}
			
			if (keypriority == 3) {press_up = false; press_down = false;
			}else if (keypriority == 4) { press_left = false; press_right = false; }
		}
		/*
		if (Key.justPressed("F")) {
			//Toggle fullscreen
			if (fullscreen) {fullscreen = false;
			}else {fullscreen = true;}
			updategraphicsmode();
		}
		*/
		#if flash
		if (Key.pressed("ESCAPE") && fullscreen) {
			fullscreen = false;
			updategraphicsmode();
		}
		#end
		
		if (keyheld) {
			if (press_action || press_right || press_left || press_map ||
					press_down || press_up) {
				press_action = false;
				press_map = false;
				press_up = false;
				press_down = false;
				press_left = false;
				press_right = false;
			}else {
				keyheld = false;
			}
		}
	}
	
	public static function setzoom(t:Int):Void {
		Gfx.screen.width = Gfx.screenwidth * t;
		Gfx.screen.height = Gfx.screenheight * t;
		Gfx.screen.x = (Gfx.screenviewwidth - (Gfx.screenwidth * t)) / 2;
		Gfx.screen.y = (Gfx.screenviewheight - (Gfx.screenheight * t)) / 2;
	}
	
	public static function updategraphicsmode():Void {
		//This was always incomplete
		if (fullscreen) {
			Lib.current.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			
			gamestage.scaleMode = StageScaleMode.SHOW_ALL;
		}else{
			Lib.current.stage.displayState = StageDisplayState.NORMAL;
			Gfx.screen.width = Gfx.screenwidth * Def.SCREENSCALE;
			Gfx.screen.height = Gfx.screenheight * Def.SCREENSCALE;
			Gfx.screen.x = 0.0;
			Gfx.screen.y = 0.0;
			
			gamestage.scaleMode = StageScaleMode.SHOW_ALL;
		}
	}
	
	public static function add(t:String):Void {
		commands[scriptlength] = t;
		scriptlength++;
	}
	
	public static function loadexternalscript(t:String):Bool {
		#if flash
		return false;
		#else
		return Fileaccess.loadscriptfile(t);
		#end
	}
	
	public static function tokenize(t:String):Void {
		numwords = 0; tempword = "";
		
		if (parsetext) {
			words[0] = t;
		}
		
		if (!parsetext) {
			for (i in 0...t.length) {
				currentletter = t.substr(i, 1);
				if (currentletter == "(" || currentletter == ")" || currentletter == ",") {
					words[numwords] = tempword;
					//If it's an instruction to talk, then we do something different
					if (numwords == 0 && words[0] == "say") {
						words[1] = Help.getbrackets(t);
						break;
					}else if (numwords == 0 && words[0] == "talk") {
						words[1] = Help.getbrackets(t);
						break;
					}else if (numwords == 0 && words[0] == "speaker") {
						words[1] = Help.getbrackets(t);
						break;
					}else if (numwords == 0 && words[0] == "call") {
						words[1] = Help.getbrackets(t);
						break;
					}else {
						words[numwords] = words[numwords].toLowerCase();
					}
					numwords++; tempword = "";
				}else if (currentletter == " ") {
					//don't do anything - i.e. strip out spaces.
				}else {
					tempword += currentletter;
				}
			}
			
			if (tempword != "") {
				words[numwords] = tempword;
				numwords++;
			}
		}
		
		if (words[0].charAt(0) == "}") {
			words[0] = "endsay";
			parsetext = false;
		}
	}
	
	public static function releasekeys():Void {
		keyheld = true;
		
		press_action = false;
		press_map = false;
		
		press_up = false;
		press_down = false;
		press_left = false;
		press_right = false;
	}
		
	public static var fullscreen:Bool;
	public static var gamestage:Stage;
	
	public static var press_up:Bool;
	public static var press_down:Bool; 
	public static var press_left:Bool;
	public static var press_right:Bool;
	public static var press_action:Bool;
	public static var press_map:Bool;
	
	public static var keypriority:Int = 0;
	public static var haspriority:Bool = false;
	public static var keyheld:Bool;
	public static var keydelay:Int;
	
	public static var gamestate:Int;
	public static var pausescript:Bool;
	public static var hascontrol:Bool;
	public static var jumpheld:Bool;
	public static var jumppressed:Int;
	public static var roomname:String;
	public static var roomnamemode:Int;
	
	public static var mx:Int; 
	public static var my:Int;
	public static var test:Bool;
	public static var teststring:String;
	
	public static var infocus:Bool;
	public static var paused:Bool;
	public static var muted:Bool; 
	public static var mutebutton:Int;
	public static var globalsound:Float;
	public static var deathseq:Int;
	public static var completestop:Bool;
	
	//Script contents
	public static var commands:Array<String> = new Array<String>();
	public static var words:Array<String> = new Array<String>();
	public static var txt:Array<String> = new Array<String>();
	public static var scriptname:String;
	public static var position:Int;
	public static var scriptlength:Int;
	public static var looppoint:Int;
	public static var loopcount:Int;
	
	public static var scriptdelay:Int;
	public static var running:Bool;
	public static var tempword:String;
	public static var currentletter:String;
	public static var numwords:Int;
	public static var parsetext:Bool;
	public static var speaker:String;
}