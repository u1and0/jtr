#[
JSON構造体のツリー表示をする

$ echo '{"foo": "0", "obj": {"bar":1, "baz":"2"}, "name": "ken"}' | ./jtr
.
├── foo <string>
├── obj
    ├── bar <int>
    └── baz <string>
└── name <string>
]#

import json, strformat, strutils

func lastOne(i, length: int): bool =
  i >= length-1

func objectTree*(jobj: JsonNode, indent: string = ""): string =
  var nextIndent: string
  var res: seq[string]
  var branch: string = "├── "
  var i: int
  for key, val in jobj.pairs:
    if lastOne(i, len(jobj)):
      branch = "└── "
    let types: string = case val.kind
      of JNull: "<null>"
      of JString: "<string>"
      of JBool: "<bool>"
      of JFloat: "<float>"
      of JInt: "<int>"
      of JArray: "<array>"
      of JObject: "\n" & objectTree(val, nextIndent)
    res.add(&"{indent}{branch}{key} {types}")
    nextIndent = indent & " ".repeat(4)
    i += 1
  return res.join("\n")

when isMainModule:
  let line = stdin.readLine
  let jobj = line.parseJson()
  let jstring = jobj.pretty()

  echo "."
  echo objectTree(jobj)

  # TODO
  # 後でオプションで表示切替
  # デフォルト非表示
  echo jstring # jqと同じように、JSONを解釈してstdoutへ表示する

  echo len(jobj)
