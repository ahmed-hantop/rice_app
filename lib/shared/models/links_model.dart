import 'package:equatable/equatable.dart';

class Links extends Equatable {
  const Links({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

  final String? first;
  final String? last;
  final dynamic prev;
  final dynamic next;

  Links copyWith({
    String? first,
    String? last,
    dynamic prev,
    dynamic next,
  }) {
    return Links(
      first: first ?? this.first,
      last: last ?? this.last,
      prev: prev ?? this.prev,
      next: next ?? this.next,
    );
  }

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      first: json["first"],
      last: json["last"],
      prev: json["prev"],
      next: json["next"],
    );
  }

  Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
      };

  @override
  List<Object?> get props => [
        first,
        last,
        prev,
        next,
      ];
}

class Link extends Equatable {
  const Link({
    required this.url,
    required this.label,
    required this.active,
  });

  final String? url;
  final String? label;
  final bool? active;

  Link copyWith({
    String? url,
    String? label,
    bool? active,
  }) {
    return Link(
      url: url ?? this.url,
      label: label ?? this.label,
      active: active ?? this.active,
    );
  }

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json["url"],
      label: json["label"],
      active: json["active"],
    );
  }

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };

  @override
  List<Object?> get props => [
        url,
        label,
        active,
      ];
}
