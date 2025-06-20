local obj = {}
obj.__index = obj

function obj:init()
	hs.eventtap
		.new({ "all" }, function(e)
			print("=== "..os.date("%Y-%m-%d %H:%M:%S").." ===")
			local type = hs.eventtap.event.types[e:getType()]
			if type == "gesture" then
				local touches = e:getTouches()
				if touches == nil or #touches < 1 then
					return
				end
				print(touches[1].phase)
			end
		end)
		:start()
end

return obj
