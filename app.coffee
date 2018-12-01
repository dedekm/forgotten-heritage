createError     = require('http-errors')
express         = require('express')
minify          = require('express-minify')
browserify      = require('browserify-middleware')
coffeeify       = require('coffeeify')
exorcist        = require('exorcist')
path            = require('path')
cookieParser    = require('cookie-parser')
logger          = require('morgan')
sassMiddleware  = require('node-sass-middleware')

indexRouter     = require('./routes/index')

app = express()
# view engine setup
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'pug'
app.use logger('dev')
app.use express.json()
app.use express.urlencoded(extended: false)
app.use cookieParser()
app.use sassMiddleware(
  src: path.join(__dirname, 'src')
  dest: path.join(__dirname, 'public')
  indentedSyntax: true
  sourceMap: true
)

browserify.settings('transform', coffeeify)
app.get('/javascripts/base.js', browserify('./src/javascripts/base.coffee'))
app.use('/javascripts', express.static(path.join(__dirname, 'node_modules/phaser/dist')))
app.use express.static(path.join(__dirname, 'public'))

app.use '/', indexRouter

# catch 404 and forward to error handler
app.use (req, res, next) ->
  next createError(404)
  return

# error handler
app.use (err, req, res, next) ->
  # set locals, only providing error in development
  res.locals.message = err.message
  res.locals.error = if req.app.get('env') == 'development' then err else {}
  # render the error page
  res.status err.status or 500
  res.render 'error'
  return

module.exports = app
