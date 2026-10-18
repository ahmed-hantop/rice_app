import 'package:equatable/equatable.dart';
import 'package:rice_delivery/core/constants/app_constants.dart';
import 'package:rice_delivery/core/constants/app_flow_sate.dart';

/// A class that holds data related to a flow in the app.
///
/// This class is used to pass data between different parts of the app, such as
/// between different screens. It is used to hold data that is related to a
/// specific flow in the app, such as a list of items to display or a user's
/// profile information.
///
/// The class is designed to be extensible, so that it can be used for a wide
/// range of different use cases. It is also designed to be easy to use, with
/// a simple and intuitive API.
///
/// The class is immutable, so that it is safe to use in concurrent
/// programming. It is also serializable, so that it can be easily stored and
/// retrieved from a database or other data store.
///
/// The class is a generic class, so that it can be used with any type of data.
/// It is also a subclass of [Equatable], so that it can be easily compared
/// with other objects.
///
/// The class has the following properties:
///
/// - [data]: The data that is associated with the flow.
/// - [result]: The result of the flow, such as whether it was successful or
///    not.
/// - [type]: The type of the flow, such as whether it is a login flow or a
///    registration flow.
/// - [temp]: A temporary value that is associated with the flow.
/// - [filterPage]: The page number of the flow.
/// - [nextUrl]: The URL of the next page in the flow.
/// - [openPage]: A boolean value indicating whether the next page should be
///    opened automatically.
class DataHandle<T> extends Equatable {
  final T? data;
  final String result;
  final String? type;
  final T? temp;
  final int filterPage;
  final String? nextUrl;
  final bool? openPage;

  const DataHandle({
    this.data,
    this.result = AppFlowState.initial,
    this.type = AppConstants.original,
    this.temp,
    this.filterPage = 1,
    this.nextUrl,
    this.openPage,
  });

  /// Creates a modified copy of the current object.
  DataHandle<T> copyWith({
    T? data,
    String? result,
    String? type,
    T? temp,
    int? filterPage,
    String? nextUrl,
    bool? openPage,
    bool resetNextUrl = false,
  }) {
    return DataHandle<T>(
      data: data ?? this.data,
      result: result ?? this.result,
      type: type ?? this.type,
      temp: temp ?? this.temp,
      filterPage: filterPage ?? this.filterPage,
      nextUrl: resetNextUrl ? nextUrl : nextUrl ?? this.nextUrl,
      openPage: openPage ?? this.openPage,
    );
  }

  @override
  List<Object?> get props => [
    data,
    result,
    type,
    temp,
    filterPage,
    nextUrl,
    openPage,
  ];
}

class PostDataHandle<T> extends Equatable {
  final String? message;
  final bool hasError;
  final T? data;
  final T? temp;
  final String? url;
  final String? nextUrl;
  final bool? openPage;
  /// Raw response body (when it's a Map). Lets callers read fields the
  /// strongly-typed response model doesn't capture — e.g. backend hints
  /// like `auth_type` that need to flow through both success AND error
  /// paths without being swallowed by the error extractor.
  final Map<String, dynamic>? extras;

  const PostDataHandle({
    this.hasError = false,
    this.message,
    this.data,
    this.temp,
    this.url,
    this.nextUrl,
    this.openPage,
    this.extras,
  });

  @override
  List<Object?> get props => [
    data,
    message,
    hasError,
    temp,
    url,
    nextUrl,
    openPage,
    extras,
  ];
}
