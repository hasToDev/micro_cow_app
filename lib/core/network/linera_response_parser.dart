// ignore_for_file: prefer_const_constructors

import "package:graphql_flutter/graphql_flutter.dart";

/// JSON [Response] parser
class LineraResponseParser extends ResponseParser {
  const LineraResponseParser();

  /// Parses the response body
  ///
  /// Extend this to add non-standard behavior
  Response parseResponse(Map<String, dynamic> body) {
    var bodyData = body["data"];
    if (bodyData is! Map) {
      bodyData = {"data": body["data"]};
    }
    return Response(
      errors: (body["errors"] as List?)
          ?.map(
            (dynamic error) => parseError(error as Map<String, dynamic>),
          )
          .toList(),
      data: bodyData as Map<String, dynamic>?,
      response: body,
      context: Context().withEntry(
        ResponseExtensions(
          body["extensions"],
        ),
      ),
    );
  }

  /// Parses a response error
  ///
  /// Extend this to add non-standard behavior
  GraphQLError parseError(Map<String, dynamic> error) => GraphQLError(
        message: error["message"] as String,
        path: error["path"] as List?,
        locations: (error["locations"] as List?)
            ?.map(
              (dynamic location) => parseLocation(location as Map<String, dynamic>),
            )
            .toList(),
        extensions: error["extensions"] as Map<String, dynamic>?,
      );

  /// Parses a response error location
  ///
  /// Extend this to add non-standard behavior
  ErrorLocation parseLocation(Map<String, dynamic> location) => ErrorLocation(
        line: location["line"] as int,
        column: location["column"] as int,
      );
}
