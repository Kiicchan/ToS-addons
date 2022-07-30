local addonName = "AUTOMATCH"
local author = "Kiicchan"
local version = "1.0.2"

_G["ADDONS"] = _G["ADDONS"] or {}
_G["ADDONS"][author] = _G["ADDONS"][author] or {}
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {}
local g = _G["ADDONS"][author][addonName];
local acutil = require("acutil");
local amList = {cm = 646, sing = 647, moring = 608, moringponia = 608, glacia = 619, res = 636, reshard = 643 , relic = 636, relichard = 643, giltine = 635, medusa = 656, vasilisa = 656}

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
	text = "{s18}/am cm{/}{nl} {s16}CM Automatch 440+{nl} {nl}";
	text = text .. "{s18}/am sing{/}{nl} {s16}Division Singularity{nl} {nl}";
	text = text .. "{s18}/am moring{/}{nl}{s18}/am moringponia{/}{nl} {s16}Lepdoptera Junction{nl} {nl}";
	text = text .. "{s18}/am glacia{/}{nl} {s16}White Witch's Forest{nl} {nl}";
	text = text .. "{s18}/am giltine{/}{nl} {s16}Demonic Sanctuary{nl} {nl}";
	text = text .. "{s18}/am res{/}{nl}{s18}/am relic{/}{nl} {s16}Res Sacrae Dungeon (Normal) {nl} {nl}";
	text = text .. "{s18}/am reshard{/}{nl}{s18}/am relichard{/}{nl} {s16}Res Sacrae Dungeon (Hard) {nl} {nl}";
	text = text .. "{s18}/am vasilisa{/}{nl}{s18}/am medusa{/}{nl} {s16}Saint's Sacellum {nl} {nl}";
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
		ReserveScript("AUTOMATCH_ENTER()", 0.5)
	end		
end

function AUTOMATCH_ENTER()
	local frame = ui.GetFrame("indunenter")
	if frame ~= nil and frame:IsVisible() == 1 then
		INDUNENTER_AUTOMATCH(frame, nil)
		CHAT_SYSTEM("Auto Match")
	end
end