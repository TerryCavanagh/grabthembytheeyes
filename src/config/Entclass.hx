package config;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;

class Entclass {
	public function new() {
		clear();
	}
	
	public function clear():Void {
		//Set all values to a default, required for creating a new entity
		active = false; invis = false;
		type = "null";  tile = 0; rule = "null";
		name = "null"; stringpara = "null";
		state = 0; statedelay = 0; life = 0; colour = 0; para = 0;
		behave = 0; animate = 0;
		
		xp = 0; yp = 0; ax = 0; ay = 0; vx = 0; vy = 0;
		w = Def.SPRITESIZEWIDTH; h = Def.SPRITESIZEHEIGHT; cx = 0; cy = 0;
		newxp = 0; newyp = 0;
		
		transx = 0; transy = 0;	rot = 0;
		
		x1 = 0; y1 = 0; x2 = Def.SCREENWIDTH; y2 = Def.SCREENHEIGHT;
		
		jumping = false; gravity = false; onground = 0; onroof = 0; jumpframe = 0;
		
		onentity = 0; onwall = 0; onxwall = 0; onywall = 0;
		
		framedelay = 0; drawframe = 0; walkingframe = 0; dir = 0; actionframe = 0;
		
		doscriptmove = false;
		scriptmovedestx = 0; scriptmovedesty = 0;
		
		hascart = false;
		
		emote = "normal"; emoteframe = 0; emoteframedelay = 0;
		jumpstate = 100;
	}
	
	public function jump():Void {
		jumpstate = 0;
		jumpframe = 0;
	}
	
	public function updatejump():Void {
		if (jumpstate == 0) {
			jumpframe = 2;
		}else if (jumpstate == 1) {
			jumpframe+=2;
		}else if (jumpstate == 2) {
			jumpframe++;
		}else if (jumpstate == 3) {
		}else if (jumpstate == 4) {
			jumpframe--;
		}else if (jumpstate == 5) {
			jumpframe-=2;
		}else if (jumpstate == 6) {
			jumpframe-=2;
		}
		
		if(jumpstate<100) jumpstate++;
	}
	
	public var jumpstate:Int = 0;
	
	public var hascart:Bool;
	
	public var scriptmovedestx:Int;
	public var scriptmovedesty:Int;
	public var doscriptmove:Bool;
	
	public var emote:String;
	public var emoteframe:Int;
	public var emoteframedelay:Int;
	
	//Fundamentals
	public var active:Bool;
	public var invis:Bool;
	public var type:String;
	public var tile:Int;
	public var rule:String;
	public var state:Int;
	public var statedelay:Int;
	public var behave:Int;
	public var animate:Int;
	public var para:Int;
	public var life:Int;
	public var colour:Int;
	public var name:String;
	public var stringpara:String;
	//Position and velocity
	public var xp:Float;
	public var yp:Float;
	public var oldxp:Float;
	public var oldyp:Float;
	public var ax:Float;
	public var ay:Float;
	public var vx:Float;
	public var vy:Float;
	public var cx:Int;
	public var cy:Int;
	public var w:Int;
	public var h:Int;
	public var newxp:Float;
	public var newyp:Float; //For collision functions
	public var x1:Int;
	public var y1:Int;
	public var x2:Int;
	public var y2:Int;
	public var rot:Float;
	public var transx:Int;
	public var transy:Int;
	//Collision Rules
	public var onentity:Int;
	public var onwall:Int;
	public var onxwall:Int;
	public var onywall:Int;
	
	//Platforming specific
	public var jumping:Bool;
	public var gravity:Bool;
	public var onground:Int;
	public var onroof:Int;
	public var jumpframe:Int;
	//Animation
	public var framedelay:Int;
	public var drawframe:Int;
	public var walkingframe:Int;
	public var dir:Int;
	public var actionframe:Int;
}
