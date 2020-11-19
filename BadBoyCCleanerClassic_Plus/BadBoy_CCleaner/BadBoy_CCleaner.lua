function Search(msg, str)
	return 
		(BADBOY_CCLEANER_WHOLE_WORDS == true  and string.find(msg, "%f[%w_]" .. str .. "%f[^%w_]")) or
		(BADBOY_CCLEANER_WHOLE_WORDS == false and msg:find(str, nil, true))
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(frame, _, addon)
	if addon ~= "BadBoy_CCleaner" then return end
	if BADBOY_CCLEANER_FILTER_FRIENDLY == nil then BADBOY_CCLEANER_FILTER_FRIENDLY = false end
	if BADBOY_CCLEANER_WHOLE_WORDS == nil then BADBOY_CCLEANER_WHOLE_WORDS = true end
	if type(BADBOY_CCLEANER_REQUIRED) ~= "table" then BADBOY_CCLEANER_REQUIRED = {} end
	if type(BADBOY_CCLEANER_CHANNELS) ~= "table" then BADBOY_CCLEANER_CHANNELS = {} end
	if type(BADBOY_CCLEANER_CLEAN) ~= "table" then
		BADBOY_CCLEANER_CLEAN = {
			"anal",
			"rape",
		}
	end

	local Ambiguate, prevLineId, result, BADBOY_CCLEANER_CLEAN = Ambiguate, 0, nil, BADBOY_CCLEANER_CLEAN
	local BadBoyIsFriendly = BadBoyIsFriendly

	--main filtering function
	local filter = function(_,event,msg,player,_,_,_,flag,chid,chnum,chname,_,lineId,guid)
		if lineId == prevLineId then
			return result
		else
			-- print ("chname=" .. (chname or "nil") .. " >>>> chatMsg chnum=" .. (chnum or "nil"))
			-- print ("#BADBOY_CCLEANER_CHANNELS=" .. #BADBOY_CCLEANER_CHANNELS)
			-- print ("msg1=" .. msg)
			-- print ("event=" .. event .. " >>>> chid=" .. chid .. " >>>> chname=" .. chname)

			prevLineId, result = lineId, nil
			local trimmedPlayer = Ambiguate(player, "none")

			-- only scan official custom channels (gen/trade)
			if event == "CHAT_MSG_CHANNEL" and ((#BADBOY_CCLEANER_CHANNELS == 0 and chid == 0) or type(chid) ~= "number") then return end
			-- always show messages from actual player
			if trimmedPlayer == UnitName("player") then return end
			-- check if we're filtering friendlies
			if BadBoyIsFriendly(trimmedPlayer, flag, lineId, guid) and BADBOY_CCLEANER_FILTER_FRIENDLY == false then return end

			-- check for required channels (if any)...
			local lowMsg = msg:lower() --lower all text
			local channel_match = false
			for i=1, #BADBOY_CCLEANER_CHANNELS do
				-- print ("BADBOY_CCLEANER_CHANNELS[i]=" .. BADBOY_CCLEANER_CHANNELS[i] .. " >>>> chname=" .. (chname or "nil"))
				if  chname and chname ~= '' and 
					string.lower(BADBOY_CCLEANER_CHANNELS[i]) == string.lower(chname) then
					channel_match = true
					break
				end
			end

			if channel_match == true or #BADBOY_CCLEANER_CHANNELS == 0 then
				-- scan for required matches (filter if not found)...
				local req_match = false
				for i=1, #BADBOY_CCLEANER_REQUIRED do 
					-- print ("lowMsg_req=" .. lowMsg .. " >>>> BADBOY_CCLEANER_REQUIRED[i]=" .. BADBOY_CCLEANER_REQUIRED[i])
					if Search(lowMsg, BADBOY_CCLEANER_REQUIRED[i]) then
						req_match = true
						break
					end
				end

				-- scan for clean matches (filter if found)...
				if  req_match == true or #BADBOY_CCLEANER_REQUIRED == 0 then
					for i=1, #BADBOY_CCLEANER_CLEAN do 
						-- print ("lowMsg2_clean=" .. lowMsg .. " >>>> BADBOY_CCLEANER_CLEAN[i]=" .. BADBOY_CCLEANER_CLEAN[i])
						if Search(lowMsg, BADBOY_CCLEANER_CLEAN[i]) then
							result = true
							break
						end
					end
				else
					-- print ("lowMsg reqs not met!")
					result = true
				end

				-- filter due to lack of required keywords or found clean keywords...
				if result == true then
					-- print ("FILTERED: " .. msg)
					if BadBoyLog then BadBoyLog("CCleaner", event, trimmedPlayer, msg) end
					return true 
				end
			end
		end
	end
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter)

	frame:SetScript("OnEvent", nil)
	frame:UnregisterEvent("ADDON_LOADED")
end)

