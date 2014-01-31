process.env.NODE_ENV = 'test'

path = require 'path'
assert = require 'assert'
Asearch = require path.resolve()

describe 'pattern "abcde"', ->

  a = new Asearch 'abcde'

  it 'should have property "source"', ->
    assert.equal a.source, 'abcde'

  it 'should match "abcde"', ->
    assert.equal a.match('abcde'), true

  it 'should match "aBCDe"', ->
    assert.equal a.match('aBCDe'), true

  it 'should match ("abXcde",1)', ->
    assert.equal a.match('abXcde',1), true

  it 'should match ("ab?de",1)', ->
    assert.equal a.match('ab?de',1), true

  it 'should match ("abde",1)', ->
    assert.equal a.match('abde',1), true

  it 'should match (abXXde,2)', ->
    assert.equal a.match('abXXde',2), true

  it 'should not match "abXcde"', ->
    assert.equal a.match('abXcde'), false

  it 'should not match "ab?de"', ->
    assert.equal a.match('ab?de'), false

  it 'should not match "abde"', ->
    assert.equal a.match('abde'), false

  it 'should not match ("abXXde",1)', ->
    assert.equal a.match('abXXde',1), false


describe 'pattern "ab de"', ->

  a = new Asearch 'ab de'

  it 'should match ("abcde")', ->
    assert.equal a.match('abcde'), true

  it 'should match ("abccde")', ->
    assert.equal a.match('abccde'), true

  it 'should match ("abXXXXXXXde")', ->
    assert.equal a.match('abXXXXXXXde'), true

  it 'should match ("abcccccxe",1)', ->
    assert.equal a.match('abcccccxe',1), true

  it 'should not match "abcccccxe"', ->
    assert.equal a.match('abcccccxe'), false


describe 'pattern "abcde"', ->

  a = new Asearch 'abcde'

  it 'should match "abcde"', ->
    assert.equal a.match('abcde'), true

  it 'should match ("abcde",1)', ->
    assert.equal a.match('abcde',1), true

  it 'should not match "abcd"', ->
    assert.equal a.match('abcd'), false

  it 'should match ("abcd",1)', ->
    assert.equal a.match('abcd',1), true


describe 'pattern "漢字文字列"', ->

  a = new Asearch '漢字文字列'

  it 'should match "漢字文字列"', ->
    assert.equal a.match('漢字文字列'), true

  it 'should not match "漢字文字"', ->
    assert.equal a.match('漢字文字'), false

  it 'should match ("漢字文字",2)', ->
    assert.equal a.match('漢字文字',2), true

  it 'should not match "漢字文字烈"', ->
    assert.equal a.match("漢字文字烈"), false

  it 'should match ("漢字文字烈",2)', ->
    assert.equal a.match("漢字文字烈",2), true

  it 'should not match ("漢和辞典",2)', ->
    assert.equal a.match("漢和辞典",2), false

