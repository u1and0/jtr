import json, ../src/jtr

discard """
  output: '''
.
├── foo <string>
├── obj
│   ├── bar <int>
│   ├── baz <string>
│   └── nex
│       ├── boo <int>
│       └── cat <int>
└── name <string>
'''
"""

const line = """
{"foo": "0", "obj": {"bar":1, "baz":"2", "nex": {"boo": 1, "cat": 100}}, "name": "ken"}
"""
echo rootTree(line.parseJson())
