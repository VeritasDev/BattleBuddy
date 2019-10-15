#  Battle Buddy iOS App

***THIS REPO IS CURRENTLY A WORK IN PROGRESS! I WILL BE ADDING MUCH MORE DOCUMENTATION AFTER THE INITIAL RELEASE!***

## <u>Roadmap</u>

- [x] Submit v1.0
- [x] Release v1.0
- [x] Release v1.0.1
- [x] Release v1.0.2 
- [ ] Release v1.1.0  ***In development - see TODO list below***

## <u>v1.1.0</u>
- [ ] Face shields
- [ ] Japenese Localization
- [ ] Combat Simulation
- [ ] Penetration Calculator Improvements
    - [ ] Helmets/face shields/mods
    - [x] Add a "shoot" button to simulate damage
- [ ] Implement Banner Ads (if setting enabled)

- [x] Info on how to earn points
- [x] Earn random bud points
- [x] Health calc buckshot fix
- [x] Placeholder images for helmets
- [x] Resize helmet placeholder
- [x] Ammo needs to be disconnected from global metadata!
- [x] Add New Item Types
    - [x] Helmets
    - [x] Compare helmets secondary recommendation are one class below
- [x] Loyalty points
    - [x] Points for watching ads
    - [x] Banner ads
- [x] Buckshot damage multiplier
- [x] Attributions for localizations I missed last release
- [x] Days since wipe counter
- [x] Settings
    - [x] Nickname
    - [x] Enable Banner ads
- [x] Language override
- [x] Loyalty Leaderboard
- [x] Sound Training Beta
    - [x] Start test button
    - [x] Commit Answer button shows results on screen
    - [x] View will disappear - stop player

## <u>v1.2.0</u>
- [ ] Armor - compatible attachments
- [ ] Placeholder images for accessories
- [ ] Health Calculator Improvements
    - Add fragmentation toggle
    - Armor Zones
- [ ] Improve search
- [ ] Filter selection lists
- [ ] Mods List
    - [ ] Optics
    - [ ] Introduce array of images - 1 of item image and `n` for different modes
    - [ ] Gallery - auto/fade to next image
    - [ ] Tap to see all images
    - [ ] Foregrips
    - [ ] Pistol Grips
    - [ ] Handguards
    - [ ] Stocks
    - [ ] Other
    - [ ] Mods Detail Screen
    - [ ] Mods Comparison
- [ ] Firearms - compatible mods
- [ ] Cell label font sizing
- [ ] Stereo audio post writeup
- [ ] Best Item Calculator
- [ ] Real-time community stats updates
- [ ] Arabic HP fraction order
- [ ] Arabic Comparison Layout issue
- [ ] Pen chance cell text size
- [ ] Info page on how to earn points
- [ ] Loyalty points
    - [ ] Random bonus loyalty points % chance
    - [ ] Points for launching app
    - [ ] Points for opening up each day
    - [ ] Points for enabling push notifications
    - [ ] Interstitial
- Display shot result
- News/changelog
- IAP
- BSG Twitter Feed
- Skills and how to level them
- [ ] Add ? info to health calculator
- [ ] Add ? info to comparison screen
- [ ] Additional Info to Existing Items:
    - Compatible Mods on Firearms
    - Related items feed
- Comparison Screen Improvements
    - Revisit range again
    - Color scheme preference, gradient, black/white, highlight best/worst?
- Favoriting Items
- [ ] Reduce image sizes in Firebase storage
- [ ] Known issues post
- Firearm building
    - Custom
    - Max ergo
    - Min recoil
    - Random
- V-Harmony Item Matchmaker (play on e-harmony)
    - Select the type (gun, armor, helmet to start)
    - Questionnaire - What's is and isn't important to you? Fire rate, bullet, pen, damage, mobility, etc
    - Show sliders to value each item by its importance to you
    - Slider value applies multiplier score to stat
    - Take all items and rank
- Strat Roulette
- Task item checklist / shopping list
- Gun building help + random build + UI
- [ ] Survival rate calculator
    - Survival rate
    - Investment per run
    - Total earned per run
- [ ] Change upcoming features blog post to news / updates
- [ ] Push notification support v1.0
- [ ] Shots to kill calculator
    - Choose target
    - Choose armor
    - Choose aim type (thorax only, headshots only, leg meta)
    - Choose fragmentation type (never - worst case, always - best case, ammo specific - realistic)
    - Calculate
- [ ] Add New Item Types
    - Rigs
    - Helmets and accessories
    - Headphones
    - Mods
    - See all attachments that fits on it
    - See all mods it can attach to
    - See all mods it conflicts with 
    
## <u>Backlog</u>
- [ ] Logging / tags / debugging / etc
- Nuke UIKit to the ground; Foundation FTW
- Surveys
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
- Logging

## Pre-release Checklist
- [ ] Update Localizations
- [ ] Check any TODOs
- [ ] Update screenshots?
- [ ] Write 'whats new in this version'
- [ ] Ensure all keys are updated with production keys
- [ ] Google Ad Mob
- [ ] Update attributions


# Architecture
- [ ] There's files and folders and shit... More to come here once I get some time to make some nifty diagrams...

## Project / Repo TODO:

- Unit testing, cc, ci
- Finish documentation
- Migrate to Swift UI
- Accessibility
- Combine framework
