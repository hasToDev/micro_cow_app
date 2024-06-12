import 'package:micro_cow_app/core/core.dart';

class GetMyCows {
  GetMyCows({
    required this.myCows,
  });

  final List<CowData> myCows;

  factory GetMyCows.fromJson(Map<String, dynamic> json) {
    return GetMyCows(
      myCows: json["getMyCows"] == null
          ? []
          : List<CowData>.from(json["getMyCows"]!.map((x) => CowData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "getMyCows": myCows.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$myCows, ";
  }
}

class CowData {
  CowData({
    required this.id,
    required this.name,
    required this.breed,
    required this.gender,
    required this.bornTime,
    required this.lastFedTime,
    required this.feedingStats,
    required this.owner,
  });

  final String id;
  final String name;
  final CowBreed breed;
  final CowGender gender;
  final int bornTime;
  late int lastFedTime;
  final FeedingStats feedingStats;
  final String owner;

  set cowLastFedTime(int lastFedTime) => this.lastFedTime = lastFedTime;

  factory CowData.fromJson(Map<String, dynamic> json) {
    CowBreed fromBreed = switch (json["breed"]) {
      'Jersey' => CowBreed.jersey,
      'Limousin' => CowBreed.limousin,
      'Hallikar' => CowBreed.hallikar,
      'Hereford' => CowBreed.hereford,
      'Holstein' => CowBreed.holstein,
      'Simmental' => CowBreed.simmental,
      _ => CowBreed.jersey,
    };

    CowGender fromGender = switch (json["gender"]) {
      'Male' => CowGender.male,
      'Female' => CowGender.female,
      _ => CowGender.male,
    };

    return CowData(
      id: json["id"],
      name: json["name"],
      breed: fromBreed,
      gender: fromGender,
      bornTime: json["born_time"],
      lastFedTime: json["last_fed_time"],
      feedingStats: FeedingStats.fromJson(json["feeding_stats"]),
      owner: json["owner"],
    );
  }

  Map<String, dynamic> toJson() {
    String toBreed = switch (breed) {
      CowBreed.jersey => 'Jersey',
      CowBreed.limousin => 'Limousin',
      CowBreed.hallikar => 'Hallikar',
      CowBreed.hereford => 'Hereford',
      CowBreed.holstein => 'Holstein',
      CowBreed.simmental => 'Simmental',
    };

    String toGender = switch (gender) {
      CowGender.male => 'Male',
      CowGender.female => 'Female',
    };

    return {
      "id": id,
      "name": name,
      "breed": toBreed,
      "gender": toGender,
      "born_time": bornTime,
      "last_fed_time": lastFedTime,
      "feeding_stats": feedingStats.toJson(),
      "owner": owner,
    };
  }

  @override
  String toString() {
    return "$id, $name, $breed, $gender, $bornTime, $lastFedTime, $feedingStats, $owner, ";
  }
}

class FeedingStats {
  FeedingStats({
    required this.onTime,
    required this.late,
    required this.forgot,
  });

  final int? onTime;
  final int? late;
  final int? forgot;

  factory FeedingStats.fromJson(Map<String, dynamic> json) {
    return FeedingStats(
      onTime: json["on_time"],
      late: json["late"],
      forgot: json["forgot"],
    );
  }

  Map<String, dynamic> toJson() => {
        "on_time": onTime,
        "late": late,
        "forgot": forgot,
      };

  @override
  String toString() {
    return "$onTime, $late, $forgot, ";
  }
}

/*
{
	"data": {
		"getMyCows": [
			{
				"id": "7edf59ea04e13fdeb8bae214119baa7cf990bc3e",
				"name": "Grey",
				"breed": "Hallikar",
				"gender": "Female",
				"born_time": 1718015052080760,
				"last_fed_time": 1718015052080760,
				"feeding_stats": {
					"on_time": 0,
					"late": 0,
					"forgot": 0
				},
				"owner": "010a1368133067336f793a27cfc0b19bf36bb7d908caf6dfa4485af105827eb7"
			},
			{
				"id": "90349461dd7b4ddbb5a8681203e86fea34b25a8d",
				"name": "Mars",
				"breed": "Limousin",
				"gender": "Female",
				"born_time": 1718014078119380,
				"last_fed_time": 1718014078119380,
				"feeding_stats": {
					"on_time": 0,
					"late": 0,
					"forgot": 0
				},
				"owner": "010a1368133067336f793a27cfc0b19bf36bb7d908caf6dfa4485af105827eb7"
			}
		]
	}
}*/
