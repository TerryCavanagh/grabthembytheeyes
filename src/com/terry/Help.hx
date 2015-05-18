package com.terry;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;

using StringTools;
	
class Help {
	public static function init():Void {
		for(i in 0...360){
			sine[i] = Math.sin((i * 6.283) / 64);
			cosine[i] = Math.cos((i * 6.283) / 64);
		}
		
		glow = 0;
		glowdir = 0;
		fastglow = 0;
		fastglowdir = 0;
		slowsine = 0;
	}
	
	public static function RGB(red:Int, green:Int, blue:Int):Int {
		return (blue | (green << 8) | (red << 16));
	}
	
	public static function wrap(t:Int, start:Int, end:Int):Int {
		while (t < start) t += (end - start);
		return (t % (end - start)) + start;
	}
	
	public static function reversetext(t:String):String {
		var t2:String = "";
		
		for (i in 0...t.length) {
			t2 += Mid(t, t.length-i-1, 1);
		}
		return t2;
	}
	
	public static function number(t:Int):String {
		switch(t) {
			case 0: return "Zero";
			case 1: return "One";
			case 2: return "Two";
			case 3: return "Three";
			case 4: return "Four"; 
			case 5: return "Five";
			case 6: return "Six";
			case 7: return "Seven";
			case 8: return "Eight";
			case 9: return "Nine";
			case 10: return "Ten";
			case 11: return "Eleven";
			case 12: return "Twelve";
			case 13: return "Thirteen";
			case 14: return "Fourteen";
			case 15: return "Fifteen";
			case 16: return "Sixteen";
			case 17: return "Seventeen";
			case 18: return "Eighteen";
			case 19: return "Nineteen";
			case 20: return "Twenty";
			case 30: return "Thirty";
			case 40: return "Forty";
			case 50: return "Fifty";
			case 60: return "Sixty";
			case 70: return "Seventy";
			case 80: return "Eighty";
			case 90: return "Ninety";
		}
		if (t > 20 && t < 30) return number(20) + " " + number(t - 20);
		if (t > 30 && t < 40) return number(30) + " " + number(t - 30);
		if (t > 40 && t < 50) return number(40) + " " + number(t - 40);
		if (t > 50 && t < 60) return number(50) + " " + number(t - 50);
		if (t > 60 && t < 70) return number(60) + " " + number(t - 60);
		if (t > 70 && t < 80) return number(70) + " " + number(t - 70);
		if (t > 80 && t < 90) return number(80) + " " + number(t - 80);
		if (t > 90 && t < 100) return number(90) + " " + number(t - 90);
		if (t >= 100 && t < 1000) {
			if (t % 100 == 0) {
				return number(Std.int((t - (t % 100)) / 100)) + " hundred";
			}else{
				return number(Std.int((t - (t % 100)) / 100)) + " hundred and " + number(t % 100);
			}
		}
		if (t >= 1000) {
			if ((t % 1000) == 0) {
				return number(Std.int((t - (t % 1000)) / 1000)) + " thousand";
			}else if ((t % 1000) < 100) {
				return number(Std.int((t - (t % 1000)) / 1000)) + " thousand and " + number(t % 1000);
			}else{
				return number(Std.int((t - (t % 1000)) / 1000)) + " thousand, " + number(t % 1000);
			}
		}
		return "Some";
	}
	
	public static function updateglow():Void {
		slowsine++;
		if (slowsine >= 64) slowsine = 0;
		
		if (glowdir == 0) {
			glow+=1; 
			if (glow >= 63) glowdir = 1;
		}else {
			glow-=1;
			if (glow < 1) glowdir = 0;
		}
		
		if (fastglowdir == 0) {
			fastglow+=2; 
			if (fastglow >= 62) fastglowdir = 1;
		}else {
			fastglow-=2;
			if (fastglow < 2) fastglowdir = 0;
		}
	}
	
	public static function inbox(xc:Int, yc:Int, x1:Int, y1:Int, x2:Int, y2:Int):Bool {
		if (xc >= x1 && xc <= x2) {
			if (yc >= y1 && yc <= y2) {
				return true;
			}
		}
		return false;
	}
	
	public static function inboxw(xc:Int, yc:Int, x1:Int, y1:Int, x2:Int, y2:Int):Bool {
		if (xc >= x1 && xc <= x1+x2) {
			if (yc >= y1 && yc <= y1+y2) {
				return true;
			}
		}
		return false;
	}
	
