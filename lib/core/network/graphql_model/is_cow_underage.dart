class IsCowUnderage {
  IsCowUnderage({
    required this.isUnderage,
  });

  final bool? isUnderage;

  factory IsCowUnderage.fromJson(Map<String, dynamic> json) {
    return IsCowUnderage(
      isUnderage: json["isCowUnderage"],
    );
  }

  Map<String, dynamic> toJson() => {
        "isCowUnderage": isUnderage,
      };

  @override
  String toString() {
    return "$isUnderage, ";
  }
}

/*
{
	"data": {
		"isCowUnderage": true
	}
}*/
