import json, ../jtr

discard """
  output: '''
.
└── foo <array[int]>
'''
"""

const line = """
{"foo": [1,2,3]}
"""
echo rootTree(line.parseJson())