class RootAndInitializeCheck {
  RootAndInitializeCheck({
    required this.isRoot,
    required this.isInitialized,
  });

  final bool? isRoot;
  final bool? isInitialized;

  factory RootAndInitializeCheck.fromJson(Map<String, dynamic> json) {
    return RootAndInitializeCheck(
      isRoot: json["rootCheck"],
      isInitialized: json["statusCheck"],
    );
  }

  Map<String, dynamic> toJson() => {
        "rootCheck": isRoot,
        "statusCheck": isInitialized,
      };

  @override
  String toString() {
    return "$isRoot, $isInitialized, ";
  }
}

/*
{
	"data": {
		"rootCheck": true,
		"statusCheck": false
	}
}*/
