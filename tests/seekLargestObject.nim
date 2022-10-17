import json, ../src/jtr

discard """
  output: '''
{"foo":{"baz":{"apple":1},"cd":{"banana":3}}}
'''
"""

let jarray = """
[
  {
    "foo":{
      "baz": {
        "apple": 1,
      },
      "cd": {
        "banana": 3
      }
    }
  },
  {
    "foo":{
      "bar": 1,
      "baz": "key"
    }
  }
]
""".parseJson

echo seekLargestObject(jarray)
