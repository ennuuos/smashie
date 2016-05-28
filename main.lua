keys = {
	'q',
	'w',
	'e',
	'r',
	't',
	'y',
	'u',
	'i',
	'o',
	'p',
	'a',
	's',
	'd',
	'f',
	'g',
	'h',
	'j',
	'k',
	'l',
	'z',
	'x',
	'c',
	'v',
	'b',
	'n',
	'm'
}


bInGame = true
bWindowChanged = false

windowwidth = 220
windowheight = 800
--Smashie Settings
smashie = {}
smashie.width = 30
smashie.height = 100
smashie.x = windowwidth/2 - smashie.width/2
smashie.linewidth = 4

smashie.speed = 150
smashie.speedStart = 150


smashie.regionSize = 400
smashie.regionStartSize = 400

smashie.spawnBuffer = 50

smashie.speedChange = 10
smashie.regionChange = 300

smashed = 0

smashies = {}

function reset()
	smashies = {}
	smashie.speed = smashie.speedStart
	smashie.regionSize = smashie.regionStartSize
	smashed = 0
end

function newGame()
	reset()
	newSmashie(35, smashie.x , keys[math.random(1, table.getn(keys))])
end

function newSmashie(origin, x,  key)
	i = table.getn(smashies) + 1
	smashies[i] = {}
	smashies[i].loc = origin
	smashies[i].key = key
	smashies[i].color = {}
	smashies[i].color.r = math.random(10,255)
	smashies[i].color.g = math.random(10,255)
	smashies[i].color.b = math.random(10,255)
	smashies[i].x = x

end

function drawSmashies()
	i = table.getn(smashies)
	while i >= 1 do
		if smashies[i].loc + smashie.height > windowheight - smashie.regionSize and smashies[i].loc < windowheight then
			love.graphics.setColor(smashies[i].color.r + 20,smashies[i].color.g + 20,smashies[i].color.b + 20)
		else
			love.graphics.setColor(smashies[i].color.r,smashies[i].color.g,smashies[i].color.b)
		end
		love.graphics.rectangle("fill", smashies[i].x, smashies[i].loc, smashie.width, smashie.height)

		if smashies[i].loc + smashie.height > windowheight - smashie.regionSize and smashies[i].loc < windowheight then
			love.graphics.setColor(smashies[i].color.r - 40,smashies[i].color.g - 40,smashies[i].color.b - 40)
		else
			love.graphics.setColor(smashies[i].color.r - 20,smashies[i].color.g - 20,smashies[i].color.b - 20)
		end
		love.graphics.rectangle("fill", smashies[i].x + smashie.linewidth, smashies[i].loc + smashie.linewidth, smashie.width - smashie.linewidth*2, smashie.height - smashie.linewidth*2)

		love.graphics.setColor(0, 0, 0)
		-- TODO: SET KEYS TO UPPERCASE
		love.graphics.printf(smashies[i].key, smashies[i].x, smashies[i].loc + smashie.height/2 - 5, smashie.width, 'center')

		i = i - 1
	end
end

function updateSmashies(dt)
	i = 1
	while i <= table.getn(smashies) do
		smashies[i].loc = smashies[i].loc + smashie.speed * dt
		if smashies[i].loc >= windowheight then
			gameEnded = true
			bInGame = false
		end
		i = i + 1
	end
end

function checkKeys(dt)
	ki = 1
	while ki <= table.getn(keys) do

		if(love.keyboard.isDown(keys[ki])) then
			smashie.regionSize = smashie.regionSize - smashie.regionChange * dt
			smashie.speed = smashie.speed + smashie.speedChange * dt

			i = 1
			while i <= table.getn(smashies) do
				if smashies[i].key == keys[ki] then
					if smashies[i].loc + smashie.height > windowheight - smashie.regionSize and smashies[i].loc < windowheight then
						table.remove(smashies, i)
						newSmashie(math.random(30, windowheight - smashie.regionSize - smashie.height - smashie.spawnBuffer), math.random(0, windowwidth - smashie.width), keys[math.random(1, table.getn(keys))])
						smashed = smashed + 1
					end
				end
				i = i + 1
			end

		end

		ki = ki + 1
	end
end

function love.load(arg)
		math.randomseed(os.time())
	love.window.setMode(windowwidth, windowheight)
	love.window.setTitle("Smashie")
	font = love.graphics.newFont(16)
	love.graphics.setFont(font)
	love.graphics.setBackgroundColor(50,50,100)
	--reset()
	--newSmashie(35, smashie.x , keys[math.random(1, table.getn(keys))])
	newGame()


end

function love.update(dt)
	if bInGame then
		updateSmashies(dt)
		checkKeys(dt)

		if smashie.regionSize <= 0 then
			smashie.regionSize = smashie.regionStartSize
			newSmashie(math.random(30, windowheight - smashie.regionSize - smashie.height - smashie.spawnBuffer), math.random(0, windowwidth - smashie.width), keys[math.random(1, table.getn(keys))])
		end
	else
		if(love.keyboard.isDown("return")) then
			newGame()
			bInGame = true
			bWindowChanged = false
			love.window.setMode(windowwidth, windowheight)
		end
	end
end

function love.draw()
	if bInGame then
		love.graphics.setColor(60,60,110)
		love.graphics.rectangle("fill", 0, windowheight - smashie.regionSize, windowwidth, smashie.regionSize)


		drawSmashies()

		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle("fill", 0, windowheight - smashie.regionSize, windowwidth, 1)

		love.graphics.setColor(40,40,90)
		love.graphics.rectangle("fill", 0, 0, windowwidth, 30)

		love.graphics.setColor(255,255,255)
		love.graphics.printf("Smashed "..smashed, 0, 10, windowwidth, 'center')
		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle("fill", 0, 30, windowwidth, 1)
	else
		if not bWindowChanged then
			love.window.setMode(windowwidth, windowwidth)
			bWindowChanged = true
		end
		love.graphics.printf("Game Over", 0, 60, windowwidth, 'center')
		love.graphics.printf("You smashed "..smashed.." blocks", 0, 90, windowwidth, 'center')

		love.graphics.setColor(60,60,110)
		love.graphics.rectangle("fill", 0, windowwidth - 40, windowwidth, 40)

		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle("fill", 0, windowwidth - 40, windowwidth, 1)

		love.graphics.printf("Press Enter to Play Again", 0, windowwidth - 30, windowwidth, 'center')
	end
end
