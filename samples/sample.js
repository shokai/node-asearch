// const Asearch = require('asearch')
const Asearch = require('../')

console.log("== example 1")
const match = Asearch('abcde')
console.log(match('abcde')) // => true
console.log(match('AbCdE')) // => true
console.log(match('abcd')) // => false
console.log(match('abcd', 1)) // => true
console.log(match('ab de', 1)) // => true
console.log(match('abe', 1)) // => false
console.log(match('abe', 2)) // => true

console.log("== example 2")
const match2 = Asearch('cheese burger')
console.log(match2('cheese burger')) // => true
console.log(match2('chess burger', 2)) // => true
console.log(match2('chess', 2)) // => false

console.log("== example 3")
const match3 = Asearch('漢字文字列')
console.log(match3('漢字文字列')) // => true
console.log(match3('漢字の文字列')) // => false
console.log(match3('漢字の文字列', 1)) // => true
