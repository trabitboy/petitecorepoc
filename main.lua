--GOAL see if rotation on model loading + compensation is aligned to game logic

--merge ?
-- thrusters decrease 

--walkable map

-- collision with walls

-- destroy ennemies

-- thruster jump

-- land on skyscrapers

--ennemies instantiated on map and rotating and doing back and forth

--remarks
-- guidelines on model orientation
-- subsequent rotations
-- write representation of axises and rotations ( orientation of angles )
-- smaller poc for model rotations ?


-- lets do dummy objects to display axes 

-- we render floor and skyscrapers

-- render robot
-- control robot 
-- todo
-- skyscraper on map 2 

--poc scope
-- ennemy mechs
-- jump on top of building
-- shoot
-- front and side dash


-- skyscraper collision with robot 
-- use g3d built in with alternate model ? ( cube )
-- jump then land on top of buildings


--WIP debugging firing of bullets

--TODO try upload new models with road and skyscrasper tex,
-- to debug uvs
--( out put of blender doesn't seem consistent with picocad )
-- seems to take bottom of sprite sheet instead of top, try to flip png
--vflip woks !!!!!

--WIP progressive angle on robot move
--    there is a direction set by combination of key presses
--    which equals an angle, 
--    the robot turns to this direction at fixed angular velocity,
--    regardless of movement
--    the robot is firing in the direction it faces , not towards its movement
-- make robot lean forward when it moves 
-- thruster in back of robot ( first test of rotation )


--map data
mapunit=8 --sceneryobjects have different zoom, but they all take 8 world units

--ply data
xmech=56
zmech=6

camerazdist=18
camerayheight=-30

guncooldown=0
--visual alpha of thrusters
frontthruster=0
downthruster=0
leftthruster=0
rightthruster=0


targetangle=0
displayangle=0

fireanglemech=math.pi
bullets={}



g3d = require "g3d"

  
    Moon = g3d.newModel(
            "assets/floortile.obj"
            ,"assets/floortile_tex.png"
--      "assets/untitled.obj"
--      "assets/mymecha.obj"
--      "assets/texcube.obj"
--      "assets/maycube.obj"
--      "assets/blencube.obj"
--      "assets/puddle.obj"
--      , "assets/smile.png"
--    , "assets/puddle.png"
--    , "assets/mymecha_tex.png"
--            "assets/tripicocube.obj"
--    , "assets/picocube_tex.png"
      , {5,5,0}, {100,0,0}, {0.5,0.5,0.5})
  
  
  thruster=   g3d.newModel(
            "assets/votoms/trithruster.obj"
            ,"assets/votoms/picotex.png"
      , {10,0,0},
      nil,
      {4,4,4}
      )
  
  xcube=  g3d.newModel(
            "assets/xcube.obj"
            ,"assets/debugtex.png"
      , {10,0,0},
      nil,
      {4,4,4}
      )
  
  zerocube=  g3d.newModel(
            "assets/tri0cube.obj"
            ,"assets/debugtex.png"
      , {0,0,0},
      nil,
      {4,4,4}
      )
  
  ycube= g3d.newModel(
            "assets/triycube.obj"
            ,"assets/debugtex.png"
      , {0,10,0},
      nil,
      {4,4,4}
      )
  
   zcube=g3d.newModel(
            "assets/trizcube.obj"
            ,"assets/debugtex.png"
      , {0,0,10},
      nil,
      {4,4,4}
      )
  

firebullet= function()
  b={
    x=xmech,
    z=zmech,
    spd=1.0,
--    angle=fireanglemech
    angle=displayangle,
    timeout=255
  }
  guncooldown=16
  table.insert(bullets,b)
end


-- 8x8, we render model number x

floor={
        1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
      }

modelRep={}

tarmacId=1

modelRep[tarmacId]= g3d.newModel(
--            "assets/floortile.obj"
--            ,"assets/floortile_tex_vf.png"
            "assets/tarmac/tritarmac1.obj"
            ,"assets/tarmac/tarmac1_tex.png"
--      , {5,5,0}, {100,0,0}, {0.5,0.5,0.5})
      , {5,5,0}, nil, {4,4,4})

buildingId=2

modelRep[buildingId]=g3d.newModel(
--      "assets/skyscraper/tripicocube.obj"
--    , "assets/skyscraper/tripicocube_tex.png"
--      "assets/skyscraper/ss1.obj"
--    , "assets/skyscraper/ss1_tex_vf.png"
      "assets/skyscraper/trisstex1.obj"
    , "assets/skyscraper/sstex1_tex.png"
      , {0,0,0}, nil, {8,8,8})


plyId=3

