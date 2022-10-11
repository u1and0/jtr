jtr is a commmand of JSON tree viewer with type

# Example

```bash
$ echo '{"foo": "0", "obj": {"bar":1, "baz":"2"}, "name": "ken"}' | jq
{
  "foo": "0",
  "obj": {
    "bar": 1,
    "baz": "2"
  },
  "name": "ken"
}

$ echo '{"foo": "0", "obj": {"bar":1, "baz":"2"}, "name": "ken"}' | jtr
.
├── foo <string>
├── obj
│   ├── bar <int>
│   └── baz <string>
└── name <string>
```
