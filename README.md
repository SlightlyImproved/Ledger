# Ledger

**Ledger** is an [ESO](http://www.elderscrollsonline.com) add-on to keep tabs on your income and expenses.

You can [get it now at ESOUI](http://www.esoui.com/downloads/info1172-Ledger.html).

## Usage

**Ledger** has a window where you can see, sort and filter your transactions.

Every time you gain or spend Gold, it automatically add a new record to your history.

After you've just installed it, you'll see it in the middle of your screen.

You can assign a key to open/close this window. Alternatively, you can simply type `/ledger`.

## Roadmap

### Upcoming

1. Filter transactions by character
2. Search transactions by reason
3. Aggregate transactions by date or reason
4. Completion and review of German translation

### Backlog

- Calculate and display totals and averages by reason (repair costs, bounty payments, trade profit, etc.)
- Attach notes to a records
- French translation (need help)

The roadmap content and order are based on your feedback, so if you have some insight please share it with us in the comments.

## Change log

- **Thu Sep 03 20:20:52 BRT 2015**
  - Bump to 1.0, Yay! :D
  - Update compatibility to API 100012
  - Fixed some texts and translations
  - Updated the interface for ease of use and aesthetics
  - Added a message for when the window is empty
  - Extracted localization code to external lib L10n.lua

- **Fri Aug 16 15:47:21 BRT 2015**
  - Fixed a bug where data failed to load leaving the window empty
  - Fixed an error occurring on non-English game clients
  - Added German localization (fine contribution from [Baertram](http://www.esoui.com/forums/member.php?u=2028))
  - Now, players can see the transactions of all characters
  - Now, players are able to configure a key binding to open/close the Ledger window
  - Added missing reason names (thank you [dominoid](http://www.esoui.com/forums/member.php?u=345))
  - Date/time column now considers game localization, player's timezone and clock format

## Help wanted

I'm looking for people to help me with:

- Accounting formulas
- Completion and review of the interface texts
- Testing and feedback of user experience

Any help is really appreciated!

## Acknowledgement

Any of this wouldn't be possible without lots of help from the good people of the ESOUI community.

Thank you, and may the Nine bless you all!

## License

See [CC-BY-NC-SA-4.0](http://creativecommons.org/licenses/by-nc-sa/4.0/).
