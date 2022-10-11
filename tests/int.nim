import json
import ../jtr

discard """
  output: '''
<int>
<string>
<bool>
'''
"""

echo rootTree(parseJson($5))
echo rootTree(parseJson("\"5\""))
echo rootTree(parseJson("true"))
