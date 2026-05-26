Player = {
    id = 0,
    x = 0,
    y = 0,
    theta = 0
}

Player.__index = Player

function Player:new(id, x, y, theta) 
    pl = {}
    setmetatable(pl, self)
    pl.id = id or 0
    pl.x = x or 0
    pl.y = y or 0
    pl.theta = theta or 0
    return pl
end


