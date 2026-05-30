weaponType = { GUN = {
    damage = 100,
    speed = 15
    }
}

Weapon = {
    type = weaponType.GUN
}

Weapon.__index = Weapon

function Weapon:new(type)
	local w = w or {}
	setmetatable(w, self)
	w.__index = self
    w.type = type or weaponType.GUN
	return w
end

function Weapon:fire(x, y, theta)
    return Bullet:new(x, y, theta)
end

Bullet = {
    x = 10,
    y = 10,
    theta = 0,
    type = nil,
    imagePath = "assets/bullet.png",
    image = nil,
    radius = nil
}

Bullet.__index = Bullet

function Bullet:new(x, y, theta, type, imagePath)
	bull = {}
	setmetatable(bull, self)
	bull.__index = self
    bull.x = x
    bull.y = y
    bull.theta = theta
    bull.type = type or weaponType.GUN
    bull.imagePath = imagePath or "assets/bullet.png"
    bull.image = love.graphics.newImage(bull.imagePath)
    bull.radius = bull.image:getWidth()/2
	return bull
end

function Bullet:update()
    self.x = self.x + self.type.speed * math.cos(self.theta)
    self.y = self.y + self.type.speed * math.sin(self.theta)
    return self
end

function Bullet:draw()
    drawing.drawRotated(self.x, self.y, self.image:getWidth(), self.image:getHeight(), self.theta)
end

function Bullet:getPosString()
    return self.x .. " " .. self.y .. " " .. self.theta*1000
end

return {
    Weapon = Weapon,
    Bullet = Bullet
}
