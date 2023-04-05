import 'package:chat/models/age_option.dart';
import 'package:chat/models/chat_type.dart';
import 'package:chat/models/gender.dart';
import 'package:chat/models/region.dart';
import 'package:chat/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SearchInfo extends StatefulWidget {
  final ValueNotifier<Gender?> myGender;
  final ValueNotifier<AgeOption?> myAgeOption;

  final ValueNotifier<Set<Gender>> lookingForGenders;
  final ValueNotifier<Set<AgeOption>> lookingForAgeOptions;

  final ValueNotifier<Region?> searchRegion;
  final ValueNotifier<ChatMode?> chatMode;

  const SearchInfo({
    super.key,
    required this.myGender,
    required this.myAgeOption,
    required this.lookingForGenders,
    required this.lookingForAgeOptions,
    required this.searchRegion,
    required this.chatMode,
  });

  @override
  State<StatefulWidget> createState() => _SearchInfoState();
}

class _SearchInfoState extends State<SearchInfo> {
  ValueNotifier<AgeOption?> _lastSelectedLookingForAgeOption = ValueNotifier(null);

  final ItemScrollController _myAgeOptionScrollController = ItemScrollController();
  final ItemScrollController _lookingForAgeOptionsScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();

    widget.myAgeOption.addListener(_scrollToMyAgeOptionOnSelected);
    _lastSelectedLookingForAgeOption.addListener(_scrollToLookingForAgeOptionOnSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: SizedBox(
            height: 48,
            child: ScrollablePositionedList.builder(
              initialScrollIndex: _getInitialScrollPositionForMyAgeOption(),
              itemScrollController: _myAgeOptionScrollController,
              scrollDirection: Axis.horizontal,
              itemCount: AgeOption.values.length,
              itemBuilder: (_, index) {
                final ageOption = AgeOption.values[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text(ageOption.displayValue),
                    selected: widget.myAgeOption.value == ageOption,
                    onSelected: (selected) {
                      if (selected && widget.myAgeOption.value != ageOption) {
                        widget.myAgeOption.value = ageOption;
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Divider(indent: 16, endIndent: 16),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: SizedBox(
            height: 48,
            child: ScrollablePositionedList.builder(
              initialScrollIndex: _getInitialScrollPositionForLookingForAgeOptions(),
              scrollDirection: Axis.horizontal,
              itemScrollController: _lookingForAgeOptionsScrollController,
              itemCount: AgeOption.values.length,
              itemBuilder: (_, index) {
                final ageOption = AgeOption.values[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: _buildLookingForAgeOptionChip(ageOption),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Divider(indent: 16, endIndent: 16),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: DropdownButtonFormField(
            onChanged: (region) => widget.searchRegion.value = region,
            focusNode: FocusNode(canRequestFocus: false),
            decoration: textFieldDecoration.copyWith(
                labelText: 'Вибери регіон пошуку',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              items: [
                for (final region in getFrequentRegions().followedBy(getOtherRegions()))
                  DropdownMenuItem(
                    value: region,
                    child: Text(region.displayValue),
                  )
              ],
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SegmentedButton(
            segments: [
              const ButtonSegment(
                value: ChatMode.regular,
                label: Text('Звичайний чат'),
              ),
              ButtonSegment(
                value: ChatMode.adult,
                label: Text('Флірт'),
                enabled: !(widget.myAgeOption.value?.isUnder18() ?? false),
              ),
            ],
            selected: {widget.chatMode.value},
            onSelectionChanged: (chatModes) => widget.chatMode.value = chatModes.first,
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    widget.myAgeOption.removeListener(_scrollToMyAgeOptionOnSelected);

    _lastSelectedLookingForAgeOption.removeListener(_scrollToLookingForAgeOptionOnSelected);
    _lastSelectedLookingForAgeOption.dispose();

    super.dispose();
  }

  int _getInitialScrollPositionForMyAgeOption() {
    final myAgeOption = widget.myAgeOption.value;
    if (myAgeOption == null) {
      return 0;
    }

    final index = AgeOption.values.indexOf(myAgeOption);
    if (index == AgeOption.values.length - 1) {
      return index - 1;
    }

    return index;
  }

  int _getInitialScrollPositionForLookingForAgeOptions() {
    final lookingForAgeOptions = widget.lookingForAgeOptions.value;
    if (lookingForAgeOptions.isEmpty) {
      return 0;
    }

    final indexOfFirst = AgeOption.values
        .indexWhere((ageOption) => widget.lookingForAgeOptions.value.contains(ageOption));
    if (indexOfFirst == AgeOption.values.length - 1) {
      return indexOfFirst - 1;
    }

    return indexOfFirst;
  }

  Future<void> _scrollToMyAgeOptionOnSelected() {
    final myAgeOption = widget.myAgeOption.value;
    if (myAgeOption == null) {
      return Future<void>.value();
    }

    var index = AgeOption.values.indexOf(widget.myAgeOption.value!);
    if (index > 2) {
      index -= 1;
    }

    return _myAgeOptionScrollController.scrollTo(
      index: index == 0 ? 0 : index - 1,
      alignment: 0,
      duration: const Duration(milliseconds: 250),
    );
  }

  Future<void> _scrollToLookingForAgeOptionOnSelected() {
    if (_lastSelectedLookingForAgeOption.value == null) {
      return Future<void>.value();
    }

    var index = AgeOption.values.indexOf(_lastSelectedLookingForAgeOption.value!);
    if (index > 2) {
      index -= 1;
    }

    return _lookingForAgeOptionsScrollController.scrollTo(
      index: index == 0 ? 0 : index - 1,
      duration: const Duration(milliseconds: 250),
    );
  }

  Widget _buildLookingForAgeOptionChip(AgeOption ageOption) {
    shouldExcludeUnder18() => widget.chatMode.value == ChatMode.adult && ageOption.isUnder18();

    return FilterChip(
      label: Text(ageOption.displayValue),
      selected: shouldExcludeUnder18() ? false : widget.lookingForAgeOptions.value.contains(ageOption),
      onSelected: shouldExcludeUnder18()
          ? null
          : (selected) {
              final ageOptions = widget.lookingForAgeOptions.value;
              if (selected && !ageOptions.contains(ageOption)) {
                _lastSelectedLookingForAgeOption.value = ageOption;

                ageOptions.add(ageOption);
                widget.lookingForAgeOptions.value = ageOptions;
              } else if (!selected && ageOptions.contains(ageOption)) {
                ageOptions.remove(ageOption);
                widget.lookingForAgeOptions.value = ageOptions;
              }
            },
    );
  }
}
