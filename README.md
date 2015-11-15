# Ledger

**Ledger** is an [ESO](http://www.elderscrollsonline.com) add-on to keep tabs on your income and expenses.

You can [get it free at ESOUI](http://www.esoui.com/downloads/info1172-Ledger.html).

## Usage

**Ledger** has a window where you can see, sort and filter your recent transactions.

Every time you gain or spend Gold, it automatically adds a new record to your history.

After you've just installed it, you'll see it in the middle of your screen.

You can assign a key to open/close this window. Alternatively, you can simply type `/ledger`.

## Change log

- **1.1.0** on Nov 14 2015 21:38:14 GMT
  - Update compatibility to API 100013
  - Automatically enter in cursor mode when you open it
  - Fixed more texts and translations
  - Now you can filter by time frame and by character
  - Ledger has been added to the UI scene, meaning it'll hide when you open your other menus
  - Fixed a bug that caused localized time to be miscalculated
  - The Timestamp column now comes sorted by default
  - Ledger window will hide if you enter in combat
- **1.0.0** on Sep 03 2015 17:20:52 GMT
  - Bump to 1.0, Yay! :D
  - Update compatibility to API 100012
  - Fixed some texts and translations
  - Updated the interface for ease of use and aesthetics
  - Added a message for when the window is empty
  - Extracted localization code to external lib L10n.lua
- **0.1.0** on Aug 16 2015 18:47:21 GMT
  - Fixed a bug where data failed to load leaving the window empty
  - Fixed an error occurring on non-English game clients
  - Added German localization (fine contribution from [Baertram](http://www.esoui.com/forums/member.php?u=2028))
  - Now, players can see the transactions of all characters
  - Now, players are able to configure a key binding to open/close the Ledger window
  - Added missing reason names (thank you [dominoid](http://www.esoui.com/forums/member.php?u=345))
  - Date/time column now considers game localization, player's timezone and clock format

## Roadmap

### Upcoming

1. Search transaction by text
2. Merge transactions with the same reason in short period of time (to reduce number of repeating entries, like Loot for instance)
3. Summary of your income and expenses (average, totals, etc.)
4. Completion and review of German translation

### Backlog

- Support for Tel Var Stones and Alliance Points
- Add a note on a transaction
- French translation (help needed)

The roadmap content and order are based on your feedback, so if you have some insight please share it with us in the comments.

## Help wanted

I'm looking for people to help me with:

- Accounting formulas
- Completion and review of the interface texts and translations
- Testing and feedback of user experience

All feedback is greatly appreciated!

## Acknowledgement

Any of this wouldn't be possible without lots of help from the good people of the ESOUI community.

Thank you, and may the Nine bless you all!

## License

See [CC-BY-NC-SA-4.0](http://creativecommons.org/licenses/by-nc-sa/4.0/).
