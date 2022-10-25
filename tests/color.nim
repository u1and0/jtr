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
const L = "── "
for line in tree.splitlines():
  var idx = line.find(L)
  if idx > 0:
    idx += 7
    # echo line[0 .. idx+6]
    styledEcho(styleBlink, line[0 ..< idx], fgBlue, line[idx .. ^1], resetStyle)
  else:
    echo line

