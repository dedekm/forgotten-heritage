GameObject = require './game_object.coffee'

class Hero extends GameObject
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame

    @setSize(14, 16, true)
    @children = []

    map = @scene.map
    particleDeadZone = {
      contains: (x, y) ->
        tile = map.getTileAtWorldXY(x, y)

        if tile
          tile.collides
        else
          false
    }

    @bloodEmitter = @scene.add.particles('pixel').createEmitter(
      x: 100
      y: 200
      lifespan: 1000
      angle: { min: 300, max: 315 }
      speed: { min: 100, max: 250 }
      active: true
      gravityY: 100
      deathZone: { type: 'onEnter', source: particleDeadZone }
    )
    @addChild(@bloodEmitter, @x, @y)
    
    @scene.input.on('pointerdown', @pointerdown, @)
    @scene.input.on('pointermove', (pointer) ->
      if @bloodEmitter.active
        angle = Phaser.Math.Angle.Between(
          @x, @y, pointer.worldX, pointer.worldY
        ) * Phaser.Math.RAD_TO_DEG

        @bloodEmitter.setAngle(min: angle - 20, max: angle + 20)
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
      @anims.play('run')
    else if !move && @anims.isPlaying
      @anims.stop()

  pointerdown: (pointer) ->
    return if @slash
    
    slashImage = @scene.add.sprite(@x, @y, 'slash')
    slashImage.anims.play('slash')

    angle = Phaser.Math.Angle.Between(@x, @y, pointer.worldX, pointer.worldY)
    Phaser.Actions.RotateAroundDistance([slashImage], @, angle, 12)
    slashImage.angle = angle * Phaser.Math.RAD_TO_DEG
    @addChild(slashImage)

    @scene.time.addEvent(
      delay: 400
      callback: ->
        @destroyChild(slashImage)
      callbackScope: @
    )

  addChild: (child, x, y) ->
    child.relativeX = (x || child.x) - @x
    child.relativeY = (y || child.y) - @y
    @children.push(child)

  destroyChild: (child) ->
    index = @children.indexOf(child)
    @children.splice(index, 1)
    child.destroy()
    
module.exports = Hero
