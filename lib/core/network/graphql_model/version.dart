class Version {
  Version({
    required this.crateVersion,
    required this.graphqlHash,
    required this.gitDirty,
    required this.gitCommit,
    required this.rpcHash,
    required this.witHash,
  });

  final String? crateVersion;
  final String? graphqlHash;
  final bool? gitDirty;
  final String? gitCommit;
  final String? rpcHash;
  final String? witHash;

  factory Version.fromJson(Map<String, dynamic> json) {
    return Version(
      crateVersion: json["crateVersion"],
      graphqlHash: json["graphqlHash"],
      gitDirty: json["gitDirty"],
      gitCommit: json["gitCommit"],
      rpcHash: json["rpcHash"],
      witHash: json["witHash"],
    );
  }

  Map<String, dynamic> toJson() => {
        "crateVersion": crateVersion,
        "graphqlHash": graphqlHash,
        "gitDirty": gitDirty,
        "gitCommit": gitCommit,
        "rpcHash": rpcHash,
        "witHash": witHash,
      };

  @override
  String toString() {
    return "$crateVersion, $graphqlHash, $gitDirty, $gitCommit, $rpcHash, $witHash, ";
  }
}

/*
{
	"data": {
		"version": {
			"crateVersion": "0.11.3",
			"graphqlHash": "package not used",
			"gitDirty": false,
			"gitCommit": "v0.11.3",
			"rpcHash": "package not used",
			"witHash": "package not used"
		}
	}
}*/
