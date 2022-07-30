local addonName = "warmodeparadise"
local author = "Kiicchan"
local version = "2.4.2"

_G["ADDONS"] = _G["ADDONS"] or {}
_G["ADDONS"][author] = _G["ADDONS"][author] or {}
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {}
local g = _G["ADDONS"][author][addonName];

local acutil = require("acutil");
CHAT_SYSTEM("Warmode Paradise by Kiicchan!");


function WARMODEPARADISE_ON_INIT(addon, frame)
	frame:ShowWindow(1);
	
	acutil.slashCommand("/warmode",WARMODE_CMD);
	acutil.slashCommand("/clear",WARMODE_CLEAR_CMD);
	acutil.slashCommand("/playerlist",WARMODE_PLAYERLIST_CMD);	
	addon:RegisterMsg("GAME_START", "WARMODE_START");
	addon:RegisterMsg("FPS_UPDATE", "WARMODE_CLEAR");	
	
	WARMODE_LOADSETTINGS();
	WARMODE_LOADLIST();
	WARMODE_LOAD_NPCLIST();
	WARMODE_CLEARFRAME();
	WARMODE_CUSTOMFRAME();
end

function WARMODE_LOADSETTINGS()
	local settings, error = acutil.loadJSON("../addons/warmodeparadise/settings.json");
	if error then
		WARMODE_SAVESETTINGS();
	else
		g.settings = settings;
	end
end

function WARMODE_SAVESETTINGS()
	if g.settings == nil then
		g.settings = {
			load = 0,
			effects = 1,
			minimal = 1,
			graphics = 0,
			chars = 99,
			monsters = 99,
			debuff = 1,
			customdisplayX = 770,
			customdisplayY = 400,
			customframe = false,
			clearguild = 1,
			clearparty = 1,
			clearPC = 1,
			clearlist = 1,
			clearneutral = 1,
			clearpet = 1,
			clearmy = 1,
			clearskill = 1,
			clearstatue = 1,
			clear = false,
			cleardisplayX = 510,
			cleardisplayY = 400,
			clearframe = false
		};
	end
	g.settings.clear = (g.settings.clearguild * g.settings.clearneutral * g.settings.clearPC * g.settings.clearparty * g.settings.clearpet * g.settings.clearmy * g.settings.clearskill * g.settings.clearstatue) == 0;
	acutil.saveJSON("../addons/warmodeparadise/settings.json", g.settings);
end

function WARMODE_START()
	CHAT_SYSTEM("Type '/warmode' or '/clear' for options.");
	
	if g.settings.load == 1 then
		CUSTOM_MODE();
		CHAT_SYSTEM("Warmode Auto Loaded");
	end
end

function WARMODE_CMD(command)
	local cmd = "";
	if #command > 0 then
        cmd = table.remove(command, 1);
	else
		WARMODE_SHOW_CUSTOMFRAME();
        return;
    end
	if cmd == "help" then
		CHAT_SYSTEM("Warmodes:{nl}'/warmode high'{nl}'/warmode medium'{nl}'/warmode low'{nl}'/warmode ulow'{nl}'/warmode despair'");
		CHAT_SYSTEM("Warmode custom options:{nl}'/warmode effects'{nl}'/warmode minimal'{nl}'/warmode debuff'{nl}'/warmode graphics'{nl}'/warmode players'{nl}'/warmode npc'{nl}'/warmode hideall'{nl}'/warmode showfew'{nl}'/warmode showall'");
		CHAT_SYSTEM("Warmode clear options:{nl}'/clear party'{nl}'/clear guild'{nl}'/clear PC'{nl}'/clear list'{nl}'/clear monster'{nl}'/clear NPC'{nl}'/clear pet'{nl}'/clear all'{nl}'/clear none'{nl}");
	elseif cmd == "high" then
		HIGH_MODE();
		CHAT_SYSTEM("High Mode");
	elseif cmd == "medium" then
		MEDIUM_MODE();
		CHAT_SYSTEM("Medium Mode");
	elseif cmd == "low" then
		LOW_MODE();
		CHAT_SYSTEM("Low Mode");
	elseif cmd == "ulow" then
		ULOW_MODE();
		CHAT_SYSTEM("Ultra Low Mode");
	elseif cmd == "despair" then
		DESPAIR_MODE();
		CHAT_SYSTEM("DESPAIR Mode");
	elseif cmd == "hideall" then
		WARMODE_ENABLE_CHARS(0);
		WARMODE_ENABLE_MONSTERS(0);
		WARMODE_SAVESETTINGS();
		WARMODE_CUSTOMFRAME();
	elseif cmd == "showfew" then
		WARMODE_ENABLE_CHARS(30);
		WARMODE_ENABLE_MONSTERS(30);
		WARMODE_SAVESETTINGS();
		WARMODE_CUSTOMFRAME();
	elseif cmd == "showall" then
		WARMODE_ENABLE_CHARS(99);
		WARMODE_ENABLE_MONSTERS(99);
		WARMODE_SAVESETTINGS();
		WARMODE_CUSTOMFRAME();
	else
		WARMODE_TOGGLE_CUSTOM(cmd);
		return;
	end
	return;
