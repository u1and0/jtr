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

import json, strformat

proc objectTree(jobj: JsonNode, indent: string = ""): string =
  var nextIndent: string
  const defaultIndent: string = "    "
  var res: string
  for k, v in jobj.pairs:
    # echo &"key: {k}, val: {$v}"
    let types: string = case v.kind
      of JNull: "<null>"
      of JString: "<str>"
      of JBool: "<bool>"
      of JFloat: "float>"
      of JInt: "<int>"
      of JArray: "<list>"
      of JObject: &"\n{objectTree(v, nextIndent)}"
    res &= &"{indent}└── {k} {types}\n"
    nextIndent = indent & defaultIndent
  return res

let line = stdin.readLine
let jobj = line.parseJson()
let jstring = jobj.pretty()
echo jstring # jqと同じように、JSONを解釈してstdoutへ表示する

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
