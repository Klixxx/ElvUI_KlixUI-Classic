-- English localization file for enUS and enGB.
local L = ElvUI[1].Libs.ACL:NewLocale("ElvUI", "enUS", true, true)
if not L then return end

-- General Options / Core
L["A plugin for |cff1784d1ElvUI|r by Klix (EU-Twisting Nether)"] = true
L['by Klix (EU-Twisting Nether)'] = true
L["KUI_DESC"] = [=[|cfff960d9KlixUI|r is an extension of ElvUI. It adds:

- Alot of new features.
- A transparent look.
- A decorative texture on alot of frames.
- Support both DPS and Healer specialization.
- compatible with most of other ElvUI plugins.

|cfff960d9Note:|r Some more available options can be found in the ElvUI options marked with |cfff960d9pink color|r.  

|cffff8000Newest additions are marked with:|r]=]

L['Install'] = true
L['Run the installation process.'] = true
L["Reload"] = true
L['Reaload the UI'] = true
L["Changelog"] = true
L['Open the changelog window.'] = true
L["Modules"] = true
L["Media"] = true
L["Skins & AddOns"] = true
L["AFK Screen"] = true
L["Enable/Disable the |cfff960d9KlixUI|r AFK Screen.\nCredit: |cff00c0faBenikUI|r"] = true
L["AFK Screen Chat"] = true
L["Show the chat when entering AFK screen."] = true
L["Game Menu Screen"] = true
L["Enable/Disable the |cfff960d9KlixUI|r Game Menu Screen.\nCredit: |cffff7d0aMerathilisUI|r"] = true
L['Splash Screen'] = true
L["Enable/Disable the |cfff960d9KlixUI|r Splash Screen.\nCredit: |cff00c0faBenikUI|r"] = true
L['Login Message'] = true
L["Enable/Disable the Login Message in Chat."] = true
L["Game Menu Button"] = true
L["Show/Hide the |cfff960d9KlixUI|r Game Menu button"] = true
L["Minimap Button"] = true
L["Show/Hide the |cfff960d9KlixUI|r minimap button."] = true
L["Left Click"] = true
L["Open KlixUI Config"] = true
L["Alt + Left Click"] = true
L["ReloadUI"] = true
L['Tweaks'] = true
L["Speedy Loot"] = true
L["Enable/Disable faster corpse looting."] = true
L["Easy Delete"] = true
L['Enable/Disable the ability to delete an item without the need of typing: "delete".'] = true --WIP
L["Cinematic"] = true
L["Skip Cut Scenes"] = true
L["Enable/Disable cut scenes."] = true
L["Cut Scenes Sound"] = true
L["Enable/Disable sounds when a cut scene pops.\n|cffff8000Note: This will only enable if you have your sound disabled.|r"] = true
L["Talkinghead Sound"] = true
L["Enable/Disable sounds when the talkingheadframe pops.\n|cffff8000Note: This will only enable if you have your sound disabled."] = true
L["Here you find the options for all the different |cfff960d9KlixUI|r modules.\nPlease use the dropdown to navigate through the modules."] = true
-- New Information tab
L['Information'] = true
L["FAQ_DESC"] = "This section contains some questions about ElvUI and |cfff960d9KlixUI|r."
L["FAQ_ELV_1"] = [[|cfff960d9Q: Where can I find the latest ElvUI version?|r
|cffff8000A:|r You can find the latest ElvUI version here - https://www.tukui.org/download.php?ui=elvui
You can also try out the latest development version, which can be found here - https://git.tukui.org/elvui/elvui/repository/archive.zip?ref=development
The development can cause errors and therefore should be used with cautions.]]
L["FAQ_ELV_2"] = [[|cfff960d9Q: Where can I get ElvUI support?|r
|cffff8000A:|r The fastest way, to get support, is joining the tukui Discord - https://discord.gg/xFWcfgE
You could also make a post on the official forum - https://www.tukui.org/forum/]]
L["FAQ_ELV_3"] = [[|cfff960d9Q: What if I wanna request a feature or make a bug report?|r
|cffff8000A:|r If you want to request a feature or make a bug report please use the bug tracker found here - https://git.tukui.org/elvui/elvui/issues]]
L["FAQ_ELV_4"] = [[|cfff960d9Q: What info do I need to provide in a bug report?|r
|cffff8000A:|r First you need to ensure the error really comes from ElvUI.
To do so you need to disable all other addons except ElvUI and ElvUI_Config.
You can do this by typing "/luaerror on" (without quotes).
If the error didn't disappear then you need to send us a bug report.
In this bug report you'll need to provide the ElvUI version ("latest" is not a valid version number), the text of the error, screenshot if needed.
The more info you'll give us on how to reproduce said error the faster it will be fixed.]]
L["FAQ_ELV_5"] = [[|cfff960d9Q: Why are some options not applied on my other characters using the same profile?|r
|cffff8000A:|r ElvUI has three kinds of options. First (profile) is stored in your profile, second (private) is stored on a character basis, third (global) are applied across all character regardless of profile used.
In this case you most likely came across the option of type two.]]
L["FAQ_ELV_6"] = [[|cfff960d9Q: What are ElvUI slash (chat) commands?|r
|cffff8000A:|r ElvUI has a lot of different chat commands used for different purposes. They are:
/ec or /elvui - Opening config window
/bgstats - Shows battleground specific datatexts if you are on battleground and closed those.
/hellokitty - Want a pink kawaii UI? We got you covered!
/harlemshake - Need a shake? Just do it!
/luaerror - loads you UI in testing mode that is designed for making a proper bug report (see Q #4)
/egrid - Sets the size of a grid in toggle anchors mode
/moveui - Allows to move stuff around
/resetui - Resets your entire UI]]
L["FAQ_KUI_1"] = [[|cfff960d9Q: What to do if I encounter an error with KlixUI?|r
|cffff8000A:|r Pretty much the same as for ElvUI (see it's FAQ section) but you'll have to provide the KlixUI version aswell.
Though the fastest way is still joining my Discord and post the issue there - https://discord.gg/GbQbDRX]]
L["FAQ_KUI_2"] = [[|cfff960d9Q: Why are some features disabled or totally gone from the module section?|r
|cffff8000A:|r You probably have another addon enabled that does the exact same thing as some of the KlixUI modules, thats why they are disabled / hidden to minimize conflicts.
If you want to use the modules provided by KlixUI, please disable the specific addon.]]
L["FAQ_KUI_3"] = [[|cfff960d9Q: Where can i disable / enable a specific feature in KlixUI?|r
|cffff8000A:|r I have tried to build up the KlixUI config as self explanatory as possible, e.g. disabling a Bag feature will be located in the Bag module etc.
Remember to always look in the Miscellaneous section many "random" features are located there.]]
L["FAQ_KUI_4"] = [[

|cfff960d9To be continued...|r]] -- those extra section is meant to be there!
L["Links"] = true
L["LINK_DESC"] = [[Following the links below will direct you to the |cfff960d9KlixUI's|r pages on various sites, where you can download the latest versions and report errors.
Furthermore you will find download links for my other addons by pressing the respective button below.]]
L["My other Addons"] = true
L["|cfffb4f4fSkullflowers UI C.A|r"] = true
L["A continuation of the popular and highly demanded Skullflower UI."] = true
L["|cfffb4f4fSkullflowers UI Texture Pack|r"] = true
L["Texture pack for all the Skullflower textures."] = true
L["ElvUI Fog Remover"] = true
L["Removes the fog from the World map, thus displaying the artwork for all the undiscovered zones, optionally with a color overlay on undiscovered areas."] = true
L["ElvUI Chat Tweaks Continued"] = true
L["Chat Tweaks adds various enhancements to the default ElvUI chat."] = true
L["ElvUI Enhanced Currency"] = true
L["A simple yet enhanced currency datatext."] = true
L["ElvUI Compass Points"] = true
L["Adds cardinal points to the elvui minimap."] = true
L["|cfff2f251Cool Glow|r"] = true
L["Changes the actionbar proc glow to something cool!"] = true
L["Masque: |cfff960d9KlixUI|r"] = true
L["My masque skin to match the UI."] = true
L["ElvUI InfoBar"] = true
L["Adds an utility info bar bottom or top of your screen."] = true
L["Credits"] = true
L["ELVUI_KUI_CREDITS"] = "I would like to point out the following people for helping me create this addon with coding, testing and other stuff."
L["Submodules & Coding:"] = true
L["ELVUI_KUI_CODERS"] = [[Merathilis
Benik
Azilroka
Darth Predator
Blazeflack
Simpy
Lockslap
Whiro
Woolbound
Woffle
Myrrodin
Tyra314
Arwic
Hizuro
Lifeismystery
Lightspark]]
L["ELVUI_KUI_DONORS_TITLE"] = "Thanks to these awesome people for supporting my work via donations:"
L["ELVUI_KUI_DONORS"] = [[Akiao
Enii
He Min
Bradx
Rey
Vauxine]]
L["Testing & Inspiration:"] = true
L["ELVUI_KUI_TESTING"] = [[Kringel
Akiao
Obscurrium
Benik
Merathilis
Darth Predator
Skullflower
TukUI/ElvUI community]]
L["Other Support:"] = true
L["ELVUI_KUI_SPECIAL"] = [[Kringel - for updating the german locales and always provide helpful and good support in my Discord!
Wilzor - for suggestion alot of new features and helping out with some coding (AutoOpen Bags ID)
And not to forget the rest of the TukUI/ElvUI community :)]]

-- Actionbars
L["Credits"] = true
L['ActionBars'] = true
L["General"] = true
L['Transparent Backdrops'] = true
L['Applies transparency in all actionbar backdrops and actionbar buttons.'] = true
L['Quest Button'] = true
L['Shows a button with the quest item for the closest quest with an item.'] = true
L['Clean Button'] = true
L['Removes the textures around the Bossbutton and the Zoneability button.'] = true
L["Enhanced Vehicle Bar"] = true
L["A different look/feel of the default vehicle bar."] = true
L["Buttons"] = true
L["The amount of buttons to display."] = true
L["Button Size"] = true
L["The size of the enhanced vehicle bar buttons."] = true
L["Button Spacing"] = true
L["The spacing between the enhanced vehicle bar buttons."] = true
L["Template"] = true
L["Random Hearthstone"] = true
L["RHS_DESC"] = [[This Random Hearthstone feature creates a fully functional hearthstone macro, when pressing on the "Create |cfff960d9KlixUI|r Hearthstone" button below.
This macro will then cycles through all your avaible toy hearthstones and use one randomly everytime you press the macro.

|cffff8000The created macro only works for toy hearthstones!|r
]] -- that extra section is meant to be there!
L["Delete Hearthstone"] = true
L['Automatically delete the classic hearthstone, you receive, when you change hearth location.'] = true
L["Create |cfff960d9KlixUI|r Hearthstone"] = true
L["Glow"] = true
L["Finishing Move Glow"] = true
L["This will display glow, when reaching 5 combopoints, on spells which utilize 1-5 combopoints."] = true
L["Color"] = true
L["Num Lines"] = true
L["Defines the number of lines the glow will spawn."] = true
L["Frequency"] = true
L["Sets the animation speed of the glow. Negative values will rotate the glow anti-clockwise."] = true
L["Length"] = true
L["Defines the length of each individual glow lines."] = true
L["Thickness"] = true
L["Defines the thickness of the glow lines."] = true
L["X-Offset"] = true
L["Y-Offset"] = true
L["Specialization & Equipment Bar"] = true
L["Enable"] = true
L['Show/Hide the |cfff960d9KlixUI|r Spec & EquipBar.'] = true
L["Border Glow"] = true
L["Shows an animated border glow for the currently active specialization and loot specialization."] = true
L["Mouseover"] = true
L["Change the alpha level of the frame."] = true
L["Hide In Combat"] = true
L['Show/Hide the |cfff960d9KlixUI|r Spec & EquipBar in combat.'] = true
L["Hide In Orderhall"] = true
L['Show/Hide the |cfff960d9KlixUI|r Spec & Equip Bar in the class hall.'] = true
L["Micro Bar"] = true
L['Show/Hide the |cfff960d9KlixUI|r MicroBar.'] = true
L["Microbar Scale"] = true
L['Show/Hide the |cfff960d9KlixUI|r MicroBar in combat.'] = true
L['Show/Hide the |cfff960d9KlixUI|r MicroBar in the class hall.'] = true
L["Highlight"] = true
L['Show/Hide the highlight when hovering over the |cfff960d9KlixUI|r MicroBar buttons.'] = true
L["Buttons"] = true
L['Only show the highlight of the buttons when hovering over the |cfff960d9KlixUI|r MicroBar buttons.'] = true
L["Text"] = true
L["Position"] = true
L["Top"] = true
L["Bottom"] = true
L['Show/Hide the friend text on |cfff960d9KlixUI|r MicroBar.'] = true
L['Show/Hide the guild text on |cfff960d9KlixUI|r MicroBar.'] = true
L["AutoButtons"] = true
L["Auto InventoryItem Button"] = true
L["Auto QuestItem Button"] = true
L["Alliance Mine"] = true
L["Horde Mine"] = true
L["Salvage Yard"] = true
L["Quest Auto Buttons"] = true
L["Inventory Auto Buttons"] = true
L["Auto Buttons"] = true
L["Feature Config"] = true
L["Hot Key Font"] = true
L["Count Font"] = true
L["Hot Key Font Size"] = true
L["Count Font Size"] = true
L["Inventory Auto Buttons"] = true
L["Color By Item"] = true
L["Custom Color"] = true
L["Spacing"] = true
L["Direction"] = true
L["Number of Buttons"] = true
L["Buttons Per Row"] = true
L["Button Size"] = true
L["Quest Auto Buttons"] = true
L["Whitelist"] = true
L["Add ItemID"] = true
L["Must be an itemID!"] = true
L["is not an itemID"] = true
L["Delete ItemID"] = true
L["Blacklist"] = true
L["Add Blacklist ItemID"] = true
L["Delete Blacklist ItemID"] = true

-- Addon Panel
L["Addon Control Panel"] = true
L['# Shown AddOns'] = true
L['Frame Width'] = true
L['Button Height'] = true
L['Button Width'] = true
L['Font'] = true
L['Font Outline'] = true
L["Value Color"] = true
L["Font Color"] = true
L['Texture'] = true
L['Class Color Check Texture'] = true

-- Announcement
L["Announcement"] = true
L["Utility spells"] = true
L["Combat spells"] = true
L["Taunt spells"] = true
L["Say thanks"] = true
L["Your name"] = true
L["Name of the player"] = true
L["Target name"] = true
L["Pet name"] = true
L["The spell link"] = true
L["Your spell link"] = true
L["Interrupted spell link"] = true
L["Interrupt"] = true
L["Success"] = true
L["Failed"] =true
L["Only instance / arena"] = true
L["Player"] = true
L["Pet"] = true
L["Player(Only you)"] = true
L["Other players"] = true
L["Other players\' pet"] = true
L["Text"] = true
L["Use default text"] = true
L["Text for the interrupt casted by you"] = true
L["Text for the interrupt casted by others"] = true
L["Example"] = true
L["Only I casted"] = true
L["Target is me"] = true
L["Only target is not tank"] = true
L["Feasts"] = true
L["Bots"] = true
L["Toys"] = true
L["Portals"] = true
L["Niuzao"] = true
L["Totem"] = true
L["Provoke all(Monk)"] = true
L["Sylvanas"] = true
L["Channel"] = true
L["Use raid warning"] = true
L["Use raid warning when you is raid leader or assistant."] = true
L["If you do not check this, the spell casted by other players will be announced."] = true
L["None"] = true
L["Whisper"] = true
L["Self(Chat Frame)"] = true
L["Emote"] = true
L["Yell"] = true
L["Say"] = true
L["Solo"] = true
L["Party"] = true
L["Instance"] = true
L["Raid"] = true
L["In party"] = true
L["In instance"] = true
L["In raid"] = true
L["Combat resurrection"] = true
L["Threat transfer"] = true
L["Resurrection"] = true
L["Goodbye"] = true
L["I interrupted %target%\'s %target_spell%!"] = true
L["%player% interrupted %target%\'s %target_spell%!"] = true
L["%player% is casting %spell%, please assist!"] = true
L["%player% is handing out cookies, go and get one!"] = true
L["%player% puts %spell%"] = true
L["%player% used %spell%"] = true
L["%player% casted %spell%, today's special is Anchovy Pie!"] = true
L["OMG, wealthy %player% puts %spell%!"] = true
L["%player% opened %spell%!"] = true
L["%player% casted %spell% -> %target%"] = true
L["I taunted %target% successfully!"] = true
L["I failed on taunting %target%!"] = true
L["My %pet_role% %pet% taunted %target% successfully!"] = true
L["My %pet_role% %pet% failed on taunting %target%!"]= true
L["%player% taunted %target% successfully!"] = true
L["%player% failed on taunting %target%!"] = true
L["%player%\'s %pet_role% %pet% taunted %target% successfully!"] = true
L["%player%\'s %pet_role% %pet% failed on taunting %target%!"] = true
L["I taunted all enemies in 10 yards!"] = true
L["%player% taunted all enemies in 10 yards!"] = true
L["%target%, thank you for using %spell% to revive me. :)"] = true
L["Thanks all!"] = true

-- Armory
L["Armory"] = true
L["ARMORY_DESC"] = [[The |cfff960d9KlixUI|r Armory Mode only works with the current Expansion from World of Warcraft. The following results may occur:

- Socket warnings are displayed wrong on old items.
- Enchants could displayed wrong or not at all.

As of version 1.57 the |cfff960d9KlixUI|r Armory Mode will now function together with the simple armory mode from default ElvUI.
Enabling the simple armory mode from default ElvUI will result in:

- itemlevel display from the |cfff960d9KlixUI|r Armory Mode will not display.
- Indicators such as socket and enchant from the |cfff960d9KlixUI|r Armory Mode will be disabled.
]] -- that extra section is meant to be there!
L["Enable/Disable the |cfff960d9KlixUI|r Armory Mode."] = true
L["Azerite Buttons"] = true
L["Enable/Disable the Azerite Buttons on the character window."] = true
L["Naked Button"] = true
L["Enable/Disable the Naked Button on the character window."] = true
L["Class Crests"] = true
L["Shows an overlay of the class crests on the character window."] = true
L["Durability"] = true
L["Enable/Disable the display of durability information on the character window."] = true
L["Damaged Only"] = true
L["Only show durability information for items that are damaged."] = true
L["Itemlevel"] = true -- doesnt work
L["Enable/Disable the display of item levels on the character window."] = true
L["Level"] = true
L["Full Item Level"] = true
L["Show both equipped and average item levels."] = true
L["Item Level Coloring"] = true
L["Color code item levels values. Equipped will be gradient, average - selected color."] = true
L["Color of Average"] = true
L["Sets the color of average item level."] = true
L["Only Relevant Stats"] = true
L["Show only those primary stats relevant to your spec."] = true
L["Categories"] = true
L["Indicators"] = true
L["Enchant"] = true
L["Shows an indictor for enchanted/not enchanted items."] = true
L["Glow Indicator"] = true
L["Shows a glow indicator of not enchanted items only."] = true
L["Socket"] = true
L["Shows an indictor for socketed/unsocketed items."] = true
L["Shows a glow indictor for unsocketed items only."] = true
L["Transmog"] = true
L["Shows an arrow indictor for currently transmogrified items."] = true
L["Illusion"] = true
L["Shows an indictor for weapon illusions."] = true
L["Gradient"] = true
L["Value"] = true
L["Background"] = true
L["Select Image"] = true
L["Overlay"] = true
L["Custom Image Path"] = true
L["Shows the Icy-Veins stats pane on the character window.\n|cffff8000Note: Recommended stats pulled from Icy-Veins.com the 09th of Februrary.|r"] = true
L["Height"] = true
L["Position"] = true
L["Custom Text"] = true
L["Add, remove and edit the text on the stats panel to your preference."] = true
L["If you want to retoggle the stats panel, please do a reload or relog."] = true
-- AzeriteButtons
L["Open head slot azerite powers."] = true
L["Open shoulder slot azerite powers."] = true
L["Open chest slot azerite powers."] = true
L["Equipped head is not an Azerite item."] = true
L["No head item is equipped."] = true
L["Equipped shoulder is not an Azerite item."] = true
L["No shoulder item is equipped."] = true
L["Equipped chest is not an Azerite item."] = true
L["No chest item is equipped."] = true

-- Bags
L["Transparent Slots"] = true
L["Apply transparent template on bag and bank slots."] = true
L["Bag Filter"] = true
L["Enable/disable the bagfilter button."] = true
L["Toggle Filter Bar"] = true
L["Auto Open Containers"] = true
L["Enable/disable the auto opening of container, treasure etc."] = true
L["Item Selection"] = true
L["The item selection module allows deletion / vendoring of multiple items at once."] = true
L["Display Progress Frame"] = true
L["List Processed Items"] = true
L["Process Interval"] = true
L["The delay between processing items, e.g. between items being deleted."] = true
L["Quest Items"] = true
L["Process Quest Items"] = true
L["Toggle whether Quest Items should be deleted/sold. Quest Items with sell value are usually related to repeatable quests."] = true
L["Never process"] = true
L["Merchant only"] = true
L["Process if sellable"] = true
L["Always process"] = true
L["BoE Items"] = true
L["Process BoE Items"] = true
L["Toggle when you wish BoEs to be handled when processing items."] = true
L["Threshold for BoEs"] = true
L["Set the threshold for which BoE items should be processed."] = true
L["Process If Missing Appearance"] = true
L["Process items even if we haven't unlocked their appearance."] = true
L["Crafting Reagents"] = true
L["Process Crafting Reagents"] = true
L["|cff00FF00Enabled|r"] = true
L["|cffFF0000Disabled|r"] = true
L["|cffffffffClick to vendor grays. Shift-Click to activate item\nselection for vendoring. Currently:|r %s"] = true
L["Processing selected items:"] = true
L["No deletable items were found, please check your configuration."] = true
L["Skipping %s due to missing appearance."] = true
L["%s (%d), vendor value: %s."] = true
L["Deleted the selected %d items."] = true
L["Vendored selected items for %s."] = true
L["Select start and end slots, everything in between them will be vendored, including the items at selected slots."] = true

-- Blizzard
L["Blizzard"] = true
L["Raid Utility Mouse Over"] = true
L["Enabling mouse over will make ElvUI's raid utility show on mouse over instead of always showing."] = true
L["Error Frame"] = true
L["Width"] = true
L["Set the width of Error Frame. Too narrow frame may cause messages to be split in several lines"] = true
L["Height"] = true
L["Set the height of Error Frame. Higher frame can show more lines at once."] = true
L["Move Blizzard frames"] = true
L["Allow some Blizzard frames to be moved around."] = true
L["Remember"] = true
L["Remember positions of frames after moving them."] = true

-- Chat
L['Chat'] = true
L['Chat Tabs'] = true
L["Selected Indicator"] = true
L["Shows you which of your docked chat tabs which is currently selected."] = true
L["Style"] = true
L['Fade Chat Tabs'] = true
L['Fade out chat tabs except the currently selected chat tab.'] = true
L['Chat Tab Alpha'] = true
L['Alpha of faded chat tabs.'] = true
L['Force to Show'] = true
L['Force a tab to show when it is flashing. This works both for when chat panel backdrop is hidden and when chat tab is faded.'] = true
L['Force Show Threshold'] = true
L['Threshold before a faded chat tab is forced to show. If a faded chat tab alpha is less than or equal to this value then it will be forced to show.'] = true
L['Force Show Alpha'] = true
L['Alpha of a chat tab when it is forced to show.'] = true
L["Chat Separators"] = true
L["Chat Tab Separators"] = true
L["Add a thin black line below chat tabs to separate them from chat messages."] = true
L["Chat Datatext Separators"] = true
L["Add a thin black line above chat datatexts to separate them from chat messages."] = true
L["Right-Click Menu"] = true
L["Enhances the chat character right-click menu with new features."] = true
L["Get Name"] = true
L["Query Detail"] = true
L["Guild Invite"] = true
L["Add Friend"] = true
L["Report MyStats"] = true
L["has come |cff298F00online|r."] = true
L["has gone |cffff0000offline|r."] = true
L[" has come |cff298F00online|r."] = true
L[" has gone |cffff0000offline|r."] = true
L["|cfff960d9GMOTD:|r %s"] = true

-- CombatText
L["Combat Text"] = true
L["Disable Blizzard FCT"] = true
L["Personal SCT"] = true
L["Also show numbers when you take damage on your personal nameplate or in the center of the screen."] = true
L["Animations"] = true
L["Default"] = true
L["Criticals"] = true
L["Miss/Parry/Dodge/etc."] = true
L["Personal SCT Animations"] = true
L["Appearance/Offsets"] = true
L["Font Shadow"] = true
L["Use Damage Type Color"] = true
L["Default Color"] = true
L["Has soft min/max, you can type whatever you'd like into the editbox tho."] = true
L["X-Offset Personal SCT"] = true
L["Y-Offset Personal SCT"] = true
L["Only used if Personal Nameplate is Disabled."] = true
L["Text Formatting"] = true
L["Truncate Number"] = true
L["Condense combat text numbers."] = true
L["Show Truncated Letter"] = true
L["Comma Seperate"] = true
L["e.g. 100000 -> 100,000"] = true
L["Icon"] = true
L["Size"] = true
L["Start Alpha"] = true
L["Use Seperate Off-Target Text Appearance"] = true
L["Off-Target Text Appearance"] = true
L["Sizing Modifiers"] = true
L["Embiggen Crits"] = true
L["Embiggen Crits Scale"] = true
L["Embiggen Miss/Parry/Dodge/etc."] = true
L["Embiggen Miss/Parry/Dodge/etc. Scale"] = true
L["Scale Down Small Hits"] = true
L["Small Hits Scale"] = true

-- Cooldowns
L["Cooldowns"] = true
L["Dimishing Returns"] = true
L["DR_DESC"] = [[This section will display dimishing returns icons next to the arena frames.
Icon border color explanation:

- |cffffff00Yellow color|r = Half Duration
- |cffff7f00Orange color|r = Quarter Duration
- |cffff0000Red color|r = Immune

|cffff8000Note: You can either type "/testdr" or "/tdr" without the quotes, to display the icons.|r
]] -- that extra section is meant to be there!
L["Cooldown Text"] = true
L["EC_DESC"] = [[This section will display enemy cooldown icons next at the target frame location (can be moved).

|cffff8000Note: You can either type "/testecd" or "/tecd" without the quotes, to display the icons.|r
]] -- that extra section is meant to be there!
L["Border Color"] = true
L["Sets the border color to either dimishing return or classic ElvUI.\n |cffff8000Note: If using the dimishing return border color the shadow overlay will slightly overlap the border color.|r"] = true
L["Direction"] = true
L["Show Always"] = true
L["Show the enemy cooldown spells in every related instance types."] = true
L["Show In PvP"] = true
L["Show the enemy cooldown spells in battlegrounds."] = true
L["Show In Arena"] = true
L["Show the enemy cooldown spells in arenas."] = true
L["Pulse"] = true
L["Icon Size"] = true
L["Fadein duration"] = true
L["Fadeout duration"] = true
L["Transparency"] = true
L["Duration time"] = true
L["Animation size"] = true
L["Display spell name"] = true
L["Watch on pet spell"] = true
L["Test"] = true

-- Databars
L["DataBars"] = true
L["Enable/Disable the |cfff960d9KlixUI|r DataBar color mod."] = true
L["|cfff960d9KlixUI|r Style"] = true
L["Capped"] = true
L["Replace XP text with the word 'Capped' at max level."] = true
L["Blend Progress"] = true
L["Progressively blend the bar as you gain XP."] = true
L["XP Color"] = true
L["Select your preferred XP color."] = true
L["Rested Color"] = true
L["Select your preferred rested color."] = true
L["Reputation Bar"] = true
L["Replace rep text with the word 'Capped' or 'Paragon' at max."] = true
L["Progressively blend the bar as you gain reputation."] = true
L["Auto Track Reputation"] = true
L["Automatically change your watched faction on the reputation bar to the faction you got reputation points for."] = true
L["'Paragon' Format"] = true
L["If 'Capped' is toggled and watched faction is a Paragon then choose short or long."] = true
L["P"] = true
L["Paragon"] = true
L["Progress Colour"] = true
L["Change rep bar colour by standing."] = true
L["Paragon"] = true
L["PREP_DESC"] = [[This feature changes how the paragon reputation bar looks like in the reputation tab.]]
L["Exalted"] = true
L["Current"] = true
L["Value"] = true
L["Deficit"] = true
L["Reputation Colors"] = true
L["Honor Bar"] = true
L["Progressively blend the bar as you gain honor."] = true
L["Honor Color"] = true
L["Change the honor bar color."] = true
L["Azerite Bar"] = true
L["Progressively blend the bar as you gain Azerite Power"] = true
L["Azerite Color"] = true
L["Change the Azerite bar color"] = true
L["Quest XP"] = true
L["QXP_DESC"] = [[Adds an overlay to the XP bar to show how much potential experience is in your quest log while leveling to get an idea of how much XP you will get once the quest is turned in.]]
L["Enable/Disable the QuestXP overlay on the experiencebar."] = true
L["Overlay Color"] = true
L["Include Incomplete Quests"] = true
L["Current Zone Quests Only"] = true

-- Datatext
L["DataTexts"] = true
L["DT_DESC"] = [[This module provides alot of different new features for the datatexts.

|cffff8000You can change all datatexts on the fly by 'CTRL + ALT + Right click' on a visible datatext. This will bring up an option menu with all the current available datatexts to choose from.|r]]
L["Left ChatTab Panel"] = true
L["Show/Hide the left ChatTab DataTexts"] = true
L["Right ChatTab Panel"] = true
L["Show/Hide the right ChatTab DataTexts"] = true
L["Panels"] = true
L["Chat Datatext Panel"] = true
L['Panel Transparency'] = true
L['Chat EditBox Position'] = true
L['Position of the Chat EditBox, if datatexts are disabled this will be forced to be above chat.'] = true
L['Below Chat'] = true
L['Above Chat'] = true
L["Frame Strata"] = true
L['Backdrop'] = true
L['Game Menu Dropdown Color'] = true
L["Middle Datatext Panel"] = true
L['Show/Hide the Middle DataText Panel.'] = true
L["Width"] = true
L["Height"] = true
L["Other DataTexts"] = true
L["System Datatext"] = true
L["Max Addons"] = true
L["Maximum number of addons to show in the tooltip."] = true
L["Announce Freed"] = true
L["Announce how much memory was freed by the garbage collection."] = true
L["Show FPS"] = true
L["Show FPS on the datatext."] = true
L["Show Memory"] = true
L["Show total addon memory on the datatext."] = true
L["Show Latency"] = true
L["Show latency on the datatext."] = true
L["Latency Type"] = true
L["Display world or home latency on the datatext. Home latency refers to your realm server. World latency refers to the current world server."] = true
L["Home"] = true
L["World"] = true
L["Time Datatext"] = true
L["Time Size"] = true
L["Change the size of the time datatext individually from other datatexts."] = true
L["Date Condensed"] = true
L["Display a condensed version of the current date."] = true
L["Invasions"] = true
L["Display upcomming and current Legion and BfA invasions in the time datatext tooltip."] = true
L["Faction Assault:"] = true
L["Legion Invasion:"] = true
L["Current: "] = true
L["Next: "] = true
L["Missing invasion info on your realm."] = true
L["Time Played"] = true
L["Display session, level and total time played in the time datatext tooltip."] = true
L["Session:"] = true
L["Previous Level:"] = true
L["Account Time Played:"] = true
L["Account Time Played data has been reset!"] = true
L["Left Click:"] = true
L["Toggle Map & Quest Log frame"] = true
L["Shift + Left Click:"] = true
L["Reset account time played data"] = true
L["Right Click:"] = true
L["Toggle Calendar frame"] = true
L["Professions Datatext"] = true
L["Professions"] = true
L["Select which profession to display."] = true
L["Show Hint"] = true
L["Show the hint in the tooltip."] = true
L["No Profession"] = true
L["Mining"] = true
L["Smelting"] = true
L["Open "] = true
L["Titles Datatext"] = true
L["Use Character Name"] = true
L["Use your character's class color and name in the tooltip."] = true
L["ElvUI DataTexts"] = true
L["Order of each toon. Smaller numbers will go first"] = true
L["Currency"] = true
L["Show Archaeology Fragments"] = true
L["Show Jewelcrafting Tokens"] = true
L["Show Player vs Player Currency"] = true
L["Show Dungeon and Raid Currency"] = true
L["Show Cooking Awards"] = true
L["Show Miscellaneous Currency"] = true
L["Show Zero Currency"] = true -- ??
L["Show Icons"] = true
L["Show Faction Totals"] = true
L["Show Unused Currencies"] = true
L["Delete character info"] = true
L["Remove selected character from the stored gold values"] = true
L["Are you sure you want to remove |cff1784d1%s|r from currency datatexts?"] = true
L["Gold Sorting"] = true
L["Sort Direction"] = true
L["Normal"] = true
L["Reversed"] = true
L["Sort Method"] = true
L["Amount"] = true
L["Currency Sorting"] = true
L["Direction"] = true
L["Tracked"] = true
L["KlixUI DataTexts"] = true

-- Enhanced Friendslist
L["Enhanced Friends List"] = true
L["Name Font"] = true
L["Info Font"] = true
L["Game Icon Pack"] = true
L["Status Icon Pack"] = true
L["Game Icon Preview"] = true
L["Diablo 3"] = true
L["Hearthstone"] = true
L["Starcraft"] = true
L["Starcraft 2"] = true
L["App"] = true
L["Mobile"] = true
L["Hero of the Storm"] = true
L["Overwatch"] = true
L["Destiny 2"] = true
L["Call of Duty 4"] = true
L["Status Icon Preview"] = true

-- Equip Manager
L["Timewalking"] = true
L["No Change"] = true
L["Equip this set when switching to specialization %s."] = true
L["Equip this set for open world/general use."] = true
L["Equip this set after entering dungeons or raids."] = true
L["Equip this set after enetering a timewalking dungeon."] = true
L["Equip this set after entering battlegrounds or arens."] = true
L["Equipment Manager"] = true
L["EM_DESC"] = [[This module provides different options to automatically change your equipment sets on spec change or entering certain locations.

|cffff8000All options are character based.|r
]] -- that extra section is meant to be there!
L["Enable/Disable the Equipment Manager and the all character window texts."] = true
L["Equipment Set Overlay"] = true
L["Show the associated equipment sets for the items in your bags (or bank)."] = true
L["Block button"] = true
L["Create a button in the character window to allow temporary blocking of auto set swap."] = true
L["Ignore zone change"] = true
L["Swap sets only on specialization change ignoring location change when. Does not influence entering/leaving instances and bg/arena."] = true
L["Equipment conditions"] = true

-- Equip Manager unfinished/unknown
L["KUI_EM_CONDITIONS_DESC"] = [[Determines conditions under which specified sets are equipped.
This works as macros and controlled by a set of tags as seen below.]]
L["Impossible to switch to appropriate equipment set in combat. Will switch after combat ends."] = true
L["KUI_EM_LOCK_TITLE"] = [[|cfff960d9KlixUI|r]]
L["KUI_EM_LOCK_TOOLTIP"] = [[This button is designed for temporary disable
Equip Manager's auto switch gear sets.
While locked (red colored state) it will disable auto swap.]]

L["KUI_EM_SET_NOT_EXIST"] = [[Equipment set |cfff960d9%s|r doesn't exist!]]
L["KUI_EM_TAG_INVALID"] = [[Invalid tag: %s]]
L["KUI_EM_TAG_INVALID_TALENT_TIER"] = [[Invalid argument for talent tag. Tier is |cfff960d9%s|r, should be from 1 to 7.]]
L["KUI_EM_TAG_INVALID_TALENT_COLUMN"] = [[Invalid argument for talent tag. Column is |cfff960d9%s|r, should be from 1 to 3.]]
L["KUI_EM_TAG_DOT_WARNING"] = [[Wrong separator for conditions detected. You need to use commas instead of dots.]]

L["KUI_EM_TAGS_HELP"] = [[Following tags and parameters are eligible for setting equip condition:
|cfff960d9solo|r - when you are solo without any group;
|cfff960d9party|r - when you are in a group of any description. Can be of specified size, e.g. [party:4] - if in a group of total size 4;
|cfff960d9raid|r - when you are in a raid group. Can be of specified size like party option;
|cfff960d9spec|r - specified spec. Usage [spec:<number>] number is the index of desired spec as seen in spec tab;
|cfff960d9talent|r - specified talent. Usage [talent:<tier>/<column>] tier is the row going from 1 on lvl 15 to 7 and lvl 100, column is the column in said row from 1 to 3;
|cfff960d9instance|r - if in instance. Can be of specified instance type - [instance:<type>]. Types are party, raid and scenario. If not specified will be true for any instance;
|cfff960d9pvp|r - if on BG, arena or world pvp area. Available arguments: pvp, arena;
|cfff960d9difficulty|r - defines the difficulty of the instance. Arguments are: normal, heroic, lfr, challenge, mythic;

Example: [solo] Set1; [party:4, spec:3] Set2; [instance:raid, difficulty:heroic] Set3
]]

-- Location Panel
L["Location Panel"] = true
L["Link Position"] = true
L["Allow pasting of your coordinates in chat editbox via holding shift and clicking on the location name."] = true
L["Template"] = true
L["Transparent"] = true
L["NoBackdrop"] = true
L["Auto Width"] = true
L["Change width based on the zone name length."] = true
L["Spacing"] = true
L["Update Throttle"] = true
L["The frequency of coordinates and zonetext updates. Check will be done more often with lower values."] = true
L["Hide In Combat"] = true
L["Hide In Orderhall"] = true
L["Hide Blizzard Zone Text"] = true
L["Mouse Over"] = true
L["The frame is not shown unless you mouse over the frame"] = true
L["Change the alpha level of the frame."] = true
L["Show additional info in the Location Panel."] = true
L['None'] = true
L['Battle Pet Level'] = true
L["Location"] = true
L["Full Location"] = true
L["Color Type"] = true
L["Reaction"] = true
L["Custom Color"] = true
L["Coordinates"] = true
L["Format"] = true
L["Hide Coords"] = true
L["Show/Hide the coord frames"] = true
L["Hide Coords in Instance"] = true
L["Fonts"] = true
L["Font Size"] = true
L["Relocation Menu"] = true
L["Right click on the location panel will bring up a menu with available options for relocating your character (e.g. Hearthstones, Portals, etc)."] = true
L["Custom Width"] = true
L["By default menu's width will be equal to the location panel width. Checking this option will allow you to set own width."] = true
L["Justify Text"] = true
L["Left"] = true
L["Middle"] = true
L["Right"] = true
L["CD format"] = true
L["Hearthstone Location"] = true
L["Show the name on location your Heathstone is bound to."] = true
L["Show hearthstones"] = true
L["Show hearthstone type items in the list."] = true
L["Hearthstone Toys Order"] = true
L["Show Toys"] = true
L["Show toys in the list. This option will affect all other display options as well."] = true
L["Show spells"] = true
L["Show relocation spells in the list."] = true
L["Show engineer gadgets"] = true
L["Show items used only by engineers when the profession is learned."] = true
L["Ignore missing info"] = true -- ??
L["Show/Hide tooltip"] = true
L["Combat Hide"] = true
L["Hide tooltip while in combat."] = true
L["Show Hints"] = true
L["Enable/Disable hints on Tooltip."] = true
L["Enable/Disable status on Tooltip."] = true
L["Enable/Disable level range on Tooltip."] = true
L["Area Fishing level"] = true
L["Enable/Disable fishing level on the area."] = true
L["Battle Pet level"] = true
L["Enable/Disable battle pet level on the area."] = true
L["Recommended Zones"] = true
L["Enable/Disable recommended zones on Tooltip."] = true
L["Zone Dungeons"] = true
L["Enable/Disable dungeons in the zone, on Tooltip."] = true
L["Recommended Dungeons"] = true
L["Enable/Disable recommended dungeons on Tooltip."] = true
L["with Entrance Coords"] = true
L["Enable/Disable the coords for area dungeons and recommended dungeon entrances, on Tooltip."] = true
L["Enable/Disable the currencies, on Tooltip."] = true
L["Enable/Disable the professions, on Tooltip."] = true
L["Hide capped"] = true
L["Hides a profession when the player reaches its highest level."] = true
L["Hide Raid"] = true
L["Show/Hide raids on recommended dungeons."] = true
L["Hide PvP"] = true
L["Show/Hide PvP zones, Arenas and BGs on recommended dungeons and zones."] = true
L["KUI_LOCPANEL_IGNOREMISSINGINFO"] = [[Due to how client functions some item info may become unavailable for a period of time. This mostly happens to toys info.
When called the menu will wait for all information being available before showing up. This may resul in menu opening after some concidarable amount of time, depends on how fast the server will answer info requests.
By enabling this option you'll make the menu ignore items with missing info, resulting in them not showing up in the list.]]

-- Maps
L["Maps"] = true
L["Garrison Button Style"] = true
L["Change the look of the Garrison/OrderHall/BfA Mission Button"] = true
L["LFG Button Style"] = true
L["Change the look of the looking for group Button"] = true
L["Minimap Glow"] = true
L["Shows the minimap glow when a mail or a calendar invite is available."] = true
L["Always Display Glow"] = true
L["Always display the minimap glow."] = true
L["Hide minimap while in combat."] = true
L["FadeIn Delay"] = true
L["The time to wait before fading the minimap back in after combat hide. (0 = Disabled)"] = true
L["Mail"] = true
L["Enhanced Mail"] = true
L["Shows the enhanced mail tooltip and styling (Icon, color, and blink animation)."] = true
L['You have about %s unread mails'] = true
L['You have about %s unread mail'] = true
L[' from:'] = true
L["Play Sound"] = true
L["Plays a sound when a mail is received.\n|cffff8000Note: This will be disabled by default if notifcations or notification mail module is enabled.|r"] = true
L["Hide Mail Icon"] = true
L["Hide the mail Icon on the minimap."] = true
L["Bar Backdrop"] = true
L["Button Spacing"] = true
L["Buttons Per Row"] = true
L["Blizzard"] = true
L["Move Tracker Icon"] = true
L["Move Queue Status Icon"] = true
L["Move Mail Icon"] = true
L["Hide Garrison Icon"] = true
L["Move Garrison Icon"] = true
L["Minimap Ping"] = true
L["Shows the name of the player who pinged on the Minimap."] = true
L["Center"] = true
L["Enable/Disable Square Minimap Coords."] = true
L["Coords Display"] = true
L["Change settings for the display of the coordinates that are on the minimap."] = true
L["Minimap Mouseover"] = true
L["Always Display"] = true
L["Coords Location"] = true
L["This will determine where the coords are shown on the minimap."] = true
L["Cardinal Points"] = true
L["Places cardinal points on your minimap (N, S, E, W)"] = true
L["North"] = true
L["Places the north cardinal point on your minimap."] = true
L["East"] = true
L["Places the east cardinal point on your minimap."] = true
L["South"] = true
L["Places the south cardinal point on your minimap."] = true
L["West"] = true
L["Places the west cardinal point on your minimap."] = true
L["Worldmap"] = true
L["World Map Frame Size"] = true
L["World Map Frame Fade"] = true
L["World Map Frame Zoom"] = true
L["Mouse scroll on the world map to zoom."] = true
L["Reveal"] = true
L["Reveal all undiscovered areas on the world map."] = true
L["Set an overlay tint on unexplored ares on the world map."] = true
L["Enhanced World Quests"] = true
L["Enhances the regular world quests pins on the world map."] = true
L["Flight Queue"] = true
L["Location Digits"] = true
L["Change the decimals of the coords on the location bar."] = true
L["Location Text"] = true
L["Change the text on the location bar."] = true
L["Version"] = true
L["Minimap Mouseover"] = true
L["Always Display"] = true
L["Above Minimap"] = true
L["Hide"] = true

-- Misc
L['Miscellaneous'] = true
L["Display the Guild Message of the Day in an extra window, if updated.\nCredit: |cffff7d0aMerathilisUI|r"] = true
L["Mover Transparency"] = true
L["Changes the transparency of all the movers."] = true
L["Buy Max Stack"] = true
L["Alt-Click on an item, sold buy a merchant, to buy a full stack."] = true
L["Hide TalkingHeadFrame"] = true
L["Flight Master's Whistle Location"] = true
L["Show the nearest Flight Master's Whistle Location on the minimap and in the tooltip."] = true
L["Flight Master's Whistle Sound"] = true
L["Plays a sound when you use the Flight Master's Whistle."] = true
L["Loot container opening sound"] = true
L["Plays a sound when you open a container, chest etc."] = true
L["Transmog Remover Button"] = true
L["Enable/Disable the transmog remover button in the transmogrify window."] = true
L["Leader Change Sound"] = true
L["Plays a sound when you become the group leader."] = true
L["Missing Seat Indicators"] = true
L["Add a seat indicator, to passenger mounts without an indicator, e.g. The Hivemind, Sandstone Drake, Heart of the Nightwing and Travel Form."] = true
L["Cursor Flash"] = true
L["Shows a flashing star as the cursor trail."] = true
L["Change the alpha level of the cursor trail."] = true
L["Change how/when the cursor trail is shown."] = true
L["Already Known"] = true
L["Display a color overlay of already known/learned items."] = true
L["Overlay Color"] = true
L["AFK Pet Model"] = true
L["Companion Pet Name"] = true
L["Model Scale"] = true
L["Some pets will appear huge. Lower the scale when that happens."] = true
L["Model Facing Direction"] = true
L["Less than 0 faces the model to the left, more than 0 faces the model to the right"] = true
L["Animation"] = true
L["NPC animations are not documented anywhere, and as such you will just have to try out various settings until you find the animation you want. Default animation is 0 (idle)"] = true
L["Announce Combat Status"] = true
L["Announce combat status in a textfield in the middle of the screen.\nCredit: |cffff7d0aMerathilisUI|r"] = true
L["Announce Skill Gains"] = true
L["Announce skill gains in a textfield in the middle of the screen.\nCredit: |cffff7d0aMerathilisUI|r"] = true
L["Merchant"] = true
L["Display the MerchantFrame in one window instead of a small one with variouse amount of pages."] = true
L["Subpages"] = true
L["Subpages are blocks of 10 items. This option set how many of subpages will be shown on a single page."] = true
L["Display the item level on the MerchantFrame."] = true
L["EquipSlot"] = true
L["Display the equip slot on the MerchantFrame."] = true
L["Bloodlust"] = true
L["Sound"] = true
L["Play a sound when bloodlust/heroism is popped."] = true
L["Print a chat message of whom who popped bloodlust/heroism."] = true
L["Sound Type"] = true
L["Horde"] = true
L["Alliance"] = true
L["Illidan"] = true
L["Sound Override"] = true
L["Force to play even when other sounds are disabled."] = true
L["Use Custom Volume"] = true
L["Use custom volume.\n|cffff8000Note: This will only work if 'Sound Override' is enabled.|r"] = true
L["Volume"] = true
L["Custom Sound Path"] = true
L["Example of a path string: path\\path\\path\\sound.mp3"] = true
L["Easy Curve"] = true
L["Enable/disable the Easy Curve popup frame."] = true
L["Default Highest Achievements Found"] = true
L["Override Defaults"] = true
L["Enable Override"] = true
L["Overrides the default achievements found and will always send the selected achievement from the dropdown."] = true
L["Search Achievements"] = true
L["Search term must be greater than 3 characters."] = true
L["Error: Search term must be greater than 3 characters"] = true
L["Select Override Achievement"] = true
L["Results are limited to 500 and only completed achievemnts. Please try a more specific search term if you cannot find the achievement listed."] = true
L["Error: Please select an achievement"] = true
L["Other Options"] = true
L["Always Check Achievement Whisper Dialog Checkbox"] = true
L["This will always check the achievement whisper dialog checkbox when signing up for a group by default."] = true
L["Always Check Keystone Whisper Dialog Checkbox"] = true
L["This will always check the keystone whisper dialog checkbox when signing up for a mythic plus group by default."] = true
L["There was an error sending your whisper."] = true
L["Automatization"] = true
L["Auto Keystones"] = true
L["Automatically insert keystones when you open the keystonewindow in a dungeon."] = true
L["Auto Gossip"] = true
L["This setting will auto gossip some NPC's.\n|cffff8000Note: Holding down any modifier key before visiting/talking to the respective NPC's will briefly disable the automatization.|r"] = true
L["Auto Auction"] = true
L["Shift + Right-Click to auto buy auctions at the auctionhouse."] = true
L["Skip Azerite Animations"] = true
L["Skips the reveal animation of a new azerite armor piece and the animation after you select a trait."] = true
L["Teleportation"] = true
L["Automatically reequips your last item, after using an item, with teleportation feature."] = true
L["Work Orders"] = true
L["WO_DESC"] = [[This module will auto start any workorders in any legion class order hall, alliance/horde ship in battle for azeroth and Nomi work orders.

|cffff8000Note: Holding down any modifier key before visiting/talking to the respective NPC's will briefly disable the automatization.|r
]] -- that extra section is meant to be there!
L["OrderHall/Ship"] = true
L["Auto start orderhall/ship workorders when visiting the npc."] = true
L["Nomi"] = true
L["Auto start workorders when visiting Nomi."] = true
L["Invite"] = true
L["Auto Invite Keyword"] = true
L["Invite Rank"] = true
L["Refresh Rank"] = true
L["Start Invite"] = true
L["KUI_INVITEGROUP_MSG"] = "Members of order %s will be invited into the group after 10 seconds."
L["Screenshot"] = true
L["Auto screenshot when you get an achievement."] = true
L["Screen Format"] = true
L["Screen Quality"] = true
L["Role Check"] = true
L["Automatically accept all role check popups."] = true
L["Confirm Role Checks"] = true
L["After you join a custom group finder raid a box pops up telling you your role and won't dissapear until clicked, this gets rid of it."] = true
L["Automatically accept timewalking role check popups."] = true
L["Love is in the Air"] = true
L["Automatically accept Love is in the Air dungeon role check popups."] = true
L["Halloween"] = true
L["Automatically accept Halloween dungeon role check popups."] = true
L['Top Panel'] = true
L["Display a panel across the top of the screen. This is for cosmetic only."] = true
L['Bottom Panel'] = true
L["Display a panel across the bottom of the screen. This is for cosmetic only."] = true
L["Scrap Machine"] = true
L["Show the scrapbutton at the scrappingmachineUI."] = true
L["Place scrap button at the top or the bottom of the scrappingmachineUI."] = true
L["Equipment Sets"] = true
L["Ignore items in equipment sets."] = true
L["Ignore azerite items."] = true
L["Bind-on-Equipped"] = true
L["Ignore bind-on-equipped items."] = true
L["Equipped Item Level"] = true
L["Don't insert items above equipped iLvl."] = true
L["Item Print"] = true
L["Print inserted scrap items to the chat window."] = true
L["Specific Item Level"] = true
L["Ignore items above specific item level."] = true
L["Auto Open Bags"] = true
L["Auto open bags when visiting the scrapping machine."] = true
L["Character Zoom"] = true
L["Zoom Increment"] = true
L["Adjust the increment the camera will follow behind you."] = true
L["Zoom Speed"] = true
L["Adjust the zoom speed the camera will follow behind you."] = true
L["AutoLog"] = true
L["Enable/disable automatically combat logging."] = true
L["All raids"] = true
L["Combat log all raids regardless of individual raid settings"] = true
L["Display in chat"] = true
L["Display the combat log status in the chat window"] = true
L["5 player heroic instances"] = true
L["Combat log 5 player heroic instances"] = true
L["5 player challenge mode instances"] = true
L["Combat log 5 player challenge mode instances"] = true
L["5 player mythic instances"] = true
L["Combat log 5 player mythic instances"] = true
L["Minimum level"] = true
L["Logging will not be enabled for mythic levels lower than this"] = true
L["LFR Raids"] = true
L["Raid finder instances where you want to log combat"] = true
L["Normal Raids"] = true
L["Raid instances where you want to log combat"] = true
L["Heroic Raids"] = true
L["Raid instances where you want to log combat"] = true
L["Mythic Raids"] = true
L["Raid instances where you want to log combat"] = true
L["Confirm Static Popups"] = true
L["CSP_DESC"] = [[This modules auto accept many static popups found in WoW.
If a popup isn't auto accepted it may be due to:

- The popup is protected by blizzard and will cause a taint if called.
- You need to take action, yourself, in the popup before accepting e.g. Guildbank deposit.
- 3rd party addons custom popups.
- Popup is not added to the code yet, please join my discord and contact me to add it.
- The popup is simply not enabled in my config option.

|cffff8000Note: You can hold down any modifier key before a popup pops to disable the auto acceptance temporarily!|r
]] -- that extra section is meant to be there!
L["Automatically accept various static popups encountered in-game."] = true
L["Auto Answer"] = true
L["REQUEST"] = [[- static popup not supported, if you want it added to the UI, please post it in my discord: ]]
L["NOTENABLED"] = [[- static popup not enabled in the options.]]
L["PvP"] = true
L["KillStreak Sounds"] = true
L["Unreal Tournament sound effects for killing blow streaks."] = true
L["Automatically release body when killed inside a battleground."] = true
L["Check for rebirth mechanics"] = true
L["Do not release if reincarnation or soulstone is up."] = true
L["Automatically cancel PvP duel requests."] = true
L["Automatically cancel pet battles duel requests."] = true
L["Announce"] = true
L["Announce in chat if duel was rejected."] = true
L["Show your PvP killing blows as a popup."] = true
L["KB Sound"] = true
L["Play sound when killing blows popup is shown."] = true

-- Notification
L["Notification"] = true
L["NOTIFY_DESC"] = [[Here can you control which notifications that should be displayed.

|cffff8000Note: You can either type "/testnotification" or "/tn" without the quotes, to show a test notification.|r
]] -- that extra section is meant to be there!
L["Here you can enable/disable the different notification types."] = true
L["Raid Disabler"] = true
L["Enable/disable the notification toasts while in a raid group."] = true
L["No Sounds"] = true
L["Enable/disable the sound effect of the notification toasts."] = true
L["Chat Message"] = true
L["Enable/disable the notification message in chat."] = true
L["Mail"] = true
L["Vignette"] = true
L["If a Rare Mob or a treasure gets spotted on the minimap."] = true
L["Invites"] = true
L["Guild Events"] = true
L["Quick Join Notification"] = true
L["This is an example of a notification."] = true
L["You have a new mail!"] = true
L["%s slot needs to repair, current durability is %d."] = true
L["You have %s pending calendar |4invite:invites;."] = true
L["You have %s pending guild |4event:events;."] = true
L["has appeared on the MiniMap!"] = true
L["is looking for members"] = true
L["joined a group"] = true
L["joined a group "] = true

-- Professions
L["Profession Tabs"] = true
L["Creates tabs next to the profession window, similar to the spellbook tabs, for easy access to all your profession."] = true
L["Deconstruct Mode"] = true
L["Create a button in your bag frame to switch to deconstruction mode allowing you to easily disenchant/mill/prospect and pick locks."] = true
L["Sets style of glow around item available for deconstruction while in deconstruct mode. Autocast is less intense but also less noticeable."] = true
L["Actionbar Proc"] = true
L["Actionbar Autocast"] = true
L["Pixel"] = true
L["Show Glow On Bag Button"] = true
L["Show glow on the deconstruction button in bag when deconstruction mode is enabled.\nApplies on next mode toggle."] = true
L["Enchant Scroll Button"] = true
L["Create a button for applying selected enchant on the scroll."] = true
L["PROF_DESC_GLOBAL"] = [[Following options are global and will be applied to all characters on account.]]
L["Deconstruction Ignore"] = true
L["Items listed here will be ignored in deconstruction mode. Add names or item links, entries must be separated by comma."] = true
L["Ignore Tabards"] = true
L["Deconstruction mode will ignore tabards."] = true
L["Ignore Pandaria BoA"] = true
L["Deconstruction mode will ignore BoA weapons from Pandaria."] = true
L["Ignore Cooking"] = true
L["Deconstruction mode will ignore cooking specific items."] = true
L["Ignore Fishing"] = true
L["Deconstruction mode will ignore fishing specific items."] = true
L["Unlock In Trade"] = true
L["Apply unlocking skills in trade window the same way as in deconstruction mode for bags."] = true
L["Easy Cast"] = true
L["Allow to fish with double right-click."] = true
L["From Mount"] = true
L["Start fishing even if you are mounted."] = true
L["Apply Lures"] = true
L["Automatically apply lures."] = true
L["Re-lure Threshold"] = true
L["Time after the previous attemp to apply a lure before the next attempt will occure."] = true
L["Ignore Poles"] = true
L["If enabled will start fishing even if you don't have fishing pole equipped. Will not work if you have fish key set to \"None\"."] = true
L["Fish Key"] = true
L["Hold this button while clicking to allow fishing action."] = true
L["|cffffffffAllow you to disenchant/mill/prospect/unlock items.\nClick to toggle.\nCurrent state:|r %s"] = true
L["Scroll"] = true
L["KUI_PROF_RELURE_ERROR"] = [[Can't use lure due to threshlod. Time left: %.1f seconds.]]

--Quest
L["Quest"] = true
L["Objective Progress"] = true
L["Adds quest/mythic+ dungeon progress to the tooltip."] = true
L["Auto Pilot"] = true
L["AP_DESC"] = [[This section enables auto accepting and auto finishing various quests.

|cffff8000Note: To disable the auto pilot feature temporarily without disabling the whole module, please hold down the "CTRL-Key" before talking with an NPC.
This key can be changed in the "Disable Key" option down below.|r
]] -- that extra section is meant to be there!
L["Disable Key"] = true
L["When the specific key is down the quest automatization is disabled."] = true
L["Auto Accept Quests"] = true
L["Enable/Disable auto quest accepting"] = true
L["Auto Complete Quests"] = true
L["Enable/Disable auto quest complete"] = true
L["Dailies Only"] = true
L["Enable/Disable auto accepting for daily quests only"] = true
L["Accept PVP Quests"] = true
L["Enable/Disable auto accepting for PvP flagging quests"] = true
L["Auto Accept Escorts"] = true
L["Enable/Disable auto escort accepting"] = true
L["Enable in Raid"] = true
L["Enable/Disable auto accepting quests in raid"] = true
L["Skip Greetings"] = true
L["Enable/Disable NPC's greetings skip for one or more quests"] = true
L["Auto Select Quest Reward"] = true
L["Automatically select the quest reward with the highest vendor sell value."] = true
L["Quest Announce"] = true
L["This section enables the quest announcement module which will alert you when a quest is completed."] = true
L["No Detail"] = true
L["Instance"] = true
L["Raid"] = true
L["Party"] = true
L["Solo"] = true
L["Ignore supplies quest"] = true
L["Smart Quest Tracker"] = true
L["This section modify the ObjectiveTracker to only display your quests available for completion in your current zone."] = true
L['Untrack quests when changing area'] = true
L["Completed quests"] = true
L["Quests from other areas"] = true
L["Keep daily and weekly quest tracked"] = true
L['Sorting of quests in tracker'] = true
L["Automatically sort quests"] = true
L["Print all quests to chat"] = true
L["Print tracked quests to chat"] = true
L["Untrack all quests"] = true
L["Force update of tracked quests"] = true
L["Quest Tracker Visibility"] = true
L["Adjust the settings for the visibility of the questtracker (questlog) to your personal preference."] = true
L["Rested"] = true
L["Class Hall"] = true

-- Raidmarkers
L["Raid Markers"] = true
L["Options for panels providing fast access to raid markers and flares."] = true
L["Show/Hide raid marks."] = true
L["Restore Defaults"] = true
L["Reset these options to defaults"] = true
L["Button Size"] = true
L["Button Spacing"] = true
L["Orientation"] = true
L["Horizontal"] = true
L["Vertical"] = true
L["Reverse"] = true
L["Modifier Key"] = true
L["No tooltips"] = true
L["Raid Marker Icons"] = true
L["Choose what Raid Marker Icon Set the bar will display."] = true
L["Visibility"] = true
L["Always Display"] = true
L["Visibility State"] = true
L["Quick Mark"] = true
L["Show the quick mark dropdown when pressing the specific key combination chosen below."] = true
L["RaidMarkingButton"] = true
L["MouseButton1"] = true
L["MouseButton2"] = true
L["Auto Mark"] = true
L["Enable/Disable auto mark of tanks and healers in dungeons."] = true
L["Tank Mark"] = true
L["Healer Mark"] = true

-- Reminders
L["Reminders"] = true
L["Solo"] = true
L["Reminds you on self Buffs."] = true
L["Shows the pixel glow on missing buffs."] = true
L["Solo Reminder"] = true
L["Raid"] = true
L["Shows a frame with flask/food/rune."] = true
L["Toggles the display of the raidbuffs backdrop."] = true
L["Size"] = true
L["Changes the size of the icons."] = true
L["Change the alpha level of the icons."] = true
L["Class Specific Buffs"] = true
L["Shows all the class specific raidbuffs."] = true
L["Shows the pixel glow on missing raidbuffs."] = true
L["Raid Buff Reminder"] = true

-- Skins
L["ActonBarProfiles"] = true
L["Baggins"] = true
L["BigWigs"] = true
L["BugSack"] = true
L["Deadly Boss Mods"] = true
L["ElvUI_DTBars2"] = true
L["Shadow & Light"] = true
L["ls_Toasts"] = true
L["ProjectAzilroka"] = true
L["WeakAuras"] = true
L["XIV_Databar"] = true
L['KlixUI successfully created and applied profile(s) for:'] = true 
L["|cfff960d9KlixUI|r Style |cffff8000(Beta)|r"] = true
L["Creates decorative squares, a gradient and a shadow overlay on some frames.\n|cffff8000Note: This is still in beta state, not every blizzard frames are skinned yet!|r"] = true
L["|cfff960d9KlixUI|r Icon Shadow"] = true
L["Creates a shadow overlay around various icons.\n|cffff8000Note: There is still some icons that miss the shadow overlay, i'm working on them!|r"] = true
L["KlixUI Vehicle"] = true
L["Redesign the standard vehicle button with a custom one."] = true
L["Shadow Overlay"] = true
L["Creates a shadow overlay around the whole screen for a more darker finish."] = true
L["Shadow Level"] = true
L["Change the dark finish of the shadow overlay."] = true
L["Addon Skins"] = true
L["KUI_ADDONSKINS_DESC"] = [[This section is designed to modify some external addons appearance.

Please note that some of these options will be |cff636363disabled|r if the addon is not loaded in the addon control panel.]]
L["Blizzard Skins"] = true
L["KUI_SKINS_DESC"] = [[This section is designed to modify already existing ElvUI skins.

Please note that some of these options will not be available if corresponding skin is |cff636363disabled|r in the main ElvUI skins section.]]
L["ElvUI Skins"] = true
L["Character Frame"] = true
L["Gossip Frame"] = true
L["Quest Frames"] = true
L["Quest Choice"] = true
L["Orderhall"] = true
L["Archaeology Frame"] = true
L["Barber Shop"] = true
L["Contribution"] = true
L["Calendar Frame"] = true
L["Merchant Frame"] = true
L["PvP Frames"] = true
L["Item Upgrade"] = true
L["LF Guild Frame"] = true
L["TalkingHead"] = true
L["AddOn Manager"] = true
L["Mail Frame"] = true
L["Raid Frame"] = true
L["Guild Control Frame"] = true
L["Help Frame"] = true
L["Loot Frames"] = true
L["Warboard"] = true
L["Azerite"] = true
L["BFAMission"] = true
L["Island Party Pose"] = true
L["Minimap"] = true
L["Trainer Frame"] = true
L["Debug Tools"] = true
L["Inspect Frame"] = true
L["Socket Frame"] = true
L["Addon Profiles"] = true
L["KUI_PROFILE_DESC"] = [[This section creates Profiles for some AddOns.

|cffff0000WARNING:|r It will overwrite/delete existing Profiles. If you don't want to apply these Profiles please don't press the Button(s) below.]]
L['This will create and apply profile for '] = true
L["KlixUI Skins"] = true

-- Talents
L["Talents"] = true
L["Toggle Talent Frame"] = true
L["Enable/disable the |cfff960d9KlixUI|r Better Talents Frame."] = true
L["Shows an animated border glow for the currently selected talents."] = true
L["Default to Talents Tab"] = true
L["Defaults to the talents tab of the talent frame on login. By default WoW shows you the specialization tab."] = true
L["Auto Hide PvP Talents"] = true
L["Closes the PvP talents flyout on login. PvP talents and warmode flag are still accessible by manually opening the PvP talents flyout."] = true

-- Toasts
L["Toasts"] = true
L["TOAST_DESC"] = [[Here can you control which toasts that should be displayed.

|cffff8000Note: You can either type "/testtoasts" or "/tt" without the quotes, to show a test toast.|r
]] -- that extra section is meant to be there!
L["Growth Direction"] = true
L["Up"] = true
L["Down"] = true
L["Left"] = true
L["Right"] = true
L["Number of Toasts"] = true
L["Sound Effects"] = true
L["Fade Out Delay"] = true
L["Colored Names"] = true
L["Scale"] = true
L["Colored Names"] = true
L["Toast Types"] = true
L["Achievement"] = true
L["Archaeology"] = true
L["Garrison"] = true
L["Class Hall"] = true
L["War Effort"] = true
L["Dungeon"] = true
L["Loot (Special)"] = true
L["Loot (Common)"] = true
L["Loot Threshold"] = true
L["Loot (Currency)"] = true
L["Loot (Gold)"] = true
L["Copper Threshold"] = true
L["Minimum amount of copper to create a toast for."] = true
L["Recipe"] = true
L["World Quest"] = true
L["Transmogrification"] = true
L["DND"] = true

-- Tooltip
L["Tooltip"] = true
L["Change the visual appearance of the Tooltip.\nCredit: |cffff7d0aMerathilisUI|r"] = true
L["Title Color"] = true
L["Change the color of the title to something more cool!"] = true
L["LFG Member Info"] = true
L["Adds member info for the LFG group list tooltip."] = true
L["Adds information to the tooltip, on which character you earned an achievement.\nCredit: |cffff7d0aMerathilisUI|r"] = true
L["Keystone"] = true
L["Adds descriptions for mythic keystone properties to their tooltips."] = true
L["Enable/disable the azerite tooltip."] = true
L["Remove Blizzard"] = true
L["Replaces the blizzard azerite tooltip text."] = true
L["Specialization"] = true
L["Only show the traits for your current specialization."] = true
L["Compact"] = true
L["Only show icons in the azerite tooltip."] = true
L["Raid Progression"] = true
L["Shows raid progress of a character in the tooltip.\n|cffff8000Note: The visibility of the raid progress can be changed in the display option.|r"] = true
L["Display"] = true
L["Change how the raid progress should display in the tooltip."] = true
L["Name Style"] = true
L["Full"] = true
L["Short"] = true
L["Difficulty Style"] = true
L["RAID_BOD"] = "BoD"
L["RAID_COS"] = "CoS"
L["RAID_EP"] = "EP"
L["Name Hover"] = true
L["Shows the unit name, at the cursor, when hovering over a target."] = true
L["Guild Name"] = true
L["Shows the current mouseover units guild name."] = true
L["Guild Rank"] = true
L["Shows the current mouseover units guild rank."] = true
L["Level, Race & Class"] = true
L["Shows the current mouseover units level, race and class.\n|cffff8000Note: Holding down the shift key will display the gender aswell!|r"] = true
L["Realm Name"] = true
L["Shows the current mouseover units realm name when holding down the shift-key."] = true
L["Always Show Realm Name"] = true
L["Always show the current mouseover units realm name."] = true
L["Titles"] = true
L["Shows the current mouseover units titles."] = true
L["World Quest Count"] = true
L["Enable/disable the world quest count in tooltip, when hovering over a WQ."] = true
L["Show Character"] = true
L["DESC_WQ_CHARACTER"] = [[Add the number of times the current character has completed a world quest to its tooltip on the map.
Omitted if the global count is shown and it is zero.
|cffff8000Note: Only includes times completed while |cfff960d9KlixUI|r |cffff8000was enabled.]]
L["Show Global"] = true
L["DESC_WQ_GLOBAL"] = [[Add the number of times you've completed a world quest to its tooltip on the map. Includes all of your characters.
|cffff8000Note: Only includes times completed while |cfff960d9KlixUI|r |cffff8000was enabled.]]
L["Show WQ ID"] = true
L["Show IDs of the world quests"] = true
L["Realm Info"] = true
L["Shows realm info in various tooltips."] = true
L["Tooltips"] = true
L["Show the realm info in the group finder tooltip."] = true
L["Player Tooltips"] = true
L["Show the realm info in the player tooltip."] = true
L["Friend List"] = true
L["Show the realm info in the friend list tooltip."] = true
L["Tooltip Lines"] = true
L["Realm Timezone"] = true
L["Add realm timezone to the tooltip."] = true
L["Realm Type"] = true
L["Add realm type to the tooltip."] = true
L["Realm Language"] = true
L["Add realm language to the tooltip."] = true
L["Connected Realms"] = true
L["Add the connected realms to the tooltip."] = true
L["Country Flag"] = true
L["Display the country flag without text on the left side in tooltip."] = true
L["Behind language in 'Realm language' line"] = true
L["Behind the character name"] = true
L["In own tooltip line on the left site"] = true
L["Prepend country flag on character name in group finder."] = true
L["Prepend country flag on character name in community member lists."] = true

-- Unitframes
L["UnitFrames"] = true
L['Power Bar'] = true
L['This will enable/disable the |cfff960d9KlixUI|r powerbar modification.|r'] = true
L['Healer Mana'] = true
L['Only show the mana of the healer when in a party group.'] = true
L["Focus Key"] = true
L["Show the focus frame when pressing the specific key combination chosen below."] = true
L["FocusButton"] = true
L["MouseButton"] = true
L["FK_DESC"] = [[To remove the focus frame once set, please press the same combination of focusbuttons again on any part of the UI screen you like.
]] -- that extra section is meant to be there!
L["Auras"] = true
L["Aura Icon Spacing"] = true
L["Aura Spacing"] = true
L["Sets space between individual aura icons."] = true
L["Set Aura Spacing On Following Units"] = true
L["Player"] = true
L["Target"] = true
L["TargetTarget"] = true
L["TargetTargetTarget"] = true
L["Focus"] = true
L["FocusTarget"] = true
L["Pet"] = true
L["PetTarget"] = true
L["Arena"] = true
L["Boss"] = true
L["Party"] = true
L["Raid"] = true
L["Raid40"] = true
L["RaidPet"] = true
L["Tank"] = true
L["Assist"] = true
L["Aura Icon Text"] = true
L["Duration Text"] = true
L["Hide Text"] = true
L["Hide From Others"] = true
L["Will hide duration text on auras that are not cast by you."] = true
L["Threshold"] = true
L["Duration text will be hidden until it reaches this threshold (in seconds). Set to -1 to always show duration text."] = true
L["Position of the duration text on the aura icon."] = true
L["Bottom Left"] = true
L["Bottom Right"] = true
L["Top Left"] = true
L["Top Right"] = true
L["Stack Text"] = true
L["Will hide stack text on auras that are not cast by you."] = true
L["Position of the stack count on the aura icon."] = true
L['Textures'] = true
L['Health'] = true
L['Health statusbar texture. Applies only on Group Frames'] = true
L['Ignore Transparency'] = true
L['This will ignore ElvUI Health Transparency setting on all Group Frames.'] = true
L['Power'] = true
L['Power statusbar texture.'] = true
L['Castbar'] = true
L['This applies on all available castbars.'] = true
L['Castbar Text'] = true
L['Show InfoPanel text'] = true
L['Force show any text placed on the InfoPanel, while casting.'] = true
L['Show Castbar text'] = true
L['Show on Target'] = true
L['Y Offset'] = true
L['Adjust castbar text Y Offset'] = true
L["Text Color"] = true
L["Elite Icon"] = true
L["Show the elite icon on the target frame."] = true
L["Anchor Point"] = true
L["Relative Point"] = true
L["Frame Level"] = true
L['Attack Icon'] = true
L['Show attack icon for units that are not tapped by you or your group, but still give kill credit when attacked.'] = true
L['Icons'] = true
L["LFG Icons"] = true
L["Choose what icon set there will be used on unitframes and in the chat."] = true
L["ReadyCheck Icons"] = true
L['|cfff960d9KlixUI|r Raid Icons'] = true
L['Replaces the default Raid Icons with the |cfff960d9KlixUI|r ones.\n|cffff8000Note: The Raid Icons Set can be changed in the |cfff960d9KlixUI|r |cffff8000Raid Markers option.|r'] = true
L["Debuffs Alert"] = true
L["Color the unit healthbar if there is a debuff from this filter"] = true
L["Default Color"] = true
L["Filters Page"] = true
L["Add Spell ID or Name"] = true
L["Add a spell to the filter. Use spell ID if you don't want to match all auras which share the same name."] = true
L["Remove Spell ID or Name"] = true
L["Remove a spell from the filter. Use the spell ID if you see the ID as part of the spell name in the filter."] = true
L["Select Spell"] = true
L["Reset Filter"] = true
L["This will reset the contents of this filter back to default. Any spell you have added to this filter will be removed.\n|cffff8000Note: Please reloadUI after resetting the filters.|r"] = true
L["special color"] = true
L["use special color"] = true

-- Media
L["KUI_MEDIA_ZONES"] = {
	"Washington",
	"Moscow",
	"Moon Base",
	"Goblin Spa Resort",
	"Illuminaty Headquaters",
	"Elv's Closet",
	"BlizzCon",
}
L["KUI_MEDIA_PVP"] = {
	"(Horde Territory)",
	"(Alliance Territory)",
	"(Contested Territory)",
	"(Russian Territory)",
	"(Aliens Territory)",
	"(Cats Territory)",
	"(Japanese Territory)",
	"(EA Territory)",
}
L["KUI_MEDIA_SUBZONES"] = {
	"Administration",
	"Hellhole",
	"Alley of Bullshit",
	"Dr. Pepper Storage",
	"Vodka Storage",
	"Last National Bank",
}
L["KUI_MEDIA_PVPARENA"] = {
	"(PvP)",
	"No Smoking!",
	"Only 5% Taxes",
	"Free For All",
	"Self destruction is in process",
}
L["Zone Text"] = true
L["Test"] = true
L["Subzone Text"] = true
L["PvP Status Text"] = true
L["Misc Texts"] = true
L["Mail Text"] = true
L["Chat Editbox Text"] = true
L["Gossip and Quest Frames Text"] = true
L["Objective Tracker Header Text"] = true
L["Objective Tracker Text"] = true
L["Banner Big Text"] = true
L["Set the font outline."] = true

-- Profiles

-- Staticpopup
L["MSG_KUI_ELV_OUTDATED"] = [[Your version of ElvUI is older than recommended to use with |cfff960d9KlixUI|r. Your version is |cff1784d1%.2f|r (recommended is |cff1784d1%.2f|r). Please update your ElvUI to avoid errors.]]