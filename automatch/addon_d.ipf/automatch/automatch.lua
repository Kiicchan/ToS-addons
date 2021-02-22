local addonName = "AUTOMATCH"
local author = "Kiicchan"
local version = "1.0.1"

_G["ADDONS"] = _G["ADDONS"] or {}
_G["ADDONS"][author] = _G["ADDONS"][author] or {}
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {}
local g = _G["ADDONS"][author][addonName];
local acutil = require("acutil");
local amList = {cm1 = 644, cm2 = 645, cm3 = 646, sing = 647, moring = 608, moringponia = 608, glacia = 619, giltine = 643, res = 636, relic = 636}

CHAT_SYSTEM("AutoMatch by Kiicchan");

function AUTOMATCH_ON_INIT(addon, frame)
    frame:ShowWindow(1);
    acutil.slashCommand("/automatch",AUTOMATCH_CMD);
    acutil.slashCommand("/am",AUTOMATCH_CMD);
end

function AUTOMATCH_CMD(command)
    local cmd = "";
	if #command > 0 then
        cmd = table.remove(command, 1);
    else
		AUTOMATCH_HELP()
        return;
    end
	cmd = string.lower(cmd)
	AUTOMATCH_OPEN_DUNGEON(cmd)
end

function AUTOMATCH_HELP()
	local text = "";
	text = "{s18}/automatch cm1{/}{nl} {s16}CM Area 1: Lvl 361~399{nl} {nl}";
	text = text .. "{s18}/automatch cm2{/}{nl} {s16}CM Area 2: Lvl 400+{nl} {nl}";
	text = text .. "{s18}/automatch cm3{/}{nl} {s16}CM Area 3: Lvl 450+{nl} {nl}";
	text = text .. "{s18}/automatch sing{/}{nl} {s16}Division Singularity{nl} {nl}";
	text = text .. "{s18}/automatch moring{/}{nl} {s16}Lepdoptera Junction{nl} {nl}";
	text = text .. "{s18}/automatch glacia{/}{nl} {s16}White Witch's Forest{nl} {nl}";
	text = text .. "{s18}/automatch giltine{/}{nl} {s16}Demonic Sanctuary{nl} {nl}";
	text = text .. "{s18}/automatch res sacrae{/}{nl} {s16}Res Sacrae Dungeon";
	return ui.MsgBox(text,"","Nope");
end

function AUTOMATCH_OPEN_DUNGEON(cmd)
	local indunType = amList[cmd]
	if indunType == nil then
		CHAT_SYSTEM("Invalid command");
		return;
	end
	if session.world.IsIntegrateServer() == true or IsPVPField(pc) == 1 or IsPVPServer(pc) == 1 then
        ui.SysMsg(ScpArgMsg('ThisLocalUseNot'));
        return;
    end
	local frame = ui.GetFrame('induninfo')
	local indunCls = GetClassByType('Indun', indunType)
	local btnInfoCls = GetClass('IndunInfoButton', indunCls.DungeonType)
	local redButtonScp = TryGetProp(btnInfoCls, "RedButtonScp")
	local buttonBox = GET_CHILD_RECURSIVELY(frame, 'buttonBox');
	local redButton = GET_CHILD_RECURSIVELY(buttonBox,'RedButton')
	redButton:SetUserValue('MOVE_INDUN_CLASSID', indunCls.ClassID);
	if _G[redButtonScp] ~= nil then
		_G[redButtonScp](frame, redButton)
		ReserveScript("AUTOMATCH_ENTER()", 3.5)
	end		
end

function AUTOMATCH_ENTER()
	local frame = ui.GetFrame("indunenter")
	if frame ~= nil and frame:IsVisible() == 1 then
		INDUNENTER_AUTOMATCH(frame, nil)
		CHAT_SYSTEM("Auto Match")
	end
end