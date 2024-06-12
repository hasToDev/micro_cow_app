class Chains {
  Chains({
    required this.list,
    required this.chainsDefault,
  });

  final List<String> list;
  final String? chainsDefault;

  factory Chains.fromJson(Map<String, dynamic> json) {
    return Chains(
      list: json["list"] == null ? [] : List<String>.from(json["list"]!.map((x) => x)),
      chainsDefault: json["default"],
    );
  }

  Map<String, dynamic> toJson() => {
        "list": list.map((x) => x).toList(),
        "default": chainsDefault,
      };

  @override
  String toString() {
    return "$list, $chainsDefault, ";
  }
}

/*
{
	"data": {
		"chains": {
			"list": [
				"778925e8c23b975cb9da03182ff4f6008bc0d2bdf8f424dcdca16b9302419243",
				"ad5b69bdc6b1d57e9a23dd322f2390ea35ea3e6ee486a2d8be7728c0f6fde499",
				"e4854ab09513d0e0b62497a5e190a074ff161c6c39e4dfa07dc5e2c0ee73d284"
			],
			"default": "ad5b69bdc6b1d57e9a23dd322f2390ea35ea3e6ee486a2d8be7728c0f6fde499"
		}
	}
}*/
