# Ledger

> **Ledger** is an [ESO](http://www.elderscrollsonline.com) add-on to keep tabs on your Gold income and expenses.

## Usage:

Type '/ledger' (or set a key binding in the control settings) to open and close the main window. There you can see a history of all your gold transactions.

Every time you get or spend Gold Ledger automatically adds a new record, saying who (which character), when (date and time, localized to your time zone), how much and for what reason (loot, theft, quest reward, guild store, etc...).

You can [get it free from ESOUI](http://www.esoui.com/downloads/info1172-Ledger.html).

## Change log

### 1.4.0 (Dec 20 2015)

- Design received additional polish and it's sexier than ever!
- Fixed a bug that allowed records from different characters to be merged.
- Added an option to enable/disable merge of consecutive transactions of same character and reason.
- Added a summary of your transactions for the selected character and period.
- Added a new period option: Last 1 hour.

### 1.3.1 (Nov 16 2015)

- Fixed bug where a refresh could be called before the data was loaded, prompting the user with an error. (Thanks BigM for the report.)

### 1.3.0 (Nov 15 2015)

- New entries with the same reason within 5 minutes are now grouped. The number of grouped entries are shown inside parenthesis - e.g. Loot (4)
- Fixed a bug that caused the Ledger window to flash quickly before hiding upon loading the UI.
- Added a Feedback button so you can mail me in-game with bugs, suggestions, comments, donations, or anything!

### 1.2.0 (Nov 14 2015)

- Update compatibility to API 100013.
- Automatically enter in cursor mode when you open it.
- Fixed more texts and translations.
- You can now filter the translations by period and character. Also Ledger will remember your options next time you play.
- Ledger has been added to the UI scene, meaning it'll hide when you open your other menus.
- Fixed a bug that caused localized time to be miscalculated.
- The Timestamp column now comes sorted by default.
- Ledger window will hide if you enter in combat.

### 1.0.0 (Sep 03 2015)

- Bump to 1.0, Yay! :D
- Update compatibility to API 100012.
- Fixed some texts and translations.
- Updated the interface for ease of use and aesthetics.
- Added a message for when the window is empty.
- Extracted localization code to external lib L10n.lua.

### 0.1.0 (Aug 16 2015)

- Fixed a bug where data failed to load leaving the window empty.
- Fixed an error occurring on non-English game clients.
- Added German localization (fine contribution from [Baertram](http://www.esoui.com/forums/member.php?u=2028)).
- Now, players can see the transactions of all characters.
- Now, players are able to configure a key binding to open/close the Ledger window.
- Added missing reason names (thank you [dominoid](http://www.esoui.com/forums/member.php?u=345)).
- Timestamp column now considers game localization, player's time zone and clock format.

## Acknowledgement

Any of this wouldn't be possible without lots of help from the good people of the ESOUI community. Thank you, and may the Nine bless you all!

## License

See [CC BY-NC-SA 4.0](http://creativecommons.org/licenses/by-nc-sa/4.0/).
