flutter build apk --split-per-abi
adb install -r -d $(PWD)/build/app/outputs/apk/release/app-arm64-v8a-release.apk
