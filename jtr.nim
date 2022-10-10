#[
JSON構造体のツリー表示をする

$ echo '{"foo": "0", "obj": {"bar":1, "baz":"2"}}' | ./jtr
{
  "foo": "0",
  "obj": {
    "bar": 1,
    "baz": "2"
  }
}

ここまではjqと同じ
]#

import json, strutils

proc objectTree(jobj: JsonNode): string =
  for k, v in jobj.pairs:
    let types: string = case v.kind
      of JNull: "(null)"
      of JString: "(str)"
      of JBool: "(bool)"
      of JFloat: "(float)"
      of JInt: "(int)"
      of JArray: "(list)"
      of JObject: objectTree(v)
      # of JObject: "\n    └── "
    # echo "key: " & k & "val: " & $v
    return "└── " & k & types

let line = stdin.readLine
let jobj = line.parseJson()
let jstring = jobj.pretty()
echo jstring

echo "."
let tr = objectTree(jobj)
echo tr

# let splited = jstring.split("\n")
# echo splited
#
# echo "."
# for s in splited:
#   if s.contains("{"):
#     echo "└── "
#   elif s.contains("}"):
#     echo "pass"
#   else:
#     echo s
#
#
