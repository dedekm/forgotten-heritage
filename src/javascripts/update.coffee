module.exports = (time) ->
  
  for emitter in @enemyEmitter
    if time - emitter.counter > 4000
      emitter.createEnemy() if emitter.active
      emitter.counter = time
