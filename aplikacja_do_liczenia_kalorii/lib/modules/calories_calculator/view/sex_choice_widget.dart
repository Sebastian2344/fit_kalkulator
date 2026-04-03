import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/model/calories_models.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/viewmodel/gender_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SexChoiceWidget extends ConsumerWidget {
  const SexChoiceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gender = ref.watch(genderProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ChoiceChip(
          label: const Text('Mężczyzna'),
          selected: gender == Gender.male,
          onSelected: (val) =>
              ref.read(genderProvider.notifier).setGender(Gender.male),
        ),
        ChoiceChip(
          label: const Text('Kobieta'),
          selected: gender == Gender.female,
          onSelected: (val) =>
              ref.read(genderProvider.notifier).setGender(Gender.female),
        ),
      ],
    );
  }
}
