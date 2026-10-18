class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final bool? profileCompleted;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.profileCompleted,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json["success"] != null ? json["success"] as bool : false,
      message: json["message"],
      data: json["data"] != null ? fromJsonT(json["data"]) : null,
      profileCompleted: json["profile_completed"] as bool?,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic>? Function(T?)? toJsonT) {
    return {
      "success": success,
      "message": message,
      "data": toJsonT != null ? toJsonT(data) : data,
      "profile_completed": profileCompleted,
    };
  }
}
