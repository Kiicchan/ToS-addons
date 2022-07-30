local addonName = "IMWEAK"
local author = "Kiicchan"
local version = "1.0.1"

_G["ADDONS"] = _G["ADDONS"] or {}
_G["ADDONS"][author] = _G["ADDONS"][author] or {}
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {}
local g = _G["ADDONS"][author][addonName];

CHAT_SYSTEM("I'm Weak by Kiicchan");

local acutil = require("acutil");
function IMWEAK_ON_INIT(addon, frame)
    acutil.slashCommand("/imweak",IMWEAK_CMD);
    addon:RegisterMsg('FPS_UPDATE', 'IMWEAK_SEARCH')
    
    IMWEAK_LOADLIST();
end

function IMWEAK_LOADLIST()
	local buffList, error = acutil.loadJSON("../addons/imweak/buffList.json");
	if error then
		IMWEAK_SAVELIST();
		return
	end
        g.buffList = buffList;
end

function IMWEAK_SAVELIST()
	if g.buffList == nil then
		g.buffList = {

        };
	end
	acutil.saveJSON("../addons/imweak/buffList.json", g.buffList);
end

function IMWEAK_CMD(command)
    local cmd = "";
	if #command > 0 then
        cmd = table.remove(command, 1);
    else
		CHAT_SYSTEM("Type '/imweak buffID' to add/remove a buff from the list")
		IMWEAK_BUFFLIST_SHOW()
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
        for k, v in pairs(g.buffList) do
            if v == buffid then
                table.remove(g.buffList, k);
                CHAT_SYSTEM("Removing "..buffid..": "..buffName.." from the list");
                IMWEAK_SAVELIST();
                return;
            end
        end
        table.insert(g.buffList, buffid);
        CHAT_SYSTEM("Adding "..buffid..": "..buffName.." to the list");
        IMWEAK_SAVELIST();
    else
        CHAT_SYSTEM("Insert a number");
    end
end

function IMWEAK_SEARCH()
    local list, cnt = SelectObject(GetMyPCObject(), 1000, "ALL");
	for i = 1, cnt do			
		local handle = GetHandle(list[i]);
		if info.IsPC(handle) == 1 and info.IsNegativeRelation(handle) == 1 then
            local buffCount = info.GetBuffCount(handle);
            local stat = info.GetStat(handle);
            for i = 0, buffCount - 1 do
                local buff = info.GetBuffIndexed(handle, i);                
                for k, buffid in pairs(g.buffList) do
                    if stat ~= nil and buff ~= nil and buff.buffID == buffid or stat.HP == 0 then  
                        IMWEAK_DESTROY(handle)
                        goto continue;
                    end
                end
            end
            IMWEAK_MARKER(handle)
            ::continue::
		end
	end
end

function IMWEAK_MARKER(handle)
    local markerName = string.format('imweak_%s', handle)
    local markerFrame = ui.GetFrame(markerName)
    if markerFrame == nil then
        markerFrame = ui.CreateNewFrame('imweak', markerName)
        FRAME_AUTO_POS_TO_OBJ(markerFrame, handle, -markerFrame:GetWidth() / 2, -markerFrame:GetHeight() - 20, 3, 1, 1)
    end
end

function IMWEAK_DESTROY(handle)
    local markerName = string.format('imweak_%s', handle)
    local markerFrame = ui.GetFrame(markerName)
    if markerFrame ~= nil then
        ui.DestroyFrame(markerName)
    end
end

function IMWEAK_BUFFLIST_SHOW()
    for k, buffid in pairs(g.buffList) do
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