kart = require("Kart")
box = require("Box")
socket = require("socket")

Game = {
    playersCoords = {},
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
    if love.keyboard.isDown("e") then
        self.mainKart:shoot()
    end
    if self.sock ~= nil then
        self.sock:send(self.mainKart:getPosString())

        local playerRaw = self.sock:receive("*l")
        self.playersCoords = {}
        while (playerRaw ~= nil and playerRaw ~= "") do
            
            local playerInfo = {}
            for number in string.gmatch(playerRaw, "%d+") do
                table.insert(playerInfo, number)
            end
            table.insert(self.playersCoords, playerInfo)
            playerRaw = self.sock:receive("*l")
        end
    end
    
    for id,player in ipairs(self.playersCoords) do
        if circleCollision(player[2], player[3], 100, 100, self.mainKart:radius()) then
            print("COLLISION")
        end
    end
end

function drawRotated(x, y, width, height, theta, image)
    local radius = math.sqrt((width * width) + (height * height))/2
    local alpha = math.asin(height/(2*radius))
    local newx = x - radius*math.cos(alpha + theta)
    local newy = y - radius*math.sin(alpha + theta)
    print(newx, newy)

	love.graphics.draw(image, newx, newy, theta)
end

-- returns array of 8 points laying on the ellipse
-- the points are evenly spaced, starting from intersection
-- of the ellipse and a straight line y=0, clockwise
function ellipseDefinitionPoints(x, y, width, height)
    
end

function Game:draw()
	-- k:draw()
    -- k2:draw()
    local width = self.mainKart.image:getWidth()
    local height = self.mainKart.image:getHeight()
    drawRotated(100, 100, width, height, 0, self.mainKart.image)
    for id,player in ipairs(self.playersCoords) do
        -- x is player[2] y is player[3] (for some reason)
        print(id, player[2], player[3], player[4]/1000)
        -- love.graphics.draw(self.mainKart.image, player[2], player[3], player[4]/1000)
        drawRotated(player[2], player[3], width, height, player[4]/1000, self.mainKart.image)
    end
    love.graphics.points(self.mainKart.x, self.mainKart.y)
	self.boxes[1]:draw()
end


return {
    Game = Game
}
