import 'dart:async';

import 'package:chat/widgets/extensions/context_x.dart';
import 'package:flutter/material.dart';

class FullScreenDialogHeaderDelegate<T> extends SliverPersistentHeaderDelegate {
  final String title;
  final FutureOr<void> Function(T?) onFinish;

  const FullScreenDialogHeaderDelegate({
    required this.title,
    required this.onFinish,
  });

  @override
  double get maxExtent => 56;

  @override
  double get minExtent => 56;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: context.getColorScheme().surface,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            IconButton(onPressed: Navigator.of(context).pop, icon: const Icon(Icons.close_rounded)),
            Flexible(child: Text(title, style: const TextStyle(fontSize: 22),)),
            const Spacer(),
            TextButton(onPressed: () {}, child: Text('Ок'))
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
