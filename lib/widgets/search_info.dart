import 'package:chat/models/age_option.dart';
import 'package:chat/models/chat_type.dart';
import 'package:chat/models/gender.dart';
import 'package:chat/models/region.dart';
import 'package:chat/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
  final ValueNotifier<AgeRange?> _lastSelectedLookingForAgeRange = ValueNotifier(null);

  final ItemScrollController _myAgeRangeScrollController = ItemScrollController();
  final ItemScrollController _lookingForAgeRangesScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();

    widget.myAgeRange.addListener(_scrollToMyAgeRangeOnSelected);
    _lastSelectedLookingForAgeRange.addListener(_scrollToLookingForAgeRangeOnSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SegmentedButton(
            segments: const [
              ButtonSegment(value: Gender.male, label: Text('Я хлопець')),
              ButtonSegment(value: Gender.female, label: Text('Я дівчина')),
            ],
            selected: {widget.myGender.value},
            onSelectionChanged: (genders) => widget.myGender.value = genders.single,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: SizedBox(
            height: 48,
            child: ScrollablePositionedList.separated(
              itemCount: AgeRange.values.length,
              scrollDirection: Axis.horizontal,
              initialScrollIndex: _getInitialScrollPositionForMyAgeRange(),
              itemScrollController: _myAgeRangeScrollController,
              itemBuilder: (_, index) => _buildMyAgeRangeChip(AgeRange.values[index]),
              separatorBuilder: (_, __) => const SizedBox(width: 8),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Divider(indent: 20, endIndent: 20),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SegmentedButton(
            segments: const [
              ButtonSegment(value: Gender.male, label: Text('Шукаю хлопця')),
              ButtonSegment(value: Gender.female, label: Text('Шукаю дівчину')),
            ],
            selected: widget.lookingForGenders.value,
            multiSelectionEnabled: true,
            onSelectionChanged: (genders) => widget.lookingForGenders.value = genders,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: SizedBox(
            height: 48,
            child: ScrollablePositionedList.separated(
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              minCacheExtent: 5,
              itemCount: AgeRange.values.length,
              scrollDirection: Axis.horizontal,
              initialScrollIndex: _getInitialScrollPositionForLookingForAgeRanges(),
              itemScrollController: _lookingForAgeRangesScrollController,
              itemBuilder: (_, index) => _buildLookingForAgeRangeChip(AgeRange.values[index]),
              separatorBuilder: (_, __) => const SizedBox(width: 8),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Divider(indent: 20, endIndent: 20),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: DropdownButtonFormField(
            value: widget.searchRegion.value,
            onChanged: (region) => widget.searchRegion.value = region,
            focusNode: FocusNode(canRequestFocus: false),
            // some misbehavior
            decoration: textFieldDecoration.copyWith(
              labelText: 'Вибери регіон пошуку',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            items: [
              for (final region in getFrequentRegions().followedBy(getOtherRegions()))
                DropdownMenuItem(value: region, child: Text(region.displayValue))
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
                label: Text('Звичайний'),
              ),
              ButtonSegment(
                value: ChatMode.adult,
                label: Text('Флірт'),
                enabled: widget.myAgeRange.value?.isUnder18() != true,
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
    widget.myAgeRange.removeListener(_scrollToMyAgeRangeOnSelected);

    _lastSelectedLookingForAgeRange.removeListener(_scrollToLookingForAgeRangeOnSelected);
    _lastSelectedLookingForAgeRange.dispose();

    super.dispose();
  }

  int _getInitialScrollPositionForMyAgeRange() {
    final myAgeRange = widget.myAgeRange.value;
    if (myAgeRange == null) {
      return 0;
    }

    final index = AgeRange.values.indexOf(myAgeRange);
    if (index == AgeRange.values.length - 1) {
      return index - 1;
    }

    return index;
  }

  int _getInitialScrollPositionForLookingForAgeRanges() {
    final lookingForAgeRanges = widget.lookingForAgeRanges.value;
    if (lookingForAgeRanges.isEmpty) {
      return 0;
    }

    final indexOfFirst = AgeRange.values
        .indexWhere((ageRange) => widget.lookingForAgeRanges.value.contains(ageRange));
    if (indexOfFirst == AgeRange.values.length - 1) {
      return indexOfFirst - 1;
    }

    return indexOfFirst;
  }

  Future<void> _scrollToMyAgeRangeOnSelected() {
    final ageRange = widget.myAgeRange.value;
    if (ageRange == null) {
      return Future<void>.value();
    }

    var indexToScroll = AgeRange.values.indexOf(ageRange);
    if (indexToScroll > 2) {
      indexToScroll -= 1;
    }

    return _myAgeRangeScrollController.scrollTo(
      index: indexToScroll == 0 ? 0 : indexToScroll - 1,
      alignment: 0.025,
      duration: const Duration(milliseconds: 250),
    );
  }

  Future<void> _scrollToLookingForAgeRangeOnSelected() {
    final ageRange = _lastSelectedLookingForAgeRange.value;
    if (ageRange == null) {
      return Future<void>.value();
    }

    var indexToScroll = AgeRange.values.indexOf(ageRange);
    if (indexToScroll > 2) {
      indexToScroll -= 1;
    }

    return _lookingForAgeRangesScrollController.scrollTo(
      index: indexToScroll == 0 ? 0 : indexToScroll - 1,
      alignment: 0.025,
      duration: const Duration(milliseconds: 250),
    );
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
                _lastSelectedLookingForAgeRange.value = ageRange;

                ageRanges.add(ageRange);
                widget.lookingForAgeRanges.value = ageRanges;
              } else if (!selected && ageRanges.contains(ageRange)) {
                ageRanges.remove(ageRange);
                if (ageRanges.isEmpty) {
                  _lookingForAgeRangesScrollController.scrollTo(index: 0, duration: Duration(milliseconds: 250));
                }

                _lastSelectedLookingForAgeRange.value = null;

                widget.lookingForAgeRanges.value = ageRanges;
              }
            },
    );
  }
}
