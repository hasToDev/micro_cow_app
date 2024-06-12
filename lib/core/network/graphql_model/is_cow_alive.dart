class IsCowAlive {
  IsCowAlive({
    required this.isAlive,
  });

  final bool? isAlive;

  factory IsCowAlive.fromJson(Map<String, dynamic> json) {
    return IsCowAlive(
      isAlive: json["isCowAlive"],
    );
  }

  Map<String, dynamic> toJson() => {
        "isCowAlive": isAlive,
      };

  @override
  String toString() {
    return "$isAlive, ";
  }
}

/*
{
	"data": {
		"isCowAlive": true
	}
}*/