end

function CUSTOM_MODE()
	WARMODE_ENABLE_GRAPHICS(g.settings.graphics);
	WARMODE_ENABLE_EFFECTS(g.settings.effects);
	WARMODE_ENABLE_MINIMAL_EFFECTS(g.settings.minimal);
	WARMODE_ENABLE_CHARS(g.settings.chars);
	WARMODE_ENABLE_MONSTERS(g.settings.monsters);
	WARMODE_ENABLE_DEBUFF_WINDOW(g.settings.debuff);
end

function HIGH_MODE()
	WARMODE_ENABLE_GRAPHICS(1);
	WARMODE_ENABLE_EFFECTS(1);
	WARMODE_ENABLE_MINIMAL_EFFECTS(1);
	WARMODE_ENABLE_CHARS(99);
	WARMODE_ENABLE_MONSTERS(99);
	WARMODE_ENABLE_DEBUFF_WINDOW(1);
	WARMODE_SAVESETTINGS();
	WARMODE_CUSTOMFRAME();
end

function MEDIUM_MODE()
	WARMODE_ENABLE_GRAPHICS(0);
	WARMODE_ENABLE_EFFECTS(1);
	WARMODE_ENABLE_MINIMAL_EFFECTS(1);
	WARMODE_ENABLE_CHARS(50);
	WARMODE_ENABLE_MONSTERS(50);
	WARMODE_ENABLE_DEBUFF_WINDOW(1);
	WARMODE_SAVESETTINGS();
	WARMODE_CUSTOMFRAME();
end

function LOW_MODE()
	WARMODE_ENABLE_GRAPHICS(0);
	WARMODE_ENABLE_EFFECTS(1);
	WARMODE_ENABLE_MINIMAL_EFFECTS(0);
	WARMODE_ENABLE_CHARS(30);
	WARMODE_ENABLE_MONSTERS(30);
	WARMODE_ENABLE_DEBUFF_WINDOW(0);
	WARMODE_SAVESETTINGS();
	WARMODE_CUSTOMFRAME();
end

function ULOW_MODE()
	WARMODE_ENABLE_GRAPHICS(0);
	WARMODE_ENABLE_EFFECTS(0);
	WARMODE_ENABLE_MINIMAL_EFFECTS(0);
	WARMODE_ENABLE_CHARS(30);
	WARMODE_ENABLE_MONSTERS(30);
	WARMODE_ENABLE_DEBUFF_WINDOW(0);
	WARMODE_SAVESETTINGS();
	WARMODE_CUSTOMFRAME();
end

function DESPAIR_MODE()
	WARMODE_ENABLE_GRAPHICS(0);
	WARMODE_ENABLE_EFFECTS(0);
	WARMODE_ENABLE_MINIMAL_EFFECTS(0);
	WARMODE_ENABLE_CHARS(0);
	WARMODE_ENABLE_MONSTERS(0);
	WARMODE_ENABLE_DEBUFF_WINDOW(0);
	WARMODE_SAVESETTINGS();
	WARMODE_CUSTOMFRAME();
end

function WARMODE_ENABLE_EFFECTS(switch)
	g.settings.effects = switch;
    imcperfOnOff.EnableIMCEffect(switch);
	imcperfOnOff.EnableEffect(switch);	
	imcperfOnOff.EnableParticleVertex(switch);
end

