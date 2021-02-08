local acutil = require('acutil');
local version = '2.0.1'

local myName = GETMYFAMILYNAME();
local killcount = 0;
local deathcount = 0;
local save = 1;

local selfFile = io.open("../addons/killcounter/self.txt", "r");
if selfFile ~= nil then
	local fileString = selfFile:read("*all");
	fileString, killcount = fileString:gsub(" kill ", "");
	fileString, deathcount = fileString:gsub(" death ", "");
	selfFile:close();	
end

CHAT_SYSTEM("KillCounter by Kiicchan");

function KILLCOUNTER_ON_INIT(addon, frame)
	addon:RegisterMsg('COLONYWAR_GUILD_KILL_MSG', 'KILLCOUNTER_ON_NOTICE');
	acutil.slashCommand("/killcounter",KILLCOUNTER_CMD);

	KILLCOUNTER_LOADSETTINGS();
end

function KILLCOUNTER_ON_NOTICE(frame, msg, argstr, argnum)
	local splitedString = StringSplit(argstr, "#");
	KILLCOUNTER_SELF(splitedString);
end

function KILLCOUNTER_SAVESETTINGS()
	local settings = {
		save = save;
	};
	acutil.saveJSON("../addons/killcounter/settings.json", settings);
end

function KILLCOUNTER_LOADSETTINGS()
	local settings, error = acutil.loadJSON("../addons/killcounter/settings.json");
	if error then
		KILLCOUNTER_SAVESETTINGS();
	else
		save = settings.save;
	end
	config.SetShowGuildInColonyBattleMessage(1)
end

function KILLCOUNTER_CMD(command)
	local cmd = "";
	if #command > 0 then
        cmd = table.remove(command, 1);
	else
		CHAT_SYSTEM(myName .. " defeated [" .. killcount .. "] enemies");
		CHAT_SYSTEM(myName .. " has been defeated [" .. deathcount .. "] times");
        return;
	end
	
	if cmd == "help" then
		CHAT_SYSTEM("KillCounter commands:{nl}'/killcounter save' {nl}'/killcounter reset'");
	elseif cmd == "save" then
		if save == 0 then
			save = 1;
			CHAT_SYSTEM("Auto saving kill log on hard disc");
		else
			save = 0;
			CHAT_SYSTEM("Not saving kill log on hard disc");
		end
	elseif cmd == "reset" then 
		killcount = 0;
		deathcount = 0;
		KILLCOUNTER_RESET("../addons/killcounter/self.txt");
		CHAT_SYSTEM("Kill count reseted!");
	else 
		CHAT_SYSTEM("Invalid command.");
		return;
	end

	KILLCOUNTER_SAVESETTINGS();
	return;
end

function KILLCOUNTER_SELF(splitedString)
	local killerName = splitedString[3];
	local selfName = splitedString[4];
	local targetGuildName = splitedString[5];
	
	if killerName == selfName then
		return;
	elseif killerName == myName then
		killcount = killcount + 1;
		CHAT_SYSTEM("You defeated " .. selfName .. " from " .. targetGuildName .. " [" .. killcount .. "]");
		
		if save == 1 then
			local sysTime = geTime.GetServerSystemTime();
			local timeString = string.format("%02d:%02d:%02d", sysTime.wHour, sysTime.wMinute, sysTime.wSecond);
			local file = io.open("../addons/killcounter/self.txt", "a");
			file:write(killerName, " ", selfName, " ", targetGuildName, " kill ", timeString, " \n");
			file:close();
		end
	elseif 	selfName == myName then
		deathcount = deathcount + 1;
		CHAT_SYSTEM("You've been defeated by " .. killerName .. " from " .. targetGuildName .. " [" .. deathcount .. "]");
		
		if save == 1 then
			local sysTime = geTime.GetServerSystemTime();
			local timeString = string.format("%02d:%02d:%02d", sysTime.wHour, sysTime.wMinute, sysTime.wSecond);
			local file = io.open("../addons/killcounter/self.txt", "a");
			file:write(selfName, " ", killerName, " ", targetGuildName, " death ", timeString, " \n");
			file:close();
		end
	end
end

function KILLCOUNTER_RESET(filepath)
	local file = io.open(filepath, "w");
	file:write("");
	file:close();
end