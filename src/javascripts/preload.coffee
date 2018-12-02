module.exports = ->
  @game.canvas.style.width = (@game.config.width * @game.config.zoom).toString() + 'px'
  @game.canvas.style.height = (@game.config.height * @game.config.zoom).toString() + 'px'
  
  @load.image('tiles', 'http://labs.phaser.io/assets/tilemaps/tiles/catastrophi_tiles_16.png')
  @load.image('arrow', 'http://labs.phaser.io/assets/sprites/arrow.png')
  @load.tilemapCSV('map', 'http://labs.phaser.io/assets/tilemaps/csv/catastrophi_level2.csv')
  @load.spritesheet('gardener', '/images/gardener_16x17.png', frameWidth: 16, frameHeight: 17)

  graphics = @add.graphics()
  graphics.fillStyle(0xff0000, 1)
  graphics.fillRect(0, 0, 2, 2)
  texture = graphics.generateTexture('pixel', 2, 2)
