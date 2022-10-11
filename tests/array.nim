import json, ../jtr

discard """
  output: '''
<array[int]>
<array[any]>
<array[object]>
'''
"""

echo rootTree(parseJson("[1,2,3]"))
echo rootTree(parseJson("[1,\"2\",3]"))

const line = """
[
  {
    "foo":{
      "bar": 1,
      "baz": "key"
    }
  }
]
"""
echo rootTree(parseJson(line))
