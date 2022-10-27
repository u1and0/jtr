## jtr is a commmand of JSON tree viewer with type
##
## ```bash
## $ echo '{"foo":5.0,"baz":[{"foo":{"bar":100,"baz":"click","cat":null}},],"login":true}' | jtr
## .
## ├── foo <float>
## ├── baz [].
## │     └── foo
## │         ├── bar <int>
## │         ├── baz <string>
## │         └── cat <null>
## └── login <bool>
## ```

import json, strformat, strutils, sequtils, sugar, terminal

func collectKeys*(jnode: JsonNode): seq[string] =
  ## Collect all keys of JSON object
  ##
  ## ```nim
  ## jnode = """
  ## {
  ##   "foo":{
  ##     "baz": {
  ##       "apple": 1,
  ##     },
  ##     "cd": {
  ##       "banana": 3
  ##     }
  ##   }
  ## }""".parseJson
  ##
  ## doAssert collectKeys(jnode) == @["foo", "baz", "apple", "cd", "banana"]
  ## ```
  if jnode.kind != JObject:
    return @[]
  for k, v in jnode:
    result.add(k)
    if v.kind == JObject:
      result = concat(result, collectKeys(v))

func seekLargestObject*(jarray: JsonNode): JsonNode =
  ## Get most number of key object from array of object
  ##
  ## ```nim
  ## let jarray = """
  ## [
  ##   {
  ##     "foo":{
  ##       "baz": {
  ##         "apple": 1,
  ##       },
  ##       "cd": {
  ##         "banana": 3
  ##       }
  ##     }
  ##   },
  ##   {
  ##     "foo":{
  ##       "bar": 1,
  ##       "baz": "key"
  ##     }
  ##   }
  ## ]
  ## """.parseJson
  ##
  ## doAssert $seekLargestObject(jarray) == """{"foo":{"baz":{"apple":1},"cd":{"banana":3}}}"""
  ##
  ## ```

  if jarray.kind != JArray:
    return jarray
  var largest: JsonNode = jarray[0]
  if len(jarray) == 1:
    return largest
  for jnode in jarray[1..^1]:
    let a = collectKeys(jnode).len()
    let b = collectKeys(largest).len()
    if a > b:
      largest = jnode
  return largest

# 前方宣言
# objectTree()内でarrayTree()を使う相互再帰のため、
# 先に宣言が必要
func arrayTree*(jarray: JsonNode, indent = ""): string

func objectTree*(jobj: JsonNode, indent = ""): string =
  ## Tree view for type of object elemnts recursively
  ##
  ## ```nim
  ## let obj = """
  ## {"foo": "0", "obj": {"bar":1, "baz":"2"}, "name": "ken"}
  ## """.parseJson
  ## doAssert objectTree(obj) == """├── foo <string>
  ## ├── obj
  ## │   ├── bar <int>
  ## │   └── baz <string>
  ## └── name <string>"""
  ## ```

  var
    res: seq[string]
    i: int
    branch, nextIndent: string
  let isLastOne = func(i: int): bool = i >= len(jobj)-1
  for key, val in jobj.pairs:
    if isLastOne(i):
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
      of JArray: " " & arrayTree(val, nextIndent)
      of JObject: "\n" & objectTree(val, nextIndent)
    res.add(&"{indent}{branch}{key}{types}")
    i += 1
  return res.join("\n")

