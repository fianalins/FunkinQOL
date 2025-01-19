package funkin.api.gamejolt;

import haxe.Http;
#if FEATURE_GAMEJOLT
import hxgamejolt.GameJolt;
#end

/**
 * A helper class for the GameJolt API.
 * This is a wrapper around the GameJolt API, and is used to make it easier to use.
 */
class GameJoltHelper
{
  #if FEATURE_GAMEJOLT
  static var instance:GameJoltHelper;

  /**
   * The current username.
   */
  public var currentUser(default, null):Null<String> = null;

  /**
   * Whether the user is logged in.
   */
  public var isLoggedIn(get, never):Bool;

  static final API_PAGE:String = 'https://api.gamejolt.com/api/game';
  static final API_VERSION:String = 'v1_2';
  static final DATA_FORMAT:String = '?format=json';

  static var game_id:String;
  static var private_key:String;

  function new() {} // Haha so funny teehee

  // Instancing stuff
  public static function getInstance():GameJoltHelper
  {
    if (instance == null) instance = new GameJoltHelper();
    return instance;
  }

  /**
   * Initializes the GameJolt API
   * @param gameId The Game ID from the GameJolt dashboard and/or the page's URL
   * @param privateKey The private key from the GameJolt dashboard
   */
  public function init(gameId:String, privateKey:String):Void
  {
    game_id = gameId;
    private_key = privateKey;

    GameJolt.init(gameId, privateKey);

    // Try to auto-login with saved credentials
    if (Preferences.savedUser != '' && Preferences.savedToken != '')
    {
      login(Preferences.savedUser, Preferences.savedToken);
    }
  }

  #if html5
  function buildUrl(endpoint:String, params:String):String
  {
    var urlPage:String = '$API_PAGE/$API_VERSION/$endpoint/$DATA_FORMAT&game_id=$game_id$params';
    var signature:String = '&signature=' + haxe.crypto.Md5.encode(urlPage + private_key);
    return urlPage + signature;
  }

  function buildAuthUrl(username:String, token:String):String
  {
    // Following the original format:
    var urlPage:String = '$API_PAGE/$API_VERSION/users/auth/$DATA_FORMAT&game_id=$game_id&username=${StringTools.urlEncode(username)}&user_token=$token';
    var signature:String = '&signature=' + haxe.crypto.Md5.encode(urlPage + private_key);

    return urlPage + signature;
  }

  static function httpRequestWebSafe(url:String, post:Bool = false, ?onSuccess:Dynamic->Void, ?onError:String->Void):Void
  {
    var http = new Http(url);

    http.onStatus = function(status:Int) {
      // Skip redirect handling since it's causing issues on web
      if (status != 200)
      {
        if (onError != null) onError('HTTP Error: ${status}');
      }
    };

    http.onData = function(data:String) {
      try
      {
        var response = haxe.Json.parse(data).response;
        if (response.success == "true")
        {
          if (onSuccess != null) onSuccess(response);
        }
        else
        {
          if (onError != null) onError(response.message ?? "Unknown error");
        }
      }
      catch (e)
      {
        if (onError != null) onError('Parse error: ${e.message}');
      }
    };

    http.onError = function(msg:String) {
      if (onError != null) onError(msg);
    };

    #if js
    http.async = true;
    #end

    try
    {
      http.request(post);
    }
    catch (e)
    {
      if (onError != null) onError('Request error: ${e.message}');
    }
  }
  #end

  /**
   * Function to login to GameJolt
   * @param username The username to login with
   * @param token The token to login with
   * @param onComplete A callback function that is called when the login is complete
   */
  public function login(username:String, token:String, ?onComplete:Bool->Void):Void
  {
    #if html5
    var url = buildAuthUrl(username, token);
    httpRequestWebSafe(url, false, response -> {
      currentUser = username;
      if (onComplete != null) onComplete(true);
    }, error -> {
      currentUser = null;
      trace('[GJ] Login failed: ${error}');
      if (onComplete != null) onComplete(false);
    });
    #else
    GameJolt.authUser(username, token,
      {
        onSucceed: response -> {
          currentUser = username;
          trace('[GJ] Login successful');
          if (onComplete != null) onComplete(true);
        },
        onFail: error -> {
          currentUser = null;
          trace('[GJ] Login failed: $error');
          if (onComplete != null) onComplete(false);
        }
      });
    #end
  }

  /**
   * Function to logout from GameJolt
   */
  public function logout():Void
  {
    currentUser = null;
    Preferences.savedUser = '';
    Preferences.savedToken = '';
    trace('[GJ] Saving nothing to user. (Signing out)');
  }

  /**
   * Function to add a trophy to the user
   * @param trophyID The ID of the trophy to add
   * @param onComplete A callback function that is called when the trophy is added
   */
  public function addTrophy(trophyID:Int, ?onComplete:Bool->Void):Void
  {
    if (!isLoggedIn)
    {
      if (onComplete != null) onComplete(false);
      return;
    }

    #if html5
    var params = '&username=${StringTools.urlEncode(currentUser)}&user_token=${Preferences.savedToken}&trophy_id=$trophyID';
    var url = buildUrl('trophies/add', params);

    httpRequestWebSafe(url, false, response -> {
      trace('[GJ] Trophy unlocked successfully');
      if (onComplete != null) onComplete(true);
    }, error -> {
      trace('[GJ] Failed to unlock trophy: ${error}');
      if (onComplete != null) onComplete(false);
    });
    #else
    GameJolt.addTrophy(currentUser, Preferences.savedToken, trophyID,
      {
        onSucceed: response -> {
          trace('[GJ] Trophy unlocked successfully');
          if (onComplete != null) onComplete(true);
        },
        onFail: error -> {
          trace('[GJ] Failed to unlock trophy: $error');
          if (onComplete != null) onComplete(false);
        }
      });
    #end
  }

  /**
   * Function to add a score to the user
   * @param scoreText The string text of the score - this is what is displayed
   * @param scoreSort The sort number of the score - this is how it sorts
   * @param tableID The ID of the leaderboard table to add the score to
   * @param onComplete A callback function that is called when the score is added
   */
  public function addScore(scoreText:String, scoreSort:Int, ?tableID:Int, ?onComplete:Bool->Void):Void
  {
    if (!isLoggedIn)
    {
      if (onComplete != null) onComplete(false);
      return;
    }

    var urlEncodedString:String = StringTools.urlEncode(scoreText); // This should prevent HTTP 400 errors

    #if html5
    var params = '&username=${StringTools.urlEncode(currentUser)}&user_token=${Preferences.savedToken}'
      + '&score=$urlEncodedString&sort=$scoreSort'
      + (tableID != null ? '&table_id=$tableID' : '');

    var url = buildUrl('scores/add', params);

    httpRequestWebSafe(url, false, response -> {
      trace('[GJ] Score added successfully');
      if (onComplete != null) onComplete(true);
    }, error -> {
      trace('[GJ] Failed to add score: ${error}');
      if (onComplete != null) onComplete(false);
    });
    #else
    GameJolt.addScore(currentUser, Preferences.savedToken, null, urlEncodedString, scoreSort, null, tableID, {
      onSucceed: response -> {
        trace('[GJ] Score added successfully');
        if (onComplete != null) onComplete(true);
      },
      onFail: error -> {
        trace('[GJ] Failed to add score: $error');
        if (onComplete != null) onComplete(false);
      }
    });
    #end
  }

  function get_isLoggedIn():Bool
  {
    return currentUser != null;
  }
  #end
}
