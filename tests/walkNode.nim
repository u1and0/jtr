import json, ../jtr

discard """
  output: '''
obj object
{
  "bar": 1,
  "baz": "2",
  "nex": {
    "coffee": 5,
    "juice": "20",
    "some": {
      "apple": "iphone",
      "google": "android"
    }
  }
}
nex object
{
  "coffee": 5,
  "juice": "20",
  "some": {
    "apple": "iphone",
    "google": "android"
  }
}
some object
{
  "apple": "iphone",
  "google": "android"
}
'''
"""

const line = """
{
  "foo": "0",
    "obj": {
      "bar": 1,
      "baz": "2",
      "nex": {
        "coffee": 5,
        "juice": "20",
        "some": {
          "apple": "iphone",
          "google": "android"
        }
      },
    },
  "name": "ken"
}
"""
let js = line.parseJson
echo "obj object"
echo walk(js, @["obj"]).pretty
echo "nex object"
echo walk(js, @["obj", "nex"]).pretty
echo "some object"
echo walk(js, @["obj", "nex", "some"]).pretty
