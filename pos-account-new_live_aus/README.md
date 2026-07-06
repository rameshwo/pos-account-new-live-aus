# POSAPT

POS System Software To Streamline Your Business
POSApt is a game-changer for businesses looking to streamline their operations and improve customer experience. With its intuitive design, extensive features, and real-time reporting, businesses can make data-driven decisions, increase revenue, and ultimately achieve success.


## Getting Started

Teminal Flutter Path Setup for older and newer version for my personal terminal only
```bash
export PATH="$HOME/development/flutter/bin:$PATH"
```

```bash
export PATH="$HOME/fvm/3.27.4/bin:$PATH"
```


This project is a starting point for a Flutter application.
```bash
flutter clean && flutter pub get
```

###  IOS Clean
```bash
flutter clean && flutter pub get && cd ios && pod install && cd ..
```

###  Build apk for user testing
```bash
flutter build apk --split-per-abi -t lib/main_uat.dart --release --android-skip-build-dependency-validation && cd build/app/outputs/flutter-apk && cp app-arm64-v8a-release.apk pos_uat_aus.apk && cp -f pos_uat_aus.apk  /Users/volgaimac/Library/CloudStorage/GoogleDrive-coffyee.offee@gmail.com/My\ Drive/Apk && cd -
```

###  Build apk for production
```bash
flutter build apk --split-per-abi -t lib/main_prod.dart --release --android-skip-build-dependency-validation && cd build/app/outputs/flutter-apk && cp app-arm64-v8a-release.apk pos_live_aus.apk && cp -f pos_live_aus.apk  /Users/volgaimac/Library/CloudStorage/GoogleDrive-coffyee.offee@gmail.com/My\ Drive/Apk && cd -
```

###  Build appbundle for production
```bash
flutter build appbundle -t lib/main_prod.dart --release --android-skip-build-dependency-validation
```