function WARMODE_ENABLE_MINIMAL_EFFECTS(switch)
	g.settings.minimal = switch;
	imcperfOnOff.EnableBloomObject(switch);
	imcperfOnOff.EnableDeadParts(switch);
	imcperfOnOff.EnableDepth(switch);
	imcperfOnOff.EnableDynamicTree(switch);
	imcperfOnOff.EnableFog(switch);
	imcperfOnOff.EnableFork(switch);
	imcperfOnOff.EnableGrass(switch);
	imcperfOnOff.EnableLight(switch);
	imcperfOnOff.EnableParticleEffectModel(switch);
	imcperfOnOff.EnableParticleInstancing(switch);
	imcperfOnOff.EnableParticleInstancing2(switch);
	imcperfOnOff.EnableParticleModel(switch);
	imcperfOnOff.EnableParticlePoint(switch);
	imcperfOnOff.EnableParticleScreen(switch);
	imcperfOnOff.EnablePlaneLight(switch);
	imcperfOnOff.EnableRenderShadow(switch);
	imcperfOnOff.EnableSky(switch);
	imcperfOnOff.EnableWater(switch);
	geScene.option.SetUseBGWaterReflection(switch);
end

function WARMODE_ENABLE_GRAPHICS(switch)
	g.settings.graphics = switch;
	graphic.EnableBloom(switch);
	graphic.EnableCharEdge(switch);
    graphic.EnableFXAA(switch);
    graphic.EnableGlow(switch);
	graphic.EnableHighTexture(switch);
	graphic.EnableHitGlow(switch);
	graphic.EnableSoftParticle(switch);
	graphic.EnableWater(switch);
end

function WARMODE_ENABLE_CHARS(switch)
	g.settings.chars = switch; 
	if switch == 0 then
		graphic.SetDrawActor(-100);
	else
		graphic.SetDrawActor(switch);
	end
end

function WARMODE_ENABLE_MONSTERS(switch)
	g.settings.monsters = switch;
	if switch == 0 then
		graphic.SetDrawMonster(-100);
	else
		graphic.SetDrawMonster(switch);
	end
end

function WARMODE_ENABLE_DEBUFF_WINDOW(switch)
	g.settings.debuff = switch;
	if switch == 0 then
		config.SetShowTargetDeBuffMinimize(1);
	else
		config.SetShowTargetDeBuffMinimize(0);
	end
end

function WARMODE_CLEAR_CMD(command)
	local cmd = "";
	if #command > 0 then
        cmd = table.remove(command, 1);
	else
		WARMODE_SHOW_CLEARFRAME();
        return;
	end
	WARMODE_TOGGLE_CLEAR(cmd);
end

function WARMODE_TOGGLE_CLEAR(option)	
	if option == "party" then
		if g.settings.clearparty == 0 then
			g.settings.clearparty = 1;
			CHAT_SYSTEM("Not clearing party members");
		else
			g.settings.clearparty = 0;
			CHAT_SYSTEM("Clearing party members");
		end
	elseif option == "guild" then
		if g.settings.clearguild == 0 then
			g.settings.clearguild = 1;
			CHAT_SYSTEM("Not clearing guild members");
		else
			g.settings.clearguild = 0;
			CHAT_SYSTEM("Clearing guild members");
		end
	elseif option == "PC" then
		if g.settings.clearPC == 0 then
			g.settings.clearPC = 1;
			CHAT_SYSTEM("Not clearing other players");
		else
			g.settings.clearPC = 0;
			CHAT_SYSTEM("Clearing other players");
		end
	elseif option == "list" then
		if g.settings.clearlist == 0 then
			g.settings.clearlist = 1;
			CHAT_SYSTEM("Using exception list");
		else
			g.settings.clearlist = 0;
			CHAT_SYSTEM("Not using exception list");
		end
	elseif option == "neutral" then
		if g.settings.clearneutral == 0 then
			g.settings.clearneutral = 1;
			CHAT_SYSTEM("Not clearing Neutral Objects");
		else
			g.settings.clearneutral = 0;
			CHAT_SYSTEM("Clearing Neutral Objects");
		end
	elseif option == "pet" then
		if g.settings.clearpet == 0 then
			g.settings.clearpet = 1;
			CHAT_SYSTEM("Not clearing Pets");
		else
			g.settings.clearpet = 0;
			CHAT_SYSTEM("Clearing Pets");
		end
	elseif option == "my" then
		if g.settings.clearmy == 0 then
			g.settings.clearmy = 1;
			CHAT_SYSTEM("Not clearing my objects");
		else
			g.settings.clearmy = 0;
			CHAT_SYSTEM("Clearing my objects");
		end
	elseif option == "skill" then
		if g.settings.clearskill == 0 then
			g.settings.clearskill = 1;
			CHAT_SYSTEM("Not clearing skill objects");
		else
			g.settings.clearskill = 0;
			CHAT_SYSTEM("Clearing skill objects");
		end
	elseif option == "statue" then
		if g.settings.clearstatue == 0 then
			g.settings.clearstatue = 1;
			CHAT_SYSTEM("Not clearing Goddess statues");
		else
			g.settings.clearstatue = 0;
			CHAT_SYSTEM("Clearing Goddess statues");
		end
	elseif option == "none" then
		g.settings.clearparty = 1;
		g.settings.clearguild = 1;
		g.settings.clearPC = 1;
		g.settings.clearmy = 1;
		g.settings.clearpet = 1;
		g.settings.clearneutral = 1;
		g.settings.clearskill = 1;
		g.settings.clearstatue = 1;
		CHAT_SYSTEM("Clearing nothing");
	elseif option == "all" then
		g.settings.clearparty = 0;
		g.settings.clearguild = 0;
		g.settings.clearPC = 0;
		g.settings.clearmy = 0;
		g.settings.clearpet = 0;
		g.settings.clearneutral = 0;
		g.settings.clearskill = 0;
		g.settings.clearstatue = 0;
		CHAT_SYSTEM("Clearing everything");
	else
		CHAT_SYSTEM("Invalid Command.");
	end
	WARMODE_SAVESETTINGS();
	WARMODE_CLEARFRAME();
