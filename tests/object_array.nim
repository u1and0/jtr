import json, ../jtr

discard """
  output: '''
.
└── foo []int
'''
"""

const line = """
{"foo": [1,2,3]}
"""
echo rootTree(line.parseJson())
