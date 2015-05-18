package config;

import openfl.display.Sprite;
import openfl.utils.Timer;
import openfl.events.*;
import openfl.Lib;
import gamecontrol.*;
import com.terry.*;
import com.terry.util.*;

class Coreloop {
	public static function setupgametimer():Void {
		_rate = 1000 / TARGET_FPS;
	  _skip = _rate * 10;
		_timer.addEventListener(TimerEvent.TIMER, mainloop);
		_timer.start();
	}
	
	private static function mainloop(e:TimerEvent):Void {
		_current = Lib.getTimer();
		if (_last < 0) _last = _current;
		_delta += _current - _last;
		_last = _current;
		if (_delta >= _rate){
			_delta %= _skip;
			while (_delta >= _rate){
				_delta -= _rate;
				input();
				logic();
			}
			render();
			e.updateAfterEvent();
		}
	}
	
	private static function input():Void{
		if (Game.infocus) {
			Mouse.update(Std.int(Lib.current.mouseX), Std.int(Lib.current.mouseY));
			Game.mx = Std.int(Mouse.x / Def.SCREENSCALE);
			Game.my = Std.int(Mouse.y / Def.SCREENSCALE);
			
			Game.keypoll();
			
			switch(Game.gamestate) {
				case Def.TITLEMODE:	Input.titleinput();
				case Def.GAMEMODE: Input.gameinput();
				case Def.CLICKTOSTART: if (Mouse.justleftpressed()) { Game.gamestate = Def.TITLEMODE; }
			}
		}
	}

	private static function logic():Void {
		if (!Game.infocus) {
			if (Game.globalsound > 0) {
				Game.globalsound = Game.globalsound * 0.95;
			  if (Game.globalsound < 0.1) Game.globalsound = 0;
				Music.updateallvolumes();
			}
			Music.processmusic();
			Gfx.processfade();
			Help.updateglow();
		}else {		
			if (Control.exitmenu) {
			
			}else {
				Script.runscript();
				Textbox.updatetextboxes();
				
				switch(Game.gamestate) {
					case Def.TITLEMODE: Logic.titlelogic();
					case Def.GAMEMODE: Logic.gamelogic(); 
				}
				
				Control.fadelogic();
				Obj.cleanup();
				Music.processmusic();
				Gfx.processfade();
				Help.updateglow();
				
				//Mute button
				Music.processmute();
			}
		}
	}

	private static function render():Void {
		Gfx.backbuffer.lock();
		if (!Game.infocus) {
			Draw.outoffocusrender();
		}else {
			Gfx.cls();
			
			switch(Game.gamestate) {
				case Def.TITLEMODE: Render.titlerender();
				case Def.GAMEMODE: Render.gamerender(); 
				case Def.CLICKTOSTART: Draw.clicktostart();
			}
			
			Draw.drawfade();
			Gfx.screenrender();
		}
	}
	
	public function windowNotActive(e:Event):Void{ Game.infocus = false; }
  public function windowActive(e:Event):Void{ Game.infocus = true; }
	
	private static var TARGET_FPS:Int = 60;
	private static var _rate:Float;
	private static var _skip:Float;
	private static var _last:Float = -1;
	private static var _current:Float = 0;
	private static var _delta:Float = 0;
	private static var _timer:Timer = new Timer(4);
}