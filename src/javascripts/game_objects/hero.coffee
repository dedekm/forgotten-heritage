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
    @healthBar.setScrollFactor(0)
    
    scene = @scene
    particleDeadZone = {
      contains: (x, y) ->
        for enemy in scene.enemies.getChildren()
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
    
    @drawHealthBar()
    
    for child in @children
      child.setPosition(@x + child.relativeX, @y + child.relativeY)
    
    if @insane()
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
      else if !move && @anims.isPlaying
        @anims.stop()

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
    @bloodEmitter.start()
  
  grabHeart: (pointer) ->
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
  
  turnInsane: ->
    @state = 'insane'
    @setFrame(3)
  
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
