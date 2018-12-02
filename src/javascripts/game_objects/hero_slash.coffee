class HeroSlash extends Phaser.GameObjects.Sprite
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame

  hit: ->
    tileX = @scene.bushes.worldToTileX(@x)
    tileY = @scene.bushes.worldToTileY(@y)
    tile = @scene.bushes.getTileAt(tileX, tileY)

    # TODO: use bush tile
    if tile && tile.index == 59
      @scene.bushes.putTileAt(41, tileX, tileY)

module.exports = HeroSlash
