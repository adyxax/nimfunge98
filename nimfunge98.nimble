# Package

version       = "1.0.0"
author        = "Julien Dessaux"
description   = "A Funge-98 interpreter written in nim"
license       = "EUPL-1.2"
srcDir        = "src"
bin           = @["nimfunge98"]

# Dependencies

requires "nim >= 1.4.8"

# Tasks

task tests, "Runs the test suite":
  exec "testament pattern \"tests/*.nim\""

task coverage, "Run all tests and calculate coverage":
  exec "coco --target 'tests/**/*.nim' --cov '!tests,!nimcache'"

import os, strformat

task fmt, "Run nimpretty on all git-managed .nim files in the current repo":
  ## Usage: nim fmt
  for file in walkDirRec("./", {pcFile, pcDir}):
    if file.splitFile().ext == ".nim":
      let
        # https://github.com/nim-lang/Nim/issues/6262#issuecomment-454983572
        # https://stackoverflow.com/a/2406813/1219634
        fileIsGitManaged = gorgeEx("cd $1 && git ls-files --error-unmatch $2" % [getCurrentDir(), file]).exitCode == 0
        #                           ^^^^^-- That "cd" is required.
      if fileIsGitManaged:
        let
          cmd = "nimpretty --maxLineLen=220 $1" % [file]
        echo "Running $1 .." % [cmd]
        exec(cmd)

task clean, "Clean":
  exec "rm -rf coverage lcov.info nimcache"
  exec "rm -rf outputGotten.txt testresults tests/megatest.nim"
  exec "rm -rf src/htmldocs"
  exec "find tests/ -type f -executable -delete"
