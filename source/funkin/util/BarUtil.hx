package funkin.util;

import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.math.FlxMath;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class BarUtil extends FlxSpriteGroup
{
  public var leftSide:FlxSprite;
  public var rightSide:FlxSprite;
  public var backBar:FlxSprite;

  public var valueFunc:Void->Float = null;
  public var percent(default, set):Float = 0;
  public var boundingPos:Dynamic = {min: 0, max: 1};

  public var leftToRight(default, set):Bool = true;
  public var barCenter(default, null):Float = 0;

  public var barWidth(default, set):Int = 1;
  public var barHeight(default, set):Int = 1;
  public var barOffset:FlxPoint = new FlxPoint(4, 4);

  public function new(x:Float, y:Float, img:String, ?valueFunc:Void->Float, boundingX:Float = 0, boundingY:Float = 1)
  {
    super(x, y);

    this.valueFunc = valueFunc;
    setBounds(boundingX, boundingY);

    backBar = new FlxSprite().loadGraphic(Paths.image(img));
    backBar.antialiasing = true;
    barWidth = Std.int(backBar.width - 8);
    barHeight = Std.int(backBar.height - 8);

    leftSide = new FlxSprite().makeGraphic(Std.int(backBar.width), Std.int(backBar.height), FlxColor.WHITE);
    leftSide.antialiasing = true;

    rightSide = new FlxSprite().makeGraphic(Std.int(backBar.width), Std.int(backBar.height), FlxColor.WHITE);
    rightSide.antialiasing = true;

    add(leftSide);
    add(rightSide);
    add(backBar);
    reloadClips();
  }

  public var enabled:Bool = true;

  override function update(elapsed:Float)
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
    {
      percent = 0;
    }

    super.update(elapsed);
  }

  public function setBounds(min:Float, max:Float)
  {
    boundingPos.min = min;
    boundingPos.max = max;
  }

  public function setColors(left:FlxColor = null, right:FlxColor = null)
  {
    if (left != null) leftSide.color = left;
    if (right != null) rightSide.color = right;
  }

  public function updateBar()
  {
    if (leftSide == null || rightSide == null) return;

    leftSide.setPosition(backBar.x, backBar.y);
    rightSide.setPosition(backBar.x, backBar.y);

    var leftSize:Float = 0;
    if (leftToRight) leftSize = FlxMath.lerp(0, barWidth, percent / 100);
    else
      leftSize = FlxMath.lerp(0, barWidth, 1 - percent / 100);

    leftSide.clipRect.width = leftSize;
    leftSide.clipRect.height = barHeight;
    leftSide.clipRect.x = barOffset.x;
    leftSide.clipRect.y = barOffset.y;

    rightSide.clipRect.width = barWidth - leftSize;
    rightSide.clipRect.height = barHeight;
    rightSide.clipRect.x = barOffset.x + leftSize;
    rightSide.clipRect.y = barOffset.y;

    barCenter = leftSide.x + leftSize + barOffset.x;

    leftSide.clipRect = leftSide.clipRect;
    rightSide.clipRect = rightSide.clipRect;
  }

  public function reloadClips()
  {
    if (leftSide != null)
    {
      leftSide.setGraphicSize(Std.int(backBar.width), Std.int(backBar.height));
      leftSide.updateHitbox();
      leftSide.clipRect = new FlxRect(0, 0, Std.int(backBar.width), Std.int(backBar.height));
    }
    if (rightSide != null)
    {
      rightSide.setGraphicSize(Std.int(backBar.width), Std.int(backBar.height));
      rightSide.updateHitbox();
      rightSide.clipRect = new FlxRect(0, 0, Std.int(backBar.width), Std.int(backBar.height));
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
