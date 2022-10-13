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

import json, strformat, strutils, sequtils, sugar

const VERSION = "v0.2.2"

func lastOne(i, length: int): bool =
  i >= length-1

# 前方宣言
# objectTree()内でarrayTree()を使う相互再帰のため、
# 先に宣言が必要
func arrayTree(jarray: JsonNode): string

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
      of JNull: " <null>"
      of JBool: " <bool>"
      of JString: " <string>"
      of JInt: " <int>"
      of JFloat: " <float>"
      of JArray: " " & arrayTree(val)
      of JObject: "\n" & objectTree(val, nextIndent)
    res.add(&"{indent}{branch}{key}{types}")
    i += 1
  return res.join("\n")

func arrayTree(jarray: JsonNode): string =
  let typesArr: seq[JsonNodeKind] = collect:
    for val in jarray: val.kind
  if all(typesArr, func(x: JsonNodeKind): bool = x == JNull):
    return "[]null"
  elif all(typesArr, func(x: JsonNodeKind): bool = x == JBool):
    return "[]bool"
  elif all(typesArr, func(x: JsonNodeKind): bool = x == JString):
    return "[]string"
  elif all(typesArr, func(x: JsonNodeKind): bool = x == JInt):
    return "[]int"
  elif all(typesArr, func(x: JsonNodeKind): bool = x == JFloat):
    return "[]float"
  elif all(typesArr, func(x: JsonNodeKind): bool = x == JArray):
    return "[]" & arrayTree(jarray[0])
  elif all(typesArr, func(x: JsonNodeKind): bool = x == JObject):
    return "[].\n" & objectTree(jarray[0], " ".repeat(2))
  else: # 全ての型が一致しない場合
    return "[]any"

func rootTree*(jnode: JsonNode): string =
  case jnode.kind
    of JNull: "<null>"
    of JBool: "<bool>"
    of JString: "<string>"
    of JInt: "<int>"
    of JFloat: "<float>"
    of JArray: arrayTree(jnode)
    of JObject: ".\n" & objectTree(jnode, "")

proc showHelp() =
  echo """jtr is a commmand of JSON tree viewer with type

usage:
  $ echo '{"foo": "0", "obj": {"bar":1, "baz":"2"}, "name": "ken"}' | jtr
  .
  ├── foo <string>
  ├── obj
  │   ├── bar <int>
  │   └── baz <string>
  └── name <string>
"""

proc main() =
  let line = stdin.readAll
  let jnode = line.parseJson()
  echo rootTree(jnode)

when isMainModule:
  import os, parseopt
  let args = commandLineParams()
  for kind, key, val in getopt(args):
    case kind
    of cmdLongOption, cmdShortOption:
      case key
      of "help", "h":
        showHelp()
        quit(0)
      of "version", "v":
        echo VERSION
        quit(0)
    of cmdArgument, cmdEnd:
      showHelp()
      quit(1)
  main()

  # TODO
  # 後でオプションで表示切替
  # デフォルト非表示
  # let jstring = jnode.pretty()
  # echo jstring # jqと同じように、JSONを解釈してstdoutへ表示する
