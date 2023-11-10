import 'package:autozone/domain/new_auto_repo/auto.dart';
import 'package:autozone/domain/new_auto_repo/iauto.dart';
import 'package:autozone/domain/otp_repo/iforgot_pin.dart';
import 'package:autozone/domain/otp_repo/forgot_pin.dart';
import 'package:autozone/domain/pin_repo/ipin_repo.dart';
import 'package:autozone/domain/pin_repo/pin_repo.dart';
import 'package:autozone/domain/registration/iregistration.dart';
import 'package:autozone/domain/registration/registration.dart';
import 'package:autozone/domain/tex_place_repo/itex_place_repo.dart';
import 'package:autozone/domain/tex_place_repo/tex_place_repo.dart';
import 'package:autozone/utils/service_provider.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';

extension ServiceProviderExtensions on ServiceCollection {
  ServiceCollection addDomain() {
    ServiceProvider.registerTransient<IPinRepo>(
      (optional, required, platform) => PinRepo(),
    );

    ServiceProvider.registerSingleton<IAuto>(
        (optional, required, platform) => Auto());

    ServiceProvider.registerSingleton<IRegistration>(
        (optional, required, platform) => Registration());

    ServiceProvider.registerSingleton<IForgotPin>(
        (optional, required, platform) => ForgotPin());

    ServiceProvider.registerSingleton<ITexPlaceRepo>(
        (optional, required, platform) => TexPlaceRepo()
    );

    return this;
  }
}
