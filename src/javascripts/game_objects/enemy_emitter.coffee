Enemy = require './enemy.coffee'

class EnemyEmitter extends Phaser.GameObjects.GameObject
  constructor: (scene, x, y) ->
    super scene
    
    @x = x
    @y = y
    
  createEnemy: (key) ->
    enemy = @scene.add.gameObject(Enemy, @x, @y, 'aztec1', 0)
    @scene.physics.add.existing(enemy)
    enemy.body.setSize(12, 20)
    enemy.body.setOffset(4, 4)
    enemy.body.immovable = true
    
    @scene.enemies.add(enemy)

module.exports = EnemyEmitter
