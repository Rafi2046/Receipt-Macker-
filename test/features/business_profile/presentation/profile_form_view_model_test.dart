import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/core/utils/validation_error.dart';
import 'package:receipt_maker/features/business_profile/domain/models/profile_field.dart';
import 'package:receipt_maker/features/business_profile/presentation/view_models/profile_form_state.dart';
import 'package:receipt_maker/features/business_profile/presentation/view_models/profile_form_view_model.dart';
import 'package:receipt_maker/features/business_profile/providers.dart';

import '../../../helpers/test_env.dart';

void main() {
  late TestEnv env;
  late ProviderContainer container;
  late ProviderSubscription<AsyncValue<ProfileFormState>> sub;

  ProfileFormViewModel vm() =>
      container.read(profileFormViewModelProvider.notifier);
  ProfileFormState form() =>
      container.read(profileFormViewModelProvider).requireValue;

  Future<void> open() async {
    container = env.container();
    sub = container.listen(profileFormViewModelProvider, (_, _) {});
    await container.read(profileFormViewModelProvider.future);
  }

  setUp(() async {
    env = TestEnv();
    when(() => env.picker.pickFromGallery())
        .thenAnswer((_) async => (bytes: tinyPng, extension: 'png'));
    await open();
  });
  tearDown(() async {
    container.dispose();
    await env.dispose();
  });

  test('starts with an empty draft and hidden errors', () {
    expect(form().saved, isNull);
    expect(form().draft.name, isEmpty);
    expect(form().errorFor(ProfileField.name), isNull);
    expect(form().errors[ProfileField.name], ValidationError.required);
  });

  test('save is blocked until the name is valid, then persists', () async {
    expect(await vm().save(), isFalse);
    expect(form().errorFor(ProfileField.name), ValidationError.required);

    vm().updateField(ProfileField.name, 'Rahman Traders');
    vm().updateField(ProfileField.phone, '01712345678');
    expect(await vm().save(), isTrue);

    final stored = await container
        .read(businessProfileRepositoryProvider)
        .load();
    expect(stored.valueOrNull?.name, 'Rahman Traders');
    expect(form().hasUnsavedChanges, isFalse);
  });

  test('picking a logo twice before saving leaves one file', () async {
    await vm().pickLogo();
    await vm().pickLogo();
    expect(env.storedImages(), [form().draft.logoPath]);
  });

  test('closing without saving deletes draft images', () async {
    await vm().pickLogo();
    await vm().setSignature(tinyPng);
    expect(env.storedImages(), hasLength(2));
    sub.close();
    container.dispose();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(env.storedImages(), isEmpty);
    container = env.container(); // for tearDown
  });

  test('a saved logo is replaced on disk only after the next save', () async {
    vm().updateField(ProfileField.name, 'Shop');
    await vm().pickLogo();
    await vm().save();
    final first = form().draft.logoPath;

    await vm().pickLogo();
    final second = form().draft.logoPath;
    expect(env.storedImages(), unorderedEquals([first, second]));

    await vm().save();
    expect(env.storedImages(), [second]);
  });

  test('removing the saved signature deletes it after save', () async {
    vm().updateField(ProfileField.name, 'Shop');
    await vm().setSignature(tinyPng);
    await vm().save();
    await vm().removeSignature();
    expect(env.storedImages(), hasLength(1), reason: 'still saved');
    await vm().save();
    expect(env.storedImages(), isEmpty);
  });

  test('re-opening loads the saved profile', () async {
    vm().updateField(ProfileField.name, 'Shop');
    await vm().save();
    sub.close();
    container.dispose();
    await open();
    expect(form().saved?.name, 'Shop');
    expect(form().draft.name, 'Shop');
  });
}
