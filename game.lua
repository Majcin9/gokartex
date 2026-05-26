kart = require("Kart")
box = require("Box")
socket = require("socket")
bump = require("bump")
player = require("player")

Game = {
	players = {},
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
		self.players = {}
		while playerRaw ~= nil and playerRaw ~= "" do
			local playerInfo = {}
			for number in string.gmatch(playerRaw, "%d+") do
				table.insert(playerInfo, number)
			end
			local new_player = Player:new(playerInfo[1], playerInfo[2], playerInfo[3], playerInfo[4])
			table.insert(self.players, new_player)
			playerRaw = self.sock:receive("*l")
		end
	end
end

function Game:load()
	self.mainKart = kart.Kart:new(100, 100, true)
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
	for id, player in ipairs(self.players) do
		print(player.id, player.x, player.y, player.theta / 1000)
        player:draw()
	end
	self.boxes[1]:draw()
end

return {
	Game = Game,
}
