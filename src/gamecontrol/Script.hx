package gamecontrol;

import config.*;
import com.terry.*;

class Script{
	public static function load(t:String):Void {
		//loads script name t into the array
		Game.position = 0; Game.scriptlength = 0; Game.parsetext = false;
		if (t == "supersigntest") {
			s("fadein()");
			s("wait(fade)");
			s("supersign()");
		}else if (t == "tieending") {
			s("clearallcharacters()");
			s("endcustomers()");
			s("jaytiesign()");
			s("fbtiesign()");
			s("scene(streets)");
			s("addcharacter(jay,jaycart)");
			s("addcharacter(hipsters,hipstercart)");
			s("face(hipster1,left)");
			s("face(hipster2,left)");
			s("jayhascart()");
			s("jayhassign()");
			s("fbhascart()");
			s("fbhassign()");
			s("fadein()");
			s("wait(fade)");
			
			s("delay(30)");
			
			s("say(hipster2){");
      s("	 ...um, well, this is akward.");
      s("}");
			
			s("say(hipster1){");
      s("	 We got exactly the same number of customers? What?");
      s("}");
			
			s("say(hipster2){");
      s("	 Is that even possible? What are the odds?");
      s("}");
			
			s("say(hipster1){");
      s("	 Yeah, we didn't expect this to happen.");
      s("}");
			
			s("say(hipster2){");
      s("	 Uh, so, how about a rematch then?");
      s("}");
			
			s("doendingcustomers()");
			
			s("delay(240)");
			
			s("movecharacter(jay,jaycartleft)");
			s("movecharacter(hipster1,hipstercartleft)");
			s("movecharacter(hipster2,hipstercartright)");
			s("wait(movement)");
			s("movecharacter(jay,jaycartleft_front)");
			s("movecharacter(hipster1,hipstercartleft_front)");
			s("movecharacter(hipster2,hipstercartright_front)");
			s("wait(movement)");
			s("movecharacter(jay,jaycartmidleft_front)");
			s("movecharacter(hipsters,hipstercartmidright_front)");
			s("wait(movement)");
			s("face(jay,right)");
			s("face(hipster1,left)");
			s("delay(90)");
			
			s("emote(jay,confused)");
			s("emote(hipsters,confused)");
			
			s("wait(customers)");
			
			s("movecharacter(jay,middlejay)");
			s("wait(movement)");
			s("movecharacter(jay,topjay)");
			s("movecharacter(hipsters,middlehipsters)");
			s("delay(70)");
			s("movecharacter(hipsters,tophipsters)");
			s("delay(70)");
			
			s("fadeout()");
			s("wait(fade)");
			s("delay(60)");
			s("endcustomers()");
			s("removecharacter(jay)");
			s("removecharacter(hipster1)");
			s("removecharacter(hipster2)");
			s("shopkeephascart()");
			s("scene(northstreet)");
			s("addcharacter(shopkeep,shopkeepcart)");
			s("fadein()");
			
			s("delay(20)");
			
			s("addcharacter(jay,bottomjay)");
			s("movecharacter(jay,middlejay_front)");
			s("wait(movement)");
			s("addcharacter(hipsters,bottomhipsters)");
			s("movecharacter(hipsters,middlejay_front)");
			s("movecharacter(jay,middlejayleft_front)");
			s("delay(30)");
			s("face(jay,right)");
			s("wait(movement)");
			s("face(jay,right)");
			s("movecharacter(hipsters,middlejayright_front)");
			s("wait(movement)");
			s("face(hipsters,left)");
			
			s("say(shopkeep){");
      s("  Oh, hello!");
      s("}");
			
			s("say(shopkeep){");
      s("  Business has been really great lately. So great that I've decided to expand!");
      s("}");
			
			s("say(shopkeep){");
      s("  I'm going to cut out the middleman! You!");
      s("}");
			
			s("delay(15)");
			s("emote(jay,alert)");
			s("emote(hipsters,alert)");
			s("delay(60)");
			
			s("say(shopkeep){");
      s("  People never wanted your food anyway; all they want are my signs!");
      s("}");
			
			s("say(shopkeep){");
      s("  Check out the latest model!");
      s("}");
			s("delay(30)");
			s("shopkeephassign()");
			s("flash(5)");
			s("shake(15)");
			s("delay(15)");
			s("emote(jay,alert");
			s("emote(hipsters,alert)");
			s("delay(120)");
			s("supersign()");
			s("delay(240)");
			s("gameover(win)");
			
		}else if (t == "goodending") {
			s("clearallcharacters()");
			s("endcustomers()");
			s("jayvictorysign()");
			s("fbdefeatsign()");
			s("scene(streets)");
			s("addcharacter(jay,jaycart)");
			s("addcharacter(hipsters,hipstercart)");
			s("face(hipster1,left)");
			s("face(hipster2,left)");
			s("jayhascart()");
			s("jayhassign()");
			s("fbhascart()");
			s("fbhassign()");
			s("fadein()");
			s("wait(fade)");
			
			s("delay(30)");
			
			s("say(hipster2){");
      s("	 ...fine, whatever. You win.");
      s("}");
			
			s("say(hipster1){");
      s("	 But we don't care! We're not going anywhere.");
      s("}");
			
			s("say(hipster2){");
      s("	 Hah!");
      s("}");
			
			s("delay(30)");
			s("emote(jay,angry)");
			s("delay(90)");
			s("emote(jay,nothing)");
			
			s("doendingcustomers()");
			
			s("delay(240)");
			
			s("movecharacter(jay,jaycartleft)");
			s("movecharacter(hipster1,hipstercartleft)");
			s("movecharacter(hipster2,hipstercartright)");
			s("wait(movement)");
			s("movecharacter(jay,jaycartleft_front)");
			s("movecharacter(hipster1,hipstercartleft_front)");
			s("movecharacter(hipster2,hipstercartright_front)");
			s("wait(movement)");
			s("movecharacter(jay,jaycartmidleft_front)");
			s("movecharacter(hipsters,hipstercartmidright_front)");
			s("wait(movement)");
			s("face(jay,right)");
			s("face(hipster1,left)");
			s("delay(90)");
			
			s("emote(jay,confused)");
			s("emote(hipsters,confused)");
			
			s("wait(customers)");
			
			s("movecharacter(jay,middlejay)");
			s("wait(movement)");
			s("movecharacter(jay,topjay)");
			s("movecharacter(hipsters,middlehipsters)");
			s("delay(70)");
			s("movecharacter(hipsters,tophipsters)");
			s("delay(70)");
			
			s("fadeout()");
			s("wait(fade)");
			s("delay(60)");
			s("endcustomers()");
			s("removecharacter(jay)");
			s("removecharacter(hipster1)");
			s("removecharacter(hipster2)");
			s("shopkeephascart()");
			s("scene(northstreet)");
			s("addcharacter(shopkeep,shopkeepcart)");
			s("fadein()");
			
			s("delay(20)");
			
			s("addcharacter(jay,bottomjay)");
			s("movecharacter(jay,middlejay_front)");
			s("wait(movement)");
			s("addcharacter(hipsters,bottomhipsters)");
			s("movecharacter(hipsters,middlejay_front)");
			s("movecharacter(jay,middlejayleft_front)");
			s("delay(30)");
			s("face(jay,right)");
			s("wait(movement)");
			s("face(jay,right)");
			s("movecharacter(hipsters,middlejayright_front)");
			s("wait(movement)");
			s("face(hipsters,left)");
			
			s("say(shopkeep){");
      s("  Oh, hello!");
      s("}");
			
			s("say(shopkeep){");
      s("  Business has been really great lately. So great that I've decided to expand!");
      s("}");
			
			s("say(shopkeep){");
      s("  I'm going to cut out the middleman! You!");
      s("}");
			
			s("delay(15)");
			s("emote(jay,alert)");
			s("emote(hipsters,alert)");
			s("delay(60)");
			
			s("say(shopkeep){");
      s("  People never wanted your food anyway; all they want are my signs!");
      s("}");
			
			s("say(shopkeep){");
      s("  Check out the latest model!");
      s("}");
			s("delay(30)");
			s("shopkeephassign()");
			s("flash(5)");
			s("shake(15)");
			s("delay(15)");
			s("emote(jay,alert");
			s("emote(hipsters,alert)");
			s("delay(120)");
			s("supersign()");
			s("delay(240)");
			s("gameover(win)");
			
		}else if (t == "goodending_old") {
			s("clearallcharacters()");
			s("jayvictorysign()");
			s("scene(streets)");
			s("addcharacter(jay,jaycart_front)");
			s("addcharacter(hipsters,jaycartright_front)");
			s("face(hipster1,left)");
			s("face(hipster2,left)");
			s("jayhascart()");
			s("jayhassign()");
			s("fbhasnocart()");
			s("fbhasnosign()");
			
			s("fadein()");
			s("wait(fade)");
			
			s("delay(30)");
			
			s("say(hipster2){");
      s("	 ...fine, whatever. Keep your stupid corner.");
      s("}");
			
			s("say(hipster1){");
      s("	 We're moving down the block!");
      s("}");
			
			s("delay(30)");
			s("emote(jay,victory)");
			s("delay(90)");
			
			s("movecharacter(hipsters,right)");
			s("wait(movement)");
			s("removecharacter(hipster1)");
			s("removecharacter(hipster2)");
			s("delay(60)");
			s("face(jay,left)");
			s("emote(jay,alert)");
			s("delay(60)");
			s("movecharacter(jay,jaycartright_front)");
			s("wait(movement)");
			s("movecharacter(jay,jaycartright)");
			
			s("addcharacter(shopkeep,left)");
			s("movecharacter(shopkeep,hipstercartleft_front)");
			s("shopkeepgetcart()");
			
			s("movecharacter(shopkeep,introcartposition)");
			s("wait(movement)");
			s("delay(30)");
			
			s("movecharacter(shopkeep,introcartposition_back)");
			
			s("delay(16)");
			
			s("shopkeepdropcart()");
			s("shopkeephascart()");
			s("delay(120)");
			
			s("face(shopkeep,left)");
			
			s("say(shopkeep){");
      s("  Oh, hello!");
      s("}");
			
			s("say(shopkeep){");
      s("  Business has been really great lately. So great that I've decided to expand!");
      s("}");
			
			s("say(shopkeep){");
      s("  I'm going to cut out the middleman! You!");
      s("}");
			
			s("delay(15)");
			s("emote(jay,angry)");
			s("delay(60)");
			s("emote(jay,nothing)");
			
			s("say(shopkeep){");
      s("  People don't want your food anyway; all they want are my signs!");
      s("}");
			
			s("say(shopkeep){");
      s("  Check out the latest model!");
      s("}");
			s("delay(30)");
			s("shopkeephassign()");
			s("flash(5)");
			s("shake(15)");
			s("delay(15)");
			s("emote(jay,alert");
			s("delay(60)");
			s("supersign()");
			s("delay(240)");
			s("gameover(win)");
		}else if (t == "badending") {
			s("clearallcharacters()");
			s("endcustomers()");
			s("fbvictorysign()");
			s("scene(streets)");
			s("addcharacter(jay,hipstercartleft_front)");
			s("addcharacter(hipsters,hipstercart_front)");
			s("face(hipster1,left)");
			s("face(hipster2,left)");
			s("jayhasnocart()");
			s("jayhasnosign()");
			s("fbhascart()");
			s("fbhassign()");
			
			s("fadein()");
			s("wait(fade)");
			
			s("delay(30)");
			
			s("say(hipsters){");
      s("	Hah! You lose, old man!");
      s("}");
			
			s("emote(jay,angry)");
			s("delay(90)");
			
			s("emote(jay,nothing)");
			s("delay(30)");
			s("face(jay,left)");
			s("delay(30)");
			
			s("movecharacter(jay,jaycartright_front)");
			s("wait(movement)");
			s("delay(60)");
			
			s("movecharacter(jay,jaycart_front)");
			s("wait(movement)");
			s("delay(60)");
			s("face(jay,right)");
			s("delay(10)");
			s("emote(hipsters,highfive)");
			s("gameover(lose)");
			s("delay(120)");
			
			s("face(jay,left)");
			s("delay(30)");
			s("movecharacter(jay,left)");
		}else if (t == "newday_loaded") {
			//Idential to below, except that it doesn't contain the "saved" message
			//Special new day script!
			s("clearallcharacters()");
			s("wait(fade)");
			s("scene(outsideshop)");
			s("removecharacter(jay)");
			s("removecharacter(hipster1)");
			s("removecharacter(hipster2)");
			s("addcharacter(jay,shopright)");
			s("fadein()");
			
			s("newday()");
			s("showdayinfo()");
			s("movecharacter(jay,shop_front)");
			s("wait(movement)");
			s("delay(20)");
			
			s("movecharacter(jay,shop_enter)");
			s("delay(20)");
			
			s("fadeout()");
			s("wait(fade)");
			s("removecharacter(jay)");
			s("delay(60)");
			
			//Different every day!
			s("dodayanimation()");
		}else if (t == "newday") {
			//Special new day script!
			if(!Control.turbomode){
				s("clearallcharacters()");
				s("wait(fade)");
				s("scene(outsideshop)");
				s("removecharacter(jay)");
				s("removecharacter(hipster1)");
				s("removecharacter(hipster2)");
				s("addcharacter(jay,shopright)");
				s("fadein()");
				
				s("newday()");
				s("showdayinfogamesaved()");
				s("movecharacter(jay,shop_front)");
				s("wait(movement)");
				s("delay(20)");
				
				s("movecharacter(jay,shop_enter)");
				s("delay(20)");
				
				s("fadeout()");
				s("wait(fade)");
				s("removecharacter(jay)");
				s("delay(30)");
				s("shopbell()");
				s("delay(30)");
				
				//Different every day!
				s("dodayanimation()");
			}else {
			  s("clearallcharacters()");
				s("newday()");
				s("startshopdayone()");
					
				s("fadein()");
			}
		}else if (t == "skipintro") {
			s("delay(60)");
			s("scene()");
			s("zoomout()");
			s("removecharacter(jay)");
			s("removecharacter(hipster1)");
			s("removecharacter(hipster2)");
			s("removecharacter(shopkeep)");
			s("clearallcharacters()");
			s("delay(60)");
			s("startshopdayone()");
			s("hidecutsceneborders()");
      s("fadein()");
		}else if (t == "playout") {
			s("clearallcharacters()");
			s("scene(streets)");
			s("addcharacter(jay,jaycart)");
			s("addcharacter(hipsters,hipstercart)");
			s("face(hipster1,right)");
			s("face(hipster2,left)");
			s("jayhascart()");
			s("jayhassign()");
			s("fbhascart()");
			s("fbhassign()");
			
			if(!Control.turbomode){
				s("showdayinfo()");
				s("delay(180)");
			}
			
			s("docustomers()");
			s("wait(customers)");
			s("calculate_customers()");
			
			s("movecharacter(jay,jaycartleft)");
			s("movecharacter(hipster1,hipstercartleft)");
			s("movecharacter(hipster2,hipstercartright)");
			s("wait(movement)");
			s("movecharacter(jay,jaycartleft_front)");
			s("movecharacter(hipster1,hipstercartleft_front)");
			s("movecharacter(hipster2,hipstercartright_front)");
			s("wait(movement)");
			s("movecharacter(jay,jaycartmidleft_front)");
			s("movecharacter(hipsters,hipstercartmidright_front)");
			s("wait(movement)");
			s("face(jay,right)");
			s("delay(15)");
			
			s("endday()");
			s("wait(endday)");
			s("delay(30)");
			
			if (Control.day == 6) {
				s("doending()");
				s("wait(fade)");
				s("delay(30)");
			}else {
				if(!Control.turbomode){
					s("carddep()");
				}else {
					s("debugskiptonewday()");
					
				}
				s("wait(fade)");
				s("delay(30)");
			}
		}else if (t == "intro") {
			s("newday()");
			s("clearallcharacters()");
			s("showcutsceneborders()");
			s("scene(streets)");
			s("jayhascart()");
			
			s("addcharacter(jay,jaycart)");
			s("addcharacter(hipster1,right)");
			s("addcharacter(hipster2,rightofcart)");
			s("getcart()");
			
			s("movecharacter(hipster1,introcartposition)");
			s("movecharacter(hipster2,introcartposition_right)");
			s("wait(movement)");
			s("delay(30)");
			
			s("movecharacter(hipster1,introcartposition_back)");
			s("movecharacter(hipster2,introcartposition_right_back)");
			
			s("delay(16)");
			
			s("face(hipster1,right)");
			s("dropcart()");
			s("fbhascart()");
			s("delay(60)");
			
			s("movecharacter(hipsters,hipstercart)");
			s("movecharacter(jay,jaycartleft)");
			s("wait(movement)");
			s("face(jay,right)");
			s("movecharacter(jay,jaycartleft_front)");
			s("wait(movement)");
			s("movecharacter(jay,jaycart_front)");
			
			s("wait(movement)");
			s("delay(15)");
			s("emote(jay,confused");
			s("delay(120)");
			
			s("fbhassign()");
			s("fbdefaultsign()");
			s("flash(5)");
			s("shake(15)");
			s("delay(15)");
			s("emote(jay,alert");
			s("delay(90)");
			s("movecharacter(jay,jaycartright_front)");
			s("delay(90)");
			s("movecharacter(jay,hipstercartleft_front)");
			
			s("wait(movement)");
			s("delay(10)");
			
			s("say(jay){");
      s("	What are you doing? You can't just show up here with your fancy sign and...");
      s("}");
			
			s("say(hipster2){");
      s("	Hah! What's wrong old man, afraid of a little competition?");
      s("}");
			
			s("emote(jay,angry)");
			s("delay(45)");
			
			s("say(jay){");
      s("	Grr! I'm not afraid of you kids! You won't last a week here!");
      s("}");
			
			s("emote(jay,normal)");
			
			s("say(hipster1){");
      s("	Oh yeah? If you're so sure, let's make a bet!");
      s("}");
			
			s("say(hipster2){");
      s(" We bet we'll have more customers than you by the end of the week!");
      s("}");
			
			s("say(hipster1){");
      s("	Winner stays on this corner!");
      s("}");
			
			s("delay(45)");
			
			s("say(jay){");
      s("	You're on! You don't stand a chance!");
      s("}");
			
			s("delay(60)");
			s("movecharacter(jay,jaycart_front)");
			s("delay(120)");
			
			s("say(jay){");
      s("	I'm gonna need one of those signs...");
      s("}");
			s("delay(15)");
			s("movecharacter(jay,left)");
			s("delay(60)");
			
			s("fadeout()");
			s("delay(60)");
			s("scene(outsideshop)");
			s("removecharacter(jay)");
			s("removecharacter(hipster1)");
			s("removecharacter(hipster2)");
			s("addcharacter(jay,shopright)");
			s("fadein()");
			
			s("showdayinfo()");
			s("movecharacter(jay,shop_front)");
			s("wait(movement)");
			s("delay(20)");
			
			s("movecharacter(jay,shop_enter)");
			s("delay(20)");
			
			s("fadeout()");
			s("wait(fade)");
			s("removecharacter(jay)");
			s("delay(30)");
			s("shopbell()");
			s("delay(30)");
			
			s("scene(shop)");
			s("addcharacter(jay,inshop_left)");
			s("addcharacter(shopkeep,inshop_right)");
			s("zoomin(camerashop)");
			s("fadein()");
			s("wait(fade)");
			
			s("movecharacter(jay,inshop_attill)");
			s("delay(15)");
			s("movecharacter(shopkeep,inshop_shopkeep)");
			s("wait(movement)");
			
			s("say(jay){");
      s("	I need a sign!");
      s("}");
			
			s("say(shopkeep){");
      s("	Sold!");
      s("}");
			
      s("fadeout()");
			s("wait(fade)");
			s("removecharacter(jay)");
			s("removecharacter(shopkeep)");
			s("scene()");
			s("zoomout()");
			
			s("delay(30)");
      s("fadein()");
			s("doboughtlcdsign()");
			s("wait(lcdsign)");
      s("fadeout()");
			s("delay(30)");
			s("scene(shop)");
			s("zoomin(camerashop)");
			
			s("addcharacter(jay,inshop_attill)");
			s("addcharacter(shopkeep,inshop_shopkeep)");
			s("face(shopkeep,left)");
      s("fadein()");
			
			s("delay(20)");
			
			s("say(shopkeep){");
      s("	That's a good start! But if you want to compete these days...");
      s("}");
			
			s("say(shopkeep){");
      s("	... you'll need more than a basic sign.");
      s("}");
			
			s("say(shopkeep){");
      s("	I sell punch cards for all the latest settings.");
      s("}");
			
			s("delay(20)");
			s("addcharacter(hipsters,inshop_left)");
			s("movecharacter(hipsters,inshop_inqueue)");
			s("delay(25)");
			s("face(jay,left)");
			s("emote(jay,alert)");
			s("wait(movement)");
			s("delay(60)");
			
			s("face(jay,right)");
			
			s("say(shopkeep){");
      s("  ...but they tend to sell out pretty quickly.");
      s("}");
			
			s("delay(60)");
			
      s("fadeout()");
			s("wait(fade)");
			s("scene()");
			
			s("zoomout()");
			s("removecharacter(jay)");
			s("removecharacter(hipster1)");
			s("removecharacter(hipster2)");
			s("removecharacter(shopkeep)");
			s("delay(60)");
			
			s("startshopdayone()");
			
      s("fadein()");
			s("hidecutsceneborders()");
		}else {
			trace("Error: Can't find script " + t);
		}
		
		Game.running = true;
	}
	
