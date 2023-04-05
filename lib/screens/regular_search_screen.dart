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
  late final ValueNotifier<AgeOption?> _myAgeOption;

  late final ValueNotifier<Set<Gender>> _lookingForGenders;
  late final ValueNotifier<Set<AgeOption>> _lookingForAgeOptions;

  late final ValueNotifier<Region?> _searchRegion;
  late final ValueNotifier<ChatMode?> _chatMode;

  bool _canPerformSearch = false;

  @override
  void initState() {
    super.initState();

    const myGender = Gender.male;
    const myAge = AgeOption.twentySixAndMore;

    _myGender = ValueNotifier(myGender)..addListener(_setCanPerformSearch);
    _myAgeOption = ValueNotifier(myAge)
      ..addListener(_setCanPerformSearch)
      ..addListener(_handleAdultChatMode);

    final lookingForGenders = {Gender.female};
    final lookingForAgeOptions = {AgeOption.twentyOneToTwentyFive, AgeOption.twentySixAndMore};

    _lookingForGenders = ValueNotifier(lookingForGenders)..addListener(_setCanPerformSearch);
    _lookingForAgeOptions = ValueNotifier(lookingForAgeOptions)..addListener(_setCanPerformSearch);

    const searchRegion = Region.ivanoFrankivsk;
    const chatMode = ChatMode.regular;

    _searchRegion = ValueNotifier(searchRegion)..addListener(_setCanPerformSearch);
    _chatMode = ValueNotifier(chatMode)
      ..addListener(_setCanPerformSearch)
      ..addListener(_handleUnder18AgeOptions);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchInfo(
                myGender: _myGender,
                myAgeOption: _myAgeOption,
                lookingForGenders: _lookingForGenders,
                lookingForAgeOptions: _lookingForAgeOptions,
                searchRegion: _searchRegion,
                chatMode: _chatMode,
              ),
            ],
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
              )),
        ),
      ],
    );
  }

  @override
  dispose() {
    _myGender.removeListener(_setCanPerformSearch);
    _myGender.dispose();

    _myAgeOption.removeListener(_setCanPerformSearch);
    _myAgeOption.removeListener(_handleAdultChatMode);
    _myAgeOption.dispose();

    _lookingForGenders.removeListener(_setCanPerformSearch);
    _lookingForGenders.dispose();

    _lookingForAgeOptions.removeListener(_setCanPerformSearch);
    _lookingForAgeOptions.dispose();

    _searchRegion.removeListener(_setCanPerformSearch);
    _searchRegion.dispose();

    _chatMode.removeListener(_setCanPerformSearch);
    _chatMode.removeListener(_handleUnder18AgeOptions);
    _chatMode.dispose();

    super.dispose();
  }

  void _handleUnder18AgeOptions() {
    if (_chatMode.value == ChatMode.adult &&
        _lookingForAgeOptions.value.any((ageOption) => ageOption.isUnder18())) {
      final ageOptions =
          _lookingForAgeOptions.value.where((ageOption) => !ageOption.isUnder18()).toSet();

      _lookingForAgeOptions.value = ageOptions;
    }
  }

  void _handleAdultChatMode() {
    if ((_myAgeOption.value?.isUnder18() ?? true) && _chatMode.value == ChatMode.adult) {
      _chatMode?.value = null;
    }
  }

  void _setCanPerformSearch() {
    setState(() {
      _canPerformSearch = _myGender.value != null &&
          _myAgeOption.value != null &&
          _lookingForGenders.value.isNotEmpty &&
          _lookingForAgeOptions.value.isNotEmpty &&
          _searchRegion.value != null &&
          _chatMode.value != null;
    });
  }
}
