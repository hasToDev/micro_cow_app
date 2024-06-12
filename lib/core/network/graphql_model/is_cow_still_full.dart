class IsCowStillFull {
  IsCowStillFull({
    required this.isFull,
  });

  final bool? isFull;

  factory IsCowStillFull.fromJson(Map<String, dynamic> json) {
    return IsCowStillFull(
      isFull: json["isCowStillFull"],
    );
  }

  Map<String, dynamic> toJson() => {
        "isCowStillFull": isFull,
      };

  @override
  String toString() {
    return "$isFull, ";
  }
}

/*
{
	"data": {
		"isCowStillFull": true
	}
}*/
