class HeroSlash extends Phaser.GameObjects.Sprite
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame

  hit: ->
    tileX = @scene.map.worldToTileX(@x)
    tileY = @scene.map.worldToTileY(@y)
    tile = @scene.map.getTileAt(tileX, tileY)
      
    if tile && [196, 251].includes(tile.index)
      @scene.sounds.slashBush.play()
      @scene.map.putTileAt(231, tileX, tileY)

module.exports = HeroSlash
