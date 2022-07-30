local addonName = "DIET"
local author = "Kiicchan"

_G["ADDONS"] = _G["ADDONS"] or {}
_G["ADDONS"][author] = _G["ADDONS"][author] or {}
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {}
local g = _G["ADDONS"][author][addonName];

local acutil = require("acutil");
function DIET_ON_INIT(addon, frame)
    frame:ShowWindow(1);
    acutil.slashCommand("/diet",DIET_CREATE_TIMER);
end

function DIET_CREATE_TIMER()
    g.comidas = {4021, 4022, 4023, 4024, 4087, 4136};
    local frame = ui.GetFrame("diet");
    local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("DIET_UPDATE");
    timer:Start(0.4);
end

function DIET_UPDATE()
    local buffID = table.remove(g.comidas);
    if buffID ~= nil then
        local handle = session.GetMyHandle();
        local buff = info.GetBuff(handle, buffID) or nil;
            
        if buff ~= nil then
            packet.ReqRemoveBuff(buffID);
        end
    else
        DIET_END();
    end
end

function DIET_END()
    local frame = ui.GetFrame("diet");
    local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
    timer:Stop();
    CHAT_SYSTEM("Food buffs removed");
end