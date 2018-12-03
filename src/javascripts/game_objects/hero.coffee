Character = require './character.coffee'
HeroSlash = require './hero_slash.coffee'

class Hero extends Character
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame
    
    @children = []
    @state = 'normal'

    scene = @scene
    particleDeadZone = {
      contains: (x, y) ->
        for enemy in scene.enemies
          if enemy.body.hitTest(x, y)
            enemy.hit(0.1)
            return true
        
        tile = scene.map.getTileAtWorldXY(x, y)
        
        if tile
          tile.collides
        else
          false
    }
    
    particleDeathCallback = (particle) ->
      scene.remainsGraphics.drawBlood(particle.x, particle.y)

    @bloodEmitter = @scene.add.particles('pixel').createEmitter(
      x: 100
      y: 200
      lifespan: 500
      speed: { min: 100, max: 250 }
      on: false
      gravityY: 100
      deathZone: { type: 'onEnter', source: particleDeadZone }
      deathCallback: particleDeathCallback
    )
    @addChild(@bloodEmitter, @x, @y)
    
    @scene.input.on('pointerdown', @pointerdown, @)
    @scene.input.on('pointerup', @pointerup, @)
    @scene.input.on('pointermove', (pointer) ->
      if @bloodEmitter.active
        angle = Phaser.Math.Angle.Between(
          @x, @y, pointer.worldX, pointer.worldY
        ) * Phaser.Math.RAD_TO_DEG

        @bloodEmitter.setAngle(min: angle - 15, max: angle + 15)
    , @)

    @scene.add.updateList.add(@)
    
  preUpdate: (time, delta) ->
    super.preUpdate(time, delta)
    
    for child in @children
      child.setPosition(@x + child.relativeX, @y + child.relativeY)
    
    @body.setVelocity 0
    # Horizontal movement
    if @scene.keys.a.isDown
      @body.setVelocityX(-100)
      @flipX = false
      move = true
    else if @scene.keys.d.isDown
      @body.setVelocityX(100)
      @flipX = true
      move = true

    # Vertical movement
    if @scene.keys.w.isDown
      @body.setVelocityY(-100)
      move = true
    else if @scene.keys.s.isDown
      @body.setVelocityY(100)
      move = true
    
    if move && !@anims.isPlaying
      @anims.play(if @insane() then 'run_insane' else 'run')
    else if !move && @anims.isPlaying
      @anims.stop()

  pointerdown: (pointer) ->
    if @insane()
      @splash(pointer)
    else
      @slash(pointer)
      
  pointerup: (pointer) ->
    if @insane()
      @bloodEmitter.stop()

  addChild: (child, x, y) ->
    child.relativeX = (x || child.x) - @x
    child.relativeY = (y || child.y) - @y
    @children.push(child)

  destroyChild: (child) ->
    index = @children.indexOf(child)
    @children.splice(index, 1)
    child.destroy()
  
  slash: (pointer) ->
    return if @slashActive
    
    slashImage = @scene.add.gameObject(HeroSlash, @x, @y, 'slash')
    slashImage.anims.play('slash')

    angle = Phaser.Math.Angle.Between(@x, @y, pointer.worldX, pointer.worldY)
    Phaser.Actions.RotateAroundDistance([slashImage], @, angle, 10)
    slashImage.angle = angle * Phaser.Math.RAD_TO_DEG
    @addChild(slashImage)
    @slashActive = true
    slashImage.hit()

    @scene.time.addEvent(
      delay: 400
      callback: ->
        @slashActive = false
        @destroyChild(slashImage)
      callbackScope: @
    )
  
  splash: (pointer) ->
    @bloodEmitter.start()
  
  insane: ->
    @state == 'insane'
  
  turnInsane: ->
    @state = 'insane'
    @setFrame(3)
    
module.exports = Hero
