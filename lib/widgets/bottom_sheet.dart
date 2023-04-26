import 'dart:async';

import 'package:chat/widgets/extensions/context_x.dart';
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Center(
          child: Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: context.getColorScheme().onSurfaceVariant,
              borderRadius: const BorderRadius.all(Radius.circular(2)),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (title != null || onCancel != null || onProceed != null) ...[
          _buildHeader(),
        ],
        const SizedBox(height: 12),
        const Divider(
          height: 1,
          thickness: 1,
          indent: 12,
          endIndent: 12,
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: content,
            ),
          ),
        ),
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
          ] else ...[
            Spacer(
              flex: 2,
            )
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
    isScrollControlled: true,
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
