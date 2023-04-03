import 'package:chat/models/age_option.dart';
import 'package:chat/models/gender.dart';
import 'package:flutter/material.dart';

class MySearchInfo extends StatefulWidget {
  final ValueNotifier<Gender?> genderNotifier;
  final ValueNotifier<AgeOption?> ageOptionNotifier;

  const MySearchInfo({
    super.key,
    required this.genderNotifier,
    required this.ageOptionNotifier,
  });

  @override
  State<StatefulWidget> createState() => _MySearchInfoState();
}

class _MySearchInfoState extends State<MySearchInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton(
          segments: const [
            ButtonSegment(
              value: Gender.male,
              label: Text('Я хлопець'),
            ),
            ButtonSegment(value: Gender.female, label: Text('Я дівчина')),
          ],
          selected: {widget.genderNotifier.value},
          onSelectionChanged: (genders) => widget.genderNotifier.value = genders.single,
        ),
        const SizedBox(height: 16),
        SegmentedButton(
          segments: const [
            ButtonSegment(
              value: AgeOption.eighteenToTwenty,
              label: Text('18-20'),
            ),
            ButtonSegment(
              value: AgeOption.twentyOneToTwentyFive,
              label: Text('21-25'),
            ),
            ButtonSegment(
              value: AgeOption.twentySixAndMore,
              label: Text('26...'),
            ),
          ],
          selected: {widget.ageOptionNotifier.value},
          onSelectionChanged: (ageOptions) => widget.ageOptionNotifier.value = ageOptions.single,
        ),
      ],
    );
  }
}
