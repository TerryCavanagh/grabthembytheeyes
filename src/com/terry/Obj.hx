package com.terry;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;
import com.terry.util.*;
import gamecontrol.*;
import config.*;
import objs.*;

class Obj {		
	public static function init():Void {		
		nentity = 0;
		temprect = new Rectangle();
		temprect2 = new Rectangle();
		activedoor = "null";
		
		for (z in 0...500) {
			var entity:Entclass = new Entclass();
			entities.push(entity);
			
			var initentity:Initentclass = new Initentclass();
			initentities.push(initentity);
		}
	}
	
	public static function loadtemplates():Void {
		numtemplate = 0;
		for (i in 0...templates.length) {
			addtemplate(templates[i].name);
		}
	}
	
	public static function addtemplate(t:String):Void {
		entindex.set(t, numtemplate);
		numtemplate++;
	}
	
	public static function getgridpoint(t:Int):Int { //This function often needs to be adjusted
		t = Std.int((t - (t % Def.TILESIZE)) / Def.TILESIZE);
		return t;
	}
	
	public static function updateentitylogic(t:Int):Void {
		entities[t].oldxp = entities[t].xp; entities[t].oldyp = entities[t].yp;
		
		entities[t].vx = entities[t].vx + entities[t].ax;
		entities[t].vy = entities[t].vy + entities[t].ay;
		entities[t].ax = 0;
		
		if (entities[t].jumping) {
			if (entities[t].ay < 0) entities[t].ay++;
			if (entities[t].ay > -1) entities[t].ay = 0;
			entities[t].jumpframe--;
			if(entities[t].jumpframe<=0){
				entities[t].jumping=false;
			}
		}else {
			if (entities[t].gravity) entities[t].ay = 3;
		}
		
		entities[t].newxp = entities[t].xp + entities[t].vx;
		entities[t].newyp = entities[t].yp + entities[t].vy;
	}
	
	public static function gettype(t:String):Bool {
		//Returns true is there is an entity of type t onscreen
		for (i in 0...nentity) {
			if (entities[i].type == t) {
				return true;
			}
		}
		
		return false;
	}		
	
	public static function getplayer():Int {
		//Returns the index of the first player entity
		for (i in 0...nentity) {
			if (entities[i].type == "player") {
				return i;
			}
		}
		
		return -1;
	}
	
	public static function getnpc(t:String):Int {
		//Returns the index of the npc by name
		if (t == "player") return getplayer();
		
		for (i in 0...nentity) {
			if (entities[i].name == t) {
				return i;
			}
		}
		
		return -1;
	}
	
	public static function rectset(xi:Int, yi:Int, wi:Int, hi:Int):Void {
		temprect.x = xi; temprect.y = yi; temprect.width = wi; temprect.height = hi;
	}

	public static function rect2set(xi:Int, yi:Int, wi:Int, hi:Int):Void {
		temprect2.x = xi; temprect2.y = yi; temprect2.width = wi; temprect2.height = hi;
	}

	public static function entitycollide(a:Int, b:Int):Bool {
		//Do entities a and b collide?
		tempx = Std.int(entities[a].xp + entities[a].cx); 
		tempy = Std.int(entities[a].yp + entities[a].cy);
		tempw = entities[a].w; temph = entities[a].h;
		rectset(tempx, tempy, tempw, temph);
		
		tempx = Std.int(entities[b].xp + entities[b].cx); 
		tempy = Std.int(entities[b].yp + entities[b].cy);
		tempw = entities[b].w; temph = entities[b].h;
		rect2set(tempx, tempy, tempw, temph);
		if (temprect.intersects(temprect2)) return true;
		return false;
	}
	
	public static function stopmovement(i:Int):Void {
		entities[i].vx = 0;
		entities[i].vy = 0;
		entities[i].ax = 0;
		entities[i].ay = 0;
	}
	
	public static function cleanup():Void {
		var i:Int = 0;
		i = nentity - 1; while (i >= 0 && !entities[i].active) { nentity--; i--; }
	}
	
