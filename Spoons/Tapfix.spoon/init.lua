-- hs.console.clearConsole()
local obj = {}
obj.__index = obj

local windowFlags = nil

function obj:init()
	hs
		.eventtap
		-- .new({ hs.eventtap.event.types.gesture }, function(e)
		.new({ "all" }, function(e)
      local eventType = e:getType()
			local touches = e:getTouches()
			local flags = {}
			for key, value in pairs(e:getFlags()) do
				if value then
					table.insert(flags, key)
				end
			end

			-- if #flags > 0 and touches ~= nil and #touches == 1 and touches[1].phase == "ended" then
			-- 	local absolutePosition = hs.mouse.absolutePosition()
			-- 	hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, absolutePosition, flags):post()
			-- 	hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, absolutePosition, flags):post()
			-- end

			-- -- NOTE: logs
			if touches ~= nil and #touches > 0 and touches[1].phase ~= "moved" then
				print("gesture" .. " - " .. touches[1].phase)
			elseif
				hs.eventtap.event.types[eventType] == "gesture"
				or hs.eventtap.event.types[eventType] == "mouseMoved"
				or hs.eventtap.event.types[eventType] == "keyUp"
				or hs.eventtap.event.types[eventType] == "keyDown"
			then
			else
				print(hs.eventtap.event.types[eventType])
			end

			if #flags > 0 and (touches ~= nil and #touches == 1 and touches[1].phase == "ended") then
				windowFlags = flags
				-- local log = "windowFlags: "
				-- for i, f in ipairs(windowFlags) do
				-- 	log = log .. f .. ", "
				-- end
				-- print(log)
				return
			end
			if windowFlags and (eventType == hs.eventtap.event.types.leftMouseDown) then
				windowFlags = nil
				-- print("windowFlags: nil (leftMouseDown)")
				return
			end
			if windowFlags and (eventType == hs.eventtap.event.types.flagsChanged and #flags == 0) then
				local absolutePosition = hs.mouse.absolutePosition()
				hs.eventtap.event
					.newMouseEvent(hs.eventtap.event.types.leftMouseDown, absolutePosition, windowFlags)
					:post()
				hs.eventtap.event
					.newMouseEvent(hs.eventtap.event.types.leftMouseUp, absolutePosition, windowFlags)
					:post()
				windowFlags = nil
				-- print("inject now!!!")
				-- print("windowFlags: nil (inject)")
				return
			end
		end)
		:start()
end

return obj