end

function WARMODE_CLEAR()
	if g.settings.clear then
		local list, cnt = SelectObject(GetMyPCObject(), 1000, "ALL");
		for i = 1, cnt do			
			local handle = GetHandle(list[i]);
			local owner = info.GetOwner(handle);
			if info.IsPC(handle) == 1 then
				local PCfamily = info.GetFamilyName(handle);
				if g.settings.clearlist == 1 then
					for k, playerName in pairs(g.playerList) do
						if PCfamily == playerName then
							goto continue;
						end
					end
				end

				local IsParty = session.party.GetPartyMemberInfoByName(PARTY_NORMAL, PCfamily) ~= nil;
				local IsGuild = session.party.GetPartyMemberInfoByName(PARTY_GUILD, PCfamily) ~= nil;
				local targetInfo = info.GetTargetInfo(handle);
				
				if targetInfo.IsDummyPC == 0 then
					if g.settings.clearparty == 0 and IsParty then
						world.Leave(handle, 0);
					elseif g.settings.clearguild == 0 and IsGuild and not IsParty then
						world.Leave(handle, 0);
					elseif g.settings.clearPC == 0 and not IsGuild and not IsParty then
						world.Leave(handle, 0);
					end
				end
				::continue::				
			elseif info.IsMonster(handle) == 1 then
				for k, npcClass in pairs(g.npcList) do
					if list[i].ClassName == npcClass then
						goto skip;
					end
				end

				local targetInfo = info.GetTargetInfo(handle);
				if g.settings.clearneutral == 0 and list[i].MonRank == 'Material' and owner == 0 then
					world.Leave(handle, 0);
				elseif g.settings.clearmy == 0 and owner == session.GetMyHandle() then
					world.Leave(handle, 0);
				elseif g.settings.clearpet == 0 and list[i].MonRank == 'Pet' and owner ~= session.GetMyHandle() then
					world.Leave(handle, 0);
				elseif g.settings.clearskill == 0 and (list[i].MonRank == 'Material' or targetInfo.isBoss == 1) and owner ~= 0 and owner ~= session.GetMyHandle() and info.IsMonster(owner) ~= 1 then
					world.Leave(handle, 0);
				elseif g.settings.clearstatue == 0 and list[i].ClassName == 'farm47_statue_zemina_small' then
					world.Leave(handle, 0);
				end
				::skip::
			end
		end
	end
end
-- Clear Frame
function WARMODE_SHOW_CLEARFRAME()
	local frame = ui.GetFrame('clearframe');
	if  frame ~= nil then 
		if frame:IsVisible() == 1  then
			frame:ShowWindow(0);
			g.settings.clearframe = false;
		else
			frame:ShowWindow(1);
			g.settings.clearframe = true;
		end
		WARMODE_SAVESETTINGS();
	else
		WARMODE_CLEARFRAME();
	end
