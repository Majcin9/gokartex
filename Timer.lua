Timer = {
	start = 0,
	now = 0,
	round_length = 300,
}
Timer.__index = Timer
function Timer:new(round_length)
	local o = {}
	setmetatable(o, self)
	o.__index = self
	o.start = os.time()
	o.now = os.time()
	o.round_length = round_length or 150
	return o
end

function Timer:update()
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
	self.now = os.time()
	if self.now - self.start >= self.round_length then
		os.exit(0, true)
	end
	if self.now - self.start >= self.round_length - 30 then
		love.graphics.setColor(255, 0, 0, 255)
	end
	love.graphics.print(self:getString(), 20, 20, 0, 2, 2)
	love.graphics.setColor(255, 255, 255, 255)
end

function Timer:getString()
	return tostring(math.floor((self.now - self.start)))
end

return {
	Timer = Timer,
}
