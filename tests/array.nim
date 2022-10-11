import json, ../jtr

discard """
  output: '''
<array[null]>
<array[bool]>
<array[string]>
<array[int]>
<array[float]>
<array[any]>
<array[.]>
       └── foo
           ├── bar <int>
           └── baz <string>
'''
"""

echo rootTree(parseJson("[null,null,null]"))
echo rootTree(parseJson("[true,false,false]"))
echo rootTree(parseJson("[\"cat\", \"dog\"]"))
echo rootTree(parseJson("[1,2,3]"))
echo rootTree(parseJson("[1.0,10.0,100.0]"))
echo rootTree(parseJson("[1,\"2\",3]"))

const line = """
[
  {
    "foo":{
      "bar": 1,
      "baz": "key"
    }
  },
  {
    "foo":{
      "bar": 2,
      "baz": "signal"
    }
  }
]
"""
echo rootTree(parseJson(line))
