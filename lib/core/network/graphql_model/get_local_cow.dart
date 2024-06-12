import 'get_my_cows.dart';

class GetLocalCow {
  GetLocalCow({
    required this.localCow,
  });

  final List<CowData> localCow;

  factory GetLocalCow.fromJson(Map<String, dynamic> json) {
    return GetLocalCow(
      localCow: json["getOneLocalDbCow"] == null
          ? []
          : List<CowData>.from(json["getOneLocalDbCow"]!.map((x) => CowData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "getOneLocalDbCow": localCow.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$localCow, ";
  }
}

/*
{
	"data": {
		"getOneLocalDbCow": [
			{
				"id": "6a5f375dd033f7c0870004cb28d4df0355c2578e",
				"name": "everest",
				"breed": "Hallikar",
				"gender": "Male",
				"born_time": 1718029985227825,
				"last_fed_time": 1718029985227825,
				"feeding_stats": {
					"on_time": 0,
					"late": 0,
					"forgot": 0
				},
				"owner": "629c205a48320e26926bfc02f79422dd77da555170702402b30ad3beb27d2762"
			}
		]
	}
}*/
