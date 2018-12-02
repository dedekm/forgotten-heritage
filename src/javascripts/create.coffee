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
    key: 'map'
  )

  tileset = @map.addTilesetImage('tileset', 'tiles')
  layer = @map.createStaticLayer('static', tileset, 0, 0)
  layer_bushes = @map.createDynamicLayer('dynamic', tileset, 0, 0)
  @map.setCollision([196, 251])

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

  @hero = @add.gameObject(Hero, 12 * 16, 57 * 16, 'gardener', 1)
  @physics.add.existing(@hero)
  @hero.body.setSize(12, 14, true)
  
  @physics.add.collider(@hero, [layer, layer_bushes])
  @cameras.main.setBounds(0, 0, @map.widthInPixels, @map.heightInPixels)
  @cameras.main.startFollow(@hero)

  debugGraphics = @add.graphics()
  @input.keyboard.on 'keydown_C', (event) ->
    showDebug = !showDebug
    drawDebug(map, debugGraphics)
    return

  @keys = this.input.keyboard.addKeys('w,s,a,d')
