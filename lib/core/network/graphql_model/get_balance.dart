class Balance {
  Balance({
    required this.getBalance,
  });

  final String? getBalance;

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      getBalance: json["getBalance"],
    );
  }

  Map<String, dynamic> toJson() => {
        "getBalance": getBalance,
      };

  @override
  String toString() {
    return "$getBalance, ";
  }
}

/*
{
	"data": {
		"getBalance": "3883."
	}
}*/
