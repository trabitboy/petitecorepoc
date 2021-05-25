

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

--TODO progressive angle on robot move
--    there is a direction set by combination of key presses
--    which equals an angle, 
--    the robot turns to this direction at fixed angular velocity,
--    regardless of movement
--    the robot is firing in the direction it faces , not towards its movement
-- make robot lean forward when it moves 


--ply data
xmech=0
zmech=0
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
  
  

firebullet= function()
  b={x=xmech,z=zmech,spd=1.0,angle=fireanglemech}
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
        1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
      }

modelRep={}
modelRep[1]= g3d.newModel(
--            "assets/floortile.obj"
--            ,"assets/floortile_tex_vf.png"
            "assets/tarmac/tritarmac1.obj"
            ,"assets/tarmac/tarmac1_tex_vf.png"
--      , {5,5,0}, {100,0,0}, {0.5,0.5,0.5})
      , {5,5,0}, nil, {4,4,4})

modelRep[2]=g3d.newModel(
--      "assets/skyscraper/tripicocube.obj"
--    , "assets/skyscraper/tripicocube_tex.png"
--      "assets/skyscraper/ss1.obj"
--    , "assets/skyscraper/ss1_tex_vf.png"
      "assets/skyscraper/trisstex1.obj"
    , "assets/skyscraper/sstex1_tex_vf.png"
      , {0,0,0}, nil, {8,8,8})


--no tex, not super finished
modelRep[3]=g3d.newModel(
--      "assets/votoms/trivotoms1.obj"
--    , "assets/votoms/votom1_tex_vf.png"
      "assets/votoms/tritexmecha1.obj"
    , "assets/votoms/mymecha_tex_vf.png"
      , {0,0,0}, {0,0,math.pi}, {3,3,3})

modelRep[4]=g3d.newModel(
--      "assets/skyscraper/tripicocube.obj"
--    , "assets/skyscraper/tripicocube_tex.png"
      "assets/skyscraper/ss1.obj"
    , "assets/skyscraper/ss1_tex_vf.png"
      , {0,0,0}, nil, {1,1,1})

function love.load()
--    Earth = g3d.newModel("assets/sphere.obj", "assets/earth.png", {0,0,4})
    Background = g3d.newModel("assets/sphere.obj", "assets/starfield.png", {0,0,0}, nil, {500,500,500})
    Timer = 0
    
  --doesn4t seem to work
    g3d.camera.position={0,0,-10}
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
function moveBullet(b)
  b.x=b.x+math.cos(b.angle)*b.spd
  b.z=b.z+math.sin(b.angle)*b.spd
end


function love.update(dt)
  
    for i,b in ipairs(bullets)
    do
      moveBullet(b)
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
  
  
  if love.keyboard.isDown('s')then
    xmech=xmech-0.1
    fireanglemech=-math.pi/2
    modelRep[3]:setRotation(0,-math.pi/2,math.pi)
    moveCamera(-0.1,0,0)
  end
  if love.keyboard.isDown('f')then
    xmech=xmech+0.1
    fireanglemech=math.pi/2
    modelRep[3]:setRotation(0,math.pi/2,math.pi)    
    moveCamera(0.1,0,0)
  end
  
  if love.keyboard.isDown('e')then
    zmech=zmech+0.1
    fireanglemech=math.pi
    modelRep[3]:setRotation(0,math.pi,math.pi)
    moveCamera(0,0,0.1)

  end
  if love.keyboard.isDown('d')then
    zmech=zmech-0.1
    fireanglemech=0    
    modelRep[3]:setRotation(0,0,math.pi)
    moveCamera(0,0,-0.1)

  end
  
  if love.keyboard.isDown('space') then
    firebullet()
  end
  
  cameraTargetPlayer()
  
--    Timer = Timer + dt
--    Moon:setTranslation(math.cos(Timer)*5, 0, math.sin(Timer)*5 +4)
--    Moon:setRotation(0,-1*Timer,0)
--    g3d.camera.firstPersonMovement(dt)
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
        modelRep[1]:setTranslation(i*8,ty,j*8)
        modelRep[1]:draw()
      else
        modelRep[2]:setTranslation(i*8,ty-4,j*8)
        --rot should not be there
        modelRep[2]:setRotation(math.pi,0,0)
        modelRep[2]:draw()        
      end
      
        
      end
    end
    
    --test render skyscraper
    modelRep[4]:draw()
    
      
    --ply
    modelRep[3]:setTranslation(xmech,ty-5,zmech)
    modelRep[3]:draw()

    --bullets
    for i,b in ipairs(bullets)
    do
      modelRep[3]:setTranslation(b.x,ty,b.z)
      modelRep[3]:draw()
      
    end
    
    
    love.graphics.setColor(1.,1.,1.,1.)
    love.graphics.print('petite core')
    
end
