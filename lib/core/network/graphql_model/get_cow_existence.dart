class GetCowExistence {
  GetCowExistence({
    required this.isCowExist,
  });

  final bool? isCowExist;

  factory GetCowExistence.fromJson(Map<String, dynamic> json) {
    return GetCowExistence(
      isCowExist: json["getCowExistence"],
    );
  }

  Map<String, dynamic> toJson() => {
        "getCowExistence": isCowExist,
      };

  @override
  String toString() {
    return "$isCowExist, ";
  }
}

/*
{
	"data": {
		"getCowExistence": true
	}
}*/
