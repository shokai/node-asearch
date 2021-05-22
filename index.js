const INITPAT = 0x80000000
const MAXCHAR = 0x100
const INITSTATE = [INITPAT, 0, 0, 0]
const isupper = c => (c >= 0x41) && (c <= 0x5a)
const islower = c => (c >= 0x61) && (c <= 0x7a)
const tolower = c => isupper(c) ? (c + 0x20) : c
const toupper = c => islower(c) ? (c - 0x20) : c

module.exports = function Asearch (source) {
  const shiftpat = []
  let epsilon = 0
  let acceptpat = 0
  let mask = INITPAT
  for (let i = 0; i < MAXCHAR; i++) {
    shiftpat[i] = 0
  }
  for (let i of unpack(source)) {
    if (i === 0x20) {
      epsilon |= mask
    } else {
      shiftpat[i] |= mask
      shiftpat[toupper(i)] |= mask
      shiftpat[tolower(i)] |= mask
      mask = mask >>> 1
    }
  }
  acceptpat = mask

  function state (state=INITSTATE, str = '') {
    let i0 = state[0]
    let i1 = state[1]
    let i2 = state[2]
    let i3 = state[3]
    for (let c of unpack(str)) {
      mask = shiftpat[c]
      i3 = (i3 & epsilon) | ((i3 & mask) >>> 1) | (i2 >>> 1) | i2
      i2 = (i2 & epsilon) | ((i2 & mask) >>> 1) | (i1 >>> 1) | i1
      i1 = (i1 & epsilon) | ((i1 & mask) >>> 1) | (i0 >>> 1) | i0
      i0 = (i0 & epsilon) | ((i0 & mask) >>> 1)
      i1 |= (i0 >>> 1)
      i2 |= (i1 >>> 1)
      i3 |= (i2 >>> 1)
    }
    return [i0, i1, i2, i3]
  }

  function unpack (str) {
    const bytes = []
    for (let c of str.split('')) {
      const code = c.charCodeAt(0)
      if (code > 0xFF) {
        bytes.push((code & 0xFF00) >>> 8)
      }
      bytes.push(code & 0xFF)
    }
    return bytes
  }

  function match (str, ambig = 0) {
    const s = state(INITSTATE, str)
    if (ambig >= INITSTATE.length) {
      ambig = INITSTATE.length-1
    }
    return (s[ambig] & acceptpat) != 0
  }

  match.source = source

  return match
}
