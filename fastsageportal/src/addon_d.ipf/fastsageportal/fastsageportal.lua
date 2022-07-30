function SAGE_PORTAL_SELL_INFO_OK_BTN(ctrlSet, btn)
    local frame = ctrlSet:GetTopParentFrame();
    local handle = frame:GetUserIValue('HANDLE');
    local sellType = frame:GetUserIValue('SELL_TYPE');
    local index = ctrlSet:GetUserIValue('SELL_ITEM_INDEX');
    
    ACCEPT_PORTAL_OK_BTN(handle, index, sellType)
end