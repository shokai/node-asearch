process.env.NODE_ENV = 'test'

path = require 'path'
assert = require 'assert'

describe 'test', ->

  script = require path.resolve()

  it 'should be hoge', ->
    return assert.equal 'hoge', script()
