# tictactoe-core.rb
[![Build Status](https://travis-ci.org/mateuadsuara/tictactoe-core.rb.svg?branch=remove-old-runtests)](https://travis-ci.org/mateuadsuara/tictactoe-core.rb) [![Code Climate](https://codeclimate.com/github/demonh3x/tictactoe.rb/badges/gpa.svg)](https://codeclimate.com/github/demonh3x/tictactoe.rb) [![Test Coverage](https://codeclimate.com/github/demonh3x/tictactoe.rb/badges/coverage.svg)](https://codeclimate.com/github/demonh3x/tictactoe.rb)

## Description

This is an implementation of the [tic-tac-toe][ttt] game (or Noughts and crosses, Xs and Os) in Ruby.

[ttt]: http://en.wikipedia.org/wiki/Tic-tac-toe

This repository provides the core logic of the game that can be shared across [multiple user interfaces](#available-user-interfaces) or run without any user interface.

## Features

##### Board sizes
* 3x3
* 4x4

##### Interesting perfect computer player
* Never loses
* Wins if possible
* Chooses randomly between best moves

## Dependencies

##### Execution
* Ruby, from v2.0.0 to 2.2.0 (other versions might work too)

##### Testing
* [RSpec][rspec] 3.1.0
* [Codeclimate Test Reporter][climate] (For CI environment)

[rspec]: http://rspec.info/
[climate]: https://github.com/codeclimate/ruby-test-reporter

##### Others
* [Bundler][bundler] (To manage dependencies)
* [Rake][rake] (To run preconfigured tasks)

[bundler]: http://bundler.io/
[rake]: https://github.com/ruby/rake

## Setup

##### Install dependencies
`bundle install`

##### Run tests
`rake`

## Rake tasks
run `rake -T` to see all available tasks

## Available user interfaces
* [tictactoe-cli.rb][cli]: A CLI for tictactoe
* [tictactoe-gui.rb][gui]: A GUI for tictactoe 
* [tictactoe-web.rb][web]: A Web interface for tictactoe

[cli]: https://github.com/demonh3x/tictactoe-cli.rb
[gui]: https://github.com/demonh3x/tictactoe-gui.rb
[web]: https://github.com/demonh3x/tictactoe-web.rb
