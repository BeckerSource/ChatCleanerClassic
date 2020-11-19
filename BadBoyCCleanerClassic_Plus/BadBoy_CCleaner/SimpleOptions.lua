
do
	BadBoyCCleanerConfigTitle:SetText("BadBoy_CCleaner v9.1.0") --packager magic, replaced with tag version

	------------------
	-- Filter Friendly
	------------------
	local btnFilterFriendly = CreateFrame("CheckButton", nil, BadBoyConfig, "OptionsBaseCheckButtonTemplate")
	btnFilterFriendly:SetPoint("TOPLEFT", BadBoyCCleanerConfigTitle, "BOTTOMLEFT", 0, -5)
	btnFilterFriendly:SetScript("OnClick", function(frame)
		BADBOY_CCLEANER_FILTER_FRIENDLY = frame:GetChecked()
	end)
	btnFilterFriendly:SetScript("OnShow", function(frame)
		frame:SetChecked(BADBOY_CCLEANER_FILTER_FRIENDLY)
	end)
	btnFilterFriendly:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		GameTooltip:AddLine("Filter out chat from friends, guildies, etc.", 0.5, 0.5, 0)
		GameTooltip:Show()
	end)
	local txtFilterFriendly = BadBoyConfig:CreateFontString(nil, nil, "GameFontHighlight")
	txtFilterFriendly:SetPoint("LEFT", btnFilterFriendly, "RIGHT", 0, 1)
	txtFilterFriendly:SetText("Filter Friendly")

	------------------
	-- Whole Words
	------------------
	local btnWholeWords = CreateFrame("CheckButton", nil, btnFilterFriendly, "OptionsBaseCheckButtonTemplate")
	btnWholeWords:SetPoint("TOPLEFT", txtFilterFriendly, "TOPRIGHT", 10, 5)
	btnWholeWords:SetScript("OnClick", function(frame)
		BADBOY_CCLEANER_WHOLE_WORDS = frame:GetChecked()
	end)
	btnWholeWords:SetScript("OnShow", function(frame)
		frame:SetChecked(BADBOY_CCLEANER_WHOLE_WORDS)
	end)
	btnWholeWords:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		GameTooltip:AddLine("Filtering keywords are matched as whole words instead of partial.", 0.5, 0.5, 0)
		GameTooltip:Show()
	end)
	local txtWholeWords = BadBoyConfig:CreateFontString(nil, nil, "GameFontHighlight")
	txtWholeWords:SetPoint("LEFT", btnWholeWords, "RIGHT", 0, 1)
	txtWholeWords:SetText("Whole Words")

	------------------
	-- Channels
	------------------
	local ccleanerInputChannels = CreateFrame("EditBox", nil, btnFilterFriendly, "InputBoxTemplate")
	ccleanerInputChannels:SetPoint("TOPLEFT", btnFilterFriendly, "BOTTOMLEFT", 125, -2)
	ccleanerInputChannels:SetAutoFocus(false)
	ccleanerInputChannels:EnableMouse(true)
	ccleanerInputChannels:SetWidth(310)
	ccleanerInputChannels:SetHeight(20)
	ccleanerInputChannels:SetMaxLetters(99999)
	ccleanerInputChannels:SetScript("OnEscapePressed", function(frame)
		frame:ClearFocus()
	end)
	ccleanerInputChannels:SetScript("OnShow",         function(frame) frame:SetText(GetChannels()) end)
	ccleanerInputChannels:SetScript("OnEnterPressed", function(frame) SetChannels(frame:GetText()) frame:ClearFocus() end)
	ccleanerInputChannels:Show()
	------------------
	ccleanerInputChannels:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		GameTooltip:AddLine("Only affect chat on these channel names (separated by semi-colons).\nLeave empty for all (defaults).\nExample: LookingForGroup;LFG", 0.5, 0.5, 0)
		GameTooltip:Show()
	end)
	ccleanerInputChannels:SetScript("OnLeave", GameTooltip_Hide)
	------------------
	local ccleanerChannelsText = BadBoyConfig:CreateFontString("FontString", "OVERLAY", "GameFontHighlight")
	ccleanerChannelsText:SetPoint("TOPLEFT", btnFilterFriendly, "BOTTOMLEFT", 0, -5)
	ccleanerChannelsText:SetText("Affected Channels:")

	------------------
	-- Required Keywords
	------------------
	local ccleanerInputRequired = CreateFrame("EditBox", nil, BadBoyConfig, "InputBoxTemplate")
	ccleanerInputRequired:SetPoint("TOPLEFT", ccleanerInputChannels, "BOTTOMLEFT", 0, -5)
	ccleanerInputRequired:SetAutoFocus(false)
	ccleanerInputRequired:EnableMouse(true)
	ccleanerInputRequired:SetWidth(150)
	ccleanerInputRequired:SetHeight(20)
	ccleanerInputRequired:SetMaxLetters(100)
	ccleanerInputRequired:SetScript("OnEscapePressed", function(frame)
		frame:SetText("")
		frame:ClearFocus()
	end)
	ccleanerInputRequired:SetScript("OnTextChanged", function(frame, changed)
		if changed then
			local msg = (frame:GetText()):lower()
			frame:SetText(msg)
		end
	end)
	ccleanerInputRequired:Show()
	------------------
	local ccleanerButtonRequired = CreateFrame("Button", nil, ccleanerInputRequired, "UIPanelButtonTemplate")
	ccleanerButtonRequired:SetWidth(90)
	ccleanerButtonRequired:SetHeight(20)
	ccleanerButtonRequired:SetPoint("LEFT", ccleanerInputRequired, "RIGHT")
	ccleanerButtonRequired:SetText(ADD.."/"..REMOVE)
	local ccleanerButtonRequiredClear = CreateFrame("Button", nil, ccleanerButtonRequired, "UIPanelButtonTemplate")
	ccleanerButtonRequiredClear:SetWidth(70)
	ccleanerButtonRequiredClear:SetHeight(20)
	ccleanerButtonRequiredClear:SetPoint("LEFT", ccleanerButtonRequired, "RIGHT")
	ccleanerButtonRequiredClear:SetText("Clear All")
	------------------
	ccleanerInputRequired:SetScript("OnEnterPressed", function() ccleanerButtonRequired:Click() end)
	ccleanerInputRequired:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		GameTooltip:AddLine("Chats must have at least one of these keywords to be shown.\nLeave empty to bypass.", 0.5, 0.5, 0)
		GameTooltip:Show()
	end)
	ccleanerInputRequired:SetScript("OnLeave", GameTooltip_Hide)
	------------------
	local ccleanerRequiredText = BadBoyConfig:CreateFontString("FontString", "OVERLAY", "GameFontHighlight")
	ccleanerRequiredText:SetPoint("TOPLEFT", ccleanerChannelsText, "BOTTOMLEFT", 0, -10)
	ccleanerRequiredText:SetText("Required keywords:")
	ccleanerInputRequired:SetPoint("TOPLEFT", ccleanerRequiredText, "TOPRIGHT", 10, 3)

	------------------
	-- Required Table
	------------------
	local ccleanerScrollAreaRequired = CreateFrame("ScrollFrame", nil, BadBoyConfig, "UIPanelScrollFrameTemplate")
	ccleanerScrollAreaRequired:SetPoint("TOPLEFT", ccleanerRequiredText, "BOTTOMLEFT", 0, -7)
	ccleanerScrollAreaRequired:SetWidth(BadBoyConfig:GetWidth() - 45)
	ccleanerScrollAreaRequired:SetHeight(100)

	local ccleanerEditBoxRequired = CreateFrame("EditBox", nil, BadBoyConfig)
	ccleanerEditBoxRequired:SetMultiLine(true)
	ccleanerEditBoxRequired:SetMaxLetters(99999)
	ccleanerEditBoxRequired:EnableMouse(false)
	ccleanerEditBoxRequired:SetAutoFocus(false)
	ccleanerEditBoxRequired:SetFontObject(ChatFontNormal)
	ccleanerEditBoxRequired:SetWidth(350)
	ccleanerEditBoxRequired:SetHeight(100)
	ccleanerEditBoxRequired:Show()
	ccleanerEditBoxRequired:SetScript("OnShow", function(frame)
		if type(BADBOY_CCLEANER_REQUIRED) == "table" then
			table.sort(BADBOY_CCLEANER_REQUIRED)
			local text
			for i=1, #BADBOY_CCLEANER_REQUIRED do
				if not text then
					text = BADBOY_CCLEANER_REQUIRED[i]
				else
					text = text.."\n"..BADBOY_CCLEANER_REQUIRED[i]
				end
			end
			frame:SetText(text or "")
		end
	end)

	ccleanerScrollAreaRequired:SetScrollChild(ccleanerEditBoxRequired)

	local ccleanerBackdropRequired = CreateFrame("Frame", nil, BadBoyConfig)
	ccleanerBackdropRequired:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = {left = 3, right = 3, top = 5, bottom = 3}}
	)
	ccleanerBackdropRequired:SetBackdropColor(0,0,0,1)
	ccleanerBackdropRequired:SetPoint("TOPLEFT", ccleanerRequiredText, "BOTTOMLEFT", -5, -2)
	ccleanerBackdropRequired:SetWidth(ccleanerScrollAreaRequired:GetWidth() + 10)
	ccleanerBackdropRequired:SetHeight(ccleanerScrollAreaRequired:GetHeight() + 10)

	------------------
	-- Clean Keywords
	------------------
	local ccleanerInputClean = CreateFrame("EditBox", nil, BadBoyConfig, "InputBoxTemplate")
	ccleanerInputClean:SetPoint("TOPLEFT", ccleanerEditBoxRequired, "BOTTOMLEFT", 0, -5)
	ccleanerInputClean:SetAutoFocus(false)
	ccleanerInputClean:EnableMouse(true)
	ccleanerInputClean:SetWidth(150)
	ccleanerInputClean:SetHeight(20)
	ccleanerInputClean:SetMaxLetters(100)
	ccleanerInputClean:SetScript("OnEscapePressed", function(frame)
		frame:SetText("")
		frame:ClearFocus()
	end)
	ccleanerInputClean:SetScript("OnTextChanged", function(frame, changed)
		if changed then
			local msg = (frame:GetText()):lower()
			frame:SetText(msg)
		end
	end)
	ccleanerInputClean:Show()

	local ccleanerButtonClean = CreateFrame("Button", nil, ccleanerInputClean, "UIPanelButtonTemplate")
	ccleanerButtonClean:SetWidth(90)
	ccleanerButtonClean:SetHeight(20)
	ccleanerButtonClean:SetPoint("LEFT", ccleanerInputClean, "RIGHT")
	ccleanerButtonClean:SetText(ADD.."/"..REMOVE)
	local ccleanerButtonCleanClear = CreateFrame("Button", nil, ccleanerButtonClean, "UIPanelButtonTemplate")
	ccleanerButtonCleanClear:SetWidth(70)
	ccleanerButtonCleanClear:SetHeight(20)
	ccleanerButtonCleanClear:SetPoint("LEFT", ccleanerButtonClean, "RIGHT")
	ccleanerButtonCleanClear:SetText("Clear All")
	------------------
	ccleanerInputClean:SetScript("OnEnterPressed", function() ccleanerButtonClean:Click() end)
	ccleanerInputClean:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		GameTooltip:AddLine("Chats found with any of these keywords will be removed (even if a required keyword is found).\n", 0.5, 0.5, 0)
		GameTooltip:Show()
	end)
	ccleanerInputClean:SetScript("OnLeave", GameTooltip_Hide)
	------------------
	local ccleanerCleanText = BadBoyConfig:CreateFontString("FontString", "OVERLAY", "GameFontHighlight")
	ccleanerCleanText:SetPoint("TOPLEFT", ccleanerBackdropRequired, "BOTTOMLEFT", 5, -10)
	ccleanerCleanText:SetText("Clean keywords:")
	ccleanerInputClean:SetPoint("TOPLEFT", ccleanerCleanText, "TOPRIGHT", 30, 3)

	------------------
	-- Clean Table
	------------------
	local ccleanerScrollAreaClean = CreateFrame("ScrollFrame", nil, BadBoyConfig, "UIPanelScrollFrameTemplate")
	ccleanerScrollAreaClean:SetPoint("TOPLEFT", ccleanerCleanText, "BOTTOMLEFT", 0, -7)
	ccleanerScrollAreaClean:SetWidth(BadBoyConfig:GetWidth() - 45)
	ccleanerScrollAreaClean:SetHeight(100)

	local ccleanerEditBoxClean = CreateFrame("EditBox", nil, BadBoyConfig)
	ccleanerEditBoxClean:SetMultiLine(true)
	ccleanerEditBoxClean:SetMaxLetters(99999)
	ccleanerEditBoxClean:EnableMouse(false)
	ccleanerEditBoxClean:SetAutoFocus(false)
	ccleanerEditBoxClean:SetFontObject(ChatFontNormal)
	ccleanerEditBoxClean:SetWidth(350)
	ccleanerEditBoxClean:SetHeight(100)
	ccleanerEditBoxClean:Show()
	ccleanerEditBoxClean:SetScript("OnShow", function(frame)
		if type(BADBOY_CCLEANER_CLEAN) == "table" then
			table.sort(BADBOY_CCLEANER_CLEAN)
			local text
			for i=1, #BADBOY_CCLEANER_CLEAN do
				if not text then
					text = BADBOY_CCLEANER_CLEAN[i]
				else
					text = text.."\n"..BADBOY_CCLEANER_CLEAN[i]
				end
			end
			frame:SetText(text or "")
		end
	end)

	ccleanerScrollAreaClean:SetScrollChild(ccleanerEditBoxClean)

	local ccleanerBackdropClean = CreateFrame("Frame", nil, BadBoyConfig)
	ccleanerBackdropClean:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = {left = 3, right = 3, top = 5, bottom = 3}}
	)
	ccleanerBackdropClean:SetBackdropColor(0,0,0,1)
	ccleanerBackdropClean:SetPoint("TOPLEFT", ccleanerCleanText, "BOTTOMLEFT", -5, -2)
	ccleanerBackdropClean:SetWidth(ccleanerScrollAreaClean:GetWidth() + 10)
	ccleanerBackdropClean:SetHeight(ccleanerScrollAreaClean:GetHeight() + 10)

	------------------
	-- OnClick Handler
	------------------
	function UpdateKeywords(input, editbox, tbl)
		-- format new text...
		local t = input:GetText()
		if t == "" or t:find("^ *$") then input:SetText("") return end
		t = t:lower()

		-- find if exists...
		local found
		for i=1, #tbl do
			if tbl[i] == t then found = i end
		end

		-- if found...
		if found then
			tremove(tbl, found)
		else
			tinsert(tbl, t)
		end

		-- resort...
		table.sort(tbl)
		local text
		for i=1, #tbl do
			if not text then
				text = tbl[i]
			else
				text = text.."\n"..tbl[i]
			end
		end

		input:SetText("")
		editbox:SetText(text or "")
	end

	function GetChannels()
		local icList = ""
		local iNext = 0
		if BADBOY_CCLEANER_CHANNELS ~= nil then
			for i = 1, #BADBOY_CCLEANER_CHANNELS do
				if BADBOY_CCLEANER_CHANNELS[i] ~= nil then
					icList = icList .. BADBOY_CCLEANER_CHANNELS[i]
				end
				iNext = i + 1
				if iNext <= #BADBOY_CCLEANER_CHANNELS and BADBOY_CCLEANER_CHANNELS[iNext] ~= nil then
					icList = icList .. ";"
				end
			end
		end
		return icList
	end

	function SetChannels(icList)
		BADBOY_CCLEANER_CHANNELS = {}
		for chname in string.gmatch(icList, "[^;]+") do
			if chname ~= nil and string.len(chname) then table.insert(BADBOY_CCLEANER_CHANNELS, chname) end
		end		
	end

	-- add/remove clicks
	ccleanerButtonRequired:SetScript("OnClick", function() 
		UpdateKeywords(ccleanerInputRequired, ccleanerEditBoxRequired, BADBOY_CCLEANER_REQUIRED) 
	end)
	ccleanerButtonClean:SetScript("OnClick", function()
		UpdateKeywords(ccleanerInputClean, ccleanerEditBoxClean, BADBOY_CCLEANER_CLEAN)
	end)
	-- clear all clicks
	ccleanerButtonRequiredClear:SetScript("OnClick", function()
		ccleanerEditBoxRequired:SetText("")
		for k in pairs(BADBOY_CCLEANER_REQUIRED) do BADBOY_CCLEANER_REQUIRED[k] = nil end		
	end)
	ccleanerButtonCleanClear:SetScript("OnClick", function()
		ccleanerEditBoxClean:SetText("")
		for k in pairs(BADBOY_CCLEANER_CLEAN) do BADBOY_CCLEANER_CLEAN[k] = nil end		
	end)	
end
