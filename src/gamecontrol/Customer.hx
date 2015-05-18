package gamecontrol;

import com.terry.*;

class Customer {
	public function new():Void {
		state = "";
	}
	
	public function add(t:Int, pos:Int, d:Int, gen:Int=-1):Void {
		state = "begin";
		position = pos;
		statedelay = 0;
		if(gen==-1){
			gender = Std.int(Math.random() * 2);
		}else {
			gender = gen;
		}
		dir = d;
		frame = 0;
		framedelay = 0;
		
		prefers = t;
	}
	
	public function copy(c:Customer):Void {
		state = c.state;
		position = c.position;
		statedelay = c.statedelay;
		gender = c.gender;
		dir = c.dir;
		frame = c.frame;
		framedelay = c.framedelay;
		prefers = c.prefers;
	}
	
	public var state:String;
	public var position:Int;
	public var statedelay:Int;
	public var gender:Int;
	public var prefers:Int;
	public var frame:Int;
	public var framedelay:Int;
	public var dir:Int;
}