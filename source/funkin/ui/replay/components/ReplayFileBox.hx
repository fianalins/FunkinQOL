package funkin.ui.replay.components;

import haxe.ui.containers.VBox;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.Events;

/**
 * Class for the box that appears for each replay file.
 */
@:build(haxe.ui.ComponentBuilder.build("assets/exclude/data/ui/replay/components/replayfilebox.xml"))
@:composite(ReplayFileBoxEvents)
class ReplayFileBox extends VBox
{
  /**
   * The metadata file name for when switching between selected replays
   * Also shown in the tooltip
   */
  public var replayMetadataFile(default, null):String;

  /**
   * The song name that displays on the little box
   * It says "SongName" but also includes variation, ex. Cocoa *Erect*, Pico *(Pico Mix)*, Darnell *(BF Mix)*
   * After the song name, the difficulty will be displayed in square brackets, ex. [Hard], [Nightmare], [Easy]
   */
  public var replaySongName(default, null):String;

  /**
   * The date that appears (smaller) underneath the song name
   * Helps distinguish between duplicate song replays, and I don't know what else I could add here
   */
  public var replayDate(default, null):String;

  /**
   * Whether or not THIS replay is currently selected
   */
  public var isSelected(default, null):Bool = false;

  /**
   * Which instance is currently selected.
   */
  public static var selectedInstance(default, null):ReplayFileBox = null;

  /**
   * All other instances of this class. Other file boxes are added to this.
   * This is to keep track of what is selected and what isn't.
   */
  public static var allInstances:Array<ReplayFileBox> = [];

  public function new(replayMetadataFile:String, replaySongName:String, replayDate:String)
  {
    super();

    this.replayMetadataFile = replayMetadataFile;
    this.replaySongName = replaySongName;
    this.replayDate = replayDate;

    this.tooltip = replayMetadataFile;
    this.replayBoxName.value = replaySongName;
    this.replayBoxDate.value = replayDate;

    // Make sure this is added to the list
    allInstances.push(this);
  }

  /**
   * Easy way of deselecting this file box.
   */
  public function deselect():Void
  {
    removeClass(":select", true, true);
    isSelected = false;
  }

  /**
   * Easy way of selecting this file box.
   */
  public function select(instance:ReplayFileBox):Void
  {
    addClass(":select", true, true);
    isSelected = true;
    selectedInstance = instance;
  }

  /**
   * Get the filename of the currently selected replay instance.
   * @return String
   */
  public static function getSelectedInstance():String
  {
    if (selectedInstance != null)
    {
      return selectedInstance.replayMetadataFile;
    }
    else
    {
      return null;
    }
  }

  override public function destroy():Void
  {
    allInstances.remove(this);
    if (selectedInstance == this)
    {
      selectedInstance = null;
    }
    super.destroy();
  }
}

/**
 * Composite class for handling mouse events
 */
class ReplayFileBoxEvents extends Events
{
  var _replayFileBox:ReplayFileBox;

  public function new(replayFileBox:ReplayFileBox)
  {
    super(replayFileBox);
    _replayFileBox = replayFileBox;
  }

  public override function register():Void
  {
    if (!hasEvent(MouseEvent.MOUSE_OVER, onMouseOver))
    {
      registerEvent(MouseEvent.MOUSE_OVER, onMouseOver);
    }
    if (!hasEvent(MouseEvent.MOUSE_OUT, onMouseOut))
    {
      registerEvent(MouseEvent.MOUSE_OUT, onMouseOut);
    }
    if (!hasEvent(MouseEvent.CLICK, onClick))
    {
      registerEvent(MouseEvent.CLICK, onClick);
    }
  }

  public override function unregister():Void
  {
    unregisterEvent(MouseEvent.MOUSE_OVER, onMouseOver);
    unregisterEvent(MouseEvent.MOUSE_OUT, onMouseOut);
    unregisterEvent(MouseEvent.CLICK, onClick);
  }

  function onMouseOver(event:MouseEvent):Void
  {
    _replayFileBox.addClass(":hover", true, true);
  }

  function onMouseOut(event:MouseEvent):Void
  {
    _replayFileBox.removeClass(":hover", true, true);
  }

  function onClick(event:MouseEvent):Void
  {
    for (instance in ReplayFileBox.allInstances)
    {
      if (instance != _replayFileBox)
      {
        instance.deselect();
      }
    }

    if (!_replayFileBox.isSelected)
    {
      _replayFileBox.select(_replayFileBox);
    }
  }
}
