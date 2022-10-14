import json, ../jtr

discard """
  output: '''
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

# Simple object of array
var obj = """
{"foo": [1,2,3]}
"""
echo rootTree(obj.parseJson())

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
"""
echo rootTree(obj.parseJson())
