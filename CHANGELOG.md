# Changelog
All notable changes will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.0] - Prerelease - 2024-10-14
Most features work, others are broken. This is an experimental branch for this specific update, don't expect this to come out any time soon.

### Everything
- Updated game to have the Pico Update. This required redoing/going into the file and retyping most things, some things able to be copied and pasted!
### Changed
- Experimental Flag for base game Ghost Tapping switches completely over to the experimental version.

### Known Issues
- Health Bar does not work.
  - Using Colored bar makes the `dark` variation characters throw an error. I have no clue why.
- Probably a lot more

### Extra
- This uses base game save data!! If you choose to build this you are risking everything!
  - A bug with the base game itself causes older versions of the game to delete all save data!! Back everything up!

Unless you want to be like me and lose all my gold P ranks...

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
