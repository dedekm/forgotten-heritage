Character = require './character.coffee'

class Enemy extends Character
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame

    @needsTint = false
  
  hit: (value) ->
    super.hit(value)

    @needsTint = true
  
  preUpdate: (time, delta) ->
    super.preUpdate(time, delta)

    if @needsTint
      gb = 255 * @health
      @setTint(new Phaser.Display.Color(255, gb, gb).color)
      @needsTint = false

module.exports = Enemy