import 'package:chat/models/age_option.dart';
import 'package:chat/models/gender.dart';
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

  bool _canPerformSearch = false;

  @override
  void initState() {
    super.initState();

    final myGender = Gender.male;
    final myAge = AgeOption.twentySixAndMore;

    _myGender = ValueNotifier(null)..addListener(_listenToChanges);
    _myAgeOption = ValueNotifier(null)..addListener(_listenToChanges);

    final lookingForGender = { Gender.female };
    final lookingForAge = { AgeOption.twentyOneToTwentyFive, AgeOption.twentySixAndMore};

    _lookingForGenders = ValueNotifier(lookingForGender)..addListener(_listenToChanges);
    _lookingForAgeOptions = ValueNotifier(lookingForAge)..addListener(_listenToChanges);
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
                icon: Icon(Icons.search_rounded),
                label: Text('Шукати співрозмовника'),
              ),
            )
          ),
        ),
      ],
    );
  }

  @override
  dispose() {
    _myGender.removeListener(_listenToChanges);
    _myGender.removeListener(_listenToChanges);

    _myAgeOption.removeListener(_listenToChanges);
    _myAgeOption.dispose();

    _lookingForGenders.removeListener(_listenToChanges);
    _lookingForGenders.dispose();

    _lookingForAgeOptions.removeListener(_listenToChanges);
    _lookingForAgeOptions.dispose();

    super.dispose();
  }

  _listenToChanges() {
    setState(() {
      _canPerformSearch =
          _myGender.value != null &&
          _myAgeOption.value != null &&
          _lookingForGenders.value.isNotEmpty &&
          _lookingForAgeOptions.value.isNotEmpty;
    });
  }
}
