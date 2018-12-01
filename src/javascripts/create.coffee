Hero = require './game_objects/hero.coffee'

showDebug = false
drawDebug = (map, debugGraphics) ->
  debugGraphics.clear()
  if showDebug
    map.renderDebug debugGraphics,
      tileColor: null
      collidingTileColor: new (Phaser.Display.Color)(243, 134, 48, 200)
      faceColor: new (Phaser.Display.Color)(40, 39, 37, 255)
  return

module.exports = ->
  @keys = @input.keyboard.addKeys('W,S,A,D')

  map = @make.tilemap(
    key: 'map'
    tileWidth: 16
    tileHeight: 16
  )
  tileset = map.addTilesetImage('tiles')
  layer = map.createStaticLayer(0, tileset, 0, 0)
  
  map.setCollisionBetween(54, 83)

  @anims.create(
    key: 'left'
    frames: @anims.generateFrameNumbers('player', start: 8, end: 9)
    frameRate: 10
    repeat: -1
  )
  @anims.create(
    key: 'right'
    frames: @anims.generateFrameNumbers('player', start: 1, end: 2)
    frameRate: 10
    repeat: -1
  )
  @anims.create(
    key: 'up'
    frames: @anims.generateFrameNumbers('player', start: 11, end: 13)
    frameRate: 10
    repeat: -1
  )
  @anims.create(
    key: 'down'
    frames: @anims.generateFrameNumbers('player', start: 4, end: 6)
    frameRate: 10
    repeat: -1
  )
  
  @hero = @add.gameObject(Hero, 50, 100, 'player', 1)
  @physics.add.existing(@hero)
  
  # Set up the player to collide with the tilemap layer. Alternatively, you can manually run
  # collisions in update via: this.physics.world.collide(player, layer)
  @physics.add.collider(@hero, layer)
  @cameras.main.setBounds(0, 0, map.widthInPixels, map.heightInPixels)
  @cameras.main.startFollow(@hero)

  debugGraphics = @add.graphics()
  @input.keyboard.on 'keydown_C', (event) ->
    showDebug = !showDebug
    drawDebug(map, debugGraphics)
    return

  @keys = this.input.keyboard.addKeys('w,s,a,d')
