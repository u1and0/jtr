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

# Nested object of array
var obj = """
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

import terminal, strutils
let tree = rootTree(obj)

type Index = tuple[branch, types, strings, null, arrays: int]

proc colorEcho(line: string) =
  var i: Index
  i.branch = line.find("── ")
  if i.branch < 0: # not found branch "──"
    echo line
    return
  else: # found branch "──"
    i.branch += 7
    i.strings = line.find("<string")
    i.null = line.find("<null")
    i.types = line.find("<")
    i.arrays = line.find("[")
    if i.null >= 0: # found array "<null>"
      styledEcho(
        styleBright, line[0 ..< i.branch], # tree line -> Default Color
        fgBlue, line[i.branch ..< i.null], # object -> Blue Color
        fgBlack, line[i.null .. ^1], # type -> Black Color
        resetStyle
      )
    elif i.strings >= 0: # found strings "<string>"
      styledEcho(
        styleBright, line[0 ..< i.branch], # tree line -> Default Color
        fgBlue, line[i.branch ..< i.strings], # object -> Blue Color
        resetStyle, fgGreen, line[i.strings .. ^1], # type -> Green Color
        resetStyle
      )
    elif i.types >= 0: # found types "<>"
      styledEcho(
        styleBright, line[0 ..< i.branch], # tree line -> Default Color
        fgBlue, line[i.branch ..< i.types], # object -> Blue Color
        resetStyle, line[i.types .. ^1], # type -> White Color
        resetStyle
      )
    elif i.arrays >= 0: # found array "[]"
      styledEcho(
        styleBright, line[0 ..< i.branch], # tree line -> Default Color
        fgBlue, line[i.branch ..< i.arrays], # object -> Blue Color
        styleBright, fgWhite, line[i.arrays .. ^1], # type -> Bold White Color
        resetStyle
      )
    else: # found branch, Just object
      styledEcho(
        styleBright, line[0 ..< i.branch], # tree line -> Default Color
        fgBlue, line[i.branch .. ^1], # object -> Blue Color
        resetStyle
      )


for line in tree.splitlines():
  colorEcho(line)
