package funkin.util;

import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.math.FlxMath;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class BarUtil extends FlxSpriteGroup
{
  /*
   * The left side of the bar
   */
  public var leftSideBar:FlxSprite;

  /*
   * The right side of the bar
   */
  public var rightSideBar:FlxSprite;

  /*
   * The back of the bar, as an image defined by what you pass in
   */
  public var backBar:FlxSprite;

  /*
   * An optional function for the value of the bar
   */
  public var valueFunc:Void->Float = null;

  /*
   * The percent value of the bar
   */
  public var percent(default, set):Float = 0;

  /*
   * The bounds of the bar
   */
  public var boundingPos:Dynamic = {min: 0, max: 1};

  /*
   * Whether or not the bar changes from left to right or not
   */
  public var leftToRight(default, set):Bool = true;

  /*
   * The center of the bar
   */
  public var barCenter(default, null):Float = 0;

  /*
   * The width of the bar
   */
  public var barWidth(default, set):Int = 1;

  /*
   * The height of the bar
   */
  public var barHeight(default, set):Int = 1;

  /*
   * The offset of the bar to the back bar image
   */
  public var barOffset:FlxPoint = new FlxPoint(4, 4);

  /*
   * Whether or not the bar is enabled or not...
   */
  public var enabled:Bool = true;

  public function new(x:Float, y:Float, image:String = 'healthBar', ?valueFunc:Void->Float, boundingX:Float = 0, boundingY:Float = 1)
  {
    super(x, y);

    this.valueFunc = valueFunc;
    setBounds(boundingX, boundingY);

    backBar = new FlxSprite().loadGraphic(Paths.image(image));
    barWidth = Std.int(backBar.width - 6);
    barHeight = Std.int(backBar.height - 6);

    leftSideBar = new FlxSprite().makeGraphic(Std.int(backBar.width), Std.int(backBar.height), FlxColor.WHITE);
    // leftSideBar.color = FlxColor.WHITE;

    rightSideBar = new FlxSprite().makeGraphic(Std.int(backBar.width), Std.int(backBar.height), FlxColor.WHITE);
    rightSideBar.color = FlxColor.BLACK;

    add(leftSideBar);
    add(rightSideBar);
    add(backBar);
    reloadClips();
  }

  override function update(elapsed:Float):Void
  {
    if (!enabled)
    {
      super.update(elapsed);
      return;
    }

    if (valueFunc != null)
    {
      var value:Null<Float> = FlxMath.remapToRange(FlxMath.bound(valueFunc(), boundingPos.min, boundingPos.max), boundingPos.min, boundingPos.max, 0, 100);
      percent = (value != null ? value : 0);
    }
    else
      percent = 0;
    super.update(elapsed);
  }

  public function setBounds(min:Float, max:Float)
  {
    boundingPos.min = min;
    boundingPos.max = max;
  }

  public function setColors(left:FlxColor = null, right:FlxColor = null)
  {
    if (left != null) leftSideBar.color = left;
    if (right != null) rightSideBar.color = right;
  }

  public function updateBar()
  {
    if (leftSideBar == null || rightSideBar == null) return;

    leftSideBar.setPosition(backBar.x, backBar.y);
    rightSideBar.setPosition(backBar.x, backBar.y);

    var leftSize:Float = 0;
    if (leftToRight) leftSize = FlxMath.lerp(0, barWidth, percent / 100);
    else
      leftSize = FlxMath.lerp(0, barWidth, 1 - percent / 100);

    leftSideBar.clipRect.width = leftSize;
    leftSideBar.clipRect.height = barHeight;
    leftSideBar.clipRect.x = barOffset.x;
    leftSideBar.clipRect.y = barOffset.y;

    rightSideBar.clipRect.width = barWidth - leftSize;
    rightSideBar.clipRect.height = barHeight;
    rightSideBar.clipRect.x = barOffset.x + leftSize;
    rightSideBar.clipRect.y = barOffset.y;

    barCenter = leftSideBar.x + leftSize + barOffset.x;

    leftSideBar.clipRect = leftSideBar.clipRect;
    rightSideBar.clipRect = rightSideBar.clipRect;
  }

  public function reloadClips()
  {
    if (leftSideBar != null)
    {
      leftSideBar.setGraphicSize(Std.int(backBar.width), Std.int(backBar.height));
      leftSideBar.updateHitbox();
      leftSideBar.clipRect = new FlxRect(0, 0, Std.int(backBar.width), Std.int(backBar.height));
    }
    if (rightSideBar != null)
    {
      rightSideBar.setGraphicSize(Std.int(backBar.width), Std.int(backBar.height));
      rightSideBar.updateHitbox();
      rightSideBar.clipRect = new FlxRect(0, 0, Std.int(backBar.width), Std.int(backBar.height));
    }
    updateBar();
  }

  private function set_percent(value:Float)
  {
    var doUpdate:Bool = false;
    if (value != percent) doUpdate = true;
    percent = value;

    if (doUpdate) updateBar();
    return value;
  }

  private function set_leftToRight(value:Bool)
  {
    leftToRight = value;
    updateBar();
    return value;
  }

  private function set_barWidth(value:Int)
  {
    barWidth = value;
    reloadClips();
    return value;
  }

  private function set_barHeight(value:Int)
  {
    barHeight = value;
    reloadClips();
    return value;
  }
}