end

function WARMODE_CLEARFRAME()
	local frame = ui.GetFrame('clearframe');
	if frame == nil then
		frame = ui.CreateNewFrame("warmodeparadise","clearframe");
		frame:SetSkinName("pip_simple_frame");
		frame:Resize(250,258);
		frame:SetLayerLevel(62);
		frame:SetOffset(g.settings.cleardisplayX, g.settings.cleardisplayY);
		frame.isDragging = false;
		frame:SetEventScript(ui.LBUTTONDOWN, "WARMODE_CLEAR_DRAG_START");
		frame:SetEventScript(ui.LBUTTONUP, "WARMODE_CLEAR_DRAG_END");
		frame:EnableMove(1);
		frame:EnableHitTest(1);
		if g.settings.clearframe then
			frame:ShowWindow(1);
		else
			frame:ShowWindow(0);
		end
	end
	
	-- Playable Characters boxes
	local text = frame:CreateOrGetControl("richtext","playertext", 5, 10, 0, 0);
	text:SetText("{ol}Visible Players:");	
	
	local box = frame:CreateOrGetControl('checkbox', 'partybox', 5, 32, 100, 20)
	box:SetText("{ol}Party members");
	box:SetEventScript(ui.LBUTTONUP,"WARMODE_CLEAR_EVENT");
	box:SetEventScriptArgString(ui.LBUTTONUP, "party");	
	local child = GET_CHILD(frame, "partybox");
	child:SetCheck(g.settings.clearparty);

	box = frame:CreateOrGetControl('checkbox', 'guildbox', 5, 54, 100, 20)
	box:SetText("{ol}Guild members");
	box:SetEventScript(ui.LBUTTONUP,"WARMODE_CLEAR_EVENT");
	box:SetEventScriptArgString(ui.LBUTTONUP, "guild");	
	child = GET_CHILD(frame, "guildbox");
	child:SetCheck(g.settings.clearguild);

	box = frame:CreateOrGetControl('checkbox', 'pcbox', 5, 76, 100, 20)
	box:SetText("{ol}Other players");
	box:SetEventScript(ui.LBUTTONUP,"WARMODE_CLEAR_EVENT");
	box:SetEventScriptArgString(ui.LBUTTONUP, "PC");	
	child = GET_CHILD(frame, "pcbox");
	child:SetCheck(g.settings.clearPC);

	box = frame:CreateOrGetControl('checkbox', 'listbox', 5, 98, 100, 20)
	box:SetText("{ol}Exception List");
	box:SetEventScript(ui.LBUTTONUP,"WARMODE_CLEAR_EVENT");
	box:SetEventScriptArgString(ui.LBUTTONUP, "list");	
	child = GET_CHILD(frame, "listbox");
	child:SetCheck(g.settings.clearlist);

	-- Non playable characters boxes
	text = frame:CreateOrGetControl("richtext","nonplayertext", 5, 122, 0, 0);
	text:SetText("{ol}Visible Non-player Objects:");	
	
	box = frame:CreateOrGetControl('checkbox', 'mybox', 5, 144, 100, 20)
	box:SetText("{ol}My Objects");
	box:SetEventScript(ui.LBUTTONUP,"WARMODE_CLEAR_EVENT");
	box:SetEventScriptArgString(ui.LBUTTONUP, "my");	
	child = GET_CHILD(frame, "mybox");
	child:SetCheck(g.settings.clearmy);

	box = frame:CreateOrGetControl('checkbox', 'neutralbox', 5, 166, 100, 20)
	box:SetText("{ol}Neutral Objects");
	box:SetEventScript(ui.LBUTTONUP,"WARMODE_CLEAR_EVENT");
	box:SetEventScriptArgString(ui.LBUTTONUP, "neutral");	
	child = GET_CHILD(frame, "neutralbox");
	child:SetCheck(g.settings.clearneutral);

	box = frame:CreateOrGetControl('checkbox', 'petbox', 5, 188, 100, 20)
	box:SetText("{ol}Pets");
	box:SetEventScript(ui.LBUTTONUP,"WARMODE_CLEAR_EVENT");
	box:SetEventScriptArgString(ui.LBUTTONUP, "pet");	
	child = GET_CHILD(frame, "petbox");
	child:SetCheck(g.settings.clearpet);

	box = frame:CreateOrGetControl('checkbox', 'skillbox', 5, 210, 100, 20)
	box:SetText("{ol}Skills and Summons");
	box:SetEventScript(ui.LBUTTONUP,"WARMODE_CLEAR_EVENT");
	box:SetEventScriptArgString(ui.LBUTTONUP, "skill");	
	child = GET_CHILD(frame, "skillbox");
	child:SetCheck(g.settings.clearskill);

	box = frame:CreateOrGetControl('checkbox', 'statuebox', 5, 232, 100, 20)
	box:SetText("{ol}Goddess Statues");
	box:SetEventScript(ui.LBUTTONUP,"WARMODE_CLEAR_EVENT");
	box:SetEventScriptArgString(ui.LBUTTONUP, "statue");	
	child = GET_CHILD(frame, "statuebox");
	child:SetCheck(g.settings.clearstatue);
