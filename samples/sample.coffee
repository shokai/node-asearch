Asearch = require '../'
# Asearch = require 'asearch'

console.log "== example 1"
a = new Asearch 'abcde'
console.log a.match 'abcde' # => true
console.log a.match 'AbCdE' # => true
console.log a.match 'abcd' # => false
console.log a.match 'abcd', 1 # => true
console.log a.match 'ab de', 1 # => true
console.log a.match 'abe', 1 # => false
console.log a.match 'abe', 2 # => true

console.log "== example 2"
a = new Asearch 'cheese burger'
console.log a.match 'cheese burger' # => true
console.log a.match 'chess burger', 2 # => true
console.log a.match 'chess', 2 # => false

console.log "== example 3"
a = new Asearch '漢字文字列'
console.log a.match '漢字文字列' # => true
console.log a.match '漢字文字烈' # => false
console.log a.match '漢字文字烈', 2 # => true
