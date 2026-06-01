Box = {
	x = 0,
	y = 0,
	imagepath = "assets/boxmini.png",
	image = nil,
	visible = true,
	timeinv = 0,
	timecheck = 0,
}
Box.__index = Box
function Box:new(x, y, visible, timeinv, timecheck, imagepath)
	local o = {}
	setmetatable(o, self)
	o.__index = self
	local w, h = love.graphics.getDimensions()
	o.x = x or math.random(1, w - 1)
	o.y = y or math.random(1, h - 1)
	o.visible = visible or true
	o.timeinv = timeinv or 0
	o.timecheck = timecheck or os.time()
	o.image = love.graphics.newImage(imagepath or "assets/boxmini.png")
	return o
end

function Box:radius()
	return self.image:getWidth() / 2 --because texture is a square
end

function Box:update()
	if not self.visible then
		local now = os.time()
		self.timeinv = self.timeinv + os.difftime(now, self.timecheck)
		self.timecheck = now
	else
		self.timeinv = 0
		self.timecheck = os.time()
	end
end

function Box:draw()
	if not self.visible then
		return
	end
	local width = self.image:getWidth()
	local height = self.image:getHeight()
	local radius = math.sqrt((width * width) + (height * height)) / 2
	local newx = self.x + radius * math.cos((5 * 3.14 / 4))
	local newy = self.y + radius * math.sin((5 * 3.14 / 4))

	love.graphics.draw(self.image, newx, newy, self.theta)
end

return {
	Box = Box,
}
