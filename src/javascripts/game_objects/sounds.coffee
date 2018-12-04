class Sounds extends Object
  constructor: (scene) ->
    super()
    
    @scene = scene
    
    @background = {
      garden: @scene.sound.add('background_garden')
      jungle: @scene.sound.add('background_jungle')
      voice: @scene.sound.add('background_voice')
    }
    @run = @scene.sound.add('run')
    @slashBush = @scene.sound.add('slash_bush')
    @slashAir = @scene.sound.add('slash_air')
    
module.exports = Sounds
