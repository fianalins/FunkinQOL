package funkin.ui.replay;

#if sys
import haxe.ui.backend.flixel.UIState;
import haxe.ui.RuntimeComponentBuilder;
import haxe.ui.events.UIEvent;
import haxe.ui.components.Button;
import haxe.ui.components.DropDown;
import haxe.ui.components.TextField;
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.containers.dialogs.MessageBox.MessageBoxType;
import haxe.ui.containers.menus.MenuCheckBox;
import haxe.ui.containers.menus.MenuItem;
import flixel.util.FlxStringUtil;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import funkin.data.song.SongRegistry;
import funkin.play.song.Song;
import funkin.ui.replay.components.ReplayFileBox;
import funkin.ui.mainmenu.MainMenuState;
import funkin.ui.transition.LoadingState;
import funkin.input.Cursor;
import funkin.audio.FunkinSound;
import funkin.graphics.FunkinCamera;
import funkin.util.replay.Replay;
import funkin.util.FileUtil;
import funkin.save.Save;
import sys.FileSystem;

/**
 * A replay manager for loading replays and possibly deleteing them if you so choose
 */
@:build(haxe.ui.ComponentBuilder.build("assets/exclude/data/ui/replay/main-view.xml"))
class ReplayManagerState extends UIState
{
  var replayList:Array<ReplayFileBox>;
  var cachedMetadata:Map<String, ReplayMetadata>;

  var theCamera:FunkinCamera;

  // Stuff for searching and sorting
  var searchDebounceTimer:Float = 0; // So we don't filter through every time the user types
  var currentSearchTerm:String = ''; // We should start with empty search
  var pendingSearchTerm:String = '';
  var currentSortType:String = 'nameAZ'; // Default sort

  /**
   * The filename of the currently selected replay. Will be null if no replay is selected.
   * ex: `replays/replay-metadata-test.json`
   * The filename will always start with `replays/` and will be the metadata file of the replay.
   * The actual replay file will be under `targetFile` in the metadata.
   */
  var selectedInstanceFilename:String;

  /**
   * The `File -> Open Replays Folder` menu item.
   */
  var menubarItemReplayFolder:MenuItem;

  /**
   * The `File -> Reload Replays List` menu item.
   */
  var menubarItemReloadReplays:MenuItem;

  /**
   * The `File -> Save Replays` menu item.
   */
  var menubarItemSaveReplays:MenuCheckBox;

  /**
   * The `File -> Quit` menu item.
   */
  var menubarItemQuit:MenuItem;

  /**
   * The `Edit -> Delete` menu item.
   */
  var menubarItemDelete:MenuItem;

  /**
   * The `Help -> User Guide` menu item.
   */
  var menubarItemUserGuide:MenuItem;

  /**
   * The `Help -> About...` menu item.
   */
  var menubarItemAbout:MenuItem;

  /**
   * The path to the layout for the user guide dialog.
   */
  public static final USER_GUIDE_LAYOUT:String = Paths.ui('replay/dialogs/user-guide');

  /**
   * The path to the layout for the about dialog.
   * I moved this to preload stuff because why is it not here in the first place.
   */
  public static final ABOUT_LAYOUT:String = Paths.ui('replay/dialogs/about');

  /**
   * The path to the layout for the delete confirmation dialog.
   */
  public static final DELETE_LAYOUT:String = Paths.ui('replay/dialogs/delete-confirm');

  /**
   * Set by the dialog open function, used to prevent background interaction while the dialog is open.
   * All of this is quite obviously stolen from the Chart Editor.
   */
  var isHaxeUIDialogOpen:Bool = false;

