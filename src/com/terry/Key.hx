//Nicked a bunch of this from flixel, cheers flixel
package com.terry;

import openfl.display.DisplayObject;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

class Key{	
	public static function init(stage:DisplayObject):Void{
		stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
		
		//BASIC STORAGE & TRACKING			
		var i:Int = 0;
		for(i in 0...numletters){
			current.push(0);
			last.push(0);
			keyheld.push(false);
		}
		
		//LETTERS
		addKey("A", Keyboard.A);
		addKey("B", Keyboard.B);
		addKey("C", Keyboard.C);
		addKey("D", Keyboard.D);
		addKey("E", Keyboard.E);
		addKey("F", Keyboard.F);
		addKey("G", Keyboard.G);
		addKey("H", Keyboard.H);
		addKey("I", Keyboard.I);
		addKey("J", Keyboard.J);
		addKey("K", Keyboard.K);
		addKey("L", Keyboard.L);
		addKey("M", Keyboard.M);
		addKey("N", Keyboard.N);
		addKey("O", Keyboard.O);
		addKey("P", Keyboard.P);
		addKey("Q", Keyboard.Q);
		addKey("R", Keyboard.R);
		addKey("S", Keyboard.S);
		addKey("T", Keyboard.T);
		addKey("U", Keyboard.U);
		addKey("V", Keyboard.V);
		addKey("W", Keyboard.W);
		addKey("X", Keyboard.X);
		addKey("Y", Keyboard.Y);
		addKey("Z", Keyboard.Z);
		
		//NUMBERS
		addKey("ZERO",Keyboard.NUMBER_0);
		addKey("ONE",Keyboard.NUMBER_1);
		addKey("TWO",Keyboard.NUMBER_2);
		addKey("THREE",Keyboard.NUMBER_3);
		addKey("FOUR",Keyboard.NUMBER_4);
		addKey("FIVE",Keyboard.NUMBER_5);
		addKey("SIX",Keyboard.NUMBER_6);
		addKey("SEVEN",Keyboard.NUMBER_7);
		addKey("EIGHT",Keyboard.NUMBER_8);
		addKey("NINE",Keyboard.NUMBER_9);
		
		//FUNCTION KEYS
		addKey("F1",Keyboard.F1);
		addKey("F2",Keyboard.F2);
		addKey("F3",Keyboard.F3);
		addKey("F4",Keyboard.F4);
		addKey("F5",Keyboard.F5);
		addKey("F6",Keyboard.F6);
		addKey("F7",Keyboard.F7);
		addKey("F8",Keyboard.F8);
		addKey("F9",Keyboard.F9);
		addKey("F10",Keyboard.F10);
		addKey("F11",Keyboard.F11);
		addKey("F12",Keyboard.F12);
		
		//SPECIAL KEYS + PUNCTUATION
		addKey("ESCAPE",Keyboard.ESCAPE);
		addKey("MINUS",Keyboard.MINUS);
		addKey("PLUS",Keyboard.EQUAL);
		addKey("DELETE",Keyboard.DELETE);
		addKey("BACKSPACE",Keyboard.BACKSPACE);
		addKey("LBRACKET",Keyboard.LEFTBRACKET);
		addKey("RBRACKET",Keyboard.RIGHTBRACKET);
		addKey("BACKSLASH",Keyboard.BACKSLASH);
		addKey("CAPSLOCK",Keyboard.CAPS_LOCK);
		addKey("SEMICOLON",Keyboard.SEMICOLON);
		addKey("QUOTE",Keyboard.QUOTE);
		addKey("ENTER",Keyboard.ENTER);
		addKey("SHIFT",Keyboard.SHIFT);
		addKey("COMMA",Keyboard.COMMA);
		addKey("PERIOD",Keyboard.PERIOD);
		addKey("SLASH",Keyboard.SLASH);
		addKey("CONTROL",Keyboard.CONTROL);
		addKey("ALT", 18);
		addKey("SPACE",Keyboard.SPACE);
		addKey("UP",Keyboard.UP);
		addKey("DOWN",Keyboard.DOWN);
		addKey("LEFT",Keyboard.LEFT);
		addKey("RIGHT",Keyboard.RIGHT);
	}
	
	public static function update():Void{
		for (i in 0...numletters) {
			if (lookup.exists(i)) {
				if ((last[i] == -1) && (current[i] == -1)) current[i] = 0;
				else if ((last[i] == 2) && (current[i] == 2)) current[i] = 1;
				last[i] = current[i];
			}
		}
	}
	
	public static function reset():Void{
		for (i in 0...numletters) {
			if (lookup.exists(i)) {
				current[i] = 0;
				last[i] = 0;
				keyheld[i] = false;
			}
		}
	}
	
	public static function pressed(k:String):Bool { 
		return keyheld[keymap.get(k)]; 
	}
	
	public static function justPressed(k:String):Bool { 
		if (current[keymap.get(k)] == 2) {
			current[keymap.get(k)] = 1;
			return true;
		}else {
			return false;
		}
	}
	
	public static function justReleased(k:String):Bool { 
		return (current[keymap.get(k)] == -1);
	}
	
	public static function handleKeyDown(event:KeyboardEvent):Void {
		keycode = event.keyCode;
		
		if (lookup.exists(keycode)) {
			if (current[keycode] > 0) {
				current[keycode] = 1;
			}else {
				current[keycode] = 2;
			}
			keyheld[keycode] = true;
		}
	}
	
	public static function handleKeyUp(event:KeyboardEvent):Void {
		keycode = event.keyCode;
		if (lookup.exists(keycode)) {
			if (current[keycode] > 0) {
				current[keycode] = -1;
			}else {
				current[keycode] = 0;
			}
			keyheld[keycode] = false;
		}
	}
	
	public static function addKey(KeyName:String, KeyCode:Int):Void {
		keymap.set(KeyName, KeyCode);
		lookup.set(KeyCode, KeyName);
		current[KeyCode] = 0;
		last[KeyCode] = 0;
		keyheld[KeyCode] = false;
	}
	
	public static var keymap:Map<String, Int> = new Map<String, Int>();
	public static var lookup:Map<Int, String> = new Map<Int, String>();
	public static var current:Array<Int> = new Array<Int>();
	public static var last:Array<Int> = new Array<Int>();
	public static var keyheld:Array<Bool> = new Array<Bool>();
	
	public static var numletters:Int = 256;
	public static var keycode:Int;
}
