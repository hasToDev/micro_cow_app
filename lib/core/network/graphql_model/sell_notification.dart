class SellNotificationList {
  SellNotificationList({
    required this.getOneSellNotification,
  });

  final List<SellNotification> getOneSellNotification;

  factory SellNotificationList.fromJson(Map<String, dynamic> json) {
    return SellNotificationList(
      getOneSellNotification: json["getOneSellNotification"] == null
          ? []
          : List<SellNotification>.from(
              json["getOneSellNotification"]!.map((x) => SellNotification.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "getOneSellNotification": getOneSellNotification.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$getOneSellNotification, ";
  }
}

class SellNotification {
  SellNotification({
    required this.cowName,
    required this.isSuccess,
    required this.failureReason,
  });

  final String? cowName;
  final bool? isSuccess;
  final String? failureReason;

  factory SellNotification.fromJson(Map<String, dynamic> json) {
    return SellNotification(
      cowName: json["cowName"],
      isSuccess: json["isSuccess"],
      failureReason: json["failureReason"],
    );
  }

  Map<String, dynamic> toJson() => {
        "cowName": cowName,
        "isSuccess": isSuccess,
        "failureReason": failureReason,
      };

  @override
  String toString() {
    return "$cowName, $isSuccess, $failureReason, ";
  }
}

/*
{
	"data": {
		"getOneSellNotification": [
			{
				"cowName": "Green",
				"isSuccess": true,
				"failureReason": "operation"
			}
		]
	}
}*/
