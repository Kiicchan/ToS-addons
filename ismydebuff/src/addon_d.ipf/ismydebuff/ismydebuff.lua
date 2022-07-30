local version = "0.0.2"

function TARGETBUFF_DEBUFF_LIMIT(frame, handle, buffType)
	if handle == nil then
		return false;
	end

	if buffType == nil or buffType == 0 then
		return false;
	end

	local option = config.GetShowTargetDeBuffMinimize();
	local isLimitDebuff = tonumber(frame:GetUserValue("IS_LIMIT_DEBUFF"));
	if isLimitDebuff == 1 and option == 1 then
		local buffCls = GetClassByType('Buff', buffType);
		if buffCls ~= nil and buffCls.Group1 == "Debuff" then
			return true;
		end
	end

	local buff = info.GetBuff(handle, buffType);
	if buff ~= nil then
		local casterHandle = buff:GetHandle();
		local myHandle = session.GetMyHandle();
		if casterHandle ~= nil and casterHandle ~= handle and casterHandle ~= myHandle and casterHandle ~= '0' then
			return true;
		end
	end
	
	return false;
end

function TARGETBUFF_ON_MSG(frame, msg, argStr, argNum)
	local handle = session.GetTargetHandle();
	if msg == "TARGET_BUFF_ADD" then
		if TARGETBUFF_DEBUFF_LIMIT(frame, handle, argNum) == false then 
		COMMON_BUFF_MSG(frame, "ADD", argNum, handle, t_buff_ui, argStr);
		end
	elseif msg == "TARGET_BUFF_REMOVE" then
		COMMON_BUFF_MSG(frame, "REMOVE", argNum, handle, t_buff_ui, argStr);
	elseif msg == "TARGET_BUFF_UPDATE" then
		COMMON_BUFF_MSG(frame, "UPDATE", argNum, handle, t_buff_ui, argStr);
	elseif msg == "TARGET_SET" then
		if s_lsgmsg == msg and s_lasthandle == handle then
			return;
		end
		s_lsgmsg = msg;
		s_lasthandle = handle;
		COMMON_BUFF_MSG(frame, "CLEAR", argNum, handle, t_buff_ui);		
		local isLimitDebuff = tonumber(frame:GetUserValue("IS_LIMIT_DEBUFF"));
		if isLimitDebuff == 1 then
			ui.TargetBuffAddonMsg("SET", handle);
		else
			local buffCount = info.GetBuffCount(handle);
			for i = 0, buffCount - 1 do
				local buff = info.GetBuffIndexed(handle, i);
				if buff ~= nil and TARGETBUFF_DEBUFF_LIMIT(frame, handle, buff.buffID) == false then
					COMMON_BUFF_MSG(frame, "ADD", buff.buffID, handle, t_buff_ui, buff.index);
				end
			end
			TARGETBUFF_VISIBLE(frame, 1);
		end
	elseif msg == "TARGET_CLEAR" then
		if s_lsgmsg == msg then 
			return;
		end
		s_lsgmsg = msg;
		COMMON_BUFF_MSG(frame, "CLEAR", argNum, handle, t_buff_ui);
		TARGETBUFF_VISIBLE(frame, 0);		
	end
	
	TARGET_BUFF_UPDATE(frame);
	TARGETBUFF_RESIZE(frame, t_buff_ui);
end