local addonName = "PARTYDUEL"
local author = "Kiicchan"
local version = "2.0.1"

_G["ADDONS"] = _G["ADDONS"] or {}
_G["ADDONS"][author] = _G["ADDONS"][author] or {}
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {}
local g = _G["ADDONS"][author][addonName];
g.playerList = {};

local acutil = require("acutil");
CHAT_SYSTEM("PartyDuel by Kiicchan!");

function PARTYDUEL_ON_INIT(addon, frame)
	frame:ShowWindow(1);
    acutil.slashCommand("/partyduel",PARTYDUEL_PARTY_CMD);
    acutil.slashCommand("/guildduel",PARTYDUEL_GUILD_CMD);
    acutil.slashCommand("/acceptduel",PARTYDUEL_ACCEPTDUEL_CMD);
    acutil.slashCommand("/pkend",PARTYDUEL_PK_END);
    acutil.slashCommand("/pkstart",PARTYDUEL_PK_START);
    addon:RegisterMsg("GAME_START_3SEC", "PARTYDUEL_GAMESTART");
    
    PARTYDUEL_LOADSETTINGS();
end

function PARTYDUEL_LOADSETTINGS()
	local settings, error = acutil.loadJSON("../addons/partyduel/settings.json");
	if error then
		PARTYDUEL_SAVESETTINGS();
		return
	end
		g.settings = settings;
end

function PARTYDUEL_SAVESETTINGS()
	if g.settings == nil then
		g.settings = {
            acceptDuel = 2,
            autoDuel = 0
		};
	end
	acutil.saveJSON("../addons/partyduel/settings.json", g.settings);
end

function PARTYDUEL_GAMESTART()
    if g.settings.autoDuel == 1 then
        PARTYDUEL_PK_START();
    end
    if g.settings.acceptDuel == 1 then
        CHAT_SYSTEM("Auto accepting duel requests");
    end
end

function PARTYDUEL_ACCEPTDUEL_CMD(command)
    local acceptDuel = "";
	if #command > 0 then
		acceptDuel = table.remove(command, 1);
	else
        PARTYDUEL_HELP();
        return;
    end

    if acceptDuel == "yes" then
        g.settings.acceptDuel = 1;
        PARTYDUEL_SAVESETTINGS();
        CHAT_SYSTEM("Auto accepting duel requests");
    elseif acceptDuel == "no" then
        g.settings.acceptDuel = 0;
        PARTYDUEL_SAVESETTINGS();
        CHAT_SYSTEM("Auto rejecting duel requests");
    elseif acceptDuel == "ask" then
        g.settings.acceptDuel = 2;
        PARTYDUEL_SAVESETTINGS();
        CHAT_SYSTEM("Asking before accepting duel requests");
    else 
        CHAT_SYSTEM("Invalid command. Use 'yes' for auto accept, 'no' for auto reject or 'ask' for asking before accepting");
    end
    return;
end

function PARTYDUEL_HELP()
    CHAT_SYSTEM("Help: {nl}'/partyduel PlayerName' to invite the player and his party members to a duel{nl} '/guildduel GuildName' to invite all guild members to a duel {nl} '/acceptduel yes/no/ask' to config auto-accept duel option");
    CHAT_SYSTEM("'/pkstart' to start PK mode");
    CHAT_SYSTEM("'/pkend' to end PK mode");
end

function PARTYDUEL_GUILD_CMD(command)    
    local targetGuild = "";
	if #command > 0 then
		targetGuild = table.remove(command, 1);
	else
        PARTYDUEL_HELP();
        return;
    end
    
    if world.IsPVPMap() == true then
        CHAT_SYSTEM("You're in a PVP area");
        return;
    end
    
    CHAT_SYSTEM("Inviting "..targetGuild.."'s members to a duel");
    PARTYDUEL_STOP_TIMER();
    PARTYDUEL_GUILD_FIND(targetGuild);
    PARTYDUEL_CREATE_TIMER();
end

function PARTYDUEL_GUILD_FIND(targetGuild)
    local list, cnt = SelectObject(GetMyPCObject(), 10000, "ALL");
	for i = 1, cnt do			
		local ObHandle = GetHandle(list[i]);
        local stat = info.GetStat(ObHandle);
        if stat ~= nil and info.IsPC(ObHandle) == 1 and info.IsNegativeRelation(ObHandle) == 0 and stat.HP > 300 then				
            local charFrame = ui.GetFrame("charbaseinfo1_"..ObHandle);
            if charFrame ~= nil then
                local guildText = charFrame:GetChild("guildName");
                local guildName = guildText:GetTextByKey("guildName");
                guildName = guildName:gsub("{(.-)}", "");
                if guildName == targetGuild then
                   table.insert(g.playerList, ObHandle);
                end
            end
        end
    end
end

