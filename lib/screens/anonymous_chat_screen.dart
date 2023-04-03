import 'package:chat/models/age_option.dart';
import 'package:chat/models/gender.dart';
import 'package:chat/models/region.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnonymousChatScreen extends StatefulWidget {
  const AnonymousChatScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AnonymousChatScreenState();
}

class _AnonymousChatScreenState extends State<AnonymousChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: IntrinsicWidth(
        child: Column(
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
              selected: const <Gender>{Gender.male},
              onSelectionChanged: (_) {},
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
              selected: const {AgeOption.twentyOneToTwentyFive},
              onSelectionChanged: (_) {},
            ),
            const Divider(),
            SegmentedButton(
              segments: const [
                ButtonSegment(
                  value: Gender.male,
                  label: Text('Шукаю хлопця'),
                ),
                ButtonSegment(value: Gender.female, label: Text('Шукаю дівчину')),
              ],
              selected: const {Gender.female},
              onSelectionChanged: (_) {},
            ),
            const SizedBox(height: 16),
            SegmentedButton(
              segments: const [
                ButtonSegment(
                  value: AgeOption.eighteenToTwenty,
                  label: Text('18..20'),
                ),
                ButtonSegment(
                  value: AgeOption.twentyOneToTwentyFive,
                  label: Text('21..25'),
                ),
                ButtonSegment(
                  value: AgeOption.twentySixAndMore,
                  label: Text('26..'),
                ),
              ],
              selected: const {
                AgeOption.twentyOneToTwentyFive,
                AgeOption.twentySixAndMore,
              },
              multiSelectionEnabled: true,
              onSelectionChanged: (_) {},
            ),
            const SizedBox(height: 24),
            DropdownButton(
              items: Region.values
                  .map((region) => DropdownMenuItem(
                        value: region,
                        child: Text(region.name),
                      ))
                  .toList(),
              onChanged: (_) {},
              isExpanded: true,
              hint: Text('Вибери область'),
            ),
            FilledButton.icon(
              onPressed: () {},
              icon: Icon(Icons.search_rounded),
              label: Text('Шукати співрозмовника'),
            ),
            const SizedBox(height: 24),
            Text(
              "Чат з'єднає тебе одразу, або ж доведеться почекати.",
              softWrap: true,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, ),
            ),
          ],
        ),
      ),
    );
  }
}
