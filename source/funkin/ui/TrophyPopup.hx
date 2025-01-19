package funkin.ui;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import funkin.audio.FunkinSound;

/**
 * A very cool class that makes a trophy popup.
 * This will make stuff easier for when we have trophies outside of GameJolt API as well.
 *
 * @author: @fianalins
 */
class TrophyPopup extends FlxSpriteGroup
{
  var background:FlxSprite;
  var icon:FlxSprite;
  var titleText:FlxText;
  var descText:FlxText;

  // There shouldn't be more than one trophy at a time anyways, but IDK I could add more that could possibly mean displaying multiple
  var trophyQueue:Array<{name:String, icon:String}> = [];
  var isDisplaying:Bool = false;

  public function new()
  {
    super();

    // Make this not move with camera. When testing in MainMenuState, it was also in the incorrect position.
    scrollFactor.set(0, 0);

    // Create slightly transparent black background
    background = new FlxSprite(0, 0);
    background.makeGraphic(340, 120, FlxColor.BLACK);
    background.alpha = 0.8;
    add(background);

    // Trophy icon placeholder (scales to 80x80)
    icon = new FlxSprite(20, 20);
    icon.loadGraphic(Paths.image('trophies/bigQuestion'));
    icon.setGraphicSize(80, 80);
    icon.updateHitbox();
    add(icon);

    // These texts could be instead Title of the trophy, and then a description of the trophy.
    // I don't feel like making descriptions, so Trophy Unlocked! is the main text, with the trophy name on GameJolt below.

    // "Trophy Unlocked!" text
    titleText = new FlxText(120, 35, 200, "Trophy Unlocked!", 20);
    titleText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    add(titleText);

    // Trophy name text
    descText = new FlxText(120, 0, 200, "", 16);
    descText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    // Position vertically relative to titleText
    descText.y = titleText.y + titleText.height + 8; // This should be centered, unless there is two lines
    add(descText);

    // Start offscreen
    this.x = -400;
    this.y = 20;
    this.visible = false;
  }

  /**
   * Queue a trophy to be displayed. This should be the function that is used in other classes.
   * @param name The name of the trophy. Should be what is shown on GameJolt. This will be the bottom line of text.
   * @param iconPath The path to the icon. This should be in the images folder, which is by default `preload/images/trophies/`.
   */
  public function queueTrophy(name:String, ?iconPath:String):Void
  {
    trophyQueue.push({name: name, icon: iconPath});
    if (!isDisplaying)
    {
      displayNextTrophy();
    }
  }

  function displayNextTrophy():Void
  {
    if (trophyQueue.length == 0)
    {
      isDisplaying = false;
      return;
    }

    isDisplaying = true;
    var trophy = trophyQueue.shift();
    showTrophy(trophy.name, trophy.icon);
  }

  /**
   * Show a trophy popup that slides in from the left, and then back out.
   * @param name The name of the trophy. Should be what is shown on GameJolt. This will be the bottom line of text.
   * @param iconPath The path to the icon. This should be in the images folder, which is by default `preload/images/trophies/`.
   */
  public function showTrophy(name:String, ?iconPath:String):Void
  {
    trace('[ACH] showTrophy function called. Name: $name, icon: $iconPath');

    // Set trophy name, the bottom text
    descText.text = name;

    // Load custom icon if provided, scaling to 80x80px no matter what
    // I don't know if the scaling is needed, but it's here just in case.
    if (iconPath != null)
    {
      icon.loadGraphic(Paths.image(iconPath));
      icon.setGraphicSize(80, 80);
      icon.updateHitbox();
    }

    // Reset position and make visible
    this.x = -400;
    this.visible = true;

    // Play sound effect (the perfect rank sfx)
    FunkinSound.playOnce(Paths.sound('perfect'), 2.0); // Increase volume to 2.0 (double volume)

    // Slide in animation
    FlxTween.tween(this, {x: 20}, 0.5,
      {
        ease: FlxEase.backOut,
        startDelay: 0.45, // The sound effect works better when this comes in on the Big Impact
        onComplete: function(_) {
          // Wait 3 seconds then slide out
          FlxTween.tween(this, {x: -400}, 0.5,
            {
              ease: FlxEase.backIn,
              startDelay: 3,
              onComplete: function(_) {
                this.visible = false;
                displayNextTrophy(); // Show next trophy in queue
              }
            });
        }
      });
  }
}
