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

  @map = @make.tilemap(
    key: 'map_base'
    tileWidth: 16
    tileHeight: 16
  )

  tileset = @map.addTilesetImage('tiles')
  layer = @map.createStaticLayer(0, tileset, 0, 0)
  @map.setCollisionBetween(54, 83)

  @bushes = @make.tilemap(
    key: 'map_bushes'
    tileWidth: 16
    tileHeight: 16
  )
  tileset = @bushes.addTilesetImage('tiles')
  bushesLayer =  @bushes.createDynamicLayer(0, tileset, 0, 0)
  @bushes.setCollisionBetween(54, 83)

  @anims.create(
    key: 'run'
    frames: @anims.generateFrameNumbers('gardener', start: 0, end: 1)
    frameRate: 10
    repeat: -1
  )
  @anims.create(
    key: 'run_insane'
    frames: @anims.generateFrameNumbers('gardener', start: 2, end: 3)
    frameRate: 10
    repeat: -1
  )
  @anims.create(
    key: 'slash'
    frames: @anims.generateFrameNumbers('slash')
    frameRate: 10
    repeat: -1,
    yoyo: true
  )

  @hero = @add.gameObject(Hero, 50, 100, 'gardener', 1)
  @physics.add.existing(@hero)
  
  # Set up the player to collide with the tilemap layer. Alternatively, you can manually run
  # collisions in update via: this.physics.world.collide(player, layer)
  @physics.add.collider(@hero, layer)
  @physics.add.collider(@hero, bushesLayer)
  @cameras.main.setBounds(0, 0, @map.widthInPixels, @map.heightInPixels)
  @cameras.main.startFollow(@hero)

  debugGraphics = @add.graphics()
  @input.keyboard.on 'keydown_C', (event) ->
    showDebug = !showDebug
    drawDebug(map, debugGraphics)
    return

  @keys = this.input.keyboard.addKeys('w,s,a,d')
