import 'dart:async';

import 'package:flutter/material.dart';

class ChatBottomSheet extends StatelessWidget {
  final Widget content;
  final String? title;
  final String? cancelLabel;
  final FutureOr<void>? Function()? onCancel;
  final String? proceedLabel;
  final FutureOr<void> Function()? onProceed;

  const ChatBottomSheet({
    super.key,
    required this.content,
    this.title,
    this.cancelLabel,
    this.onCancel,
    this.proceedLabel,
    this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 1.0,
      expand: false,
      builder: (_, scrollController) {
        return CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverPersistentHeader(
              delegate: BottomSheetPersistentHeaderDelegate(
                title: title,
                cancelLabel: cancelLabel,
                onCancel: onCancel,
                proceedLabel: proceedLabel,
                onProceed: onProceed,
              ),
            ),
            SliverToBoxAdapter(
              child: content,
            )
          ],
        );
      },
    );
  }
}

class BottomSheetPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String? title;
  final String? cancelLabel;
  final FutureOr<void>? Function()? onCancel;
  final String? proceedLabel;
  final FutureOr<void> Function()? onProceed;

  const BottomSheetPersistentHeaderDelegate({
    this.title,
    this.cancelLabel,
    this.onCancel,
    this.proceedLabel,
    this.onProceed,
  });

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Center(
          child: Container(
            width: 44,
            height: 4,
            decoration: const BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (title != null || onCancel != null || onProceed != null) ...[
          _buildHeader(),
        ],
        const SizedBox(height: 16),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          if (onCancel != null) ...[
            Flexible(
              child: TextButton(
                onPressed: onCancel,
                child: Text(cancelLabel ?? 'Скасувати'),
              ),
            ),
          ],
          if (title != null) ...[
            Expanded(
              flex: 4,
              child: Center(
                child: Text(
                  title!,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
          if (onProceed != null) ...[
            Flexible(
              child: TextButton(
                onPressed: onProceed,
                child: Text(proceedLabel ?? 'Ок'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

Future<T?> showChatModalBottomSheet<T>({
  required BuildContext context,
  required Widget content,
  String? title,
  String? cancelLabel,
  FutureOr<void>? Function()? onCancel,
  String? proceedLabel,
  FutureOr<void>? Function()? onProceed,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useSafeArea: true,
    isScrollControlled: false,
    builder: (_) => ChatBottomSheet(
      content: content,
      title: title,
      cancelLabel: cancelLabel,
      onCancel: onCancel,
      proceedLabel: proceedLabel,
      onProceed: onProceed,
    ),
  );
}

// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// class ChatBottomSheet extends StatelessWidget {
//   final Widget content;
//   final String? title;
//   final String? cancelLabel;
//   final FutureOr<void>? Function()? onCancel;
//   final String? proceedLabel;
//   final FutureOr<void> Function()? onProceed;
//
//   const ChatBottomSheet({
//     super.key,
//     required this.content,
//     this.title,
//     this.cancelLabel,
//     this.onCancel,
//     this.proceedLabel,
//     this.onProceed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       slivers: [
//         SliverPersistentHeader(
//           delegate: BottomSheetPersistentHeaderDelegate(
//             title: title,
//             cancelLabel: cancelLabel,
//             onCancel: onCancel,
//             proceedLabel: proceedLabel,
//             onProceed: onProceed,
//           ),
//         ),
//         SliverToBoxAdapter(
//           child: content,
//         )
//       ],
//     );
//   }
// }
//
// class BottomSheetPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
//   final String? title;
//   final String? cancelLabel;
//   final FutureOr<void>? Function()? onCancel;
//   final String? proceedLabel;
//   final FutureOr<void> Function()? onProceed;
//
//   const BottomSheetPersistentHeaderDelegate({
//     this.title,
//     this.cancelLabel,
//     this.onCancel,
//     this.proceedLabel,
//     this.onProceed,
//   });
//
//   @override
//   double get maxExtent => 50;
//
//   @override
//   double get minExtent => 50;
//
//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         const SizedBox(height: 8),
//         Center(
//           child: Container(
//             width: 44,
//             height: 4,
//             decoration: const BoxDecoration(
//               color: Colors.white70,
//               borderRadius: BorderRadius.all(Radius.circular(2)),
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//         if (title != null || onCancel != null || onProceed != null) ...[
//           _buildHeader(),
//         ],
//         const SizedBox(height: 16),
//         const Divider(height: 1, thickness: 1),
//       ],
//     );
//   }
//
//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       child: Row(
//         children: [
//           if (onCancel != null) ...[
//             Flexible(
//               child: TextButton(
//                 onPressed: onCancel,
//                 child: Text(cancelLabel ?? 'Скасувати'),
//               ),
//             ),
//           ],
//           if (title != null) ...[
//             Expanded(
//               flex: 4,
//               child: Center(
//                 child: Text(
//                   title!,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ],
//           if (onProceed != null) ...[
//             Flexible(
//               child: TextButton(
//                 onPressed: onProceed,
//                 child: Text(proceedLabel ?? 'Ок'),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
// }
//
// Future<T?> showChatModalBottomSheet<T>({
//   required BuildContext context,
//   required Widget content,
//   String? title,
//   String? cancelLabel,
//   FutureOr<void>? Function()? onCancel,
//   String? proceedLabel,
//   FutureOr<void>? Function()? onProceed,
// }) {
//   return showModalBottomSheet<T>(
//     context: context,
//     useSafeArea: true,
//     isScrollControlled: true,
//     builder: (_) => ChatBottomSheet(
//       content: content,
//       title: title,
//       cancelLabel: cancelLabel,
//       onCancel: onCancel,
//       proceedLabel: proceedLabel,
//       onProceed: onProceed,
//     ),
//   );
// }
