package gamecontrol;

import com.terry.*;
import com.terry.util.*;

class Customercontrol {
	public static function init():Void {
		for (i in 0...200) {
			leftqueue.push(new Customer());
			rightqueue.push(new Customer());
			middlequeue.push(new Customer());
			
			preferences.push(0);
		}
		
		for(i in 0...20){
			topqueue.push(new Customer());
		}
	}
	
	public static function setupcustomers():Void {
		nummiddlecustomers = 0;
		numleftcustomers = 0;
		numrightcustomers = 0;
		numtopcustomers = 0;
		customerphase = true;
		
		jayscore = 0;
		fbscore = 0;
		
		//customerspeed = 1; //Slow!
		customerspeed = 2; //pretty fast!
		//customerspeed = 3; //stupidly fast!	
		//trace(Edphase.jaycardscore);
		for(i in 0...Edphase.jaycardscore){
			preferences[i] = 1;
		}	
		//trace(Edphase.fbcardscore);
		for(i in 0...Edphase.fbcardscore){
			preferences[Edphase.jaycardscore + i] = 0;
		}
		
		shufflepreferences();
		
		for (i in 0 ... Edphase.jaycardscore + Edphase.fbcardscore) {
			if (Control.turbomode) {
				if (preferences[i] == 1) addtoleftqueue(Std.int(Math.random()*2));
				if (preferences[i] == 0) addtorightqueue(Std.int(Math.random()*2));
			}else{
				addtomiddlequeue(preferences[i]);
			}
		}
		
		totalcustomers = nummiddlecustomers + numleftcustomers + numrightcustomers;
		if (nummiddlecustomers >= 25 || Control.turbomode) {
			customerspeed = 3;
		}
	}
	
	public static function setupendingcustomers():Void {
		nummiddlecustomers = 0;
		numleftcustomers = 0;
		numrightcustomers = 0;
		numtopcustomers = 0;
		customerphase = true;
		
		jayscore = 0;
		fbscore = 0;
		
		//customerspeed = 1; //Slow!
		customerspeed = 2; //pretty fast!
		//customerspeed = 3; //stupidly fast!	
		//trace(Edphase.jaycardscore)		
		shufflepreferences();
		
		for (i in 0 ... 6) {
			addtomiddlequeue(2);
		}
		
		totalcustomers = 6;
	}
	
