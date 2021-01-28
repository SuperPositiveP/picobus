pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- picobus encore
-- superpositivep

--[[
this port is a mix of all
publicly known crazybus
versions (0.7, 0.8, 1.1, 2.0)

this is due to both limitations
of pico-8 and the aim of
crafting a near definitive
crazybus experience.
--]]

-- version information
codename, version, binary, debug = "encore", "3.0", false, true

-- default bus selection
defbus = 1

function _init()
	-- 32 col pallete
	pal()
	poke(0x5f5f,0x10)
	poke(0x5f2e,1)

	if debug then
		debug_enabled()
--[[	else
		-- double check that we are
		-- not in 64x64 mode
		poke(0x5f2c,0)
		clip()
		-- lowresjam2020 build
		-- run bundled cart if
		-- binary build.
		local lowrescart = "#wtf01_mini"
		if (binary) lowrescart = "picobus mini.p8"
		menuitem(2, "dlc: lowresjam", function() load(lowrescart)end)
--]]
	end

	--[[
	
	current screen

	the splash screens dont count
	as they only show once when
	the cartridge boots.
	--]]

	--[[
	-1 = none
	0 = title
	1 = bus select
	2 = instructions
	3 = normal game
	]]--
	scr = -1

	-- gfx
	blink_frame, t, txt_flash, dust = false, 0, false, {}

	-- might not need to be global
	-- logo rainbow colors
	title_rainbow = {
	3, 7, 9, 10, 11, 12, 13, 14
	}

	-- might not need to be global
	-- random bus color choices
	bus_rainbow = {
	2, 3, 6, 8, 9, 10, 11, 14
	}

	-- game score
	-- bus position
	-- wheel animation frame
	-- instructions countdown
	score1, score2, pos, wanim, instcount = 0, 0, 0, 3
	scorestr1, scorestr2 = "", "0"
	-- game bg color pallete (does not need to be global...)
	-- randomized bus color (might not need to be defined this early)
	bgcolpal, buscol = 7, 14

	-- selected bus
	busid = defbus

	-- bus info

	-- this system can be improved greatly.
	-- tables are token heavy and used way too much there
	-- and i should do my own math.

	--[[
	hp refers to the horsepower
	of the engine.
	--]]


	--[[
	bus ids are in the order they
	were added into the original
	game each version.
	--]]

	century395={
		brand="irizar",
		name="century 3.95",
		origin="spain",
		height="3.95m (sd)",
		flavor1="the superior luxury bus",
		flavor2="mercedes benz chassis",
		flavor3="first bus added to crazybus",
		motorhp="360hp",
		passangers="50 (max)",
		id=1,
		rndcolor=true,
		sx=32,
		sy=16,
		sw=8*4,
		sh=8,
		dy=94,
		dw=(8*4)*2,
		dh=16,
		w1sx=37,
		w2sx=48,
		wsy=22,
		psprite=68
		}

	--update infoflags
	visstabuss={
		brand="busscar",
		name="vissta buss",
		origin="brazil?",
		height="?.??m (sd)",
		flavor1="this bus was cut from",
		flavor2="the original crazybus",
		flavor3="in version 1.1",
		motorhp="???hp",
		passangers="?? (max)",
		rndcolor=false,
		id=2,
		sx=64,
		sy=16,
		sw=8*3,
		sh=8,
		dy=94,
		dw=(8*3)*2,
		dh=16,
		w1sx=69,
		w2sx=80,
		wsy=22,
		psprite=124
		}

	schoolbus={
		brand="generic",
		name="school bus",
		origin="??????",
		height="2.50m (sd)",
		flavor1="classic yellow schoolbus",
		flavor2="variable configurations",
		flavor3="weak ford or chevy engine",
		motorhp="200hp",
		passangers="60 (max)",
		id=3,
		rndcolor=false,
		sx=40,
		sy=24,
		sw=8*3,
		sh=8,
		dy=96,
		dw=(8*3)*2,
		dh=16,
		w1sx=45,
		w2sx=56,
		wsy=29,
		psprite=116
		}

	jumbuss={
		brand="busscar",
		name="jum buss 360",
		origin="brazil",
		height="3.60m (sd)",
		flavor1="the sturdy bus",
		flavor2="best chassis (volvo)",
		flavor3="",
		motorhp="360hp",
		passangers="52 (max)",
		rndcolor=true,
		id=4,
		sx=104,
		sy=0,
		sw=8*3,
		sh=8,
		dy=94,
		dw=(8*3)*2,
		dh=16,
		w1sx=109,
		w2sx=120,
		wsy=6,
		psprite=72
		}

	ent6000={
		brand="encava",
		name="e-nt6000",
		origin="venezuela",
		height="3.80m (sd)",
		flavor1="model for short routes",
		flavor2="has a custom chassis",
		flavor3="had 340 horsepower in cb v1.1",
		motorhp="300hp",
		passangers="40 (max)",
		rndcolor=true,
		id=5,
		sx=64,
		sy=24,
		sw=8*4,
		sh=8,
		dy=94,
		dw=(8*4)*2,
		dh=16,
		w1sx=69,
		w2sx=80,
		wsy=30,
		psprite=76
		}

	pgv1150={
		brand="marcopolo",
		name="paradiso gv1150",
		origin="brazil",
		height="3.55m (sd)",
		flavor1="the legendary bus",
		flavor2="uses a volvo chassis",
		flavor3="",
		motorhp="340hp",
		passangers="52 (max)",
		rndcolor=true,
		id=6,
		sx=64,
		sy=8,
		sw=8*3,
		sh=8,
		dy=94,
		dw=(8*3)*2,
		dh=16,
		w1sx=69,
		w2sx=80,
		wsy=14,
		psprite=120
  }

	pico8={
		brand="lexaloffle",
		name="pico-8 logo",
		origin="fantasy land",
		height="n/a",
		flavor1="surely i don't need",
		flavor2="to explain what this is?",
		flavor3="",
		motorhp="  n/a",
		passangers="     n/a",
		rndcolor=false,
		id=7,
		sx=0,
		sy=8,
		sw=8*4,
		sh=8,
		dy=94,
		dw=(8*4)*2,
		dh=16,
		w1sx=3,
		w2sx=23,
		wsy=14,
		psprite=16
		}

	--[[

	ya like kfad, kfad2, or kfag?
	check out host for a day (hfad)

	https://www.youtube.com/c/hiipaspooker

	https://www.youtube.com/playlist?list=plrrziyh6rd1u7ynynxexhn47wztwcrxw2

	https://discord.io/hfad

	... i know this isn't what
	you are here for, but at
	least check it out for loge...

	shill over.


	also if you like kfag, kfag2
	is a thing now:

	https://www.youtube.com/channel/ucaoxjpt671cjwt8hfwrulaa

	https://discord.gg/gy5uysc

	it has nothing to do with vavr,
	since he is dead, but its the
	same team who did the original.

	also check out other tourneys
	at tourneyhub.

	https://discord.gg/shuxwgg

	--]]

	--[[loge={
		brand="hfad",
		name="loge",
		origin="hiipaspooker",
		height=">small",
		flavor1="a log with a doge face",
		flavor2="sports a cute hat",
		flavor3="youtube.com/c/hiipaspooker",
		motorhp="  n/a",
		passangers="     n/a",
		rndcolor=false,
		-- replace with a global
		flipped=false,
		id=8,
		psprite=28
		}--]]
		
	coge={
		brand="hfad",
		name="coge",
		origin="hiipaspooker",
		height=">small",
		flavor1="a cog with a doge face",
		flavor2="sports a cute hat",
		flavor3="youtube.com/c/hiipaspooker",
		motorhp="  n/a",
		passangers="     n/a",
		rndcolor=false,
		-- replace with a global
		flipped=false,
		id=8,
		psprite=28
		}

	-- impostor loge was here
	im_loge={
		brand="n/a",
		name="impostor loge",
		origin="bosnia",
		height=">small",
		flavor1="the scoundrel himself!",
		flavor2="he's here to put you in debt",
		flavor3="and troll you to no end!",
		motorhp="  n/a",
		passangers="     n/a",
		rndcolor=false,
		-- just use the flipped variable
		-- in loge's info for both.
		--flipped=false,
		id=9,
		psprite=28
		}

		loge_flipped = false

		-- m&m's themed bus
		-- for hypercord anniversary
	mnmbus={
		brand="himhey's",
		name="mnm's bus",
		origin="protocord/hypercord",
		height="4.20m (sd)",
		flavor1="approaching sound barrier!",
		flavor2="happy 3rd anniversary to",
		flavor3="protocord and hypercord!",
		motorhp="666hp",
		passangers="69 (max)",
		rndcolor=false,
		id=10,
		sx=104,
		sy=80,
		sw=8*3,
		sh=8,
		dy=94,
		dw=(8*3)*2,
		dh=16,
		w1sx=122,
		w2sx=122,
		wsy=86,
		psprite=164
  }

		-- based on joel stream
		-- youtu.be/3wxtynh1fja
	dt40l={
		brand="wentward",
		name="hero dt40l",
		origin="'merica",
		height="?.??m (sd)",
		flavor1="joel really likes this bus.",
		flavor2="it really is grand, isn't it?",
		flavor3="a very patriotic bus.",
		motorhp="345hp",
		passangers="?? (max)",
		rndcolor=false,
		id=11,
		sx=93,
		sy=88,
		sw=(8*4)+3,
		sh=8,
		dy=94,
		dw=((8*4)+3)*2,
		dh=16,
		w1sx=104,
		w2sx=118,
		wsy=94,
		psprite=212
  }

	sleipnir={
		brand="??????",
		name="sleipnir",
		origin="iceland",
		height="?.??m (sd)",
		flavor1="this beast from iceland",
		flavor2="is a glacier bus.",
		flavor3="",
		motorhp="345hp",
		passangers="?? (max)",
		rndcolor=false,
		id=12,
		sx=64,
		sy=80,
		sw=8*4,
		sh=8,
		dy=94,
		dw=16*4,
		dh=16,
		w1sx=70,
		w2sx=73,
		wsy=86,
		psprite=208
  }

	dukebox={
		brand="kfag",
		name="dukebox of flies",
		origin="vavr fansubs",
		height="1m (~3ft)",
		flavor1="a living jukebox block",
		flavor2="has a knack for irony",
		flavor3="and wings on his back",
		motorhp="  n/a",
		passangers="     n/a",
		rndcolor=false,
		-- replace with a global
		flipped=false,
		id=13,
		psprite=28
		}


	-- bus info by id.
	busbyid = {
		century395,
		visstabuss,
		schoolbus,
		jumbuss,
		ent6000,
		pgv1150,
		pico8,
		--loge,
		coge,
		im_loge,
		mnmbus,
		dt40l,
		sleipnir,
		dukebox
		}

	-- for music timing
	mus_update = 1

	pico8_intro()
	logo_splash()
	credits_splash()

	-- corrupt mode
	if btn"0" and btn"2" then
		corruptor_menu()
		cls()
	end

	-- potential 64x64 screen mode for jam?

	--[[
	this is where the game flow
	actually starts.

	the game flow:

	* titlescreen
	* bus select
	* instructions
	* game
	* titlescreen
	* etc.
	--]]
	title_screen()
end

-- splash screen stuff
function pico8_intro()
	cls"0"

	palt(11, true)
	palt(0, false)
	pal(7,5)
	for i=0, 32 do
		cls"0"
		sspr(pico8.sx, pico8.sy, pico8.sw, pico8.sh, i, 48, pico8.dw, pico8.dh)
		sleep"0.06"
		sfx(0,2)
	end

	for i=6, 7 do
		sleep"0.2"
		pal(7,i)
		sspr(pico8.sx, pico8.sy, pico8.sw, pico8.sh, 32,48, pico8.dw, pico8.dh)
	end
	pal()
	sspr(8, 0, 8, 8, pico8.dw+30,44, 16, 16)

	-- move this to pattern 0 and 1
	-- i want to make better use of
	-- the mostly unused music memory
	music"0"

	sleep"1"
end

function logo_splash()
	cls"6"
	palt(0,false)
	sspr(0, 0, 8, 8, 32, 24, 64, 64)
	pal()
	print_centered("the problem attic", 100, 0, -1)

	sleep"4"
end

