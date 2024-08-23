function love.load()
  jetpacksprite = love.graphics.newImage("sprites/shitpack.png")
  obs_sprite = love.graphics.newImage("sprites/ob2.png")
  window_width = love.graphics.getWidth()
  window_height = love.graphics.getHeight()
  jetpack = {}
  jetpack.height = 50
  jetpack.width = 25
  jetpack.x = window_width / 4
  jetpack.y = window_height - jetpack.height
  jetpack.yspeed = 500
  jetpack.gravity = 300
  jetpack.acceleration = 150
  shit = {}
  obstacles = {}
  max_particles = 30
  can_spawn = true
  spawn_delay = 0.09
  spawn_timer = 0
  max_obstacles = 5
  suspension_delay = 0.1
  suspension_timer = 0
  on_air = 0
  collision = false
end

function createshit()
  if #shit < max_particles then
    local particle = {}
    particle.x = jetpack.x + (jetpack.width / 2)
    particle.y = jetpack.y + jetpack.height
    particle.yspeed = 300
    table.insert(shit, particle)
  end
end

function love.update(dt)
  create_obstacles()
  if collision then
    love.graphics.clear()
  else
    for i, v in ipairs(shit) do
      v.y = v.y + v.yspeed * dt + jetpack.yspeed * dt
      if v.y > window_height then
        table.remove(shit, i)
      end
    end
    
    for i, v in ipairs(obstacles) do
      v.x = v.x - v.speed * dt
      if v.x < -50 then
        table.remove(obstacles, i)
      end
    end
    
    if love.keyboard.isDown("space") then
      spawn_timer = spawn_timer + dt
      if spawn_timer >= spawn_delay then
        createshit()
        spawn_timer = 0
      end
      jetpack.y = jetpack.y - jetpack.yspeed * dt
      suspension_timer = 0 
      jetpack.gravity = 300 
    else
      suspension_timer = suspension_timer + dt
      if suspension_timer >= suspension_delay then
        jetpack.y = jetpack.y + jetpack.gravity * dt
        jetpack.gravity = jetpack.gravity + jetpack.acceleration * dt 
      end
    end
    
    check_collision()
  end
end

function check_collision()
  if jetpack.y < 10 then
    jetpack.y = 10
  elseif jetpack.y > window_height - jetpack.height - 20 then
    jetpack.y = window_height - jetpack.height - 20
  end
  for i, v in ipairs(obstacles) do
    if jetpack.x + jetpack.width > v.x and jetpack.x < v.x + v.width  and
       jetpack.y + jetpack.height > v.y and jetpack.y < v.y + v.height * 0 then
      collision = true
      return
    end
  end
  collision = false
end

function create_stage()
  love.graphics.rectangle('fill', 0, window_height - 10, window_width, 10)
  love.graphics.rectangle('fill', 0, 0, window_width, 10)
end

function create_obstacles()
  if #obstacles < max_obstacles then
    local obs = {}
    obs.x = window_width
    obs.y = math.random(20, window_height - 192 * 0.1 - 20)
    obs.speed = 300
    obs.width = 68
    obs.height = 137
    table.insert(obstacles, obs)
  end
end

function love.draw()
  create_stage()
  love.graphics.draw(jetpacksprite, jetpack.x, jetpack.y, 0, 0.2, 0.2)
  for i, v in ipairs(shit) do
    love.graphics.setColor(0.588,0.29,0)
    love.graphics.circle("fill", v.x, v.y, 5)
    love.graphics.setColor(1,1,1)
  end
  for i, v in ipairs(obstacles) do
    love.graphics.draw(obs_sprite, v.x, v.y, 0)
  end
end
