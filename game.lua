kart = require("Kart")
weapon = require("Weapon")
box = require("Box")
socket = require("socket")
drawing = require("drawing")

Game = {
    playersCoords = {},
    bulletCoords = {},
    mainKart = nil,
    boxes = {},
    sock = nil,
}

Game.__index = Game

function Game:new() 
    ggg = {}
    setmetatable(ggg, self)
    return ggg
end

function Game:load()
    self.mainKart = kart.Kart:new(100, 100)
    table.insert(self.boxes, box.Box:new(nil))

    self.sock = socket.connect("localhost", 5000)
end

function Game:update(dt)
	-- k:update(dt)
    self.mainKart:update(dt)

    if self.sock ~= nil then
        local kartStr = "P " .. self.mainKart:getPosString()
        local bullstr = ""
        if self.mainKart.bu ~= nil then
            bullStr = "B " .. self.mainKart.bu:getPosString()
        else
            bullStr = "B -1 -1"
        end
        self.sock:send(kartStr .. "," .. bullStr)


        local playerRaw = self.sock:receive("*l")
        self.playersCoords = {}
        self.bulletCoords = {}
        while (playerRaw ~= nil and playerRaw ~= "") do
            local playerInfo = {}
            for number in string.gmatch(playerRaw, "[^%s]+") do
                table.insert(playerInfo, tonumber(number))
            end
            table.insert(self.playersCoords, playerInfo)
            local bulletRaw = self.sock:receive("*l")
            local bulletInfo = {}
            for number in string.gmatch(bulletRaw, "[^%s]+") do
                table.insert(bulletInfo, tonumber(number))
            end
            print("bulletRaw" .. bulletRaw)
            print("bulletInfo" .. bulletInfo[1], bulletInfo[2])
            table.insert(self.bulletCoords, bulletInfo)
            playerRaw = self.sock:receive("*l")
        end
    end

    local tempbu = Bullet:new(0, 0, 0)
    for id, bullet in ipairs(self.bulletCoords) do         -- bad way to get the radius.. FIX IT!
        if circleCollision(self.mainKart.x, self.mainKart.y, self.mainKart.image:getWidth()/2, bullet[1], bullet[2], tempbu.image:getWidth()/2) then
            print("BULLET COLLISION")
        end
    end
end


function Game:draw()
	-- k:draw()
    -- k2:draw()
    local width = self.mainKart.image:getWidth()
    local height = self.mainKart.image:getHeight()
    drawing.drawRotated(100, 100, width, height, 0, self.mainKart.image)
    for id,player in ipairs(self.playersCoords) do
        -- love.graphics.draw(self.mainKart.image, player[2], player[3], player[4]/1000)
        drawing.drawRotated(player[2], player[3], width, height, player[4]/1000, self.mainKart.image)
    end

    local tempbu = Bullet:new(0, 0, 0)
    local bulletWidth = tempbu.image:getWidth()

    for id,bullet in ipairs(self.bulletCoords) do
        drawing.drawRotated(bullet[1], bullet[2], bulletWidth, bulletWidth, bullet[3]/1000, tempbu.image)
    end
    love.graphics.points(self.mainKart.x, self.mainKart.y)
	self.boxes[1]:draw()
end


return {
    Game = Game
}
