import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/services/ads/consent_service.dart';
import 'package:receipt_maker/core/services/purchases/purchase_providers.dart';

class FakeProStatus extends ProStatus {
  FakeProStatus(this._isPro);
  final bool _isPro;

  @override
  bool build() => _isPro;
}

void main() {
  group('ConsentService & Providers', () {
    test('FakeConsentService tracks form presentation', () async {
      final fake = FakeConsentService(required: true);
      expect(await fake.isPrivacyOptionsRequired(), isTrue);
      expect(fake.formShown, isFalse);

      await fake.showPrivacyOptionsForm();
      expect(fake.formShown, isTrue);
    });

    test(
      'privacyOptionsRequiredProvider is false when isPro is true',
      () async {
        final container = ProviderContainer(
          overrides: [
            proStatusProvider.overrideWith(() => FakeProStatus(true)),
            consentServiceProvider.overrideWithValue(
              FakeConsentService(required: true),
            ),
          ],
        );
        addTearDown(container.dispose);

        final isRequired = await container.read(
          privacyOptionsRequiredProvider.future,
        );
        expect(isRequired, isFalse);
      },
    );

    test(
      'privacyOptionsRequiredProvider checks service when isPro is false',
      () async {
        final fake = FakeConsentService(required: true);
        final container = ProviderContainer(
          overrides: [
            proStatusProvider.overrideWith(() => FakeProStatus(false)),
            consentServiceProvider.overrideWithValue(fake),
          ],
        );
        addTearDown(container.dispose);

        final isRequired = await container.read(
          privacyOptionsRequiredProvider.future,
        );
        expect(isRequired, isTrue);

        fake.required = false;
        container.invalidate(privacyOptionsRequiredProvider);

        final isRequiredAfter = await container.read(
          privacyOptionsRequiredProvider.future,
        );
        expect(isRequiredAfter, isFalse);
      },
    );
  });
}
