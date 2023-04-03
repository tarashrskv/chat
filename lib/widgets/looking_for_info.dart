import 'package:chat/models/age_option.dart';
import 'package:chat/models/gender.dart';
import 'package:chat/models/region.dart';
import 'package:chat/widgets/bottom_sheet.dart';
import 'package:chat/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LookingForInfo extends StatefulWidget {
  final ValueNotifier<Set<Gender>> gendersNotifier;
  final ValueNotifier<Set<AgeOption>> ageOptionsNotifier;

  const LookingForInfo({
    super.key,
    required this.gendersNotifier,
    required this.ageOptionsNotifier,
  });

  @override
  State<StatefulWidget> createState() => _LookingForInfoState();
}

class _LookingForInfoState extends State<LookingForInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton(
          segments: const [
            ButtonSegment(
              value: Gender.male,
              label: Text('Шукаю хлопця'),
            ),
            ButtonSegment(value: Gender.female, label: Text('Шукаю дівчину')),
          ],
          selected: widget.gendersNotifier.value,
          multiSelectionEnabled: true,
          onSelectionChanged: (genders) => widget.gendersNotifier.value = genders,
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
          selected: widget.ageOptionsNotifier.value,
          multiSelectionEnabled: true,
          onSelectionChanged: (ageOptions) => widget.ageOptionsNotifier.value = ageOptions,
        ),
        const SizedBox(height: 24),
        TextField(
          decoration: textFieldDecoration.copyWith(
            labelText: 'Вибери область'
          ),
          onTap: () => showChatModalBottomSheet(
            context: context,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [for (final region in Region.values) Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(region.name),
              )],
            )
          ),
        ),
      ],
    );
  }
}
