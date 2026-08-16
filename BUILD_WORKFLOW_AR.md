# 🍎 سير عمل بناء ملف IPA (Workflow لـ iOS IPA Build)

## نظرة عامة
هذا السير العمل مصمم لبناء ملف IPA قابل للتثبيت على أجهزة iOS، مع دعم كامل للترجمة العربية والإعدادات المحلية.

---

## 📋 المتطلبات المسبقة

### 1️⃣ حساب Apple Developer
- حساب Apple ID (مطلوب: حساب مدفوع $99/سنة للاستخدام الإنتاجي)
- أو استخدام TestFlight للتجربة قبل النشر

### 2️⃣ إعداد Mac
```bash
# تثبيت Xcode و Instruments
# تحميل من: https://developer.apple.com/xcode/

# التحقق من Xcode
xcodebuild -version
```

### 3️⃣ إعداد بيئة العمل
```bash
# إنشاء مجلد للمشاريع
mkdir -p ~/Projects/location-spoofer-build
cd ~/Projects/location-spoofer-build

# تهيئة المستودع (git)
git init
```

---

## 🛠️ خطوات البناء (Build Steps)

### الخطوة 1: نسخ الكود إلى Mac 📦
```bash
# من جهاز Windows، قم بنسخ مجلد المشروع
cd C:\Users\aboda\Desktop\Hermes\location-spoofer
tar -czf location-spoofer.tar.gz .

# على جهاز Mac (MacOS/Linux)
mkdir ~/Projects/location-spoofer-build
cd ~/Projects/location-spoofer-build
tar -xzf ~/Downloads/location-spoofer.tar.gz
```

### الخطوة 2: إعداد التواقيع (Signing Configuration) 🔐

#### 2.1 إنشاء Identity & Certificate
```bash
# في Terminal على Mac
security find-identity -v -p codesigning
```

#### 2.2 استخدام Xcode Signing
1. افتح المشروع في Xcode:
   ```bash
   open location-spoofer.xcodeproj
   ```

2. اذهب إلى: **Project Settings → Signing & Capabilities**
3. اختر Team الخاص بك (Apple Developer Account)
4. تأكد من تفعيل: "Automatically manage signing"

### الخطوة 3: إعداد Target Configuration ⚙️

#### 3.1 تحديث Info.plist للعربية
```xml
<key>CFBundleLocalizations</key>
<array>
    <string>ar</string>
    <string>en</string>
</array>
```

#### 3.2 إعداد Locale & Language
في **General → Localization** في Xcode:
- أضف اللغة: العربية (ar)
- افتراضي النظام: ar (عربي) أو en-US (إنجليزي حسب الرغبة)

### الخطوة 4: بناء المشروع (Build Process) 🔨

#### 4.1 عبر Xcode (الطريقة السهلة)
```bash
# في Terminal داخل مجلد المشروع
xcodebuild \
    -scheme location-spoofer \
    -configuration Release \
    -destination generic/platform=iOS \
    clean build
```

#### 4.2 عبر命令行 المباشر
```bash
# بناء لـ iOS Simulator (للجرب فقط)
xcodebuild -scheme location-spoofer \
    -sdk iphonesimulator \
    -configuration Release \
    build

# بناء للتوطين الحقيقي (Real Device)
xcodebuild -scheme location-spoofer \
    -sdk iphoneos \
    -configuration Release \
    -destination 'generic/platform=iOS' \
    archive
```

### الخطوة 5: استخراج ملف IPA 📱

#### 5.1 إنشاء Payload Directory
```bash
# إنشاء مجلد مؤقت للـ Payload
mkdir ~/Payloads

# انتقل إلى المجلد
cd ~/Payloads
```

#### 5.2 تحويل Archive إلى IPA
```bash
# استخدم الـ Product Archive الذي تم إنشاؤه سابقاً
xcodebuild -exportArchive \
    -archivePath ~/Build/Export/archive.xcarchive \
    -exportPath ~/Build/Export/ipa \
    -exportOptionsPlist export_options.plist
```

#### 5.3 ملف export_options.plist
أنشئ ملف `export_options.plist`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>ad-hoc</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID_HERE</string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>stripSwiftSymbols</key>
    <true/>
    <key>waitForProvisioningUpdate</key>
    <true/>
</dict>
</plist>
```

### الخطوة 6: إنشاء ملف IPA النهائي 🎯

#### الطريقة البسيطة (باستخدام Fastlane)
أنشئ ملف `Fastfile`:
```ruby
default_platform(:ios)

platform :ios do
  desc 'Build IPA for distribution'
  lane :build_ipa do
    # إعداد التواقيع
    setup_keychain
    match_type('adhoc')
    
    # البناء
    build(
      workspace: 'location-spoofer.xcworkspace',
      scheme: 'location-spoofer',
      export_method: 'app-store'
    )
    
    # استخراج IPA
    export_options({
      method: 'ad-hoc',
      team_id: ENV['TEAM_ID']
    })
  end
