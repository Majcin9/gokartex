kart = require("Kart")
box = require("Box")
x, y = 400, 300
velocity = 0
transitionSpeed = 5
theta = 0
dtheta = 15 / (2 * 3.14)
MaxVelocity = 10

function love.load()
	love.window.setFullscreen(true, "desktop")
	k = kart.Kart:new(nil, x, y)
	b = box.Box:new(nil)
end

function love.update(dt)
	k:update(dt)
end

function love.draw()
	k:draw()
	b:draw()
end