  override function create():Void
  {
    super.create();

    Cursor.show();

    replayList = [];
    cachedMetadata = new Map();
    reloadReplays();
    reloadInformation(null);

    // File
    menubarItemReplayFolder.onClick = _ -> {
      // If you don't have any replays, then that means no folder. Unless you deleted them all or made the folder manually?
      Replay.makeReplayPath();

      FileUtil.openFolder(Replay.REPLAY_FOLDER);
    }

    menubarItemReloadReplays.onClick = _ -> {
      trace('[REPLAY] (Menubar) Reloading Replays list...');
      reloadReplays();
    }

    menubarItemSaveReplays.onChange = event -> {
      trace('[REPLAY] Setting Save Replays option to ${event.value}');
      Save.instance.replayManagerSaveReplays = event.value;
    };
    menubarItemSaveReplays.selected = Save.instance.replayManagerSaveReplays;

    menubarItemQuit.onClick = _ -> {
      trace('[REPLAY] (Menubar) Quitting Manager');
      quitReplayManager();
    }

    // Edit
    menubarItemDelete.onClick = _ -> {
      if (selectedInstanceFilename != null)
      {
        trace('[REPLAY] (Menubar) Opening delete confirmation dialog for $selectedInstanceFilename...');
        openDeleteDialog();
      }
      else
      {
        trace('[REPLAY] (Menubar) No replay selected. Cannot delete.');
      }
    }

    // Help
    menubarItemUserGuide.onClick = _ -> {
      openDialog(USER_GUIDE_LAYOUT, true, true);
      trace('[REPLAY] Opened User Guide from Menubar');
    }

    menubarItemAbout.onClick = _ -> {
      openDialog(ABOUT_LAYOUT, true, true);
      trace('[REPLAY] Opened About');
    }

    // Additional UI Stuff
    var replayButtonStart:Null<Button> = this.replayButtonStart;
    if (replayButtonStart == null) throw 'Could not locate replayButtonStart button in Replay Manager state';
    replayButtonStart.onClick = function(_) {
      if (selectedInstanceFilename != null)
      {
        trace('[REPLAY] Attempting to load into PlayState with selected replay $selectedInstanceFilename...');

        // If you deleted the replay file manually, then you suck
        // you are D-O-N-E fucked
        startReplay(selectedInstanceFilename);
      }
      else
      {
        trace('[REPLAY] No replay selected. Cannot proceed into PlayState.');
      }
    }

    var replayButtonDelete:Null<Button> = this.replayButtonDelete;
    if (replayButtonDelete == null) throw 'Could not locate replayButtonDelete button in Replay Manager state';
    replayButtonDelete.onClick = function(_) {
      if (selectedInstanceFilename != null)
      {
        trace('[REPLAY] (Button) Opening delete confirmation dialog for $selectedInstanceFilename...');
        openDeleteDialog();
      }
      else
      {
        trace('[REPLAY] (Button) No replay selected. Cannot delete.');
      }
    }

    // The Search and Sort
    var replaySearchBar:Null<TextField> = this.replaySearchBar;
    if (replaySearchBar == null) throw 'Could not locate replaySearchBar in Replay Manager state';
    replaySearchBar.onChange = function(event:UIEvent) {
      pendingSearchTerm = event.target.text;
      trace('[REPLAY] (Search) Search term changed to: $pendingSearchTerm');
    }

    // Initialize sort dropdown
    var replaySortDropdown:Null<DropDown> = this.replaySortDropdown;
    if (replaySortDropdown == null) throw 'Could not locate replaySortDropdown in Replay Manager state';
    replaySortDropdown.onChange = function(event:UIEvent) {
      if (event.data?.id == null) return;
      currentSortType = event.data.id;
      applyFiltersAndSort();
    }

    theCamera = new FunkinCamera('rmCam');
    FlxG.cameras.reset(theCamera);
  }

  override function update(elapsed:Float):Void
  {
    super.update(elapsed);

    if (searchDebounceTimer > 0)
    {
      searchDebounceTimer -= elapsed;
    }
    else if (replaySearchBar.text != currentSearchTerm)
    {
      searchDebounceTimer = 0.2; // Wait .2 seconds before searching
      currentSearchTerm = pendingSearchTerm;

      applyFiltersAndSort();
    }

    handleCursor();
    handleKeybinds();
  }

  override function destroy():Void
  {
    super.destroy();

    // Hide the mouse cursor on other states.
    Cursor.hide();
  }

