weapons = require("Weapon")
drawing = require("drawing")

local Kart = {
	x = 0,
	y = 0,
	velocity = 0,
	transitionSpeed = 5,
	theta = 0,
	dtheta = 15 / (2 * 3.14),
	MaxVelocity = 10,
	imagepath = "assets/helmet.png",
	image = nil,
	weapon = nil,
    shootTimeout = 0,
	bu = {Bullet:new(-1, -1), Bullet:new(-1, -1), Bullet:new(-1, -1)},
}

Kart.__index = Kart

function Kart:new(x, y, velocity, transitionSpeed, theta, dtheta, MaxVelocity, imagepath)
	o = {}
	setmetatable(o, self)
	o.x = x or 0
	o.y = y or 0
	o.velocity = velocity or 0
	o.transitionSpeed = transitionSpeed or 5
	o.theta = theta or 0
	o.dtheta = dtheta or (15 / (2 * 3.14))
	o.MaxVelocity = MaxVelocity or 10
	o.weapon = weapons.Weapon:new()
	o.image = love.graphics.newImage(imagepath or "assets/helmet.png")
	return o
end

function Kart:update(dt)
    -- MOVEMENT
	if love.keyboard.isDown("left") then
		self.theta = self.theta - self.dtheta * dt
		if self.theta < 0 then
			self.theta = 2 * 3.14
		end
	end
	if love.keyboard.isDown("right") then
		self.theta = self.theta + self.dtheta * dt
		if self.theta > 2 * 3.14 then
			self.theta = 0
		end
	end

	if love.keyboard.isDown("up") then
		if self.velocity < 0 then
			self.velocity = self.velocity + 3 * self.transitionSpeed * dt
		else
			self.velocity = self.velocity + self.transitionSpeed * dt
		end
	elseif love.keyboard.isDown("down") then
		if self.velocity > 0 then
			self.velocity = self.velocity - 3 * self.transitionSpeed * dt
		else
			self.velocity = self.velocity - self.transitionSpeed * dt
		end
	else
		if self.velocity < 0 then
			self.velocity = self.velocity + 2 * self.transitionSpeed * dt
		elseif self.velocity > 0 then
			self.velocity = self.velocity - 2 * self.transitionSpeed * dt
		end
	end

    -- SHOOTING
    print("bullet timeout", self.shootTimeout)
    self:decreaseShootTimeout()
	if love.keyboard.isDown("e") then
		local bu_ret = self:shoot()
	end

	if self.velocity > 0 then
		self.velocity = math.min(self.velocity, self.MaxVelocity)
	elseif self.velocity < 0 then
		self.velocity = math.max(self.velocity, -self.MaxVelocity)
	end
	self.x = self.x + self.velocity * math.cos(self.theta)
	self.y = self.y + self.velocity * math.sin(self.theta)
	for i, bullet in ipairs(self.bu) do
        if not bullet:isEmpty() then
            self.bu[i] = bullet:update()
        end
	end
end

function Kart:shoot()
    if self.shootTimeout ~= 0 then
        return
    end
	local bu_ret = nil
	if self.weapon ~= nil then
		bu_ret = self.weapon:fire(self.x, self.y, self.theta)
		if bu_ret == nil then
			self.weapon = nil
		end
	end

    if bu_ret ~= nil then
		for i = 1, 3 do
			local bull = self.bu[i]
			if bull:isEmpty() then
                print("shooted")
                self:setShootTimeout()
                self.bu[i] = bu_ret
                break
            end
		end
        -- table.insert(self.bu, bu_ret)
    end
end

function Kart:decreaseShootTimeout()
    if self.shootTimeout == 0 then
        return
    end
    self.shootTimeout = self.shootTimeout - 1
end

function Kart:setShootTimeout(d)
    self.shootTimeout = d or 3
end

function Kart:radius()
	return self.image:getWidth() / 2 --because texture is a square
end

function Kart:draw()
	local width = self.image:getWidth()
	local height = self.image:getHeight()
	local radius = math.sqrt((width * width) + (height * height)) / 2
	local newx = self.x + radius * math.cos((5 * 3.14 / 4) + self.theta)
	local newy = self.y + radius * math.sin((5 * 3.14 / 4) + self.theta)

	love.graphics.draw(self.image, newx, newy, self.theta)
    -- for i, bullet in ipairs(self.bu) do
    --     if bullet ~= nil then
    --         bullet:draw()
    --     end
    -- end
end

function Kart:getPosString()
	return math.floor(self.x) .. " " .. math.floor(self.y) .. " " .. math.floor(tonumber(self.theta * 1000))
end

return {
	Kart = Kart,
}
