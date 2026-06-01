kart = require("Kart")
box = require("Box")
socket = require("socket")
game = require("game")

g = game.Game:new()


function love.load()
	-- love.window.setFullscreen(true, "desktop")
	-- k = kart.Kart:new(x, y)
    -- g = game.Game:new()
    g:load()
end

function love.update(dt)
	-- k:update(dt)
    g:update(dt)

end

function love.draw()
    g:draw()
end
