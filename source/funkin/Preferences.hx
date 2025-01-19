package funkin;

import funkin.save.Save;

/**
 * A core class which provides a store of user-configurable, globally relevant values.
 */
class Preferences
{
  /**
   * Cap the FPS at this value.
   * @default `60`
   */
  public static var framerate(get, set):Int;

  static function get_framerate():Int
  {
    #if web
    return 60;
    #else
    return Save?.instance?.options?.framerate ?? 60;
    #end
  }

  static function set_framerate(value:Int):Int
  {
    #if web
    return 60;
    #else
    var save:Save = Save.instance;
    save.options.framerate = value;
    save.flush();
    FlxG.updateFramerate = value;
    FlxG.drawFramerate = value;
    return value;
    #end
  }

  /**
   * Whether some particularly foul language is displayed.
   * @default `true`
   */
  public static var naughtyness(get, set):Bool;

  static function get_naughtyness():Bool
  {
    return Save?.instance?.options?.naughtyness;
  }

  static function set_naughtyness(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.naughtyness = value;
    save.flush();
    return value;
  }

  /**
   * If enabled, the strumline is at the bottom of the screen rather than the top.
   * @default `false`
   */
  public static var downscroll(get, set):Bool;

  static function get_downscroll():Bool
  {
    return Save?.instance?.options?.downscroll;
  }

  static function set_downscroll(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.downscroll = value;
    save.flush();
    return value;
  }

  /**
   * If enabled, the strumline is in the middle of the screen rather than the right.
   * @default `false`
   */
  public static var middlescroll(get, set):Bool;

  static function get_middlescroll():Bool
  {
    return Save?.instance?.options?.middlescroll;
  }

  static function set_middlescroll(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.middlescroll = value;
    save.flush();
    return value;
  }

  /**
   * If disabled, the opponent's strumline is invisible.
   * @default `true`
   */
  public static var oppStrumVis(get, set):Bool;

  static function get_oppStrumVis():Bool
  {
    return Save?.instance?.options?.oppStrumVis;
  }

  static function set_oppStrumVis(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.oppStrumVis = value;
    save.flush();
    return value;
  }

  /**
   * If enabled, ghost tapping won't have any consequences.
   * @default `false`
   */
  public static var ghostTap(get, set):Bool;

  static function get_ghostTap():Bool
  {
    return Save?.instance?.options?.ghostTap;
  }

  static function set_ghostTap(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.ghostTap = value;
    save.flush();
    return value;
  }

  /**
   * When changed, the alpha (transparency/opacity) of the Health Bar follows.
   * @default `100`
   */
  public static var uiAlpha(get, set):Int;

  static function get_uiAlpha():Int
  {
    return Save?.instance?.options?.uiAlpha;
  }

  static function set_uiAlpha(value:Int):Int
  {
    var save:Save = Save.instance;
    save.options.uiAlpha = value;
    save.flush();
    return value;
  }

  /**
   * If enabled, a list of all judgements appears on the left half.
   * @default `false`
   */
  public static var judgementCounter(get, set):Bool;

  static function get_judgementCounter():Bool
  {
    return Save?.instance?.options?.judgementCounter;
  }

  static function set_judgementCounter(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.judgementCounter = value;
    save.flush();
    return value;
  }

  /**
   * If enabled, a timer showing selected option appears.
   * @default `"disabled"`
   */
  public static var timeBar(get, set):String;

  static function get_timeBar():String
  {
    return Save?.instance?.options?.timeBar;
  }

  static function set_timeBar(value:String):String
  {
    var save:Save = Save.instance;
    save.options.timeBar = value;
    save.flush();
    return value;
  }

  /**
   * If disabled, flashing lights in the main menu and other areas will be less intense.
   * @default `true`
   */
  public static var flashingLights(get, set):Bool;

  static function get_flashingLights():Bool
  {
    return Save?.instance?.options?.flashingLights ?? true;
  }

  static function set_flashingLights(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.flashingLights = value;
    save.flush();
    return value;
  }

  /**
   * When changed, the health bar colors will follow the selected.
   * @default `"soft"`
   */
  public static var healthColors(get, set):String;

  static function get_healthColors():String
  {
    return Save?.instance?.options?.healthColors;
  }

  static function set_healthColors(value:String):String
  {
    var save:Save = Save.instance;
    save.options.healthColors = value;
    save.flush();
    return value;
  }

  /**
   * If disabled, the camera bump synchronized to the beat.
   * @default `false`
   */
  public static var zoomCamera(get, set):Bool;

  static function get_zoomCamera():Bool
  {
    return Save?.instance?.options?.zoomCamera;
  }

  static function set_zoomCamera(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.zoomCamera = value;
    save.flush();
    return value;
  }

  /**
   * If enabled, score text bops when note hit, and reverse bops(?) when miss.
   * @default `false`
   */
  public static var scoreZoom(get, set):Bool;

  static function get_scoreZoom():Bool
  {
    return Save?.instance?.options?.scoreZoom;
  }

  static function set_scoreZoom(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.scoreZoom = value;
    save.flush();
    return value;
  }

