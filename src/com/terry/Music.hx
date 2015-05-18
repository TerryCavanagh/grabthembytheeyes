package com.terry;

import openfl.display.*;          
import openfl.media.*; 
import openfl.events.*;
import openfl.Assets;

class Music {
	public static function init():Void{
		currentsong = "nothing"; musicfade = 0;//no music, no amb
		currentefchan = 0;
		usingtickertext = false;
		
		numplays = 0;
		numeffects = 0;
		numsongs = 0;
	}
	
	public static function play(t:String):Void {
		if (currentsong !=t) {
			if (currentsong != "nothing") {
				//Stop the old song first
				musicchannel.stop();
				musicchannel.removeEventListener(Event.SOUND_COMPLETE, loopmusic);
			}
			if (t != "nothing") {
				currentsong = t;
				
				musicchannel = musicchan[Std.int(songindex.get(t))].play(0);
				musicchannel.soundTransform = new SoundTransform(songvolumelevels[Std.int(songindex.get(t))] * Game.globalsound);
				
				musicchannel.addEventListener(Event.SOUND_COMPLETE, loopmusic);
			}else {	
				currentsong = "nothing";
			}
		}
	}   
	
	public static function loopmusic(e:Event):Void { 
		musicchannel.removeEventListener(Event.SOUND_COMPLETE, loopmusic);
		if (currentsong != "nothing") {
			musicchannel = musicchan[Std.int(songindex.get(currentsong))].play();
			musicchannel.soundTransform = new SoundTransform(songvolumelevels[Std.int(songindex.get(currentsong))] * Game.globalsound);
				
			musicchannel.addEventListener(Event.SOUND_COMPLETE, loopmusic);
		}
	}
	
	public static function stopmusic(e:Event):Void { 
		musicchannel.removeEventListener(Event.SOUND_COMPLETE, stopmusic);
		musicchannel.stop();
		currentsong = "nothing";
	}
	
	public static function stop():Void { 
		musicchannel.removeEventListener(Event.SOUND_COMPLETE, stopmusic);
		musicchannel.stop();
		currentsong = "nothing";
	}
	
	public static function fadeout():Void { 
		if (musicfade == 0) {
			musicfade = 31;
		}
	}
	
	public static function processmusicfade():Void {
		musicfade--;
		if (musicfade > 0) {
			musicchannel.soundTransform = new SoundTransform((musicfade / 30) * Game.globalsound);
		}else {
			musicchannel.stop();
			currentsong = "nothing";
		}
	}
	
	public static function processmusicfadein():Void {
		musicfadein--;
		if (musicfadein > 0) {
			musicchannel.soundTransform = new SoundTransform(((60-musicfadein) / 60 )*Game.globalsound);
		}else {
			musicchannel.soundTransform = new SoundTransform(1.0 * Game.globalsound);
		}
	}
	
	public static function processmusic():Void {
		if (musicfade > 0) processmusicfade();
		if (musicfadein > 0) processmusicfadein();
	}
	
	public static function updateallvolumes():Void {
		//Update the volume levels of all currently playing sounds.
		//Music:
		if(currentsong!="nothing"){
			musicchannel.soundTransform = new SoundTransform(songvolumelevels[Std.int(songindex.get(currentsong))] * Game.globalsound);
		}
		//Sound effects
		//Figure this out someday I guess?
	}
	
	public static function processmute():Void {
		/*
		if (Key.justPressed("M") && Game.mutebutton<=0) {
			Game.mutebutton = 2; if (Game.muted) { Game.muted = false; }else { Game.muted = true;}
		}
		if (Game.mutebutton > 0 && !Key.pressed("M")) Game.mutebutton--;
		*/
		if (Game.muted) {
			if (Game.globalsound == 1) {
				Game.globalsound = 0;
				updateallvolumes();
			}
		}
		
		if (!Game.muted && Game.globalsound < 1) {
			Game.globalsound += 0.05; 
			if (Game.globalsound > 1.0) Game.globalsound = 1.0;
			updateallvolumes();
		}
	}
	
	//Play a sound effect! There are 16 channels, which iterate
	public static function playef(t:String, offset:Int = 0):Void {
		temptransform = new SoundTransform(volumelevels[Std.int(effectindex.get(t))] * Game.globalsound);
		efchannel[currentefchan] = efchan[Std.int(effectindex.get(t))].play(offset);
		efchannel[currentefchan].soundTransform = temptransform;
		currentefchan++;
		if (currentefchan > 15) currentefchan -= 16;
	}
	
	public static function addeffect(t:String, vol:Float = 1.0):Void {
		effectindex.set(t, numeffects);
		volumelevels.push(vol);
		#if flash
		efchan.push(Assets.getSound("data/sounds/" + t + ".mp3")); 
		#else
		efchan.push(Assets.getSound("data/sounds/" + t + ".ogg")); 
		#end
		numeffects++;
	}
	
	public static function addsong(t:String, vol:Float = 1.0):Void {	
		songindex.set(t, numsongs);
		songvolumelevels.push(vol);
		#if flash
		musicchan.push(Assets.getMusic("data/music/" + t + ".mp3"));
		#else
		musicchan.push(Assets.getMusic("data/music/" + t + ".ogg"));
		#end
		numsongs++;
	}
	
	public static var musicchan:Array<Dynamic> = new Array<Dynamic>();	
	public static var musicchannel:SoundChannel;
	public static var currentsong:String;
	public static var musicfade:Int;
	public static var musicfadein:Int;
	
	public static var effectindex:Map<String, Int> = new Map<String, Int>();
	public static var volumelevels:Array<Float> = new Array<Float>();
	public static var numeffects:Int;
	
	public static var songindex:Map<String, Int> = new Map<String, Int>();
	public static var songvolumelevels:Array<Float> = new Array<Float>();
	public static var numsongs:Int;
	
	public static var currentefchan:Int;
	public static var efchannel:Array<SoundChannel> = new Array<SoundChannel>();
	public static var efchan:Array<Sound> = new Array<Sound>();
	public static var numplays:Int;
	
	public static var usingtickertext:Bool;
	
	public static var temptransform:SoundTransform;
}