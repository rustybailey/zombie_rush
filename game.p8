pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
frames = 1
screen_width = 128
half_screen_width = screen_width / 2
screen_height = 128
half_screen_height = screen_height / 2
frame_rate = 60


function test_collision(a, b)
	return (
		a.x < b.x + b.width and
		a.x + a.width > b.x and
		a.y < b.y + b.height and
		a.y + a.height > b.y
	)
end

player = {
	x = 64,
	y = 64,
	width = 4,
	height = 8,
	dx = 0,
	dy = 0,
	ddx = 0,
	ddy = 0,
	cur_spr = 1,
	mirror = false,
	grounded = function(self)
	  local v = mget(flr(self.x+4)/8, flr(self.y)/8+1)
    return fget(v, 0)
	end,
	draw = function(self)
		spr(
			self.cur_spr,
			self.x,
			self.y,
			1,
			1,
			self.mirror
		)
	end,
	move = function(self)
    -- x acceleration
    self.ddx = 0
    if (btn(0)) self.ddx=-.25
    if (btn(1)) self.ddx=.25

    -- apply x accel
    self.dx += self.ddx

    -- limit max speed
    local max_speed = 1
    if self.dx > max_speed then
      self.dx = max_speed
    elseif self.dx < -max_speed then
      self.dx = -max_speed
    end

    -- drag
    if self.ddx == 0 then
      self.dx *= 0.8
    end

		-- y velocity
		if self:grounded() then
			if (btnp(4)) then
				self.dy=-8
			else
				self.dy = 0
				-- fix position
				-- or else he'll be sunk into floor
				self.y = flr(flr(self.y)/8)*8
			end
		else
			-- gravity accel
			self.dy += 0.98
		end

		-- update position based on vel
		self.x += self.dx
		self.y += self.dy
	end,
	update = function(self)
	  if (btn(0) or btn(1)) then
	  	if frames%5 == 0 then
		  	if self.cur_spr == 4 then
	  			self.cur_spr = 5
		  	else
	  			self.cur_spr = 4
		  	end
		  end
		else
			self.cur_spr = 1
	  end

		if btn(0) then
			self.mirror = true;
		end

		if btn(1) then
			self.mirror = false;
		end

		self:move()
	end
}

sword = {
	x = player.x,
	y = player.y,
	width = 6,
	height = 3,
	sprite = 6,
	mirror = false,
	update = function(self)
		if btn(5) then
			self.visible = true
			self.x = player.x + 6
			self.y = player.y
			self.mirror = player.mirror
			if self.mirror then
				self.x = player.x - 6
			end
		else
			self.visible = false
		end
	end,
	draw = function(self)
	 	if self.visible then
			spr(
				self.sprite,
				self.x,
				self.y,
				1,
				1,
				self.mirror
			)
		end
	end
}

baddie = {
	x = 100,
	y = 64,
	width = 3,
	height = 8,
	sprite = 32,
	mirror = false,
	alive = true,
	update = function(self)
		if (self.alive) then
			stabbed = test_collision(self, sword)
			self.alive = not stabbed
		end
	end,
	draw = function(self)
	  if (self.alive) then
			spr(
				self.sprite,
				self.x,
				self.y,
				1,
				1,
				self.mirror
			)
		end
	end
}

function update_frames()
  frames+=1
  if frames > frame_rate then frames = 1 end
end

function _update60()
 	update_frames()
	player:update()
	sword:update()
	baddie:update()
end

function _draw()
 	cls()
 	-- draw the map
 	map(0,0, 0,0, 16,16)
	player:draw()
	sword:draw()
	baddie:draw()
end
__gfx__
0000000000fff00000fff0000000000000fff00000fff00000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000fcfc0000fcfc000000000000fcfc0000fcfc0000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000fff00000fff0000000000000fff00000fff0000a000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000999900009999900000000000999900009999000adaaaa00000000000000000000000000000000000000000000000000000000000000000000000000
0007700009999000099990000000000009999000099990000a000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000cccc0000cccc000000000000cccc0000cccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000c00c0000c00c000000000000000c0000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000050050000500500000000000000050000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddd7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddd71000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd777711000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd777711000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd777711000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd777711000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d7111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
71111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000d7700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000ccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000aaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000101000000000001010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000001010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010000010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010001010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010000000000000000000101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
