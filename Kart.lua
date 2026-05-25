Kart = {
	x = 0,
	y = 0,
	velocity = 0,
	transitionSpeed = 5,
	theta = 0,
	dtheta = 15 / (2 * 3.14),
	MaxVelocity = 10,
	imagepath = "assets/gokart3.png",
}
function Kart:new(o, x, y, velocity, transitionSpeed, theta, dtheta, MaxVelocity, imagepath)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	self.x = x or 0
	self.y = y or 0
	self.velocity = velocity or 0
	self.transitionSpeed = transitionSpeed or 5
	self.theta = theta or 0
	self.dtheta = dtheta or (15 / (2 * 3.14))
	self.MaxVelocity = MaxVelocity or 10
	self.image = love.graphics.newImage(imagepath or "assets/gokart3.png")
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
	elseif love.keyboard.isDown("down") then
        velocity = velocity - transitionSpeed * dt
	else
        if velocity < 0 then
            velocity = velocity + transitionSpeed * dt
        elseif velocity > 0 then
            velocity = velocity - transitionSpeed * dt
        end
    end
    if velocity > 0 then
        velocity = math.min(velocity, MaxVelocity)
    elseif velocity < 0 then
        velocity = math.max(velocity, -MaxVelocity)
    end
	x = x + velocity * math.cos(theta)
	y = y + velocity * math.sin(theta)
end

function Kart:draw()
	love.graphics.draw(image, x, y, theta)
end

return {
	Kart = Kart,
}
