class RemainsGraphics extends Phaser.GameObjects.Graphics
  constructor: (scene, options) ->
    super(scene, options)
  
  drawBlood: (x, y, w = 1, h = 1) ->
    @fillStyle(0xff0000)
    @fillRect(x, y, w, h)

module.exports = RemainsGraphics
