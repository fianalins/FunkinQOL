# Changelog
All notable changes will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.?.?] - 8/11/2024 (not final)
### Added
- [Colored Health Bar dependant on Icons.](#info-about-colored-health-bar)
- [Independent Save File](#info-about-new-save-data)
### Changed
- Soft Health Bar Colors setting is replaced by Health Bar Color Type (Default, Soft, Icon Colored)
- All base characters now have new `"color"` value
- Merch button has dissapeared
### Fixed
- ONLY IN FINAL BUILD!! [Visualizer last bar not displaying + memory leak](#how-2-fix-funkinvis)
### Known Issues
- Senpai Erect (Erect and Nightmare) loops when reaching the end, probably caused due to either the fixed resync or something with the chart editor. When opening the song in the chart editor, then testing and going back, the end of the song disappears
- Cannot build on my machine, geting stuck at the Git Commit ID (probably doesn't affect others)
### Log of Pull Requests
- [Fix Camera Tweening When Paused](https://github.com/FunkinCrew/Funkin/pull/3098/files)
- [[BUGFIX]Player's left notes being selected when they shouldn't](https://github.com/FunkinCrew/Funkin/pull/3093)
- [[BUGFIX] Animation Editor not saving the file name](https://github.com/FunkinCrew/Funkin/pull/3090/files)
- [[BUGFIX] Ensure the variation used for the next song is valid.](https://github.com/FunkinCrew/Funkin/pull/3037/files)
- [Change UI Controls Order](https://github.com/FunkinCrew/Funkin/pull/3027/files)
- [[ENHANCEMENT] Custom Popups and Countdowns](https://github.com/FunkinCrew/Funkin/pull/3020)
### Wanted Pull Requests - Reason Not Added
- [Add Mod Menu](https://github.com/FunkinCrew/Funkin/pull/3060) - Crashes on Quit, no reordering. !!Issue with new haxeui stuff, crashes on Chart Editor as well!!
- [[ENHANCEMENT] Note Kind Scripts](https://github.com/FunkinCrew/Funkin/pull/2635/files) - Too scared to add
- [[ENHANCEMENT] Softcode Week 5 Cutscenes](https://github.com/FunkinCrew/Funkin/pull/2880/files) - Too scared because the [Custom Popups and Countdowns](https://github.com/FunkinCrew/Funkin/pull/3020) changes some of the stuff because it was hardcoded
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
#### What doesn't work
Not tested, but the way setting the Health Bar color is, I can't change the color on command so switching characters does not change the color. Copying Psych Engine and making a new Bar that can actually change the colors would make this work, but as much as I would like stealing, I won't. Also, there is no character switching in base game, and modding is not my main priority, otherwise I would've made this a script.
### How 2 Fix funkin.vis
I don't know how to do this hmm stuff + these are two seperate Pull Requests that need to be added

1. [Do this stuff](https://github.com/FunkinCrew/funkVis/pull/8/files)
2. [Do this other stuff](https://github.com/FunkinCrew/funkVis/pull/7/files)
### Info about New Save Data
All Save Data is being migrated to its own folder, `FunkinQoL-Dev`.

To make this work, instead of transferring from Legacy Funkin', the game first checks if you have a Save from the base game, and transfers all data to the new file. If you somehow don't have any Save Data, it then returns to checking Legacy Funkin'.

There is also a new shiny button in Options that lets you transfer any new data from base game. In theory.

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
