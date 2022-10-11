import json, ../jtr

discard """
  output: '''
<array[int]>
'''
"""

const line = """
[1,2,3]
"""
echo rootTree(line.parseJson())
