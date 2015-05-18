package gamecontrol;

import com.terry.*;

class Frame {
	public function new() {
		clear();
	}
	
	public function getlength():Int {
		return length;
	}
	
	public function clear(doreverse:Bool = false):Void {
	  message = new Array<String>();
	  colour = new Array<String>();
	  border = new Array<String>();
	  effect = new Array<String>();
	  delay = 0;
		length = 0;
		reverse = doreverse;
	}
	
	public function add(m:String, c:String, b:String, e:String):Void {
		message.push(m);
		colour.push(c);
		border.push(b);
		effect.push(e);
		delay = Control.waittime;
		length++;
	}
	
	
	public function change(index:Int, m:String, c:String, b:String, e:String):Void {
		message[index] = m;
		colour[index] = c;
		border[index] = b;
		effect[index] = e;
		delay = Control.waittime;
	}
	
	public function delete(t:Int):Void {
		if (t == length - 1) {
			Control.currentframe[Gfx.sign]--;
			if (Control.currentframe[Gfx.sign] < 0)	Control.currentframe[Gfx.sign] = 0;
		}else{
			for (i in t...length - 1) {
				message[i] = message[i + 1];
				colour[i] = colour[i + 1];
				border[i] = border[i + 1];
				effect[i] = effect[i + 1];
			}
		}
		
		message.pop();
		colour.pop();
		border.pop();
		effect.pop();
		length--;
		reverse = false;
	}
	
	public function start(t:Int):Void {
		Gfx.sign = t;
		Control.currentframe[t] = 0;
		
		Control.changecurrenttext(message[Control.currentframe[t]]);
		Gfx.changecolour(colour[Control.currentframe[t]]);
		Gfx.changeborder(border[Control.currentframe[t]]);
		Control.changeeffect(effect[Control.currentframe[t]]);
		
		delay = Control.waittime;
	}
	
	public function next(t:Int):Void {
	  Gfx.sign = t;
		Control.currentframe[t]++;
		if (Control.currentframe[t] >= getlength()) {
			Control.currentframe[t] = 0;
		}
		Control.changecurrenttext(message[Control.currentframe[t]]);
		Gfx.changecolour(colour[Control.currentframe[t]]);
		Gfx.changeborder(border[Control.currentframe[t]]);
		Control.changeeffect(effect[Control.currentframe[t]]);
		
		delay = Control.waittime;
	}
	
	public function repeat(t:Int):Void {
	  Gfx.sign = t;
		
		Control.changecurrenttext(message[Control.currentframe[t]]);
		Gfx.changecolour(colour[Control.currentframe[t]]);
		Gfx.changeborder(border[Control.currentframe[t]]);
		Control.changeeffect(effect[Control.currentframe[t]]);
		
		delay = Control.waittime;
		Control.changecurrenttext(Control.guimessage);
	}
	
	public var message:Array<String>;
	public var colour:Array<String>;
	public var border:Array<String>;
	public var effect:Array<String>;
	public var delay:Int;
	public var length:Int;
	public var reverse:Bool;
}