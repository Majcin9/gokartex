kart = require("Kart")
x, y = 400, 300
velocity = 0
transitionSpeed = 5
theta = 0
dtheta = 15 / (2 * 3.14)
MaxVelocity = 10

k = kart.Kart:new(nil, x, y)

function love.load()
	love.window.setFullscreen(true, "desktop")
end

function love.update(dt)
	k:update(dt)
end

function love.draw()
	k:draw()
end
