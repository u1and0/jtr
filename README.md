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
