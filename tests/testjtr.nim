# jtr command test

import json
import ../jtr

discard """
  output: '''
.
├── foo <string>
├── obj
│   ├── bar <int>
│   └── baz <string>
└── name <string>
'''
"""

var line = """
{"foo": "0", "obj": {"bar":1, "baz":"2"}, "name": "ken"}
"""
echo rootTree(line.parseJson())
