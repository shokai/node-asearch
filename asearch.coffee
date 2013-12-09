{jspack} = require 'jspack'

module.exports = class Asearch

  INITPAT = 0x80000000
  MAXCHAR = 0x100

  isupper: (c) ->
    return (c >= 0x41) and (c <= 0x5a)

  islower: (c) ->
    return (c >= 0x61) and (c <= 0x7a)

  tolower: (c) ->
    return if (@isupper c) then (c + 0x20) else c

  toupper: (c) ->
    return if (@islower c) then (c - 0x20) else c

  constructor: (pat) ->
    @shiftpat = []
    @epsilon = 0
    @acceptpat = 0
    mask = INITPAT
    for c in [0...MAXCHAR]
      @shiftpat[c] = 0
    for c in jspack.Unpack 'B', pat
      if c is 0x20
        @epsilon |= mask
      else
        @shiftpat[c] |= mask
        @shiftpat[@toupper c] |= mask
        @shiftpat[@tolower c] |= mask
        mask >>= 1
    @acceptpat = mask
    return @

  initstate: ->
    return [].concat [INITPAT, 0, 0, 0]

  state: (state = null, str = '') ->
    state = @initstate() if state is null
    i0 = state[0]
    i1 = state[1]
    i2 = state[2]
    i3 = state[3]
    for c in jspack.Unpack 'B', str
      mask = @shiftpat[c]
      i3 = (i3 & @epsilon) | ((i3 & mask) >> 1) | (i2 >> 1) | i2
      i2 = (i2 & @epsilon) | ((i2 & mask) >> 1) | (i1 >> 1) | i1
      i1 = (i1 & @epsilon) | ((i1 & mask) >> 1) | (i0 >> 1) | i0
      i0 = (i0 & @epsilon) | ((i0 & mask) >> 1)
      i1 |= (i0 >> 1)
      i2 |= (i1 >> 1)
      i3 |= (i2 >> 1)

  match: (str, ambig = 0) ->
    s = @state @initstate(), str
    return (s[ambig] & @acceptpat) isnt 0

a = new Asearch 'abcde'
console.log a.match 'abcde'
console.log a.match 'abXcde', 1