function PARTYDUEL_PARTY_CMD(command)    
    local targetPlayer = "";
	if #command > 0 then
		targetPlayer = table.remove(command, 1);
	else
        PARTYDUEL_HELP();
        return;
    end
    
    if world.IsPVPMap() == true then
        CHAT_SYSTEM("You're in a PVP area");
        return;
    end

    local targetActor = world.GetActorByFamilyName(targetPlayer);
    if targetActor == nil then
        CHAT_SYSTEM(targetPlayer.." not found");
        return;
    end
    
    local targetHandle = targetActor:GetHandleVal()    
    if targetHandle ~= session.GetMyHandle() then
        CHAT_SYSTEM("Inviting "..targetPlayer.." and party to a duel");
    else
        CHAT_SYSTEM("You can't duel yourself");
        return;
    end

    local targetFrame = ui.GetFrame("charbaseinfo1_"..targetHandle)
    if targetFrame ~= nil then
        local targetText = targetFrame:GetChild("partyName");
        local targetParty = targetText:GetTextByKey("partyName");
        targetParty = targetParty:gsub("{(.-)}", "");

        if targetParty == "None" then
            REQUEST_FIGHT(targetHandle);
            CHAT_SYSTEM("This Player has no party");
            return;
        end
        PARTYDUEL_STOP_TIMER();
        PARTYDUEL_PARTY_FIND(targetParty);
        PARTYDUEL_CREATE_TIMER();
    end
end

function PARTYDUEL_PARTY_FIND(targetParty)
    local list, cnt = SelectObject(GetMyPCObject(), 10000, "ALL");        
    for i = 1, cnt do			
        local ObHandle = GetHandle(list[i]);
        local stat = info.GetStat(ObHandle);
        if stat ~= nil and info.IsPC(ObHandle) == 1 and info.IsNegativeRelation(ObHandle) == 0 and stat.HP > 300 then				
            local charFrame = ui.GetFrame("charbaseinfo1_"..ObHandle);
            if charFrame ~= nil then
                local partyText = charFrame:GetChild("partyName");
                local partyName = partyText:GetTextByKey("partyName");
                partyName = partyName:gsub("{(.-)}", "");
                if partyName == targetParty then
                    table.insert(g.playerList, ObHandle);
                end
            end
        end
    end
end

function PARTYDUEL_PK_START()
    if world.IsPVPMap() == true then
        CHAT_SYSTEM("You're in a PVP area");
        return;
    end
    CHAT_SYSTEM("Starting PK Mode");
    g.settings.acceptDuel = 1;
    g.settings.autoDuel = 1;
    PARTYDUEL_SAVESETTINGS();
    UI_CHAT("!!PK mode");
    PARTYDUEL_PK_FIND();
    PARTYDUEL_CREATE_TIMER();
end

function PARTYDUEL_PK_END()
    CHAT_SYSTEM("Ending PK Mode");
    g.settings.acceptDuel = 2;
    g.settings.autoDuel = 0;
    PARTYDUEL_SAVESETTINGS();
    UI_CHAT("!!");
end

function PARTYDUEL_PK_FIND()
    local list, cnt = SelectObject(GetMyPCObject(), 10000, "ALL");        
    for i = 1, cnt do			
        local ObHandle = GetHandle(list[i]);
        local stat = info.GetStat(ObHandle);
        if stat ~= nil and info.IsPC(ObHandle) == 1 and ObHandle ~= session.GetMyHandle() and info.IsNegativeRelation(ObHandle) == 0 and stat.HP > 300 then
            local PCfamily = info.GetFamilyName(ObHandle);
            local IsParty = session.party.GetPartyMemberInfoByName(PARTY_NORMAL, PCfamily) ~= nil;				
            local pctitleFrame = ui.GetFrame(ObHandle.."_pctitle");
            if pctitleFrame ~= nil then
                local pctitleText = pctitleFrame:GetChild("text");
                local pctitle = pctitleText:GetTextByKey("value");
                pctitle = pctitle:gsub("{(.-)}", "");
                if pctitle == "PK mode" and not IsParty then
                    table.insert(g.playerList, ObHandle);
                end
            end
        end
    end
end

function PARTYDUEL_CREATE_TIMER()
    local frame = ui.GetFrame("partyduel");
    local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("PARTYDUEL_REQUEST");
    timer:Start(0.5);
end

function PARTYDUEL_STOP_TIMER()
    local frame = ui.GetFrame("partyduel");
    local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:Stop();
end

function ASKED_FRIENDLY_FIGHT(handle, familyName)
    if g.settings.acceptDuel == 0 then
        return;
    elseif g.settings.acceptDuel == 1 then
        ACK_FRIENDLY_FIGHT(handle);
        return;
    end

	local msgBoxString = ScpArgMsg("DoYouAcceptFriendlyFightingWith{Name}?", "Name", familyName);
	ui.MsgBox(msgBoxString, string.format("ACK_FRIENDLY_FIGHT(%d)", handle) ,"None");
end

function PARTYDUEL_REQUEST()
    local mystat = info.GetStat(session.GetMyHandle());
    if mystat == nil or mystat.HP < 300 then
        return;
    end

    local playerHandle = table.remove(g.playerList);
    if playerHandle ~= nil then
        local stat = info.GetStat(playerHandle);
        if stat ~= nil and info.IsPC(playerHandle) == 1 and stat.HP > 300 then
            local playerName = info.GetFamilyName(playerHandle);
            CHAT_SYSTEM("Inviting "..playerName);
            REQUEST_FIGHT(playerHandle);
        end
    else
        if g.settings.autoDuel == 0 then
            PARTYDUEL_STOP_TIMER();
            CHAT_SYSTEM("----REQUEST END");
        else
            PARTYDUEL_PK_FIND();
        end
    end
end