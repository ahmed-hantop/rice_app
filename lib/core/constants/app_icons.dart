import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcons {
  static const String _basePath = 'assets/icons/';

  // Icon paths
  static const String home = '${_basePath}home.svg';
  static const String search = '${_basePath}search.svg';
  static const String location = '${_basePath}location.svg';
  static const String heart = '${_basePath}heart.svg';
  static const String heartFilled = '${_basePath}heart_filled.svg';
  static const String profile = '${_basePath}profile.svg';
  static const String calendar = '${_basePath}calendar.svg';
  static const String airplane = '${_basePath}airplane.svg';
  static const String hotel = '${_basePath}hotel.svg';
  static const String car = '${_basePath}car.svg';
  static const String star = '${_basePath}star.svg';
  static const String starFilled = '${_basePath}star_filled.svg';
  static const String filter = '${_basePath}filter.svg';
  static const String menu = '${_basePath}menu.svg';
  static const String close = '${_basePath}close.svg';
  static const String arrowBack = '${_basePath}arrow_back.svg';
  static const String arrowForward = '${_basePath}arrow_forward.svg';
  static const String notification = '${_basePath}notification.svg';
  static const String settings = '${_basePath}settings.svg';

  // Error and State Icons
  static const String error = '${_basePath}error.svg';
  static const String noInternet = '${_basePath}no_internet.svg';
  static const String authError = '${_basePath}auth_error.svg';
  static const String emptyState = '${_basePath}empty_state.svg';
  static const String serverError = '${_basePath}server_error.svg';
  static const String noData = '${_basePath}no_data.svg';
  static const String loading = '${_basePath}loading.svg';
  static const String networkError = '${_basePath}network_error.svg';

  // Helper method to create SVG widgets
  static Widget icon(
    String iconPath, {
    double? size,
    Color? color,
    double? width,
    double? height,
  }) => SvgPicture.asset(
    iconPath,
    width: width ?? size ?? 24,
    height: height ?? size ?? 24,
    colorFilter: color != null
        ? ColorFilter.mode(color, BlendMode.srcIn)
        : null,
  );

  // Convenience methods for common icons
  static Widget homeIcon({double? size, Color? color}) =>
      icon(home, size: size, color: color);

  static Widget searchIcon({double? size, Color? color}) =>
      icon(search, size: size, color: color);

  static Widget locationIcon({double? size, Color? color}) =>
      icon(location, size: size, color: color);

  static Widget heartIcon({double? size, Color? color, bool filled = false}) =>
      icon(filled ? heartFilled : heart, size: size, color: color);

  static Widget profileIcon({double? size, Color? color}) =>
      icon(profile, size: size, color: color);

  static Widget calendarIcon({double? size, Color? color}) =>
      icon(calendar, size: size, color: color);

  static Widget airplaneIcon({double? size, Color? color}) =>
      icon(airplane, size: size, color: color);

  static Widget hotelIcon({double? size, Color? color}) =>
      icon(hotel, size: size, color: color);

  static Widget carIcon({double? size, Color? color}) =>
      icon(car, size: size, color: color);

  static Widget starIcon({double? size, Color? color, bool filled = false}) =>
      icon(filled ? starFilled : star, size: size, color: color);

  static Widget filterIcon({double? size, Color? color}) =>
      icon(filter, size: size, color: color);

  static Widget menuIcon({double? size, Color? color}) =>
      icon(menu, size: size, color: color);

  static Widget closeIcon({double? size, Color? color}) =>
      icon(close, size: size, color: color);

  static Widget arrowBackIcon({double? size, Color? color}) =>
      icon(arrowBack, size: size, color: color);

  static Widget arrowForwardIcon({double? size, Color? color}) =>
      icon(arrowForward, size: size, color: color);

  static Widget notificationIcon({double? size, Color? color}) =>
      icon(notification, size: size, color: color);

  static Widget settingsIcon({double? size, Color? color}) =>
      icon(settings, size: size, color: color);

  // Error and State Icon Methods
  static Widget errorIcon({double? size, Color? color}) =>
      icon(error, size: size, color: color);

  static Widget noInternetIcon({double? size, Color? color}) =>
      icon(noInternet, size: size, color: color);

  static Widget authErrorIcon({double? size, Color? color}) =>
      icon(authError, size: size, color: color);

  static Widget emptyStateIcon({double? size, Color? color}) =>
      icon(emptyState, size: size, color: color);

  static Widget serverErrorIcon({double? size, Color? color}) =>
      icon(serverError, size: size, color: color);

  static Widget noDataIcon({double? size, Color? color}) =>
      icon(noData, size: size, color: color);

  static Widget loadingIcon({double? size, Color? color}) =>
      icon(loading, size: size, color: color);

  static Widget networkErrorIcon({double? size, Color? color}) =>
      icon(networkError, size: size, color: color);
}
