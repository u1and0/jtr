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

$ echo '{"foo": "0", "obj": {"bar":1, "baz":"2"}, "name": "ken"}' | ./jtr
.
├── foo <string>
├── obj
    ├── bar <int>
    ├── baz <string>

├── name <string>
]#

import json, strformat, strutils

proc objectTree*(jobj: JsonNode, indent: string = ""): string =
  var nextIndent: string
  var res: seq[string]
  var branch: string = "├── "
  for k, v in jobj.pairs:
    let types: string = case v.kind
      of JNull: "<null>"
      of JString: "<string>"
      of JBool: "<bool>"
      of JFloat: "<float>"
      of JInt: "<int>"
      of JArray: "<array>"
      of JObject: "\n" & objectTree(v, nextIndent)
    res.add(&"{indent}{branch}{k} {types}")
    nextIndent = indent & " ".repeat(4)
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
