# Changelog
All notable changes will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
