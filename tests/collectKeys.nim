import json, ../jtr, sequtils

discard """
  output: '''
@["foo", "bar", "baz"]
@["foo", "baz", "apple", "cd", "banana"]
'''
"""

let jarray = """
[
  {
    "foo":{
      "bar": 1,
      "baz": "key"
    }
  },
  {
    "foo":{
      "baz": {
        "apple": 1,
      },
      "cd": {
        "banana": 3
      }
    }
  }
]
""".parseJson

for jnode in jarray:
  echo collectKeys(jnode)
