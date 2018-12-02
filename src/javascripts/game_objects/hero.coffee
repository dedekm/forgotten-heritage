GameObject = require './game_object.coffee'

class Hero extends GameObject
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame
    
    @children = []
    @scene.input.on('pointerdown', @pointerdown, @)

    map = @scene.map
    particleDeadZone = {
      contains: (x, y) ->
        map.getTileAtWorldXY(x, y).collides
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

    @scene.input.on('pointermove', (pointer) ->
      if @bloodEmitter.active
        angle = Phaser.Math.Angle.Between(@x, @y, pointer.x, pointer.y) * Phaser.Math.RAD_TO_DEG
        
        @bloodEmitter.setAngle({min: angle - 20, max: angle + 20})
    , @)

    @scene.add.updateList.add(@)
    
  preUpdate: () ->
    for child in @children
      child.setPosition(@x + child.relativeX, @y + child.relativeY)
      
    @body.setVelocity 0
    # Horizontal movement
    if @scene.keys.a.isDown
      @body.setVelocityX -100
    else if @scene.keys.d.isDown
      @body.setVelocityX 100
    # Vertical movement
    if @scene.keys.w.isDown
      @body.setVelocityY -100
    else if @scene.keys.s.isDown
      @body.setVelocityY 100

    if @scene.keys.a.isDown
      @anims.play 'left', true
    else if @scene.keys.d.isDown
      @anims.play 'right', true
    else if @scene.keys.w.isDown
      @anims.play 'up', true
    else if @scene.keys.s.isDown
      @anims.play 'down', true
    else
      @anims.stop()
  
  pointerdown: (pointer) ->
    return if @slash
    
    slashImage = @scene.add.image(@x, @y, 'arrow')
    angle = Phaser.Math.Angle.Between(@x, @y, pointer.x, pointer.y)
    Phaser.Actions.RotateAroundDistance([slashImage], @, angle, 50)
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
