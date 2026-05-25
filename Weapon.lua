weaponType = { GUN = {
    damage = 100,
    speed = 4
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

function Weapon:fire(x, y)
    return Bullet:new(x, y)
end

Bullet = {
    x = 10,
    y = 10,
    type = nil,
    imagePath = "assets/bullet.png",
    image = nil
}

Bullet.__index = Bullet

function Bullet:new(x, y, theta, type, imagePath)
	bull = {}
	setmetatable(bull, self)
	bull.__index = self
    bull.x = x
    bull.y = y
    bull.theta = theta or 0
    bull.type = type or weaponType.GUN
    bull.imagePath = imagePath or "assets/bullet.png"
    bull.image = love.graphics.newImage(bull.imagePath)
	return bull
end

function Bullet:update(theta)
    self.x = self.x + self.type.speed * math.cos(theta)
    self.y = self.y + self.type.speed * math.sin(theta)
end

function Bullet:draw(theta)
    love.graphics.draw(self.image, self.x, self.y, theta, 0.1, 0.1)
end

return {
    Weapon = Weapon,
    Bullet = Bullet
}
