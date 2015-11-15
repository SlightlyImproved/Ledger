# Ledger

> **Ledger** is an [ESO](http://www.elderscrollsonline.com) add-on to keep tabs on your income and expenses.

Type `/ledger` (or set a key binding in the control options) to open its window, where you can see when and how you spent all your money. (And where it comes from!)

Every time you get or spend Gold, Ledger automatically writes a new entry, saying who (which character), when (date and time, localized to your time zone), how much and why (loot, theft, quest reward, guild store, etc...).

You can [get it free at ESOUI](http://www.esoui.com/downloads/info1172-Ledger.html).

## Change log

### 1.3.0 _on Nov 15 2015 21:13:45 GMT_

- New entries with the same reason within 5 minutes are now grouped. The number of grouped entries are shown inside parenthesis - e.g. Loot (4)
- Fixed a bug that caused the Ledger window to flash quickly before hiding upon loading the UI.
- Added a Feedback button so you can mail me in-game with bugs, suggestions, comments, donations, or anything!

### 1.2.0 _on Nov 14 2015 21:38:14 GMT_

- Update compatibility to API 100013.
- Automatically enter in cursor mode when you open it.
- Fixed more texts and translations.
- You can now filter the translations by time frame and character. Also Ledger will remember your options next time you play.
- Ledger has been added to the UI scene, meaning it'll hide when you open your other menus.
- Fixed a bug that caused localized time to be miscalculated.
- The Timestamp column now comes sorted by default.
- Ledger window will hide if you enter in combat.

### 1.0.0 _on Sep 03 2015 17:20:52 GMT_

- Bump to 1.0, Yay! :D
- Update compatibility to API 100012.
- Fixed some texts and translations.
- Updated the interface for ease of use and aesthetics.
- Added a message for when the window is empty.
- Extracted localization code to external lib L10n.lua.

### 0.1.0 _on Aug 16 2015 18:47:21 GMT_

- Fixed a bug where data failed to load leaving the window empty.
- Fixed an error occurring on non-English game clients.
- Added German localization (fine contribution from [Baertram](http://www.esoui.com/forums/member.php?u=2028)).
- Now, players can see the transactions of all characters.
- Now, players are able to configure a key binding to open/close the Ledger window.
- Added missing reason names (thank you [dominoid](http://www.esoui.com/forums/member.php?u=345)).
- Timestamp column now considers game localization, player's time zone and clock format.

## Roadmap

1. Support for Tel Var Stones and Alliance Points
2. Search transactions by reason description
3. Summary of your income and expenses (average and totals by reason or time frame)
4. Ability to attach notes to the transactions
5. German translation (help needed!)
6. French translation (help needed!)

The roadmap content and priority are **based on your feedback**, so if you have some insight please [share it with us in the comments](http://www.esoui.com/downloads/fileinfo.php?id=1172#comments).

## Help wanted

I'm looking for people to help me with:

- Accounting formulas
- Reason descriptions
- German translation
- French translation
- Testing and feedback

**All feedback, suggestions, bug reports and comments are greatly appreciated!**

## Acknowledgement

Any of this wouldn't be possible without lots of help from the good people of the ESOUI community.

Thank you, and may the Nine bless you all!

## License

See [CC-BY-NC-SA-4.0](http://creativecommons.org/licenses/by-nc-sa/4.0/).
