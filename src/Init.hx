package;

import openfl.display.*;
import openfl.Assets;
import config.*;
import gamecontrol.*;
import com.terry.*;
import objs.*;

class Init {
	public static function initengine(stage:Stage):Void {
		Key.init(stage);
		Mouse.init(stage);
		Gui.init(stage);
		Help.init();
		Music.init();
		Obj.init();
		Game.init(stage);
		Gfx.init(stage);
		
		Textbox.init();
		
		Edphase.init();
		
		Control.init();
		Draw.init();
		
		#if flash
		Game.fullscreen = false;
		#else
		Savecookie.loadsettings();
		if (Savecookie.fullscreen == 1) {
			Game.fullscreen = true;
		}else {
			Game.fullscreen = false;
		}
		#end
		Game.updategraphicsmode();
	}
	
	public static function loadresources():Void {
		//Load Music
		/*
		Music.addsong("silence");
		Music.addsong("grabthem");
		
		Music.play("grabthem");
		*/
		
		//Load Soundeffects
		Music.addeffect("voice_mid", 0.2); Music.usingtickertext = true;
		Music.addeffect("voice_low", 0.2);
		Music.addeffect("voice_low2", 0.2);
		Music.addeffect("voice_high", 0.2);
		Music.addeffect("click");
		Music.addeffect("menu_select");
		Music.addeffect("alert", 0.2);
		Music.addeffect("angryjump", 0.2);
		Music.addeffect("confused", 0.2);
		Music.addeffect("sold", 0.5);
		Music.addeffect("shopbell", 0.5);
		Music.addeffect("card1");
		Music.addeffect("card2", 0.5);
		Music.addeffect("card3", 0.5);
		Music.addeffect("card4");
		Music.addeffect("coin", 0.2);
		Music.addeffect("coin_jay", 0.2);
		Music.addeffect("coin_fb", 0.2);
		Music.addeffect("win", 0.5);
		Music.addeffect("lose", 0.5);
		Music.addeffect("drumroll", 0.5);
		Music.addeffect("dayscore", 0.5);
		Music.addeffect("walking", 0.1);
		Music.addeffect("reduce", 0.5);
		
		//Load Tiles, Sprites
		Gfx.maketilearray("data/graphics/tiles.png");
		Gfx.makespritearray("data/graphics/sprites.png");
		
		Gfx.makecardsarray("data/graphics/cards.png");
		Gfx.makeminicardsarray("data/graphics/minicards.png");
		
		//Textbox sides
		Gfx.maketbsidesarray("data/graphics/tbsides.png");
		
		//Load large images
		Gfx.addimage("titlebackground", "data/graphics/bg.png");
		Gfx.addimage("streets", "data/graphics/streets.png");
		Gfx.addimage("northstreet", "data/graphics/northstreet.png");
		Gfx.addimage("outsideshop", "data/graphics/outsideshop.png");
		Gfx.addimage("tint", "data/graphics/tint.png");
		Gfx.addimage("signbacking", "data/graphics/signbacking.png");
		Gfx.addimage("shop", "data/graphics/shop.png");
		Gfx.addimage("frontdesk", "data/graphics/frontdesk.png");
		Gfx.addimage("help1", "data/graphics/help1.png");
		Gfx.addimage("help2", "data/graphics/help2.png");
	}
	
	//For embedding font, external to library
	public static var fontlocation:String = "data/graphics/font/font.ttf";
	
	public static function init(stage:Stage):Void {
		//Setup the classes
		initengine(stage);
		
		stage.quality = StageQuality.LOW;
		
		//Init all entity types
		Obj.templates.push(new Ent_person());
		Obj.loadtemplates();
		
		//Init game variables
		//Game.gamestate = Def.TITLEMODE;
		Game.gamestate = Def.GAMEMODE; Control.start(0);
		
		//Load resources
		loadresources();
		
		//Start the game
		Coreloop.setupgametimer();
	}
}