modelRep[plyId]=g3d.newModel(
--      "assets/votoms/trivotoms1.obj"
--    , "assets/votoms/votom1_tex_vf.png"
--      "assets/votoms/tritexmecha1.obj"
      "assets/votoms/trimechatex2.obj"
--    , "assets/votoms/mymecha_tex_vf.png"
    , "assets/votoms/mymecha_tex.png"
      , {0,0,0}, 
      nil,
      --{0,0,math.pi}, rot, model doesnt have correct orientation 
      {3,3,3})

modelRep[4]=g3d.newModel(
--      "assets/skyscraper/tripicocube.obj"
--    , "assets/skyscraper/tripicocube_tex.png"
      "assets/skyscraper/ss1.obj"
    , "assets/skyscraper/ss1_tex_vf.png"
      , {0,0,0}, nil, {1,1,1})

plyBulletId=5

modelRep[plyBulletId]=g3d.newModel(
      "assets/votoms/rainbowshard.obj"
    , "assets/votoms/rainbowshard_tex.png"
      , {0,0,0}, {0,0,math.pi/2}, {3,3,3})

ennemyDrone=6

modelRep[ennemyDrone]=g3d.newModel(
--      "assets/votoms/trivotoms1.obj"
--    , "assets/votoms/votom1_tex.png"
      "assets/mechaturd/mechaturd.obj"
    , "assets/skyscraper/sstex1_tex.png"
      , {-32,0,0}, {0,0,math.pi}, {3,3,3})




function turnRobot()
  if displayangle<=targetangle then
    if targetangle-displayangle>0.1 then
      displayangle=displayangle+0.1
    end
  elseif 
    displayangle>=targetangle then
    if displayangle-targetangle>0.1 then
      displayangle=displayangle-0.1
    end
  end
  
end


function love.load()
--    Earth = g3d.newModel("assets/sphere.obj", "assets/earth.png", {0,0,4})
    Background = g3d.newModel("assets/sphere.obj", "assets/starfield.png", {0,0,0}, nil, {500,500,500})
    Timer = 0
    
    g3d.camera.position={xmech,camerayheight,zmech-camerazdist}
    g3d.camera.updateViewMatrix()
end

function love.mousemoved(x,y, dx,dy)
--    g3d.camera.firstPersonLook(dx,dy)
end

function cameraTargetPlayer()
    g3d.camera.target={xmech,0,zmech}
    g3d.camera.updateViewMatrix()
    
end

function moveCamera(dx,dy,dz)
    g3d.camera.position={g3d.camera.position[1]+dx,g3d.camera.position[2]+dy,g3d.camera.position[3]+dz}
end

--WIP totally not verified on paper hum
function moveBullet(b,i)
  b.x=b.x+math.cos(b.angle)*b.spd
  b.z=b.z+math.sin(b.angle)*b.spd
  b.timeout=b.timeout-8
  if b.timeout < 1 then
    table.remove(bullets,i)
    return
  end
end

