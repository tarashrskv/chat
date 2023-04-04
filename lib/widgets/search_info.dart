import 'package:chat/models/age_option.dart';
import 'package:chat/models/gender.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SearchInfo extends StatefulWidget {
  final ValueNotifier<Gender?> myGender;
  final ValueNotifier<AgeOption?> myAgeOption;

  final ValueNotifier<Set<Gender>> lookingForGenders;
  final ValueNotifier<Set<AgeOption>> lookingForAgeOptions;

  const SearchInfo({
    super.key,
    required this.myGender,
    required this.myAgeOption,
    required this.lookingForGenders,
    required this.lookingForAgeOptions,
  });

  @override
  State<StatefulWidget> createState() => _SearchInfoState();
}

class _SearchInfoState extends State<SearchInfo> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: SegmentedButton(
            segments: const [
              ButtonSegment(
                value: Gender.male,
                label: Text('Я хлопець'),
              ),
              ButtonSegment(
                value: Gender.female,
                label: Text('Я дівчина'),
              ),
            ],
            selected: {widget.myGender.value},
            onSelectionChanged: (genders) => widget.myGender.value = genders.single,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final ageOption in AgeOption.values)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      label: Text(ageOption.displayValue()),
                      selected: widget.myAgeOption.value == ageOption,
                      onSelected: (selected) {
                        if (selected && widget.myAgeOption.value != ageOption) {
                          widget.myAgeOption.value = ageOption;
                        }
                        else {
                          widget.myAgeOption.value = null;
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 8),
          child: SegmentedButton(
            segments: const [
              ButtonSegment(
                value: Gender.male,
                label: Text('Шукаю хлопця'),
              ),
              ButtonSegment(value: Gender.female, label: Text('Шукаю дівчину')),
            ],
            selected: widget.lookingForGenders.value,
            multiSelectionEnabled: true,
            onSelectionChanged: (genders) => widget.lookingForGenders.value = genders,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final ageOption in AgeOption.values)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: FilterChip(
                      label: Text(ageOption.displayValue()),
                      selected: widget.lookingForAgeOptions.value.contains(ageOption),
                      onSelected: (selected) {
                        if (selected && !widget.lookingForAgeOptions.value.contains(ageOption)) {
                          widget.lookingForAgeOptions.value = widget.lookingForAgeOptions.value
                            ..add(ageOption);
                        } else if (!selected && widget.lookingForAgeOptions.value.contains(ageOption)) {
                          widget.lookingForAgeOptions.value = widget.lookingForAgeOptions.value
                            ..remove(ageOption);
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}