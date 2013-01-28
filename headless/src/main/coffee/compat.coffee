###
### stuff in this file papers over differences between Rhino and other
### JS implementations such as Node as the ones in browsers.
###
### on Rhino, the goal is precisely bit-for-bit identical results as
### JVM NetLogo.  on other JS impls, "close enough" is close enough
###

# from: http://coffeescriptcookbook.com/chapters/arrays/filtering-arrays
# this works with the coffee command, but is absent in Rhino.
unless Array::filter
  Array::filter = (callback) ->
    element for element in this when callback(element)

# Rhino has "print" and "println", V8 and browsers have "console.log".  we use println,
# so ensure it is present
unless println
  println = console.log

# surprisingly difficult to ask if something is an array or not
typeIsArray = (value) ->
  value and
  typeof value is 'object' and
  value instanceof Array and
  typeof value.length is 'number' and
  typeof value.splice is 'function' and
  not ( value.propertyIsEnumerable 'length' )

# on Rhino, we provide this via MersenneTwisterFast.  in the browser,
# we delegate to Math.random(), for speed.  we could swap in a JS
# implementation of the Mersenne Twister (code for it is googlable),
# but I fear (though have not measured) the performance impact
unless Random
  Random = {}
  Random.nextInt = (limit) -> Math.floor(Math.random() * limit)
  Random.nextLong = Random.nextInt
  Random.nextDouble = -> Math.random()

# on Rhino, we use the JVM StrictMath stuff so results are identical
# with regular NetLogo. in browser, be satisfied with "close enough"
unless StrictMath
  StrictMath = Math
  Math.toRadians = (degrees) ->
    degrees * Math.PI / 180
