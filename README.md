# Node Asearch
Approximate pattern matching on JavaScript

- https://github.com/shokai/node-asearch
- https://npmjs.org/package/asearch


## Install

    $ npm install asearch

## Usage

### API

```js
const Asearch = require('asearch')

const match = Asearch('abcde')

console.log(match('abcde'))    // => true
console.log(match('AbCdE'))    // => true
console.log(match('abcd'))     // => false
console.log(match('abcd', 1))  // => true
console.log(match('ab de', 1)) // => true
console.log(match('abe', 1))   // => false
console.log(a.match('abe', 2))   // => true
```

### CLI

> Usage: asearch left right [ambig]

```bash
$ asearch abcde abcde; echo $?
0  # true
$ asearch abcde abcd; echo $?
1  # false
$ asearch abcde abcd 1; echo $?
0  # true
$ asearch abcde; echo $?
Usage: asearch left right [ambig]
2  # Argument error
```

### Typo

```js
const match = Asearch('cheese burger')

console.log(match('cheese burger'))   // => true
console.log(match('chess burger'))    // => false
console.log(match('chess burger', 2)) // => true
console.log(match('chess', 2))        // => false
```

<img src="http://gyazo.com/cbbabaf5f48f99a236b129b3df804081.png">


### 2 byte chars

```js
const match = Asearch('漢字文字列')

console.log(match('漢字文字列'))    // => true
console.log(match('漢字の文字列'))  // => false
console.log(match('漢字の文字列', 1)) // => true
```


## Test

    $ git clone https://github.com/shokai/node-asearch.git
    $ cd node-asearch
    $ npm i
    $ npm test
