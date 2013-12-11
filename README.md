# nodeinit

![](https://travis-ci.org/geta6/nodeinit.png?branch=master)

node_moduleを開発し始めるためのベース

# usage

    $ git clone https://github.com/geta6/nodeinit
    $ cd nodeinit
    $ npm i
    $ npm i -g grunt-cli
    $ grunt

# tasks

* lint coffee
* build coffee (`src` to `lib`, recursive)
* mocha test (`tests/test.coffee`)
* watching file changes
* failure notification
