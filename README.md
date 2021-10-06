# NimFunge98 : a Funge-98 interpreter written in nim

This repository contains code for a nim program that can interpret a valid [Funge-98](https://github.com/catseye/Funge-98/blob/master/doc/funge98.markdown) program. It will soon pass the [mycology test suite](https://github.com/Deewiant/Mycology).

Current limitations are :
- currently does not implement any fingerprints
- does not implement concurrent execution with the `t` command
- does not implement file I/O with the `i` and `o` commands
- does not implement system execution with the `=` command

## Contents

- [Dependencies](#dependencies)
- [Quick install](#quick-install)
- [Usage](#usage)
- [Building](#building)
- [Running tests](#running-tests)

## Dependencies

nim is required. Only nim version >= 1.4.8 on linux amd64 (Gentoo) is being regularly tested.

## Quick Install

To install, clone this repository then run :
```
nimble install
```

## Usage

Launching the interpreter is as simple as :
```
nimfunge98 -f something.b98
```

The interpreter will then load and execute the specified Funge-98 program until the program normally terminates or is interrupted or killed.

## Building

For a debug build, use :
```
nimble build
```

For a release build, use :
```
nimble build -d:release
```

## Running tests

To run unit tests, use :
```
nimble tests
```

To calculate the code coverage of tests, use :
```
nimble coverage
```

To run tests only on (for example) the stack module, use :
```
nim r tests/stack.nim
```

To debug these particular tests, use :
```
nim c --debugger:on --parallelBuild:1 --debuginfo --linedir:on tests/stack.nim
gdb tests/stack
set args XXXXX-if-necessary
b src/truc.nim:123
r
```
