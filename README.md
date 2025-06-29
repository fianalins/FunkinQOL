# Funkin' QoL

## Archival
I am archiving these repos because I don't believe that any of this has any use. I don't plan on updating this and every feature could be implemented better in a script for the game, rather than source code changes. A lot of, if not all features already have an equivalent on Gamebanana.

## Info

Funkin' QoL adds features that I personally think should be in the base game. As to why they aren't ranges from devs stating they don't want to add the feature (like middlescroll) or features like a colored healthbar for the various icons being what I think is too unreasonable for what the game wants to be.

- [Play the base game online](https://www.newgrounds.com/portal/view/770371)
- [Download base game builds for Windows, Mac, and Linux on itch.io](https://ninja-muffin24.itch.io/funkin)
- [Check out the GameBanana page for the latest release](https://gamebanana.com/mods/522085)
- [Check out the GameJolt page for the latest release. You can also play the web build and have access to Leaderboards and Trophies](https://gamejolt.com/games/funkinqol/919698)

## Compiling from Source

**PLEASE USE THE LINKS ABOVE IF YOU JUST WANT TO PLAY THE GAME**

To learn how to install the necessary dependencies and compile the game from source, please check out the [building the game/compilation](/docs/COMPILING.md) guide.

## Modding

Feel free to start learning how to mod the game by reading the Funkin' Crew's [documentation](https://funkincrew.github.io/funkin-modding-docs/) and guide to modding.

## Features

- Fixed positioning of Note Splashes
- Fixed default position of the Player's strumlime
- Added Middlescroll
- Added ability to hide the Opponent's strumline
- Added Ghost Tapping
- Added Judgement Counter
- Changed Score Text to be similar to that of Psych Engine
- Changed Health Bar to have three different modes
  - Default, Soft, Icon Colored
- Added Score Text Zoom, that bumps on note hit, and the opposite for missing
- Added ability to change transparency of Health Bar and Icons
- Added Time Bar with four different modes (other than disabled)
  - Time Left, Time Elapsed, Combined, Song Name

**Web Version Only**
- GameJolt API
  - Simple log in interface in the options menu
    - Logging in, logging out, changing users (typing in new credentials)
  - Ability to send scores to be viewed on the GameJolt page
  - Several trophies to collect
  - Option to disable score/trophy submission is available in settings

**Desktop Version Only**
I only upload this project for Windows. If I knew how/were able to make Linux/MacOS builds, I would.
- Replays
  - Replay Manager, found in the Debug Menu.
    - Ability to search and sort songs, delete, and play replays
  - Saving replays themselves. Stored in the `replays` folder relative to the game folder.
    - Stored with two seperate files, the replay itself and a metadata file.
  - You can disable saving replays in the Menubar.

## Credits

Full credits can be found in-game, or in the `credits.json` file which is located [here](https://github.com/fianalins/funkin.qol.assets/blob/main/exclude/data/credits.json).

- [@fianalins](https://www.youtube.com/fianalins) - Features
