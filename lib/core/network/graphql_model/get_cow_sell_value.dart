class GetCowSellValue {
  GetCowSellValue({
    required this.value,
  });

  final String? value;

  factory GetCowSellValue.fromJson(Map<String, dynamic> json) {
    return GetCowSellValue(
      value: json["getCowSellValue"],
    );
  }

  Map<String, dynamic> toJson() => {
        "getCowSellValue": value,
      };

  @override
  String toString() {
    return "$value, ";
  }
}

/*
{
	"data": {
		"getCowSellValue": "3883."
	}
}*/
