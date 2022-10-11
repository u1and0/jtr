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
  const defaultIndent: string = " ".repeat(4)
  var res: string
  var branch: string = "├── "
  for k, v in jobj.pairs:
    # echo &"key: {k}, val: {$v}"
    let types: string = case v.kind
      of JNull: "<null>"
      of JString: "<string>"
      of JBool: "<bool>"
      of JFloat: "<float>"
      of JInt: "<int>"
      of JArray: "<array>"
      of JObject: "\n" & objectTree(v, nextIndent)
    res &= &"{indent}{branch}{k} {types}\n"
    nextIndent = indent & defaultIndent
  return res

when isMainModule:
  let line = stdin.readLine
  let jobj = line.parseJson()
  let jstring = jobj.pretty()
  echo jstring # jqと同じように、JSONを解釈してstdoutへ表示する

  echo "."
  echo objectTree(jobj)

