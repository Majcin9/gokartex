kart = require("Kart")
weapon = require("Weapon")
box = require("Box")
socket = require("socket")
drawing = require("drawing")

Game = {
	playersCoords = {},
	bulletCoords = {},
	mainKart = nil,
	boxes = {},
	sock = nil,
	id = 0,
}

Game.__index = Game

function Game:new()
	ggg = {}
	setmetatable(ggg, self)
	return ggg
end

function Game:load()
	self.mainKart = kart.Kart:new(100, 100)
	table.insert(self.boxes, box.Box:new(nil))
	table.insert(self.boxes, box.Box:new(nil))
	table.insert(self.boxes, box.Box:new(nil))
	table.insert(self.boxes, box.Box:new(nil))

	self.sock = socket.connect("localhost", 5000)

	self.id = tonumber(self.sock:receive("*l"))
end

function Game:update(dt)
	-- k:update(dt)
	self.mainKart:update(dt)

	if self.sock ~= nil then
		local kartStr = "P " .. self.mainKart:getPosString()
		if self.mainKart.bu ~= nil then
			bullStr = "B " .. self.mainKart.bu:getPosString()
		else
			bullStr = "B -1 -1"
		end
		local boxesStr = ""
		for id, box in ipairs(self.boxes) do
			local boxStr = box:getString()
			boxesStr = boxesStr .. ",X " .. boxStr
			print("BOX: " .. boxStr)
		end
		print("BOXES: " .. boxesStr)
		local sendStr = kartStr .. "," .. bullStr .. boxesStr
		print("Sent: " .. sendStr)
		self.sock:send(sendStr)

		local playerRaw = self.sock:receive("*l")
		self.playersCoords = {}
		self.bulletCoords = {}
		self.boxes = {}
		while playerRaw ~= nil and playerRaw ~= "" do
			local playerInfo = {}
			for number in string.gmatch(playerRaw, "[^%s]+") do
				table.insert(playerInfo, tonumber(number))
			end
			table.insert(self.playersCoords, playerInfo)
			local bulletRaw = self.sock:receive("*l")
			local bulletInfo = {}
			for number in string.gmatch(bulletRaw, "[^%s]+") do
				table.insert(bulletInfo, tonumber(number))
			end
			print("bulletRaw" .. bulletRaw)
			table.insert(self.bulletCoords, bulletInfo)
			for i = 0, 3 do
				local boxRaw = self.sock:receive("*l")
				local boxInfo = {}
				for number in string.gmatch(boxRaw, "[^%s]+") do
					table.insert(boxInfo, tonumber(number))
					print("BoxInfo number " .. tonumber(number) .. "! " .. number)
				end
				local new_box = Box:new(boxInfo[2], boxInfo[3], boxInfo[4], boxInfo[5])

				print("boxRaw" .. boxRaw)
				print("newbox: " .. new_box:getString())
				table.insert(self.boxes, new_box)
			end
			playerRaw = self.sock:receive("*l")
		end
	end

	local tempbu = Bullet:new(0, 0, 0)
	for id, bullet in ipairs(self.bulletCoords) do
		if bullet[1] ~= self.id then
			if
				circleCollision(
					self.mainKart.x,
					self.mainKart.y,
					self.mainKart.image:getWidth() / 2,
					bullet[2],
					bullet[3],
					tempbu.image:getWidth() / 2
				)
			then
				print("BULLET COLLISION")
			end
		end
	end
	for id, box in ipairs(self.boxes) do
		if
			circleCollision(
				self.mainKart.x,
				self.mainKart.y,
				self.mainKart.image:getWidth() / 2,
				box.x,
				box.y,
				box.image:getWidth() / 2
			) and box.visible
		then
			box.visible = false
			print("BOX COLLISION")
		elseif not box.visible and box.timeinv >= 3 then
			box.visible = true
		end
		box:update()
	end
end

function Game:draw()
	-- k:draw()
	-- k2:draw()
	local width = self.mainKart.image:getWidth()
	local height = self.mainKart.image:getHeight()
	drawing.drawRotated(100, 100, width, height, 0, self.mainKart.image)
	for id, player in ipairs(self.playersCoords) do
		-- love.graphics.draw(self.mainKart.image, player[2], player[3], player[4]/1000)
		drawing.drawRotated(player[2], player[3], width, height, player[4] / 1000, self.mainKart.image)
	end

	local tempbu = Bullet:new(0, 0, 0)
	local bulletWidth = tempbu.image:getWidth()

	for id, bullet in ipairs(self.bulletCoords) do
		drawing.drawRotated(bullet[2], bullet[3], bulletWidth, bulletWidth, bullet[4] / 1000, tempbu.image)
	end
	love.graphics.points(self.mainKart.x, self.mainKart.y)
	for id, box in ipairs(self.boxes) do
		box:draw()
	end
end

return {
	Game = Game,
}
