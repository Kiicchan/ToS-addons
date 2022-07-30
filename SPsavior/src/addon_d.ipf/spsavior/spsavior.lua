local addonName = "SPSAVIOR"
local author = "Kiicchan"

_G["ADDONS"] = _G["ADDONS"] or {}
_G["ADDONS"][author] = _G["ADDONS"][author] or {}
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {}
local g = _G["ADDONS"][author][addonName];
--CHAT_SYSTEM("SP Savior by Kiicchan");

local acutil = require("acutil");
function SPSAVIOR_ON_INIT(addon, frame)
    frame:ShowWindow(1);
    acutil.slashCommand("/spsavior",SPSAVIOR_CMD);    
    acutil.slashCommand("/bufflist",SPSAVIOR_BUFFLIST_CMD);
    addon:RegisterMsg('STAT_UPDATE', 'SPSAVIOR_ON_MSG');
    
    SPSAVIOR_LOADSETTINGS();
end

function SPSAVIOR_LOADSETTINGS()
	local settings, error = acutil.loadJSON("../addons/spsavior/settings.json");
	if error then
		SPSAVIOR_SAVESETTINGS();
		return
	end
        g.settings = settings;
end

function SPSAVIOR_SAVESETTINGS()
	if g.settings == nil then
		g.settings = {
            SPtrigger = 0,
            buffList = {}
        };
	end
	acutil.saveJSON("../addons/spsavior/settings.json", g.settings);
end

function SPSAVIOR_BUFFLIST_CMD(command)
    local cmd = "";
	if #command > 0 then
        cmd = table.remove(command, 1);
    else
		SPSAVIOR_SHOW_LIST();
        return;
    end
	if cmd == "help" then
		CHAT_SYSTEM("'/spsavior SP' to set the SP trigger. Set 0 to turn off the addon.");
        CHAT_SYSTEM("'/bufflist BuffID' to remove or add a buff to the removal list{nl} Check buff Ids on tos.neet.tv");
        return;
    end
    
    local buffid = tonumber(cmd);
    if buffid ~= nil then
        local buffObj = GetClassByType('Buff',buffid);
        local buffName = "";
        if buffObj ~= nil then
            buffName = buffObj.Name;
        else
            CHAT_SYSTEM(buffid.." is not a buff");
            return;
        end
        for k, v in pairs(g.settings.buffList) do
            if v == buffid then
                table.remove(g.settings.buffList, k);
                CHAT_SYSTEM("Removing "..buffid..": "..buffName.." from the list");
                SPSAVIOR_SAVESETTINGS();
                return;
            end
        end
        table.insert(g.settings.buffList, buffid);
        CHAT_SYSTEM("Adding "..buffid..": "..buffName.." to the list");
        SPSAVIOR_SAVESETTINGS();
    else
        CHAT_SYSTEM("Insert a number");
    end
end

function SPSAVIOR_CMD(command)
    local cmd = "";
	if #command > 0 then
        cmd = table.remove(command, 1);
    else
		SPSAVIOR_SHOW_LIST();
        return;
    end
	if cmd == "help" then
		CHAT_SYSTEM("'/spsavior SP' to set the SP trigger. Set 0 to turn off the addon.");
        CHAT_SYSTEM("'/bufflist BuffID' to remove or add a buff to the removal list{nl} Check buff IDs on tos.neet.tv");
        return;
    end

    local SPtrigger = tonumber(cmd)
    if cmd ~= nil then
        g.settings.SPtrigger = SPtrigger;
        CHAT_SYSTEM("SP trigger setted to ".. SPtrigger);
        SPSAVIOR_SAVESETTINGS();
    else
        CHAT_SYSTEM("Insert a number");
    end
end

function SPSAVIOR_SHOW_LIST()
    CHAT_SYSTEM("SP trigger: "..g.settings.SPtrigger);
    CHAT_SYSTEM("Buffs being removed: ");
    for k, buffid in pairs(g.settings.buffList) do
        local buffObj = GetClassByType('Buff',tonumber(buffid));
        if buffObj ~= nil then
            local buffName = buffObj.Name;
            CHAT_SYSTEM(buffid.. ": "..buffName);
        else
            CHAT_SYSTEM(buffid.." is not a buff");
        end
    end
    CHAT_SYSTEM("--- LIST END");
end

function SPSAVIOR_ON_MSG(frame, msg, argStr, argNum)
    if g.settings.SPtrigger == 0 then
        return;
    end
    if g.validation ~= true then
        SPSAVIOR_VALIDATION();
    end

    local stat = info.GetStat(session.GetMyHandle());
    
    if stat.SP < g.settings.SPtrigger and g.validation then
        for k, buffid in pairs(g.settings.buffList) do
            local handle = session.GetMyHandle();
            local buff = info.GetBuff(handle, buffid) or nil;
            
            if buff ~= nil then
                packet.ReqRemoveBuff(buffid);
            end
        end
    end
end

function SPSAVIOR_VALIDATION()
	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	local guildName = pcparty.info.name;
	if guildName == "Paradise" then
		g.validation = true;
	end
end