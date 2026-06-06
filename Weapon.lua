weaponType = { GUN = {
    damage = 100,
    speed = 15
    }
}

screen_width = 400
screen_height = 400

Weapon = {
    type = weaponType.GUN,
    bullets = 3
}

Weapon.__index = Weapon

function Weapon:new(type, bullets)
	local w = w or {}
	setmetatable(w, self)
	w.__index = self
    w.type = type or weaponType.GUN
    w.bullets = bullets or 3
	return w
end

function Weapon:fire(x, y, theta)
    if self.bullets == 0 then
        return nil
    end
    self.bullets = self.bullets - 1
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
    bull.theta = theta or 0
    bull.type = type or weaponType.GUN
    bull.imagePath = imagePath or "assets/bullet.png"
    bull.image = love.graphics.newImage(bull.imagePath)
    bull.radius = bull.image:getWidth()/2
	return bull
end

function Bullet:update()
    self.x = self.x + self.type.speed * math.cos(self.theta)
    self.y = self.y + self.type.speed * math.sin(self.theta)
    if self.x > screen_width or self.y > screen_width or self.x < 0 or self.y < 0 then
        self.x = -1
        self.y = -1
    end
    return self
end

function Bullet:isEmpty()
    return self.x == -1 or self.y == -1
end

function Bullet:draw()
    drawing.drawRotated(self.x, self.y, self.image:getWidth(), self.image:getHeight(), self.theta)
end

function Bullet:getPosString()
    if not self:isEmpty() then
        return math.floor(self.x) .. " " .. math.floor(self.y) .. " " .. math.floor(self.theta*1000)
    end
    return "-1 -1 0"
end

return {
    Weapon = Weapon,
    Bullet = Bullet
}
