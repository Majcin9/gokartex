weaponType = { GUN = {
    damage = 100,
    speed = 1
    }
}

Weapon = {
    type = weaponType.GUN
}

function Weapon:new(o, type)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
    self.type = type or weaponType.GUN
	return o
end

function Weapon:fire(x, y)
    return Bullet:new(x, y, self.type)
end

Bullet = {
    x = 10,
    y = 10,
    type = nil,
    imagePath = "assets/bullet.png",
    image = nil
}

function Bullet:new(o, x, y, theta, type, imagePath)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
    self.x = x
    self.y = y
    self.theta = theta
    self.type = type or weaponType.GUN
    self.imagePath = imagePath or "assets/bullet.png"
    self.image = love.graphics.newImage(image)
	return o
end

function Bullet:update()
    self.x = self.x + self.type.speed * cos(self.theta)
    self.y = self.y + self.type.speed * sin(self.theta)
    love.graphics.draw(x, y, self.theta, 0.2, 0.2)
end

return {
    Weapon = Weapon,
    Bullet = Bullet
}
