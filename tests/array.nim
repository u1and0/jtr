import json, ../jtr, sequtils

discard """
  output: '''
[]null
[]bool
[]string
[]int
[]float
[]any
[][]int
[].
  └── foo
      ├── bar <int>
      └── baz <string>
'''
"""

echo rootTree(parseJson("[null,null,null]")) # null type array
echo rootTree(parseJson("[true,false,false]")) # bool type array
echo rootTree(parseJson("[\"cat\", \"dog\"]")) # string type array
echo rootTree(parseJson("[1,2,3]")) # int type array
echo rootTree(parseJson("[1.0,10.0,100.0]")) # float type array
echo rootTree(parseJson("[1,\"2\",3]")) # mixed type type array
echo rootTree(parseJson("[[1,2,3]]")) # nested array
echo rootTree(parseJson("""
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
"""))
