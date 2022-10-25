import json, ../src/jtr

discard """
  output: '''
.
├── foo <string>
├── obj
│   ├── bar <int>
│   └── baz <string>
└── name <string>
.
└── foo []int
.
├── foo <float>
├── baz [].
│     └── foo
│         ├── bar <int>
│         ├── baz <string>
│         └── cat <null>
└── login <bool>
'''
"""

# Simple object
var obj = """
{"foo": "0", "obj": {"bar":1, "baz":"2"}, "name": "ken"}
""".parseJson
echo rootTree(obj)

# Object of array
obj = """
{"foo": [1,2,3]}
""".parseJson
echo rootTree(obj)

# Nested object of array
obj = """
{
  "foo": 5.0,
  "baz": [
    {
      "foo": {
        "bar": 100,
        "baz": "click",
        "cat": null
      }
    },
    {
      "foo": {
        "bar": 64,
        "cat": null
      }
    }
  ],
  "login": true
}
""".parseJson
echo rootTree(obj)

import terminal
styledEcho(fgGreen, obj.pretty, fgDefault)
styledEcho styleBright, fgGreen, "[PASS]", resetStyle, fgBlue, " Yay!"

# could not load: kernel32
# (compile with -d:nimDebugDlOpen for more information)
# Error: execution of an external program failed: '/home/u1and0/home/nim/jtr/tests/color '
# import colorizeEcho except setConsoleMode
# initColorizeEcho()
# cecho "[magenta]Every [green]color [cyan]is [default]beautiful."


# let args = [styleBright, fgGreen, "[PASS]", resetStyle, fgBlue, " Yay!"]
# styledEcho(args)
import strutils
let tree = rootTree(obj)
const
  L = "── "
  K = "<"
  E = "["

# func findS(line, s: string): int =
#   var v:int = line.find(s)
#     if v != -1:
#       return v
#     else:
#       return ^1

for line in tree.splitlines():
  var il = line.find(L)
  if il > 0:
    il += 7
    var ik = line.find(K)
    if not ik == -1:
      ik = line.find(E)
    styledEcho(
      styleBlink, line[0 ..< il], # tree line -> Default Color
      fgBlue, line[il ..< ik], # object -> Blue Color
      # styleBlink, line[ie .. ^1], # object -> Default Color
      fgGreen, line[ik .. ^1], # type -> Green Color
      resetStyle
    )
  else: # not found L
    echo line

