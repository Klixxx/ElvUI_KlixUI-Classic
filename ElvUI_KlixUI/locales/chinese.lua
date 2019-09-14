-- Chinese localization file for zhCN.
local L = ElvUI[1].Libs.ACL:NewLocale("ElvUI", "zhCN")

-- General Options / Core
L["A plugin for |cff1784d1ElvUI|r by Klix (EU-Twisting Nether)"] = true
L['by Klix (EU-Twisting Nether)'] = true
L["KUI_DESC"] = [=[|cfff960d9KlixUI|r 是ElvUI的一个扩展插件，提供了:

- 很多新功能.
- 透明外观.
- 美化材质.
- 同时支持治疗和DPS专精.
- 与大多数其他ElvUI插件兼容.

|cfff960d9备注:|r 在用|cfff960d9粉红色|r标记的ElvUI选项中可以找到更多设置选项 .  

|cffff8000最新增加的项目包括:|r]=]

L['Install'] = "安装"
L['Run the installation process.'] = "开始安装步骤"
L["Reload"] = "重新载入"
L['Reaload the UI'] = "重新载入界面"
L["Changelog"] = "更新日志"
L['Open the changelog window.'] = "打开更新日志窗口"
L["Modules"] = "功能模块"
L["Media"] = "材质"
L["Skins & AddOns"] = "皮肤&插件"
L["AFK Screen"] = "暂离画面"
L["Enable/Disable the |cfff960d9KlixUI|r AFK Screen.\nCredit: |cff00c0faBenikUI|r"] = "启用/禁用暂离画面."
L["AFK Screen Chat"] = "暂离画面聊天框"
L["Show the chat when entering AFK screen."] = "在暂离画面显示聊天框"
L["Game Menu Screen"] = "菜单画面"
L["Enable/Disable the |cfff960d9KlixUI|r Game Menu Screen.\nCredit: |cffff7d0aMerathilisUI|r"] = "启用/禁用游戏菜单画面"
L['Splash Screen'] = "启动画面"
L["Enable/Disable the |cfff960d9KlixUI|r Splash Screen.\nCredit: |cff00c0faBenikUI|r"] = "启用/禁用登录画面"
L['Login Message'] = "登录信息"
L["Enable/Disable the Login Message in Chat."] = "在聊天框启用/禁用登录信息"
L["Game Menu Button"] = "游戏菜单按钮"
L["Show/Hide the |cfff960d9KlixUI|r Game Menu button"] = "显示/隐藏游戏菜单按钮"
L["Minimap Button"] = "小地图按钮"
L["Show/Hide the |cfff960d9KlixUI|r minimap button."] = "显示/隐藏小地图按钮"
L["Left Click"] = "左键点击"
L["Open KlixUI Config"] = "打开|cff00c0faKlixUI|r设置"
L["Alt + Left Click"] = "Alt+左键点击"
L["ReloadUI"] = "重载界面"
L['Tweaks'] = "调整"
L["Speedy Loot"] = "快速拾取"
L["Enable/Disable faster corpse looting."] = "启用/禁用快速战利品拾取"
L["Easy Delete"] = "快速删除物品"
L['Enable/Disable the ability to delete an item without the need of typing: "delete".'] = "启用/禁用删除物品时自动输入DELTE" --WIP
L["Cinematic"] = "剧情动画"
L["Skip Cut Scenes"] = "跳过剧情动画"
L["Enable/Disable cut scenes."] = "启用/禁用自动跳过剧情动画"
L["Cut Scenes Sound"] = "场景音效"
L["Enable/Disable sounds when a cut scene pops.\n|cffff8000Note: This will only enable if you have your sound disabled.|r"] = "启用/禁用剧情动画音效.注意:此功能仅在您禁用了音效时生效"
L["Talkinghead Sound"] = "特写音效"
L["Enable/Disable sounds when the talkingheadframe pops.\n|cffff8000Note: This will only enable if you have your sound disabled."] = "启用/禁用特写音效.\n|cffff8000注意:此设置仅在音效禁用时可启用"
L["Here you find the options for all the different |cfff960d9KlixUI|r modules.\nPlease use the dropdown to navigate through the modules."] = "你可以在这里找到|cfff960d9KlixUI|r所有模块.\n请使用下拉菜单浏览模块"
-- New Information tab
L['Information'] = "相关信息"
L["FAQ_DESC"] = "以下包含ElvUI和|cfff960d9KlixUI|r的一些常见问题."
L["FAQ_ELV_1"] = [[|cfff960d9问: 我在哪里可以找到ElvUI的最新版本?|r
|cffff8000答:|r 您可在此找到最新版本的ElvUI - https://www.tukui.org/download.php?ui=elvui
您还可以在此下载试用最新的开发版本 - https://git.tukui.org/elvui/elvui/repository/archive.zip?ref=development
开发版可能存在一些问题和错误,请谨慎使用.]]
L["FAQ_ELV_2"] = [[|cfff960d9问: 我在哪里可以找到ElvUI的支持文档?|r
|cffff8000答:|r 最快的方式则是加入tukui项目 - https://discord.gg/xFWcfgE
您还可以在官方论坛发帖咨询 - https://www.tukui.org/forum/]]
L["FAQ_ELV_3"] = [[|cfff960d9问: 我如何提交功能需求或错误报告?|r
|cffff8000答:|r 如果您需要提交新功能需求或错误报告,可访问 - https://git.tukui.org/elvui/elvui/issues]]
L["FAQ_ELV_4"] = [[|cfff960d9问: 我应该在错误报告中提供什么信息?|r
|cffff8000答:|r 首先您需要确定错误是源自ElvUI.
故此您需要先禁用除ElvUI及ElvUI_Config外的全部插件.
您可输入"/luaerror on" (不含引号)实现.
如果错误没有解决,那么您需要向我们发送错误报告.
在报告中您需要提供ElvUI详细版本号(类似"latest/最新"不是有效的版本信息), 错误记录, 以及截图.
您提供的信息越详细,则该问题将越快被修正.]]
L["FAQ_ELV_5"] = [[|cfff960d9问: 为什么我使用了相同配置的字符串不生效?|r
|cffff8000答:|r ElvUI一共有三种配置. 第一种(配置文件)存储在您的配置文件中,第二种(个人配置) 是以字符串为基础的,第三种(全局配置)应用于全局配置.
在这个问题中,您似乎是遇到了以上第二类所述问题.]]
L["FAQ_ELV_6"] = [[|cfff960d9问: ElvUI有什么命令?|r
|cffff8000答:|r ElvUI具有很多不同功能的命令. 如下所示:
/ec 或 /elvui - 打开设置界面
/bgstats - 当你在战场中显示战场特定的数据
/hellokitty - 需要一个粉色可爱界面? 这里有!
/harlemshake - 想要界面开始舞动? 试试呗!
/luaerror - 以测试模式载入界面,该模式适用于生成错误报告 (查看 Q #4)
/egrid - 开启网格模式
/moveui - 解锁界面
/resetui - 重置至默认界面]]
L["FAQ_KUI_1"] = [[|cfff960d9问: 如果我在KlixUI中遇到问题怎么办?|r
|cffff8000答:|r 与ElvUI类似 (在FAQ中可找到) 但您仍需提供KlixUI详细版本号.
最快的方式仍是加入我的项目,然后把错误贴在上面 - https://discord.gg/GbQbDRX]]
L["FAQ_KUI_2"] = [[|cfff960d9问: 为什么有些功能模块不生效或发生错误?|r
|cffff8000答:|r 您可能启用了另一个插件，它的功能与KlixUI模块完全相同.
如果您想使用KlixUI提供的模块，请禁用有冲突的插件.]]
L["FAQ_KUI_3"] = [[|cfff960d9问: 在哪里可以禁用/启用KlixUI中的某个功能?|r
|cffff8000答:|r 我已经尽可能简化KlixUI设置, 例如. 禁用某个功能时,这个功能就在这个模块下.
尽量在杂项中查找"随机"属性.]]
L["FAQ_KUI_4"] = [[

|cfff960d9未完待续...|r]] -- those extra section is meant to be there!
L["Links"] = "链接"
L["LINK_DESC"] = [[下面的链接将引导您访问|cfff960d9KlixUI|r的页面,您可以在这些站点上下载最新版本并报告错误.
此外,您将找到我其它插件的下载链接.]]
L["My other Addons"] = "我的其它插件"
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
L["ELVUI_KUI_CREDITS"] = "以下人员在本插件编写时提供了许多帮助,特此感谢."
L["Submodules & Coding:"] = "子模块&代码编写"
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
L["ELVUI_KUI_DONORS_TITLE"] = "感谢以下人员的捐赠支持我的工作:"
L["ELVUI_KUI_DONORS"] = [[Akiao
Enii
He Min
Bradx
Rey
Vauxine]]
L["Testing & Inspiration:"] = "测试&启发"
L["ELVUI_KUI_TESTING"] = [[Kringel
Akiao
Obscurrium
Benik
Merathilis
Darth Predator
Skullflower
TukUI/ElvUI社区]]
L["Other Support:"] = "其它支持"
L["ELVUI_KUI_SPECIAL"] = [[Kringel - 完成德语地区的插件本地化工作，一直在我的Discord中提供帮助和支持!
Wilzor - 提供许多新特性的建议，并帮助编写一些代码 (AutoOpen Bags ID)
以及TukUI/ElvUI社区的众多成员 :)]]

-- Actionbars
L["Credits"] = "创建"
L['ActionBars'] = "动作条"
L["General"] = "一般"
L['Transparent Backdrops'] = "透明背景"
L['Applies transparency in all actionbar backdrops and actionbar buttons.'] = "在所有动作条应用透明背景"
L['Quest Button'] = "任务按钮"
L['Shows a button with the quest item for the closest quest with an item.'] = "显示带有任务项的按钮，用于最近的任务"
L['Clean Button'] = "清除按钮"
L['Removes the textures around the Bossbutton and the Zoneability button.'] = true
L["Enhanced Vehicle Bar"] = true
L["A different look/feel of the default vehicle bar."] = true
L["Buttons"] = "按钮"
L["The amount of buttons to display."] = true
L["Button Size"] = "按钮尺寸"
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
L["Color"] = "颜色"
L["Num Lines"] = true
L["Defines the number of lines the glow will spawn."] = true
L["Frequency"] = true
L["Sets the animation speed of the glow. Negative values will rotate the glow anti-clockwise."] = true
L["Length"] = true
L["Defines the length of each individual glow lines."] = true
L["Thickness"] = true
L["Defines the thickness of the glow lines."] = true
L["X-Offset"] = "X偏移"
L["Y-Offset"] = "Y偏移"
L["Specialization & Equipment Bar"] = "专业&装备"
L["Enable"] = "启用"
L['Show/Hide the |cfff960d9KlixUI|r Spec & EquipBar.'] = "显示/隐藏|cfff960d9KlixUI|r专业&装备动作条"
L["Border Glow"] = true
L["Shows an animated border glow for the currently active specialization and loot specialization."] = true
L["Mouseover"] = "鼠标滑过显示"
L["Change the alpha level of the frame."] = "更改框架透明度"
L["Hide In Combat"] = "战斗中隐藏"
L['Show/Hide the |cfff960d9KlixUI|r Spec & EquipBar in combat.'] = "在战斗中显示/隐藏|cfff960d9KlixUI|r专业&装备动作条"
L["Hide In Orderhall"] = "在职业大厅中隐藏"
L['Show/Hide the |cfff960d9KlixUI|r Spec & Equip Bar in the class hall.'] = "在职业大厅显示/隐藏|cfff960d9KlixUI|r专业&装备动作条"
L["Enable"] = "启用"
L["Micro Bar"] = "微型系统菜单"
L['Show/Hide the |cfff960d9KlixUI|r MicroBar.'] = "显示/隐藏|cfff960d9KlixUI|r微型系统菜单"
L["Microbar Scale"] = "比例"
L['Show/Hide the |cfff960d9KlixUI|r MicroBar in combat.'] = "在战斗中显示/隐藏|cfff960d9KlixUI|r微型系统菜单"
L['Show/Hide the |cfff960d9KlixUI|r MicroBar in the class hall.'] = "在职业大厅显示/隐藏|cfff960d9KlixUI|r微型系统菜单"
L["Highlight"] = "高亮效果"
L['Show/Hide the highlight when hovering over the |cfff960d9KlixUI|r MicroBar buttons.'] = "显示/隐藏鼠标经过|cfff960d9KlixUI|r微型系统菜单按钮时的高亮效果"
L["Buttons"] = "按钮"
L['Only show the highlight of the buttons when hovering over the |cfff960d9KlixUI|r MicroBar buttons.'] = "仅显示鼠标经过|cfff960d9KlixUI|r微型系统菜单按钮时的高亮效果"
L["Text"] = "按钮文本"
L["Position"] = "位置"
L["Top"] = "上"
L["Bottom"] = "下"
L["Config"] =  "设置"
L["Map & Quest Log"] = "任务面板"
L["Bug Report"] = "错误报告"
L['Show/Hide the friend text on |cfff960d9KlixUI|r MicroBar.'] = "在|cfff960d9KlixUI|r微型动作条中显示/隐藏好友信息"
L['Show/Hide the guild text on |cfff960d9KlixUI|r MicroBar.'] = "在|cfff960d9KlixUI|r微型动作条中显示/隐藏公会信息"
L["AutoButtons"] = "自动按钮"
L["Auto InventoryItem Button"] = "自动物品按钮"
L["Auto QuestItem Button"] = "自动任务按钮"
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
L["Custom Color"] = "自定义颜色"
L["Spacing"] = "间距"
L["Direction"] = "方向"
L["Number of Buttons"] = "按钮数量"
L["Buttons Per Row"] = "每行按钮数"
L["Button Size"] = "按钮尺寸"
L["Quest Auto Buttons"] = "任务自动按钮"
L["Whitelist"] = "白名单"
L["Add ItemID"] = "增加物品ID"
L["Must be an itemID!"] = "必须为物品ID!"
L["is not an itemID"] = "这不是一个物品ID"
L["Delete ItemID"] = "删除物品ID"
L["Blacklist"] = "黑名单"
L["Add Blacklist ItemID"] = "增加黑名单物品ID"
L["Delete Blacklist ItemID"] = "删除黑名单物品ID"

-- Addon Panel
L["Addon Control Panel"] = "插件管理"
L['# Shown AddOns'] = "插件数/页"
L['Frame Width'] = "框架宽度"
L['Button Height'] = "按钮高度"
L['Button Width'] = "按钮宽度"
L['Font'] = "字体大小"
L['Font Outline'] = "字体阴影"
L["Value Color"] = "数值颜色"
L["Font Color"] = "字体颜色"
L['Texture'] = "按钮材质"
L['Class Color Check Texture'] = "按钮职业色"

-- Announcement
L["Announcement"] = "通告"
L["Utility spells"] = "通用技能"
L["Combat spells"] = "战斗技能"
L["Taunt spells"] = "嘲讽技能"
L["Say thanks"] = "感谢"
L["Your name"] = "你的名字"
L["Name of the player"] = "玩家名"
L["Target name"] = "目标名"
L["Pet name"] = "宠物名"
L["The spell link"] = "技能链接"
L["Your spell link"] = "你的技能链接"
L["Interrupted spell link"] = "打断技能链接"
L["Interrupt"] = "打断"
L["Success"] = "成功"
L["Failed"] = "失败"
L["Only instance / arena"] = "仅场景战役/竞技场"
L["Player"] = "玩家"
L["Pet"] = "宠物"
L["Player(Only you)"] = "玩家(仅自己)"
L["Other players"] = "其他玩家"
L["Other players\' pet"] = "其他玩家宠物"
L["Text"] = "文本"
L["Use default text"] = "使用默认文本"
L["Text for the interrupt casted by you"] = "你打断的施法"
L["Text for the interrupt casted by others"] = "其他玩家打断的施法"
L["Example"] = "示例"
L["Only I casted"] = "仅自己施放"
L["Target is me"] = "目标为我"
L["Only target is not tank"] = "仅目标为非坦克"
L["Feasts"] = "大餐"
L["Bots"] = "机器人"
L["Toys"] = "玩具"
L["Portals"] = "入口"
L["Niuzao"] = "玄牛砮皂"
L["Totem"] = "图腾"
L["Provoke all(Monk)"] = "群嘲(武僧)"
L["Sylvanas"] = "希尔瓦娜斯"
L["Channel"] = "频道"
L["Use raid warning"] = "使用团队警报"
L["Use raid warning when you is raid leader or assistant."] = "当你具有团长或团队助理权限时使用团队警报"
L["If you do not check this, the spell casted by other players will be announced."] = "如果你不进行设置,团队通告将由其他玩家发出."
L["None"] = "无"
L["Whisper"] = "密语"
L["Self(Chat Frame)"] = "自己(聊天框)"
L["Emote"] = "表情"
L["Yell"] = "大喊"
L["Say"] = "说"
L["Solo"] = "单人"
L["Party"] = "小队"
L["Instance"] = "副本"
L["Raid"] = "团队"
L["In party"] = "小队中"
L["In instance"] = "副本中"
L["In raid"] = "团队中"
L["Combat resurrection"] = "战复"
L["Threat transfer"] = "嫁祸"
L["Resurrection"] = "复活"
L["Goodbye"] = "再会"
L["I interrupted %target%\'s %target_spell%!"] = "我打断了%target%施放的%target_spell%!"
L["%player% interrupted %target%\'s %target_spell%!"] = "%player%打断了%target%施放的%target_spell%!"
L["%player% is casting %spell%, please assist!"] = "%player%施放了%spell%!"
L["%player% is handing out cookies, go and get one!"] = "%player%放置了,快去食用!"
L["%player% puts %spell%"] = "%player%放置了%spell%"
L["%player% used %spell%"] = "%player%使用了%spell%"
L["%player% casted %spell%, today's special is Anchovy Pie!"] = "%player%施放了%spell%,今天的特色菜是凤尾鱼馅饼!"
L["OMG, wealthy %player% puts %spell%!"] = "我滴妈,土豪玩家%player%放置了%spell%!"
L["%player% opened %spell%!"] = "%player%打开了%spell%!"
L["%player% casted %spell% -> %target%"] = "%player% 施放了 %spell% -> %target%"
L["I taunted %target% successfully!"] = "我嘲讽了%target%!"
L["I failed on taunting %target%!"] = "我嘲讽%target%失败!"
L["My %pet_role% %pet% taunted %target% successfully!"] = "我的%pet_role% %pet%嘲讽了%target%!"
L["My %pet_role% %pet% failed on taunting %target%!"]= "我的%pet_role% %pet%嘲讽%target%失败!"
L["%player% taunted %target% successfully!"] = "%player%嘲讽了%target%!"
L["%player% failed on taunting %target%!"] = "%player%嘲讽%target%失败!"
L["%player%\'s %pet_role% %pet% taunted %target% successfully!"] = "%player%的%pet_role% %pet%嘲讽了%target%!"
L["%player%\'s %pet_role% %pet% failed on taunting %target%!"] = "%player%的%pet_role% %pet%嘲讽%target%失败!"
L["I taunted all enemies in 10 yards!"] = "我施放了群嘲!"
L["%player% taunted all enemies in 10 yards!"] = "%player%施放了群嘲!"
L["%target%, thank you for using %spell% to revive me. :)"] = "%target%,感谢你复活我. :)"
L["Thanks all!"] = "谢谢大家!"

-- Armory
L["Armory"] = "物品增强"
L["ARMORY_DESC"] = [[The |cfff960d9KlixUI|r 物品增强只适用于魔兽世界当前资料片.可能会出现以下结果:

- 在旧的装备上显示错误.
- 插槽和附魔显示不完整或完全不显示.

自1.57版开始,|cfff960d9KlixUI|r物品增强显示将与ElvUI默认的功能一起工作.
启用ElvUI的默认物品功能将导致:

- |cfff960d9KlixUI|r物品增强中的装备等级不能正常显示.
- |cfff960d9KlixUI|r物品增强中的插槽和附魔显示将被禁用.
]] -- that extra section is meant to be there!
L["Enable/Disable the |cfff960d9KlixUI|r Armory Mode."] = "启用/禁用|cfff960d9KlixUI|r物品增强"
L["Azerite Buttons"] = "艾泽里特按钮"
L["Enable/Disable the Azerite Buttons on the character window."] = "启用/禁用艾泽里特按钮"
L["Naked Button"] = true
L["Enable/Disable the Naked Button on the character window."] = true
L["Class Crests"] = true
L["Shows an overlay of the class crests on the character window."] = true
L["Durability"] = "耐久度"
L["Enable/Disable the display of durability information on the character window."] = "在装备栏中显示物品耐久"
L["Damaged Only"] = "仅显示损坏"
L["Only show durability information for items that are damaged."] = "仅显示损坏耐久"
L["Itemlevel"] = "装备等级" -- doesnt work
L["Enable/Disable the display of item levels on the character window."] = "启用/禁用装备等级显示"
L["Level"] = "等级"
L["Full Item Level"] = "完整装等"
L["Show both equipped and average item levels."] = "显示已装备和平均装等"
L["Item Level Coloring"] = "装等着色"
L["Color code item levels values. Equipped will be gradient, average - selected color."] = true
L["Color of Average"] = true
L["Sets the color of average item level."] = true
L["Only Relevant Stats"] = true
L["Show only those primary stats relevant to your spec."] = true
L["Categories"] = "类型"
L["Indicators"] = "指示器"
L["Enchant"] = "附魔"
L["Shows an indictor for enchanted/not enchanted items."] = "在已附魔或未附魔物品上显示一个指示器"
L["Glow Indicator"] = "高亮指示器"
L["Shows a glow indicator of not enchanted items only."] = "仅在未附魔物品上显示高亮指示器"
L["Socket"] = "插槽"
L["Shows an indictor for socketed/unsocketed items."] = "在已插宝石或未插宝石物品上显示一个指示器"
L["Shows a glow indictor for unsocketed items only."] = "仅在未插宝石物品上显示高亮指示器"
L["Transmog"] = true
L["Shows an arrow indictor for currently transmogrified items."] = true
L["Illusion"] = true
L["Shows an indictor for weapon illusions."] = true
L["Gradient"] = "装备渐变"
L["alpha"] = "透明度"
L["Value"] = "数值"
L["Background"] = "背景"
L["Select Image"] = "选择图片"
L["Overlay"] = "覆盖"
L["Custom Image Path"] = "自定义图片路径"
L["Shows the Icy-Veins stats pane on the character window.\n|cffff8000Note: Recommended stats pulled from Icy-Veins.com the 09th of Februrary.|r"] = true
L["Height"] = "高度"
L["Position"] = "位置"
L["Custom Text"] = "自定义文本"
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
L["Blizzard"] = "暴雪原生"
L["Raid Utility Mouse Over"] = "鼠标滑过显示团队管理"
L["Enabling mouse over will make ElvUI's raid utility show on mouse over instead of always showing."] = "启用该选项将使ElvUI团队管理界面仅在鼠标滑过时显示."
L["Error Frame"] = "错误框架"
L["Width"] = "宽度"
L["Set the width of Error Frame. Too narrow frame may cause messages to be split in several lines"] = "设置错误信息框架宽度.如果宽度值过小,将导致信息分为多行显示"
L["Height"] = "高度"
L["Set the height of Error Frame. Higher frame can show more lines at once."] = "设置错误信息框架高度.高度越高,显示的行数也越多"
L["Move Blizzard frames"] = "暴雪框架移动"
L["Allow some Blizzard frames to be moved around."] = "允许移动暴雪框架"
L["Remember"] = "记忆位置"
L["Remember positions of frames after moving them."] = "记忆移动后的框架位置"

-- Chat
L['Chat'] = "聊天框"
L['Chat Tabs'] = "聊天选项卡"
L["Selected Indicator"] = "选项卡箭头"
L["Shows you which of your docked chat tabs which is currently selected."] = "显示当前选中的聊天选项卡"
L["Style"] = "样式"
L['Fade Chat Tabs'] = "淡出聊天选项卡"
L['Fade out chat tabs except the currently selected chat tab.'] = "淡出显示除选中外的聊天选项卡"
L['Chat Tab Alpha'] = "透明度"
L['Alpha of faded chat tabs.'] = "聊天选项卡透明度"
L['Force to Show'] = "强制显示"
L['Force a tab to show when it is flashing. This works both for when chat panel backdrop is hidden and when chat tab is faded.'] = "当一个聊天选项卡闪烁时强制显示"
L['Force Show Threshold'] = "强制显示阈值"
L['Threshold before a faded chat tab is forced to show. If a faded chat tab alpha is less than or equal to this value then it will be forced to show.'] = "强制显示聊天选项卡的阈值"
L['Force Show Alpha'] = "透明度"
L['Alpha of a chat tab when it is forced to show.'] = "设置聊天选项卡强制显示时的透明度"
L["Chat Separators"] = "聊天分隔符"
L["Chat Tab Separators"] = "聊天选项卡分隔符"
L["Add a thin black line below chat tabs to separate them from chat messages."] = "在聊天选项卡下面添加一条黑色细线,将它们与聊天消息分开"
L["Chat Datatext Separators"] = "数值分隔符"
L["Add a thin black line above chat datatexts to separate them from chat messages."] = "在数值上面添加一条黑色细线，将它们与聊天消息分开"
L["Right-Click Menu"] = "右键菜单"
L["Enhances the chat character right-click menu with new features."] = "增强型右键菜单"
L["Get Name"] = "获取名字"
L["Query Detail"] = "查询玩家"
L["Guild Invite"] = "公会邀请"
L["Add Friend"] = "添加好友"
L["Report MyStats"] = "报告装等"
L["has come |cff298F00online|r."] = "上线了。"
L["has gone |cffff0000offline|r."] = "下线了。"
L[" has come |cff298F00online|r."] = "已经上线。"
L[" has gone |cffff0000offline|r."] = "已经离线。"
L["|cfff960d9GMOTD:|r %s"] = "公会信息：%s"


-- CombatText
L["Combat Text"] = "战斗文字"
L["Absorbed"] = "吸收"
L["Blocked"] = "格挡"
L["Deflected"] = "偏斜"
L["Dodged"] = "躲闪"
L["Immune"] = "免疫"
L["Missed"] = "未命中"
L["Parried"] = "招架"
L["Reflected"] = "反射"
L["Resisted"] = "抵抗"
L["Disable Blizzard FCT"] = "禁用暴雪战斗信息"
L["Personal SCT"] = "显示个人战斗数值"
L["Also show numbers when you take damage on your personal nameplate or in the center of the screen."] = "在你的姓名板或屏幕中央显示数值"
L["No Icons"] = "无图标"
L["Left Side"] = "左侧"
L["Right Side"] = "右侧"
L["Both Sides"] = "两侧"
L["Icons Only (No Text)"] = "仅图标(无数值)"
L["Animations"] = "动画效果"
L["Default"] = "默认"
L["Vertical Up"] = "垂直上升"
L["Vertical Down"] = "垂直下落"
L["Fountain"] = "瀑布"
L["Rainfall"] = "雨滴下落"
L["Disabled"] = "禁用"
L["Abilities"] = "技能"
L["Criticals"] = "爆击"
L["Miss/Parry/Dodge/etc."] = "未命中/躲闪/招架"
L["Auto Attacks"] = "自动攻击"
L["Auto attacks that are critical hits"] = "自动攻击爆击"
L["Critical"] = "自动攻击爆击"
L["Personal SCT Animations"] = "个人战斗数值动画"
L["Appearance/Offsets"] = "外观"
L["Font Shadow"] = "字体阴影"
L["Use Damage Type Color"] = "使用伤害数字颜色"
L["Default Color"] = "默认"
L["Has soft min/max, you can type whatever you'd like into the editbox tho."] = true
L["X-Offset Personal SCT"] = "X偏移-SCT"
L["Y-Offset Personal SCT"] = "Y偏移-SCT"
L["Only used if Personal Nameplate is Disabled."] = "仅在个人姓名板禁用时生效"
L["Text Formatting"] = "文本格式"
L["Truncate Number"] = "分隔数值"
L["Condense combat text numbers."] = "分隔战斗数值"
L["Show Truncated Letter"] = "显示分隔符"
L["Comma Seperate"] = "逗号分隔"
L["e.g. 100000 -> 100,000"] = "例如 100000 -> 100,000"
L["Icon"] = "图标"
L["Size"] = "尺寸"
L["Start Alpha"] = "初始透明度"
L["Use Seperate Off-Target Text Appearance"] = "使用分离的非目标文本外观"
L["Off-Target Text Appearance"] = "非目标文本"
L["Sizing Modifiers"] = "尺寸设置"
L["Embiggen Crits"] = "技能爆击"
L["Embiggen Auto Attack Crits"] = "自动攻击爆击"
L["Embiggen critical auto attacks"] = "缩放自动攻击爆击数值"
L["Embiggen Crits Scale"] = "比例"
L["Embiggen Miss/Parry/Dodge/etc."] = "未命中/躲闪/招架"
L["Embiggen Miss/Parry/Dodge/etc. Scale"] = "比例"
L["Scale Down Small Hits"] = "缩放小伤害数值"
L["Scale down hits that are below a running average of your recent damage output"] = "缩小低于伤害平均值的数值"
L["Small Hits Scale"] = "比例"
L["Hide Small Hits"] = "隐藏小伤害"
L["Hide hits that are below a running average of your recent damage output"] = "隐藏低于伤害平均值的数值"


-- Cooldowns
L["Cooldowns"] = "冷却"
L["Dimishing Returns"] = "递减"
L["DR_DESC"] = [[本部分将在竞技场框架旁显示递减值.
图标边框颜色说明:

- |cffffff00黄色|r = 1/2持续
- |cffff7f00橙色|r = 1/4持续
- |cffff0000红色|r = 免疫

|cffff8000备注: 你可以输入"/testdr"或"/tdr"(不含引号)以显示该图标.|r
]] -- that extra section is meant to be there!
L["Cooldown Text"] = "冷却文本"
L["EC_DESC"] = [[此部分将显示敌对目标的技能冷却图标(可以移动).

|cffff8000备注: 你可以输入"/testecd"或"/tecd"(不含引号),以显示该图标.|r
]] -- that extra section is meant to be there!
L["Border Color"] = "边框颜色"
L["Sets the border color to either dimishing return or classic ElvUI.\n |cffff8000Note: If using the dimishing return border color the shadow overlay will slightly overlap the border color.|r"] = true
L["Direction"] = "方向"
L["Show Always"] = "持续显示"
L["Show the enemy cooldown spells in every related instance types."] = "在所有地域显示敌对目标法术冷却"
L["Show In PvP"] = "PVP中显示"
L["Show the enemy cooldown spells in battlegrounds."] = "在战场中显示敌对目标法术冷却"
L["Show In Arena"] = "竞技场中显示"
L["Show the enemy cooldown spells in arenas."] = "在竞技场中显示敌对目标法术冷却"
L["Pulse"] = "抖动"
L["Icon Size"] = "图标尺寸"
L["Fadein duration"] = "淡入持续时间"
L["Fadeout duration"] = "淡出持续时间"
L["Transparency"] = "透明度"
L["Duration time"] = "持续时间"
L["Animation size"] = "动画效果尺寸"
L["Display spell name"] = "显示施放法术名称"
L["Watch on pet spell"] = "显示宠物施放法术"

-- Databars
L["DataBars"] = "数据条"
L["Enable/Disable the |cfff960d9KlixUI|r DataBar color mod."] = "启用/禁用|cfff960d9KlixUI|r数据条颜色设置"
L["|cfff960d9KlixUI|r Style"] = "|cfff960d9KlixUI|r 样式"
L["Capped"] = "封顶"
L["Replace XP text with the word 'Capped' at max level."] = "在满级后以'封顶'字样替换经验条数字"
L["Blend Progress"] = "混合"
L["Progressively blend the bar as you gain XP."] = "融合经验条前景/背景色"
L["XP Color"] = "经验值颜色"
L["Select your preferred XP color."] = "自定义经验值颜色"
L["Rested Color"] = "精力充沛颜色"
L["Select your preferred rested color."] = "自定义充分休息颜色"
L["Reputation Bar"] = "声望条"
L["Replace rep text with the word 'Capped' or 'Paragon' at max."] = "达到最大值时显示'巅峰'或'崇拜'"
L["Progressively blend the bar as you gain reputation."] = "融合声望条前景/背景色"
L["Auto Track Reputation"] = "自动切换声望"
L["Automatically change your watched faction on the reputation bar to the faction you got reputation points for."] = "自动切换在声望条上显示的声望阵营"
L["'Paragon' Format"] = "巅峰格式"
L["If 'Capped' is toggled and watched faction is a Paragon then choose short or long."] = "true"
L["P"] = true
L["Paragon"] = "巅峰"
L["Progress Colour"] = "进度条颜色"
L["Change rep bar colour by standing."] = "改变进度条颜色"
L["Paragon"] = true
L["PREP_DESC"] = [[This feature changes how the paragon reputation bar looks like in the reputation tab.]]
L["Exalted"] = true
L["Current"] = "当前"
L["Value"] = "数值"
L["Deficit"] = "缺少"
L["Reputation Colors"] = "声望值颜色"
L["Honor Bar"] = "荣誉条"
L["Progressively blend the bar as you gain honor."] = "融合荣誉条前景/背景色"
L["Honor Color"] = "荣誉颜色"
L["Change the honor bar color."] = "自定义荣誉条颜色"
L["Azerite Bar"] = "艾泽里特经验条"
L["Progressively blend the bar as you gain Azerite Power"] = "融合艾泽里特经验条前景/背景色"
L["Azerite Color"] = "艾泽里特颜色"
L["Change the Azerite bar color"] = "自定义艾泽里特经验条颜色"
L["Quest XP"] = "任务经验"
L["QXP_DESC"] = [[在任务栏上增加一个框体,显示任务日志中有多少潜在经验,以了解任务完成后你将获得多少经验.]]
L["Enable/Disable the QuestXP overlay on the experiencebar."] = "启用/禁用经验栏上的任务经验"
L["Overlay Color"] = "覆盖颜色"
L["Include Incomplete Quests"] = "包含未完成任务"
L["Current Zone Quests Only"] = "仅当前区域任务"
L["Add Quest XP To Tooltip"] = "在鼠标提示中加入任务经验"

-- Datatext
L["DataTexts"] = "信息文字"
L["DT_DESC"] = [[此模块为信息文字提供了许多功能设置.

|cffff8000你可随时使用'CTRL + ALT + 鼠标右键'更改所有可见的信息文字.这将打开一个菜单,其中包含所有当前可用的信息文字设置选项.|r]]
L["Left ChatTab Panel"] = "左侧聊天框面板"
L["Show/Hide the left ChatTab DataTexts"] = "启用/禁用左侧聊天框面板信息文字"
L["Right ChatTab Panel"] = "右侧聊天框面板"
L["Show/Hide the right ChatTab DataTexts"] = "启用/禁用右侧聊天框面板信息文字"
L["Panels"] = "面板"
L["Chat Datatext Panel"] = "聊天框信息面板"
L["Show/Hide Chat DataTexts. ElvUI chat datatexts must be disabled"] = "启用/禁用左右两侧聊天框信息条. 启用前请禁用ElvUI默认聊天框信息条"
L['Panel Transparency'] = "面板透明度"
L['Chat EditBox Position'] = "聊天输入框位置"
L['Position of the Chat EditBox, if datatexts are disabled this will be forced to be above chat.'] = "聊天输入框位置,如果信息条被禁用,则会强制开启在聊天框上方"
L['Below Chat'] = "聊天框下方"
L['Above Chat'] = "聊天框上方"
L["Frame Strata"] = "框架层级"
L['Backdrop'] = "背景"
L['Game Menu Dropdown Color'] = "游戏菜单下拉颜色"
L["Middle Datatext Panel"] = "中部信息条"
L['Show/Hide the Middle DataText Panel.'] = "启用/禁用中部信息条"
L["Width"] = "宽度"
L["Height"] = "高度"
L["Other DataTexts"] = "其它信息条"
L["System Datatext"] = "系统信息条"
L["Max Addons"] = "最大插件数"
L["Maximum number of addons to show in the tooltip."] = "鼠标提示中的最大插件数量"
L["Announce Freed"] = true
L["Announce how much memory was freed by the garbage collection."] = true
L["Show FPS"] = "显示帧数"
L["Show FPS on the datatext."] = "在信息文字中显示帧数"
L["Show Memory"] = "显示内存占用"
L["Show total addon memory on the datatext."] = "在信息文字中显示内存占用"
L["Show Latency"] = "显示延迟"
L["Show latency on the datatext."] = "在信息文字中显示网络延迟"
L["Latency Type"] = "延迟类型"
L["Display world or home latency on the datatext. Home latency refers to your realm server. World latency refers to the current world server."] = "显示世界延迟和本地延迟"
L["Home"] = "本地"
L["World"] = "世界"
L["Time Datatext"] = "时间信息"
L["Clock Size"] = "时间尺寸"
L["Change the size of the time datatext individually from other datatexts."] = "将时间信息从其它信息文字里分离"
L["Date Condensed"] = "简化时间"
L["Display a condensed version of the current date."] = "显示当前日期的简化版本"
L["Invasions"] = "入侵"
L["Display upcomming and current Legion and BfA invasions in the time datatext tooltip."] = "显示军团和争霸艾泽拉斯入侵"
L["Faction Assault:"] = true
L["Legion Invasion:"] = "军团入侵"
L["Current: "] = "当前: "
L["Next: "] = "下一次: "
L["Missing invasion info on your realm."] = "丢失当前入侵信息"
L["Time Played"] = "总游戏时间"
L["Display session, level and total time played in the time datatext tooltip."] = "显示当前等级和游戏总时间"
L["Session:"] = true
L["Previous Level:"] = true
L["Account Time Played:"] = true
L["Account Time Played data has been reset!"] = true
L["Left Click:"] = "左键点击"
L["Toggle Map & Quest Log frame"] = true
L["Shift + Left Click:"] = "Shift + 左键点击"
L["Reset account time played data"] = true
L["Right Click:"] = "右键点击"
L["Toggle Calendar frame"] = "开启日历"
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
L["ElvUI DataTexts"] = "ElvUI信息文字"
L["Order of each toon. Smaller numbers will go first"] = true
L["Currency"] = "货币"
L["Show Archaeology Fragments"] = "显示考古碎片"
L["Show Jewelcrafting Tokens"] = "显示珠宝加工代币"
L["Show Player vs Player Currency"] = "显示PVP货币"
L["Show Battle for Azeroth Currency"] = "显示争霸艾泽拉斯货币"
L["Show Legion Currency"] = "显示军团货币"
L["Show Warlords of Draenor Currency"] = "显示德拉诺货币"
L["Show Mists of Pandaria Currency"] = "显示熊猫人之谜货币"
L["Show Cataclysm Currency"] = "显示大灾变货币"
L["Show Wrath of the Lich King Currency"] = "显示巫妖王之怒货币"
L["Show WoW Token Price"] = "显示时光徽章价格"
L["Show Dungeon and Raid Currency"] = "显示地下城与团队副本货币"
L["Show Cooking Awards"] = "显示烹饪奖励"
L["Show Miscellaneous Currency"] = "显示杂项货币"
L["Show Zero Currency"] = "显示空货币" -- ??
L["Show Icons"] = "显示图标"
L["Show Faction Totals"] = "显示声望总数"
L["Show Unused Currencies"] = "显示未使用的货币"
L["Delete character info"] = "删除配置信息"
L["Remove selected character from the stored gold values"] = "从存储的金币值中删除选定的字符"
L["Are you sure you want to remove |cff1784d1%s|r from currency datatexts?"] = "是否确定从货币信息中删除|cff1784d1%s|r?"
L["Gold Sorting"] = "金币排序"
L["Sort Direction"] = "排序方向"
L["Normal"] = "正序"
L["Reversed"] = "倒序"
L["Sort Method"] = "排序方式"
L["Amount"] = "总计"
L["Currency Sorting"] = "货币排序"
L["Direction"] = "方向"
L["Tracked"] = "追踪"
L["KlixUI DataTexts"] = "KlixUI信息文字"

-- Enhanced Friendslist
L["Enhanced Friends List"] = "好友列表增强"
L["Name Font"] = "姓名预设字体"
L["Info Font"] = "信息预设字体"
L["Game Icon Pack"] = "游戏图标选择"
L["Status Icon Pack"] = "状态图标选择"
L["Game Icon Preview"] = "游戏图标预览"
L["Diablo 3"] = "暗黑破幻神3"
L["Hearthstone"] = "炉石传说"
L["Starcraft"] = "星际争霸"
L["Starcraft 2"] = "星际争霸2"
L["App"] = "战网"
L["Mobile"] = "手机App"
L["Hero of the Storm"] = "风暴英雄"
L["Overwatch"] = "守望先锋"
L["Destiny 2"] = "命运2"
L["Call of Duty 4"] = "使命召唤4"
L["Status Icon Preview"] = "状态图标预览"
L["Launcher"] = "战网"
L["Blizzard Chat"] = "暴雪聊天框"
L["Square"] = "方形"
L["Flat Style"] = "扁平式"
L["Glossy"] = "光泽式"


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
L["Location Panel"] = "区域面板"
L["Link Position"] = "发送位置"
L["Allow pasting of your coordinates in chat editbox via holding shift and clicking on the location name."] = "允许通过按住shift和点击位置名称粘贴你的坐标到聊天框"
L["Template"] = "模板"
L["Transparent"] = "透明度"
L["NoBackdrop"] = "无背景"
L["Auto Width"] = "自动宽度"
L["Change width based on the zone name length."] = "按区域名称自动改变框体宽度"
L["Spacing"] = "间距"
L["Update Throttle"] = "更新频率"
L["The frequency of coordinates and zonetext updates. Check will be done more often with lower values."] = "坐标和区域的更新频率,使用较低的值将更新更为频繁"
L["Hide In Combat"] = "战斗中隐藏"
L["Hide In Orderhall"] = "职业大厅隐藏"
L["Hide Blizzard Zone Text"] = "隐藏暴雪区域文本"
L["Mouse Over"] = "鼠标滑过显示"
L["The frame is not shown unless you mouse over the frame"] = "鼠标经过时才显示"
L["Change the alpha level of the frame."] = "改变框架透明度"
L["Show additional info in the Location Panel."] = "在区域面板中显示附加信息"
L['None'] = true
L['Battle Pet Level'] = "战斗宠物等级"
L["Location"] = "区域"
L["Full Location"] = "所在区域全称"
L["Color Type"] = "颜色类型"
L["Reaction"] = "连锁"
L["Custom Color"] = "自定义颜色"
L["Coordinates"] = "坐标"
L["Format"] = "坐标格式"
L["Hide Coords"] = "隐藏坐标"
L["Show/Hide the coord frames"] = "显示/隐藏坐标框架"
L["Hide Coords in Instance"] = "隐藏坐标"
L["Fonts"] = "字体"
L["Font Size"] = "字体大小"
L["Relocation Menu"] = "重置目录"
L["Right click on the location panel will bring up a menu with available options for relocating your character (e.g. Hearthstones, Portals, etc)."] = "右键点击位置面板将弹出一个菜单，可以将你的角色重新定位(例如，《炉石传说》，《传送门》等)"
L["Custom Width"] = "自定义宽度"
L["By default menu's width will be equal to the location panel width. Checking this option will allow you to set own width."] = true
L["Justify Text"] = "校正文字"
L["Left"] = "左"
L["Middle"] = "中"
L["Right"] = "右"
L["CD format"] = "冷却格式"
L["Hearthstone Location"] = "炉石区域"
L["Show the name on location your Heathstone is bound to."] = "显示炉石绑定的区域"
L["Show hearthstones"] = "显示炉石"
L["Show hearthstone type items in the list."] = "在列表中显示炉石的物品类型"
L["Hearthstone Toys Order"] = "炉石玩具订单"
L["Show Toys"] = "显示玩具"
L["Show toys in the list. This option will affect all other display options as well."] = true
L["Show spells"] = true
L["Show relocation spells in the list."] = true
L["Show engineer gadgets"] = true
L["Show items used only by engineers when the profession is learned."] = true
L["Ignore missing info"] = true -- ??
L["Show/Hide tooltip"] = "显示/隐藏鼠标提示"
L["Combat Hide"] = "战斗中隐藏"
L["Hide tooltip while in combat."] = "战斗中隐藏鼠标提示"
L["Show Hints"] = "显示提示"
L["Enable/Disable hints on Tooltip."] = "启用/禁用鼠标提示中的提示"
L["Enable/Disable status on Tooltip."] = "启用/禁用鼠标提示中的状态"
L["Enable/Disable level range on Tooltip."] = "启用/禁用鼠标提示中的等级范围"
L["Area Fishing level"] = "区域钓鱼等级"
L["Enable/Disable fishing level on the area."] = "启用/禁用该区域钓鱼等级"
L["Battle Pet level"] = "战斗宠物等级"
L["Enable/Disable battle pet level on the area."] = "启用/禁用该区域宠物对战等级"
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
L["Maps"] = "地图"
L["Rectangular Minimap"] = "矩形小地图"
L["Reshape the minimap to a rectangle."] = "将小地图设置成矩形"
L["Garrison Button Style"] = "任务大厅按钮样式"
L["Change the look of the Garrison/OrderHall/BfA Mission Button"] = "更改职业大厅及任务大厅按钮样式"
L["LFG Button Style"] = "查找地下城按钮样式"
L["Change the look of the looking for group Button"] = "更改查找地下城按钮外观"
L["Minimap Glow"] = "小地图闪光"
L["Shows the minimap glow when a mail or a calendar invite is available."] = "当有邮件或日历事件可用时,在小地图中闪光"
L["Always Display Glow"] = "总是显示闪光"
L["Always display the minimap glow."] = "总是在小地图中显示闪光"
L["Hide minimap while in combat."] = "战斗中隐藏小地图"
L["FadeIn Delay"] = "淡入延迟"
L["The time to wait before fading the minimap back in after combat hide. (0 = Disabled)"] = "战斗结束后显示小地图的延迟时间.(0 = 禁用)"
L["Mail"] = "邮件"
L["Enhanced Mail"] = "增强邮件"
L["Shows the enhanced mail tooltip and styling (Icon, color, and blink animation)."] = "显示增强型邮件提示和样式(包括图标,颜色,以及闪烁动画)"
L['You have about %s unread mails'] = "你有%s封未读邮件"
L['You have about %s unread mail'] = "你有%s封未读邮件"
L[' from:'] = " 来自:"
L["Play Sound"] = "播放音效"
L["Plays a sound when a mail is received.\n|cffff8000Note: This will be disabled by default if notifcations or notification mail module is enabled.|r"] = "当收到邮件时播放音效.\n|cffff8000注意: 当邮件通知功能启用时,设置将被重置到缺省状态.|r"
L["Hide Mail Icon"] = "隐藏邮件图标"
L["Hide the mail Icon on the minimap."] = "在小地图中隐藏邮件图标"
L["Bar Backdrop"] = "背景"
L["Button Spacing"] = "按钮间距"
L["Buttons Per Row"] = "每行按钮数"
L["Blizzard"] = "暴雪原生"
L["Move Tracker Icon"] = "移动追踪图标"
L["Move Queue Status Icon"] = "移动排队等待状态图标"
L["Move Mail Icon"] = "移动邮件图标"
L["Hide Garrison Icon"] = "隐藏任务大厅图标"
L["Move Garrison Icon"] = "移动任务大厅图标"
L["Minimap Ping"] = "小地图点击者"
L["Shows the name of the player who pinged on the Minimap."] = "显示谁点击了小地图"
L["Center"] = "中间"
L["Enable/Disable Square Minimap Coords."] = "启用/禁用方形小地图坐标"
L["Coords Display"] = "坐标显示"
L["Change settings for the display of the coordinates that are on the minimap."] = "在小地图中显示坐标"
L["Minimap Mouseover"] = "鼠标经过显示"
L["Always Display"] = "总是显示"
L["Coords Location"] = "坐标显示位置"
L["This will determine where the coords are shown on the minimap."] = "设置坐标点在小地图中显示的位置"
L["Cardinal Points"] = "方位指示"
L["Places cardinal points on your minimap (N, S, E, W)"] = "启用/禁用在小地图中显示方位"
L["North"] = "北"
L["Places the north cardinal point on your minimap."] = "在小地图中显示北方"
L["East"] = "东"
L["Places the east cardinal point on your minimap."] = "在小地图中显示东方"
L["South"] = "南"
L["Places the south cardinal point on your minimap."] = "在小地图中显示南方"
L["West"] = "西"
L["Places the west cardinal point on your minimap."] = "在小地图中显示西方"
L["Worldmap"] = "世界地图"
L["World Map Frame Size"] = "世界地图尺寸"
L["World Map Frame Fade"] = true
L["World Map Frame Zoom"] = "地图缩放"
L["Mouse scroll on the world map to zoom."] = "鼠标滚轮缩放"
L["Reveal"] = "地图全亮"
L["Reveal all undiscovered areas on the world map."] = "显示未探索区域"
L["Set an overlay tint on unexplored ares on the world map."] = "设置未探索区域遮罩色"
L["Enhanced World Quests"] = "增强世界任务"
L["Enhances the regular world quests pins on the world map."] = "增强显示地图上世界任务标记"
L["Flight Queue"] = "飞行位置"
L["Location Digits"] = "区域显示精度"
L["Change the decimals of the coords on the location bar."] = "更改在区域框架中坐标的小数"
L["Location Text"] = "区域名称"
L["Change the text on the location bar."] = "更改在区域框架"
L["Version"] = "版本"
L["Minimap Mouseover"] = "小地图鼠标经过"
L["Always Display"] = "总是显示"
L["Above Minimap"] = true
L["Hide"] = "隐藏"


-- Misc
L['Miscellaneous'] = "杂项"
L["Display the Guild Message of the Day in an extra window, if updated.\nCredit: |cffff7d0aMerathilisUI|r"] = "显示公会今日最新信息"
L["Mover Transparency"] = "透明度"
L["Changes the transparency of all the movers."] = "改变可移动窗体透明度"
L["Buy Max Stack"] = "购买最大堆数"
L["Alt-Click on an item, sold buy a merchant, to buy a full stack."] = "Alt + 鼠标左键点击物品,购买最大堆数"
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
L["Cursor Flash"] = "鼠标闪光"
L["Shows a flashing star as the cursor trail."] = "启用/禁用鼠标闪光"
L["Change the alpha level of the cursor trail."] = "透明度"
L["Change how/when the cursor trail is shown."] = "可见性"
L["Always"] = "总是可见"
L["Combat"] = "战斗中"
L["Modifier"] = "自定义"
L["Already Known"] = "已学会"
L["Display a color overlay of already known/learned items."] = "在已学会物品上添加一个覆盖颜色"
L["Overlay Color"] = "覆盖颜色"
L["AFK Pet Model"] = true
L["Companion Pet Name"] = true
L["Model Scale"] = true
L["Some pets will appear huge. Lower the scale when that happens."] = true
L["Model Facing Direction"] = true
L["Less than 0 faces the model to the left, more than 0 faces the model to the right"] = true
L["Animation"] = true
L["NPC animations are not documented anywhere, and as such you will just have to try out various settings until you find the animation you want. Default animation is 0 (idle)"] = true
L["Announce Combat Status"] = "战斗状态"
L["Announce combat status in a textfield in the middle of the screen.\nCredit: |cffff7d0aMerathilisUI|r"] = "在屏幕中间显示进入/离开战斗状态"
L["Announce Skill Gains"] = "技能收益"
L["Announce skill gains in a textfield in the middle of the screen.\nCredit: |cffff7d0aMerathilisUI|r"] = "在屏幕中间显示技能收益"
L["Merchant"] = "贩卖增强"
L["Display the MerchantFrame in one window instead of a small one with variouse amount of pages."] = "在同一页中显示所有商品"
L["ItemLevel"] = "物品等级"
L["Display the item level on the MerchantFrame."] = "在商人贩卖框架中显示物品等级"
L["EquipSlot"] = "装备位置"
L["Display the equip slot on the MerchantFrame."] = "在商人贩卖框架中显示装备位置"
L["Subpages"] = true
L["Subpages are blocks of 10 items. This option set how many of subpages will be shown on a single page."] = true
L["Bloodlust"] = true
L["Sound"] = true
L["Play a sound when bloodlust/heroism is popped."] = true
L["Print a chat message of whom who popped bloodlust/heroism."] = true
L["Sound Type"] = true
L["Horde"] = "部落"
L["Alliance"] = "联盟"
L["Illidan"] = "伊利丹"
L["Sound Override"] = "音效覆盖"
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
L["Automatization"] = "自动邀请"
L["Auto Keystones"] = "自动插入钥石"
L["Automatically insert keystones when you open the keystonewindow in a dungeon."] = "当你在地下城中打开插入钥匙面板时,自动插入钥石"
L["Auto Gossip"] = true
L["This setting will auto gossip some NPC's.\n|cffff8000Note: Holding down any modifier key before visiting/talking to the respective NPC's will briefly disable the automatization.|r"] = true
L["Auto Auction"] = "拍卖助手"
L["Shift + Right-Click to auto buy auctions at the auctionhouse."] = "Shift + 鼠标右键可自动在拍卖行中竞拍"
L["Skip Azerite Animations"] = "跳过艾泽里特动画"
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
L["Invite"] = "邀请"
L["Auto Invite Keyword"] = "自动邀请关键词"
L["Invite Rank"] = "邀请级别"
L["Refresh Rank"] = "刷新等级"
L["Start Invite"] = "开始邀请"
L["KUI_INVITEGROUP_MSG"] = "Members of order %s will be invited into the group after 10 seconds."
L["Screenshot"] = "截图"
L["Auto screenshot when you get an achievement."] = "成就自动截图"
L["Screen Format"] = "图片格式"
L["Screen Quality"] = "图片质量"
L["Role Check"] = "检查角色"
L["Automatically accept all role check popups."] = "自动接受所有角色检查"
L["Confirm Role Checks"] = "确认就位检查"
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
L["Character Zoom"] = "镜头缩放"
L["Zoom Increment"] = "镜头级别"
L["Adjust the increment the camera will follow behind you."] = "调整镜头级别"
L["Zoom Speed"] = "镜头速度"
L["Adjust the zoom speed the camera will follow behind you."] = "调整镜头速度"
L["Force Max Zoom"] = "强制镜头最大距离"
L["This will force max zoom every time you enter the world"] = "强制镜头最大距离显示"
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
L["Confirm Static Popups"] = "允许弹窗"
L["CSP_DESC"] = [[此模块将自动允许WoW中许多静态弹窗.
如果一个弹出窗口没有自动允许，它可能是由于:

- 弹出窗口被暴雪锁定,如果调用将造成插件污染.
- 你需要自己在弹出窗口中点击接受.例如:银行存款.
- 第三方插件自定义弹出窗口.
- 弹出窗口还没有加入到代码中,请加入我的项目,并联系我添加.
- The popup is simply not enabled in my config option.

|cffff8000备注: 你可以在窗口弹出前按住自定义快捷键来禁用自动弹出!|r
]] -- that extra section is meant to be there!
L["Enable"] = "启用"
L["Automatically accept various static popups encountered in-game."] = "在游戏中自动接受各种弹出窗口"
L["Auto Answer"] = "自动回复"
L["REQUEST"] = [[- 未支持的弹出窗口, 如果你想在界面中启用它, 请来我的项目中提交需求: ]]
L["NOTENABLED"] = [[- static popup not enabled in the options.]]
L["PvP"] = true
L["KillStreak Sounds"] = "击杀音效"
L["Unreal Tournament sound effects for killing blow streaks."] = "成功击杀时播放音效"
L["Automatically release body when killed inside a battleground."] = "战场中死亡后自动释放尸体"
L["Check for rebirth mechanics"] = "检查复活状态"
L["Do not release if reincarnation or soulstone is up."] = "如果存在救赎或灵魂石则不释放"
L["Automatically cancel PvP duel requests."] = "自动取消决斗邀请"
L["Automatically cancel pet battles duel requests."] = "自动取消宠物对战邀请"
L["Announce"] = "通报"
L["Announce in chat if duel was rejected."] = "在聊天框中通告决斗邀请是否被拒绝"
L["Show your PvP killing blows as a popup."] = "显示你的PVP击杀数量"
L["KB Sound"] = "击杀音效"
L["Play sound when killing blows popup is shown."] = "在成功击杀后播放音效"

-- Notification
L["Notification"] = true
L["NOTIFY_DESC"] = [[Here can you control which notifications that should be displayed.

|cffff8000Note: You can either type "/testnotification" or "/tn" without the quotes, to show a test notification.|r
]] -- that extra section is meant to be there!
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
L["Quest"] = "任务"
L["Objective Progress"] = "任务进度"
L["Adds quest/mythic+ dungeon progress to the tooltip."] = "在鼠标提示中添加任务/地下城进度"
L["Auto Pilot"] = "自动完成"
L["AP_DESC"] = [[此项用以设置自动完成任务.

|cffff8000注意: 若要暂时禁用自动交接任务功能而非禁用整个模块,请在与NPC对话前按下“CTRL-Key”.
该热键可在"暂停自动交接热键"中更改.|r
]] -- that extra section is meant to be there!
L["Disable Key"] = "暂停自动交接热键"
L["When the specific key is down the quest automatization is disabled."] = "当按下指定快捷键时,暂停自动交接任务功能"
L["Auto Accept Quests"] = "自动接受任务"
L["Enable/Disable auto quest accepting"] = "启用/禁用自动接受任务"
L["Auto Complete Quests"] = "自动完成任务"
L["Enable/Disable auto quest complete"] = "启用/禁用自动完成任务"
L["Dailies Only"] = "仅日常任务"
L["Enable/Disable auto accepting for daily quests only"] = "启用/禁用仅在日常任务中生效"
L["Accept PVP Quests"] = "接受PvP任务"
L["Enable/Disable auto accepting for PvP flagging quests"] = "启用/禁用自动接受PvP任务"
L["Auto Accept Escorts"] = "自动接受护送任务"
L["Enable/Disable auto escort accepting"] = "启用/禁用自动接受护送任务"
L["Enable in Raid"] = "团队副本中生效"
L["Enable/Disable auto accepting quests in raid"] = "启用/禁用在团队副本中生效"
L["Skip Greetings"] = "跳过问候语"
L["Enable/Disable NPC's greetings skip for one or more quests"] = "启用/禁用任务中的NPC问候语"
L["Auto Select Quest Reward"] = "自动选择任务奖励"
L["Automatically select the quest reward with the highest vendor sell value."] = "自动选择最高任务奖励"
L["Quest Announce"] = "任务通报"
L["This section enables the quest announcement module which will alert you when a quest is completed."] = "当你完成任务时通报完成进度"
L["No Detail"] = true
L["Instance"] = true
L["Raid"] = "团队"
L["Party"] = "小队"
L["Solo"] = "单人"
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
L["Quest Tracker Visibility"] = "任务追踪"
L["Adjust the settings for the visibility of the questtracker (questlog) to your personal preference."] = true
L["Rested"] = "充分休息"
L["Class Hall"] = "职业大厅"

-- Raidmarkers
L["Raid Markers"] = "团队标记"
L["Options for panels providing fast access to raid markers and flares."] = "提供快速标记的图标和光柱"
L["Show/Hide raid marks."] = "启用/禁用团队标记"
L["Restore Defaults"] = "重置到默认"
L["Reset these options to defaults"] = "重置到默认配置"
L["Button Size"] = "按钮尺寸"
L["Button Spacing"] = "按钮间距"
L["Orientation"] = "方向"
L["Horizontal"] = "水平位置"
L["Vertical"] = "垂直位置"
L["Reverse"] = "反向"
L["Modifier Key"] = true
L["No tooltips"] = "无提示"
L["Raid Marker Icons"] = "标记图标"
L["Choose what Raid Marker Icon Set the bar will display."] = "选择要显示的标记"
L["Visibility"] = "可见性"
L["Always Display"] = "持续可见"
L["Visibility State"] = "可见状态"
L["Quick Mark"] = "快速标记"
L["Show the quick mark dropdown when pressing the specific key combination chosen below."] = "当按下指定快捷键时,弹出一个快速标记框体"
L["RaidMarkingButton"] = "标记按钮"
L["MouseButton1"] = "鼠标左键"
L["MouseButton2"] = "鼠标右键"
L["Auto Mark"] = "自动标记"
L["Enable/Disable auto mark of tanks and healers in dungeons."] = "启用/禁用地下城自动标记"
L["Tank Mark"] = "坦克标记"
L["Healer Mark"] = "治疗标记"
L["Star"] = "星星"
L["Circle"] = "圆形"
L["Diamond"] = "菱形"
L["Triangle"] = "三角"
L["Moon"] = "月亮"
L["Square"] = "方块"
L["Cross"] = "十字"
L["Skull"] = "骷髅"





-- Reminders
L["Reminders"] = "技能提示"
L["Solo"] = "单人"
L["Reminds you on self Buffs."] = "Buff提示器"
L["Shows the pixel glow on missing buffs."] = "在缺失buff上显示一个发光框架"
L["Solo Reminder"] = "单人提示"
L["Raid"] = "团队"
L["Shows a frame with flask/food/rune."] = "显示合剂/食物/符文框架"
L["Toggles the display of the raidbuffs backdrop."] = "切换团队buff背景显示"
L["Size"] = "尺寸"
L["Changes the size of the icons."] = "设置图标尺寸"
L["Change the alpha level of the icons."] = "设置图标透明度"
L["Class Specific Buffs"] = "职业特定Buff"
L["Shows all the class specific raidbuffs."] = "显示所有特定职业团队副本Buff"
L["Shows the pixel glow on missing raidbuffs."] = "高亮显示缺失buff"
L["Raid Buff Reminder"] = "团队Buff提示"

-- Skins
L["ActonBarProfiles"] = "动作条配置"
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
L["|cfff960d9KlixUI|r Style |cffff8000(Beta)|r"] = "|cfff960d9KlixUI|r样式|cffff8000(Beta)|r"
L["Creates decorative squares, a gradient and a shadow overlay on some frames.\n|cffff8000Note: This is still in beta state, not every blizzard frames are skinned yet!|r"] = "在一些框架中添加修饰性的阴影遮罩效果.\n|cffff8000注意: 并非作用于所有暴雪原生框架!|r"
L["|cfff960d9KlixUI|r Icon Shadow"] = "|cfff960d9KlixUI|r阴影图标"
L["Creates a shadow overlay around various icons.\n|cffff8000Note: There is still some icons that miss the shadow overlay, i'm working on them!|r"] = "在各种图标创建一个阴影效果.\n|cffff8000注意: 仍有某些部分未能全部生效,我正在积极跟进解决!|r"
L["KlixUI Vehicle"] = "KlixUI 载具"
L["Redesign the standard vehicle button with a custom one."] = "自定义载具按钮"
L["Shadow Overlay"] = "阴影覆盖"
L["Creates a shadow overlay around the whole screen for a more darker finish."] = "在游戏画面创建一个阴影覆盖效果,以获得更暗画面"
L["Shadow Level"] = "等级"
L["Change the dark finish of the shadow overlay."] = "改变阴影覆盖层的等级"
L["Addon Skins"] = "插件皮肤"
L["KUI_ADDONSKINS_DESC"] = [[本项可以修改一些外部插件的皮肤外观.

请注意:如果插件控制面板中没有加载该插件,则其中一些选项将被|cff636363禁用|r]]
L["Blizzard Skins"] = "暴雪皮肤"
L["KUI_SKINS_DESC"] = [[本项可以修改现有ElvUI的皮肤外观.

请注意，如果在ElvUI皮肤部分禁用了相应的皮肤,则其中一些选项将被|cff636363禁用|r.]]
L["ElvUI Skins"] = "ElvUI皮肤"
L["Battlefield"] = "战场"
L["Battlefield Map"] = "战场地图"
L["Battlefield Score"] = "战场记分板"
L["Character Frame"] = "聊天框"
L["Gossip Frame"] = "宏框架"
L["Quest Frames"] = "任务框架"
L["Quest Frame"] = "任务框架"
L["Quest Choice"] = "任务选择"
L["Trade"] = "交易"
L["Orderhall"] = "任务大厅"
L["Archaeology Frame"] = "考古框架"
L["Barber Shop"] = "理发店"
L["Contribution"] = "捐献"
L["Calendar Frame"] = "日历框架"
L["Merchant Frame"] = "购物框架"
L["PvP Frames"] = "PvP框架"
L["Item Upgrade"] = "物品升级"
L["LF Guild Frame"] = true
L["TalkingHead"] = "特写"
L["AddOn Manager"] = "插件管理器"
L["Mail Frame"] = "邮件"
L["Raid Frame"] = "团队框架"
L["Guild Control Frame"] = "公会控制"
L["Help Frame"] = "帮助"
L["Loot Frames"] = "物品拾取"
L["Warboard"] = "战场信息板"
L["Azerite"] = "艾泽里特"
L["BFAMission"] = true
L["Island Party Pose"] = "海岛探险"
L["Minimap"] = "小地图"
L["Stable Frame"] = "坐骑"
L["Tabard Frame"] = "战袍"
L["Craft Frame"] = "专业"
L["Communities"] = "社区"
L["Trainer Frame"] = true
L["Debug Tools"] = "错误收集器"
L["Inspect Frame"] = "装备显示"
L["Socket Frame"] = "插槽"
L["Addon Profiles"] = "插件配置"
L["KUI_PROFILE_DESC"] = [[本项可创建一部分插件配置文件.

|cffff0000注意:|r这将覆盖/删除已有配置信息.如果你不想这么做,请不要点击下面的按钮.]]
L['This will create and apply profile for '] = "创建一个新的配置文件"
L["KlixUI Skins"] = "KlixUI皮肤"

-- Talents
L["Talents"] = "天赋"
L["Toggle Talent Frame"] = "天赋切换"
L["Enable/disable the |cfff960d9KlixUI|r Better Talents Frame."] = "启用/禁用|cfff960d9KlixUI|r天赋框架"
L["Shows an animated border glow for the currently selected talents."] = "在当前选定的天赋的边框添加高亮效果"
L["Default to Talents Tab"] = true
L["Defaults to the talents tab of the talent frame on login. By default WoW shows you the specialization tab."] = true
L["Auto Hide PvP Talents"] = "自动隐藏PvP天赋"
L["Closes the PvP talents flyout on login. PvP talents and warmode flag are still accessible by manually opening the PvP talents flyout."] = "登录时关闭PvP天赋.PvP天赋及战争模式仍可通过手动打开PvP天赋栏设置"

-- Toasts
L["Toasts"] = true
L["TOAST_DESC"] = [[Here can you control which toasts that should be displayed.

|cffff8000Note: You can either type "/testtoasts" or "/tt" without the quotes, to show a test toast.|r
]] -- that extra section is meant to be there!
L["Growth Direction"] = "延伸方向"
L["Up"] = "上"
L["Down"] = "下"
L["Left"] = "左"
L["Right"] = "右"
L["Number of Toasts"] = true
L["Sound Effects"] = "音效"
L["Fade Out Delay"] = "淡出延迟"
L["Colored Names"] = "姓名着色"
L["Scale"] = "比例"
L["Colored Names"] = "姓名着色"
L["Toast Types"] = true
L["Achievement"] = "成就"
L["Archaeology"] = "考古"
L["Garrison"] = true
L["Class Hall"] = "职业大厅"
L["War Effort"] = true
L["Dungeon"] = "地下城"
L["Loot (Special)"] = true
L["Loot (Common)"] = true
L["Loot Threshold"] = true
L["Loot (Currency)"] = true
L["Loot (Gold)"] = true
L["Copper Threshold"] = true
L["Minimum amount of copper to create a toast for."] = true
L["Recipe"] = true
L["World Quest"] = "世界任务"
L["Transmogrification"] = true
L["DND"] = true

-- Tooltip
L["Tooltip"] = "鼠标提示"
L["Change the visual appearance of the Tooltip.\nCredit: |cffff7d0aMerathilisUI|r"] = "更改鼠标提示外观.\n创建者: |cffff7d0aMerathilisUI|r"
L["Title Color"] = "标题颜色"
L["Change the color of the title to something more cool!"] = "将标题改为更酷的颜色"
L["LFG Member Info"] = "集合石成员信息"
L["Adds member info for the LFG group list tooltip."] = "在集合石列表中添加成员信息"
L["Adds information to the tooltip, on which character you earned an achievement.\nCredit: |cffff7d0aMerathilisUI|r"] = "显示你在哪个角色中获得了该成就"
L["Keystone"] = "钥石"
L["Adds descriptions for mythic keystone properties to their tooltips."] = "在鼠标提示中添加钥石信息"
L["Enable/disable the azerite tooltip."] = "启用/禁用艾泽里特鼠标提示"
L["Remove Blizzard"] = "移除原生效果"
L["Replaces the blizzard azerite tooltip text."] = "替换暴雪原生艾泽里特提示"
L["Specialization"] = "专精"
L["Only show the traits for your current specialization."] = "只显示当前专精"
L["Compact"] = "紧凑"
L["Only show icons in the azerite tooltip."] = "只在艾泽里特鼠标提示中显示图标"
L["Raid Progression"] = "团队副本进度"
L["Shows raid progress of a character in the tooltip.\n|cffff8000Note: The visibility of the raid progress can be changed in the display option.|r"] = "在鼠标提示中显示团队副本进度..\n|cffff8000注意:可在显示设置中选择是否显示团队副本进度.|r"
L["Display"] = "显示"
L["Change how the raid progress should display in the tooltip."] = "设置是否在鼠标提示中显示团队副本进度"
L["Name Style"] = "名称样式"
L["Full"] = "完整"
L["Short"] = "简短"
L["Difficulty Style"] = "难度样式"
L["RAID_BOD"] = "BoD"
L["RAID_COS"] = "CoS"
L["RAID_EP"] = "EP"
L["Name Hover"] = "角色名悬停"
L["Shows the unit name, at the cursor, when hovering over a target."] = "当鼠标悬停在目标上时，在光标处显示目标名"
L["Guild Name"] = "公会名称"
L["Shows the current mouseover units guild name."] = "显示当前鼠标悬停目标的公会名称"
L["Guild Rank"] = "公会等级"
L["Shows the current mouseover units guild rank."] = "显示当前鼠标悬停目标的公会等级"
L["Level, Race & Class"] = "等级/性别/种族/职业"
L["Shows the current mouseover units level, race and class.\n|cffff8000Note: Holding down the shift key will display the gender aswell!|r"] = "显示当前鼠标悬停目标等级、种族和职业.\n|cffff8000备注: 按住shift键还可显示性别!|r"
L["Realm Name"] = true
L["Shows the current mouseover units realm name when holding down the shift-key."] = true
L["Always Show Realm Name"] = true
L["Always show the current mouseover units realm name."] = true
L["Titles"] = "标题"
L["Shows the current mouseover units titles."] = "显示当前鼠标悬停目标的标题"
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
L["UnitFrames"] = "单位框架"
L["Tags"] = "标签"
L['Power Bar'] = "能量条"
L['This will enable/disable the |cfff960d9KlixUI|r powerbar modification.|r'] = "启用/禁用|cfff960d9KlixUI|r能量条设置"
L['Healer Mana'] = "治疗蓝量"
L['Only show the mana of the healer when in a party group.'] = "当位于队伍中时,仅显示治疗职业的蓝量"
L["Focus Key"] = true
L["Show the focus frame when pressing the specific key combination chosen below."] = true
L["FocusButton"] = true
L["MouseButton"] = true
L["FK_DESC"] = [[To remove the focus frame once set, please press the same combination of focusbuttons again on any part of the UI screen you like.
]] -- that extra section is meant to be there!
L["Auras"] = "光环"
L["Aura Icon Spacing"] = "光环图标间距"
L["Aura Spacing"] = "光环间距"
L["Sets space between individual aura icons."] = "设置单个光环图标之间的间距"
L["Set Aura Spacing On Following Units"] = "设置以下单位的光环间距"
L["Player"] = "玩家"
L["Target"] = "目标"
L["TargetTarget"] = "目标的目标"
L["TargetTargetTarget"] = "目标的目标的目标"
L["Focus"] = "焦点目标"
L["FocusTarget"] = "焦点目标的目标"
L["Pet"] = "宠物"
L["PetTarget"] = "宠物目标"
L["Arena"] = "竞技场"
L["Boss"] = "首领"
L["Party"] = "小队"
L["Raid"] = "团队"
L["Raid40"] = "40人团队"
L["RaidPet"] = "团队宠物"
L["Tank"] = "坦克"
L["Assist"] = "协助"
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
L['Textures'] = "材质"
L['Health'] = "血量"
L['Health statusbar texture. Applies only on Group Frames'] = true
L['Ignore Transparency'] = "忽略透明度"
L['This will ignore ElvUI Health Transparency setting on all Group Frames.'] = "忽略所有团队框架的ElvUI透明度设置"
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
L["Anchor Point"] = "锚点"
L["Relative Point"] = "相对位置"
L["Frame Level"] = "框架层级"
L['Attack Icon'] = "攻击图标"
L['Show attack icon for units that are not tapped by you or your group, but still give kill credit when attacked.'] = "显示没有被你或你的团队选中的攻击图标，但仍会给予击杀奖励"
L['Icons'] = "图标"
L["LFG Icons"] = "查找地下城图标"
L["Choose what icon set there will be used on unitframes and in the chat."] = "选择在单位框架和聊天框中使用的图标类型"
L["ReadyCheck Icons"] = "就位确认图标"
L['|cfff960d9KlixUI|r Raid Icons'] = "|cfff960d9KlixUI|r 团队图标"
L['Replaces the default Raid Icons with the |cfff960d9KlixUI|r ones.\n|cffff8000Note: The Raid Icons Set can be changed in the |cfff960d9KlixUI|r |cffff8000Raid Markers option.|r'] = "使用|cfff960d9KlixUI|r风格图标替换默认图标.\n|cffff8000备注: Raid图标风格可以在|cfff960d9KlixUI|r |cffff8000Raid标记选项中更改.|r"
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
L["Test"] = "测试模式"
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