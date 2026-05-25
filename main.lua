kart = require("Kart")
box = require("Box")
x, y = 400, 300
velocity = 0
transitionSpeed = 5
theta = 0
dtheta = 15 / (2 * 3.14)
MaxVelocity = 10

function love.load()
	-- love.window.setFullscreen(true, "desktop")
	k = kart.Kart:new(x, y)
    k2 = kart.Kart:new(100, 10)
	b = box.Box:new(nil)
end

function love.update(dt)
	k:update(dt)
    k2:update(dt)
    if love.keyboard.isDown("e") then
        k2:shoot()
    end
end

function love.draw()
	k:draw()
    k2:draw()
	b:draw()
end
