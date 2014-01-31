module.exports = class Asearch

  INITPAT = 0x80000000
  MAXCHAR = 0x100
  INITSTATE = [INITPAT, 0, 0, 0]

  isupper: (c) ->
    return (c >= 0x41) and (c <= 0x5a)

  islower: (c) ->
    return (c >= 0x61) and (c <= 0x7a)

  tolower: (c) ->
    return if (@isupper c) then (c + 0x20) else c

  toupper: (c) ->
    return if (@islower c) then (c - 0x20) else c

  constructor: (@source) ->
    @shiftpat = []
    @epsilon = 0
    @acceptpat = 0
    mask = INITPAT
    for c in [0...MAXCHAR]
      @shiftpat[c] = 0
    for c in @unpack(@source)
      if c is 0x20
        @epsilon |= mask
      else
        @shiftpat[c] |= mask
        @shiftpat[@toupper c] |= mask
        @shiftpat[@tolower c] |= mask
        mask >>>= 1
    @acceptpat = mask
    return @


  state: (state=INITSTATE, str = '') ->
    i0 = state[0]
    i1 = state[1]
    i2 = state[2]
    i3 = state[3]
    for c in @unpack(str)
      mask = @shiftpat[c]
      i3 = (i3 & @epsilon) | ((i3 & mask) >>> 1) | (i2 >>> 1) | i2
      i2 = (i2 & @epsilon) | ((i2 & mask) >>> 1) | (i1 >>> 1) | i1
      i1 = (i1 & @epsilon) | ((i1 & mask) >>> 1) | (i0 >>> 1) | i0
      i0 = (i0 & @epsilon) | ((i0 & mask) >>> 1)
      i1 |= (i0 >>> 1)
      i2 |= (i1 >>> 1)
      i3 |= (i2 >>> 1)
    return [i0, i1, i2, i3]

  match: (str, ambig = 0) ->
    s = @state INITSTATE, str
    ambig = INITSTATE.length-1 unless ambig < INITSTATE.length
    return (s[ambig] & @acceptpat) != 0

  unpack: (str) ->
    bytes = []
    for c in str.split(//)
      code = c.charCodeAt(0)
      bytes.push((code & 0xFF00) >>> 8) if code > 0xFF
      bytes.push(code & 0xFF)
    return bytes
 