	public static function twodigits(t:Int):String {
		if (t < 10) return "0" + Std.string(t);
		if (t > 100) return Std.string(twodigits(t % 100));
		return Std.string(t);
	}
	
	public static function threedigits(t:Int):String {
		if (t < 10) return "00" + Std.string(t);
		if (t < 100) return "0" + Std.string(t);
		return Std.string(t);
	}
	
	public static function thousand(t:Int):String {
		if (t < 1000) {
			return "$"+Std.string(t);	
		}else if (t < 1000000) {
			return "$"+Std.string((t - (t % 1000)) / 1000) + "," + threedigits(t % 1000);
		}else {
			var temp:Int;
			temp = Std.int((t - (t % 1000)) / 1000);
			return "$" + Std.string((temp - (temp % 1000)) / 1000) + "," 
								 + threedigits(temp % 1000) + "," + threedigits(t % 1000);
		}
	}
	
	public static function removenewlines(s:String):String {
		//Remove newlines from string s
		return removefromstring(removefromstring(s, "\n"), "\r");
	}
	
	public static function removefromstring(s:String, c:String):String {
		//Remove all instances of c from string s
		var t:Int = Instr(s, c);
		if (t == 0) {
			return s;
		}else {
			return removefromstring(getroot(s, c) + getbranch(s, c), c);
		}
	}
	
	public static function Instr(s:String, c:String, start:Int = 1):Int {
		return (s.indexOf(c, start - 1) + 1);
	}
	
	public static function Mid(s:String, start:Int = 0, length:Int = 1):String {
		return s.substr(start, length);
	}
	
	public static function Left(s:String, length:Int = 1):String {
		return s.substr(0,length);
	}
	
	public static function Right(s:String, length:Int = 1):String {
		return s.substr(s.length - length, length);
	} 
	
	public static function stringplusplus(t:String):String {
		return Left(t, t.length - 1) + Std.string(Std.parseInt(Right(t, 1)) + 1);
	}
	
	public static function getlastbranch(n:String, ch:String):String {
		//Given a string n, return everything after the LAST occurance of the "ch" character
		while (Instr(n, ch) != -1) n = getbranch(n, ch);
		return n;
	}
	
	public static function getroot(n:String, ch:String):String {
		//Given a string n, return everything before the first occurance of the "ch" character
		for (i in 0...n.length) {
			if (Mid(n, i, 1) == ch) {
				return Mid(n, 0, i);
			}
		}
		return n;
	}
	
	public static function getbranch(n:String, ch:String):String {
		//Given a string n, return everything after the first occurance of the "ch" character
		for (i in 0...n.length) {
			if (Mid(n, i, 1) == ch) {
				return Mid(n, i + 1, n.length - i - 1);
			}
		}
		return n;
	}
	
	public static function getbrackets(n:String):String {
		//Given a string n, return everything between the first and the last bracket
		while (Mid(n, 0, 1) != "(" && n.length > 0)	n = Mid(n, 1, n.length - 1);
		while (Mid(n, n.length-1, 1) != ")" && n.length > 0) n = Mid(n, 0, n.length - 1);
		
		if (n.length <= 0) return "";
		return Mid(n, 1, n.length - 2);
	}
	
	public static function trimspaces(n:String):String {
		//Given a string n, remove the spaces around it
		while (Mid(n, 0, 1) == " " && n.length > 0)	n = Mid(n, 1, n.length - 1);
		while (Mid(n, n.length - 1, 1) == " " && n.length > 0) n = Mid(n, 0, n.length - 1);
		
		while (Mid(n, 0, 1) == "\t" && n.length > 0)	n = Mid(n, 1, n.length - 1);
		while (Mid(n, n.length - 1, 1) == "\t" && n.length > 0) n = Mid(n, 0, n.length - 1);
		
		if (n.length <= 0) return "";
		return n;
	}
	
	public static function isNumber(t:String):Bool {
		if (Math.isNaN(Std.parseFloat(t))) {
			return false;
		}else{
			return true;
		}	
		return false;
	}
	
	public static function randomletter(uppercase:Bool = false):String {
		if (uppercase) return randomletter(false).toUpperCase();
		return letters[Std.int(Math.random() * 26)];
	}
	
	public static var letters:Array<String> = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"];
	
	public static var sine:Array<Float> = new Array<Float>();
	public static var cosine:Array<Float> = new Array<Float>();
	public static var glow:Int;
	public static var glowdir:Int;
	public static var fastglow:Int;
	public static var fastglowdir:Int;
	public static var slowsine:Int;
	public static var tempstring:String;
}
