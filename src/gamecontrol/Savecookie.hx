package gamecontrol;

import openfl.net.*;
import com.terry.*;

class Savecookie {
	public static function init():Void {
		saveexists = 0;
		gamecookie = SharedObject.getLocal("grabthembytheeyes");
		savedeckdata = "";
		
		if (gamecookie.data.saveexists == null) {
			saveexists = 0;
			
			gamecookie.data.saveexists = 0;
			
			//Create a blank cookie!
			blankcookie();
		}else {
			saveexists = gamecookie.data.saveexists;
			saveday = gamecookie.data.day;
		}
	}
	
	public static function loadsettings():Void {
		fullscreen = gamecookie.data.fullscreen;
	}
	
	public static function savefullscreensettings(f:Bool):Void {
		if (f) {
			gamecookie.data.fullscreen = 1;
		}else {
			gamecookie.data.fullscreen = 0;
		}
		gamecookie.flush();
	}
	
	public static function writetosavestring(t:String):Void {
		savedeckdata += t + "|";
		savedeckpos++;
	}
	
	public static function readint():Int {
		savedeckpos++;
		return Std.parseInt(savedeckdataarray[savedeckpos - 1]);
	}
	
	public static function readstring():String {
		savedeckpos++;
		return savedeckdataarray[savedeckpos - 1];
	}
	
	public static function blankcookie():Void {
		gamecookie.data.saveexists = 0;
		gamecookie.data.day = 0;
		gamecookie.data.jaymoney = 0;
		gamecookie.data.fbmoney = 0;
		gamecookie.data.fullscreen = 1;
		
		gamecookie.data.savedeckdata = savedeckdata;
		
		gamecookie.flush();
	}
	
	public static function loaddata():Void {
		saveexists = gamecookie.data.saveexists;
		saveday = gamecookie.data.day;
		savejaymoney = gamecookie.data.jaymoney;
		savefbmoney = gamecookie.data.fbmoney;
		
		savedeckdata = gamecookie.data.savedeckdata;
		savedeckpos = 0;
		savedeckdataarray = new Array<String>();
		savedeckdataarray = savedeckdata.split("|");
		
		for (i in 0...6) {
			Control.dayscore_jay[i] = readint();
			Control.dayscore_fb[i] = readint();
		}
		
		getsavedeck(0, "playerdeck");
		getsavedeck(1, "enemydeck");
		getsavedeck(2, "message_gamedeck");
		getsavedeck(3, "colour_gamedeck");
		getsavedeck(4, "border_gamedeck");
		getsavedeck(5, "effect_gamedeck");
		getsavedeck(6, "extraframe_gamedeck");
	}
	
	public static function savedata():Void {
		gamecookie.data.saveexists = 1;
		gamecookie.data.day = Control.day;
		gamecookie.data.jaymoney = Control.jaybudget;
		gamecookie.data.fbmoney = Control.fbbudget;
		
		savedeckdata = ""; savedeckpos = 0;
		for (i in 0...6) {
			writetosavestring(Std.string(Control.dayscore_jay[i]));
			writetosavestring(Std.string(Control.dayscore_fb[i]));
		}
		
		setsavedeck(0, "playerdeck");
		setsavedeck(1, "enemydeck");
		setsavedeck(2, "message_gamedeck");
		setsavedeck(3, "colour_gamedeck");
		setsavedeck(4, "border_gamedeck");
		setsavedeck(5, "effect_gamedeck");
		setsavedeck(6, "extraframe_gamedeck");
		
		gamecookie.data.savedeckdata = savedeckdata;
		
		gamecookie.flush();
	}
	
	public static function deletesave():Void {
		gamecookie.data.saveexists = 0;
		gamecookie.flush();
	}
	
	public static function setsavedeck(t:Int, deckname:String):Void {
		Control.changeotherdeck(deckname);
		writetosavestring(Std.string(Control.deck[Control.otherdeck].numcards));
		for (i in 0 ... Control.deck[Control.otherdeck].numcards) {
			writetosavestring(Control.deck[Control.otherdeck].card[i].type);
      writetosavestring(Control.deck[Control.otherdeck].card[i].name);
			writetosavestring(Control.deck[Control.otherdeck].card[i].action);
			writetosavestring(Std.string(Control.deck[Control.otherdeck].card[i].score));
			writetosavestring(Control.deck[Control.otherdeck].card[i].special);
		}
	}
	
	public static function getsavedeck(t:Int, deckname:String):Void {
		Control.changedeck(deckname);
		var numcards:Int = readint();
		for (i in 0 ... numcards) {
			temptype = readstring();
			tempname = readstring();
			tempaction = readstring();
			tempscore = readint();
			tempspecial = readstring();
			
			Control.deck[Control.currentdeck].addcard(temptype, tempname, tempaction, tempscore, tempspecial);
		}
	}
	
	public static var gamecookie:SharedObject;
	public static var saveexists:Int;
	public static var fullscreen:Int;
	
	public static var saveday:Int;
	public static var savejaymoney:Int;
	public static var savefbmoney:Int;
	public static var savedeckdata:String = "";
	public static var savedeckdataarray:Array<String> = new Array<String>();
	public static var savedeckpos:Int;
	
	public static var temptype:String;
	public static var tempname:String;
	public static var tempaction:String;
	public static var tempscore:Int;
	public static var tempspecial:String;
	
}