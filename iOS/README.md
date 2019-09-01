#  Battle Buddy
### The Unofficial [Escape from Tarkov](http://www.escapefromtarkov.com) Reference App

Concept and development brought to you by [Veritas](http://www.twitch.tv/veritas), with loads of help from his and the greater EFT Community!

***THIS REPO IS CURRENTLY A WORK IN PROGRESS! I WILL BE ADDED MUCH MORE DOCUMENTATION AFTER THE INITIAL RELEASE!***
    
## <u>Roadmap</u>

- [ ] Release iOS v1.0 ***in progress***
- [ ] Start development on Progressive Web App (PWA) to support Android and the web basic initial features at first.

## <u>iOS v1.0</u>

- [ ] Fix any broken autolayout constraints
- [ ] Instrument memory and processing performance
- [ ] Client update user count
- [ ] Server update user count
- [ ] iPad support for each screen
    - [x] Main menu
    - [x] Search results
    - [x] Item lists
    - [x] Blog posts
    - [x] Base stack view
    - [ ] Pen chance calc
    - [ ] Health Calc
    - [x] Item Details
    - [x] Comparisons
- [x] Ensure watch an ad - handle not loaded
- [ ] Fix arabic last translation
- [ ] Localizations
    - [x] Dutch
    - [x] Italian
    - [x] Swedish
    - [x] Spanish (es)
    - [x] Serbian
    - [x] Croatian
    - [x] Spanish (es-419)
    - [x] Hungarian
    - [x] Russian
    - [x] Portuguese (br)
    - [x] Lithuanian
    - [x] Arabic
    - [x] French
    - [x] Portuguese (pt)
    - [x] Polish
    - [ ] Romanian
    - [ ] German
    - [ ] Czech
    - [ ] Chinese
    - [ ] Norwegian
- [ ] Replace Google Admob Key w/ Real One
- [ ] App store submission stuff
    - Screenshots
    - App description/copy/tags
- [x] Initial prototype
- [x] Firebase migration
- [x] Item lists and detail pages
    - [x] Firearms
    - [x] Body Armor
    - [x] Medical
    - [x] Ammo
    - [x] Throwables
    - [x] Melee weapons
- [x] Item searching
- [x] Prototype health/damage calculator
- [x] Penetration chance calculator
- [x] Blog post/writeup for ballistics system
- [x] Misc. App Info in *More* menu
    - [x] Info about Veritas
        - [x] Universal links to discord, socials, etc
    - [x] Upcoming features
    - [x] Links to github
    - [x] Attributions for help on app
    - [x] Link to The Team
- [x] Initial integration of ad support

## <u>Backend v1.0</u>

- [ ] Remote functions deployed
    - [ ] item update/syncing (every 60 mins)
    - [ ] Total user count cache (every 5 mins?)
    - [ ] Total ads watched cache (every 5 mins?)

## <u>PWA v0.1</u>

- [ ] Get basic site up and running at domain

## <u>v1.1</u>
- Favoriting Items
- Additional Info to Existing Items:
    - Mods -> Firearms 
- Add New Item Types
    - Helmets and accessories
    - Headphones
    - Rigs
    - Mods
        - See all attachments that fits on it
        - See all mods it can attach to
        - See all mods it conflicts with 
- Health Calculator Improvements
    - Add fragmentation toggle
    - Armor Zones
- Penetration Calculator Improvements
    - Helmets/face shields/mods
    - Armored Rigs + Multi-layer support to ballistics calc
- Survival rate calculator
    - Survival rate
    - Investment per run
    - Total earned per run
- Global metrics
    - Total ads watched count
    - Total supporters
    - Leaderboards
- In app purchases for supporters
- Support
    - Banner ads
    - Supporter mode - IAP
- More info to future features blog post
- Skills and how to level them
- News/changelog
    - BSG Twitter Feed
- Ballistics Simulation
    - Choose armor (and rig), choose round, fire shot, show result of shot (pen, armor damage, flesh damage, blunt damage, fragmentation)
- Exchange rate calculator
- Choose gun
    - See available parts
    - Max ergo
    - Min recoil
- Attributions Additions
    - SmooothBrain for design work 
- Item details additions
    - Related items feed
- Add ? info to health calculator
- Comparison Screen Improvements
    - Add ? info to comparison screen
    - Revisit range again
    - Color scheme preference, gradient, black/white, highlight best/worst?
    
    
## <u>v1.2</u>
- Nuke UIKit to the ground; Foundation FTW
- V-Harmony Item Matchmaker (play on e-harmony)
    - Select the type (gun, armor, helmet to start)
    - Questionnaire - What's is and isn't important to you? Fire rate, bullet, pen, damage, mobility, etc
    - Show sliders to value each item by its importance to you
    - Slider value applies multiplier score to stat
    - Take all items and rank
- Strat Roulette
- Task item checklist / shopping list
- Gun building help + random build + UI
    
# <u>Backlog</u>
- Crowdsourced images + gallery for items + fullscreen images
- Profile
    - Supporter type
    - Ads watched
    - Join date
    - Choose username
- New player interactive survival troubleshooting flowchart
- Evolutionary-esque algorithm for ballistics simulation?
- Accessibility audit - implement now or with swift UI?
- IoT Integrations
    - Siri / Alexa / Google Home
- Items
    - Bags, containers, etc
    - Add additional info to existing items, like where they can buy/find the item
    - Scopes
        - Show reticals / different modes / images 
- Tools
    - Does <item> fit on <item>?
- Learn
    - Skills / mastery
    - Useful hotkeys
    - Maps
    - Quest Info
    - Trader Info
- More
    - BSG twitter news
    - Youtube feed from select people
- Create GEAR tab that holds armor + other gear like rigs, comtacs, etc
- Random loadout generator
- Sharing content?
- Push notifications?
- Location maps w/ filtering on spawns/extracts/etc
- Quests
- Trader
	- Level / rep requirements
- Mac support
- Twitch intergrations/alerts/overlays?
- Everything we know about the wipe - !wipe video, soonTM, clips, etc
- Soundboard?
    - Yeet
    - Moist
    - PMC lines
    - Scav lines

## Project / Repo TODO:

- Unit testing, cc, ci
- Changelog
- Finish documentation
- Migrate to Swift UI
    - Accessibility
    - Combine framework
