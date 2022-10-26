import strutils, json, ../src/jtr

discard """
  output: '''
.
[1m├── [34mfoo [0m<float>[0m[0m
[1m├── [34mbaz [1m[37m[].[0m[0m
[1m│     └── [34mfoo[0m[0m
[1m│         ├── [34mbar [0m<int>[0m[0m
[1m│         ├── [34mbaz [0m[32m<string>[0m[0m
[1m│         └── [34mcat [30m<null>[0m[0m
[1m└── [34mlogin [0m<bool>[0m[0m
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

let tree = rootTree(obj)
for l in tree.splitlines():
  colorEcho(l)
