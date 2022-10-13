import json, ../jtr

discard """
  output: '''
@[]
@["obj", "nex", "some"]
error
'''
"""

echo parseProperty(".")
echo parseProperty(".obj.nex.some")
echo parseProperty("obj.nex.some")
