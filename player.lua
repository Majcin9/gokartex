Player = {
    id = 0,
    x = 0,
    y = 0,
    theta = 0,
	imagepath = "assets/gokart3.png",
}

Player.__index = Player

function Player:new(id, x, y, theta) 
    pl = {}
    setmetatable(pl, self)
    pl.id = id or 0
    pl.x = x or 0
    pl.y = y or 0
    pl.theta = theta or 0
    pl.imagepath = "assets/gokart3.png"
    pl.image = love.graphics.newImage(pl.imagepath)
    return pl
end

function Player:draw()
    local width = self.image:getWidth()
    local height = self.image:getHeight()
    local radius = math.sqrt((width * width) + (height * height))/2
    local newx = self.x + radius*math.cos((5*3.14/4) + self.theta/1000)
    local newy = self.y + radius*math.sin((5*3.14/4) + self.theta/1000)

	love.graphics.draw(self.image, newx, newy, self.theta/1000)
    if bu ~= nil then
        bu:draw(self.theta)
    end
end


