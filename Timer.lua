Timer = {
	start = 0,
	now = 0,
	round_length = 300,
}
Timer.__index = Timer
function Timer:new(round_length, start)
	local o = {}
	setmetatable(o, self)
	o.__index = self
	print("START:" .. start .. "\n")
	o.start = start or os.time()
	print(os.time() .. "\n")
	o.now = os.time()
	o.round_length = round_length or 150
	return o
end

function Timer:update()
	self.now = os.time()
	if self.now - self.start >= self.round_length then
		return 1
		--os.exit(0, true)
	end
	return 0
	-- if not self.visible then
	-- 	local now = os.time()
	-- 	self.timeinv = self.timeinv + os.difftime(now, self.timecheck)
	-- 	self.timecheck = now
	-- else
	-- 	self.timeinv = 0
	-- 	self.timecheck = os.time()
	-- end
end

function Timer:draw()
	--love.graphics.setColor(0, 255, 0, 255)
	if self.now - self.start >= self.round_length - 30 then
		love.graphics.setColor(255, 0, 0, 255)
	end
	love.graphics.print(self:getString(), 20, 20, 0, 1, 1)
	love.graphics.setColor(255, 255, 255, 255)
end

function Timer:getString()
	return tostring(math.floor((self.now - self.start)))
end

return {
	Timer = Timer,
}
