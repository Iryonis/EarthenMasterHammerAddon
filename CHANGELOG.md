## CHANGELOG

All notable changes to this project will be documented in this file.

The format is freely inspired by [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

### 1.1.0 - 2026-02-08

#### Added

- Auto detection of Blacksmithing specializations for both The War Within and Midnight expansions.
- Auto detection of Master Hammer presence for both expansions.
- Improved weapon detection logic to determine which items can be repaired with the hammer, based on detected specializations and expansion.
- New command: `/tmhcap` will print the detected capabilities of the addon, including which specializations are detected, and for which expansion, and whether a Master Hammer is detected.

#### Changed

- The Interface version number to ensure compatibility with new expansion.
- The main frame now use money icons instead of text to display the amount saved.
- Changed the name of the addon to "Thalassian Master Hammer" to fit the new expansion -> I also changed all mentions of "EMH" to "TMH" in translations and commands (commands are now /tmh, /tmhcheck and /tmhcap).
- Automatically translated missing lines in Chinese and Russian translations, it may need review by native speakers.

#### Removed

- The checkboxes for manually selecting the Blacksmithing specialization, as they are no longer needed.

### 1.0.3 - 2025-09-11

#### Added

- Combat management for opening and closing frames.
- New command: `/emhcheck` will print the durability percentage of every item needing repair.

#### Changed

- The order of items to repair in the main frame now depends on durability percentage. The lower durability items will be repaired before those with higher durability.
- The durability percentage is now displayed on the repair button.

### 1.0.2 - 2025-05-19

#### Added

- Added Chinese translation - Thanks Fenei.
- Clicking the repair button after completing all repairs will now close the addon window.

#### Changed

- The EMH frame will now automatically open when a merchant frame is opened, but only if equipped items need repairs. It no longer checks inventory items.

### 1.0.1 - 2025-03-19

#### Added

- Added Russian translation - Thanks @Hubbotu.
- Added reset functionality when a merchant frame is opened.
- Linked .toc version to .lua version, for easier versionning.

#### Changed

- Improved the macro for repair.
- Improved README.md.
- Changed global variables and functions to local ones.

#### Fixed

- Fixed a bug where the frame wouldn't reset when dragged out of the screen.

### 1.0.0 - 2025-03-11

- Initial public release.
