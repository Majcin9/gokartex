kart = require("Kart")
weapon = require("Weapon")
box = require("Box")
socket = require("socket")
drawing = require("drawing")
wall = require("Wall")

Game = {
    playersCoords = {},
    bulletCoords = {},
    mainKart = nil,
    boxes = {},
    sock = nil,
    id = 0
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
    while self.sock == nil do
        self.sock = socket.connect("localhost", 5000)
    end
    self.id = tonumber(self.sock:receive("*l"))
end

function Game:update(dt)
	-- k:update(dt)
    self.mainKart:update(dt)

    if self.sock ~= nil then
        local kartStr = "P " .. self.mainKart:getPosString()
        local bullStr = {}
        for i = 1, 3 do
            local bull = self.mainKart.bu[i]
            if bull ~= nil then
                table.insert(bullStr, "B " .. bull:getPosString())
            else
                table.insert(bullStr,"B -1 -1")
            end
        end
        self.sock:send(kartStr .. "," .. bullStr[1] .. "," .. bullStr[2] .. "," .. bullStr[3])


        local playerRaw = self.sock:receive("*l")
        self.playersCoords = {}
        self.bulletCoords = {}
        while (playerRaw ~= nil and playerRaw ~= "") do
            local playerInfo = {}
            for number in string.gmatch(playerRaw, "[^%s]+") do
                table.insert(playerInfo, tonumber(number))
            end
            table.insert(self.playersCoords, playerInfo)
            for i = 1, 3 do
                local bulletRaw = self.sock:receive("*l")
                local bulletInfo = {}
                for number in string.gmatch(bulletRaw, "[^%s]+") do
                    table.insert(bulletInfo, tonumber(number))
                end
                table.insert(self.bulletCoords, bulletInfo)
            end
            playerRaw = self.sock:receive("*l")
        end
    end

    local tempbu = Bullet:new(0, 0, 0)
    for id, bullet in ipairs(self.bulletCoords) do         
        if bullet[1] ~= self.id then
            if circleCollision(self.mainKart.x, self.mainKart.y, self.mainKart.image:getWidth()/2, bullet[2], bullet[3], tempbu.image:getWidth()/2) then
                print("BULLET COLLISION")
            end
        end
    end

    local w = wall.Wall:new(10, 10, 100, 10)
end


function Game:draw()
	-- k:draw()
    -- k2:draw()
    local width = self.mainKart.image:getWidth()
    local height = self.mainKart.image:getHeight()
    -- drawing.drawRotated(100, 100, width, height, 0, self.mainKart.image)

    for id,player in ipairs(self.playersCoords) do
        -- love.graphics.draw(self.mainKart.image, player[2], player[3], player[4]/1000)
        drawing.drawRotated(player[2], player[3], width, height, player[4]/1000, self.mainKart.image)
    end

    local tempbu = Bullet:new(0, 0, 0)
    local bulletWidth = tempbu.image:getWidth()

    for id,bullet in ipairs(self.bulletCoords) do
        print(bullet[2], bullet[3])
        if bullet[2] ~= -1 and bullet[3] ~= -1 then
            drawing.drawRotated(bullet[2], bullet[3], bulletWidth, bulletWidth, bullet[4]/1000, tempbu.image)
        end
    end
    love.graphics.points(self.mainKart.x, self.mainKart.y)
	self.boxes[1]:draw()

    love.graphics.line(10, 10, 100, 10)
end


return {
    Game = Game
}
