process.env.NODE_ENV = 'test'

path = require 'path'
assert = require 'assert'
Asearch = require path.resolve()

describe 'pattern "abcde"', ->

  a = new Asearch 'abcde'

  it 'should match', ->
    assert.equal a.match('abcd'), true
    assert.equal a.match('aBCDe'), true
    assert.equal a.match('abXcde',1), true
    assert.equal a.match('ab?de',1), true
    assert.equal a.match('abde',1), true
    assert.equal a.match('abXXde',2), true

  it 'should not match', ->
    assert.equal a.match('abXcde'), false
    assert.equal a.match('ab?de'), false
    assert.equal a.match('abde'), false
    assert.equal a.match('abXXde',1), false


describe 'pattern "ab de"', ->

  a = new Asearch 'ab de'

  it 'should match', ->
    assert.equal a.match('abcde'), true
    assert.equal a.match('abccde'), true
    assert.equal a.match('abXXXXXXXde'), true
    assert.equal a.match('abcccccxe',1), true

  it 'should not match', ->
    assert.equal a.match('abcccccxe'), false


describe 'state transition of pattern "abcde"', ->

  a = new Asearch 'abcde'

  it 'should have state', ->
    initstate = a.initstate
    laststate = a.state(initstate, 'abcde')
    assert.notEqual(laststate[0] & a.acceptpat, 0)


describe 'state of pattern "abc"', ->

  a = new Asearch 'abc'

  it 'should have state', ->
    state = a.initstate
    assert.notEqual state[0], 0
    assert.equal state[1], 0
    assert.equal state[2], 0


describe 'ambiguity argument of "match()" method', ->

  a = new Asearch 'abcde'

  it 'should match', ->
    assert.equal a.match('abcde'), true
    assert.equal a.match('abcde',1), true
    assert.equal a.match('abcd',1), true

  it 'should not match', ->
    assert.equal a.match('abcd'), false


describe 'test of complex internal states', ->

  a = new Asearch 'abcde'
 
  it 'should test complex states', ->
    initstate = a.initstate
    laststate = a.state(initstate,'abcde')
    assert.notEqual (laststate[0] & a.acceptpat), 0
    laststate = a.state(initstate,'abcdf')   # 1文字置換
    assert.equal (laststate[0] & a.acceptpat), 0
    assert.notEqual (laststate[1] & a.acceptpat), 0
    assert.notEqual (laststate[2] & a.acceptpat), 0
    laststate = a.state(initstate,'abde')    # 1文字欠損
    assert.equal (laststate[0] & a.acceptpat), 0
    assert.notEqual (laststate[1] & a.acceptpat), 0
    assert.notEqual (laststate[2] & a.acceptpat), 0
    laststate = a.state(initstate,'abcfg')   # 2文字置換
    assert.equal (laststate[0] & a.acceptpat), 0
    assert.equal (laststate[1] & a.acceptpat), 0
    assert.notEqual (laststate[2] & a.acceptpat), 0
    laststate = a.state(initstate,'abe')     # 2文字欠損
    assert.equal (laststate[0] & a.acceptpat), 0
    assert.equal (laststate[1] & a.acceptpat), 0
    assert.notEqual (laststate[2] & a.acceptpat), 0
    laststate = a.state(initstate,'axbcde')  # 1文字追加
    assert.equal (laststate[0] & a.acceptpat), 0
    assert.notEqual (laststate[1] & a.acceptpat), 0
    assert.notEqual (laststate[2] & a.acceptpat), 0
    laststate = a.state(initstate,'axbcyde') # 2文字追加
    assert.equal (laststate[0] & a.acceptpat), 0
    assert.equal (laststate[1] & a.acceptpat), 0
    assert.notEqual (laststate[2] & a.acceptpat), 0
    laststate = a.state(initstate,'ABCDF')   # 大文字
    assert.equal (laststate[0] & a.acceptpat), 0
    assert.notEqual (laststate[1] & a.acceptpat), 0
    assert.notEqual (laststate[2] & a.acceptpat), 0

describe 'test of wildcard', ->

  a = new Asearch ' abc def'

  it 'is wildcard test', ->
    initstate = a.initstate
    laststate = a.state(initstate,'abcdef')
    assert.notEqual (laststate[0] & a.acceptpat), 0
    initstate = a.initstate
    laststate = a.state(initstate,'abcXXXXdef')
    assert.notEqual (laststate[0] & a.acceptpat), 0
    initstate = a.initstate
    laststate = a.state(initstate,'abcXXXXYYY')
    assert.equal (laststate[0] & a.acceptpat), 0
    initstate = a.initstate
    laststate = a.state(initstate,'abcXXXXde')
    assert.equal (laststate[0] & a.acceptpat), 0
    assert.notEqual (laststate[1] & a.acceptpat), 0
    assert.notEqual (laststate[2] & a.acceptpat), 0
    initstate = a.initstate
    laststate = a.state(initstate,'ZZZZZabcdef')
    assert.notEqual (laststate[0] & a.acceptpat), 0


describe 'test of Kanji', ->

  a = new Asearch '漢字文字列'

  it 'is Kanji test', ->
    initstate = a.initstate
    laststate = a.state(initstate,'漢字文字列')
    assert.notEqual (laststate[0] & a.acceptpat), 0
    laststate = a.state(initstate,'漢字文字')
    assert.equal (laststate[0] & a.acceptpat), 0
    laststate = a.state(initstate,'漢字!文字列')
    assert.equal (laststate[0] & a.acceptpat), 0
    assert.notEqual (laststate[1] & a.acceptpat), 0
