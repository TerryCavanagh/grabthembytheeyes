package gamecontrol;

class Card {
	public function new() {
		type = "blank";
		name = "";
		action = "message";
		special = "none";
		score = 1;
	}
	
	public function copy(_type:String, _name:String, _action:String, _score:Int, _special:String):Void {
		type = _type;
		name = _name;
		action = _action;
		special = _special;
		score = _score;
	}
	
	public var type:String;
	public var name:String;
	public var action:String;
	public var special:String;
	public var score:Int;
}