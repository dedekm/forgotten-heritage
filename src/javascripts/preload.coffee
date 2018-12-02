module.exports = ->
  @load.image('tiles', 'http://labs.phaser.io/assets/tilemaps/tiles/catastrophi_tiles_16.png')
  @load.image('arrow', 'http://labs.phaser.io/assets/sprites/arrow.png')
  @load.tilemapCSV('map', 'http://labs.phaser.io/assets/tilemaps/csv/catastrophi_level2.csv')
  @load.spritesheet('player', 'http://labs.phaser.io/assets/sprites/spaceman.png', frameWidth: 16, frameHeight: 16)
