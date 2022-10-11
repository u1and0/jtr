#[
JSON構造体のツリー表示をする

$ echo '{"foo": "0", "obj": {"bar":1, "baz":"2"}, "name": "ken"}' | ./jtr
.
├── foo <string>
├── obj
│   ├── bar <int>
│   └── baz <string>
└── name <string>
]#

import json, strformat, strutils, sequtils

func lastOne(i, length: int): bool =
  i >= length-1

func arrayTree(jarray: JsonNode): string =
  var typesArr: seq[JsonNodeKind]
  for val in jarray:
    # let types: string = case val.kind
    #   of JNull: "<null>"
    #   of JString: "<string>"
    #   of JBool: "<bool>"
    #   of JFloat: "<float>"
    #   of JInt: "<int>"
    #   of JArray: "<array>" & arrayTree(val)
    #   of JObject: "\n" & "obj"
      # of JObject: "\n" & objectTree(val, nextIndent)
    typesArr.add(val.kind)
  var typesall: string
  if all(typesArr, proc(x: JsonNodeKind): bool = x == JString):
    typesall = "[string]"
  elif all(typesArr, proc(x: JsonNodeKind): bool = x == JInt):
    typesall = "[int]"
  return &"{typesall}"


func objectTree*(jobj: JsonNode, indent = ""): string =
  var
    res: seq[string]
    i: int
    branch, nextIndent: string
  for key, val in jobj.pairs:
    if lastOne(i, len(jobj)):
      branch = "└── "
      nextIndent = indent & " ".repeat(4)
    else:
      branch = "├── "
      nextIndent = indent & "│" & " ".repeat(3)
    let types: string = case val.kind
      of JNull: "<null>"
      of JString: "<string>"
      of JBool: "<bool>"
      of JFloat: "<float>"
      of JInt: "<int>"
      of JArray: &"<array{arrayTree(val)}>"
      of JObject: "\n" & objectTree(val, nextIndent)
    res.add(&"{indent}{branch}{key} {types}")
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