function credits_splash()
	cls"6"
	
	palt(0, false)
	
	pal(8, 142, 1)
	pal(7, 6)
	pal(0, 133, 1)
	pal(5, 134, 1)
	pal(12, 140, 1)
	pal(14, 143, 1)
	
	pal(3, 8, 1)
	
	pal(11, 0, 1)
	color"11"
	for i=0, 96, 32 do
		sspr(0, 72, 32, 16, 0, i, 32, 16)
		--spr(32, 0, i, 4, 2)
		sspr(0, 72, 32, 16, 32, i, 32, 16)
		sspr(0, 72, 32, 16, 0, i+16, 32, 16)
		sspr(0, 72, 32, 16, 32, i+16, 32, 16)
		--spr(32, 32, i+16, 4, 2)

		--spr(32, 64, i, 4, 2)
		sspr(0, 72, 32, 16, 64, i, 32, 16)
		sspr(0, 72, 32, 16, 96, i, 32, 16)
		sspr(0, 72, 32, 16, 64, i+16, 32, 16)
		sspr(0, 72, 32, 16, 96, i+16, 32, 16)
		--spr(32, 96, i+16, 4, 2)
	end
	
	line(1, 2, 1, 125, 11)
	line(126, 2, 126, 125, 11)
	line(2, 1, 125, 1, 11)
	line(2, 126, 125, 126, 11)
	
	rectfill(2, 95, 125, 125, 12)
	
	line(2, 94, 125, 94, 11)
	
	print("original game: tom scripts\nphotos: tom maneiro,cherrystar\n,wikipedia cc\nloge sprite: wewmu\nsee manual for further details.", 3, 96)
	
	palt(15, true)
	sspr(8, 25, 8, 7, 32, 19, 64, 64)
	sspr(0, 24, 8, 8, 48, 30, 32, 32)
	
	sleep"2"
	pal()
end
-->8
-- update and draw

--[[

	all that happens here is
	some rng stuff and calls
	to the actual update and draw
	functions for each screen.

--]]

function _update()

	if scr==0 then

	-- we only care about blinks
	-- during the title screen

		t = (t + 1) % 8
		blink_frame = (t == 0)

		title_update()
	elseif scr==1 then
		bussel_update()
	elseif scr==3 then
		game_update()
	end

	-- fix for psuedo rng
	--[[
	needed to make titlescreen
	sound consistent as in the
	original game.

	makes use of current seed
	and current time to determine
	new seed.
	--]]
	if btnp"0" or btnp"1" or btnp"2" or btnp"3" or btnp"4" or btnp"5" then
		-- for some reason this token optimization
		-- ruins/alters the behavior of this code
		-- srand((rnd(40)-20)+stat"93"-stat"94"+stat"95")
		srand((rnd(40)-20)+stat(93)-stat(94)+stat(95))
	end

end

function _draw()

	if scr==0 then
		title_draw()
	elseif scr==1 then
		bussel_draw()
	elseif scr==3 then
		game_draw()
	end

	if (debug) sdbg()
end

-->8
--other functions

function sleep(s)
	for i=1,s*30 do
		flip()
	end
end