	public static function s(t:String):Void {	Game.add(t); }

	public static function runscript():Void {
		//Heart of the scripting engine: script commands implemented here
		while (Game.running && Game.scriptdelay <= 0 && !Game.pausescript) {
			if (Game.position < Game.scriptlength) {
				//Let's split or command in an array of words
				Game.tokenize(Game.commands[Game.position]);
				
				//Ok, now we run a command based on that string
				if (Game.parsetext) {
					Textbox.addline(Help.trimspaces(Game.words[0].toUpperCase()));
				}else if (Game.words[0] == "shopbell") {
					Music.playef("shopbell");
				}else if (Game.words[0] == "scene") {
					Control.scene = Game.words[1];
				}else if (Game.words[0] == "fadeout") {
					Gfx.fademode = Def.FADE_OUT;
				}else if (Game.words[0] == "fadein") {
					Gfx.fademode = Def.FADE_IN;
				}else if (Game.words[0] == "music") {
					//Music.play(Game.words[1]);
				}else if (Game.words[0] == "jayhascart") {
					Control.jayhascart = true;
				}else if (Game.words[0] == "jayhassign") {
					Control.jayhassign = true;
				}else if (Game.words[0] == "fbhascart") {
					Control.fbhascart = true;
				}else if (Game.words[0] == "fbhassign") {
					Control.fbhassign = true;
				}else if (Game.words[0] == "shopkeephascart") {
					Control.shopkeephascart = true;
				}else if (Game.words[0] == "shopkeephassign") {
					Control.shopkeephassign = true;
				}else if (Game.words[0] == "jayhasnocart") {
					Control.jayhascart = false;
				}else if (Game.words[0] == "jayhasnosign") {
					Control.jayhassign = false;
				}else if (Game.words[0] == "fbhasnocart") {
					Control.fbhascart = false;
				}else if (Game.words[0] == "fbhasnosign") {
					Control.fbhassign = false;
				}else if (Game.words[0] == "fbdefaultsign") {
					Gfx.sign = 1;
					Control.frame[1].clear();
					Control.frame[1].add("FILTHY", "red_flash", "none", "none");
					Control.frame[1].add("BURGER", "white", "none", "none");
					Control.frame[1].start(1);
				}else if (Game.words[0] == "jaytiesign") {
					Gfx.sign = 0;
					Control.frame[0].clear();
					Control.frame[0].add("Huh", "blue-white_flicker", "none", "none");
					Control.frame[0].start(0);
				}else if (Game.words[0] == "fbtiesign") {
					Gfx.sign = 1;
					Control.frame[1].clear();
					Control.frame[1].add("Hrmm", "red-white_flicker", "none", "none");
					Control.frame[1].start(1);
				}else if (Game.words[0] == "jayvictorysign") {
					Gfx.sign = 0;
					Control.frame[0].clear();
					Control.frame[0].add("VICTORY", "blue-white_flicker", "none", "bob");
					Control.frame[0].start(0);
				}else if (Game.words[0] == "fbdefeatsign") {
					Gfx.sign = 1;
					Control.frame[1].clear();
					Control.frame[1].add(":(", "red-white_flicker", "none", "none");
					Control.frame[1].start(1);
				}else if (Game.words[0] == "supersign") {
					Control.createsupersign();
				}else if (Game.words[0] == "fbvictorysign") {
					Gfx.sign = 1;
					Control.frame[1].clear();
					Control.frame[1].add("WE WIN", "slow_cycle", "none", "bob");
					Control.frame[1].add("LOL", "slow_cycle", "none", "invert");
					Control.frame[1].start(1);
				}else if (Game.words[0] == "showcutsceneborders") {
					Control.showcutsceneborders = true;
				}else if (Game.words[0] == "hidecutsceneborders") {
				  Control.showcutsceneborders = false;
				}else if (Game.words[0] == "debugskiptonewday") {
					Customercontrol.customerphase = false;
					Gfx.fademode = Def.FADE_OUT;
					Gfx.fadeaction = "game_newday";
				}else if (Game.words[0] == "carddep") {
					Gfx.fademode = Def.FADE_OUT;
					Gfx.fadeaction = "carddep";
				}else if (Game.words[0] == "doending") {
					Gfx.fademode = Def.FADE_OUT;
					Gfx.fadeaction = "doending";
				}else if (Game.words[0] == "showdayinfo") {
					Control.showdayinfo = 180;
					Control.showgamesaved = false;
				}else if (Game.words[0] == "showdayinfogamesaved") {
					Control.showdayinfo = 180;
					Control.showgamesaved = true;
					Savecookie.savedata();
				}else if (Game.words[0] == "doboughtlcdsign") {
					Control.boughtlcdsign = true;
					Control.changeboughtlcdsignstate("boughtlcdsign");
				}else if (Game.words[0] == "newday") {
					Control.day++;
				}else if (Game.words[0] == "startshopdayone") {
					Gui.deleteall("tiny");
					
					Control.newshop(Control.day);
					Control.changeshopstate("start");
					Control.currentscreen = "game_shop";
					Control.initshop();
				}else if (Game.words[0] == "delay") {
					//USAGE: delay(frames)
					Game.scriptdelay = Std.parseInt(Game.words[1]);
				}else if (Game.words[0] == "flash") {
					//USAGE: flash(frames)
					Gfx.flashlight = Std.parseInt(Game.words[1]);
				}else if (Game.words[0] == "shake") {
					//USAGE: shake(frames)
					Gfx.screenshake = Std.parseInt(Game.words[1]);
				}else if (Game.words[0] == "zoomout") {
					Control.zoomout();
				}else if (Game.words[0] == "zoomin") {
					Control.zoomin(Std.int(Control.getposition(Game.words[1]).x), Std.int(Control.getposition(Game.words[1]).y));
			  }else if (Game.words[0] == "endcustomers") {
				  Customercontrol.customerphase	= false;
				}else if (Game.words[0] == "docustomers") {
					Customercontrol.setupcustomers();
				}else if (Game.words[0] == "doendingcustomers") {
					Customercontrol.setupendingcustomers();
				}else if (Game.words[0] == "endday") {
					Control.enddayphase = true;
					Control.changeenddaystate("start");
				}else if (Game.words[0] == "calculate_customers") {
					Control.dayscore_fb[Control.day-1] = Customercontrol.fbscore;
					Control.dayscore_jay[Control.day-1] = Customercontrol.jayscore;
					
					Control.totalscore_fb = 0;
					Control.totalscore_jay = 0;
					for (i in 0...6) {
						Control.totalscore_fb += Control.dayscore_fb[i];
						Control.totalscore_jay += Control.dayscore_jay[i];
					}
				}else if (Game.words[0] == "changemap") {
					//USAGE: changemap("map
					Obj.activedoordest = Game.words[1];
					Obj.doortox = Std.parseInt(Game.words[2]);
					Obj.doortoy = Std.parseInt(Game.words[3]);
					
					Gfx.fademode = Def.FADE_OUT;
					Gfx.fadeaction = "changeroom";
				}else if (Game.words[0] == "wait") {
					//USAGE: wait(fade) - Wait until the screen is faded out
					if(Game.words[1]=="fade"){
						if (Gfx.fademode != Def.FADED_OUT && Gfx.fademode != Def.FADED_IN) {
							Game.scriptdelay = 2; Game.position--;
						}else {
							Game.scriptdelay = 0;
						}
					}else if (Game.words[1] == "endday") {
						if (Control.enddayphase) {
							Game.scriptdelay = 2; Game.position--;
						}else {
							Game.scriptdelay = 0;
						}
					}else if (Game.words[1] == "customers") {
						if (Customercontrol.totalcustomers > 0) {
							Game.scriptdelay = 2; Game.position--;
						}else {
							Game.scriptdelay = 0;
						}
					}else if(Game.words[1]=="lcdsign"){
						if (Control.boughtlcdsign) {
							Game.scriptdelay = 2; Game.position--;
						}else {
							Game.scriptdelay = 0;
						}
					}else if (Game.words[1] == "movement") {
						var t:Int = 0;
						for (i in 0...Obj.nentity) {
							if (Obj.entities[i].active) {
								if (Obj.entities[i].doscriptmove) {
									t = 1;
								}
							}
						}
						if (t > 0) {
							Game.scriptdelay = 2; Game.position--;
						}else {
							Game.scriptdelay = 0;
						}
					}
				}else if (Game.words[0] == "gameover") {
					Control.gameoverbanner = true;
					Control.gameoverbannerposition = 0;
					Control.gameovershowbutton = false;
					if (Game.words[1] == "win") {
						Control.gameovermessage = "CONGRATULATIONS";
					}else {
						Control.gameovermessage = "GAME OVER";
					}
				}else if (Game.words[0] == "say") {
					Game.speaker = Game.words[1];
					Control.voice = Game.words[1];
					if (Game.speaker == "hipsters") {
						Game.speaker = "hipster2";
						
						Obj.entities[Obj.getperson(Game.speaker)].emote = "talk";
						Obj.entities[Obj.getperson(Game.speaker)].emoteframe = 0;
						Obj.entities[Obj.getperson(Game.speaker)].emoteframedelay = 0;
						
						Game.speaker = "hipster1";
						Obj.entities[Obj.getperson(Game.speaker)].emote = "talk";
						Obj.entities[Obj.getperson(Game.speaker)].emoteframe = 0;
						Obj.entities[Obj.getperson(Game.speaker)].emoteframedelay = 0;
					}else {
						if(Obj.entities[Obj.getperson(Game.words[1])].emote != "angry"){
							Obj.entities[Obj.getperson(Game.words[1])].emote = "talk";
							Obj.entities[Obj.getperson(Game.words[1])].emoteframe = 0;
							Obj.entities[Obj.getperson(Game.words[1])].emoteframedelay = 0;
						}
					}
					
					Textbox.createtextbox(Obj.entities[Obj.getperson(Game.speaker)].stringpara, 0, 0, Textbox.col);
					if (Game.words[1] == "jay") {
						Textbox.textboxsnowname();
					}
					Game.parsetext = true;
				}else if (Game.words[0] == "endsay") {
					//Prepare to speak a block of text
					//if (Game.speaker != "") Textbox.textboxposition(Obj.getnpc(Game.speaker));
					Textbox.starttextbox();
					Game.parsetext = false;
					
					Game.pausescript = true;
				}else if (Game.words[0] == "textboxstyle") {
					//Change textbox style:
					Textbox.col = Std.parseInt(Game.words[1]);
				}else if (Game.words[0] == "addcharacter") {
					if (Game.words[1] == "hipsters") {
						Obj.createentity(Std.int(Control.getposition(Game.words[2]).x) - 16, Std.int(Control.getposition(Game.words[2]).y), "person", "hipster1");
						Obj.createentity(Std.int(Control.getposition(Game.words[2]).x) + 16, Std.int(Control.getposition(Game.words[2]).y), "person", "hipster2");
					}else{
						Obj.createentity(Std.int(Control.getposition(Game.words[2]).x), Std.int(Control.getposition(Game.words[2]).y), "person", Game.words[1]);
					}
				}else if (Game.words[0] == "getcart") {
					Obj.entities[Obj.getperson("hipster1")].hascart = true;
				}else if (Game.words[0] == "shopkeepgetcart") {
					Obj.entities[Obj.getperson("shopkeep")].hascart = true;
				}else if (Game.words[0] == "dropcart") {
					Obj.entities[Obj.getperson("hipster1")].hascart = false;
				}else if (Game.words[0] == "shopkeepdropcart") {
					Obj.entities[Obj.getperson("shopkeep")].hascart = false;
				}else if (Game.words[0] == "movecharacter") {
					if (!Control.characterswalking()) Control.walkingdelay = 0;
					if (Game.words[1] == "hipsters") {
						var t:Int = Obj.getperson("hipster1");
						if (t >= 0) {
							Obj.entities[t].doscriptmove = true;
							Obj.entities[t].scriptmovedestx = Std.int(Control.getposition(Game.words[2]).x) - 16;
							Obj.entities[t].scriptmovedesty = Std.int(Control.getposition(Game.words[2]).y);
						}
						var t:Int = Obj.getperson("hipster2");
						if (t >= 0) {
							Obj.entities[t].doscriptmove = true;
							Obj.entities[t].scriptmovedestx = Std.int(Control.getposition(Game.words[2]).x) + 16;
							Obj.entities[t].scriptmovedesty = Std.int(Control.getposition(Game.words[2]).y);
						}
					}else{
						var t:Int = Obj.getperson(Game.words[1]);
						if (t >= 0) {
							Obj.entities[t].doscriptmove = true;
							Obj.entities[t].scriptmovedestx = Std.int(Control.getposition(Game.words[2]).x);
							Obj.entities[t].scriptmovedesty = Std.int(Control.getposition(Game.words[2]).y);
						}
					}
				}else if (Game.words[0] == "face") {
					if (Game.words[1] == "hipsters") {
						Obj.entities[Obj.getperson("hipster1")].dir = Control.persondir(Game.words[2]);
						Obj.entities[Obj.getperson("hipster2")].dir = Control.persondir(Game.words[2]);
					}else{
						var t:Int = Obj.getperson(Game.words[1]);
						Obj.entities[t].dir = Control.persondir(Game.words[2]);
					}
				}else if (Game.words[0] == "clearallcharacters") {
					for (i in 0 ... Obj.nentity) {
						Obj.entities[i].active = false;
					}
					Obj.nentity = 0;
				}else if (Game.words[0] == "removecharacter") {
					if (Game.words[1] == "hipsters") {
						var t:Int = Obj.getperson("hipster1");
						if (t >= 0) {
							Obj.entities[t].active = false;
						}
						var t:Int = Obj.getperson("hipster2");
						if (t >= 0) {
							Obj.entities[t].active = false;
						}
					}else{
						var t:Int = Obj.getperson(Game.words[1]);
						if (t >= 0) {
							Obj.entities[t].active = false;
						}
					}
				}else if (Game.words[0] == "emote") {
					if (Game.words[1] == "hipsters") {
						Obj.entities[Obj.getperson("hipster1")].emote = Game.words[2];
						Obj.entities[Obj.getperson("hipster2")].emote = Game.words[2];
						Obj.entities[Obj.getperson("hipster1")].emoteframe = 0;
						Obj.entities[Obj.getperson("hipster2")].emoteframe = 0;
						Obj.entities[Obj.getperson("hipster1")].emoteframedelay = 0;
						Obj.entities[Obj.getperson("hipster2")].emoteframedelay = 0;
					}else {						
						Obj.entities[Obj.getperson(Game.words[1])].emote = Game.words[2];
						Obj.entities[Obj.getperson(Game.words[1])].emoteframe = 0;
						Obj.entities[Obj.getperson(Game.words[1])].emoteframedelay = 0;
						if (Game.words[2] == "confused") {
							//Music.playef("confused");
						}else if (Game.words[2] == "alert") {
							Music.playef("alert");
						}
					}
				}else if (Game.words[0] == "dodayanimation") {
					if (Control.day == 2 || Control.day == 6) {
						s("scene(shop)");
						s("addcharacter(jay,inshop_left)");
						s("addcharacter(shopkeep,inshop_shopkeep)");
						s("face(shopkeep,left)");
						s("addcharacter(hipsters,inshop_hipstersattill)");
						s("face(hipsters,right)");
						s("zoomin(camerashop)");
						s("fadein()");
						s("wait(fade)");
						
						s("movecharacter(jay,inshop_jayinqueue)");
						s("delay(90)");
						s("emote(jay,angry)");
						s("delay(60)");
					}else if (Control.day == 3 || Control.day == 5) {
						s("scene(shop)");
						s("addcharacter(jay,inshop_left)");
						s("addcharacter(shopkeep,inshop_right)");
						s("zoomin(camerashop)");
						s("fadein()");
						s("wait(fade)");
						
						s("movecharacter(jay,inshop_attill)");
						s("movecharacter(shopkeep,inshop_shopkeep)");
						s("delay(45)");
						s("addcharacter(hipsters,inshop_left)");
						s("movecharacter(hipsters,inshop_inqueue)");
						s("wait(movement)");
						s("delay(30)");
						s("emote(jay,victory)");
						s("emote(hipsters,sad)");
						s("delay(120)");
					}else if(Control.day == 4){
						s("scene(shop)");
						s("addcharacter(jay,inshop_left)");
						s("addcharacter(shopkeep,inshop_shopkeep)");
						s("face(shopkeep,left)");
						s("addcharacter(hipsters,inshop_hipstersattill)");
						s("face(hipsters,right)");
						s("zoomin(camerashop)");
						s("fadein()");
						s("wait(fade)");
						
						s("movecharacter(jay,inshop_jayinqueue)");
						s("wait(movement)");
						s("emote(jay,alert)");
						s("delay(90)");
						s("face(jay,left)");
						s("emote(hipsters,highfive)");
						s("delay(120)");
					}
					
					//Clean up
					s("fadeout()");
					s("wait(fade)");
					s("scene()");
					
					s("zoomout()");
					s("removecharacter(jay)");
					s("removecharacter(hipster1)");
					s("removecharacter(hipster2)");
					s("removecharacter(shopkeep)");
					s("delay(60)");
					
					s("startshopdayone()");
					
					s("fadein()");
				}
					
				Game.position++;
			}else {
				Game.running = false;
			}
		}
		
		if (Game.scriptdelay > 0) {
			Game.scriptdelay--;
		}
	}
}