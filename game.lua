kart = require("Kart")
box = require("Box")
socket = require("socket")
bump = require("bump")

Game = {
	playersCoords = {},
	mainKart = nil,
	boxes = {},
	sock = nil,
	world = nil,
}

Game.__index = Game

function Game:new()
	ggg = {}
	setmetatable(ggg, self)
	ggg.world = bump.newWorld(64)
	return ggg
end
function Game:networking()
	if self.sock ~= nil then
		self.sock:send(self.mainKart:getPosString())

		local playerRaw = self.sock:receive("*l")
		self.playersCoords = {}
		while playerRaw ~= nil and playerRaw ~= "" do
			local playerInfo = {}
			for number in string.gmatch(playerRaw, "%d+") do
				table.insert(playerInfo, number)
			end
			table.insert(self.playersCoords, playerInfo)
			playerRaw = self.sock:receive("*l")
		end
	end
end
function Game:load()
	self.mainKart = kart.Kart:new(100, 100)
	table.insert(self.boxes, box.Box:new(nil))

	self.sock = socket.connect("localhost", 5000)
	self.networking(self)
end

function Game:update(dt)
	-- k:update(dt)
	self.mainKart:update(dt)
	if love.keyboard.isDown("e") then
		self.mainKart:shoot()
	end
	self.networking(self)
end

function Game:draw()
	-- k:draw()
	-- k2:draw()
	for id, player in ipairs(self.playersCoords) do
		-- x is player[2] y is player[3] (for some reason)
		print(id, player[2], player[3], player[4] / 1000)
		love.graphics.draw(self.mainKart.image, player[2], player[3], player[4] / 1000)
	end
	self.boxes[1]:draw()
end

return {
	Game = Game,
}
