package funkin.ui.login;

import funkin.audio.FunkinSound;
import funkin.ui.transition.LoadingState;
import funkin.ui.mainmenu.MainMenuState;
import funkin.input.Cursor;
import funkin.save.Save;
import haxe.ui.backend.flixel.UIState;
import haxe.ui.components.Button;
import haxe.ui.components.Label;
import haxe.ui.components.TextField;
import haxe.ui.events.UIEvent;
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.RuntimeComponentBuilder;
#if FEATURE_GAMEJOLT
import funkin.api.gamejolt.GameJoltHelper;
#end

/*
 * This, to login, is the login screen of logging into.
 */
@:build(haxe.ui.ComponentBuilder.build("assets/exclude/data/ui/login/main-view.xml"))
class LogInState extends UIState
{
  #if FEATURE_GAMEJOLT
  /**
   * The path to the layout for the login menu.
   */
  public static final LOGIN_MENU_FORM_LAYOUT:String = Paths.ui('login/login-view');

  //
  // The stuff that is needed for the login function.
  //

  /**
   * What we are going to shove into the GameJolt login as username
   */
  var newUsername:String = '';

  /**
   * What we are going to shove into the GameJolt login as token
   */
  var newToken:String = '';

  var loginText:Null<Label>;

  override function create():Void
  {
    super.create();

    // Show the mouse cursor.
    Cursor.show();

    openLoginDialog();
  }

  override function update(elapsed:Float):Void
  {
    super.update(elapsed);

    handleCursor(); // Handle the cursor sound effects.

    // Keybinds for people who are used to using these instead of button on screen.
    if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.Q)
    {
      quitLoginMenu();
    }
  }

  override function destroy():Void
  {
    super.destroy();

    // Hide the mouse cursor on other states.
    Cursor.hide();
  }

  function openLoginDialog():Void
  {
    var dialog:Null<Dialog> = openDialog(LOGIN_MENU_FORM_LAYOUT, true, false);
    if (dialog == null) throw 'Could not locate Login dialog';

    var loginCancel:Null<Button> = dialog.findComponent('loginCancel', Button);
    if (loginCancel == null) throw 'Could not locate loginCancel button in Login dialog';
    loginCancel.onClick = function(_) {
      quitLoginMenu();
    }

    var usernameInput:Null<TextField> = dialog.findComponent('usernameInput', TextField);
    if (usernameInput == null) throw 'Could not locate usernameInput TextField in Login dialog';
    usernameInput.onChange = function(event:UIEvent) {
      var valid:Bool = event.target.text != null && event.target.text != '';

      if (valid)
      {
        usernameInput.removeClass('invalid-value');
        newUsername = event.target.text;
      }
      else
      {
        newUsername = "";
      }
    };
    usernameInput.text = "";

    var tokenInput:Null<TextField> = dialog.findComponent('tokenInput', TextField);
    if (tokenInput == null) throw 'Could not locate tokenInput TextField in Login dialog';
    tokenInput.onChange = function(event:UIEvent) {
      var valid:Bool = event.target.text != null && event.target.text != '';

      if (valid)
      {
        tokenInput.removeClass('invalid-value');
        newToken = event.target.text;
      }
      else
      {
        newToken = "";
      }
    };
    tokenInput.text = "";

    // To let you know if you are an invalid person.
    // Don't want to add the little popup thing from Chart Editor because it would be time consuming and pointless.
    loginText = dialog.findComponent('loginText', Label);
    if (loginText == null) throw 'Could not locate loginText label in Login dialog';
    loginText.text = '';

    var loginYes:Null<Button> = dialog.findComponent('loginYes', Button);
    if (loginYes == null) throw 'Could not locate loginYes button in Login dialog';
    loginYes.onClick = function(_) {
      // Do your stuff GameJolt
      doLogIn(newUsername, newToken, loginText);
    }

    var loginOpposite:Null<Button> = dialog.findComponent('loginOpposite', Button);
    if (loginOpposite == null) throw 'Could not locate loginOpposite button in Login dialog';
    loginOpposite.onClick = function(_) {
      // Do your stuff GameJolt
      trace('[GJ] Attempting to sign out');
      GameJoltHelper.getInstance().logout();

      quitLoginMenu();
    }
  }

  /**
   * Builds and opens a dialog from a given layout path.
   * @param modal Makes the background uninteractable while the dialog is open.
   * @param closable Hides the close button on the dialog, preventing it from being closed unless the user interacts with the dialog.
   */
  static function openDialog(key:String, modal:Bool = true, closable:Bool = true):Null<Dialog>
  {
    var dialog:Null<Dialog> = cast RuntimeComponentBuilder.fromAsset(key);
    if (dialog == null) return null;

    dialog.destroyOnClose = true;
    dialog.closable = closable;
    dialog.showDialog(modal);

    dialog.onDialogClosed = function(event:UIEvent) {
      // If you close
      #if web
      LoadingState.transitionToState(() -> new MainMenuState());
      #else
      FlxG.switchState(() -> new MainMenuState());
      #end
    };

    dialog.zIndex = 1000;

    return dialog;
  }

  function handleCursor():Void
  {
    if (FlxG.mouse.justPressed) FunkinSound.playOnce(Paths.sound("chartingSounds/ClickDown"));
    if (FlxG.mouse.justReleased) FunkinSound.playOnce(Paths.sound("chartingSounds/ClickUp"));
  }

  function quitLoginMenu():Void
  {
    // Close the state.
    #if web
    LoadingState.transitionToState(() -> new MainMenuState());
    #else
    FlxG.switchState(() -> new MainMenuState());
    #end
  }

  function doLogIn(userInput:String = '', tokenInput:String = '', failText:Null<Label>):Void
  {
    trace('[GJ] Attempting to login under $userInput with token $tokenInput');

    // I have replaced the FlxGameJolt with GameJolt API by MAJigsaw77. Let's hope it works better.
    GameJoltHelper.getInstance().login(userInput, tokenInput, success -> {
      if (success)
      {
        Preferences.savedUser = userInput;
        Preferences.savedToken = tokenInput;
        trace('[GJ] Saving $userInput with token $tokenInput');
        quitLoginMenu();
      }
      else
      {
        if (failText != null) failText.text = 'Invalid username or token';
      }
    });
  }
  #end
}
