Box = {
	x = 0,
	y = 0,
	imagepath = "assets/box.png",
	image = nil,
}
Box.__index = Box
function Box:new(x, y, imagepath)
	local o = {}
	setmetatable(o, self)
	o.__index = self
	local w, h = love.window.getDesktopDimensions()
	o.x = x or math.random(1, w - 1)
	o.y = y or math.random(1, h - 1)
	o.image = love.graphics.newImage(imagepath or "assets/box.png")
	return o
end

function Box:update() end

function Box:draw()
	love.graphics.draw(self.image, self.x, self.y, 0, 0.1, 0.1)
end

return {
	Box = Box,
}