	public static function createinitentity(xp:Float, yp:Float, t:String, para1:String = "", para2:String = "", para3:String = ""):Int {
		var i:Int = ninitentities;
		
		initentities[i].xp = xp;
		initentities[i].yp = yp;
		initentities[i].type = t;
		initentities[i].para1 = para1;
		initentities[i].para2 = para2;
		initentities[i].para3 = para3;
		
		initentities[i].entity = -1;
		initentities[i].drawframe = templates[entindex.get(t)].init_drawframe;
		initentities[i].para1_selection = 0;
		initentities[i].para2_selection = 0;
		initentities[i].para3_selection = 0;
		
		ninitentities++;
		return i;
	}
	
	public static function copyinitentity(a:Int, b:Int):Void {
		initentities[a].xp = initentities[b].xp;
		initentities[a].yp = initentities[b].yp;
		initentities[a].entity = initentities[b].entity;
		initentities[a].drawframe = initentities[b].drawframe;
		initentities[a].type = initentities[b].type;
		initentities[a].para1 = initentities[b].para1;
		initentities[a].para2 = initentities[b].para2;
		initentities[a].para3 = initentities[b].para3;
		initentities[a].para1_selection = initentities[b].para1_selection;
		initentities[a].para2_selection = initentities[b].para2_selection;
		initentities[a].para3_selection = initentities[b].para3_selection;
	}
	
	public static function removeinitentity(t:Int):Void {
		if (t != ninitentities - 1) {
			for (i in t...ninitentities) {
				copyinitentity(i, i + 1);
			}
		}
		ninitentities--;
	}
	
	public static function getperson(t:String):Int {
		//Given string name t, find the entity that corresponds
		for (i in 0...nentity) {
			if (entities[i].active) {
				if (entities[i].name == t) {
					return i;
				}
			}
		}
		
		//trace("ERROR: character " + t + " is not on the stage");
		return -1;
	}
	
	public static function createentity(xp:Float, yp:Float, t:String, para1:String = "", para2:String = "", para3:String = ""):Int {
		//Find the first inactive case z that we can use to index the new entity
		var i:Int, z:Int;
		if (nentity == 0) {
			//If there are no active entities, Z=0;
			z = 0; nentity++;
		}else {
			i = 0; z = -1;
			while (i < nentity) {
				if (!entities[i].active) {
					z = i; i = nentity;
				}
				i++;
			}
			if (z == -1) {
				z = nentity;
				nentity++;
			}
		}
		
		entities[z].clear();
		entities[z].active = true;
		entities[z].type = t;
		
		entities[z].xp = xp;
		entities[z].yp = yp;
		if (Help.isNumber(para1)) entities[z].vx = Std.parseInt(para1);
		if (Help.isNumber(para2)) entities[z].vy = Std.parseInt(para2);
		if (Help.isNumber(para3)) entities[z].para = Std.parseInt(para3);
		
		templates[entindex.get(t)].create(z, xp, yp, para1, para2, para3);
		return z;
	}
	
	public static function updateentities(i:Int):Bool {
		if(entities[i].active){
			if (entities[i].statedelay <= 0) {
				templates[entindex.get(entities[i].type)].update(i);
			}else {
				entities[i].statedelay--;
				if (entities[i].statedelay < 0) entities[i].statedelay = 0;
			}
		}
		
		return true;
	}
	
	public static function animate_default(i:Int):Void {
		entities[i].drawframe = entities[i].tile;
	}
	
	public static function animateentities(i:Int):Void {
		if(entities[i].active){
			templates[entindex.get(entities[i].type)].animate(i);
		}
	}
	
	public static var nentity:Int;
	public static var entities:Array<Entclass> = new Array<Entclass>();
	public static var tempx:Int;
	public static var tempy:Int;
	public static var tempw:Int;
	public static var temph:Int;
	public static var temp:Int;
	public static var temp2:Int;
	public static var tpx1:Int;
	public static var tpy1:Int;
	public static var tpx2:Int;
	public static var tpy2:Int;
	public static var temprect:Rectangle;
	public static var temprect2:Rectangle;
	public static var activetrigger:String;
	
	public static var doortox:Int;
	public static var doortoy:Int;
	public static var activedoor:String;
	public static var activedoordest:String;
	public static var actualdoor:Int; // Kludge: checkdoor returns trigger, but it is useful to know the actual door address for roomnames
	
	public static var templates:Array<Ent_generic> = new Array<Ent_generic>();
	public static var numtemplate:Int;
	public static var entindex:Map<String, Int> = new Map<String, Int>();

	//Entity init states
	public static var initentities:Array<Initentclass> = new Array<Initentclass>();
	public static var ninitentities:Int;
}