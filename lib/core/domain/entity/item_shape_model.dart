import 'package:flutter/cupertino.dart';

/// Describes the shape of an item in a list.
///
/// When [isHorizontalList] is true, [horizontalListAspectRatio] is used to
/// determine the aspect ratio of the list, and [horizontalListMargin] and
/// [horizontalListWidthMargin] are used to describe the margin and width
/// of the list.
///
/// When [isHorizontalList] is false, [borderRadius] and [shape] are used to
/// describe the border radius and shape of the item, respectively.
class ItemShape {
  double high;
  double width;
  EdgeInsets? margin;
  bool? isHorizontalList = false;
  EdgeInsets? horizontalListMargin;
  double? horizontalListAspectRatio;
  EdgeInsets? horizontalListWidthMargin;
  BorderRadiusGeometry? borderRadius;
  BoxShape? shape;

  ItemShape({
    required this.high,
    required this.width,
    this.margin,
    this.horizontalListAspectRatio,
    this.horizontalListMargin,
    this.isHorizontalList,
    this.borderRadius,
    this.horizontalListWidthMargin,
    this.shape,
  });
}
