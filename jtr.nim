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
    typesArr.add(val.kind)
  var typesall: string
  if all(typesArr, proc(x: JsonNodeKind): bool = x == JNull):
    typesall = "[null]"
  elif all(typesArr, proc(x: JsonNodeKind): bool = x == JString):
    typesall = "[string]"
  elif all(typesArr, proc(x: JsonNodeKind): bool = x == JBool):
    typesall = "[bool]"
  elif all(typesArr, proc(x: JsonNodeKind): bool = x == JFloat):
    typesall = "[float]"
  elif all(typesArr, proc(x: JsonNodeKind): bool = x == JInt):
    typesall = "[int]"
  elif all(typesArr, proc(x: JsonNodeKind): bool = x == JArray):
    typesall = "[array]"
  elif all(typesArr, proc(x: JsonNodeKind): bool = x == JObject):
    typesall = "[any]"
  return typesall


func objectTree(jobj: JsonNode, indent = ""): string =
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

func rootTree*(jnode: JsonNode): string =
  case jnode.kind
    of JNull: "<null>"
    of JString: "<string>"
    of JBool: "<bool>"
    of JFloat: "<float>"
    of JInt: "<int>"
    of JArray: &"<array{arrayTree(jnode)}>"
    of JObject: ".\n" & objectTree(jnode, "")

when isMainModule:
  let line = stdin.readLine
  let jnode = line.parseJson()
  echo rootTree(jnode)

  # TODO
  # 後でオプションで表示切替
  # デフォルト非表示
  # let jstring = jnode.pretty()
  # echo jstring # jqと同じように、JSONを解釈してstdoutへ表示する
