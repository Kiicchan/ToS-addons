local addonName = "MOSTWANTED"
local author = "Kiicchan"
local version = "1.0.2"

_G["ADDONS"] = _G["ADDONS"] or {}
_G["ADDONS"][author] = _G["ADDONS"][author] or {}
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {}
local g = _G["ADDONS"][author][addonName];
g.handleList = {};
CHAT_SYSTEM("Most Wanted by Kiicchan");

local acutil = require("acutil");
function MOSTWANTED_ON_INIT(addon, frame)
    acutil.slashCommand("/mostwanted",MOSTWANTED_CMD);
    addon:RegisterMsg('FPS_UPDATE', 'MOSTWANTED_SEARCH')
    
    MOSTWANTED_LOADLIST();
end

function MOSTWANTED_LOADLIST()
	local playerList, error = acutil.loadJSON("../addons/mostwanted/playerList.json");
	if error then
		MOSTWANTED_SAVELIST();
		return
	end
        g.playerList = playerList;
end

function MOSTWANTED_SAVELIST()
	if g.playerList == nil then
		g.playerList = {

        };
	end
	acutil.saveJSON("../addons/mostwanted/playerList.json", g.playerList);
end

function MOSTWANTED_CMD(command)
    local cmd = "";
	if #command > 0 then
        cmd = table.remove(command, 1);
    else
		CHAT_SYSTEM("Type '/mostwanted PlayerName' to add/remove a player from the list")
		MOSTWANTED_PLAYERLIST_SHOW()
        return;
    end

    local playerName = cmd;
	
	for k, v in pairs(g.playerList) do
		if v == playerName then
			table.remove(g.playerList, k);
			CHAT_SYSTEM("Removing "..playerName.." from the list");
			MOSTWANTED_SAVELIST();
			return;
		end
	end
	table.insert(g.playerList, playerName);
	CHAT_SYSTEM("Adding "..playerName.." to the list");
	MOSTWANTED_SAVELIST();
end

function MOSTWANTED_SEARCH()
    local list, cnt = SelectObject(GetMyPCObject(), 1000, "ALL");
	for i = 1, cnt do			
		local handle = GetHandle(list[i]);
		if info.IsPC(handle) == 1 and info.IsNegativeRelation(handle) == 1 then
            local PCfamily = info.GetFamilyName(handle);
            for k, playerName in pairs(g.playerList) do
                if PCfamily == playerName then
                    MOSTWANTED_MARKER(handle)
                end
            end
		end
	end
    MOSTWANTED_DESTROY()
end

function MOSTWANTED_MARKER(handle)
    local markerName = string.format('mostwanted_%s', handle)
    local markerFrame = ui.GetFrame(markerName)
    if markerFrame == nil then
        markerFrame = ui.CreateNewFrame('mostwanted', markerName)
        FRAME_AUTO_POS_TO_OBJ(markerFrame, handle, -markerFrame:GetWidth() / 2, -markerFrame:GetHeight() - 20, 3, 1, 1)
        table.insert(g.handleList, handle)
    end
end

function MOSTWANTED_DESTROY()
    for k, handle in pairs(g.handleList) do
        if info.GetTargetInfo(handle) == nil then
            local markerName = string.format('mostwanted_%s', handle)
            local markerFrame = ui.GetFrame(markerName)
            if markerFrame ~= nil then
                ui.DestroyFrame(markerName)
            end
            table.remove(g.handleList, k)
        end
    end
end

function MOSTWANTED_PLAYERLIST_SHOW()
    CHAT_SYSTEM("MOST WANTED:");
    for k, playerName in pairs(g.playerList) do
        CHAT_SYSTEM(playerName);
    end
    CHAT_SYSTEM("--- LIST END");
end