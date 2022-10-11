import json
import ../jtr

discard """
  output: '''
<null>
<bool>
<string>
<float>
<int>
'''
"""

echo rootTree(parseJson("null")) # null
echo rootTree(parseJson("true")) # bool
echo rootTree(parseJson("\"5\"")) # string
echo rootTree(parseJson($5.0)) # float
echo rootTree(parseJson($5)) # int
