local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local MI = KUI:GetModule("KuiMisc")

local function AutoInvite(...)
    local event, arg1, arg2 = ...
    if ((not T.UnitExists("party1") or T.UnitIsGroupLeader("player") or T.UnitIsGroupAssistant("player")) and (arg1:lower() == E.db.KlixUI.misc.auto.invite.ainvkeyword:lower())) and E.db.KlixUI.misc.auto.invite.enable then
        if event == "CHAT_MSG_BN_WHISPER" then
            local totalBNet = T.BNGetNumFriends()
            for i = 1, totalBNet do
                local _, presenceName, _, _, _, bnetIDGameAccount, client, isOnline = T.BNGetFriendInfo(i)
                if isOnline and presenceName == arg2 and client == "WoW" and bnetIDGameAccount then
                    local _, charName, _, realmName = T.BNGetGameAccountInfo(bnetIDGameAccount)
                    if realmName ~= T.GetRealmName() then charName = charName .. "-" .. realmName end
                    T.InviteToGroup(charName)
                    return
                end
            end
        else
            T.InviteToGroup(arg2)
        end
    end
end

function MI:GetGuildRanks()
    local value = {}
    if T.IsInGuild() then
        local ranks = T.GuildControlGetNumRanks()
        for i = 1, ranks do
            value[i] = T.GuildControlGetRankName(i)
        end
    end
    return value
end

function MI:InviteRanks()
    if not T.IsInGuild() then return end
    
    local numMembers = T.GetNumGuildMembers()
    for i = 1, numMembers do
        local name, _, rankIndex, _, _, _, _, _, online = T.GetGuildRosterInfo(i)
        if online and E.db.KlixUI.misc.auto.invite.inviteRank[rankIndex] then
			T.pcall(T.InviteUnit, name)
        end
        if not T.IsInRaid() and T.IsInGroup() and T.UnitIsGroupLeader("player") then T.ConvertToRaid() end
    end
end

function MI:LoadInviteGroup()
    self:RegisterEvent("CHAT_MSG_WHISPER", AutoInvite)
    self:RegisterEvent("CHAT_MSG_BN_WHISPER", AutoInvite)
end
