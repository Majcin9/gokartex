Kart = { x = 0, y = 0, velocity = 0, transitionSpeed = 5, theta = 0, dtheta = 15 / (2 * 3.14), MaxVelocity = 10 }
function Kart:new(o, x, y, velocity, transitionSpeed, theta, dtheta, MaxVelocity)
	o = o or {}
	print("AA")
	setmetatable(o, self)
	print("BB")
	self.__index = self
	self.x = x or 0
	self.y = y or 0
	self.velocity = velocity or 0
	self.transitionSpeed = transitionSpeed or 5
	self.theta = theta or 0
	self.dtheta = dtheta or (15 / (2 * 3.14))
	self.MaxVelocity = MaxVelocity or 10
	return o
end

function Kart:update(dt)
	if love.keyboard.isDown("left") then
		theta = theta - dtheta * dt
	end
	if love.keyboard.isDown("right") then
		theta = theta + dtheta * dt
	end
	if love.keyboard.isDown("up") then
		velocity = velocity + transitionSpeed * dt
		-- y = y - 100 * dt
	else
		if love.keyboard.isDown("down") then
			velocity = velocity - transitionSpeed * dt
			-- y = y + 100 * dt
		else
			velocity = velocity - transitionSpeed * dt
			if velocity < 0 then
				velocity = 0
			end
		end
	end
	velocity = math.min(velocity, MaxVelocity)
	x = x + velocity * math.cos(theta)
	y = y + velocity * math.sin(theta)
end
