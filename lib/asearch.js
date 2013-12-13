(function() {
  var Asearch;

  module.exports = Asearch = (function() {
    var INITPAT, INITSTATE, MAXCHAR;

    INITPAT = 0x80000000;

    MAXCHAR = 0x100;

    INITSTATE = [INITPAT, 0, 0, 0];

    Asearch.prototype.isupper = function(c) {
      return (c >= 0x41) && (c <= 0x5a);
    };

    Asearch.prototype.islower = function(c) {
      return (c >= 0x61) && (c <= 0x7a);
    };

    Asearch.prototype.tolower = function(c) {
      if (this.isupper(c)) {
        return c + 0x20;
      } else {
        return c;
      }
    };

    Asearch.prototype.toupper = function(c) {
      if (this.islower(c)) {
        return c - 0x20;
      } else {
        return c;
      }
    };

    function Asearch(pat) {
      var c, mask, _i, _j, _len, _ref;
      this.shiftpat = [];
      this.epsilon = 0;
      this.acceptpat = 0;
      mask = INITPAT;
      for (c = _i = 0; 0 <= MAXCHAR ? _i < MAXCHAR : _i > MAXCHAR; c = 0 <= MAXCHAR ? ++_i : --_i) {
        this.shiftpat[c] = 0;
      }
      _ref = this.unpack(pat);
      for (_j = 0, _len = _ref.length; _j < _len; _j++) {
        c = _ref[_j];
        if (c === 0x20) {
          this.epsilon |= mask;
        } else {
          this.shiftpat[c] |= mask;
          this.shiftpat[this.toupper(c)] |= mask;
          this.shiftpat[this.tolower(c)] |= mask;
          mask >>>= 1;
        }
      }
      this.acceptpat = mask;
      return this;
    }

    Asearch.prototype.state = function(state, str) {
      var c, i0, i1, i2, i3, mask, _i, _len, _ref;
      if (state == null) {
        state = INITSTATE;
      }
      if (str == null) {
        str = '';
      }
      i0 = state[0];
      i1 = state[1];
      i2 = state[2];
      i3 = state[3];
      _ref = this.unpack(str);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        c = _ref[_i];
        mask = this.shiftpat[c];
        i3 = (i3 & this.epsilon) | ((i3 & mask) >>> 1) | (i2 >>> 1) | i2;
        i2 = (i2 & this.epsilon) | ((i2 & mask) >>> 1) | (i1 >>> 1) | i1;
        i1 = (i1 & this.epsilon) | ((i1 & mask) >>> 1) | (i0 >>> 1) | i0;
        i0 = (i0 & this.epsilon) | ((i0 & mask) >>> 1);
        i1 |= i0 >>> 1;
        i2 |= i1 >>> 1;
        i3 |= i2 >>> 1;
      }
      return [i0, i1, i2, i3];
    };

    Asearch.prototype.match = function(str, ambig) {
      var s;
      if (ambig == null) {
        ambig = 0;
      }
      s = this.state(INITSTATE, str);
      if (!(ambig < INITSTATE.length)) {
        ambig = INITSTATE.length - 1;
      }
      return (s[ambig] & this.acceptpat) !== 0;
    };

    Asearch.prototype.unpack = function(str) {
      var bytes, c, code, _i, _len, _ref;
      bytes = [];
      _ref = str.split(/(?:)/);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        c = _ref[_i];
        code = c.charCodeAt(0);
        if (code > 0xFF) {
          bytes.push((code & 0xFF00) >>> 8);
        }
        bytes.push(code & 0xFF);
      }
      return bytes;
    };

    return Asearch;

  })();

}).call(this);