func arrayTree*(jarray: JsonNode, indent = ""): string =
  ## Tree view for type of array elemnts recursively
  ##
  ## ```nim
  ## doAssert arrayTree(parseJson("[null,null,null]")) == "[]null"
  ## doAssert arrayTree(parseJson("[true,false,false]")) == "[]bool"
  ## doAssert arrayTree(parseJson("[\"cat\", \"dog\"]")) == "[]string"
  ## doAssert arrayTree(parseJson("[1,2,3]")) == "[]int"
  ## doAssert arrayTree(parseJson("[1.0,10.0,100.0]")) == "[]float"
  ## doAssert arrayTree(parseJson("[1,\"2\",3]")) == "[]any"
  ## doAssert arrayTree(parseJson("[[1,2,3]]")) == "[][]int"
  ## doAssert arrayTree(parseJson("""
  ## [
  ##   {
  ##     "foo":{
  ##       "bar": 1,
  ##       "baz": "key"
  ##     }
  ##   },
  ##   {
  ##     "foo":{
  ##       "bar": 2,
  ##       "baz": "signal",
  ##       "cat": null
  ##     }
  ##   }
  ## ]
  ## """)) == """[].
  ##   └── foo
  ##       ├── bar <int>
  ##       ├── baz <string>
  ##       └── cat <null>"""
  ## ```

  let typesArr: seq[JsonNodeKind] = collect:
    for val in jarray:
      val.kind
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
    return "[]" & arrayTree(jarray[0]) # TODO 本当にjarray[0]だけでいいのか？seekLargestObject通すべきでは
  elif all(typesArr, func(x: JsonNodeKind): bool = x == JObject):
    let nextIndent = indent & " ".repeat(2)
    let largestObj = seekLargestObject(jarray)
    return "[].\n" & objectTree(largestObj, nextIndent)
  else: # 全ての型が一致しない場合
    return "[]any"

func rootTree*(jnode: JsonNode): string =
  ## Tree view for type of plain JSON recursively
  ##
  ## ```nim
  ## doAssert rootTree(parseJson("null")) == "<null>"
  ## doAssert rootTree(parseJson("true")) == "<bool>"
  ## doAssert rootTree(parseJson("\"5\"")) == "<string>"
  ## doAssert rootTree(parseJson($5.0)) == "<float>"
  ## doAssert rootTree(parseJson($5)) == "<int>"
  ## ```
  case jnode.kind
    of JNull: "<null>"
    of JBool: "<bool>"
    of JString: "<string>"
    of JInt: "<int>"
    of JFloat: "<float>"
    of JArray: arrayTree(jnode)
    of JObject: ".\n" & objectTree(jnode)

func walkNode*(node: JsonNode, props: seq[string]): JsonNode =
  ## JSON property access
  ##
  ## ```nim
  ## let js = """
  ## {
  ##   "foo": "0",
  ##     "obj": {
  ##       "bar": 1,
  ##       "baz": "2",
  ##       "nex": {
  ##         "coffee": 5,
  ##         "juice": "20",
  ##         "some": {
  ##           "apple": "iphone",
  ##           "google": "android"
  ##         }
  ##       },
  ##     },
  ##   "name": "ken"
  ## }""".parseJson
  ## let access = @["obj", "nex", "some"]
  ##
  ## doAssert walkNode(js, access).pretty == """{
  ##   "apple": "iphone",
  ##   "google": "android"
  ## }"""
  ## ```

  if props.len() == 0:
    return node
  let
    firstNode = node[props[0]]
    restProps = props[1..^1]
  return walkNode(firstNode, restProps)

proc parseProperty*(s: string): seq[string] =
  ## parse '.obj.path.to.field' like jq command
  ##
  ## ```nim
  ## doAssert parseProperty(".obj.nex.some") == @["obj", "nex", "some"]
  ## ```
  if not s.startswith("."): # jq errorのまね
    echo s & "/0 is not defined at <top-level>, line 1: " & s
    raise
  if s == ".":
    return @[]
  return s[1..^1].split(".", -1)

type Index = tuple[branch, types, strings, null, arrays: int]

