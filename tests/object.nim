import json, ../jtr

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
