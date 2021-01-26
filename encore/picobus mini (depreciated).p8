pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- picobus mini (encore 64x64)
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

-- 64x64 version based on my
-- picobus encore project

-- version information
codename, version, debug = "mini", "2.1b", false

-- default bus selection
defbus = 1

function _init()
	-- set up 64x64 screen
	init_tprint()
	poke(0x5f2c,3)
	clip(0, 0, 64, 64)

	if debug then
		debug_enabled()
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
	score, pos, wanim, instcount = 0, 0, 0, 3

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
--		flavor2="mercedes benz chassis",
--		flavor3="first bus added to crazybus",
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
--		flavor2="the original crazybus",
--		flavor3="in version 1.1",
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
--		flavor2="variable configurations",
--		flavor3="weak ford or chevy engine",
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
--		flavor2="best chassis (volvo)",
--		flavor3="",
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
--		flavor2="has a custom chassis",
--		flavor3="had 340 horsepower in cb v1.1",
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
--		flavor2="uses a volvo chassis",
--		flavor3="",
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
--		flavor2="to explain what this is?",
--		flavor3="",
		motorhp="n/a",
		passangers="n/a",
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

	loge={
		brand="hfad",
		name="loge",
		origin="hiipaspooker",
		height=">small",
		flavor1="a log with a doge face",
		motorhp="n/a",
		passangers="n/a",
		rndcolor=false,
		-- replace with a global
		flipped=false,
		id=8,
		psprite=28
		}

	-- impostor loge was here
	im_loge={
		brand="kfc bosnia",
		name="impostor loge",
		origin="bosnia",
		height=">small",
		flavor1="the scoundrel himself!",
--		flavor2="he's here to put you in debt!",
		motorhp="n/a",
		passangers="n/a",
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
		origin="hypercord",
		height="4.20m (sd)",
		flavor1="approaching sound barrier!",
--		flavor2="happy 3rd anniversary to",
--		flavor3="protocord and hypercord!",
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
--		flavor2="is a glacier bus.",
--		flavor3="",
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


	-- bus info by id.
	busbyid = {
		century395,
		visstabuss,
		schoolbus,
		jumbuss,
		ent6000,
		pgv1150,
		pico8,
		loge,
		im_loge,
		mnmbus,
		dt40l,
		sleipnir
		}

	-- for music timing
	mus_update = 1

	--logo_splash()
	pico8_intro()

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
	for i=0, 16 do
		cls"0"
		sspr(pico8.sx, pico8.sy, pico8.sw, pico8.sh, i, 48/2, pico8.sw, pico8.sh)
		sleep"0.06"
		sfx(0,2)
	end

	for i=6, 7 do
		sleep"0.2"
		pal(7,i)
		sspr(pico8.sx, pico8.sy, pico8.sw, pico8.sh, 16,48/2, pico8.sw, pico8.sh)
	end
	pal()
	sspr(8, 0, 8, 8, pico8.sw+15,22, 8, 8)

	-- move this to pattern 0 and 1
	-- i want to make better use of
	-- the mostly unused music memory
	music"0"

	sleep"1"
end

function logo_splash()
	--cls"6"

end

function credits_splash()

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
	local str = tostr(str)

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

function tprint_center(str)
	-- this roughly should be
	-- the 64x64 screen center
	-- for tprint()
	return 32 - ((#str * 2) - 2)
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
 	print"pb corrupt mode"
 	print"---------------"
 	print("\n⬆️⬇️ sd: "..c_sd)
 	print("⬅️➡️ itr: "..c_at)
 	print"\n🅾️ confirm"
 	--print"\n(some corruptions only can be\nfixed by reseting)"
 	--print"\n(check pause menu for\nnew options)"
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

-- badass thin font from
-- jwINSLOW23#6531 (cap j and w)
function init_tprint()
    local font,j="10011730c0337d5f337eb34889366aa103222e21d1355d5311c4211020841103088833e3e343f234ab932eb13754c326b7326ae30cb932eaa33aa210a21502144214a208a20f535a4c23da23df225e23fe22de215e23d63785f11d23b03499f11f378de3705e37a5e21de23ce205e2356225f37a0e33b0e37b1e3499233b1622da347ff3208237ff13082222102041378be32abf223f33a3f22bf20bf3762e37c9f347f121f136c9f221f37cdf3783f33a2e308bf37b2e368bf21b6307e137e0f33f0f37d9f36c9b31f87227d345c411b311d13046237fff51ffffff5155555550fd7b4f50ecc72e51502815502f39e850eeffee5077f9e7504745c4504fb7e4504f7fc450e8c76e51fadebf5010ff1850e8d62e50477dc45040100450edc62e504e3b84511dff7150e9c66e508202085041110450eaeeae515ad6b551f07c1f",1
    tprint_bmp,tprint_w={},{}
    for i=0,121 do
        local w=tonum(sub(font,j,j))
        local bmp="00"..sub(font,j+1,j+ceil(w*1.25))
        tprint_w[i+32]=w
        tprint_bmp[i+32]=tonum("0x"..sub(bmp,-7,-5).."."..sub(bmp,-4))
        j+=ceil(w*1.25)+1
    end
end

function tprint(s,x,y,c,d)
    if (not c) c=color()
    color(c)
    local camx,camy=peek2(0x5f28),peek2(0x5f2a)
    if (x-camx<-128 or x-camx>128) return

    local xx,yy=x,y-1
    for i=1,#s do
        local ch=sub(s,i,i)
        if ch=="\n" then
            yy+=6
            xx=x
        else
            local cs=tprint_bmp[ord(ch)] or 0x0.7fff
            repeat
                if xx-camx>=0 and xx-camx<=127 then
                    for rw=1,5 do
                        if cs>>>rw-1&0x0.0001>0 then
                            if (d) rectfill(xx,yy+rw,xx+1,yy+rw+1,d)
                            pset(xx,yy+rw,c)
                        end
                    end
                end
                cs>>>=5
                xx+=1
            until cs==0
            xx+=1
        end
    end
end

function tprint_width(s)
    local w=#s-1
    for i=1,#s do
        w+=tprint_w[ord(sub(s,i,i))] or 3
    end
    return w
end

function ctprint(s,x,y,c,d)
    tprint(s,x-tprint_width(s)/2,y,c,d)
end

--[[
thanks, 2016-2017 felice!

this code snippet is from before
punyfont was offically added
and documented, but it should
still work the same to convert
nromal font strings to punyfont
strings while the game is
running.

https://www.lexaloffle.com/bbs/?tid=3217
--]]

function punyfont(s)
  local d=""
  local c
  for i=1,#s do
    local a=sub(s,i,i)
    if a!="^" then
      if not c then
        for j=1,26 do
          if a==sub("abcdefghijklmnopqrstuvwxyz",j,j) then
            a=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",j,j)
          end
        end
      end
      d=d..a
      c=true
    end
    c=not c
  end
  return d
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

	sspr(32, 24, 3, 3, pos+(bus.w1sx-bus.sx), (bus.dy/2)+(bus.wsy-bus.sy), 3, 3, flip)
	sspr(32, 24, 3, 3, pos+(bus.w2sx-bus.sx), (bus.dy/2)+(bus.wsy-bus.sy), 3, 3, flip)
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
		sspr(96, 80, 8, 8, pos-4,(bus.dy/2)-8, 8, 8)
	end

	sspr(bus.sx, bus.sy, bus.sw, bus.sh, pos,bus.dy/2, bus.sw, bus.sh)
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
			spr(face, pos, 48, 1, 1, loge_flipped)
			spr(12, pos, 40, 1, 1, loge_flipped)
			spr(10, pos+8, 48, 1, 1, loge_flipped)
		elseif wanim==1 then
			spr(face, pos, 48, 1, 1, loge_flipped)
			spr(12, pos, 40, 1, 1, loge_flipped)
			spr(9, pos+8, 48, 1, 1, loge_flipped)
		elseif wanim==2 then
			spr(9, pos+7, 48, 1, 1, loge_flipped)
			spr(face, pos, 48, 1, 1, loge_flipped)
			spr(12, pos, 40, 1, 1, loge_flipped)
		elseif wanim==3 then
			spr(10, pos+7, 48, 1, 1, loge_flipped)
			spr(face, pos, 48, 1, 1, loge_flipped)
			spr(12, pos, 40, 1, 1, loge_flipped)
		end

	else

		if wanim==0 then
			spr(10, pos, 48, 1, 1, loge_flipped)
			spr(face, pos+8, 48, 1, 1, loge_flipped)
			spr(12, pos+8, 40, 1, 1, loge_flipped)
		elseif wanim==1 then
			spr(9, pos, 48, 1, 1, loge_flipped)
			spr(face, pos+8, 48, 1, 1, loge_flipped)
			spr(12, pos+8, 40, 1, 1, loge_flipped)
		elseif wanim==2 then
			spr(9, pos+1, 48, 1, 1, loge_flipped)
			spr(face, pos+8, 48, 1, 1, loge_flipped)
			spr(12, pos+8, 40, 1, 1, loge_flipped)
		elseif wanim==3 then
			spr(10, pos+1, 48, 1, 1, loge_flipped)
			spr(face, pos+8, 48, 1, 1, loge_flipped)
			spr(12, pos+8, 40, 1, 1, loge_flipped)
		end
	end

	palt(0, true)
	palt(11, false)
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

	sspr(32, 24, 3, 3, pos+(w1sx-bus.sx), (bus.dy/2)+(wsy-bus.sy), 5, 5, flip)
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

	sspr(32, 24, 3, 3, pos+(84-bus.sx), (bus.dy/2)+(bus.wsy-bus.sy), 3, 3, flip)
	sspr(32, 24, 3, 3, pos+(87-bus.sx), (bus.dy/2)+(bus.wsy-bus.sy), 3, 3, flip)

	palt(0, true)
	palt(11, false)

	pal()
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
 memcpy(0x4300, 0x6900, (0x6a60-0x6900)+1)

 --printfill("presiona z+x!", 32, 72/2, 10, 8)
 tprint("press z+x!", 32, 72/2, 10, 8)

 --print_centered("by superpositivep", 90, 7, 8)
 tprint("64x64 build", tprint_center("64x64 build"), 48-4, 10, 8)
 --print_centered("original by tom maneiro", 100, 7, 8)
 tprint("og: tom maneiro", tprint_center("og: tom maneiro")+1,50, 10, 8)
 --print_centered("pic: marcopolo paradiso 1800d", 110, 7, 8)
 tprint("pic: mp p 1800d", tprint_center("pic: mp p 1800d")+2, 56, 10, 8)
 --print_centered("made in pennsylvania", 120, 10, 8)

 palt()

 palt(11, true)
 palt(0, false)
 sspr(32, 0, 40, 8, 15, 18, 40, 8)
 sspr(32, 8, 32, 8, 15, 26, 32, 8)

 sspr(88, 8, 8, 8, 45, 26, 8, 8)

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
		sspr(32, 0, 40, 8, 15, 18, 40, 8)
		sspr(32, 8, 32, 8, 15, 26, 32, 8)
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

    		memcpy(0x6900, 0x4300, (0x6a60-0x6900)+1)
    else
      txt_flash = true
      tprint("press z+x!", 32, 72/2, 10, 8)
      --printfill("presiona z+x!", 64, 72, 10, 8)
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

	for i=0, 48, 32 do
		sspr(0, 72, 32, 16, 0, i, 32, 16)
		--spr(32, 0, i, 4, 2)
		spr(96, 32, i, 4, 2)
		spr(64, 0, i+16, 4, 2)
		sspr(0, 72, 32, 16, 32, i+16, 32, 16)
		--spr(32, 32, i+16, 4, 2)
	end

	busportiat(busbyid[busid])
	drawbus_bussel(busbyid[busid])

	--printfill(busbyid[busid].name,4,4,5,12)
	tprint(busbyid[busid].name.."\n"..busbyid[busid].brand.."\n"..busbyid[busid].origin.."\n"..busbyid[busid].height.."\n"..busbyid[busid].motorhp.."\noccu:"..busbyid[busid].passangers,1,1,5,12)

	--printfill("brand: "..busbyid[busid].brand,4,16,5,12)
	--printfill("origin: "..busbyid[busid].origin,4,22,5,12)
	--printfill("height: "..busbyid[busid].height,4,28,5,12)

	--printfill("motor:",86,76,5,12)
	--printfill(" "..busbyid[busid].motorhp,86,82,5,12)

	--printfill("occupancy:",86,92,5,12)
	--printfill("  "..busbyid[busid].passangers,86,98,5,12)

	--printfill("controls:",86,108,5,12)
	--printfill(" ⬅️ ➡️ 🅾️   ",86,98+16,5,12)
	tprint("\n\n\nselect\n⬅️➡️🅾️",43,1,5,12)
end

function drawbus_bussel(bus)

	local sel_dx = 1
	local sel_dy = 54
	local sel_dw = 26

	palt(0, false)
	palt(11, true)

	if (busid==3) sel_dy+=1

	if busid==7 then
		--sel_dx -= 7
		sel_dw = bus.sw
	end

	if busid==11 then
		--sel_dx -= 7
		sel_dw = bus.sw
	end

	if busid == 12 then
		--sel_dx -= 5
		sel_dw = bus.sw
	end

	if busid != 8 and busid != 9 then

		rectfill(sel_dx-1,sel_dy-1,sel_dx+sel_dw,(102/2)+bus.sh+4, 11)

		if busid == 10 then
			pal(2, 0)
			pal(15, 0)
			pal(12, 7)
			sspr(32, 24, 3, 3, sel_dx+(107-bus.sx), sel_dy+(84-bus.sy), 5, 5)

			pal(2, 2)
			pal(15, 15)
			pal(12, 12)
		end

		if busid == 12 then
			pal(2, 0)
			pal(15, 0)
			pal(12, 7)
			sspr(32, 24, 3, 3, sel_dx+(84-bus.sx), sel_dy+(bus.wsy-bus.sy), 3, 3)
			sspr(32, 24, 3, 3, sel_dx+(87-bus.sx), sel_dy+(bus.wsy-bus.sy), 3, 3)

			pal(2, 2)
			pal(15, 15)
			pal(12, 12)
		end
		
		sspr(bus.sx, bus.sy, bus.sw, bus.sh, sel_dx, sel_dy, bus.sw, bus.sh)
		
		pal(2, 0)
		pal(15, 0)
		pal(12, 7)

		sspr(32, 24, 3, 3, sel_dx+(bus.w1sx-bus.sx), sel_dy+(bus.wsy-bus.sy), 3, 3)
		sspr(32, 24, 3, 3, sel_dx+(bus.w2sx-bus.sx), sel_dy+(bus.wsy-bus.sy), 3, 3)
		pal()
	elseif busid==8 or busid==9 then
		-- loge specific stuff

		--sel_dx = 30
		sel_dy+=1

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



function busportiat(bus)

	-- no portrait for pico-8 logo
	if busid != 7 and busid!= 9 then
		rectfill(#"==>select a bus!<=="+3,73/2,#"==>select a bus!<=="+36,(73/2)+25, 0)
		spr(bus.psprite,#"==>select a bus!<=="+4,74/2,4,3)
	elseif busid==7 then
		--sspr(pico8.sx, pico8.sy, pico8.sw, pico8.sh, #"==>select a bus!<=="-11,88, pico8.dw, pico8.dh)

	-- a bit of bullshittery
	-- and corruption to cop myself
	-- out of having to use up
	-- space in the spritesheet
	-- for an impostor loge photo.
	elseif busid==9 then

		pal(14,12)
		pal(5,0)
		rectfill(#"==>select a bus!<=="+3,73/2,#"==>select a bus!<=="+36,(73/2)+25, 0)
		spr(bus.psprite,#"==>select a bus!<=="+4,74/2,4,3)
		pal(14,14)
		pal(5,5)

		portrait_glitch()

	end

end

function portrait_glitch()

	-- made specifically for
	-- impostor loge.

	-- may use for other buses.

	local addr_a = 0x690b

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
	sspr(32, 0, 40, 8, 15, 2, 40, 8)
	sspr(32, 8, 32, 8, 15, 10, 32, 8)
	sspr(88, 8, 8, 8, 45, 10, 8, 8)
	pal()

	-- the instructions text
	tprint("** controls **", tprint_center("** controls **")+2,19,5,12)
	tprint("⬅️ move bus\n➡️ move bus\n🅾️ horn\n❎ title", 12,28,5,12)

	tprint("prepare...",25,58,5,12)
	
	-- rectfill(101, 95, 101+16, 95+30, 12)

	printfill(instcount, 59, 58, 5, 12)
--[[
	if (instcount==3) then
		print("3333\n   3\n  33\n   3\n3333",102,96,5)
	elseif (instcount==2) then
		print("2222\n   2\n2222\n2    \n2222",102,96,5)
	elseif (instcount==1) then
		print("  11\n   1\n   1\n   1\n  111",98,96,5)
	else
		print("0000\n0  0\n0  0\n0  0\n0000",102,96,5)
	end
--]]
end
-->8
-- game

--[[
this absoluely could be cleaner,
but it is not nearly as bad as the
bus selection screen.
]]--

-- use punyfont alongside
-- tinyfont here.

function game()
	scr = -1

	-- reset variables each game

	pos = 0
	wanim = 0
	score = 0
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
	if (pos > 80) pos = -60
	if (pos < -60) pos = 80

	if btn"1" and btn"0" then
		-- do nothing on left and
		-- right being held together.
	elseif btn"1" then
		score += 1
		pos += 1
		wanim += 1
		sfx(0, 2)

		-- loge can turn around
		-- when going backwards.
		if (busid==8 or busid==9) loge_flipped=false

	elseif btn"0" then
		score -= 1
		pos -= 1
		wanim -= 1
		sfx(0, 2)

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
	elseif btn"4" and busid==8 or btn"4" and busid==9 then
		sfx(9, 0)
	end

	-- jump to title on ❎
	if (btn"5") title_screen()

	-- negative score fix
	if (score < 0) score = 32675
	if (score >= 32676) score = 0
end

function game_draw()
	-- draw the stage and score
	cls"13"
	stage()
	tprint("TRAVEL:"..score, 1, 58, 7, 13)--bgcolpal)
	color(bgcolpal)
	-- draw loge or the current bus
	if busid==8 or busid==9 then
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
	for i=0, 7, 1 do
		spr(2, i*8, 56)
	end
	pal(15,15)

	-- draw the picobus logo in
	--[[ the top right
	spr(4, 80, 8, 4, 2)
	spr(8, 112, 8)
	spr(27, 110, 16)

	palt(0, true)
	palt(11, false)--]]

	-- print build info under logo
	tprint("PICOBUS", 29, 1, 7, 8)
	tprint(punyfont(codename),51,1,14,0)
	tprint("VER."..punyfont(version),34,7,bgcolpal)

	color(bgcolpal)

	--[[draw the crooked post
	fillp(▒)
	rectfill(64,106,68,111,bgcolpal)
	rectfill(59,96,63,105,bgcolpal)
	rectfill(54,90,58,96,bgcolpal)
	rectfill(50,75,54,89,bgcolpal)
	fillp()
	print("\129",55,70,bgcolpal)
	print("\129",48,65,bgcolpal)
	print("\129",62,65,bgcolpal)
	print("\129",55,60,bgcolpal) --]]

	-- draw the normal posts
	--drawpost"10"
	--drawpost"114"
	spr(32, 28, 40)
	spr(49, 28, 48)
	
	spr(32, 5, 40, 1, 2)
	spr(32, 50, 40, 1, 2)
end

function stageinfotag(bus)
	--[[
	print the infotag for
	the current bus to the
	gameplay screen.
	--]]

	--[[ buses 7, 8, 9 are not buses
	if bus.id!=7 and bus.id!=8 and bus.id!=9 then
		tprint("YOUR BUS:", 1, 14)
	else
		tprint("YOUR \"BUS\":", 1, 14)
	end--]]

	-- print back to title button
	--tprint("❎=TITLE\n".."["..punyfont(bus.brand).."]\n"..punyfont(bus.name), 1, 1)
	tprint("❎=TITLE\n".."["..punyfont(bus.brand).."]\n"..punyfont(bus.name), 1, 7)

	--tprint("["..punyfont(bus.brand).."]", 1, 20)
	--tprint(punyfont(bus.name), 1, 26)


	--[[ buses 7, 8, 9 are not buses
	if bus.id!=7 and bus.id!=8 and bus.id!=9 then
		print("your bus:", 4, 14)
	else
		print("your \"bus\":", 4, 14)
	end

	print("["..bus.brand.."]", 4, 20)
	print(bus.name, 4, 26)--]]

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

	-- our label is not lowres
	poke(0x5f2c,0)
	clip()

	reload(0, 0, 0x4300, "extras\\label_mini.p8")
	cls()
	spr(0, 0, 0, 16, 16)
	menuitem(2, "reset to exit", label)
end
__gfx__
bbbbbbbb0080000055555555bbbbbbbbb8888bb888888888888888888888888888bbbbbbbbbbbbbbbbbbbbbbbb0ee0bbbbbbbbbbeeeeeeeeeeeeeeeeeeeeeebb
b000b00b097f000055555555000000bb8888bb888888888888888888888888888bbbbbbbbb000000bb0000000000000bbbbbbbbbeccc1111c1111c111ecc55cb
bbb0bbbba777e00055555555f0ffff0bbbbbbb888888888888888888888888888bbbbbbbb0ffffffb0fffffff0ffff0bbbbbbbbbeecc1111c1111c111ee5cc5c
0b0bb0b00b7d1000fbbffbbf0f7070f0b888b888888888888888888888888888bbbbbbbb0ff444440ff444440f7070f0bbbbbbbbeecc1111c1111c1111e5cc5e
0000000b00c10000bffbbffb0fff0ff0888bb777877788778877877787878877bbbbbbbb0f4444440f4444440fff0ff0bbbbbbbb85eeeeeeeeeeeeeaeee5555c
0707070b00000000fbbffbbf0ff000f0bbbbb78788788788878787878787878bbbbbbbbb0f4444440f4444440ff000f0bb0000bb85555555555555555555ee5c
b00000bb00000000bffbbffb40ffff0b888b777787887888787877788787877bbbbbbbbb0f4440000f44444440ffff0bbb0990bbee5e5bbb5aeeeea5bbba555a
bbbbbbbb00000000fbbffbbf000000bbbbbb788887887888787878787878887bbbbbbbbbb0000bbbb0000000000000bbbb0990bbbeee5bbb5eeeeee5bbb5eeee
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb888b78887778877877887778777877bbeeeeeeeeeeeeeeeeeeeeeebbb000bbbb00000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb88888888888888888888888888bbe5511511151151151115117b0eee0bbb00000000000000000000000000000000
bb7777b7777bb777bb7777bbbbb7777b88b888888888888888888888888888bbe5511511151151151115111b0eee0bbb000000000000006dd600000000000000
b771771b771177111771771bbbb71171bbb88880008888888888880008888bbbeeeeeeeeeee66eee111555110e0e0bbb0000000000000d555d00000000000000
b777771b771b771bb77177177b77777188b88800500888888888800500888bbb1111111111611611511511510e0e0bbb0000000000006555ee66666000000000
b771111b771b771bb771771b11771171bbbbbb05550bbbbbbbbbb05550bbbbbb8e00eeeeee6ee63eeeee1151b000bbbb000000000000601ee55dfffff6000000
b771bbb7777b7777b777711bbb777771bbbbbb00500bbbbbbbbbb00500bbbbbb8ee0ebbbae65e65ebbbaeeeabbbbbbbb000000000000062e55dffffffff00000
bbbbbbbb1111b111bb1111bbbbb11111bbbbbbb000bbbbbbbbbbbb000bbbbbbbbbeeebbbee6ee6eebbbeeeebbbbbbbbb000000000000062554ffffffffff0000
b777777b000000000000000000000000beeeeeeeeeeeeeeeeee000b00bbbbbbbb111111111111111111111bbbb0cc0bb0000000000000d244ffffffff6ff0000
77b7b7b7000000000000000000000000e0505550555055505550500bb0bbbbbbc1ccdcccdcccdccc1dd000cb0000000b0000000d606644444fff6ffff66ff000
7b7b7b77000000000000000000000000e5505550555055505550005bbbbbbbbbc1ccdcccdcccdccc1dd0dd0bf0ffff0b0000000d244444442ffd6fff655fe000
77b7b7b7000000000000000000000000e55055505550555000005005bbbbbbbbc1ccdcccdcccdcc11dd0ddd00f0707f000000644424444444ffffffffddff600
7b7b7b7700000000000000000000000080eeeeeee0eeeeeeeee05505bbbbbbbb811111111111111110d00dd000ff505000006444224444444efffeeeffdff600
77b7b7b70000000000000000000000008000055500555500555e0000bbbbbbbb810000000000000000000dd00f00f5f0000044444444444444feeeeeeddfe000
7b7b7b7700000000000000000000000055ee5bbb50e00ee5bbb5eeeabbbbbbbb11001bbb11111111bbb1111a40ffff0b000644d44444444444eeeeeee4eff000
b777777b000000000000000000000000b5ee5bbb50eeeee5bbb5eeebbbbbbbbbb1111bbb11111111bbb1111b000000bb000d444444444444442eeeeee44f0000
bbb77bbbb77bbbbb0000000000000000c20bbbbbbb9999999999999999bbbbbbbeeeeeeeeeeeeeeeeeeeeeb66bbbbbbb000d44444444444444424eeeeed00000
bbb7bbbbb7bbbbbb0000000000000000f5fbbbbbb8c9cc9cc9cc9cc9c99bbbbbe55555555555555555e555ebb6bbbbbb0006444444444444222222222d000000
bbbb7bbbbb7bbbbb000000000000000002cbbbbbb9c9cc9cc9cc9cc9cc99bbbbe44544544544544544e455ebbbbbbbbb00002442244222222222222d60000000
bbb77bbbb77bbbbb0000000000000000bbbbbbbbb89a0aa0aa0a9a59cc55999bee4544544544544544e444eebbbbbbbb00006522222222222222d60000000000
bbb77bbbbbb77bbb0000000000000000bbbbbbbbb890aa0aa0aa91199999995beeeeeeeeeeeeeeeeeeee44eeebbbbbbb000000d51111111dd660000000000000
bbb7bbbbbbbb7bbb0000000000000000bbbbbbbbb9999bbb99999119bbb999abe5eee555ee5ee5ee555ee4eeebbbbbbb00000000000000000000000000000000
bbbb7bbbbbb77bbb0000000000000000bbbbbbbb55555bbb55599999bbb99555e05e5bbb5e05e0e5bbb5eeeeebbbbbbb00000000000000000000000000000000
bbb77bbbbbb7bbbb0000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbeee5bbb5eeeeee5bbb5eeebbbbbbbbb00000000000000000000000000000000
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
ccccc88880008888888800088880eee0666ddd6666666666ffff666666666ff6b888cccc8cccc8cccc8cccc8cc00c00cbbbbbbbb6aaa5a5a5a5a5a5aaaaaaa9a
cc88c88800500888888005008880e0e066d055dd66666fffffff6666f666ffffbb88888888888880088888888880c00c444bbbbbaa93ca4839c848aca389c4a5
cccccccc05550cccccc05550ccc0e0e066d0005dd666fffffff666666666ffffbb777788888877088088888888808080b4444bbb8ac4839c4839ca49c00000a5
cccccccc00500cccccc00500cccc000c66610001555dddd6666666666666fff6bb8008bbbbbb88088088bbbbbb80c08abb44444baa8bbbbb0ca483ca80bbb00a
ccccccccc000cccccccc000ccccccccc666d450001011111155dddd666666ff6b55888bbbbbb88055088bbbbbb80088bbbb444446aabbbbb0000000430bbb00a
cccccccccccccccccccccccccccccccc666ff99994d552100001111115dd6666000000000000000000000000bbbbbbbbccccccccccccccccccccccccccccc878
cccccccccccccccccccccccccccccccc666f99999e55dd9dedd444451005d666000000000000000000000000bbbbbbb877777666776667777766676667777c60
cccccccccccccccccccccccccccccccc666a99999f1dd16d511de99941156666000000000000000000000000bbbbbbb888888666776667676766676667676766
cccccccccccccccccccccccccccccccc666999999f5661dd606dd9994015ff66000000000000000000000000bbbbbbb899d77666776667676766676667676766
cccccccccccccccccccccccccccccccc66699999945660d5606dd9999999fff6000000000000000000000000bbbbbb5555d8888888cccccccccccccccccccccc
cccccccccccccccccccccccccccccccc666999999dd66d65616de99999999af6000000000000000000000000bbbbbb8b77d77777777777575777777777575777
cccccccccccccccccccccccccccccccc666999999499999f6d6d999999999af6000000000000000000000000bbbbbb8b88888885bbb88757577775bbb75757da
cccccccccccccccccccccccccccccccc6669994a9d44999999999994949999a6000000000000000000000000bbbbb8bb77777775bbb77777777775bbb7777700
00000000000000000000000000000000666945df44244fd559444d4d244499f60000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000666945d4444dd4dada445d55000099af0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000066644d55dd05542f4224d5d2155149af0000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000666ddd5d5d1dd225424544d555d559af0000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000006666251dd51555dd455d4555ddd5d4660000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000666652555555d1111115fd555dddd6660000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000066666d2255ddddddddddddd5555566660000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000006666ddddd5555ddddddd55dd55d6d6660000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000067777fff77777777f77fffff777777770000000000000000000000000000000000000000000000000000000000000000
133cccc66666666777777777777777766777777f77777777ff77fffff77777770000000000000000000000000000000000000000000000000000000000000000
3ccccccc666cccc66677777777777776677777777fffeefedee777fff77777770000000000000000000000000000000000000000000000000000000000000000
ccccccccccccccc66cc777777777776d677777ff6dd444444e2677ff777777770000000000000000000000000000000000000000000000000000000000000000
6cccc66666ccccccc66676667777666d67777fe444442522dd41677f7777777f0000000000000000000000000000000000000000000000000000000000000000
cccccc6666666ccc6d666d66d6d66666677776d4eeeeeeeed44126777777777f0000000000000000000000000000000000000000000000000000000000000000
cccc6667777776ddd5555331ddd66666677766ef6dee4deeee222577f7777fff0000000000000000000000000000000000000000000000000000000000000000
66666666666666dd6d5ddddddddddddd4f77d6eeeeeeeeeeee4222d77f777ff70000000000000000000000000000000000000000000000000000000000000000
666666666d6777d7765ddd6ddd6d5555244fd6fff6edeeeeeed2222677f777770000000000000000000000000000000000000000000000000000000000000000
6667776ccc6666dc665dd5ddddd5555124444eff66edeeeedd222222677777770000000000000000000000000000000000000000000000000000000000000000
7777667666edeeeeee5d55511111555524444de66eddeddddd2212244f77777f0000000000000000000000000000000000000000000000000000000000000000
5d6666e488eee88884ee55111111155524444deeededdeeddd22224444f777740000000000000000000000000000000000000000000000000000000000000000
1544eedddd5eee8884eee4225222255524444ddedeeee5dddd422244444777f40000000000000000000000000000000000000000000000000000000000000000
555ee550551dee451548820000015dd524444dddddf66dd66e222244444f77e40000000000000000000000000000000000000000000000000000000000000000
555225d1dd11e8422245d55111115d5524444f66ddd6ddd65d122444444e7f440000000000000000000000000000000000000000000000000000000000000000
d55225555d5188488848dd1115d1155524444dddd5dd5dd6de22224444ee7e440000000000000000000000000000000000000000000000000000000000000000
d5501d555d5148888445d61155dd5dd524444fff6d55d66eee22214444ee7e440000000000000000000000000000000000000000000000000000000000000000
66d55dd5dd41002dd44111115dd6667624444e6f6ddd66eddd22204444ee7f440000000000000000000000000000000000000000000000000000000000000000
66666d51dd511001d55100566667777724444ddf6edffeedee222044444e7e440000000000000000000000000000000000000000000000000000000000000000
d666666d550011111111115d666666660444444d444d425222022144444474440000000000000000000000000000000000000000000000000000000000000000
d666666666ddddddddd55555d55dddd6044422222444442222122124444474440000000000000000000000000000000000000000000000000000000000000000
d666666667666dd66ddddddddd55555514444dd42544455d662210e6d44f7e4d0000000000000000000000000000000000000000000000000000000000000000
dd666666666766666766666666ddd551dd246dd514ef666ff65515ffe4dffe460000000000000000000000000000000000000000000000000000000000000000
ddd6d6666666666766666766666dd5dd555552552522222222222222222555520000000000000000000000000000000000000000000000000000000000000000
__label__
aaaaaaaaaaaaaaaa8888888888888828888888846759999994676dd6666ffffd5111444444444444444444444444444444444444444444444444444444444444
aaaaaaaaaaaaaaa888888888888882488888888277499999994677777777777777d4444444444444444444444444444444444444444444444444444444444444
aaaaaaaaaaaaaaa88888888888882888888888857699999999945444444444567644444444444444444444444444444444444444444444444444444444444444
aaaaaaaaaaaaaa888888888888828888888884567d99999999999999999999d76144444444444444444444444444444444444444444444444444444444444444
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
aa888888888820077777700000000077777700077777700777777700777777007777770077777700777777000777777007777770000000077777770088888888
a8888856688140077777700000000077777700077777700777777000777777007777770077777700777777000777777007777770077777007777770088888888
a8888546666580077777700999990077777700077777700777777000777777007777770077777700777777000777777007777770777777007777770088888888
888882866d6600077777700999400077777700777777700777777007777777077777770077777700777777007777777077777770777777007777770088888888
8888588d699400777777000999a00777777700777777000777777007777770077777700777777707777777007777770077777700777777007777770088888888
8888488d69990077777700994aa00777777000777777007777770007777770077777700777777007777770007777770077777700777777007777770088888888
8888e8846a99007777770094aaa00777777000777777777777770007777777777777700777777777777770007777777777777700777777777777700088888888
888ff8847d9900777777004aaaa00777777000777777777777700007777777777777000777777777777770007777777777777000777777777777700888888888
886ee8846d900077777700aaaa000777777000077777777777000000777777777770000777777777777700000777777777770000077777777777000888888888
8848884664900777777000aaaa007777777000007777777770008800077777777700007777777777777000400077777777700040007777777700008888888888
88888466999000000000066aaa000000000007000000000000088880000000000000000000000000000004440000000000000444000000000000088888888888
84884669999900000000946daaa00000000077700000000000888888000000000004400000000000000044444000000000000440000000000008800000000008
5884669999999999999999466aaaaaaaa67776588882225d88888888844444444444444444444444444444444480e044440e0480eeeee00ee08880e00eeeee08
48466d99999999999999999d66aaaaa6677658888224425d58888888844844444444444444444444444444444400e044400e088000e0000ee08880e0000e0008
84d66676666d999994666676665aaa6776508882224445495888888884666444444444444444444444444444440ee00800ee088880e0880ee00880e0880e0888
84999444dd669999a666666666aaf677d1882222242255994576dd6667776666d64444444444444444444444440e0e040e0e088800e0800e0e0800e0800e0888
4999999999f66999d67777776aa6776588222422d5554997666677777777777777666d444444444444444444400e0e000e0e08880e0080e00e000e0080e00888
499999999aa6699966777776af677d2882244449d5f9976d677776667777777677777766d66444444444444440e00e00e00e08880e0880e000e00e0880e08888
999999999aaa66a6667777da67765881242499944476d67776d51111577751155d6667777766d6674444444400e00e00e00e08880e0880e080e00e0880e08888
99999999aaaaf6d667776fa677d18022249994477666776d111111111677511155511115d6677766d67744440e000e0e000e08880e0880e080e00e0880e08888
9999999aaaaaa6766776aa6765882244999447666776d11115dd666d5d7751677776d5111111d667776666700e040e0e080e08800e0800e0800ee00800e08888
999999aaaaaaaf766d6af67608122449947666676d111115666666666d6d0067777776666dd51111d6777660e0040ee0080e0000e0000e00880ee0000e000888
999999aaaaaaaadd46d677d88222499476d676650115511d666666666610006777777766666666dd51156670e0670ee0880e00eeeee00e088800e00eeeee0888
99999aaaaaaaaa54466665812244976d6776d1115d665116666666666d000067777777666666666666d511500076000088000000000000088880000000000888
9999aaaaaaaaad48d6f66115d666d6776d1111d666661116666666666d0000676677776666666666666666d1156776d678888888888888888888888888888888
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
999888888999994999999999999999999999999f77e81888821d666666611188e7777ffeeffeeef777677feeffff777777777777777776744444444444444488
9988888889999949499999999999999999999999f76e18888821d666666111888e777fffeffefff777677ffeefefe4eeffff7ff7777776744444444444444448
988888888899999999999999999999999999999def761888888811d66661118888e777777777777777777fffeefe7ffffeefef7ff77676744444444444444444
8888888888999999999999999999999999999996f9f61e888888821d66611188888e7777777777777777777777777777f7fffeefe77776744444444444444444
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
ff7fe3ff6ff4edb28b774a49704436a68302215d9080208891b1f0d836dc615994688280998d0666490ec387d04a1c4da660cde8a1c220445e08072582105d26e4a89821e824cb6c9be348220aa389a41a6c2300868833361016f16449579849c2613f24483231d7b6711469b2d125c9f0236b9201d4419ac5101e5d82dc8110
c34436e25884adb664716032c12fa24982813c49840b8e248bc2d2ca3292f805910f907c8d46c171c891045cfc144e03e218de04d6cd167f27f9c9b02b4b6464133ff39b2444c4d21c1dc8ff9304b4b1fe0ff899201280ff015ff8875c2dcb7ee777d244c8ff82931f98588a24f37f1dd8be6522fe1dfb71091c4a34f857f0ca
d7e0f2388cdd2287c885c433c9d384332521c9e491231c87c89e300059cec4c100fbec4b7251fa484842a9fccd1f097b2a6211844792e60da77db6a7d363d284233c192cf357e62240f62c75856b19c2e6089358ed6dc2a37beb30ade348ab33914326157225c16583929c4b88dac4c529eca94c65834292391282720139b270
72a5122cf8873089209938964d9619be5a162434c11219731ca1441221968912c3234424b62489449226c6f248c8d58c840cdf113b1c1cada7b246bc49457547822d115962210f81324f26462c3866096b068b4d626f0a20325dc09048201795bf12c0f50d264b30c74c8f59320c245cc2c2355184d80e44335b84896d999190
f09825c6b3c896847cd896538ec42384653cce44b2e0a35938128f18a607cb9c86241e49650b6d124056ae463d24998863c992c3c41e9aa5e289200b780eb16c8d20b1a39325990f09900259c252a66419cb75c5356592248d99916fa984c9c2104f1dd14f40880c4d322c086292347824cf111c197cc8961c18c2409aa95480
3346aeeb40d6831d870798cc613972e570749a0350db43a0228ecea1c92c47a19276e9641b34462e7d963a784e5b92390e99809e2c71aa445747e69800b72d504908b7497c592eeb2e4b52a74a14b99ae37b9ea7b27ccb2c955ec7765852f9e3388eac6324d79ae3595cf3a54792639dd8174b160790460e82c74686311e7992
f66c3cd9d35403812e8fa36a579e88601ecac1a1ced6464cae438e43965854f5d46bdd122e761cd2a6799eede86139aeab933498c58366f5479e912d9e9e6b9ec3eb60a472d9ea48ae8a23953d342295e461df3477e2813d9f1c91e3090dcd8a6be57144c8f2781df160e01473e47b3e308dc662cf3c8f60160b38241e66927f
04f1c48ec91ccfd027c046e45818014fe0130b63e10f92cc46279ab8b2907f331359628f943239e4870ec0a1112c21200cfb83ee975f58f201d9fbc70f512b2b2b63c242001e0b0d07a75df2f2f9e30abf73e51f3f2432fc232fd7c25ff9c5f6cf7cf27fe049863790d09c4ef983097e4c62e109f831f1479e7f5e802b825f11
f9594e0cff0712e678466d9cfbe1cadf810fff0f88c41316fe4c6018fe083fe70fe34afc118e400ef0138667482a18c6ff499e05841fc0020c7f6c082143080808c0c2ff949384302b022e3e3eca41c27158e2ffca4f213cdc618c845b2e09ffff28fc4a00c20f24fcff557280f00fff7f120ce0ffbf0f06e00affff39fc42f9
ffc724349cfcffe9d0808bff3f5c1046f8ffeb0316feff3f8087ffbfcecbff3f0f77f82b8fff3f1bfe8c0fff7f34fc9c7fbeffbf19be081e967f1c9e66fefffffff82909ca92e0ff7f72814949cec4ffdf0d0bece408ffff7430044110f0ff7f2938863ff8ffd70f20e0ff6f872308ff7f9d868fffffceffff2f000000000000
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
__music__
04 07084344
00 41424340
01 41424340
00 41424340
00 41424346
00 41424346
00 41424344
00 47484344