function debugPrint()
  love.graphics.print("camera x "..g3d.camera.position[1].." y "..g3d.camera.position[2].." z "..g3d.camera.position[3] .. 
    " ply pos x "..xmech .. " z "..zmech .." bullets " .. #bullets .. " guncooldown "..guncooldown)
  
end


function love.update(dt)
    
    if guncooldown>=1 then
      guncooldown=guncooldown-1 
    end
  
    if leftthruster>=1 then
      leftthruster=leftthruster-8
    end

    if rightthruster>=1 then
      rightthruster=rightthruster-8 
    end

  
  
    for i,b in ipairs(bullets)
    do
      moveBullet(b,i)
    end
  
    if love.keyboard.isDown('kp1')then
--      g3d.camera.position[3]=g3d.camera.position[3]+0.5
      moveCamera(0,0,0.5)
    end
  
    if love.keyboard.isDown('kp7')then
      g3d.camera.position[3]=g3d.camera.position[3]-0.5
    end
  
    if love.keyboard.isDown('up')then
      g3d.camera.position[2]=g3d.camera.position[2]+0.5

    end
  
    if love.keyboard.isDown('down')then
      g3d.camera.position[2]=g3d.camera.position[2]-0.5

    end

    if love.keyboard.isDown('left')then
      g3d.camera.position[1]=g3d.camera.position[1]+0.5

    end
  
    if love.keyboard.isDown('right')then
      g3d.camera.position[1]=g3d.camera.position[1]-0.5

    end
  
  turnRobot()
  --should be definitive version later, only for s at the moment
--  modelRep[3]:setRotation(0,displayangle,math.pi)
  modelRep[3]:setRotation(0,displayangle,0)
  
  
  --TODO super strange that rotate for the shard is not the same as rotate
  -- for the mech,
  -- maybe because mech model should just be upright to begin with ?
  if love.keyboard.isDown('s')then
    xmech=xmech-0.1
    targetangle=math.pi
    leftthruster=200
--    fireanglemech=-math.pi/2
--    fireanglemech=math.pi
--    modelRep[5]:setRotation(0,0,math.pi/2)
    
--    modelRep[3]:setRotation(0,-math.pi/2,math.pi)
    moveCamera(-0.1,0,0)
  end
  if love.keyboard.isDown('f')then
    xmech=xmech+0.1
--    fireanglemech = 0
    targetangle = 0
    rightthruster=200
--    modelRep[5]:setRotation(0,targetangle,0)

    
--    modelRep[3]:setRotation(0,math.pi/2,math.pi)    
    
    
    moveCamera(0.1,0,0)
  end
  
  if love.keyboard.isDown('e')then
    zmech=zmech+0.1
--    fireanglemech=math.pi/2
    targetangle=math.pi/2
--    modelRep[5]:setRotation(0,targetangle,0)
    
--    modelRep[3]:setRotation(0,math.pi,math.pi)
    moveCamera(0,0,0.1)

  end
  if love.keyboard.isDown('d')then
    zmech=zmech-0.1
--    fireanglemech=3*math.pi/2    
    targetangle=-math.pi/2
    
--    modelRep[5]:setRotation(0,targetangle,0)
    
--    modelRep[3]:setRotation(0,0,math.pi)
    moveCamera(0,0,-0.1)

  end
  
  if love.keyboard.isDown('space') and guncooldown<1 then
    firebullet()
  end
  
  cameraTargetPlayer()
  
--    Timer = Timer + dt
--    Moon:setTranslation(math.cos(Timer)*5, 0, math.sin(Timer)*5 +4)
--    Moon:setRotation(0,-1*Timer,0)
--    g3d.camera.firstPersonMovement(dt)
end


    thrustradius=10

function calculatethrustpos(radius, a)
    ret={x=xmech+math.cos(displayangle+a)*radius,z=zmech+math.sin(displayangle+a)*radius,y=-8}
    return ret
end


function love.draw()
--    Earth:draw()
--    Moon:draw()
--    Background:draw()
    tx=5
    ty=1
    tz=0
    for j=1,16
    do
      for i=1,16
      do
        tnum=floor[8*j+i]
--      Moon:setTranslation(i,ty,j)
--      Moon:draw()
      if tnum==1 then
        modelRep[tarmacId]:setTranslation(16+i*8,ty,j*8)
        modelRep[tarmacId]:draw()
      else
        modelRep[buildingId]:setTranslation(16+i*8,ty-4,j*8)
        --rot should not be there
        modelRep[buildingId]:setRotation(math.pi,0,0)
        modelRep[buildingId]:draw()        
      end
      
        
      end
    end
    
    --test render ennemy
    modelRep[ennemyDrone]:draw()
    
      
    --ply
    
    --we render thrusters on key strokes, they are rotated around center of mecha
    --let's calculate in x z plane
    --right shoulder thruster is on radius 6 on pi/2+display angle
    
--    thrustradius=10
--    rst={x=xmech+math.cos(displayangle+math.pi/2)*thrustradius,z=zmech+math.sin(displayangle+math.pi/2)*thrustradius,y=-8}
    if leftthruster>0 then
    lst=calculatethrustpos(thrustradius,math.pi/2)
    thruster:setTranslation(lst.x,lst.y,lst.z)
    thruster:setRotation(0,-(displayangle+math.pi/2),0)
    love.graphics.setColor(1.0,1.,1.,leftthruster/255)
    thruster:draw()
    end
    
    if rightthruster>0 then
    rst=calculatethrustpos(thrustradius,-math.pi/2)
    thruster:setTranslation(rst.x,rst.y,rst.z)
    thruster:setRotation(0,-(displayangle-math.pi/2),0)
    love.graphics.setColor(1.0,1.,1.,rightthruster/255)
    thruster:draw()
    end
    
    love.graphics.setColor(1.,1.,1.,1.)

    
    
    
    modelRep[plyId]:setRotation(0,-displayangle-math.pi/2,math.pi)
    modelRep[plyId]:setTranslation(xmech,ty-5,zmech)
    modelRep[plyId]:draw()

    --bullets
    for i,b in ipairs(bullets)
    do
      modelRep[plyBulletId]:setTranslation(b.x,ty-6,b.z)
      --not sure why model rotation has to go through minus, very annoying
      -- z rot is correction of the orientation of the loaded model
      modelRep[plyBulletId]:setRotation(0,-b.angle,-math.pi/2)
      
      love.graphics.setColor(1.0,1.,1.,b.timeout/255)
      modelRep[plyBulletId]:draw()
      love.graphics.setColor(1.,1.,1.,1.)
      
    end
    
    --xcube 
    xcube:draw()
    ycube:draw()
    zcube:draw()
    
    
    --0cube
    zerocube:draw()
    
    love.graphics.setColor(1.,1.,1.,1.)
--    love.graphics.print('petite core')
    debugPrint()
end
