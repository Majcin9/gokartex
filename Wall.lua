drawing = require("drawing")

Wall = {
    x1 = 0,
    y1 = 0,
    x2 = 0,
    y2 = 0
}

Wall.__index = Wall

function Wall:new(x1, y1, x2, y2) 
    if x1 ~= x2 and y1 ~= y2 then
        return nil
    end
    local o = {}
    setmetatable(o, Wall)
    o.x1 = x1
    o.y1 = y1
    o.x2 = x2
    o.y2 = y2
    return o
end

function Wall:distance(x, y)
    local x1 = self.x1
    local y1 = self.y1
    local x2 = self.x2
    local y2 = self.y2

    if y1 == y2 then
        if x > x1 and x < x2 then
            return math.abs((y2-y1)*x - (x2-x1)*y + x2*y1 - y2*x1)/math.sqrt((y2-y1)^2 + (x2-x1)^2)
        elseif x < x1 then
            return drawing.pointDistance(x, y, x1, y1) 
        elseif x > x2 then
            return drawing.pointDistance(x, y, x2, y2) 
        end
    elseif x1 == x2 then
        if y > y1 and y < y2 then
            return math.abs((y2-y1)*x - (x2-x1)*y + x2*y1 - y2*x1)/math.sqrt((y2-y1)^2 + (x2-x1)^2)
        elseif y < y1 then
            return drawing.pointDistance(x, y, x1, y1) 
        elseif y > y2 then
            return drawing.pointDistance(x, y, x2, y2) 
        end

    end
end

function Wall:draw()
    love.graphics.line(self.x1, self.y1, self.x2, self.y2)
end

return {
    Wall = Wall
}
