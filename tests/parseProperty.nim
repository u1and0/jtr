import json, ../jtr

discard """
  exitcode: 1
  output: '''
@[]
@["obj"]
@["obj", "nex", "some"]
obj.nex.some/0 is not defined at <top-level>, line 1: obj.nex.some
/home/u1and0/Dropbox/Program/nim/jtr/tests/parseProperty.nim(20) parseProperty
/home/u1and0/Dropbox/Program/nim/jtr/jtr.nim(129) parseProperty
/home/u1and0/.choosenim/toolchains/nim-1.6.6/lib/system/fatal.nim(53) sysFatal
Error: unhandled exception: no exception to reraise [ReraiseDefect]
'''
"""

echo parseProperty(".")
echo parseProperty(".obj")
echo parseProperty(".obj.nex.some")
echo parseProperty("obj.nex.some") # error
