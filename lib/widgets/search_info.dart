import 'package:chat/models/age_option.dart';
import 'package:chat/models/chat_type.dart';
import 'package:chat/models/gender.dart';
import 'package:chat/models/region.dart';
import 'package:chat/widgets/extensions/context_x.dart';
import 'package:chat/widgets/styles.dart';
import 'package:flutter/material.dart';

class SearchInfo extends StatefulWidget {
  final ValueNotifier<Gender?> myGender;
  final ValueNotifier<AgeRange?> myAgeRange;

  final ValueNotifier<Set<Gender>> lookingForGenders;
  final ValueNotifier<Set<AgeRange>> lookingForAgeRanges;

  final ValueNotifier<Region?> searchRegion;

  final ValueNotifier<ChatMode?> chatMode;

  const SearchInfo({
    super.key,
    required this.myGender,
    required this.myAgeRange,
    required this.lookingForGenders,
    required this.lookingForAgeRanges,
    required this.searchRegion,
    required this.chatMode,
  });

  @override
  State<StatefulWidget> createState() => _SearchInfoState();
}

class _SearchInfoState extends State<SearchInfo> {
  final TextEditingController _searchRegionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    widget.searchRegion.addListener(_updateSearchRegionValue);
    _searchRegionController.text = widget.searchRegion.value?.displayValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton(
            segments: const [
              ButtonSegment(value: Gender.male, label: Text('Я хлопець')),
              ButtonSegment(value: Gender.female, label: Text('Я дівчина')),
            ],
            selected: {widget.myGender.value},
            onSelectionChanged: (genders) => widget.myGender.value = genders.single,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            children: [for (final ageRange in AgeRange.values) _buildMyAgeRangeChip(ageRange)],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          SegmentedButton(
            segments: const [
              ButtonSegment(value: Gender.male, label: Text('Шукаю хлопця')),
              ButtonSegment(value: Gender.female, label: Text('Шукаю дівчину')),
            ],
            selected: widget.lookingForGenders.value,
            multiSelectionEnabled: true,
            onSelectionChanged: (genders) => widget.lookingForGenders.value = genders,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            children: [
              for (final ageRange in AgeRange.values) _buildLookingForAgeRangeChip(ageRange)
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          TextField(
            readOnly: true,
            controller: _searchRegionController,
            // some misbehavior on unfocus
            decoration: textFieldDecoration.copyWith(
              labelText:
                  widget.searchRegion.value == null ? 'Вибери регіон пошуку' : 'Регіон пошуку',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  Region? selectedRegion = widget.searchRegion.value;
                  return AlertDialog(
                    icon: Icon(
                      Icons.travel_explore_outlined,
                      color: context.getColorScheme().secondary,
                    ),
                    title: Column(
                      children: const [
                        Text('Вибери область'),
                        SizedBox(height: 12),
                        Divider(),
                      ],
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (final region in getFrequentRegions().followedBy(getOtherRegions()))
                            RadioListTile(
                              visualDensity: VisualDensity.compact,
                              contentPadding: EdgeInsets.zero,
                              value: region,
                              groupValue: selectedRegion,
                              onChanged: (region) => selectedRegion = region,
                              title: Text(region.displayValue),
                            ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(onPressed: Navigator.of(context).pop, child: Text('Скасувати')),
                      TextButton(
                        onPressed: () {
                          if (selectedRegion != null) {
                            widget.searchRegion.value = selectedRegion;
                          }
                        },
                        child: Text('Ок'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
          SegmentedButton(
            segments: [
              const ButtonSegment(
                value: ChatMode.regular,
                label: Text('Звичайний'),
              ),
              ButtonSegment(
                value: ChatMode.adult,
                label: const Text('Без обмежень'),
                enabled: widget.myAgeRange.value?.isUnder18() != true,
              ),
            ],
            selected: {widget.chatMode.value},
            onSelectionChanged: (chatModes) => widget.chatMode.value = chatModes.first,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.searchRegion.removeListener(_updateSearchRegionValue);

    _searchRegionController.dispose();

    super.dispose();
  }

  Widget _buildMyAgeRangeChip(AgeRange ageRange) {
    return ChoiceChip(
      label: Text(ageRange.displayValue),
      selected: widget.myAgeRange.value == ageRange,
      onSelected: (selected) {
        if (selected && widget.myAgeRange.value != ageRange) {
          widget.myAgeRange.value = ageRange;
        }
      },
    );
  }

  Widget _buildLookingForAgeRangeChip(AgeRange ageRange) {
    final shouldExclude = widget.chatMode.value == ChatMode.adult && ageRange.isUnder18();

    return FilterChip(
      label: Text(ageRange.displayValue),
      selected: shouldExclude ? false : widget.lookingForAgeRanges.value.contains(ageRange),
      onSelected: shouldExclude
          ? null
          : (selected) {
              final ageRanges = widget.lookingForAgeRanges.value.toSet();
              if (selected && !ageRanges.contains(ageRange)) {
                ageRanges.add(ageRange);

                widget.lookingForAgeRanges.value = ageRanges;
              } else if (!selected && ageRanges.contains(ageRange)) {
                ageRanges.remove(ageRange);

                widget.lookingForAgeRanges.value = ageRanges;
              }
            },
    );
  }

  void _updateSearchRegionValue() {
    _searchRegionController.text = widget.searchRegion.value?.displayValue ?? '';
  }
}