  /**
   * If enabled, an FPS and memory counter will be displayed even if this is not a debug build.
   * @default `false`
   */
  public static var debugDisplay(get, set):Bool;

  static function get_debugDisplay():Bool
  {
    return Save?.instance?.options?.debugDisplay;
  }

  static function set_debugDisplay(value:Bool):Bool
  {
    if (value != Save.instance.options.debugDisplay)
    {
      toggleDebugDisplay(value);
    }

    var save:Save = Save.instance;
    save.options.debugDisplay = value;
    save.flush();
    return value;
  }

  /**
   * If enabled, the game will automatically pause when tabbing out.
   * @default `true`
   */
  public static var autoPause(get, set):Bool;

  static function get_autoPause():Bool
  {
    return Save?.instance?.options?.autoPause ?? true;
  }

  static function set_autoPause(value:Bool):Bool
  {
    if (value != Save.instance.options.autoPause) FlxG.autoPause = value;

    var save:Save = Save.instance;
    save.options.autoPause = value;
    save.flush();
    return value;
  }

  /**
   * If disabled, the score submission to GameJolt will be disabled.
   * Also disables trophies.
   * @default `true`
   */
  public static var scoreSub(get, set):Bool;

  static function get_scoreSub():Bool
  {
    return Save?.instance?.options?.scoreSub ?? true;
  }

  static function set_scoreSub(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.scoreSub = value;
    save.flush();
    return value;
  }

  /**
   * If we want the framerate to be unlocked on HTML5.
   * @default `false`
   */
  public static var unlockedFramerate(get, set):Bool;

  static function get_unlockedFramerate():Bool
  {
    return Save?.instance?.options?.unlockedFramerate;
  }

  static function set_unlockedFramerate(value:Bool):Bool
  {
    if (value != Save.instance.options.unlockedFramerate)
    {
      #if web
      toggleFramerateCap(value);
      #end
    }

    var save:Save = Save.instance;
    save.options.unlockedFramerate = value;
    save.flush();
    return value;
  }

  #if web
  // We create a haxe version of this just for readability.
  // We use these to override `window.requestAnimationFrame` in Javascript to uncap the framerate / "animation" request rate
  // Javascript is crazy since u can just do stuff like that lol

  public static function unlockedFramerateFunction(callback, element)
  {
    var currTime = Date.now().getTime();
    var timeToCall = 0;
    var id = js.Browser.window.setTimeout(function() {
      callback(currTime + timeToCall);
    }, timeToCall);
    return id;
  }

  // Lime already implements their own little framerate cap, so we can just use that
  // This also gets set in the init function in Main.hx, since we need to definitely override it
  public static var lockedFramerateFunction = untyped js.Syntax.code("window.requestAnimationFrame");
  #end

  /**
   * Loads the user's preferences from the save data and apply them.
   */
  public static function init():Void
  {
    // Apply the autoPause setting (enables automatic pausing on focus lost).
    FlxG.autoPause = Preferences.autoPause;
    // Apply the debugDisplay setting (enables the FPS and RAM display).
    toggleDebugDisplay(Preferences.debugDisplay);
    #if web
    toggleFramerateCap(Preferences.unlockedFramerate);
    #end
  }

  static function toggleFramerateCap(unlocked:Bool):Void
  {
    #if web
    var framerateFunction = unlocked ? unlockedFramerateFunction : lockedFramerateFunction;
    untyped js.Syntax.code("window.requestAnimationFrame = framerateFunction;");
    #end
  }

  static function toggleDebugDisplay(show:Bool):Void
  {
    if (show)
    {
      // Enable the debug display.
      FlxG.stage.addChild(Main.fpsCounter);
      #if !html5
      FlxG.stage.addChild(Main.memoryCounter);
      #end
    }
    else
    {
      // Disable the debug display.
      FlxG.stage.removeChild(Main.fpsCounter);
      #if !html5
      FlxG.stage.removeChild(Main.memoryCounter);
      #end
    }
  }

  /**
   * Stores the user's username here.
   * @default `''`
   */
  public static var savedUser(get, set):String;

  static function get_savedUser():String
  {
    return Save?.instance?.options?.savedUser;
  }

  static function set_savedUser(value:String):String
  {
    var save:Save = Save.instance;
    save.options.savedUser = value;
    save.flush();
    return value;
  }

  /**
   * Stores the user's token here.
   * @default `''`
   */
  public static var savedToken(get, set):String;

  static function get_savedToken():String
  {
    return Save?.instance?.options?.savedToken;
  }

  static function set_savedToken(value:String):String
  {
    var save:Save = Save.instance;
    save.options.savedToken = value;
    save.flush();
    return value;
  }

  //
  // GAMEPLAY MODIFIERS
  //
  // This is a preference. It should be here.

  /**
   * Whether or not the player should die if they do not hit a Sick! judgement.
   * @default `false`
   */
  public static var onlySick(get, set):Bool;

  static function get_onlySick():Bool
  {
    return Save?.instance?.gameplayModifiers?.onlySick;
  }

  static function set_onlySick(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.gameplayModifiers.onlySick = value;
    save.flush();
    return value;
  }
}
