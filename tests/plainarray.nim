import json
import ../jtr

discard """
  output: '''
<int>
'''
"""

const line = """
5
"""
echo rootTree(line.parseJson())
