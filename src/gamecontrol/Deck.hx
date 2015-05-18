package gamecontrol;

class Deck {
	//A deck is a collection of cards. Deck 0 is special, it never changes values.
	public function new() {
		for (i in 0...40) {
			card.push(new Card());
		}
		numcards = 0;
		name = "";
	}
	
	
	public function addcard(_type:String, _name:String, _action:String, _score:Int = 1, _special:String = "none"):Void {
		if (numcards <= card.length) card.push(new Card());
		
		_name = _name.toUpperCase();
		card[numcards].type = _type;
		card[numcards].name = _name;
		card[numcards].action = _action;
		card[numcards].score = _score;
		card[numcards].special = _special;
		
		var tempstring:String;
		tempstring = _name + "_" + _type.toUpperCase();
		cardindex.set(tempstring, numcards);
		numcards++;
	}
	
	public function copycard(_type:String, _name:String, _action:String, _score:Int, _special:String):Void {
		//Copy card othercard into this deck
		addcard(_type, _name, _action, _score, _special);
	}
	
	public function deletetop(t:Int):Void {
		//Remove the top t cards
		for (i in 0...t) {
			removecardbyindex(0);
		}
	}
	
	public function removecardbyindex(t:Int):Void {
		for(i in t...numcards-1){
			card[i].copy(card[i + 1].type, card[i + 1].name, card[i + 1].action, card[i + 1].score, card[i + 1].special);
		}
		numcards--;
	}
	
	public function removecard(cardname:String):Void {
		//Remove given card from the deck!
		var i:Int=0;
		while (i < numcards) {
			i++;
			if (card[i].name == cardname) {
				removecardbyindex(i);
			}
		}
		
		if (indeck(cardname)) {
			removecard(cardname);
		}
	}
	
	public function indeck(cardname:String):Bool {
		for (i in 0...numcards) {
			if (card[i].name == cardname) {
				return true;
			}
		}
		return false;
	}
	
	public function swapcards(i:Int, j:Int):Void {
		//i and j are indexes of cards
		var tempcard:Card = new Card();
		tempcard.name = card[i].name;
		tempcard.type = card[i].type;
		tempcard.action = card[i].action;
		tempcard.score = card[i].score;
		tempcard.special = card[i].special;
		
		card[i].name = card[j].name;
		card[i].type = card[j].type;
		card[i].action = card[j].action;
		card[i].score = card[j].score;
		card[i].special = card[j].special;
		
		card[j].name = tempcard.name;
		card[j].type = tempcard.type;
		card[j].action = tempcard.action;
		card[j].score = tempcard.score;
		card[j].special = tempcard.special;
	}
	
	public function masterdeck():Void {
		name = "master";
		
		for (i in 0...Control.numsuggestions) {
			addcard("message", Control.randomsuggestions[i], "message", 2);
		}
		
		var tempstring:String;
		tempstring = "this. sick. meat.".toUpperCase() + "_MESSAGE";
		card[cardindex[tempstring]].score = 3;
		tempstring = "I will make you full".toUpperCase() + "_MESSAGE";
		card[cardindex[tempstring]].score = 3;
		
		addcard("message", "Eat at", "message", 1);
		addcard("message", "Jay's", "message", 1);
		addcard("message", "Filthy", "message", 1);
		addcard("message", "Burger", "message", 1);
		
		addcard("message", "Jay Sucks", "message", 5, "filthyburgeronly");
		addcard("message", "Filthy Burger is literally filthy", "message", 5, "jayonly");
		
		addcard("colour", "stripe", "colour_stripe", 5);
		addcard("colour", "fire", "colour_fire", 5);
		addcard("colour", "fast cycle", "colour_fastcycle", 3);
		addcard("colour", "gradient", "colour_gradient", 3, "rainbowchain");
		addcard("colour", "slow cycle", "colour_slowcycle" ,2);
		addcard("colour", "flicker", "colour_flicker", 2);
		addcard("colour", "flash", "colour_flash", 1);
		addcard("colour", "simple", "colour_simple", 1);	
		
		addcard("border", "particles", "border_particles", 5);
		addcard("border", "rainbow", "border_gradient2", 5, "rainbowchain");
		addcard("border", "colourful", "border_gradient1", 3);
		addcard("border", "alternate", "border_alternate", 3);
		addcard("border", "gap", "border_gap", 2);
		addcard("border", "flicker", "border_flicker", 2);
		addcard("border", "flash", "border_flash", 1);
		//addcard("border", "simple", "border_colour", 1);
		
		addcard("effect", "wave", "effect_bob", 5);
		addcard("effect", "invert", "effect_invert", 5, "rainbowchain");
		addcard("effect", "join", "effect_split", 3);
		addcard("effect", "teleport", "effect_teleport", 3);
		addcard("effect", "build", "effect_pixel", 3);
		addcard("effect", "twist", "effect_midsplit", 3);
		addcard("effect", "fall down", "effect_dropin", 2);
		addcard("effect", "open", "effect_zoomin", 2);
		
		addcard("extraframe", "extra frame", "extraframe");
		addcard("extraframe", "extra frame", "extraframe");
		addcard("extraframe", "extra frame", "extraframe");
	}
	
	public var name:String;
	public var card:Array<Card> = new Array<Card>();
	public var cardindex:Map<String, Int> = new Map<String, Int>();
	public var numcards:Int;
}