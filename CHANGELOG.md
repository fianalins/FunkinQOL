# Changelog
All notable changes will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.0] - 2024-10-14 to 2025-01-18
### Everything
- Updated game to 0.5.3 (Pico Update).
### Changed
- Experimental Flag for base game Ghost Tapping switches completely over to the experimental version. (in theory)
- Most/all previous bugfixes from Pull Requests are not here. Because the issues they fix are already fixed, or I don't want to break something adding it.
- Moved the `updateHealthColors` logic for grabbing the Health Icon to the `initCharacters` function, to be with the other Health Icon code stuff.
  - This fixes a new bug that came with reimplementing this, where Dark variation characters throw an error, and the Spirit's trail creates a static version of itself above the actual character.
- Changed the Dicord API to display This Game, not the base game.
### Added
- A better way of determining whether or not to place the strums on the sides of the screen.
  - In greater detail, a `isOnSides` variable has been added to `Strumline.hx`. Not very complicated
  - This small change removes Bot Play making Player strums act in a not so desired way
- New submodule for assets, rather than uploading every asset file directly to the repo.
  - This will not be in place for any other branch until properly updated to this current version
  - You can find the fork of `funkin.assets` [here](https://github.com/fianalins/funkin.qol.assets)
- Variable for invalidating score submission. This is set to true when using Practice Mode, Bot Play, and when in Charting Mode (although Charting Mode doesn't go to results screen)
  - You can also force enable this using a new option in Preferences
- New field for songs and weeks for a `Table ID` (the thing that is used for scoreboards)
  - You can change the Table ID for songs in the Chart Editor, Weeks have to be done manually.
- A login page for GameJolt. This can be found in the Options menu.
  - You can log in, log out, and change to a different account (typing in different credentials)
- Added the [hxgamejolt](https://github.com/MAJigsaw77/hxgamejolt-api) haxelib for using GameJolt API.
  - There is also a helper class made for using the API easier. Mainly because Web doesn't work quite correctly, but it does fix scores sending twice.
- [Extra GameJolt API Info](#gamejolt-api)
- An entire Replay Sytem. [Read more here.](#new-replay-system)
### Fixed
- [Fix Audio/Visual Offset causing skips on song start](https://github.com/FunkinCrew/Funkin/pull/3732/)
- [Improvements to the save data system to prevent overwriting when resolution fails.](https://github.com/FunkinCrew/Funkin/pull/3728/)
  - This is technically 0.5.3, but it is not in the actual GitHub, just this pull request and the downloads.
  - This also changes save data to a different location, specifically for this project. Like versions before this.
- Fixed the Chart Editor button saying "Skip Back" when it clearly skips forward
- Fixed problems with several charts in the game.
  - Fixed off-beat notes on Pico's side in Spookeez (Pico Mix)
  - Fixed missing notes on Spookeez's side in Spookeez (Pico Mix)
  - Removed Focus Event at beginning of Roses (non-erect)
  - Fixed off-beat notes on Boyfriend's side in Cocoa Erect. Same as the last one below. I just don't feel like finding the exact note and changing the timing. I opened up the chart file directly from assets, so it should be exactly the same, just with the fixes.
  - [Remove extra notes from Darnell (BF Mix)](https://github.com/FunkinCrew/funkin.assets/pull/106)
  - [Fix Eggnog Erect ending notes + small adjustments](https://github.com/FunkinCrew/funkin.assets/pull/104/)
  - Added missing note on Boyfriend's side in Stress. It shows a massive diff, but it's because of formatting changes. Should functionally be the same.

### GameJolt API
This is a ***Web Only Feature!***

- Scoreboards and Trophies
  - There are no plans to make an interface to view trophies and scoreboards in-game as of now.
  - There is a popup that will appear when you get a trophy however.

- How scores are saved
  - Scores are saved as
    - The score, with commas seperating.
    - The rank (PERFECT, EXCELLENT, etc.)
    - Percent (100%, 99%, 69%, etc.)
    - Difficulty (NIGHTMARE, HARD, EASY, etc.)
      - This is because I don't feel like making a scoreboard for every difficulty.
      - There are scoreboards for the different variations, like Erect, Pico Mix, and BF Mix.

- Why do this
  - Because I want to do something. This is something.

### New Replay System
This is **NOT** on ***Web Platforms!***

Please do not steal this. This is open-source, but please.
Credit me.

#### How does it work?
I record each press and release, along with the note direction and position (from the song's position), and send it to a list. At the end of the song, the list will be converted into a file and saved to the `replays` folder relative to the game folder. I also save a metadata file with everything I'd need to access, like the song name, date recorded, tallies, etc.

In the Replay Manager (found in the Debug Menu for now), it finds every replay and populates the list on the left. When you select a replay, you can view all information from the metadata file on the right. At the bottom you can Play or Delete the replay. If you manually add a replay to the folder (for whatever reason) you can reload the replay list through the menubar at the top (or using the shortcut!). You can also search for a replay by song name, or sort by name or date.

When in Replay Mode, you cannot press any keybinds, and all preferences from when the replay was recorded will be applied. Your original preferences will be restored after the replay ends. When the replay ends, you will also be taken to the Results Screen, where you can view the accurate information from when the replay was recorded.

#### Notes
From the "User Guide":
There is no guarantee that the Replay will be 100% accurate to real performance from the player.
Accurate information can be found in the metadata, or shown in the Manager and Results Screen.

Other notes:
When in Replay Mode, you (very likely) ***will*** encounter the score being ever so slightly off.
Through my testing, I have found that most of the problem comes from the way Hold Notes are scored.
[There is a PR for Funkin' trying to make Hold Notes score consistently](https://github.com/FunkinCrew/Funkin/pull/3832)
It is not in my interest to add this though.

Depending on the performance of your computer, the tallies can be off as well.

#### Why?
Because I finished making the GameJolt API stuff and got bored. It has also been like 3 months since I started working on this update


## [0.4.0] - 2024-8-17
### Added
- [Colored Health Bar dependant on Icons.](#info-about-colored-health-bar)
- [Independent Save File](#info-about-new-save-data)
- New Bar to make changing colors easier.
- FPS Cap option. The actual FPS the game runs at will be higher than the cap, and it is disproportionate. At lower values it seems to be about 4 frames higher, however at the max of 360 I get about 480? It doesn't really matter.
### Changed
- Soft Health Bar Colors setting is replaced by Health Bar Color Type (Default, Soft, Icon Colored)
- All base characters now have new `"color"` value
- Bars now use new `BarUtil.hx`
- [Change UI Controls Order](https://github.com/FunkinCrew/Funkin/pull/3027)
### Removed
- Merch button in Main Menu
### Fixed
- ONLY IN FINAL BUILD!! [Visualizer last bar not displaying + memory leak](#how-2-fix-funkinvis)
- [Fix Camera Tweening When Paused](https://github.com/FunkinCrew/Funkin/pull/3098)
- [[BUGFIX] Player's left notes being selected when they shouldn't](https://github.com/FunkinCrew/Funkin/pull/3093)
- [[BUGFIX] Animation Editor not saving the file name](https://github.com/FunkinCrew/Funkin/pull/3090)
- [[BUGFIX] Ensure the variation used for the next song is valid.](https://github.com/FunkinCrew/Funkin/pull/3037)
### Enhancement
- [[ENHANCEMENT] Custom Popups and Countdowns](https://github.com/FunkinCrew/Funkin/pull/3020)
### Known Issues
- Senpai Erect (Erect and Nightmare) loops when reaching the end, probably caused due to either the fixed resync or something with the chart editor. When opening the song in the chart editor, then testing and going back, the end of the song disappears
- [Not fully bug tested.](#how-i-bug-test)
### Wanted Pull Requests - Reason Not Added
- [Add Mod Menu](https://github.com/FunkinCrew/Funkin/pull/3060) - Crashes on Quit, no reordering. !!Issue with new haxeui stuff, crashes on Chart Editor as well!!
- [[ENHANCEMENT] Note Kind Scripts](https://github.com/FunkinCrew/Funkin/pull/2635/files) - Too scared to add
- [[ENHANCEMENT] Softcode Week 5 Cutscenes](https://github.com/FunkinCrew/Funkin/pull/2880) - Too scared because the [Custom Popups and Countdowns](https://github.com/FunkinCrew/Funkin/pull/3020) changes some of the stuff because it was hardcoded
- [[ENHANCEMENT + BUGFIX] soft codable visualizers + polymod download fix](https://github.com/FunkinCrew/Funkin/pull/2994) - For some unknown reason it removes the faces and hands to some of the poses in Blazin'??
### Info about Colored Health Bar
For the Colored Health Bar to work, there is a new Data Input called `"color"`. If there is no `"color"` string in the Character data file, it is defaulted to White
#### How to add Color
Inside of the .json file of the Character, you need to add the line
`"color": "#FF00AA",`
It does not matter where the line is put, just so long as it is in the file.

The color is formatted as a Hex Code value, however you can [read the documentation on FlxColor - fromString](https://api.haxeflixel.com/flixel/util/FlxColor.html#fromString) to see other ways you can format the string.
#### Stuffs I want to add
In the Character Debug page, there should be a way to add the Color input for the Character, and a preview, like Psych.
### How 2 Fix funkin.vis
I don't know how to do this hmm stuff + these are two seperate Pull Requests that need to be added

1. [Do this stuff](https://github.com/FunkinCrew/funkVis/pull/8/files)
2. [Do this other stuff](https://github.com/FunkinCrew/funkVis/pull/7/files)
### Info about New Save Data
All Save Data is being migrated to its own folder, `FunkinQoL-Dev`.

To make this work, instead of transferring from Legacy Funkin', the game first checks if you have a Save from the base game, and transfers all data to the new file. If you somehow don't have any Save Data, it then returns to checking Legacy Funkin'.

There is also a new shiny button in Options that lets you transfer any new data from base game. In theory.
### How I Bug Test
Pointless random stuff I feel like adding.

My standard testing procedure consists of

1. Seeing if the game builds properly.
2. Testing the feature I am adding.
3. Playing on normal difficulties, Erect remixes, pixel stages, non-pixel stages, etc. (depends on what is being added)
4. If it truly needs it, I'll test with different Preferences enabled or disabled.
5. Assume it is good to go and push to `experimental`.

6. End of the loop. Happens when I am satisfied with all the new stuff and decide it is time to update the finished product for all zero of you to enjoy.

## [0.3.0] - 2024-08-1
### BIG STUFF
- [Preferences Menu now can use Strings, Numbers, and "Percents"](https://github.com/FunkinCrew/Funkin/pull/2942)
- Time Bar, with four different types (Time Left, Time Elapsed, Combined, Song Name)
- Opponent strums now appear when in Middlescroll, with option to disable (in case it breaks mods)
- Percentage now shows in the Score Text
- New Rating in the Score Text
- New Performance Rating(?) in the Score Text
- Way too many bug fixes. (thanks to all the people that made these PR's on base game!!!!)
### Added
- Changelog
- Time Bar sprite
- Watermark in Main Menu
- Accessibility Menu, for now only contains "Flashing Lights" and "Soft Health Colors" from the Preferences
### Changed
- Assets is no longer a submodule (art still is)
- Added my name to the Credits
- [Soft-coded "Hey!" events in "Tutorial"](https://github.com/FunkinCrew/Funkin/pull/3007)
- Title now reads "Friday Night Funkin' QoL" and filename is "Funkin QoL"
- Removed Gen Alpha terms in README.md and fixed false promises
- ["`FunkinSound.playOnce` return the created sound"](https://github.com/FunkinCrew/Funkin/pull/2926)
- ["Run the garbage collection process after purging cache"](https://github.com/FunkinCrew/Funkin/pull/2740)
- [Video Cutscenes pause when game is unfocused](https://github.com/FunkinCrew/Funkin/pull/2903)
- Hold Notes no longer disappear (might be intended) and instead turn transparent (like the notes) when missed
- Health Bar Alpha (transparency) can now be changed via Preferences
- Opponent now plays Note Splashes with Note Hits
- [Consistent flashing for menu items](https://github.com/FunkinCrew/Funkin/pull/2494)
- ["Fix Soundtray Aliasing / Smoothing"](https://github.com/FunkinCrew/Funkin/pull/2853)
- ["Story Mode Menu Mouse Scrolling"](https://github.com/FunkinCrew/Funkin/pull/2873)
- ["make checkbox items in Preferences instantly update"](https://github.com/FunkinCrew/Funkin/pull/2368)
### Fixed
- Blazin' strums now align with how the Preferences Middlescroll handles it
- "relevant" spelled wrong in `ScriptEventType.hx`
- [Default Health Icon appears instead of the HaxeFlixel logo](https://github.com/FunkinCrew/Funkin/pull/3005)
- [Consistent strum confirm animation lengths](https://github.com/FunkinCrew/Funkin/pull/2522)
- [`PIXELS_PER_MS` is now used where it should have been](https://github.com/FunkinCrew/Funkin/pull/2850)
- [`PauseSubState` text tweens from zero transparency](https://github.com/FunkinCrew/Funkin/pull/2638)
- [F5 now reloads the chart in PlayState](https://github.com/FunkinCrew/Funkin/pull/2990)
- [Better offset • "Use chart inst offset for song resync + other resync fixes"](https://github.com/FunkinCrew/Funkin/pull/3058)
- Judgement text now properly centered (if not, then I must've done something wrong)
- [No duplicate Combo Counter on combo breaks](https://github.com/FunkinCrew/Funkin/pull/2799)
- ["When pressing chart key while charting, chart gets reset"](https://github.com/FunkinCrew/Funkin/pull/2739)
- ["`ChartEditorState` Live Input"](https://github.com/FunkinCrew/Funkin/pull/2992)
- ["Clean up a part of ChartEditorThemeHandler, fixing a bug with it"](https://github.com/FunkinCrew/Funkin/pull/2860)
- ["Fixed memory counter displaying negative numbers"](https://github.com/FunkinCrew/Funkin/pull/2713)
- ["Better Freeplay song preview volume + Fix Crash + Remove debug code"](https://github.com/FunkinCrew/Funkin/pull/2738)
- ["Crash after coming back from stickers and pressing F5"](https://github.com/FunkinCrew/Funkin/pull/2863)
- ["Fixed cancelMenu sound not playing after switching state"](https://github.com/FunkinCrew/Funkin/pull/2986)
- ["Fix small oversight in LoadingState"](https://github.com/FunkinCrew/Funkin/pull/2749)
- ["Pause Menu and Stickers have same zoom as HUD"](https://github.com/FunkinCrew/Funkin/pull/2567)
- ["Song with no "Normal" causes Stack Overflow"](https://github.com/FunkinCrew/Funkin/pull/2712)
- ["Correct step lengths in x/4 time signatures"](https://github.com/FunkinCrew/Funkin/pull/3067)

## [0.2.0] - 2024-6-17
### Added
- Score Text Bop, zooms on hit, and reverse zooms(?) on miss/ghost tap
### Changed
- Health Bar colors are not softer, with the option to disable
- Health Bar + Icons are now semi-transparent when using Middlescroll
### Fixed
- Messy Code

## [0.1.1] - 2024-6-16
### Fixed
- Missing checks for whether Judgement Counter was enabled

## [0.1.0] - 2024-6-15
### Added
All of it. Public release.

- Middlescroll option, without opponent strums.
- Ghost Tapping
- Judgement Counter on left side
### Changed
- Score text now reads similar to that of Psych Engine (or basically any other engine)
### Fixed
- Lined up Note Splash effect