end

function WARMODE_CLEAR_EVENT(frame, control, argStr, argNum)
	WARMODE_TOGGLE_CLEAR(argStr);
end

function WARMODE_CLEAR_DRAG_START()
	local frame = ui.GetFrame('clearframe');
	frame.isDragging = true;
end

function WARMODE_CLEAR_DRAG_END()
	local frame = ui.GetFrame('clearframe');
	g.settings.cleardisplayX = frame:GetX();
	g.settings.cleardisplayY = frame:GetY();
	WARMODE_SAVESETTINGS();
	frame.isDragging = false;
end

-- warmode window
function WARMODE_TOGGLE_CUSTOM(cmd)
	if cmd == "load" then
		if g.settings.load == 0 then
			g.settings.load = 1;
			CHAT_SYSTEM("Warmode loading on start");
		else
			g.settings.load = 0;
			CHAT_SYSTEM("Warmode not loading on start");
		end
	elseif cmd == "effects" then
		if g.settings.effects == 1 then
			WARMODE_ENABLE_EFFECTS(0);
			CHAT_SYSTEM("Effects Off");
		else
			WARMODE_ENABLE_EFFECTS(1);
			CHAT_SYSTEM("Effects On");
		end
	elseif	cmd == "minimal" then
		if g.settings.minimal == 1 then
			WARMODE_ENABLE_MINIMAL_EFFECTS(0);
			CHAT_SYSTEM("Minor Effects Off");
		else
			WARMODE_ENABLE_MINIMAL_EFFECTS(1);
			CHAT_SYSTEM("Minor Effects On");
		end
	elseif cmd == "graphics" then
		if g.settings.graphics == 1 then
			WARMODE_ENABLE_GRAPHICS(0);
			CHAT_SYSTEM("Graphic options Off");
		else
			WARMODE_ENABLE_GRAPHICS(1);
			CHAT_SYSTEM("Graphic options On");
		end
	elseif cmd == "debuff" then
		if g.settings.debuff == 1 then
			WARMODE_ENABLE_DEBUFF_WINDOW(0);
			CHAT_SYSTEM("Debuff window Off");
		else
			WARMODE_ENABLE_DEBUFF_WINDOW(1);
			CHAT_SYSTEM("Debuff window On");
		end
	elseif cmd == "players" then
		if g.settings.chars > 0 then
			WARMODE_ENABLE_CHARS(0);
			CHAT_SYSTEM("Drawing Players Off");
		else
			WARMODE_ENABLE_CHARS(30);
			CHAT_SYSTEM("Drawing Players On");
		end
	elseif cmd == "npc" then
		if g.settings.monsters > 0 then
			WARMODE_ENABLE_MONSTERS(0);
			CHAT_SYSTEM("Drawing Monster/NPC Off");
		else
			WARMODE_ENABLE_MONSTERS(30);
			CHAT_SYSTEM("Drawing Monster/NPC On");
		end
	else
		CHAT_SYSTEM("Invalid command");
		return;
	end
	WARMODE_SAVESETTINGS();
	WARMODE_CUSTOMFRAME();
end

