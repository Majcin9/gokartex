Box = {
	x = 0,
	y = 0,
	imagepath = "assets/box.png",
	image = nil,
}
function Box:new(o, x, y, imagepath)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	w, h = love.window.getDesktopDimensions()
	self.x = x or math.random(1, w - 1)
	self.y = y or math.random(1, h - 1)
	self.image = love.graphics.newImage(imagepath or "assets/box.png")
	return o
end

function Box:update() end

function Box:draw()
	love.graphics.draw(self.image, self.x, self.y, 0, 0.1, 0.1)
end

return {
	Box = Box,
}
