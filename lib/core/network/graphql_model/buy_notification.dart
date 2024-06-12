class BuyNotificationList {
  BuyNotificationList({
    required this.getOneBuyNotification,
  });

  final List<BuyNotification> getOneBuyNotification;

  factory BuyNotificationList.fromJson(Map<String, dynamic> json) {
    return BuyNotificationList(
      getOneBuyNotification: json["getOneBuyNotification"] == null
          ? []
          : List<BuyNotification>.from(
              json["getOneBuyNotification"]!.map((x) => BuyNotification.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "getOneBuyNotification": getOneBuyNotification.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$getOneBuyNotification, ";
  }
}

class BuyNotification {
  BuyNotification({
    required this.cowName,
    required this.isSuccess,
  });

  final String? cowName;
  final bool? isSuccess;

  factory BuyNotification.fromJson(Map<String, dynamic> json) {
    return BuyNotification(
      cowName: json["cowName"],
      isSuccess: json["isSuccess"],
    );
  }

  Map<String, dynamic> toJson() => {
        "cowName": cowName,
        "isSuccess": isSuccess,
      };

  @override
  String toString() {
    return "$cowName, $isSuccess, ";
  }
}

/*
{
	"data": {
		"getOneBuyNotification": [
			{
				"cowName": "Green",
				"isSuccess": true
			}
		]
	}
}*/
