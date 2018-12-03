GameObject = require './game_object.coffee'

class Character extends GameObject
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame
    
    @health = 1
  
  hit: (value) ->
    @health -= value
    
  die: ->
    @destroy()
    
  preUpdate: (time, delta) ->
    super.preUpdate(time, delta)
    
    if @health <= 0
      @die()
    
module.exports = Character
