import 'package:chat/models/gender.dart';
import 'package:flutter/material.dart';

class ThematicChatCard extends StatelessWidget {
  final String title;
  final String description;
  final Gender? authorGender;
  final String? authorAge;
  final String? authorLocation;
  final bool hasQuestions;
  final bool isAdult;

  const ThematicChatCard({
    super.key,
    required this.title,
    required this.description,
    required this.authorGender,
    required this.authorAge,
    required this.authorLocation,
    required this.hasQuestions,
    required this.isAdult,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onLongPress: () {},
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
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  if (isAdult) ...[
                    const SizedBox(width: 16),
                    const Text(
                      '🔞',
                      style: TextStyle(fontSize: 18),
                    ),
                  ]
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (authorGender != null) ...[
                    Icon(authorGender == Gender.male ? Icons.man_4_outlined : Icons.woman_2_rounded),
                    const SizedBox(width: 4),
                    Text(authorGender!.display()),
                    const SizedBox(width: 8),
                  ],
                  if (authorAge != null) ...[
                    const Icon(Icons.calendar_today_outlined),
                    const SizedBox(width: 4),
                    Text(authorAge!),
                    const SizedBox(width: 8),
                  ],
                  if (authorLocation != null) ...[
                    const Icon(Icons.location_on_outlined),
                    const SizedBox(width: 4),
                    Flexible(child: Text(authorLocation!, overflow: TextOverflow.ellipsis, softWrap: true, maxLines: 1,)),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: hasQuestions
                        ? const Icon(Icons.lock)
                        : const Icon(Icons.chevron_right_rounded),
                    label: const Text("З'єднати"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
