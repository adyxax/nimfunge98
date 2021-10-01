# Package

version       = "0.1.0"
author        = "Julien Dessaux"
description   = "A Funge-98 interpreter written in nim"
license       = "EUPL-1.2"
srcDir        = "src"
bin           = @["nimfunge98"]

# Dependencies

requires "nim >= 1.4.8"

# Tasks

task test, "Runs the test suite":
  exec "testament pattern \"tests/*.nim\""

task coverage, "Run all tests and calculate coverage":
  exec "coco --target 'tests/**/*.nim' --cov '!tests,!nimcache'"

task clean, "Clean":
  exec "rm -rf coverage lcov.info nimcache"
  exec "rm -rf outputGotten.txt testresults tests/megatest.nim"
  exec "find tests/ -type f -executable -delete"
