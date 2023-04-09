import 'package:chat/models/gender.dart';
import 'package:chat/network/models/thematic_chats/question.dart';
import 'package:chat/widgets/extensions/context_x.dart';
import 'package:flutter/material.dart';

class ThematicChatCard extends StatelessWidget {
  final String title;
  final String description;
  final Gender? authorGender;
  final int? authorAge;
  final String? authorLocation;
  final List<Question>? questions;
  final bool adultOnly;

  final Animation<double> animation;
  final bool isActive;

  const ThematicChatCard({
    super.key,
    required this.title,
    required this.description,
    required this.authorGender,
    required this.authorAge,
    required this.authorLocation,
    required this.questions,
    required this.adultOnly,
    required this.animation,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onLongPress: isActive ? () {} : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    if (adultOnly) ...[
                      const SizedBox(width: 16),
                      const Badge(label: Text('18+')),
                    ]
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (authorGender != null) ...[
                      Icon(
                        authorGender == Gender.male ? Icons.face_6_rounded : Icons.face_3_rounded,
                        color: context.getColorScheme().secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(authorGender!.display()),
                      const SizedBox(width: 8),
                    ],
                    if (authorAge != null) ...[
                      Icon(
                        Icons.calendar_month_outlined,
                        color: context.getColorScheme().secondary,
                      ), // maybe cake
                      const SizedBox(width: 4),
                      Text(authorAge!.toString()),
                      const SizedBox(width: 8),
                    ],
                    if (authorLocation != null) ...[
                      Icon(Icons.location_on_outlined, color: context.getColorScheme().secondary),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          authorLocation!,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: isActive ? () {} : null,
                      icon: (questions?.isEmpty ?? true) ? const Icon(Icons.chevron_right_rounded) : const Icon(Icons.key_outlined),
                      label: const Text("З'єднати"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
