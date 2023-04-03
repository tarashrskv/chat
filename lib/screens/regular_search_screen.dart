import 'package:chat/models/age_option.dart';
import 'package:chat/models/gender.dart';
import 'package:chat/widgets/looking_for_info.dart';
import 'package:chat/widgets/my_search_info.dart';
import 'package:flutter/material.dart';

class RegularSearchScreen extends StatefulWidget {
  const RegularSearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegularSearchScreenState();
}

class _RegularSearchScreenState extends State<RegularSearchScreen> {
  late final ValueNotifier<Gender?> _myGenderNotifier;
  late final ValueNotifier<AgeOption?> _myAgeOptionNotifier;

  late final ValueNotifier<Set<Gender>> _lookingForGendersNotifier;
  late final ValueNotifier<Set<AgeOption>> _lookingForAgeOptionsNotifier;

  bool _canPerformSearch = false;

  @override
  void initState() {
    super.initState();

    final myGender = Gender.male;
    final myAge = AgeOption.twentySixAndMore;

    _myGenderNotifier = ValueNotifier(null)..addListener(_listenToChanges);
    _myAgeOptionNotifier = ValueNotifier(null)..addListener(_listenToChanges);

    final lookingForGender = { Gender.female};
    final lookingForAge = { AgeOption.twentyOneToTwentyFive, AgeOption.twentySixAndMore};

    _lookingForGendersNotifier = ValueNotifier(lookingForGender)..addListener(_listenToChanges);
    _lookingForAgeOptionsNotifier = ValueNotifier(lookingForAge)..addListener(_listenToChanges);
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
              MySearchInfo(
                genderNotifier: _myGenderNotifier,
                ageOptionNotifier: _myAgeOptionNotifier,
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              LookingForInfo(
                gendersNotifier: _lookingForGendersNotifier,
                ageOptionsNotifier: _lookingForAgeOptionsNotifier,
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
    _myGenderNotifier.removeListener(_listenToChanges);
    _myGenderNotifier.removeListener(_listenToChanges);

    _myAgeOptionNotifier.removeListener(_listenToChanges);
    _myAgeOptionNotifier.dispose();

    _lookingForGendersNotifier.removeListener(_listenToChanges);
    _lookingForGendersNotifier.dispose();

    _lookingForAgeOptionsNotifier.removeListener(_listenToChanges);
    _lookingForAgeOptionsNotifier.dispose();

    super.dispose();
  }

  _listenToChanges() {
    setState(() {
      _canPerformSearch =
          _myGenderNotifier.value != null &&
          _myAgeOptionNotifier.value != null &&
          _lookingForGendersNotifier.value.isNotEmpty &&
          _lookingForAgeOptionsNotifier.value.isNotEmpty;
    });
  }
}
