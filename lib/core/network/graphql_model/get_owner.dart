class Owner {
  Owner({
    required this.getOwner,
  });

  final String? getOwner;

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      getOwner: json["getOwner"],
    );
  }

  Map<String, dynamic> toJson() => {
        "getOwner": getOwner,
      };

  @override
  String toString() {
    return "$getOwner, ";
  }
}

/*
{
	"data": {
		"getOwner": "3f9cf74c53cc3b45334605adbd603e2006509f63f120e6b764b0d5be2bfe35ea"
	}
}*/
