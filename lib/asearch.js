(function() {
  var Asearch, jspack;

  jspack = require('jspack').jspack;

  module.exports = Asearch = (function() {
    var INITPAT, MAXCHAR;

    INITPAT = 0x80000000;

    MAXCHAR = 0x100;

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
      _ref = jspack.Unpack('B', pat);
      for (_j = 0, _len = _ref.length; _j < _len; _j++) {
        c = _ref[_j];
        if (c === 0x20) {
          this.epsilon |= mask;
        } else {
          this.shiftpat[c] |= mask;
          this.shiftpat[this.toupper(c)] |= mask;
          this.shiftpat[this.tolower(c)] |= mask;
          mask >>= 1;
        }
      }
      this.acceptpat = mask;
      return this;
    }

    Asearch.prototype.initstate = function() {
      return [].concat([INITPAT, 0, 0, 0]);
    };

    Asearch.prototype.state = function(state, str) {
      var c, i0, i1, i2, i3, mask, _i, _len, _ref, _results;
      if (state == null) {
        state = null;
      }
      if (str == null) {
        str = '';
      }
      if (state === null) {
        state = this.initstate();
      }
      i0 = state[0];
      i1 = state[1];
      i2 = state[2];
      i3 = state[3];
      _ref = jspack.Unpack('B', str);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        c = _ref[_i];
        mask = this.shiftpat[c];
        i3 = (i3 & this.epsilon) | ((i3 & mask) >> 1) | (i2 >> 1) | i2;
        i2 = (i2 & this.epsilon) | ((i2 & mask) >> 1) | (i1 >> 1) | i1;
        i1 = (i1 & this.epsilon) | ((i1 & mask) >> 1) | (i0 >> 1) | i0;
        i0 = (i0 & this.epsilon) | ((i0 & mask) >> 1);
        i1 |= i0 >> 1;
        i2 |= i1 >> 1;
        _results.push(i3 |= i2 >> 1);
      }
      return _results;
    };

    Asearch.prototype.match = function(str, ambig) {
      var s;
      if (ambig == null) {
        ambig = 0;
      }
      s = this.state(this.initstate(), str);
      return (s[ambig] & this.acceptpat) !== 0;
    };

    return Asearch;

  })();

}).call(this);
