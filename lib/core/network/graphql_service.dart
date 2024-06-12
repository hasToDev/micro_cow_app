import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:micro_cow_app/main.dart';
import 'linera_response_parser.dart';

const String errNode = 'Local node operation failed';
const String errRegister = 'not registered by the chain during Query';

class GraphQLService {
  GraphQLService._();

  static GraphQLClient createGraphQlClient(String baseUrl) {
    HttpLink httpLink = HttpLink(baseUrl, parser: const LineraResponseParser());
    return GraphQLClient(link: httpLink, cache: GraphQLCache());
  }

  static Future<(QueryResult?, String?)> performQuery(
    GraphQLClient client,
    String query, {
    Map<String, dynamic>? variables = const {},
  }) async {
    try {
      QueryOptions options = QueryOptions(
        document: gql(query),
        variables: variables ?? const {},
        fetchPolicy: FetchPolicy.noCache,
      );

      QueryResult result = await client.query(options).timeout(graphQLConnectionTimeout);

      if (result.hasException) {
        String err = _errorHandling(result.exception!);
        if (err.contains(errNode) && err.contains(errRegister)) err = "app not registered";
        if (err.contains('Local node operation failed')) err = "Local node operation failed";
        if (err.contains('HandshakeException')) err = "unable to connect";
        if (err.contains('Failed host lookup')) err = "unable to connect";
        if (err.contains('ServerException')) err = "unable to connect";
        if (err.contains('FormatException')) err = "invalid address";

        return (null, err);
      }

      if (result.data == null) {
        return (null, "Data Not Found or Null");
      }

      return (result, null);
    } catch (e) {
      String err = e.toString();
      if (err.contains('TimeoutException')) err = "connection timeout";
      return (null, err);
    }
  }

  static Future<(QueryResult?, String?)> performMutation(
    GraphQLClient client,
    String query, {
    Map<String, dynamic>? variables = const {},
  }) async {
    try {
      MutationOptions options = MutationOptions(
        document: gql(query),
        variables: variables ?? const {},
        fetchPolicy: FetchPolicy.noCache,
      );

      QueryResult result = await client.mutate(options).timeout(graphQLConnectionTimeout);

      if (result.hasException) {
        String err = _errorHandling(result.exception!);
        if (err.contains(errNode) && err.contains(errRegister)) err = "app not registered";
        if (err.contains('Local node operation failed')) err = "Local node operation failed";
        if (err.contains('HandshakeException')) err = "unable to connect";
        if (err.contains('Failed host lookup')) err = "unable to connect";
        if (err.contains('ServerException')) err = "unable to connect";
        if (err.contains('FormatException')) err = "invalid address";

        return (null, err);
      }

      if (result.data == null) {
        return (null, "Data Not Found or Null");
      }

      return (result, null);
    } catch (e) {
      String err = e.toString();
      if (err.contains('TimeoutException')) err = "connection timeout";
      return (null, err);
    }
  }

  static String _errorHandling(OperationException exception) {
    String errorMessage;
    if (exception.graphqlErrors.isNotEmpty) {
      GraphQLError error = exception.graphqlErrors.first;
      errorMessage = error.message;
    } else if (exception.linkException != null) {
      var clientException = exception.linkException;
      if (clientException is UnknownException) return "Something went wrong";
      errorMessage = clientException.toString();
    } else {
      errorMessage = 'Something went wrong';
    }
    return errorMessage;
  }
}
