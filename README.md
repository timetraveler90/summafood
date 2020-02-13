#  Summa Food 1.1
Deadline 1st April

## Bugs
- Empty screen on first login
- Keyboard jumping on the login
- Find the better way for handling userID 
- Musaka tikvice is not displayed for all days, it should be displayed for all days except monday

## Refactoring
- Create git repo add project there with tag 1.0 
- Access control
- Code duplication
- Removing unecessary self
- Properly using Guard when suited
- Comment when really needed. Change vairable and functions names to be self documented when needed.
- Use more extension to break code into logical components
- Carefully check whether `DispatchQueue.main.async` is applied properly in right places

## New Features
- Adding peristance without CoreData. Your own Plist persistance file in Document folder (clue, read NSDictionary documentation and plist interaction).
- Randomize only on Favorite Food
- Improve a bit UI design (just superficial change no refactoring of UI code)
- Local notification to remind user to order the food (add checkbox on the settings)
- Localized application in NL and EN (user service to dynamicaly translate food names from server)