function WARMODE_SHOW_CUSTOMFRAME()
	local frame = ui.GetFrame('customframe');
	if  frame ~= nil then 
		if frame:IsVisible() == 1  then
			frame:ShowWindow(0);
			g.settings.customframe = false;
		else
			frame:ShowWindow(1);
			g.settings.customframe = true;
		end
		WARMODE_SAVESETTINGS();
	else
		WARMODE_CUSTOMFRAME();
	end
end

function WARMODE_CUSTOMFRAME()
	local frame = ui.GetFrame('customframe');
	if frame == nil then
		frame = ui.CreateNewFrame("warmodeparadise","customframe");
		frame:SetSkinName("pip_simple_frame");
		frame:Resize(350,186);
		frame:SetLayerLevel(62);
		frame:SetOffset(g.settings.customdisplayX, g.settings.customdisplayY);
		frame.isDragging = false;
		frame:SetEventScript(ui.LBUTTONDOWN, "WARMODE_CUSTOM_DRAG_START");
		frame:SetEventScript(ui.LBUTTONUP, "WARMODE_CUSTOM_DRAG_END");
		frame:EnableMove(1);
		frame:EnableHitTest(1);
		if g.settings.customframe then
			frame:ShowWindow(1);
		else
			frame:ShowWindow(0);
		end
	end
	
	-- Custom options
	local text = frame:CreateOrGetControl("richtext","customtext", 5, 10, 0, 0);
	text:SetText("{ol}Custom Options:");	
	-- Effects
	local box = frame:CreateOrGetControl('checkbox', 'effectsbox', 5, 32, 100, 20)
	box:SetText("{ol}Effects");
	box:SetEventScript(ui.LBUTTONUP, "WARMODE_CUSTOM_EVENT");
	box:SetEventScriptArgString(ui.LBUTTONUP, "effects");	
	local child = GET_CHILD(frame, "effectsbox");
	child:SetCheck(g.settings.effects);
	-- Minor Effects
	box = frame:CreateOrGetControl('checkbox', 'minorbox', 5, 54, 100, 20)
	box:SetText("{ol}Minor effects");
	box:SetEventScript(ui.LBUTTONUP,"WARMODE_CUSTOM_EVENT");
	box:SetEventScriptArgString(ui.LBUTTONUP, "minimal");	
	child = GET_CHILD(frame, "minorbox");
	child:SetCheck(g.settings.minimal);
	-- Graphics
	box = frame:CreateOrGetControl('checkbox', 'graphicsbox', 5, 76, 100, 20)
	box:SetText("{ol}Graphics");
	box:SetEventScript(ui.LBUTTONUP,"WARMODE_CUSTOM_EVENT");
	box:SetEventScriptArgString(ui.LBUTTONUP, "graphics");	
	child = GET_CHILD(frame, "graphicsbox");
	child:SetCheck(g.settings.graphics);	
	-- Debuff window
	box = frame:CreateOrGetControl('checkbox', 'debuffbox', 5, 98, 100, 20)
	box:SetText("{ol}Debuff Window");
	box:SetEventScript(ui.LBUTTONUP,"WARMODE_CUSTOM_EVENT");
	box:SetEventScriptArgString(ui.LBUTTONUP, "debuff");	
	child = GET_CHILD(frame, "debuffbox");
	child:SetCheck(g.settings.debuff);
	-- Draw Players
	box = frame:CreateOrGetControl('checkbox', 'playersbox', 5, 120, 100, 20)
	box:SetText("{ol}Draw Players");
	box:SetEventScript(ui.LBUTTONUP,"WARMODE_CUSTOM_EVENT");
	box:SetEventScriptArgString(ui.LBUTTONUP, "players");	
	child = GET_CHILD(frame, "playersbox");
	if g.settings.chars > 0 then
		child:SetCheck(1);
	else
		child:SetCheck(0);
	end
	-- Draw NPCs
	box = frame:CreateOrGetControl('checkbox', 'npcsbox', 5, 142, 100, 20)
	box:SetText("{ol}Draw NPCs");
	box:SetEventScript(ui.LBUTTONUP,"WARMODE_CUSTOM_EVENT");
	box:SetEventScriptArgString(ui.LBUTTONUP, "npc");	
	child = GET_CHILD(frame, "npcsbox");
	if g.settings.monsters > 0 then
		child:SetCheck(1);
	else
		child:SetCheck(0);
	end
	-- Load
	box = frame:CreateOrGetControl('checkbox', 'loadbox', 5, 164, 100, 20)
	box:SetText("{ol}Load on start");
	box:SetEventScript(ui.LBUTTONUP,"WARMODE_CUSTOM_EVENT");
	box:SetEventScriptArgString(ui.LBUTTONUP, "load");	
	child = GET_CHILD(frame, "loadbox");
	child:SetCheck(g.settings.load);

	-- High mode
	local button = frame:CreateOrGetControl('button', 'high', 0, 0, 120, 20); 
	button:SetOffset(200, 10); 
	button:SetText("{ol}HIGH");
	button:SetEventScript(ui.LBUTTONDOWN, 'HIGH_MODE');
	-- Medium
	button = frame:CreateOrGetControl('button', 'medium', 0, 0, 120, 20); 
	button:SetOffset(200, 32); 
	button:SetText("{ol}MEDIUM");
	button:SetEventScript(ui.LBUTTONDOWN, 'MEDIUM_MODE');
	-- Low
	button = frame:CreateOrGetControl('button', 'low', 0, 0, 120, 20); 
	button:SetOffset(200, 54); 
	button:SetText("{ol}LOW");
	button:SetEventScript(ui.LBUTTONDOWN, 'LOW_MODE');
	-- Ultra Low
	button = frame:CreateOrGetControl('button', 'ulow', 0, 0, 120, 20); 
	button:SetOffset(200, 76); 
	button:SetText("{ol}ULTRA LOW");
	button:SetEventScript(ui.LBUTTONDOWN, 'ULOW_MODE');
	-- DESPAIR
	button = frame:CreateOrGetControl('button', 'despair', 0, 0, 120, 20); 
	button:SetOffset(200, 98); 
	button:SetText("{ol}DESPAIR");
	button:SetEventScript(ui.LBUTTONDOWN, 'DESPAIR_MODE');