function printfill(str, x, y, col, fcol)
	local x1 = 0

	x1 = (x - 1) + (#str * 4)

	rectfill(x - 1, y - 1, x1, y + 5 , fcol)
	print(str, x, y, col)
end

function print_centered(str, y, col, colf)

	if colf != -1 then
		rectfill(63 - (#str * 2), y - 5, 63 + (#str * 2), y + 1 , colf)
	end

	print(str, 64 - (#str * 2), y - 4, col)
end

-- "music"

--[[

	the secret sauce of the game
	the sole reason why it is so
	well known and memed up.

	this works by randomly playing
	single notes from two sound-
	effects that contain all the
	notes pico-8 can produce.

	i know poking memory is
	probably better, but it is
	really not worth the effort
	for what it is.

--]]

function pain()

	local sfx1 = 4
	local sfx2 = 5

	if scr==1 then
		sfx1 = 10
		sfx2 = 11
	end

	if mus_update > 0 then
		mus_update -= 1
	else

		if (stat(16) == -1) and (stat(17) == -1) or (stat(18) == -1) and (stat(19) == -1) then
			sfx(sfx1, -1, flr(rnd(31)), 1)
			sfx(sfx2, -1, flr(rnd(31)), 1)
		end

	mus_update = 4
	end
end

function killsound()
	for i=0,3,1 do
		sfx(-1,i)
	end
	music(-1)
	mus_update = 1
end

function corruptor()
	c_sd,c_at=1000,400 ::_lp::
	if not (btn"4") then cls()
 	if (btn"0") c_at-=5
 	if (btn"1") c_at+=5
 	if (btn"3") c_sd-=5
 	if (btn"2") c_sd+=5
 	print"picobus corrupt mode"
 	print"--------------------"
 	print("\n⬆️ ⬇️ seed: "..c_sd)
 	print("⬅️ ➡️ amount: "..c_at)
 	print"\n🅾️ to confirm"
 	print"\n(some corruptions only can be\nfixed by reseting)"
 	print"\n(check pause menu for\nnew options)"
 	flip()goto _lp
	else
	 srand(c_sd)
	 for i=1,c_at do
	  poke(rnd"0x8000",rnd"0x100")
 	end
	end
end

function corruptor_menu()
	corruptor()
	menuitem(1, "reload cart mem", function()
		reload()
		menuitem(1, "corrupt mode", corruptor_menu)
	end)
end

------ px9 ------

--[[

	compression is only used for
	bus photo on title and in
	instructions.

	i tried compressing the photos
	seen on the bus select screen,
	but the gains were not enough
	to be worth the slow load and
	the pain of having to point
	the decompress function to
	the correct part of memory.

	at most it saved like one tiles
	worth of space in the spritesheet
	for those tiny photos.

	the gains were better for the
	big photo, and i could
	even fit the fully compressed
	128x128 image in to the map.

	even the nes port is able to do
	better than this, but i don't
	have any other options that
	are worth trying to get it
	all to fit.

	i didn't bother to include the
	compress function. it would
	just be a waste of tokens.

--]]


-- px9 decompress

-- x0,y0 where to draw to
-- src   compressed data address
-- vget  read function (x,y)
-- vset  write function (x,y,v)

function
	px9_decomp(x0,y0,src,vget,vset)

	local function vlist_val(l, val)
		-- find position
		for i=1,#l do
			if l[i]==val then
				for j=i,2,-1 do
					l[j]=l[j-1]
				end
				l[1] = val
				return i
			end
		end
	end

	-- bit cache is between 16 and
	-- 31 bits long with the next
	-- bit always aligned to the
	-- lsb of the fractional part
	local cache,cache_bits=0,0
	function getval(bits)
		if cache_bits<16 then
			-- cache next 16 bits
			cache+=%src>>>16-cache_bits
			cache_bits+=16
			src+=2
		end
		-- clip out the bits we want
		-- and shift to integer bits
		local val=cache<<32-bits>>>16-bits
		-- now shift those bits out
		-- of the cache
		cache=cache>>>bits
		cache_bits-=bits
		return val
	end

	-- get number plus n
	function gnp(n)
		local bits=0
		repeat
			bits+=1
			local vv=getval(bits)
			n+=vv
		until vv<(1<<bits)-1
		return n
	end

	-- header

	local
		w,h_1,      -- w,h-1
		eb,el,pr,
		x,y,
		splen,
		predict
		=
		gnp"1",gnp"0",
		gnp"1",{},{},
		0,0,
		0
		--,nil

	for i=1,gnp"1" do
		add(el,getval(eb))
	end
	for y=y0,y0+h_1 do
		for x=x0,x0+w-1 do
			splen-=1

			if(splen<1) then
				splen,predict=gnp"1",not predict
			end

			local a=y>y0 and vget(x,y-1) or 0

			-- create vlist if needed
			local l=pr[a]
			if not l then
				l={}
				for e in all(el) do
					add(l,e)
				end
				pr[a]=l
			end

			-- grab index from stream
			-- iff predicted, always 1

			local v=l[predict and 1 or gnp"2"]

			-- update predictions
			vlist_val(l, v)
			vlist_val(el, v)

			-- set
			vset(x,y,v)

			-- advance
			x+=1
			y+=x\w
			x%=w
		end
	end
end
-->8
-- bus stuff

--[[

	the tire animation is really
	just a bunch of pallete swaps
	doing this saves me 2 sprite
	slots.

	it's pointless, but i'm not
	gonna just remove it now.

--]]

function d_tires(p, bus)
	local flip = false

	if p==0 then
		palt(11, true)
		palt(0, false)
		pal(2, 0)
		pal(15, 0)
		pal(12, 7)
	elseif p==1 then
		pal(2, 7)
		pal(15,0)
		pal(12, 0)
	elseif p==2 then
		flip = true
		pal(2, 0)
		pal(15, 0)
		pal(12, 7)
	elseif p==3 then
		pal(2, 0)
		pal(15,7)
		pal(12, 0)
	end

	sspr(32, 24, 3, 3, pos+(2*(bus.w1sx-bus.sx)), bus.dy+(2*(bus.wsy-bus.sy)), 6, 6, flip)
	sspr(32, 24, 3, 3, pos+(2*(bus.w2sx-bus.sx)), bus.dy+(2*(bus.wsy-bus.sy)), 6, 6, flip)
	pal()
end

-- this function is really just
-- me being lazy.

function drawbus(bus)

	if bus.id==7 then
		palt(1, true)
	end

	palt(11, true)
	palt(0, false)

	if bus.id==10 then
		mnm_tires(wanim, bus)
		sspr(96, 80, 8, 8, pos-8,bus.dy-16, 16, 16)
	end

	sspr(bus.sx, bus.sy, bus.sw, bus.sh, pos,bus.dy, bus.dw, bus.dh)
	d_tires(wanim, bus)

	palt(0, true)
	palt(11, false)

	if bus.id==7 then
		palt(1, false)
	end

end

-->8
--special bus stuff

--[[

	loge is special because he
	can turn around. additionally,
	he does not make use of wheels.

	here, i recycle the wheel
	animation variable for loge's
	animation and handle him
	turning around.

	he only uses 3 sprites. i
	draw his butt first and
	move it back and forth a
	pixel to save a couple
	sprite slots.

--]]

function drawloge()
	palt(11, true)
	palt(0, false)

	-- stores the sprite id for
	-- the face.

	-- loge is 11
	-- impostor loge is 43
	local face = 11

	-- loge and im_loge have
	-- diffrent hat shades
	-- and face sprites.
	if busid == 8 then
		pal(9, 5)
	elseif busid == 9 then
		pal(9, 0)
		face = 43
	end

	if loge_flipped then

		if wanim==0 then
			spr(face, pos, 104, 1, 1, loge_flipped)
			spr(12, pos, 96, 1, 1, loge_flipped)
			spr(10, pos+8, 104, 1, 1, loge_flipped)
		elseif wanim==1 then
			spr(face, pos, 104, 1, 1, loge_flipped)
			spr(12, pos, 96, 1, 1, loge_flipped)
			spr(9, pos+8, 104, 1, 1, loge_flipped)
		elseif wanim==2 then
			spr(9, pos+7, 104, 1, 1, loge_flipped)
			spr(face, pos, 104, 1, 1, loge_flipped)
			spr(12, pos, 96, 1, 1, loge_flipped)
		elseif wanim==3 then
			spr(10, pos+7, 104, 1, 1, loge_flipped)
			spr(face, pos, 104, 1, 1, loge_flipped)
			spr(12, pos, 96, 1, 1, loge_flipped)
		end

	else

		if wanim==0 then
			spr(10, pos, 104, 1, 1, loge_flipped)
			spr(face, pos+8, 104, 1, 1, loge_flipped)
			spr(12, pos+8, 96, 1, 1, loge_flipped)
		elseif wanim==1 then
			spr(9, pos, 104, 1, 1, loge_flipped)
			spr(face, pos+8, 104, 1, 1, loge_flipped)
			spr(12, pos+8, 96, 1, 1, loge_flipped)
		elseif wanim==2 then
			spr(9, pos+1, 104, 1, 1, loge_flipped)
			spr(face, pos+8, 104, 1, 1, loge_flipped)
			spr(12, pos+8, 96, 1, 1, loge_flipped)
		elseif wanim==3 then
			spr(10, pos+1, 104, 1, 1, loge_flipped)
			spr(face, pos+8, 104, 1, 1, loge_flipped)
			spr(12, pos+8, 96, 1, 1, loge_flipped)
		end
	end

	palt(0, true)
	palt(11, false)
end


-- coge sprite by kiivakunner
-- also handles dukebox floating
coge_base=81
coge_float_plus=true
function drawfloat()
	palt(11, true)
	palt(0, false)
	
	if coge_base >= 81+5 then
		coge_float_plus=false
	elseif coge_base <= 81 then
		coge_float_plus=true
	end
	
	if coge_float_plus then
		coge_base+=0.1
		
	elseif not coge_float_plus then
		coge_base=coge_base-0.1
	end
	
	if busid==8 then
		sspr(112, 96, 16, 24, pos, coge_base, 16, 24, loge_flipped)
	else
		sspr(96, 96, 16, 24, pos, coge_base, 16, 24, loge_flipped)
	end
	palt(11, false)
	palt(0, true)
end

-- special d_tires for
-- m&m's bus and sleipnir

--this NEEDS to be fixed

function mnm_tires(p, bus)
	local flip = false


	-- just use the numbers, dude
	local w1sx = 107
	local wsy = 84

	if p==0 then
		palt(11, true)
		palt(0, false)
		pal(2, 0)
		pal(15, 0)
		pal(12, 7)
	elseif p==1 then
		pal(2, 7)
		pal(15,0)
		pal(12, 0)
	elseif p==2 then
		flip = true
		pal(2, 0)
		pal(15, 0)
		pal(12, 7)
	elseif p==3 then
		pal(2, 0)
		pal(15,7)
		pal(12, 0)
	end

	sspr(32, 24, 3, 3, pos+(2*(w1sx-bus.sx)), bus.dy+(2*(wsy-bus.sy)), 10, 10, flip)
	pal()
	palt(11, true)
	palt(0, false)
end

function sleipnir_tires(p, bus)
	local flip = false

	palt(11, true)
	palt(0, false)

	if p==0 then
		palt(11, true)
		palt(0, false)
		pal(2, 0)
		pal(15, 0)
		pal(12, 7)
	elseif p==1 then
		pal(2, 7)
		pal(15,0)
		pal(12, 0)
	elseif p==2 then
		flip = true
		pal(2, 0)
		pal(15, 0)
		pal(12, 7)
	elseif p==3 then
		pal(2, 0)
		pal(15,7)
		pal(12, 0)
	end

	sspr(32, 24, 3, 3, pos+(2*(84-bus.sx)), bus.dy+(2*(bus.wsy-bus.sy)), 6, 6, flip)
	sspr(32, 24, 3, 3, pos+(2*(87-bus.sx)), bus.dy+(2*(bus.wsy-bus.sy)), 6, 6, flip)

	palt(0, true)
	palt(11, false)

	pal()
end

-- thanks for the particle
-- system, docrobs.

-- used for hero dt40l jet
-- and m&m bus dust
function add_new_dust(_x,_y,_dx,_dy,_l,_s,_g,_p,_f)
add(dust, {
fade=_f,x=_x,y=_y,dx=_dx,dy=_dy,life=_l,orig_life=_l,rad=_s,col=0,grav=_g,p=_p,draw=function(self)
pal()palt()circfill(self.x,self.y,self.rad,self.col)
end,update=function(self)
self.x+=self.dx self.y+=self.dy
self.dy+=self.grav self.rad*=self.p self.life-=1
if type(self.fade)=="table"then self.col=self.fade[flr(#self.fade*(self.life/self.orig_life))+1]else self.col=self.fade end
if self.life<0then del(dust,self)end end})
end
-->8
-- title screen
function title_screen()

	--[[
	this is here to make sure
	that we cleanly return from
	the game to the titlescreen
	without glithces.
	--]]

	scr = -1
	
	poke(0x5f5f,0x00)

	killsound()

	srand()

	blink_frame, t, txt_flash = false, 0, false

	-- it might be a placebo,
	-- but i swear clearing the screen
	-- with this specific color makes
	-- the photo decompress faster.
	cls"7"
	-- ...it's really odd...

	px9_decomp(0,0,0x2000,pget,pset)

 -- set-up for text blink
 -- copies portion of screen
 -- where the text blinks
 -- to work ram
 memcpy(0x4300, 0x719e, 0x025a)

 printfill("presiona z+x!", 64, 72, 10, 8)

 print_centered("by superpositivep", 90, 7, 8)
 print_centered("original by tom maneiro", 100, 7, 8)
 print_centered("pic: marcopolo paradiso 1800d", 110, 7, 8)
 print_centered("made in pennsylvania", 120, 10, 8)

 palt()

 palt(11, true)
 palt(0, false)
 sspr(32, 0, 40, 8, 30, 36, 80, 16)
 sspr(32, 8, 32, 8, 30, 52, 64, 16)

 sspr(88, 8, 8, 8, 90, 52, 16, 16)

 pal()

	scr = 0

end

function title_update()
	if btnp"4" or btnp"5" then
		bussel()
	end

	pain()
end

--[[

	 in the original game,
	 the logo text flashes
	 rainbow colors and the
	 'press start' text blinks.

--]]

function title_draw()
  if blink_frame then

    palt(11, true)
    palt(0, false)
    pal(7, rnd(title_rainbow))
    sspr(32, 0, 40, 8, 30, 36, 80, 16)
    sspr(32, 8, 32, 8, 30, 52, 64, 16)

    sspr(88, 8, 8, 8, 90, 52, 16, 16)

    pal()
    if txt_flash then
      txt_flash = false
      --[[
						i managed to make the
      flash take up no
      space in the spritesheet
      by using work ram :)

      it could be more efficent,
      but it doesn't really
      make a diffrence even
      if i make use of work
      ram for something else
      later.
						--]]

    		memcpy(0x719e, 0x4300, 0x025a)
    else
      txt_flash = true
      printfill("presiona z+x!", 64, 72, 10, 8)
    end

  end
end

-->8
-- bus selection

--[[
the bus select has the messiest
code of all the game.

it absolutely needs to be fixed.
]]--

function bussel()
	scr = -1

	killsound()

	-- lower the octave here
	-- by lowering audio clock-rate

	-- the music function is written
	-- to use sfx 10 and 11 on the
	-- bus select screen instead of
	-- sfx 4 and 5. these sets of
	-- sfx are identical except
	-- 10 and 11 are twice as fast
	-- as 4 and 5 to account for
	-- the slower audio speed.

	-- we don't want slower audio,
	-- just a lowered octave.

	-- perhaps 10 and 11 could be
	-- deleted if it is possible
	-- to manipulate the memory
	-- where the sfx speed is stored
	-- for sfx 4 and 5.

	poke(0x5f40, 0x1111.1111)

	buscol = rnd(bus_rainbow)

	srand()

	scr = 1

	busid = defbus
end

function bussel_update()

	if btnp"4" then
		-- restore audio clock-rate
		poke(0x5f40, 0x0000.0000)

		-- to instructions on 🅾️
		inst()
	elseif btn"0" and btn"1" then
		-- nothing lol
	elseif btnp"0" then
		busid -= 1
	elseif btnp"1" then
		busid += 1
	end

	if (busid<1) busid=#busbyid
	if (busid>#busbyid) busid=1

	pain()

end

function bussel_draw()
	cls()
	pal()

	-- fix this shit!

	for i=0, 96, 32 do
		sspr(0, 72, 32, 16, 0, i, 32, 16)
		--spr(32, 0, i, 4, 2)
		spr(96, 32, i, 4, 2)
		spr(64, 0, i+16, 4, 2)
		sspr(0, 72, 32, 16, 32, i+16, 32, 16)
		--spr(32, 32, i+16, 4, 2)

		--spr(32, 64, i, 4, 2)
		sspr(0, 72, 32, 16, 64, i, 32, 16)
		spr(96, 96, i, 4, 2)
		spr(64, 64, i+16, 4, 2)
		sspr(0, 72, 32, 16, 96, i+16, 32, 16)
		--spr(32, 96, i+16, 4, 2)
	end

	busportiat(busbyid[busid])
	drawbus_bussel(busbyid[busid])

	printfill(busbyid[busid].name,4,4,5,12)

	printfill("brand: "..busbyid[busid].brand,4,16,5,12)
	printfill("origin: "..busbyid[busid].origin,4,22,5,12)
	printfill("height: "..busbyid[busid].height,4,28,5,12)

	printfill(busbyid[busid].flavor1,4,40,5,12)
	printfill(busbyid[busid].flavor2,4,46,5,12)

	if #busbyid[busid].flavor3!=0 then
		printfill(busbyid[busid].flavor3,4,52,5,12)
	end

	printfill("==>select a bus!<==",4,64,5,12)

	printfill("motor:",86,76,5,12)
	printfill(" "..busbyid[busid].motorhp,86,82,5,12)

	printfill("occupancy:",86,92,5,12)
	printfill("  "..busbyid[busid].passangers,86,98,5,12)

	printfill("controls:",86,108,5,12)
	printfill(" ⬅️ ➡️ 🅾️   ",86,98+16,5,12)

end

function busportiat(bus)

	-- no portrait for pico-8 logo
	if busid != 7 and busid!= 9 then
		rectfill(#"==>select a bus!<=="+3,73,#"==>select a bus!<=="+36,98, 0)
		spr(bus.psprite,#"==>select a bus!<=="+4,74,4,3)
	elseif busid==7 then
		sspr(pico8.sx, pico8.sy, pico8.sw, pico8.sh, #"==>select a bus!<=="-11,88, pico8.dw, pico8.dh)

	-- a bit of bullshittery
	-- and corruption to cop myself
	-- out of having to use up
	-- space in the spritesheet
	-- for an impostor loge photo.
	elseif busid==9 then

		pal(14,12)
		pal(5,0)
		rectfill(#"==>select a bus!<=="+3,73,#"==>select a bus!<=="+36,98, 0)
		spr(bus.psprite,#"==>select a bus!<=="+4,74,4,3)
		pal(14,14)
		pal(5,5)

		portrait_glitch()

	end

end

function drawbus_bussel(bus)

	local sel_dx = 15
	local sel_dy = 102
	local sel_dw = 53

	palt(0, false)
	palt(11, true)

	if (busid==3) sel_dy+=2

	if busid==11 then
		sel_dx -= 7
		sel_dw = bus.dw+2
	end

	if busid == 12 then
		sel_dx -= 5
		sel_dw = bus.dw+2
	end

	if busid != 8 and busid != 9 and busid != 13 and busid != 7 then

		rectfill(sel_dx-2,sel_dy-2,sel_dx+sel_dw,102+bus.dh+2, 11)

		if busid == 10 then
			pal(2, 0)
			pal(15, 0)
			pal(12, 7)
			sspr(32, 24, 3, 3, sel_dx+(2*(107-bus.sx)), sel_dy+(2*(84-bus.sy)), 10, 10, flip)
			pal(2, 2)
			pal(15, 15)
			pal(12, 12)
		end

		if busid == 12 then
			pal(2, 0)
			pal(15, 0)
			pal(12, 7)
			sspr(32, 24, 3, 3, sel_dx+(2*(84-bus.sx)), sel_dy+(2*(bus.wsy-bus.sy)), 6, 6)
			sspr(32, 24, 3, 3, sel_dx+(2*(87-bus.sx)), sel_dy+(2*(bus.wsy-bus.sy)), 6, 6)
			pal(2, 2)
			pal(15, 15)
			pal(12, 12)
		end

		sspr(bus.sx, bus.sy, bus.sw, bus.sh, sel_dx, sel_dy, bus.dw, bus.dh)

		pal(2, 0)
		pal(15, 0)
		pal(12, 7)

		sspr(32, 24, 3, 3, sel_dx+(2*(bus.w1sx-bus.sx)), sel_dy+(2*(bus.wsy-bus.sy)), 6, 6)
		sspr(32, 24, 3, 3, sel_dx+(2*(bus.w2sx-bus.sx)), sel_dy+(2*(bus.wsy-bus.sy)), 6, 6)
		pal()
	elseif busid==7 then
		-- nothing lol
	elseif busid==8 or busid==9 or busid==13 then
		-- loge specific stuff

		sel_dx = 30
		sel_dy = 112

		palt(11, false)

		if busid==8 then
			pal(9,5)
			spr(10, sel_dx, sel_dy, 2, 1)
			spr(12, sel_dx+8, sel_dy-8, 1, 1)
		else
			pal(9,0)
			spr(10, sel_dx, sel_dy, 1, 1)
			spr(43, sel_dx+8, sel_dy, 1, 1)
			spr(12, sel_dx+8, sel_dy-8, 1, 1)
		end

		pal(9,9)
	end

end

function portrait_glitch()

	-- made specifically for
	-- impostor loge.

	-- may use for other buses.

	local addr_a = 0x724b

	for i=1, 7 do

		local addr_b = addr_a+0x011

		local addr_c = addr_a+0x040
		local addr_d = addr_c+0x011

  poke(addr_a+rnd(addr_b-addr_a),rnd(0x100))
  poke(addr_c+rnd(addr_d-addr_c),rnd(0x100))

		addr_a+=0x100
 end

end
-->8
-- instructions

--[[
this screen is intended to last
about 3 seconds. all the code
has to run inside of  the same
function for the countdown to
work properly with the sleep
function.

the sleep function intterupts
draw and update, so they really
only exist here as dummys.

everything important goes down
in the inst function.
--]]

function inst()
	scr = 2

	killsound()
	srand()

	instcount=3

	cls"7"
	px9_decomp(0,0,0x2000,pget,pset)

	inst_draw()

	-- loop 3 times
	for i=3, 0, -1 do
		-- wait one second
		sleep"1"
		-- decrement the counter
		instcount-=1
		-- draw to the screen
		inst_draw()
		-- play the countdown beep
		-- except for zero
		if (i!=0) sfx(1)
	end

	-- when the countdown ends,
	-- jump to the actual game
	game()

end

-- the actual draw function
-- for this screen.
function inst_draw()

	-- draw the picobus logo
	palt(11, true)
	palt(0, false)
	sspr(32, 0, 40, 8, 30, 4, 80, 16)
	sspr(32, 8, 32, 8, 30, 52-32, 64, 16)
	sspr(88, 8, 8, 8, 90, 52-32, 16, 16)
	pal()

	-- the instructions text
	printfill("** controls **", 64-#"** controls **"*2,38,5,12)
	printfill("⬅️ move bus backwards ", 20,56,5,12)
	printfill("➡️ move bus forwards ", 20,64,5,12)
	printfill("🅾️ horn/beep ", 20,72,5,12)
	printfill("❎ return to titlescreen ",20,80,5,12)

	printfill("prepare...",50,120,5,12)

	--[[

	these are the numbers that
	appear in the bottom right
	corner.

	i have achived this the same
	way tom did in the original.

	it's probably the only code
	that is near identical to how
	it looks in the original


	basically, i abuse new lines
	to make numbers out of the
	number text characters.
	--]]

	rectfill(101, 95, 101+16, 95+30, 12)

	if (instcount==3) then
		print("3333\n   3\n  33\n   3\n3333",102,96,5)
	elseif (instcount==2) then
		print("2222\n   2\n2222\n2    \n2222",102,96,5)
	elseif (instcount==1) then
		print("  11\n   1\n   1\n   1\n  111",98,96,5)
	else
		print("0000\n0  0\n0  0\n0  0\n0000",102,96,5)
	end

end
-->8
-- game

--[[
this absoluely could be cleaner,
but it is not nearly as bad as the
bus selection screen.
]]--

function game()
	scr = -1

	poke(0x5f5f,0x3d)
	pal({[0]=0x82,0x82,0x84,0x84,4,4,0x89,0x89,0x8e,0x8e,0x8f,0x8f,15,15,0x87,0x87},2)
	memset(0x5f70,0xaa,16)

	-- reset variables each game

	pos, wanim, score1, score2 = 0, 0, 0, 0
	scorestr1, scorestr2 = "", "0"
	loge_flipped = false
	dust={}

	scr = 3

	if (busid!=8 and busid!=9) sfx(6, 3)
end

function game_update()

	--[[
	pico-8 has no screen wrap.
 this is here to account
	for that.
	--]]
	if (pos > 160) pos = -120
	if (pos < -120) pos = 160

	if btn"1" and btn"0" then
		-- do nothing on left and
		-- right being held together.
	elseif btn"1" then
		score2 += 1
		pos += 1
		wanim += 1
		if (not busid==8) sfx(0, 2)
		if (busid==8 and (stat(18) == -1)) sfx(16, 2, 0, 4)
		
		-- hero dt40l jet
		if busid==11 then
			score2 += 1
			pos += 1
			for i=1,10 do
				add_new_dust(pos+2,busbyid[busid].dy+9,rnd(2)-4,rnd(0.5)-0.25,rnd(20)+10,rnd(4)+1,-0.1,0.9,{10,12,10,9,12,9,2,2,12,2,2,5,5,1,1,2,12,2,12,2})
			end
		end

		-- m&m sound barrier dust
		if busid==10 then
			score2 += 3
			pos += 3
			for i=1,10 do
				add_new_dust(pos+10,busbyid[busid].dy+18,rnd(2)-4,rnd(1)-1.75,rnd(10)+5,rnd(4)+1,0.1,0.9,{0,0,0,0,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6})
			end
		end

		-- loge can turn around
		-- when going backwards.
		if (busid==8 or busid==9) loge_flipped=false

	elseif btn"0" then
		score2 -= 1
		pos -= 1
		wanim -= 1
		if (not busid==8) sfx(0, 2)
		if (busid==8 and (stat(18) == -1)) sfx(16, 2, 0, 4)
		
		if stat(17)==-1 and busid!=8 and busid!=9 then
			sfx(3,1)
		end

		if (busid==8 or busid==9) loge_flipped=true

	end

	if (wanim < 0) wanim = 3
	if (wanim > 3) wanim = 0

	-- beep on 🅾️
	-- unless loge, bonk for loge.
	if btn"4" and busid!=8 and busid!=9 then
		sfx(1, 0)
		sfx(2, 1)
	elseif btn"4" and busid==8 then
		sfx(17, 0)
	elseif btn"4" and busid==8 or btn"4" and busid==9 then
		sfx(9, 0)
	end

	-- jump to title on ❎
	if (btn"5") title_screen()

	--shitty unsigned 16-bit int
	--implementation.
	
	--this is why the score is
	--in two parts and has
	--seperate string variables
	if score2 > 999 then
		score1 += 1
		score2 =0
	end
	
	if score2 < 0 then
		score1 -= 1
		score2 = 999
	end
	
	if score1 < 0 then
		score1 = 65
		score2 = 535
	end
	
	if score1 >= 65 and score2 >= 536 then
		score1 = 0
		score2 = 0
	end
	
	scorestr1 = tostr(score1)
	scorestr2 = tostr(score2)
	
	if score1 > 0 then
		if score2 < 10 then
			scorestr2 = "00"..scorestr2
		elseif score2 < 100 then
			scorestr2 = "0"..scorestr2
		end
	end
	
	if score1 <= 0 then
		scorestr1 = ""
	end
	
	-- dust particles
	if busid==10 or busid==11 then
		--move dust
		for d in all(dust) do
	  d:update()
	 end
	end
	

end

function game_draw()
	-- draw the stage and score
	cls"13"
	stage()
	print("travel: "..scorestr1..scorestr2, 4, 36,bgcolpal)

	-- draw loge or the current bus
	if busid==8 or busid==13 then
		drawfloat()
	elseif busid==9 then
		drawloge()
	else
		game_pal(busbyid[busid])
		drawbus(busbyid[busid])
		-- draw extra tires for selipnir
		if (busid==12) sleipnir_tires(wanim, busbyid[busid])
	end

	-- draw the infotag of the bus
	pal()
	stageinfotag(busbyid[busid])

	-- dust particles
	if busid==10 or busid==11 then
		--draw dust
		for d in all(dust) do
	  d:draw()
	 end
	end

end

function stage()
	--[[
	draw the background elements
	of the game here.
	--]]

	palt(11, true)
	palt(0, false)

	-- draw the road
	-- replace with fillp and rectfill?
	pal(15,bgcolpal)
	for i=0, 15, 1 do
		spr(2, i*8, 112)
		spr(3, i*8, 120)
	end
	pal(15,15)

	-- draw the picobus logo in
	-- the top right
	spr(4, 80, 8, 4, 2)
	spr(8, 112, 8)
	spr(27, 110, 16)

	palt(0, true)
	palt(11, false)

	-- print build info under logo
	print("ver. "..version,75,25,bgcolpal)
	printfill(codename,95,31,14,0)

	color(bgcolpal)

	-- print back to title button
	print("❎ = title",4,4)

	-- draw the crooked post
	fillp(▒)
	rectfill(64,106,68,111,bgcolpal)
	rectfill(59,96,63,105,bgcolpal)
	rectfill(54,90,58,96,bgcolpal)
	rectfill(50,75,54,89,bgcolpal)
	fillp()
	print("\129",55,70,bgcolpal)
	print("\129",48,65,bgcolpal)
	print("\129",62,65,bgcolpal)
	print("\129",55,60,bgcolpal)

	-- draw the normal posts
	drawpost"10"
	drawpost"114"
end

function stageinfotag(bus)
	--[[
	print the infotag for
	the current bus to the
	gameplay screen.
	--]]

	-- buses 7, 8, 9 are not buses
	if bus.id!=7 and bus.id!=8 and bus.id!=9 then
		print("your bus:", 4, 14)
	else
		print("your \"bus\":", 4, 14)
	end

	print("["..bus.brand.."]", 4, 20)
	print(bus.name, 4, 26)

end

-- todo:
-- remove the following function
-- , this code is never reused.

-- move this code where ever
-- the function was originally
-- called.
function game_pal(bus)
	--[[
	this is where the colors
	are handled for the game
	itself.

	nothing special happens here.

	--]]

	if (bus.rndcolor) pal(14, buscol)

end

function drawpost(x)
	--[[
	this function draws the
	two posts that arent crooked
	--]]
	fillp(▒)

	rectfill(x+1,70, x+5, 111, bgcolpal)

	print("\129",x,70,bgcolpal)
	print("\129",x-7,65,bgcolpal)
	print("\129",x+7,65,bgcolpal)
	print("\129",x,60,bgcolpal)

	fillp()
end
-->8
-- debug

function debug_enabled()
	-- makes it less of a pain
	-- when i accidentally
	-- press the function key
	menuitem(2, "display label.p8", label)

	-- thx shootingstar
	dbg_dbtn = '`' dbt = 7 don = false cc = 8 mc = 15 addr = 0x5e00 function dtxt(txt,x,y,c) print(txt, x,y+1,1) print(txt,x,y,c) end function init_dbg() poke(0x5f2d, 1) test_num = peek(∧addr) or 0 poke(∧addr, test_num+1) end dbtm = 0 dbu = {0,0,0} function sdbg() if stat(31) == dbg_dbtn then if don==false then don=true else don=false end end if don != true then return end local c=dbt local cpu=stat(1)*100 local mem=(stat(0)/100)/10*32 local fps=stat(7) local u=stat(7)..'' local _x=124-(#u*4) local du = {dbu[1],dbu[2],dbu[3]} dtxt(u, 124-(#u*4), 1, c) u=cpu..'%' dtxt(u, 124-(#u*4), 7, c) u=mem..'kb /' dtxt(u, 124-(#u*4)-32, 13, c) dtxt('31.25kib', 128-33, 13, c) dtxt(du[3]..'h', 124-44, 128-9, c) dtxt(du[2]..'m', 124-28, 128-9, c) dtxt(du[1] ..'s', 124-12, 128-9, c) dtxt('cpu', 1, 7, c) dtxt('mem', 1, 13, c) dtxt('pico-'..stat(5), 1, 128-15, c) dtxt('uptime', 1, 128-9, c) dbtm+=1 dbu[1] = flr(dbtm/stat(8)) dbu[2] = flr(dbu[1]/60) dbu[3] = flr(dbu[2]/60) dtxt('test number: '..peek(0x5e00), 0, 24, c) dtxt('mouse: {'..stat(32)..','..stat(33)..'}\nbitmask: '..stat(34), 0, 30, c) draw_dbg_info(c) end function draw_dbg_info(c) local m = {stat(32)/8, stat(33)/8} local tile=fget(mget(m[0],m[1]), 0) dtxt('tile flags', 0, 6*8, c) local res = {} res[1] = fget(mget(m[1],m[2]), 0) res[2] = fget(mget(m[1],m[2]), 1) res[3] = fget(mget(m[1],m[2]), 2) res[4] = fget(mget(m[1],m[2]), 3) res[5] = fget(mget(m[1],m[2]), 4) res[6] = fget(mget(m[1],m[2]), 5) res[7] = fget(mget(m[1],m[2]), 6) res[8] = fget(mget(m[1],m[2]), 7) dtxt('{'.. blton(res[1]) ..','..blton(res[2]) ..','..blton(res[3]) ..','..blton(res[4]) ..'\n '..blton(res[5]) ..','..blton(res[6]) ..','..blton(res[7]) ..','..blton(res[8]) ..'}\ntile-id: '..mget(m[1],m[2]), 0, 6*9, c) print('color: '..pget(m[1]*8,m[2]*8), 0, 6*12, max(pget(m[1]*8,m[2]*8), 1)) circ(stat(32), stat(33), 3, c) circfill(stat(32), stat(33),1, c) end function blton(v) return v and 1 or 0 end
	init_dbg()
end

function label()
	scr = -1
	--[[
	expect label.p8 to be in the
	extras directory post-release.
	--]]
	reload(0, 0, 0x4300, "extras\\label.p8")
	cls()
	spr(0, 0, 0, 16, 16)
	menuitem(2, "reset to exit", label)
end
__gfx__
7777777700800000555555550ff00ff0b8888bb888888888888888888888888888bbbbbbbbbbbbbbbbbbbbbbbb0ee0bbbbbbbbbbeeeeeeeeeeeeeeeeeeeeeebb
70007007097f000055555555f00ff00f8888bb888888888888888888888888888bbbbbbbbb000000bb0000000000000bbbbbbbbbeccc1111c1111c111ecc55cb
77707777a777e000555555550ff00ff0bbbbbb888888888888888888888888888bbbbbbbb0ffffffb0fffffff0ffff0bbbbbbbbbeecc1111c1111c111ee5cc5c
070770700b7d1000f00ff00ff00ff00fb888b888888888888888888888888888bbbbbbbb0ff444440ff444440f7070f0bbbbbbbbeecc1111c1111c1111e5cc5e
0000000700c100000ff00ff00ff00ff0888bb777877788778877877787878877bbbbbbbb0f4444440f4444440fff0ff0bbbbbbbb85eeeeeeeeeeeeeaeee5555c
0707070700000000f00ff00ff00ff00fbbbbb78788788788878787878787878bbbbbbbbb0f4444440f4444440ff000f0bb0000bb85555555555555555555ee5c
70000077000000000ff00ff00ff00ff0888b777787887888787877788787877bbbbbbbbb0f4440000f44444440ffff0bbb0990bbee5e5bbb5aeeeea5bbba555a
7777777700000000f00ff00ff00ff00fbbbb788887887888787878787878887bbbbbbbbbb0000bbbb0000000000000bbbb0990bbbeee5bbb5eeeeee5bbb5eeee
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb888b78887778877877887778777877bbeeeeeeeeeeeeeeeeeeeeeebbb000bbbb00000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb88888888888888888888888888bbe5511511151151151115117b0eee0bbb00000000000000000000000000000000
bb7777b7777bb777bb7777bbbbb7777b88b888888888888888888888888888bbe5511511151151151115111b0e000bbb000000000000006dd600000000000000
b771771b771177111771771bbbb71171bbb88880008888888888880008888bbbeeeeeeeeeee66eee111555110eee0bbb0000000000000d555d00000000000000
b777771b771b771bb77177177b77777188b88800500888888888800500888bbb1111111111611611511511510e000bbb0000000000006555ee66666000000000
b771111b771b771bb771771b11771171bbbbbb05550bbbbbbbbbb05550bbbbbb8e00eeeeee6ee63eeeee11510eee0bbb000000000000601ee55dfffff6000000
b771bbb7777b7777b777711bbb777771bbbbbb00500bbbbbbbbbb00500bbbbbb8ee0ebbbae65e65ebbbaeeeab000bbbb000000000000062e55dffffffff00000
bbbbbbbb1111b111bb1111bbbbb11111bbbbbbb000bbbbbbbbbbbb000bbbbbbbbbeeebbbee6ee6eebbbeeeebbbbbbbbb000000000000062554ffffffffff0000
bbbbbbbbbb3333bba000a00a00677000beeeeeeeeeeeeeeeeee000b00bbbbbbbb111111111111111111111bbbb0cc0bb0000000000000d244ffffffff6ff0000
000000bb0300003b0a00000007770000e0505550555055505550500bb0bbbbbbc1ccdcccdcccdccc1dd000cb0000000b0000000d606644444fff6ffff66ff000
f0ffff0b30ffff0300a00aaa67700000e5505550555055505550005bbbbbbbbbc1ccdcccdcccdccc1dd0dd0bf0ffff0b0000000d244444442ffd6fff655fe000
0f7070f0337070f30000aaaa77600000e55055505550555000005005bbbbbbbbc1ccdcccdcccdcc11dd0ddd00f0707f000000644424444444ffffffffddff600
0fff0ff033ff0ff3a00aaa997770000080eeeeeee0eeeeeeeee05505bbbbbbbb811111111111111110d00dd000ff505000006444224444444efffeeeffdff600
0ff000f00ff0003000aaa999677600008000055500555500555e0000bbbbbbbb810000000000000000000dd00f00f5f0000044444444444444feeeeeeddfe000
40ffff0b40ffff0b00aa99990777700055ee5bbb50e00ee5bbb5eeeabbbbbbbb11001bbb11111111bbb1111a40ffff0b000644d44444444444eeeeeee4eff000
000000bb000000bba0aa999900677600b5ee5bbb50eeeee5bbb5eeebbbbbbbbbb1111bbb11111111bbb1111b000000bb000d444444444444442eeeeee44f0000
ffffffffffffffff0000000000000000c20bbbbbbb9999999999999999bbbbbbbeeeeeeeeeeeeeeeeeeeeeb66bbbbbbb000d44444444444444424eeeeed00000
fffffffff33ff33f0000000000000000f5fbbbbbb8c9cc9cc9cc9cc9c99bbbbbe55555555555555555e555ebb6bbbbbb0006444444444444222222222d000000
777ff7f733333333000000000000000002cbbbbbb9c9cc9cc9cc9cc9cc99bbbbe44544544544544544e455ebbbbbbbbb00002442244222222222222d60000000
f7ffff7f333333330000000000000000bbbbbbbbb89a0aa0aa0a9a59cc55999bee4544544544544544e444eebbbbbbbb00006522222222222222d60000000000
f7ffff7f333333330000000000000000bbbbbbbbb890aa0aa0aa91199999995beeeeeeeeeeeeeeeeeeee44eeebbbbbbb000000d51111111dd660000000000000
f7fff7fff333333f0000000000000000bbbbbbbbb9999bbb99999119bbb999abe5eee555ee5ee5ee555ee4eeebbbbbbb00000000000000000000000000000000
ffffffffff3333ff0000000000000000bbbbbbbb55555bbb55599999bbb99555e05e5bbb5e05e0e5bbb5eeeeebbbbbbb00000000000000000000000000000000
fffffffffff33fff0000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbeee5bbb5eeeeee5bbb5eeebbbbbbbbb00000000000000000000000000000000
7777777777765000110100000000000015511111111111151677777777777777666d515dddddd5ddd1ddddd66666d66677777777777777d5555dd555d6777777
777777777777d555155110000000000055555111151111111067777777777777d666555d66ddd5d66dd6dddd66d6d66677777777777776dd6d11d55556777777
677777777776d6111115310000000000115555551111111111577777777777775d5d5555ddd55555555555d6666dd666777777777777776dd55555555dd77777
7777777777776761115551000000000055115555000000011056777777777777555555dd555511111111155ddd5ddd55777777777777776555dd5d115d677777
677777777776d55110055510100000005511550000000000111d6777777777775555555511551000111111d55555dd557777777777777765151515d157677777
6777777776d161d10000000100000000555110000000000011176667777777775d555555555511001000115d5555dd25777777777777777666666ddd66777777
d7776776ddd6ddd151111101000000006555000000000001515766677777777755d55555555510001001115ddddd6d257777777777777666666666ddddd555d7
d66ddd6d666755d15ddd0001000000007677600000000005515667777777777755555555555511011111115ddddd6d25776d6d555511111111110010000110d7
155500566d5dd5d5000000000dd5d000767660000000000150d6677777777777555555555555511111111155d6dd6d25dd5161111111111111000000000000d6
d156d55555511155500000011665d10076d5d00000000001106666677777777755555555255dd1111115111556dd6d5d1d11611111111111100010000015dd66
5555550511dd15115000000006766500d51551110000000111dd76677777777755555555255dd11111115155565d655d1d116dddddddd6d66666666d5d66d666
005005115d5155555111511015511500ddddd50000000105dd505dd67775dd5d555555552d555111111151555d55655d1d1d666776d66d66666676d11dd15d6d
7776f6dffd15ddd6450111115d000000dddd6dd11011100d6d111105d6655555555555222d511111111155555555dd1516666666666666666666d511111555dd
7777ff6ff77d5dd45550000000000000551516505000000d6d155d66651000115555551225515111111555555555dd151666d511d6666777667d1111011555dd
7777fffff777d511100000000000000055551501100005ddd515d5dd555ddddd1111101225515111111555555555d5001666d55dd7777777666111dd01555555
d66776f7666776551000000000000000511510001000000001555111510dd1111111110125511115111555551555d511566615d6166ddddddd11105500011151
6666666666666666666666666667666665d511101100111555111115555d51111111110025511151111555551555d51111110000000111111000000000001115
66666666666666666666666666666666d555111010011155511111011100010155555110155255211111555d5555d511d1111111111555555551111100111115
66666666666666666666666666666666d56d551100015511111111110011111155555111055d5522222255dd11555d55d5511111155515555551111111111115
66666666666ddddddd66666666666666d555111111111555511111000111111155511111101dddd222525d6611551111dd511155551155555551111111111115
666666666d0000000d655d6666666666777d001111111111111110001111111155551111101dddddddddddd601151115dd511555515155555551111111111111
666666666d0000001f6000005d66666676d51111011111101111000111111111555511111115dddddd5ddddd01111111dd551115555515555511111111111115
666666666df55dffff76dd1000056666115d66ddd5111111110000011111111155555111111155555555511111111111dd551555155555555511111111111111
766d66666deddd6d6f777777766d50015d666666d5000000000000011111111115555111111100000000555555555551d5555155151555551111111111111111
6dd554455d5000022677ffffd66655556666666666666666677666666666666666677677777766666666667676666666cccccccccccccccccccccccccccccccc
f4d42422256555ddf6777776000544446666666666666767776666666666666666677776666667766666667666666666cccccccccccccc66666ccccccccccccc
5454445445000015d5ddd666494d44446666666666677777776777766666666615dd6776d555d66dddd6666666666666ccccddcccccc6d5dd65dddd6cccccccc
9e49994994252025554446dd5dd59999666666666666777776677777666666761111166d5555dd555555d66666666666cdddd5dccc6d511d6755dd555dcccccc
99f999994400000000000dd500004499666666666fffff7776677766766666665111155555d5115111111555d66666666666656666d55156d65511d555dccccc
0000000000000000000000000000224456666ddd4d5525444eeffffff666666655555555555551155111155dd6dddddd66666d66d555d116f5555155555dcccc
0000000000000000000000000000000055d6d55551000000000125222444ee661115155dddd6776666666666666651116666666ddddd5116f5511155555dd66c
000000000000000000000000000000005555d55551000000000000000000000d1115677776666666666ddddddddd551166666ddddddd555df55d5555555d66f6
cccccccccccccccccccccccccccccccc55555555500000000000000000000005111dd66e511111111111111111111551666dddddddd55d556ddd5555551556f5
cccccccccccccccccccccccccccccccc555d5ddd100000000000000000000005111de6ed11111111111111111111115566dddddddd555d65676d555655555545
cccccccccccccccccccccccccccccccc5dfffff45524444444442222222225551115ddd50111111111111555555551556ddddd66dd445ddd676d5ddd55555515
ccccccccccccccccccccccccccccccccdfffff4444444444444444444444444411155551515ddddddddd6dddddddd5d56dd66666d45d5d5dd7ddddddddddd515
ccccccccccccccccccccccccccccccccd55ff4400000001111155555511111150011555151d6dd66666dddddddd5dddd66666666d4dd555dd6dd5dddddddd511
ccccccccccccccccccccccccccccccccd4fff4454444444444444444414444441155155111d6ddddddddddddddd5d6ddd444444444d42514fffdd5d5d5555551
cccccccccccccccccccccccccccccccc51100000044444444444444451544444ff6d5d5115d666d6ddd6d5511dd56f6655d4444444444554aaaaaffffaaaadd6
ccccccccccccccccccccccccccccccccd000005515444444444444441554444deff776dd66d1ddddddddd111155d555d655444444424444966faaaaaaaaadd5d
ccc8888cc8888888888888888888888cd1000051554444444444555115555555ff777766d611dddddddd5111111555556d5dddd444514449af6faaaaaaa666d1
cc8888cc88887777778877777788888c5100101515555555111001115555555566f777f6dd115d55551111555ddedeee515dddddd4154449aaaaaaaaaaaaf5dd
cccccccc88887777778877777788888cdd551100011555555dddddddddddddddffff666dd5111555ddddeeeeeedddddddd5100155515444aaaaaaaf6faaa4555
ccc888c88887788778877887778888cc555555dddddddddd66d6666dddddddddffffffffffffeeefffeeeeeddeddddd55555dd5100050549a9aaaaaaaaaa4555
cc888cc88887788778877887788888cc55ddddddddddddddd6ddddddddddddddfffffffffffffff6ff6666dddd55555555555ddd6d1500000111105555555555
ccccccc8888777777887777888888cccddddddddddddddd6d66666ddddddddddffffffffffffff666dddd55555551551ddd55d5dd5555511115555d66d55ddd5
cc888c88888777777887777788888cccddddddddddddddddddddddddddddddddffffffff6f6ddddddd5555555555555555555555555555ddd5dddddddd6666d5
cccccc88888778888887788778888ccc55ddddddddddddddddddddddddddddddff6edeeeedddddddddddd555555555555d55511155d5555ddd6dd55555ddd55d
cc888c8888778888887778877888ccccddddddddddddd422222222222244dddd877566665666656666566665665bbb5abbbbbbbb444444444444444444444abb
cccccc8888778888887777777888000c6666666666666666666feee666f6ff66887888888888888888888888880777bbbbbbbbbbaaaa555a55aa555aa00000ab
cc88c88888778888887777778880eee0666666666666666666666666666fff66b888cccc8cccc8cccc8cccc8cc0000ccbbbbbbbb6aaa555a5a5a555aa000000a
ccccc88880008888888800088880e000666ddd6666666666ffff666666666ff6b888cccc8cccc8cccc8cccc8cc00c00cbbbbbbbb6aaa5a5a5a5a5a5aaaaaaa9a
cc88c88800500888888005008880eee066d055dd66666fffffff6666f666ffffbb88888888888880088888888880c00c444bbbbbaa93ca4839c848aca389c4a5
cccccccc05550cccccc05550ccc0e00066d0005dd666fffffff666666666ffffbb777788888877088088888888808080b4444bbb8ac4839c4839ca49c00000a5
cccccccc00500cccccc00500ccc0eee066610001555dddd6666666666666fff6bb8008bbbbbb88088088bbbbbb80c08abb44444baa8bbbbb0ca483ca80bbb00a
ccccccccc000cccccccc000ccccc000c666d450001011111155dddd666666ff6b55888bbbbbb88055088bbbbbb80088bbbb444446aabbbbb0000000430bbb00a
cccccccccccccccccccccccccccccccc666ff99994d552100001111115dd6666666000000660066000000000bbbbbbbbccccccccccccccccccccccccccccc878
cccccccccccccccccccccccccccccccc666f99999e55dd9dedd444451005d666666000060660066000000000bbbbbbb877777666776667777766676667777c60
cccccccccccccccccccccccccccccccc666a99999f1dd16d511de99941156666066000660000000000000000bbbbbbb888888666776667676766676667676766
cccccccccccccccccccccccccccccccc666999999f5661dd606dd9994015ff66066600660660066000000000bbbbbbb899d77666776667676766676667676766
cccccccccccccccccccccccccccccccc66699999945660d5606dd9999999fff6006606600660066000000000bbbbbb5555d8888888cccccccccccccccccccccc
cccccccccccccccccccccccccccccccc666999999dd66d65616de99999999af6006666600660066000000000bbbbbb8b77d77777777777575777777777575777
cccccccccccccccccccccccccccccccc666999999499999f6d6d999999999af6006666000660066000000000bbbbbb8b88888885bbb88757577775bbb75757da
cccccccccccccccccccccccccccccccc6669994a9d44999999999994949999a6000666000660066000000000bbbbb8bb77777775bbb77777777775bbb7777700
00000000000000000000000000000000666945df44244fd559444d4d244499f600000000000000000000000000000000bbbbbbbbbbbbbbbbbbb5555555bbbbbb
00000000000000000000000000000000666945d4444dd4dada445d55000099af00000000000000000000000000000000bbbbbbbbbbbbbbbbbb555555555bbbbb
0000000000000000000000000000000066644d55dd05542f4224d5d2155149af00000000000000000000000000000000bbbbbbbbbbbbbbbbbb555555555bbbbb
00000000000000000000000000000000666ddd5d5d1dd225424544d555d559af00000000000000000000000000000000bbbbbbbbbbbbbbbbbb555555555bbbbb
000000000000000000000000000000006666251dd51555dd455d4555ddd5d46600000000000000000000000000000000bbbbbbbb0000bbbbbb555555555bbbbb
00000000000000000000000000000000666652555555d1111115fd555dddd66600000000000000000000000000000000bbbbbbb022220bbbbb055555555bbbbb
0000000000000000000000000000000066666d2255ddddddddddddd55555666600000000000000000000000000000000bbbbbbb022220bbbbbb0555eeeebbbbb
000000000000000000000000000000006666ddddd5555ddddddd55dd55d6d66600000000000000000000000000000000bbbbbbb022220bbbbbb8eeeeee5555bb
0000000000000000000000000000000067777fff77777777f77fffff7777777700000000000000000000000000000000bbbbb00088880bbbb050ee55555555bb
133cccc66666666777777777777777766777777f77777777ff77fffff777777700000000000000000000000000000000bbbb056088880bbbb0555555555555bb
3ccccccc666cccc66677777777777776677777777fffeefedee777fff777777700000000000000000000000000000000b00b0602222220bbbb055555555555bb
ccccccccccccccc66cc777777777776d677777ff6dd444444e2677ff7777777700000000000000000000000000000000056000000000000bbbb0555555555bbb
6cccc66666ccccccc66676667777666d67777fe444442522dd41677f7777777f000000000000000000000000000000000656404444444440bb00066666660bb0
cccccc6666666ccc6d666d66d6d66666677776d4eeeeeeeed44126777777777f000000000000000000000000000000000666404404440440bb000055555505b0
cccc6667777776ddd5555331ddd66666677766ef6dee4deeee222577f7777fff000000000000000000000000000000000666404000400040b00000066660660b
66666666666666dd6d5ddddddddddddd4f77d6eeeeeeeeeeee4222d77f777ff700000000000000000000000000000000b066404404440440b00000066660660b
666666666d6777d7765ddd6ddd6d5555244fd6fff6edeeeeeed2222677f7777700000000000000000000000000000000bb06404444444440b00000b666777700
6667776ccc6666dc665dd5ddddd5555124444eff66edeeeedd2222226777777700000000000000000000000000000000bb00404444044440b00000b666777770
7777667666edeeeeee5d55511111555524444de66eddeddddd2212244f77777f00000000000000000000000000000000bb04400404440400b000000666677777
5d6666e488eee88884ee55111111155524444deeededdeeddd22224444f7777400000000000000000000000000000000bb04404024424040b000000666666707
1544eedddd5eee8884eee4225222255524444ddedeeee5dddd422244444777f400000000000000000000000000000000bbb000022222200bbb0000555555555b
555ee550551dee451548820000015dd524444dddddf66dd66e222244444f77e400000000000000000000000000000000bbbbb0442002440bbb0006666666666b
555225d1dd11e8422245d55111115d5524444f66ddd6ddd65d122444444e7f4400000000000000000000000000000000bbbbb0440bb0440bbbb05555555555bb
d55225555d5188488848dd1115d1155524444dddd5dd5dd6de22224444ee7e4400000000000000000000000000000000bbbbbb00bbbb00bbbbb5555555555bbb
d5501d555d5148888445d61155dd5dd524444fff6d55d66eee22214444ee7e440000000000000000000000000000000000000000000000000000000000000000
66d55dd5dd41002dd44111115dd6667624444e6f6ddd66eddd22204444ee7f440000000000000000000000000000000000000000000000000000000000000000
66666d51dd511001d55100566667777724444ddf6edffeedee222044444e7e440000000000000000000000000000000000000000000000000000000000000000
d666666d550011111111115d666666660444444d444d425222022144444474440000000000000000000000000000000000000000000000000000000000000000
d666666666ddddddddd55555d55dddd6044422222444442222122124444474440000000000000000000000000000000000000000000000000000000000000000
d666666667666dd66ddddddddd55555514444dd42544455d662210e6d44f7e4d0000000000000000000000000000000000000000000000000000000000000000
dd666666666766666766666666ddd551dd246dd514ef666ff65515ffe4dffe460000000000000000000000000000000000000000000000000000000000000000
ddd6d6666666666766666766666dd5dd555552552522222222222222222555520000000000000000000000000000000000000000000000000000000000000000
__label__
aaaaaaaaaaaaaaaa8888888888888828888888846759999994676dd6666ffffd5552444444444444444444444444444444444444444444444444444444444444
aaaaaaaaaaaaaaa888888888888882488888888277499999994677777777777777d4444444444444444444444444444444444444444444444444444444444444
aaaaaaaaaaaaaaa88888888888882888888888857699999999945444444444567624444444444444444444444444444444444444444444444444444444444444
aaaaaaaaaaaaaa888888888888828888888884567d99999999999999999999d76244444444444444444444444444444444444444444444444444444444444444
aaaaaaaaaaaaa888888888888828888888445677649999999999999999999d765444444444444444444444444444444444444444444444444444444444444444
aaaaaaaaaaaaa88880000000000888880000000099990000000000999999d0000000004444000000000044444440000000000000000440000000000444444444
aaaaaaaaaaaa88880000000000000040000000000990000000000009999400000000000040000000000000004400000000000000000000000000000044444444
aaaaaaaaaaa888880077777777000000077777700000077777777000990000777777700000077777777000000400777777007777770000777777770004444444
aaaaaaaaaa8888880077777777777000077777700000777777777700000007777777777000077777777777700000777777007777770007777777777000444444
aaaaaaaaaa8888800077777777777700077777700077777777777770000777777777777000077777777777700007777777077777770077777777777700444444
aaaaaaaaa88888800777777777777700777777700077777777777770000777777777777700777777777777770007777770077777700777777777777700444444
aaaaaaaa888888800777777077777700777777000777777007777770007777770077777700777777007777770007777770077777700777777077777700444444
aaaaaaaa888888800777777007777700777777000777777007777770007777770077777700777777007777770007777770077777707777770077777700444444
aaaaaaa8888888800777777007777700777777000777777007777770007777770077777700777777007777770007777770077777707777770077777700444448
aaaaaa88888888000777777007777700777777007777777007777770077777770777777700777777007777700077777770777777707777770000000000444488
aaaaaa88888888007777777077777707777777007777770007777770077777700777777007777777077777700077777700777777007777777000000004448888
aaaaa888888888007777770077777007777770007777770077777770077777700777777007777770777777700077777700777777007777777700004444488888
aaaa8888888888007777777777777007777770007777770077777700077777700777777007777777777777000077777700777777007777777777000444888888
aaaa8888888888007777777777777007777770007777770000000000077777700777777007777777777700000077777700777777000777777777700048888888
aaa88888888880007777777777770007777770077777770000000000777777707777777007777777777777000777777707777777000077777777770088888888
aaa88888888880077777777777700077777770077777700000000000777777007777770077777777777777000777777007777770000007777777770088888888
aa888848888820077777700000000077777700077777700777777700777777007777770077777700777777000777777007777770000000077777770088888888
a8888856688240077777700000000077777700077777700777777000777777007777770077777700777777000777777007777770077777007777770088888888
a8888446666580077777700999990077777700077777700777777000777777007777770077777700777777000777777007777770777777007777770088888888
888882866d6600077777700999400077777700777777700777777007777777077777770077777700777777007777777077777770777777007777770088888888
8888488d699400777777000999a00777777700777777000777777007777770077777700777777707777777007777770077777700777777007777770088888888
8888488d69990077777700994aa00777777000777777007777770007777770077777700777777007777770007777770077777700777777007777770088888888
888ee8846a99007777770094aaa00777777000777777777777770007777777777777700777777777777770007777777777777700777777777777700088888888
888ff8847d9900777777004aaaa00777777000777777777777700007777777777777000777777777777770007777777777777000777777777777700888888888
88eee8846d900077777700aaaa000777777000077777777777000000777777777770000777777777777700000777777777770000077777777777000888888888
8848884664900777777000aaaa007777777000007777777770008800077777777700007777777777777000400077777777700040007777777700008888888888
88888466999000000000066aaa000000000007000000000000088880000000000000000000000000000004440000000000000444000000000000088888888888
84884669999900000000946daaa00000000077700000000000888888000000000000000000000000000040000000000000000440000000000000000000088888
4884669999999999999999466aaaaaaaa67776488882225d888888888444440eeeeeeee00ee04440e04400eeeee08400eeee0080eeeeee0080eeeeeeee088888
48466d99999999999999999d66aaaaa6677658888224425d588888888448440e000000000ee04440e0400e000ee0400e000ee080e0000ee080e0000000088888
84d66676666d999994666676665aaa677652888222444549588888888466640e044444440ee00440e000e004000000e00400e080e08800e080e0888888888888
84999444dd669999a666666666aaf677d2888222242255994576dd666777600e064444400e0e0400e00e004444400e004440e000e08880e000e0888888888888
4999999999f66999d67777776aa6776588222422d555499766667777777770e000000040e00e000e00e004444440e0044480e00e008000e00e00000008888888
499999999aa6699966777776af677d2882244449d5f9976d67777666777770eeeeeee060e000e00e00e044444440e0448880e00e0000ee000eeeeeee08888888
999999999aaa66a6667777da67765882242499944476d67776d51111577750e000000070e060e00e00e044444440e0488800e00eeeee00080e00000008888888
99999999aaaaf6d667776fa677d28222249994477666776d11111111167750e055511110e060e00e00e044440000e088800e000e000e00880e08888888888888
9999999aaaaaa6766776aa6765882244999447666776d11115dd666d5d7700e07776d500e0100ee000e006700e00e00800e0000e0800e0000e08888888888888
999999aaaaaaaf766d6af67628222449947666676d111115666666666d6d0e000000000e00d50ee0d0ee0000e000ee000e0080e008800e00e000000008888888
999999aaaaaaaadd46d677d88222499476d676650115511d6666666666100eeeeeeee00e066600e0500eeeee00600eeee00880e088880e00eeeeeeee08888888
99999aaaaaaaaa54466664822244976d6776d1115d665116666666666d0000000000000006666000660000000776000000888000888800000000000008888888
9999aaaaaaaaad48d6f66215d666d6776d1111d666661116666666666d0000676677776666666666666666d1156776d678888888888888888888888888888888
9999aaaaaaaad488d6996666766676d5111dd666666d1156666666666d0000d66667777666666666666666666d11d67668888888888888888888888888888888
999aaaaaaaa648846f999966677651115d666666666d11d666666666660161d6666667766666666666666666666d51d6d7888888888888888888888888888888
99aaaaaaaa64884669966d676d1115d666666666666511d666666666666671d66d777666666666666666666666666651dd788888888888888888888888888888
99aaaaaaa648466f96d676d1115d666666666666666511666666666d516775566577777666666666666666666666666651688888888888888888888888888888
9aaaaaaa644d6d6d676d5111d66666666666666666611166666dd500006775566d77777666666666666666666666666666d78888888888888888888888888888
9aaaaaa6d49966676d115d66666666666666666666611566dd10000111d77d166577777666666666666666666666666666d68777777776677777888888888888
aaaaaa6d46d676d115d66666666666666666666666d111100000111111577d166d777776666666666666666666666666666d7766d5d666666d66788888888888
aaaaafdd676d1115d6666666666666666666666666d1100011111100011776166d777776666666666666666666666666666d5100006777777776d78888888888
aaaad666d511d66666666666666666666666666666d1111111100011111776166d77777666666666666666666666666666660000006777777767767888888888
aa6666d115d6666666666666666666666666666666d11110001111111116761d6d7777766666666666666666666666666666500000677777766777d788888888
666d115d6666666000666666666666666660006666511101111115dd5116771d6d7777766666666666666666666666666666d00000d6666ddd67776688888888
d115d66666666600a006d66666666666660080066651111115dd6666d11d771d6d6777766666666666666666666666666666655d667777777766777678888888
5d6666666666660aaa06666666666666660888066611111d66666666d11d771d6dd6777666666666666666666666666666666667788888888876d66667888888
6666666666666600a006666666666666660080066611111666666666d11d775d66ddddd6666666666666666666666666666666d78888888888876067d7888888
66666666666666600066666666666666666000666611111666666666611577d566666666666666666666666666666666666666d688888888888860d767888888
66d66666666666666666666666666666666666666611111666666666611177d5666666666666666666666666666666666666666d78888888888870d766788888
6666660006666666666666666666666666666666661111166666666665116761666666666666666666666666666666666666666d788888888888751776788888
6666600800666666666d66666666666666666666661111166666666665116761666666666666666666666666666666666666666d6888888888887d0776788888
66666088806666666666666666666666666666666611111666666666651167616666666666666666666666666666666666666666d7888888888886067d788888
66666008006666666666666666666666666666666d111156666666666d11d761d666666666666666666666666666666666666666d78888888888860d76788888
66666600066666666666666666666666666666666d111156666666666d11d771d66666666666666666666666666666666666666666888888888887056d688888
6d666666666666666666666666666666666666666d111156666666666d11d775d6666666666666666666666666666666666666666d788888888887500d788888
66666666660006666666666666666666666666666d111156666666666d11577d56666666666666666666666666666666666666666d78888888888876d7888888
666000666008006666d66666666666666666677776111156666666666611577656666666666666666666666666666666666666666d7788888888888888888888
6600a0066088806666d6666666666666777777777611115666666666661117765666666666666666666666666666666666666666666788888888888888888888
660aaa066008006666666666de48888e77777777761111566666666666111776166666666666666666666666666666666666666666d788888888888888888888
6600a00666000666666dee8e888888888e777777761111566666666666511676166666666666666666666666666666666666666666d778888888888888888888
d6600066666666666e8888f77e000888888e7777761111566666666666511677166666666666666666666666666666666666666666d678888888888888888888
66666666666e999f77fe8ff9e00a008888888e77761111d66666666666d116771d66666666666666666666666666666666666666666678888888888888888888
66666649999999999f77ff9990aaa0888888888f761111d66666666666d116771d66666666666666666666666666666666666666666d78888888888888888888
de4900099999999999f77e99900a0088888888888d1111d66666666666d11d77dd66666666666666666666666666666666666666666d78888888888888888888
99900800999999999999f9999000008888888888821111d66666666666d11d776566666666666666666666666666666666666666666d78888888888888888888
99908880999999fffff9f9999088808888888888841111d66666666666d115776166666666666666666666666666666666666666666d67888888888888888888
449008009ffffffff9f9f9999008008888888888821111d66666666666d115776166666666666666666666665555ddddddd66666666667888888888888888888
999f0009ffffff99f9f9f9489900088888888888841111d66666666666d11177716666666666666ddddd6dd666dddd510015ddd66666d7888888888888888888
7ffff9ffff000f99fff9f98999f77f8888888888841111d66666666666611177755dddd6666666dddddddddd55dddd6d6dd51555d666d7888888888888888888
f79ffffff00a00ffff99f94999ff77fe88888888841111d666666666666111777d111111111d666ddddddd6666dddddd5d6666ddd666d7448888888888888888
fffff9ff90aaa0ffff99f9899ef99f77e8888888881111d6666666666661117776111111115dd511111111115ddddd666666666d5d66d6744488888888888888
ff999999f00a00ffff99fe999f9999f77e888888881111d6666666666661116777651111111111100000011111111111111555dd5056d6744444488888888888
9999999fff000999999997e9ff99999f77f88888884111d6666666666661116777776666dd5511156666d5551100000011111111110166744444444488888888
999999999999999999999f7779999999ff7f4888888211d66666666666611167777777667777766d77777777776666666d51000000100d744444444444888888
8899999999999999999999fe9999999999f7f888888811d66666666666611167777777776777777767777777777777777777777666111d744444444444448888
88849999999999999994999999999999999f77e8888412566666666666611167777777777776777777777777777777777777777777d5dd788444444444444448
948889999999994999999999999999999999f774488418216666666666611167777777777777776666777777777777777777777777777d744444444444444444
9988884999999949999999999999999999999fe9988418821d666666666111677777777777777777767777766667667777777777777776744444444444444444
999888889999994999999999999999999999999efe84188821d666666661118f777777ef7ff7ff77777777777777777777776776766666744444444444444488
999888888999994999999999999999999999999f77e81888821d666666611188e7777ffeeffeeef7776777777777777777777777777776744444444444444488
9988888889999949499999999999999999999999f76e18888821d666666111888e777fffeffefff7776777777777777777777777777776744444444444444448
988888888899999999999999999999999999999def761888888811d66661118888e7777777777777777777777777777777777777777676744444444444444444
8888888888999999999999999999999999999996f9f61e888888821d66611188888e777777777777777777777777777777777777777776744444444444444444
888884888499999999994200449949999999999df99f17e8888888851d611188888e666777667777777677777777777777777777777776744444444444444444
8888824889999999999400000049999999999999999917788888888821111188888f776766777776667676666666666666666666667676744444444444444444
88888249999999999940000000049999999999999999177f8888888888211188888e7f67676766777666665555555dddddddddddd6666d744444444444444444
888899999999999994000000000099999999999999991f77e882118888882188888867776677667777fe4d00000000055d00000001d66d744444444444444444
9999999999999999950000000000499999999999999919f77e8151888888218888888f677777667776784d000000000dd000000005e666744444444444444444
99999999999999999000000000000999999999999999199f774111888888218888888888eeffff66667e8d00000000ddd000000005e67d744444444444444444
99999999999999994000000000000499999999999999199977f4888888882188888888888888888844e8ed50000005d5500000000dee44744444444444444444
99999999999999994000001d6d0001999999999999991999f77e888888881188888888888888888888888e66ddddddddddddddd66ee884744444444444444444
9999999999999994500000d6766000999999999999991999977788888888118888888888888888eee888888884eeeeeeee48888888ee8d744444444444444444
499999999999999400000666616d009949999999999919999f77e88888881188888888888888888888eeee88888eeeeeeeeeeeeeeee88d744444444444444444
8899999999999994000006676676004999999999999919999977788888881188888888888888888888888e88888888888888888888888d744444444444444444
88499999999999440000567767771049999999999999199999f77e888888118888888ee8eee8888888888888eeeeeeeeeeeeeeeee888ed744444444444444444
8844999999999944000067777777d0199999999999991999999777888888118888888888888848e888888e8e8888888888888888888846744444444444444444
88888999999999440000d777776d60099999999999991999999f77e888881188888888888886628e88888e8e88888888888888888e8f46744444444444444444
88888899999999440000577777dd60099999999999991999999f77f8888811888888888888e7728e8888888e88888888888888888e8f267a4444444444444444
888888899999994400006777776dd0099999999999992999999f77f888881188888888888847628e888888ee88888888888888888e84277aaa44444444444444
88888889999999440000d677777750099999999999992999999f7778888811888888888888884884888888eeeeeeeee88eeeeeeeeee846aaaaaa444444444444
444449999999999400001677677700099999999999995999999f777888881288888888e8ee8888888eeeeee8888888eeeee8eeee888847aaaaaaaa4444444444
0000001ddd4449940000066766760009999999999999599990007778888812888888ee8888ee88ee88eeeeeeeeeee888888888888888d7aaaaaaaaaa44444444
dddd66677777766650000dd6616d00099999999999992999008007788884128888888888888888888888888888888888888844244ed66aaaaaaaaaaaa4444444
7777778aaa887777500000d676600004449999999999549908880778888212888888888888888884888884222000000005667aaaa7777aaaaaaaaaaaaa444444
88888888aaa8888750000005d500000000066666dd5454440080077888821288488842222211000000000000000015d6677aaaaaaaaaaaaaaaaaaaaaaaa44444
8a8888888aaa8777777600000000000000077777777777666000666d422100000000000011155dddd666666666777777aaaaaaaaaaaaaaaaaaaaaaaaaaaa4444
8aa8888a88aaaa77788750000000000000007888888888888aaaaaaa77d000000000d7777777777777777444444444444aaaaaaaaaaaaaaaaaaaaaaaaaaa4444
8aaaaaa7777aaaa8888765000000000000a0088888888888888aaaaaaa7651155d667aaaaaaaaaaa4444444444444444444aaaaaaaaaaaaaaaaaaaaaaaaa4444
7aaaaaa77777aaaa88887650000000000aaa08888888888888888aaaaaaa77777777aaaaaaaaaaaa4444444444444444444444aaaaaaaaaaaaaaaaaaaaaa4444
aaaaaaa7778888aaa8888776d555dd6600a0088888888888888888888aaaaaaaaaaaaaaaaaaaaaaa444444444444444444444444aaaaaaaaaaaaaaaaaaaa4444
aaaaaaa88888888aaaa88877777777777000888888888888888888888888aaaaaaaaaaaaaaaaaaa44888444444444444444444444444aaaaaaaaaaaaaaa44444
aaaaaaaa88888888aaaaaa88888888777888888888888888888888888888888aaaaaaaaaaaaaaa84488844444444444444444444444444aaaaaaaaaaaa444444
8aaaaaaa888888888aaaaaaaaaaaa87778888888888888888888888888888888888aaaaaaaaaa88444484444444444444444444444444444aaaaaaaaa4444444
88aaa88888888888888aaaaaaaaaaa778888888888888888888888888888888888888aaaaaaa88844444444444444444444444444444444444aaaaaa44444444
88aa888888888888888888aaaaaaa778888888888888888888888888888888888888888888888888444444444444444444444444444444444444444444444444

__map__
fffffff0ffff0f7ddbae3e9c525ac92023d89286640a1c488809090447041f20e30b613684f1b3cc24014b33d1a00241027e2124b22533208c094913044110cc648b870ef84326b28c2764284324a481da4c3a202c54480a0644c295a5d1f0070b922433024822648ecd984d974c6200214412d92163ec00edc4ec3209f28b4c
b2250f54122c2181521292110a60a1854308162a095ff88587d98b67dbb297a4cd4246128043d209780118c544c3b10da43ed00925639184822622321df2101184c5620e920483d88e24440c0117b13fc291f03447b6cbd80e1677e261581201bb050809ae4524cf402ab6ba23d726910c57103c1827381103c221834d0c610f
c1718091245712485858535ec823578f24c700e2038664444346024424c94482203041b848831c21a5ecccf2d993c40489fec1f3900cd4c8436d2621924042b64484cf9481258908279192648dfd9f26b38d321e596462b26d22ad7089d462c781e44b188bc59af8ff65613ba20b4a062009bc086c7224ae6cec4050e67f294b
1623586502a491ed9ac0d72561ff078b9dc3237f26c131401647022c5c5f24c7b6e308fc0479f92b805486f0652d63668bf28790a8b043cc2f84f2e705082911ca0fad381a008935d3c066e9dac91c72658b90d8ff2242404ec6d55898544e02234ba4594d3a91634936c564f634f81f2c8bc84f328e6420041684502644a3cc
4c11397821ff0711f0930078c82411470059389278966ee924fff1ff3093fc9ac005b1b0446084e80eb49607fc7f23f82db1005c3249b3104192c0654796484848d2ccff51f01b07639c898935b224e9606b975596caff12fcc6c91887e5b0214968ec22e17f3bf1a3fc0184eb333422956b160dfea792c4ff8781c712722449
ede80248f9bf863fe55ff04826ddd29a962cf2ffe57f09c2a7c5401afeff56f889d4e44832f3d0a2c1ff17fc6f094166eb32fdff4fe1ff22d912d98492c8ffb8f01bffa723b2260047e27fcc7ffcbf9a8a0c9144f81f0ff88dff07cfb7293393f93f677e0bff0f8b1de826f8ff07447ee2ffc01104475222ff7f395c6cb4c332
ff63fe14fc392111b98c648390f03f0eff3f02c19b55db904425feafa2f0177f669118f7894a92ff77e2b704c36f47840c77104612ff6b7ed2437ee3903ff63c140bff6313841b3cf24f98fc65eb2596e45faaa8fc4102223f40b2710b91207f9138c278c0cd10c811fe09e19f50ee8505e11f78209890f9e4e34e2dfcf04892
c4f10795cac8b66d99bf440e4212b133c9c14b2091246e24fb494e9e1132f98f2c08958b6489bc567eb4bff82191e3084926499e709145581739b345fe4f89ffc19148e4194f9bb22491079a49feff01ff832670488e64223db644e430f2c73ae48fc41bfeb3bfec3319084df3c8910981464ee892dcb20780e17f248fdab01c
3efe0a9079296fc80806fee33f1a24c667bf254178430a0912ffa3e1cfc3cc205f42e67f42e591472ebbb8e488fc29199679881d9dc953a9b0dfa8dc71143c49aa9123fa138b481c39726a9348ed68329fb0c391e8386572eae4b06f4df0478295435ebb49926822b2e10992466632911f96edaf996cfc61e192250e1a0edd30
4b674b221639e5e1ff30cb00becd162e894d0e242c89c49927d6b12c268b3ce0e138c05f9d38ecdb6cdb7c912b8b498c89c0158148485510bec40f01bf49f821f170f3217c00494aa069ba045ef983049145be03fc20ff6dcd2121111109419245968c3c4c0e96b8b16d69b67d127e4ad15839b648968de4103c49ba36912406
913822e1073be40d7f644a634d3c962c8389380296048fe5c8b2a4d762cc7e49f2b0c4930947eab86241921c522b24d54548c60c96cc694f3bb68c4a1c1c7ac14e1e49923f969148e29544228c31d444642b3286843cdb9a9447aed86f12f9c540fe0409c22938081616886d127ed94ae2098f0857612c9152e7623fa480532e
2b218c7f0ea2177f89706989e0ef1c34e2902710cbb091243f64fb21f1d8d334ce240b9b11048164e22359121c13127c0449be44960d00845f228f3c31890a5032180c9038384203521238646143828838829dcf049f5cc20ef90857105650487868254a6059128389918986117086ff0f09b813f8854080312cac4b48526b58
e293ff1143e1035d16682648928b03590231dce1e623fc09c16f541ede44c545862563f45d968b0c2f4ff88766fe23899357c6121292dc493f021e31c983cc6f0c24dc904c9c0b1bf08054922f7c1359c0162ef08fe0e1972432e192572268136049c8c1d910b12cc34e4e79489623241c52c124201c83412d34c4c206fcc4a1
12e10d3f481386f1b0e1a18e8b481026232c08bff057e248dc11725c00e1e262499634489284047688ceb601b8231237499806875ef2495421fc5089f2500b25ecc9aa49e49c011e9649031c1c40962ffc274b8e80d82f3409c998c82d493472b00470870a7e145a1e2161624446064fb08d8ad5882c8a6da462acd2702c8064
e69c69862492c4baf10003c8c50c493471b10301407080532658843ccdac84cc8676ed32c5187d244080750542283812113c0c07c7a13d36cf52279f3c49c893b23239389f58c49261219095c824f004b1b12b955079723d8fa31e8ea691e673d4f148525f0a216c78c27114d441037b21af5d1c5a909830aa99240574443665
3938212b0172d4d37c9e7fe44d6293656344b740d34e220f951822ff2c1c1bcb51c27eb0c97fe492cd2a89b0744fb63fa8486cc2120f1b726075649a44c9a9077f2d61ad2c8b1c11ee067828e9b6c01cc6630f994516c7c421972b3b2c49f947f21d659aac89b51967668583198b60126afb2b2224e23a8e341c490509e921f3
87387a2c85f4d8929a6ca90b91c80f82040109e0d8a52c240f93389f2349a43b22f379d358b3a4481721c9905b6dc90f32fb410f384c8e78aa211a225b0e345b7d2282981858263c5b6dc9e135dbe4404c0e0b0724c2822387e6309a2467873f02d95a9224913421d0e88e6d355ef992450efdb9699c59d07c798e65954e4a72
c486e4882497fc6f92907f55e26e43f5204220e0964d9c59fe1f4782ffd2e28f5c91ec8883d5eeac898c2cf13649cef013861f23ffc8cb1f8a11a9546207b56439e4af2393e027fd4bc76b85ee0d5d9625593dba2c3cb36569d7e44f54967fd63a8d4d8e6d9a4e6aa57690b061693289a557cde13b9e499623cf753c3f96795c
383c4b7201cb1538b61d91c8713c24460248a2966688588e9dcf1768fae037ce66cc8885b3cbd24b25914a422293c8981c30e75157d88e58b2e8ae8ca3494ff0f6d026c991e40b6db22a6992b165c9a294825e8f1c2d922376440e7d76ed18599af432763a449e1c2dff58c4b674592049964a4cd66f323d8e4e1a3b8ec7b25c
cf773ed3a3c7512ab59425c10cf33deb95bbe9927952f06c47d44ce64b9e63cdd8b17027a9486a444a431efdc57ef8d264f8239209e1e5993df2a42a3be258ca7aad4d23a7c78e1e131d9f842d9f37c72147754724a699d0608c5c422dfb2ed7918ac47e4d7245447ee18745e1e98e04c932ac738946b3f34ae50fc73f8ed7f1
b2f0438fabbb679992d9c211b3ee21f18806c45007fd7fd82ff6c5c1a917fbe34a228a664c0eeb5359b2818420475921b74dff6762e9c1f107d695c4e6d0f54824e1023989c699bf6c51fc7fb2a6a47f4c4ba2ed755c1f262141008e4a0eb11f57fe152471f1df41552ac205a08c102e25f83179c8af9bccc2ff802d51160e02
b070885c19ff24f0871db22492ab9e7f6d910d4b2c2c8c6f6116bee1e327393c4b48d4f193d01c9f1e5433500b09078f3cd24472a087fc9001f097e74f08234438c40008bf7048cbb3ca2b17affc12fe2189206085f448149c0be1481c865ff88f380ed9243784454638c0da8523706440241a1202701480df48430e39396600
fc17de42120a898415c135248c23240c440c2b64100c00def0938c3e01a50740189ac41209bd004b2ce06424fc8f38452108108c84c3087e99e4e05ff06338469ad9021204c1808323315eb6caff2419841000c11099906d200143c03164f84dc2f87f249228423845e14b6428c1309000000000000000000000000000000000
__sfx__
011000000943600500005000050000502005020050200502005020050200502005020050200502005020050200502005020050200502005020050200502005020050200502005020050200502005020050200000
011001012553000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011001013d33000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0110000038300383003830038326383003830038300383000e0030e00000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300
01180000003100131002310033100431005310063100731008310093100a3100b3100c3100d3100e3100f310103101131012310133101431015310163101731018310193101a3101b3101c3101d3101e3101f310
01180000203102131022310233102431025310263102731028310293102a3102b3102c3102d3102e3102f310303103131032310333103431035310363103731038310393103a3103b3103c3103d3103e3103f310
011000010941700500005000050000502005020050200502005020050200502005020050200502005020050200502005020050200502005020050200502005020050200502005020050200000000000000000000
010c01012553000000255300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c01013d330000003d3300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011001010c05100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01300000003100131002310033100431005310063100731008310093100a3100b3100c3100d3100e3100f310103101131012310133101431015310163101731018310193101a3101b3101c3101d3101e3101f310
01300000203102131022310233102431025310263102731028310293102a3102b3102c3102d3102e3102f310303103131032310333103431035310363103731038310393103a3103b3103c3103d3103e3103f310
010200002c0002c0002c0002d0002d0002e0002e0002e0002432026351293412b3312f3213031100000000001a3201d3511f3412133124321263110c0000c000000002c3002c3002c3002c3002c3002c3002c300
011900000e5501555013550185501655015550115501355015550005000e5500d5500e550105500e5501055015552115521355015550005000e5501555013550185501a5521d5521c55018550155500000018550
0119000016550185501a550185501a5501c5501d5501d5501c5501a55018552000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000000000000000000000024550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011e00002255100501225010050100501005010050100501005010050100501005010050100501005010050100501005010050100501005010050100501005010050100501005010050100501005010050100001
011001010c55700507005070050700507005070050700507005070050700507005070050700507005070050700507005070050700507005070050700507005070050700507005070050700507005070050700507
__music__
04 07084344
01 0d424340
02 0e424340
00 41424340
00 41424346
00 41424346
00 41424344
00 47484344