  /**
   * Builds and opens a dialog from a given layout path.
   * @param modal Makes the background uninteractable while the dialog is open.
   * @param closable Hides the close button on the dialog, preventing it from being closed unless the user interacts with the dialog.
   */
  function openDialog(key:String, modal:Bool = true, closable:Bool = true):Null<Dialog>
  {
    var dialog:Null<Dialog> = cast RuntimeComponentBuilder.fromAsset(key);
    if (dialog == null) return null;

    dialog.destroyOnClose = true;
    dialog.closable = closable;
    dialog.showDialog(modal);

    isHaxeUIDialogOpen = true;
    dialog.onDialogClosed = function(event:UIEvent) {
      isHaxeUIDialogOpen = false;
    };

    dialog.zIndex = 1000;

    return dialog;
  }

  function openDeleteDialog():Void
  {
    Dialogs.messageBox("This will permanantly delete this replay.\n\nAre you sure? This cannot be undone.", "Delete Replay", MessageBoxType.TYPE_YESNO, true,
      function(btn:DialogButton) {
        if (btn == DialogButton.YES)
        {
          trace('[REPLAY] Attempting to delete the selected replay $selectedInstanceFilename...');
          deleteReplay(selectedInstanceFilename);
        }
      });
  }

  function handleCursor():Void
  {
    if (FlxG.mouse.justPressed) FunkinSound.playOnce(Paths.sound("chartingSounds/ClickDown"));
    if (FlxG.mouse.justReleased) FunkinSound.playOnce(Paths.sound("chartingSounds/ClickUp"));
  }

  function handleKeybinds():Void
  {
    // CTRL + R = Reload Replays List
    if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.R && !isHaxeUIDialogOpen)
    {
      trace('[REPLAY] (Keybind) Reloading Replays list...');
      reloadReplays();
    }

    // Delete = Delete Selected File
    if (FlxG.keys.justPressed.DELETE && !isHaxeUIDialogOpen)
    {
      if (selectedInstanceFilename != null)
      {
        trace('[REPLAY] (Keybind) Opening delete confirmation dialog for $selectedInstanceFilename...');
        openDeleteDialog();
      }
      else
      {
        trace('[REPLAY] (Keybind) No replay selected. Cannot delete.');
      }
    }

    // F1 = Open Help/User Guide
    if (FlxG.keys.justPressed.F1 && !isHaxeUIDialogOpen)
    {
      openDialog(USER_GUIDE_LAYOUT, true, true);
      trace('[REPLAY] Opened User Guide from Keybind');
    }

