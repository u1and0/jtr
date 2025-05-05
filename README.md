<img src="https://img.shields.io/badge/version-v0.2.8-FF7777.svg"></img>
<img src="https://img.shields.io/badge/LICENSE-MIT-3388FF.svg"></img>
<img src="https://img.shields.io/badge/Nim-^v1.6-33FF88.svg"></img>

Commmand of JSON tree viewer with type.

# Example

```bash
$ echo '{"foo":5.0,"baz":[{"foo":{"bar":100,"baz":"click","cat":null}}],"login":true}' | jq
{
  "foo": 5,
  "baz": [
    {
      "foo": {
        "bar": 100,
        "baz": "click",
        "cat": null
      }
    }
  ],
  "login": true
}

$ echo '{"foo":5.0,"baz":[{"foo":{"bar":100,"baz":"click","cat":null}}],"login":true}' | jtr
.
├── foo <float>
├── baz [].
│     └── foo
│         ├── bar <int>
│         ├── baz <string>
│         └── cat <null>
└── login <bool>

$ echo '{"foo":5.0,"baz":[{"foo":{"bar":100,"baz":"click","cat":null}}],"login":true}' | jtr '.baz'
[].
  └── foo
      ├── bar <int>
      ├── baz <string>
      └── cat <null>
```
# Installation

```
$ nimble install jtr
```

or compile from source

```
$ git clone https://github.com/u1and0/nim.git
$ cd jtr
$ nim compile -d:release src/jtr.nim
$ sudo  ln -s `pwd`/src/jtr /usr/bin
```

or get from GitHub release

```
$ curl -fLO https://github.com/u1and0/jtr/releases/download/v0.2.8/jtr-linux.zip
$ unzip jtr-linux.zip
$ chmod 755 ./jtr
$ ./jtr -v
```
