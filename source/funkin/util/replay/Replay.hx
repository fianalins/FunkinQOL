package funkin.util.replay;

#if sys
// i don't know any way to do this without having #if sys around literally everything that has to do with replays
// i'm sorry

/**
 * A class for recording input data from PlayState and saving it to a JSON file.
 */
class Replay
{
  /**
   * The folder where the replays are saved.
   * I hate the annoying `FieldDocComment checkstyle`
   */
  public static final REPLAY_FOLDER:String = 'replays';

  /**
   * Variables that get recorded.
   */
  public static var recordedInputs:Array<
    {
      songPosition:Float,
      noteDirection:Int,
      isPress:Bool
    }> = [];

  static var processedInputs:Array<Dynamic> = [];

  /**
   * Function to record an input. This is called from PlayState whenever a button is pressed or released.
   * @param songPosition The songPosition of the input formatted as a Float.
   * @param noteDirection The direction of the input. Between 0 and 3.
   * @param isPress Whether the input is a press or release.
   */
  public static function recordInput(songPosition:Float, noteDirection:Int, isPress:Bool):Void
  {
    trace('[REPLAY] Recorded input: {songPosition: $songPosition, noteDirection: $noteDirection, isPress: $isPress}');
    recordedInputs.push({songPosition: songPosition, noteDirection: noteDirection, isPress: isPress});
  }

  // stolen from ScreenshotPlugin
  public static function makeReplayPath():Void
  {
    FileUtil.createDirIfNotExists(REPLAY_FOLDER);
  }

  /**
   * Save the recorded inputs to a JSON file.
   * @param filename Name of the file to save to.
   */
  public static function saveReplay(filename:String):Void
  {
    makeReplayPath();

    // I don't really know about this `try` thing
    // But to stop it crashing because of Null Object Reference, ChatGPT said to use this
    // Now it just doesn't save if that happens :)
    try
    {
      trace('[REPLAY] Saving replay...');
      trace('[REPLAY] File path: $REPLAY_FOLDER/replay-$filename-${DateUtil.generateTimestamp()}.json');

      // This lags the game so badly when you have traces enabled.
      // It is so much to the point where I had files that had dates seconds apart from each other on their date
      // trace('[REPLAY] Recorded inputs: ' + recordedInputs);

      // Do the thing
      var writer = new json2object.JsonWriter<Array<{songPosition:Float, noteDirection:Int, isPress:Bool}>>();
      var output = writer.write(recordedInputs, '  ');

      // Save the file
      sys.io.File.saveContent('$REPLAY_FOLDER/replay-$filename-${DateUtil.generateTimestamp()}.json', output);
      trace('[REPLAY] Replay saved successfully.');
    }
    catch (e:Dynamic)
    {
      trace('[REPLAY] Error saving replay: ' + e);
    }
  }

  /**
   * Saves some metadata about the replay, mostly to help when replaying, or showing in the Replay Manager
   * @param filename Name of the file to save to
   * @param metadata Input the metadata
   */
  public static function saveReplayMetadata(filename:String, metadata:ReplayMetadata):Void
  {
    // saveReplay already should've done this, but just in case
    makeReplayPath();

    try
    {
      // Do the thing but medatada
      var writer = new json2object.JsonWriter<ReplayMetadata>();
      var output = writer.write(metadata, '  ');

      // Save the file but METADATA
      sys.io.File.saveContent('$REPLAY_FOLDER/replay-metadata-$filename-${DateUtil.generateTimestamp()}.json', output);
      trace('[REPLAY] Metadata saved successfully.');
    }
    catch (e:Dynamic)
    {
      trace('[REPLAY] Error saving replay metadata: ' + e);
    }
  }

  /**
   * Load the recorded inputs from a JSON file.
   * @param filename The file to load from.
   * @return Array
   */
  public static function loadReplay(filename:String):Array<{songPosition:Float, noteDirection:Int, isPress:Bool}>
  {
    var parser = new json2object.JsonParser<Array<{songPosition:Float, noteDirection:Int, isPress:Bool}>>();
    parser.ignoreUnknownVariables = false;

    var content = sys.io.File.getContent(filename);
    parser.fromJson(content, filename);

    if (parser.errors.length > 0)
    {
      for (error in parser.errors)
      {
        trace('[REPLAY] Error in replay JSON: ' + error);
      }
      return [];
    }

    recordedInputs = parser.value;
    // trace('[REPLAY] Loaded replay: ' + recordedInputs);

    trace('[REPLAY] Loaded replay: ' + filename);

    return recordedInputs;
  }

  /**
   * Load the recorded inputs from a JSON file.
   * @param filename The file to load from.
   * @return ReplayMetadata
   */
  public static function loadMetadata(filename:String):ReplayMetadata
  {
    var parser = new json2object.JsonParser<ReplayMetadata>();
    parser.ignoreUnknownVariables = false;

    var content = sys.io.File.getContent(filename);
    parser.fromJson(content, filename);

    if (parser.errors.length > 0)
    {
      for (error in parser.errors)
      {
        trace('[REPLAY] Error in metadata JSON: ' + error);
      }
      return null; // Idk man return null
    }

    var replayMetadata:ReplayMetadata = parser.value;
    // trace('[REPLAY] Loaded metadata: ' + replayMetadata);

    trace('[REPLAY] Loaded metadata: ' + filename);

    return replayMetadata;
  }

  /**
   * Get the next input based on songPosition.
   * @param currentSongPos What the current songPosition is.
   * @return Dynamic
   */
  public static function getNextInput(currentSongPos:Float):Dynamic
  {
    // Keep only the last 5000 milliseconds (5 seconds) of processed inputs
    // This probably will help with the lag I get from playing a replay. And memory issues.
    var cutoffTime:Float = currentSongPos - 5000;

    for (input in recordedInputs)
    {
      // We should skip if the input is in this list, or if it is too old
      if (processedInputs.indexOf(input) != -1 || input.songPosition < cutoffTime) continue;

      if (input.songPosition <= currentSongPos)
      {
        processedInputs.push(input); // Make it process to a list so we don't send it multiple times. songPosition is not that precise
        // trace('[REPLAY] Processing input: $input');

        // Remove older inputs.
        processedInputs = processedInputs.filter(input -> input.songPosition > cutoffTime);
        return input;
      }
    }
    return null; // No more inputs
  }

  /**
   * Reset the processed inputs.
   * This seems kind of redundant
   */
  public static function reset():Void
  {
    recordedInputs = [];
    processedInputs = [];
  }
}

/**
 * Metadata format for a replay
 */
typedef ReplayMetadata =
{
  prettySongName:String,
  prettyDifficulty:String,
  prettyVariation:String,
  prettyDate:String,
  targetSongID:String,
  targetDifficulty:String,
  targetVariation:String,
  targetInstrumental:String,
  targetLevelId:String,
  targetFile:String,
  playerPreferences:
  {
    isDownscroll:Bool, isMiddlescroll:Bool, showOppStrums:Bool, isGhostTap:Bool, isJudgeCounter:Bool, isZoomCamera:Bool, isScoreZoom:Bool, whatUIAlpha:Int,
    whatTimeBar:String, whatHealthColors:String, whatInputOffset:Int, whatAudioVisualOffset:Int
  },
  targetData:
  {
    finalScore:Int, finalRank:String, finalAccuracy:Float, finalTallies:
    {
      finalSick:Int, finalGood:Int, finalBad:Int, finalShit:Int, finalMissed:Int, finalCombo:Int, finalMaxCombo:Int, finalTotalNotes:Int, finalTotalNotesHit:Int
    }
  },
  generatedBy:String
}
#end