	public static function drawcustomerinfo(xoff:Int, yoff:Int):Void {
	  Gfx.fillrect(0 + xoff, Gfx.screenheight - 35 + yoff, Gfx.screenwidth, 40, Def.GRAY[1]);
		//Gfx.fillrect(0 + xoff, Gfx.screenheight - 35 + yoff, 80, 40, Def.GRAY[2]);
		//Gfx.fillrect(Gfx.screenwidth - 80+xoff, Gfx.screenheight - 35 + yoff, 80, 40, Def.GRAY[2]);
			
		Gfx.normalprint(5 + xoff, Gfx.screenheight - 32 + yoff, Std.string(Customercontrol.jayscore),  Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
		Gfx.smallbigprint(5 + xoff, Gfx.screenheight - 20 + yoff, "JAY'S FOOD STAND", Def.GRAY[2], Def.GRAY[2], Def.GRAY[2], false);
			
		Gfx.normalprint(Gfx.screenwidth-5 - Std.int(Text.len(Std.string(Customercontrol.fbscore),3))+xoff, Gfx.screenheight - 32 + yoff, Std.string(Customercontrol.fbscore),  Def.GRAY[4], Def.GRAY[4], Def.GRAY[4], false);
		Gfx.smallbigprint(Gfx.screenwidth - 5 - Std.int(Text.len("FILTHY BURGER"))+xoff, Gfx.screenheight - 20 + yoff, "FILTHY BURGER", Def.GRAY[2], Def.GRAY[2], Def.GRAY[2], false);
	}
	
	public static function addtotopqueue(gen:Int):Void {
		topqueue[numtopcustomers].add(0, 0, 2, gen);
		numtopcustomers++;
	}
	
	public static function addtomiddlequeue(prefers:Int):Void {
		if (customerspeed == 1) {
			customerdelay = 160;
		}else if (customerspeed == 2) {
			customerdelay = 128;
		}else {
			customerdelay = 64;
		}
		middlequeue[nummiddlecustomers].add(prefers, 64 + (customerdelay * nummiddlecustomers), 2);
		nummiddlecustomers++;
	}
	
	public static function addtorightqueue(gen:Int):Void {
		rightqueue[numrightcustomers].add(0, 106, 0, gen);
		numrightcustomers++;
	}
	
	public static function addtoleftqueue(gen:Int):Void {
		leftqueue[numleftcustomers].add(0, 104, 1, gen);
		numleftcustomers++;
	}
	
	public static function removemiddle():Void {
		//Remove someone from the top of the middlequeue
		if(nummiddlecustomers>1){
			for (i in 0...nummiddlecustomers-1) {
				middlequeue[i].copy(middlequeue[i+1]);
			}
			nummiddlecustomers--;
		}else {
			nummiddlecustomers = 0;
		}
	}
	
	public static function removeright():Void {
		//Remove someone from the top of the middlequeue
		if(numrightcustomers>1){
			for (i in 0...numrightcustomers-1) {
				rightqueue[i].copy(rightqueue[i+1]);
			}
			numrightcustomers--;
		}else {
			numrightcustomers = 0;
		}
	}
	
	public static function removeleft():Void {
		//Remove someone from the top of the middlequeue
		if(numleftcustomers>1){
			for (i in 0...numleftcustomers-1) {
				leftqueue[i].copy(leftqueue[i+1]);
			}
			numleftcustomers--;
		}else {
			numleftcustomers = 0;
		}
	}
	
	
	public static function removetop():Void {
		//Remove someone from the top of the middlequeue
		if(numtopcustomers>1){
			for (i in 0...numtopcustomers-1) {
				topqueue[i].copy(topqueue[i+1]);
			}
			numtopcustomers--;
		}else {
			numtopcustomers = 0;
		}
	}
	
	public static function shufflepreferences():Void {
		var t:Int;
		for (i in 0...Edphase.fbcardscore+Edphase.jaycardscore) {
			var j = Math.floor((((Edphase.fbcardscore+Edphase.jaycardscore - 1) + 1) * Math.random()));
			t = preferences[i];
			preferences[i] = preferences[j];
			preferences[j] = t;
		}
	}
	
	public static function shufflemiddlequeue():Void {
		for (i in 0...nummiddlecustomers) {
			var j = Math.floor((((nummiddlecustomers - 1) + 1) * Math.random()));
			swapcustomers(i, j);
		}
	}
	
	public static function swapcustomers(i:Int, j:Int):Void {
		var tempcustomer:Customer = new Customer();
		
		tempcustomer.state = middlequeue[i].state;
		tempcustomer.position = middlequeue[i].position;
		tempcustomer.statedelay = middlequeue[i].statedelay;
		tempcustomer.gender = middlequeue[i].gender;
		tempcustomer.dir = middlequeue[i].dir;
		tempcustomer.frame = middlequeue[i].frame;
		tempcustomer.framedelay = middlequeue[i].framedelay;
		tempcustomer.prefers = middlequeue[i].prefers;
		
		middlequeue[i].state = middlequeue[j].state;
		middlequeue[i].position = middlequeue[j].position;
		middlequeue[i].statedelay = middlequeue[j].statedelay;
		middlequeue[i].gender = middlequeue[j].gender;
		middlequeue[i].dir = middlequeue[j].dir;
		middlequeue[i].frame = middlequeue[j].frame;
		middlequeue[i].framedelay = middlequeue[j].framedelay;
		middlequeue[i].prefers = middlequeue[j].prefers;
		
		middlequeue[j].state = tempcustomer.state;
		middlequeue[j].position = tempcustomer.position;
		middlequeue[j].statedelay = tempcustomer.statedelay;
		middlequeue[j].gender = tempcustomer.gender;
		middlequeue[j].dir = tempcustomer.dir;
		middlequeue[j].frame = tempcustomer.frame;
		middlequeue[j].framedelay = tempcustomer.framedelay;
		middlequeue[j].prefers = tempcustomer.prefers;
	}
	
	public static function drawcustomers():Void {
		//Right queue
		for (i in 0...numrightcustomers) {
			Gfx.drawsprite(282 +16- 32 - rightqueue[i].position, 60, 60 + rightqueue[i].frame + (rightqueue[i].dir * 3) + (rightqueue[i].gender * 20));
		}
		//Left queue
		for (i in 0...numleftcustomers) {
			Gfx.drawsprite(72 +16- 32 + leftqueue[i].position, 60, 60 + leftqueue[i].frame + (leftqueue[i].dir * 3) + (leftqueue[i].gender * 20));
		}
		//Middle queue
		for (i in 0...nummiddlecustomers) {
			Gfx.drawsprite(Gfx.screenwidthmid - 32, 60 + middlequeue[i].position, 60 + middlequeue[i].frame + (middlequeue[i].dir * 3) + (middlequeue[i].gender * 20));
		}
		//Top queue
		for (i in 0...numtopcustomers) {
			Gfx.drawsprite(Gfx.screenwidthmid - 32, 60 - topqueue[i].position, 60 + topqueue[i].frame + (topqueue[i].dir * 3) + (topqueue[i].gender * 20));
		}
	}
	
	public static function updatecustomers():Void {
		if (nummiddlecustomers == 0 && numleftcustomers == 0 && numrightcustomers == 0 && numtopcustomers == 0) {
			totalcustomers = 0;
		}else{
			totalcustomers = nummiddlecustomers + numleftcustomers + numrightcustomers + numtopcustomers;
			//Top queue
			for (i in 0...numtopcustomers) {
				switch(topqueue[i].state) {
					case "begin":
						topqueue[i].framedelay--;
						if (topqueue[i].framedelay <= 0) {
							topqueue[i].framedelay = 12;
							topqueue[i].frame = (topqueue[i].frame+1) % 3;
							if (topqueue[i].frame == 0) topqueue[i].frame = 1;
						}
						
						if(customerspeed==1){
							topqueue[i].position += 1;
						}else if (customerspeed == 2) {
							topqueue[i].position += 2;
						}else {
							topqueue[i].position += 4;
						}
						if (topqueue[i].position >= 180) {
						  removetop();
						}
				}
			}
			//Right queue
			for (i in 0...numrightcustomers) {
				switch(rightqueue[i].state) {
					case "begin":
						rightqueue[i].framedelay--;
						if (rightqueue[i].framedelay <= 0) {
							rightqueue[i].framedelay = 12;
							rightqueue[i].frame = (rightqueue[i].frame+1) % 3;
							if (rightqueue[i].frame == 0) rightqueue[i].frame = 1;
						}
						
						if(customerspeed==1){
							rightqueue[i].position -= 1;
						}else if (customerspeed == 2) {
							rightqueue[i].position -= 2;
						}else {
							rightqueue[i].position -= 4;
						}
						if (i > 0) {
							if (rightqueue[i].position <= 24 * i) {
								rightqueue[i].position = 24 * i;
								rightqueue[i].frame = 0;
							}
						}else{
							if (rightqueue[i].position <= 0) {
								rightqueue[i].position = 0;
								rightqueue[i].state = "buy";
								rightqueue[i].framedelay = 5;
							}
						}
					case "buy":
						rightqueue[i].frame = 0;
						rightqueue[i].dir = 2;
						rightqueue[i].framedelay--;
						if (rightqueue[i].framedelay <= 0) {
							Music.playef("coin_fb");
							fbscore++;
							rightqueue[i].state = "buy2";
							if (customerspeed == 1) {
								rightqueue[i].framedelay = 45;
							}else if (customerspeed == 2) {
								rightqueue[i].framedelay = 25;
							}else {
								rightqueue[i].framedelay = 5;
							}
						}
					case "buy2":
						rightqueue[i].frame = 0;
						rightqueue[i].dir = 3;
						rightqueue[i].framedelay--;
						if (rightqueue[i].framedelay <= 0) {
							rightqueue[i].state = "leave";
							rightqueue[i].framedelay = 0;
							rightqueue[i].dir = 0;
							rightqueue[i].frame = 0;
						}	
					case "leave":
						rightqueue[i].framedelay--;
						if (rightqueue[i].framedelay <= 0) {
							rightqueue[i].framedelay = 12;
							rightqueue[i].frame = (rightqueue[i].frame+1) % 3;
							if (rightqueue[i].frame == 0) rightqueue[i].frame = 1;
						}
						
						if (customerspeed == 1) {
							rightqueue[i].position -= 2;
						}else if (customerspeed == 2) {
							rightqueue[i].position -= 3;
						}else {
							rightqueue[i].position -= 8;
						}
						
						if (rightqueue[i].position <= -100) {
							removeright();
						}
				}
			}
			//Left queue
			for (i in 0...numleftcustomers) {
				switch(leftqueue[i].state) {
					case "begin":
						leftqueue[i].framedelay--;
						if (leftqueue[i].framedelay <= 0) {
							leftqueue[i].framedelay = 12;
							leftqueue[i].frame = (leftqueue[i].frame+1) % 3;
							if (leftqueue[i].frame == 0) leftqueue[i].frame = 1;
						}
						
						if(customerspeed==1){
							leftqueue[i].position -= 1;
						}else if (customerspeed == 2) {
							leftqueue[i].position -= 2;
						}else {
							leftqueue[i].position -= 4;
						}
						if (i > 0) {
							if (leftqueue[i].position <= 24 * i) {
								leftqueue[i].position = 24 * i;
								leftqueue[i].frame = 0;
							}
						}else{
							if (leftqueue[i].position <= 0) {
								leftqueue[i].position = 0;
								leftqueue[i].state = "buy";
								leftqueue[i].framedelay = 5;
							}
						}
					case "buy":
						leftqueue[i].frame = 0;
						leftqueue[i].dir = 2;
						leftqueue[i].framedelay--;
						if (leftqueue[i].framedelay <= 0) {
							jayscore++;
							Music.playef("coin_jay");
							leftqueue[i].state = "buy2";
							if (customerspeed == 1) {
								leftqueue[i].framedelay = 45;
							}else if (customerspeed == 2) {
								leftqueue[i].framedelay = 25;
							}else {
								leftqueue[i].framedelay = 5;
							}
						}
					case "buy2":
						leftqueue[i].frame = 0;
						leftqueue[i].dir = 3;
						leftqueue[i].framedelay--;
						if (leftqueue[i].framedelay <= 0) {
							leftqueue[i].state = "leave";
							leftqueue[i].framedelay = 0;
							leftqueue[i].dir = 1;
							leftqueue[i].frame = 0;
						}	
					case "leave":
						leftqueue[i].framedelay--;
						if (leftqueue[i].framedelay <= 0) {
							leftqueue[i].framedelay = 12;
							leftqueue[i].frame = (leftqueue[i].frame+1) % 3;
							if (leftqueue[i].frame == 0) leftqueue[i].frame = 1;
						}
						
						if (customerspeed == 1) {
							leftqueue[i].position -= 2;
						}else if (customerspeed == 2) {
							leftqueue[i].position -= 3;
						}else {
							leftqueue[i].position -= 8;
						}
						if (leftqueue[i].position <= -100) {
							removeleft();
						}
				}
			}
			//Middle queue
			for (i in 0...nummiddlecustomers) {
				switch(middlequeue[i].state) {
					case "begin":
						middlequeue[i].framedelay--;
						if (middlequeue[i].framedelay <= 0) {
							middlequeue[i].framedelay = 12;
							middlequeue[i].frame = (middlequeue[i].frame+1) % 3;
							if (middlequeue[i].frame == 0) middlequeue[i].frame = 1;
						}
						
						if (customerspeed == 1) {
							middlequeue[i].position-=1;
						}else if (customerspeed == 2) {
							middlequeue[i].position-=2;
						}else {
							middlequeue[i].position-=4;
						}
							
						if (i > 0) {
							if (middlequeue[i].position <= 32 * i) {
								middlequeue[i].position = 32 * i;
								middlequeue[i].frame = 0;
							}
						}else{
							if (middlequeue[i].position <= 0) {
								middlequeue[i].position = 0;
								middlequeue[i].state = "decide1";
								if (customerspeed == 1) {
									middlequeue[i].framedelay = 25;
								}else if (customerspeed == 2) {
									middlequeue[i].framedelay = 10;
									middlequeue[i].state = "decide4";
									middlequeue[i].frame = 0;
									middlequeue[i].dir = middlequeue[i].prefers;
								}else {
									middlequeue[i].framedelay = 5;
									middlequeue[i].state = "decide4";
									middlequeue[i].frame = 0;
									middlequeue[i].dir = middlequeue[i].prefers;
								}
							}
						}
					case "decide1", "decide2", "decide3":
						middlequeue[i].frame = 0;
						middlequeue[i].framedelay--;
						if (middlequeue[i].framedelay <= 0) {
							middlequeue[i].dir = (middlequeue[i].dir + 1) % 2;
							if (customerspeed == 1) {
								middlequeue[i].framedelay = 25;
							}else if (customerspeed == 2) {
								middlequeue[i].framedelay = 5;
							}else {
								middlequeue[i].framedelay = -10;
							}
							if (middlequeue[i].dir == middlequeue[i].prefers && middlequeue[i].state == "decide2") {
								middlequeue[i].state = "decide4";
							}else{
								middlequeue[i].state = Help.stringplusplus(middlequeue[i].state);
							}
						}
					 case "decide4":
						middlequeue[i].dir = middlequeue[i].prefers;
						middlequeue[i].framedelay--;
						if (middlequeue[i].framedelay <= -15) {
							middlequeue[i].framedelay = 0;
							//REMOVE ME
							if (middlequeue[i].prefers == 0) {
								if (numrightcustomers > 3) {
									middlequeue[i].framedelay = -10;
								}else{
									addtorightqueue(middlequeue[i].gender);
									removemiddle();
								}
							}else if (middlequeue[i].prefers == 1) {
								if (numleftcustomers > 3) {
									middlequeue[i].framedelay = -10;
								}else{
									addtoleftqueue(middlequeue[i].gender);
									removemiddle();
								}
							}else if (middlequeue[i].prefers == 2) {
								addtotopqueue(middlequeue[i].gender);
								removemiddle();
							}
						}
				}
			}
		}
	}
	
	public static var customerphase:Bool;
	
	public static var totalcustomers:Int;
	public static var nummiddlecustomers:Int;
	public static var numleftcustomers:Int;
	public static var numrightcustomers:Int;
	public static var numtopcustomers:Int;
	public static var customerdelay:Int;
	public static var customerspeed:Int;
	
	public static var jayscore:Int;
	public static var fbscore:Int;
	
	public static var topqueue:Array<Customer> = new Array<Customer>();
	public static var leftqueue:Array<Customer> = new Array<Customer>();
	public static var middlequeue:Array<Customer> = new Array<Customer>();
	public static var rightqueue:Array<Customer> = new Array<Customer>();
	public static var preferences:Array<Int> = new Array<Int>();
}