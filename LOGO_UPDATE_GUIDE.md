# Steel Factory Logo Update Guide

## Overview
The Steel Factory logo has been successfully integrated into the Flutter application code. The custom logo widget (`SteelFactoryLogo`) has been created and implemented in the splash screen.

## What's Been Updated

### 1. Custom Logo Widget
- **File**: `lib/widgets/steel_factory_logo.dart`
- **Features**: 
  - Custom painted factory icon with geometric design
  - Turbocharger graphic with motion lines
  - "STEEL FACTORY" text with proper styling
  - Configurable size, colors, and text display

### 2. Splash Screen Integration
- **File**: `lib/views/splash_screen.dart`
- **Changes**: 
  - Replaced generic factory icon with custom SteelFactoryLogo
  - Updated company name display to use the new logo design
  - Maintained all existing animations and styling

### 3. App Configuration Updates
- **pubspec.yaml**: Updated app name and description
- **Android**: Updated app label in AndroidManifest.xml
- **iOS**: Updated display name and bundle name in Info.plist
- **Web**: Updated manifest.json with new app name and description
- **Windows**: Updated version info in Runner.rc

## Next Steps Required

### App Icons for All Platforms
To complete the logo update, you need to generate app icons for all platforms using the Steel Factory logo design:

#### Android Icons (Required Sizes)
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48)
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72)
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96)
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144)
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192)

#### iOS Icons (Required Sizes)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png` (20x20)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png` (40x40)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png` (60x60)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png` (29x29)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png` (58x58)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png` (87x87)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png` (40x40)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png` (80x80)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png` (120x120)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png` (120x120)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png` (180x180)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png` (76x76)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png` (152x152)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png` (167x167)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png` (1024x1024)

#### Web Icons (Required Sizes)
- `web/icons/Icon-192.png` (192x192)
- `web/icons/Icon-512.png` (512x512)
- `web/icons/Icon-maskable-192.png` (192x192)
- `web/icons/Icon-maskable-512.png` (512x512)

#### macOS Icons (Required Sizes)
- `macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_16.png` (16x16)
- `macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_32.png` (32x32)
- `macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_64.png` (64x64)
- `macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_128.png` (128x128)
- `macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_256.png` (256x256)
- `macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_512.png` (512x512)
- `macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png` (1024x1024)

#### Windows Icon
- `windows/runner/resources/app_icon.ico` (Multi-resolution ICO file)

## Logo Design Specifications

### Color Palette
- **Primary Blue**: #0175C2 (matches current theme)
- **Secondary Blues**: Various shades for depth and contrast
- **White**: Background and highlights
- **Grey/Silver**: Turbocharger details

### Design Elements
1. **Factory Icon**: Geometric, hexagonal base with chimneys and smoke
2. **House Symbol**: Small white house within the factory structure
3. **Turbocharger**: Detailed mechanical illustration with motion lines
4. **Typography**: Bold, sans-serif "STEEL FACTORY" text
5. **Motion Effects**: Speed lines for dynamism

## Tools for Icon Generation

### Recommended Tools
1. **Figma**: For vector design and export
2. **Adobe Illustrator**: Professional vector design
3. **Canva**: Easy online design tool
4. **App Icon Generator**: Online tools like appicon.co or makeappicon.com

### Icon Generation Process
1. Create a high-resolution (1024x1024) version of the Steel Factory logo
2. Ensure the design works well at small sizes (16x16 pixels)
3. Export in PNG format for all required sizes
4. For iOS, ensure icons follow Apple's design guidelines
5. For Android, ensure icons work with adaptive icon system
6. For Windows, create a multi-resolution ICO file

## Testing the Logo Integration

### In-App Testing
1. Run the Flutter app to see the new logo in the splash screen
2. Verify the logo displays correctly on different screen sizes
3. Test the logo animation and transitions

### Platform-Specific Testing
1. **Android**: Build APK and install on device to see app icon
2. **iOS**: Build and run on iOS simulator/device to see app icon
3. **Web**: Run web version to see favicon and PWA icons
4. **Desktop**: Build desktop version to see taskbar/dock icons

## Additional Considerations

### Brand Consistency
- Ensure all app icons maintain the same visual style
- Use consistent colors across all platforms
- Test icons in both light and dark themes where applicable

### Accessibility
- Ensure icons are recognizable at small sizes
- Maintain sufficient contrast for visibility
- Test with accessibility tools

### Legal Considerations
- Ensure you have rights to use the logo design
- Consider trademark registration if needed
- Update copyright notices in app metadata

## Support
If you need help with icon generation or have questions about the implementation, refer to the Flutter documentation on app icons and platform-specific guidelines.


