kart = require("Kart")
box = require("Box")
socket = require("socket")

Game = {
    x = 400,
    y =  300,
    velocity = 0,
    transitionSpeed = 5,
    theta = 0,
    dtheta = 15 / (2 * 3.14),
    MaxVelocity = 10,
    playersCoords = {}
}

function Game:new() 
    ggg = {}
    setmetatable(ggg, self)

end

function Game:update()
    k2 = kart.Kart:new(100, 100)
	b = box.Box:new(nil)

    s = socket.connect("localhost", 5000)
end

function Game:load()
	-- k:update(dt)
    k2:update(dt)
    if love.keyboard.isDown("e") then
        k2:shoot()
    end
    if s ~= nil then
        s:send(k2:getPosString())

        playerRaw = s:receive("*l")
        i = 1
        playersCoords = {}
        while (playerRaw ~= nil and playerRaw ~= "") do
            
            playerInfo = {}
            j = 1
            for number in string.gmatch(playerRaw, "%d+") do
                table.insert(playerInfo, number)
            end
            table.insert(playersCoords, playerInfo)
            playerRaw = s:receive("*l")
        end
    end
end

function Game:draw()
	-- k:draw()
    -- k2:draw()
    for id,player in ipairs(playersCoords) do
        -- x is player[2] y is player[3] (for some reason)
        print(id, player[2], player[3], player[4]/1000)
        love.graphics.draw(k2.image, player[2], player[3], player[4]/1000)
    end
	b:draw()
end

