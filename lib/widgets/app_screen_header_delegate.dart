
import 'package:flutter/material.dart';

class AppScreenHeaderDelegate extends SliverPersistentHeaderDelegate {


  static const double progressThreshold = 0.5;

  @override
  double get maxExtent => 24;

  @override
  double get minExtent => 24;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = shrinkOffset / maxExtent;

    final padding = _calculatePadding(progress);
    final opacity = _calculateOpacity(progress);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      IconButton(onPressed: Navigator.of(context).pop, icon: const Icon(Icons.close_rounded)),

    ],);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;

  double _calculatePadding(double progress, {double max = 24, double min = 12}) {
    if (progress <= progressThreshold) {
      return max * (1 - progress);
    }
    else {
      return min;
    }
  }

  double _calculateOpacity(double progress, ) {
    if (progress <= progressThreshold) {
      return 1 - progress / 1.5;
    }
    else {
      return 0.75;
    }
  }

  double _calculateAvatarSize(double progress, {double max = 64, double min = 32}) {
    if (progress <= progressThreshold) {
      return max * (1 - progress);
    }
    else {
      return min;
    }
  }

  double _calculateFontSize(double progress, double initialFontSize, double minFontSize) {
    if (progress < 0 || progress > 1) {
      throw ArgumentError('Invalid progress value. Progress should be between 0 and 1.');
    }

    if (progress <= progressThreshold) {
      return _lerp(initialFontSize, minFontSize, progress * 2);
    } else {
      return minFontSize;
    }
  }

  double _lerp(double start, double end, double progress) =>
      (1 - progress) * start + progress * end;

}