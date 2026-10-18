/// HTTP status code constants for network responses
class HttpStatusCodes {
  // Success codes
  static const int ok = 200;
  static const int created = 201;

  // Client error codes
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int unprocessableEntity = 422;

  // Server error codes
  static const int internalServerError = 500;

  // Prevent instantiation
  HttpStatusCodes._();
}
