Character = require './character.coffee'
HeroSlash = require './hero_slash.coffee'
HeroGrab = require './hero_grab.coffee'

class Hero extends Character
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame
    
    @children = []
    @state = 'normal'
    
    @on('animationcomplete', (sprite) ->
      if sprite.key == 'grab'
        @anims.play('hold')
        @scene.time.addEvent(
          delay: 200
          callback: ->
            @health += 0.1
            @paused = false
            @anims.stop()
            @setFrame(3)
          callbackScope: @
        )
    , @)
    
    @slashReady = true
    @grabReady = true
    @grabZone = @scene.add.gameObject(HeroGrab, @x, @y)
        
    @healthBar = @scene.add.graphics()
    @healthBar.visible = false
    @healthBar.setScrollFactor(0)
    
    scene = @scene
    particleDeadZone = {
      contains: (x, y) ->
        for enemy in scene.enemies.getChildren()
          if enemy.body.hitTest(x, y)
            enemy.hit(0.075)
            return true
        
        # TODO
        # tile = scene.map.getTileAtWorldXY(x, y)
        #
        # if tile
        #   tile.collides
        # else
        #   false
    }
    
    @bloodEmitter = @scene.add.particles('pixel').createEmitter(
      x: 100
      y: 200
      lifespan: 500
      speed: { min: 100, max: 250 }
      on: false
      gravityY: 100
      deathZone: { type: 'onEnter', source: particleDeadZone }
      deathCallback: @scene.remainsGraphics.particleDeathCallback
      deathCallbackScope: @scene.remainsGraphics
    )
    @addChild(@bloodEmitter, @x, @y - 1)
    
    @scene.input.mouse.disableContextMenu()
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
    
    if @insane()
      if @splashing
        @health -= 0.0025
      @drawHealthBar()
      @bloodEmitter.x.propertyValue += if @flipX then 6 else -6
    
    @body.setVelocity 0
    
    unless @paused
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
        @scene.sounds.run.play(loop: true)
      else if !move && @anims.isPlaying
        @anims.stop()
        @scene.sounds.run.stop()

  pointerdown: (pointer) ->
    unless @paused
      if pointer.leftButtonDown()
        if @insane()
          @splash(pointer)
        else
          @slash(pointer)
      
      if pointer.rightButtonDown() && @insane()
        @grabHeart(pointer)
      
  pointerup: (pointer) ->
    if @insane()
      @splashing = false
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
    return unless @slashReady
    
    slashImage = @scene.add.gameObject(HeroSlash, @x, @y, 'slash')
    slashImage.anims.play('slash')
    @rotateObjectInMouseDirection(slashImage, pointer)
    @addChild(slashImage)
    @slashReady = false
    slashImage.hit()

    @scene.time.addEvent(
      delay: 400
      callback: ->
        @slashReady = true
        @destroyChild(slashImage)
      callbackScope: @
    )
  
  splash: (pointer) ->
    @splashing = true
    @bloodEmitter.start()
  
  grabHeart: (pointer) ->
    if @insane()
      @splashing = false
      @bloodEmitter.stop()
      @grabZone.setPosition(@x, @y)
      @rotateObjectInMouseDirection(@grabZone, pointer, false)
      @grabReady = false
    
    
      @scene.time.addEvent(
        delay: 100
        callback: ->
          @grabZone.moveAway()
          @grabReady = true
        callbackScope: @
      )
  
  insane: ->
    @state == 'insane'

  dead: ->
    @state == 'dead'
  
  turnInsane: ->
    @paused = true
    @scene.sounds.scream.play(volume: 0.7)
    
    graphics = @scene.add.graphics()
    graphics.fillStyle(0xff1111)
    graphics.fillRect(
      @scene.cameras.main.worldView.x,
      @scene.cameras.main.worldView.y,
      @scene.cameras.main.worldView.width,
      @scene.cameras.main.worldView.height,
    )
    @scene.map.walls.setVisible(true)
    @scene.physics.add.collider(@scene.map.walls, [@, @scene.enemies])
    
    @scene.time.addEvent(
      delay: 500
      callback: ->
        @paused = false
        @scene.sounds.background.metal.play(loop: true)
        
        graphics.destroy()
        for emitter in @scene.enemyEmitters
          emitter.active = true
      callbackScope: @
    )
    
    @scene.enemyEmitters[0].createEnemy()
    @healthBar.visible = true
    @state = 'insane'
    @setFrame(3)
  
  die: ->
    for emitter in @scene.enemyEmitters
      emitter.active = false
    
    bloodParticle = @scene.add.particles('pixel')
    emitter = bloodParticle.createEmitter(
      x: @x
      y: @y
      lifespan: 400
      speed: { min: 10, max: 100 }
      frequency: 3
      gravityY: 150
      deathCallback: @scene.remainsGraphics.particleDeathCallback
      deathCallbackScope: @scene.remainsGraphics
    )
    
    @scene.time.addEvent(
      delay: 3000
      callback: ->
        bloodParticle.destroy()
    )
    
    @state = 'dead'
    @splashing = false
    @bloodEmitter.stop()
    
    # FIXME: errors after death
    super.die()
  
  rotateObjectInMouseDirection: (object, pointer, changeAngle = true) ->
    angle = Phaser.Math.Angle.Between(@x, @y, pointer.worldX, pointer.worldY)
    Phaser.Actions.RotateAroundDistance([object], @, angle, 10)
    if changeAngle
      object.angle = angle * Phaser.Math.RAD_TO_DEG
  
  drawHealthBar: () ->
    w = (@scene.cameras.main.worldView.width - 8) * @health
    @healthBar.clear()
    @healthBar.fillStyle(0xff0000)
    @healthBar.fillRect(
      4,
      @scene.cameras.main.worldView.height - 6,
      w,
      2
    )
    
module.exports = Hero