    // CTRL + Q = Quit
    if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.Q)
    {
      trace('[REPLAY] (Keybind) Quitting Manager');
      quitReplayManager();
    }
  }

  // Not stolen from wherever it was stolen from in the login menu
  function quitReplayManager():Void
  {
    // Close the state.
    #if web
    LoadingState.transitionToState(() -> new MainMenuState());
    #else
    FlxG.switchState(() -> new MainMenuState());
    #end
  }

  // These were going to be seperate but idk how you would then apply both filter and sort
  function applyFiltersAndSort():Void
  {
    // Get all replay files
    var replayFiles:Array<String> = FileSystem.readDirectory(Replay.REPLAY_FOLDER).filter(file -> StringTools.startsWith(file, 'replay-metadata'));

    // Apply search filter if there's a search term
    if (currentSearchTerm != null && currentSearchTerm.length > 0)
    {
      replayFiles = replayFiles.filter(file -> {
        var filePath:String = Replay.REPLAY_FOLDER + '/' + file;
        var metadata:ReplayMetadata = cachedMetadata.get(filePath);
        return metadata != null && metadata.prettySongName.toLowerCase().indexOf(currentSearchTerm.toLowerCase()) != -1;
      });
    }

    // Apply sorting
    switch (currentSortType)
    {
      case 'nameAZ':
        replayFiles.sort((a, b) -> {
          var metaA:ReplayMetadata = cachedMetadata.get(Replay.REPLAY_FOLDER + '/' + a);
          var metaB:ReplayMetadata = cachedMetadata.get(Replay.REPLAY_FOLDER + '/' + b);
          return metaA.prettySongName > metaB.prettySongName ? 1 : -1;
        });
      case 'nameZA':
        replayFiles.sort((a, b) -> {
          var metaA:ReplayMetadata = cachedMetadata.get(Replay.REPLAY_FOLDER + '/' + a);
          var metaB:ReplayMetadata = cachedMetadata.get(Replay.REPLAY_FOLDER + '/' + b);
          return metaA.prettySongName < metaB.prettySongName ? 1 : -1;
        });
      case 'dateNewest':
        replayFiles.sort((a, b) -> {
          var metaA:ReplayMetadata = cachedMetadata.get(Replay.REPLAY_FOLDER + '/' + a);
          var metaB:ReplayMetadata = cachedMetadata.get(Replay.REPLAY_FOLDER + '/' + b);
          return metaA.prettyDate < metaB.prettyDate ? 1 : -1;
        });
      case 'dateOldest':
        replayFiles.sort((a, b) -> {
          var metaA:ReplayMetadata = cachedMetadata.get(Replay.REPLAY_FOLDER + '/' + a);
          var metaB:ReplayMetadata = cachedMetadata.get(Replay.REPLAY_FOLDER + '/' + b);
          return metaA.prettyDate > metaB.prettyDate ? 1 : -1;
        });
    }

    // Update visibility and order of existing boxes
    var visibleCount:Int = 0;
    for (box in replayList)
    {
      var shouldShow:Bool = replayFiles.contains(box.replayMetadataFile.split('/').pop());
      box.visible = shouldShow;
      if (shouldShow) visibleCount++;
    }

    // Reorder visible boxes based on the sorted files
    var index:Int = 0;
    for (file in replayFiles)
    {
      for (box in replayList)
      {
        if (box.replayMetadataFile.split('/').pop() == file && box.visible)
        {
          replayListBox.setComponentIndex(box, index);
          index++;
          break;
        }
      }
    }

    // Update scrollview content height
    // Each box is 55px tall. Is there a way to get the height from the xml?
    // There is also a 5px gap between each box
    var boxHeight:Float = 55;
    var boxSpacing:Float = 5;
    replayListBox.height = (visibleCount * boxHeight) + ((visibleCount - 1) * boxSpacing);
  }

  function reloadReplays():Void
  {
    // Clear existing from the list.
    while (replayList.length > 0)
    {
      replayList[0].parentComponent.removeComponent(replayList[0]);
      replayList.shift();
    }

    // When reloading the replay list, we should deselect the replay and clear the cached metadatas
    // It would be confusing to have it still selected, especially since it removes the `selected` class
    // Also, if we are reloading after deleting a file, pressing play would try and load a file that doesn't exist
    cachedMetadata.clear();

    selectedInstanceFilename = null;
    reloadInformation(null);

    // Clear search and reset sort
    // Should we keep the search and sort the same?
    if (replaySearchBar != null)
    {
      replaySearchBar.text = '';
      replaySearchBar.value = '';
      replaySearchBar.focus = false;
    }
    if (replaySortDropdown != null) replaySortDropdown.selectedIndex = 0;
    currentSearchTerm = '';
    currentSortType = 'nameAZ';

    // Get replay metadata files from the `replays` directory.
    // Also check if the file starts with `replay-metadata`
    // We only read the metadata file here. Also do not change the filename please.
    var replayFiles:Array<String> = FileSystem.readDirectory(Replay.REPLAY_FOLDER).filter(file -> StringTools.startsWith(file, 'replay-metadata'));

    // Get the files and cache them
    for (file in replayFiles)
    {
      var replayFilePath:String = Replay.REPLAY_FOLDER + '/' + file;

      trace('[REPLAY] Filename detected: $file');

      try
      {
        // Try to load the metadata file.
        var metadata:ReplayMetadata = Replay.loadMetadata(replayFilePath);
        trace('[REPLAY] Loaded metadata from filename: ' + replayFilePath);

        cachedMetadata.set(replayFilePath, metadata);
      }
      catch (e:haxe.Exception)
      {
        trace('[REPLAY] Error loading replay metadata: ' + e);
      }
    }

    // Apply default sort (A-Z) and add to list
    replayFiles.sort((a, b) -> {
      var metaA:ReplayMetadata = cachedMetadata.get(Replay.REPLAY_FOLDER + '/' + a);
      var metaB:ReplayMetadata = cachedMetadata.get(Replay.REPLAY_FOLDER + '/' + b);
      return metaA.prettySongName > metaB.prettySongName ? 1 : -1;
    });

    // Now we can add the files to the list
    for (file in replayFiles)
    {
      var replayFilePath:String = Replay.REPLAY_FOLDER + '/' + file;
      var metadata:ReplayMetadata = cachedMetadata.get(replayFilePath);
      addReplayFile(replayFilePath, '${metadata.prettySongName} [${metadata.prettyDifficulty}]', metadata.prettyDate);
    }
  }

  function reloadInformation(filename:String):Void
  {
    var metadata:Null<ReplayMetadata> = filename != null ? cachedMetadata.get(filename) : null;

    // Set the text of a Label
    function setText(field:Null<haxe.ui.components.Label>, value:String):Void
    {
      if (field != null) field.text = value;
    }

    if (metadata == null)
    {
      // If this is null, we should go back to defaults/unselected
      setText(replayInfoSong, 'Song Name: No replay selected');
      setText(replayInfoDifficulty, 'Song Difficulty: No replay selected');
      setText(replayInfoVariation, 'Song Variation: N/A');
      setText(replayInfoDate, 'Save Date: 1970-01-01 00:00:00');
      setText(replayInfoScore, 'Score: 0');
      setText(replayInfoAccuracy, 'Accuracy: 0%');
      setText(replayInfoRank, 'Rank: Fail');
      setText(replayInfoSick, 'Sicks: 0');
      setText(replayInfoGood, 'Goods: 0');
      setText(replayInfoBad, 'Bads: 0');
      setText(replayInfoShit, 'Shits: 0');
      setText(replayInfoMissed, 'Misses: 0');
      setText(replayInfoCombo, 'Combo: 0');
      setText(replayInfoMaxCombo, 'Max Combo: 0');
      setText(replayInfoTotalNotesHit, 'Total Notes Hit: 0');
      return;
    }

    // Update fields with metadata
    var data = metadata.targetData;
    var tallies = data.finalTallies;

    // Now time to update every single field
    setText(replayInfoSong, 'Song Name: ${metadata.prettySongName}');
    setText(replayInfoDifficulty, 'Song Difficulty: ${metadata.prettyDifficulty}');
    setText(replayInfoVariation, 'Song Variation: ${metadata.prettyVariation}');
    setText(replayInfoDate, 'Save Date: ${metadata.prettyDate}');
    setText(replayInfoScore, 'Score: ${FlxStringUtil.formatMoney(data.finalScore, false, true)}');
    setText(replayInfoAccuracy, 'Accuracy: ${data.finalAccuracy}%');
    setText(replayInfoRank, 'Rank: ${data.finalRank}');
    setText(replayInfoSick, 'Sicks: ${tallies.finalSick}');
    setText(replayInfoGood, 'Goods: ${tallies.finalGood}');
    setText(replayInfoBad, 'Bads: ${tallies.finalBad}');
    setText(replayInfoShit, 'Shits: ${tallies.finalShit}');
    setText(replayInfoMissed, 'Misses: ${tallies.finalMissed}');
    setText(replayInfoCombo, 'Combo: ${tallies.finalCombo}');
    setText(replayInfoMaxCombo, 'Max Combo: ${tallies.finalMaxCombo}');
    setText(replayInfoTotalNotesHit, 'Total Notes Hit: ${tallies.finalTotalNotesHit}');
  }

  /**
   * Easy way of adding a replay to the list.
   * @param replayMetadataFile
   * @param replaySongName
   * @param replayDate
   */
  function addReplayFile(replayMetadataFile:String, replaySongName:String, replayDate:String):Void
  {
    var replayFile:ReplayFileBox = new ReplayFileBox(replayMetadataFile, replaySongName, replayDate);

    replayFile.onClick = function(_) {
      selectedInstanceFilename = ReplayFileBox.getSelectedInstance();
      if (selectedInstanceFilename != null)
      {
        reloadInformation(selectedInstanceFilename);
        trace('[REPLAY] Selected replay file: $selectedInstanceFilename');
      }
    }

    // replayFile.alpha = 0;

    replayList.push(replayFile);
    replayListBox.addComponent(replayFile);

    // Tween box alpha
    // FlxTween.tween(replayFile, {alpha: 1}, 0.5,
    //   {
    //     ease: FlxEase.quartOut,
    //     startDelay: replayList.length * 0.05 // Stagger each box's animation
    //   });

    trace('[REPLAY] Added replay file: ' + replayFile); // Idk what I was doing or what I thought this would print
  }

  function startReplay(replayMetadataFile:String):Void
  {
    // Stuff before actually loading PlayState is pretty similar to deleting
    // That is because I wrote the delete function before this
    var replayMetadata:ReplayMetadata = Replay.loadMetadata(replayMetadataFile);

    var checkFile:String = '${Replay.REPLAY_FOLDER}/${replayMetadata.targetFile}';

    if (replayMetadata != null)
    {
      if (FileSystem.exists(checkFile))
      {
        // Now we can try to load the replay because both files exist!

        // This stuff is from Freeplay.
        var targetSongId:String = replayMetadata.targetSongID;
        var targetSongNullable:Null<Song> = SongRegistry.instance.fetchEntry(targetSongId);
        if (targetSongNullable == null)
        {
          FlxG.log.warn('WARN: could not find song with id (${targetSongId})');
          return;
        }
        var targetSong:Song = targetSongNullable;

        // TODO: Have this actually set the level id. It preloads whatever was last loaded, not what we want it to load.
        // Paths.setCurrentLevel(replayMetadata.targetLevelId);
        LoadingState.loadPlayState(
          {
            // Stuff I'm 99% sure we need to even load the song
            targetSong: targetSong,
            targetDifficulty: replayMetadata.targetDifficulty,
            targetVariation: replayMetadata.targetVariation,
            targetInstrumental: replayMetadata.targetInstrumental,
            minimalMode: false,

            // Other replay stuff
            targetReplay: replayMetadata.targetFile,
            targetReplayMetadata: replayMetadataFile,
            replayMode: true
          }, true);
      }
      else
      {
        // Idk what should we do here?
        trace('[REPLAY] The replay file does not exist. Tried to load $checkFile');
      }
    }
  }

  function deleteReplay(targetMetadata:String):Void
  {
    try
    {
      // Step Uno: Get the metadata from cache
      var metadata:Null<ReplayMetadata> = cachedMetadata.get(targetMetadata);
      if (metadata == null) return;

      // Step Dos: Aquire the target file
      var targetFile:String = '${Replay.REPLAY_FOLDER}/${metadata.targetFile}';

      // Step Tres: Check if said files exist. We don't want any errors.
      if (FileSystem.exists(targetMetadata))
      {
        trace('[REPLAY] Found metadata for deletion: $targetMetadata');

        // Step Cuatro: Delete the file
        FileSystem.deleteFile(targetMetadata);
      }
      else
      {
        // If you deleted the file manually then tried using the delete button, what are you doing?
        // I'm not mad, but you should be ashamed of yourself. Just press the reload button.
        trace('[REPLAY] The metadata file does not exist. How did you make it this far?');
      }

      if (targetFile != null && FileSystem.exists(targetFile))
      {
        trace('[REPLAY] Found replay file for deletion: $targetFile');

        // Step Cuatro x2: Delete the file
        FileSystem.deleteFile(targetFile);
      }
      else
      {
        trace('[REPLAY] The replay file does not exist.');
      }

      // Step Cinco: Reload everything
      reloadReplays();
      // This should be null because we just deleted the selected file. We also reloaded the replay list
      reloadInformation(null);
    }
    catch (e:haxe.Exception)
    {
      trace('[REPLAY] Error deleting replay files: ' + e);
    }
  }
}
#end
