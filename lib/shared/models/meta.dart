import 'dart:convert';

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  String? firstPageUrl;
  String? lastPageUrl;
  dynamic nextPageUrl;
  dynamic prevPageUrl;
  int? perPage;
  int? to;
  int? total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.firstPageUrl,
    this.lastPageUrl,
    this.nextPageUrl,
    this.prevPageUrl,
    this.perPage,
    this.to,
    this.total,
  });

  factory Meta.fromMap(Map<String, dynamic> data) => Meta(
    currentPage: data['current_page'] as int?,
    from: data['from'] as int?,
    lastPage: data['last_page'] as int?,
    firstPageUrl: data['first_page_url'] as String?,
    lastPageUrl: data['last_page_url'] as String?,
    nextPageUrl: data['next_page_url'] as dynamic,
    prevPageUrl: data['prev_page_url'] as dynamic,
    perPage: data['per_page'] as int?,
    to: data['to'] as int?,
    total: data['total'] as int?,
  );

  Map<String, dynamic> toMap() => {
    'current_page': currentPage,
    'from': from,
    'last_page': lastPage,
    'first_page_url': firstPageUrl,
    'last_page_url': lastPageUrl,
    'next_page_url': nextPageUrl,
    'prev_page_url': prevPageUrl,
    'per_page': perPage,
    'to': to,
    'total': total,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Meta].
  factory Meta.fromJson(String data) {
    return Meta.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Meta] to a JSON string.
  String toJson() => json.encode(toMap());
}
