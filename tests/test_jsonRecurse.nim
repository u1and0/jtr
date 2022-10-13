import json, ../jtr

discard """
  output: '''
{"bar":1,"baz":"2","nex":{"coffee":5,"juice":"20","some":{"apple":"iphone","google":"android"}}}
{"coffee":5,"juice":"20","some":{"apple":"iphone","google":"android"}}
{"apple":"iphone","google":"android"}
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
echo jsonRecurse(js, @["obj"])
echo jsonRecurse(js, @["obj", "nex"])
echo jsonRecurse(js, @["obj", "nex", "some"])
