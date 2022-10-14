import json, ../jtr

discard """
  output: '''
@[]
@["obj"]
@["obj", "nex", "some"]
'''
"""

echo parseProperty(".")
echo parseProperty(".obj")
echo parseProperty(".obj.nex.some")
# echo parseProperty("obj.nex.some") # error case