proc colorEcho*(line: string) =
  var i: Index
  i.branch = line.find("── ")
  if i.branch < 0: # not found branch "──"
    echo line
    return
  else: # found branch "──"
    i.branch += 7
    i.strings = line.find("<string")
    i.null = line.find("<null")
    i.types = line.find("<")
    i.arrays = line.find("[")
    if i.null >= 0: # found array "<null>"
      styledEcho(
        styleBright, line[0 ..< i.branch], # tree line -> Default Color
        fgBlue, line[i.branch ..< i.null], # object -> Blue Color
        fgBlack, line[i.null .. ^1], # type -> Black Color
        resetStyle
      )
    elif i.strings >= 0: # found strings "<string>"
      styledEcho(
        styleBright, line[0 ..< i.branch], # tree line -> Default Color
        fgBlue, line[i.branch ..< i.strings], # object -> Blue Color
        resetStyle, fgGreen, line[i.strings .. ^1], # type -> Green Color
        resetStyle
      )
    elif i.types >= 0: # found types "<>"
      styledEcho(
        styleBright, line[0 ..< i.branch], # tree line -> Default Color
        fgBlue, line[i.branch ..< i.types], # object -> Blue Color
        resetStyle, line[i.types .. ^1], # type -> White Color
        resetStyle
      )
    elif i.arrays >= 0: # found array "[]"
      styledEcho(
        styleBright, line[0 ..< i.branch], # tree line -> Default Color
        fgBlue, line[i.branch ..< i.arrays], # object -> Blue Color
        styleBright, fgWhite, line[i.arrays .. ^1], # type -> Bold White Color
        resetStyle
      )
    else: # found branch, Just object
      styledEcho(
        styleBright, line[0 ..< i.branch], # tree line -> Default Color
        fgBlue, line[i.branch .. ^1], # object -> Blue Color
        resetStyle
      )


when isMainModule:
  import os, parseopt

  const VERSION = "v0.2.8r"

  proc showHelp() =
    echo """jtr is a commmand of JSON tree viewer with type

  usage:
    $ echo '{"foo":5.0,"baz":[{"foo":{"bar":100,"baz":"click","cat":null}}],"login":true}' | jtr
    .
    ├── foo <float>
    ├── baz [].
    │     └── foo
    │         ├── bar <int>
    │         ├── baz <string>
    │         └── cat <null>
    └── login <bool>

  options:
    --jq, -q                        Display jq view
    --color-output, -C              colorize JSON
    --monochrome-output, -M         monochrome (don't colorize JSON)
    --help, -h                      Show help message
    --version, -v                   Show version
  """

  type Option = tuple [
    showjq: bool,
    props: seq[string],
    files: seq[string],
    color: bool
  ]

  proc treeViewEntryPoint(opt: Option) =
    # Read JSON string from STDIN or FILE
    var lineArr: seq[string]
    if len(opt.files) == 0:
      lineArr[0] = stdin.readAll
    else:
      for file in opt.files:
        var f = open(file, FileMode.fmRead)
        lineArr.add(f.readAll())

    # Write JSON tree to STDOUT
    for line in lineArr:
      let
        jnode = line.parseJson().walkNode(opt.props)
        tree = rootTree(jnode)
      if opt.color:
        for l in tree.splitlines():
          colorEcho(l)
      else:
        echo tree
      if opt.showjq: # jqと同じように、JSONを解釈してstdoutへ表示する
        echo jnode.pretty()

  proc parseCommandLine(): Option =
    var
      opt: Option
      isFirstArgument = true
    opt.color = true # color option is default true
    for kind, key, val in commandLineParams().getopt():
      case kind
      of cmdLongOption, cmdShortOption:
        case key
        of "help", "h":
          showHelp()
          quit(0)
        of "version", "v":
          echo VERSION
          quit(0)
        of "jq", "q":
          opt.showjq = true
        of "color-output", "C":
          opt.color = true
        of "monochrome-output", "M":
          opt.color = false
      of cmdArgument:
        if isFirstArgument:
          opt.props = parseProperty(key)
          isFirstArgument = false
        else:
          opt.files.add(key)
      of cmdEnd:
        showHelp()
        quit(1)
    return opt

  let opt = parseCommandLine()
  treeViewEntryPoint(opt)