end
```

#### الطريقة اليدوية (بدون Fastlane)
```bash
# إنشاء Payload.zip
cp location-spoofer.ipa ~/Payloads/app.ipa

# ضغط الملف إلى Payload
cd ~/Payloads
zip -r location-spoofer-payload.zip app.ipa

# ملف payload جاهز للتثبيت عبر iTunes/Finder أو TestFlight
```

---

## 🔧 إعدادات إضافية للترجمة العربية

### 1. ملفات التوطين (Localization Files)

أنشئ مجلد `Arabic/` في `location-spoofer/`:

**Arabic/Localizable.strings**
```swift
"LOC_APP_NAME" = "بباو موقع زائف";
"LOC_START_HERE" = "ابدأ الآن";
"LOC_SETTINGS" = "الإعدادات";
"LOC_MODE" = "الوضع";
"LOC_WI_FI_LOCAL" = "محلي عبر Wi-Fi";
"LOC_THIRD_PARTY" = "جهة خارجية";
"LOC_ACTIVE" = "نشط";
"LOC_INACTIVE" = "غير نشط";
"LOC_VERSION" = "الإصدار";
"LOC_ABOUT" = "حول التطبيق";
```

### 2. إعدادات الـ Locale في Swift

في `Info.plist`:
```xml
<key>LSMinimumSystemVersion</key>
<string>15.0</string>

<key>CFBundleDevelopmentRegion</key>
<string>en</string>

<key>CFBundleLocalizations</key>
<array>
    <string>ar</string>
    <string>en</string>
</array>
```

### 3. استخدام NSLocalizedString في الكود

استبدل جميع النصوص الثابتة:
```swift
// ❌ غير صحيح
Text("Settings")

// ✅ صحيح بالعربية
Text(NSLocalizedString("LOC_SETTINGS", comment: ""))
```

---

## 🚀 خطوات النشر (Deployment)

### عبر TestFlight (مجاني للتجربة):
```bash
# 1. رفع إلى App Store Connect
xcrun altool --upload-ipa \
    --file location-spoofer.ipa \
    --type ios

# أو عبر Xcode:
# Product → Archive → Distribute App → TestFlight
```

### عبر Ad-Hoc Distribution (للمستخدمين المحددين):
1. تأكد من وجود UDID لجميع الأجهزة المستهدفة
2. في **Xcode → Signing & Capabilities**:
   - أضف UDIDs للأجهزة المطلوبة
3. قم بالبناء كـ "Ad-hoc"

---

## 📱 تثبيت IPA على الجهاز

### الطريقة 1: عبر iTunes/Finder (Windows/Mac)
```bash
# 1. توصيل الجهاز بـ USB
# 2. في Finder/إيطيونز، انقر على أيقونة الجهاز
# 3. "App Library" → "+ Install App"
# 4. اختر ملف .ipa
```

### الطريقة 2: عبر Airdrop (Mac)
```bash
# 1. أرسل ملف IPA إلى الجهاز عبر AirDrop
# 2. افتح الملف على الجهاز
# 3. اضغط "Install"
```

### الطريقة 3: عبر Safari (إذا متاح)
```bash
# 1. رفع IPA على سيرفر آمن
# 2. فتح الرابط على iOS
# 3. "Install from Safari"
```

---

## 🐛 حل المشاكل الشائعة

### مشكلة: "Could not find identity 'name' in keychain"
```bash
# الحل: إعادة إنشاء الـ Certificate
security delete-certificate -f <certificate_hash>
keychain --reset
```

### مشكلة: "No signing certificate"
```bash
# التأكد من تفعيل التوقيع في Xcode
open project.xcodeproj
# Project → Signing & Capabilities → Enable Team
```

### مشكلة: IPA Refused to Install
```bash
# التحقق من الـ UDIDs
cd /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/DeviceSupport

# إزالة وإعادة إضافة UDIDs إذا لزم الأمر
rm -rf ~/Library/MobileDevice/Provisioning\ Profiles/*
rm -rf ~/Library/MobileDevice/Provisioning\ Profiles/
```

---

## 📊 ملف البناء النهائي

المخرج: `~/Payloads/location-spoofer_<version>_<timestamp>.ipa`

الحجم المتوقع: 50-150MB (يعتمد على الـ Assets والـ Frameworks)

---

## ✅ قائمة التحقق النهائية

- [ ] تم إعداد حساب Apple Developer
- [ ] تم إنشاء Certificates & Provisioning Profiles
- [ ] تم تحديث Info.plist باللغات (ar, en)
- [ ] تم استبدال النصوص بـ NSLocalizedString
- [ ] تم البناء بنجاح على Xcode (iOS Device target)
- [ ] تم استخراج ملف IPA
- [ ] تم التحقق من التوقيع الصحيح
- [ ] تمت تجربة التطبيق على جهاز iOS فعلي

---

## 📞 الدعم والمساعدة

لأي مشكلة أو استفسار:
- GitHub Issues: https://github.com/xweiba/location-spoofer/issues
- مستندات Apple: https://developer.apple.com/library/archive/qa/qa1748/
