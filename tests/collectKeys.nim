import json, ../jtr

discard """
  output: '''
@["foo", "bar", "baz"]
@["foo", "baz", "apple", "cd", "banana"]
@[]
@[]
'''
"""

var jnode = """
{
  "foo":{
    "bar": 1,
    "baz": "key"
  }
}
"""
echo collectKeys(jnode.parseJson)

jnode = """
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
"""
echo collectKeys(jnode.parseJson)

# object 以外は空のseqを返す
jnode = "\"str\""
echo collectKeys(jnode.parseJson)

jnode = "[1, 2, 3]"
echo collectKeys(jnode.parseJson)
