import 'package:chat/models/age_option.dart';
import 'package:chat/models/chat_type.dart';
import 'package:chat/models/gender.dart';
import 'package:chat/models/region.dart';
import 'package:chat/widgets/search_info.dart';
import 'package:flutter/material.dart';

class RegularSearchScreen extends StatefulWidget {
  const RegularSearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegularSearchScreenState();
}

class _RegularSearchScreenState extends State<RegularSearchScreen> {
  late final ValueNotifier<Gender?> _myGender;
  late final ValueNotifier<AgeRange?> _myAgeRange;

  late final ValueNotifier<Set<Gender>> _lookingForGenders;
  late final ValueNotifier<Set<AgeRange>> _lookingForAgeRanges;

  late final ValueNotifier<Region?> _searchRegion;
  late final ValueNotifier<ChatMode?> _chatMode;

  bool _canPerformSearch = false;

  @override
  void initState() {
    super.initState();

    const myGender = Gender.male;
    const myAge = AgeRange.twentySixAndMore;

    _myGender = ValueNotifier(myGender)..addListener(_setCanPerformSearch);
    _myAgeRange = ValueNotifier(myAge)
      ..addListener(_setCanPerformSearch)
      ..addListener(_handleAdultChatMode);

    final lookingForGenders = {Gender.female};
    final lookingForAgeRanges = {AgeRange.twentyOneToTwentyFive, AgeRange.twentySixAndMore};

    _lookingForGenders = ValueNotifier(lookingForGenders)..addListener(_setCanPerformSearch);
    _lookingForAgeRanges = ValueNotifier(lookingForAgeRanges)..addListener(_setCanPerformSearch);

    const searchRegion = Region.ivanoFrankivsk;
    const chatMode = ChatMode.regular;

    _searchRegion = ValueNotifier(searchRegion)..addListener(_setCanPerformSearch);
    _chatMode = ValueNotifier(chatMode)
      ..addListener(_setCanPerformSearch)
      ..addListener(_handleUnder18AgeRanges);

    _setCanPerformSearch();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: [
        SliverToBoxAdapter(
          child: SearchInfo(
            myGender: _myGender,
            myAgeRange: _myAgeRange,
            lookingForGenders: _lookingForGenders,
            lookingForAgeRanges: _lookingForAgeRanges,
            searchRegion: _searchRegion,
            chatMode: _chatMode,
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton.icon(
                onPressed: _canPerformSearch ? () {} : null,
                icon: const Icon(Icons.search_rounded),
                label: const Text('Шукати співрозмовника'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  dispose() {
    _myGender.removeListener(_setCanPerformSearch);
    _myGender.dispose();

    _myAgeRange.removeListener(_setCanPerformSearch);
    _myAgeRange.removeListener(_handleAdultChatMode);
    _myAgeRange.dispose();

    _lookingForGenders.removeListener(_setCanPerformSearch);
    _lookingForGenders.dispose();

    _lookingForAgeRanges.removeListener(_setCanPerformSearch);
    _lookingForAgeRanges.dispose();

    _searchRegion.removeListener(_setCanPerformSearch);
    _searchRegion.dispose();

    _chatMode.removeListener(_setCanPerformSearch);
    _chatMode.removeListener(_handleUnder18AgeRanges);
    _chatMode.dispose();

    super.dispose();
  }

  void _handleUnder18AgeRanges() {
    if (_chatMode.value == ChatMode.adult &&
        _lookingForAgeRanges.value.any((ageRange) => ageRange.isUnder18())) {
      final ageRanges =
          _lookingForAgeRanges.value.where((ageRange) => !ageRange.isUnder18()).toSet();

      _lookingForAgeRanges.value = ageRanges;
    }
  }

  void _handleAdultChatMode() {
    if ((_myAgeRange.value?.isUnder18() ?? true) && _chatMode.value == ChatMode.adult) {
      _chatMode.value = null;
    }
  }

  void _setCanPerformSearch() {
    setState(() {
      _canPerformSearch = _myGender.value != null &&
          _myAgeRange.value != null &&
          _lookingForGenders.value.isNotEmpty &&
          _lookingForAgeRanges.value.isNotEmpty &&
          _searchRegion.value != null &&
          _chatMode.value != null;
    });
  }
}