end

function WARMODE_CUSTOM_EVENT(frame, control, argStr, argNum)
	WARMODE_TOGGLE_CUSTOM(argStr);
end

function WARMODE_CUSTOM_DRAG_START()
	local frame = ui.GetFrame('customframe');
	frame.isDragging = true;
end

function WARMODE_CUSTOM_DRAG_END()
	local frame = ui.GetFrame('customframe');
	g.settings.customdisplayX = frame:GetX();
	g.settings.customdisplayY = frame:GetY();
	WARMODE_SAVESETTINGS();
	frame.isDragging = false;
end

---- exception list

function WARMODE_LOADLIST()
	local list, error = acutil.loadJSON("../addons/warmodeparadise/playerlist.json");
	if error then
		WARMODE_SAVELIST();
		return
	end
	g.playerList = list;
end

function WARMODE_SAVELIST()
	if g.playerList == nil then
		g.playerList = {};
	end
	acutil.saveJSON("../addons/warmodeparadise/playerlist.json", g.playerList);
end

function WARMODE_LOAD_NPCLIST()
	local list, error = acutil.loadJSON("../addons/warmodeparadise/npclist.json");
	if error then
		WARMODE_SAVE_NPCLIST();
		return
	end
	g.npcList = list;
end

function WARMODE_SAVE_NPCLIST()
	if g.npcList == nil then
		g.npcList = {};
	end
	acutil.saveJSON("../addons/warmodeparadise/npclist.json", g.npcList);
end

function WARMODE_PLAYERLIST_CMD(command)
    local cmd = "";
	if #command > 0 then
        cmd = table.remove(command, 1);
	else
		CHAT_SYSTEM("'/playerlist PlayerName' to remove or add a player to the exception list");
		WARMODE_PLAYERLIST_SHOW();
        return;
	end
	    
	local playerName = cmd;
	
	for k, v in pairs(g.playerList) do
		if v == playerName then
			table.remove(g.playerList, k);
			CHAT_SYSTEM("Removing "..playerName.." from the list");
			WARMODE_SAVELIST();
			return;
		end
	end
	table.insert(g.playerList, playerName);
	CHAT_SYSTEM("Adding "..playerName.." to the list");
	WARMODE_SAVELIST();
end

function WARMODE_PLAYERLIST_SHOW()
    CHAT_SYSTEM("Not clearing following players: ");
    for k, playerName in pairs(g.playerList) do
        CHAT_SYSTEM(playerName);
    end
    CHAT_SYSTEM("--- LIST END");
end