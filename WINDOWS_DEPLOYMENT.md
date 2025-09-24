# 🏭 Steel Factory Inventory - Windows Deployment Guide

This guide explains how to build and create a Windows installer for the Steel Factory Inventory Management System.

## 📋 Prerequisites

### Required Software:
- **Flutter SDK** (3.35.3 or higher)
- **Visual Studio** with C++ development tools
- **Inno Setup** (for creating installers)
- **Git** (for version control)

### System Requirements:
- Windows 10/11 (64-bit)
- 8GB RAM minimum
- 2GB free disk space

## 🚀 Quick Start

### Option 1: Automated Build (Recommended)

1. **Run the automated build script:**
   ```cmd
   scripts\build-windows.bat
   ```

2. **Or use PowerShell directly:**
   ```powershell
   .\scripts\build-windows.ps1
   ```

3. **The script will:**
   - Clean previous builds
   - Install dependencies
   - Generate Hive adapters
   - Build Windows application
   - Create installer automatically

### Option 2: Manual Build

1. **Clean and prepare:**
   ```cmd
   flutter clean
   flutter pub get
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

2. **Build Windows application:**
   ```cmd
   flutter build windows --release
   ```

3. **Create installer:**
   - Install Inno Setup from: https://jrsoftware.org/isinfo.php
   - Open `installer.iss` in Inno Setup Compiler
   - Click "Build" to create installer

## 📦 Build Outputs

After successful build, you'll find:

- **Windows Build:** `build\windows\x64\runner\Release\`
- **Installer:** `build\installer\SteelFactoryInventory-Setup-v1.0.0.exe`

## 🔧 Advanced Configuration

### Customizing the Installer

Edit `installer.iss` to customize:

- **App Name:** Change `AppName` value
- **Version:** Update `AppVersion` value
- **Company Info:** Modify `AppPublisher` and URLs
- **Installation Directory:** Change `DefaultDirName`
- **Icons:** Add custom icons to the installer

### Build Script Parameters

```powershell
# Skip build, only create installer
.\scripts\build-windows.ps1 -SkipBuild

# Skip installer, only build
.\scripts\build-windows.ps1 -SkipInstaller

# Custom version
.\scripts\build-windows.ps1 -Version "2.0.0"
```

## 🌐 GitHub Actions (CI/CD)

The project includes automated Windows builds via GitHub Actions:

1. **Push to main/master branch**
2. **GitHub Actions automatically:**
   - Builds Windows application
   - Creates installer
   - Uploads artifacts

3. **Download artifacts from:**
   - GitHub Actions → Your workflow → Artifacts

## 📱 Distribution

### For End Users:
1. **Download installer:** `SteelFactoryInventory-Setup-v1.0.0.exe`
2. **Run installer** as Administrator
3. **Follow installation wizard**
4. **Launch application** from Start Menu or Desktop

### For IT Administrators:
- **Silent installation:** `SteelFactoryInventory-Setup-v1.0.0.exe /SILENT`
- **Custom directory:** `SteelFactoryInventory-Setup-v1.0.0.exe /DIR="C:\CustomPath"`

## 🛠️ Troubleshooting

### Common Issues:

1. **"Flutter not found"**
   - Ensure Flutter is in PATH
   - Run `flutter doctor` to verify installation

2. **"Visual Studio not found"**
   - Install Visual Studio with C++ development tools
   - Install Windows 10/11 SDK

3. **"Inno Setup compilation failed"**
   - Verify Inno Setup is installed
   - Check `installer.iss` syntax
   - Ensure build output exists

4. **"App won't start"**
   - Install Visual C++ Redistributable
   - Check Windows version compatibility

### Debug Mode:
```cmd
flutter build windows --debug
```

## 📊 Build Information

- **Target Platform:** Windows x64
- **Minimum Windows Version:** Windows 7 SP1
- **Architecture:** 64-bit only
- **Dependencies:** Visual C++ Redistributable

## 🔒 Security Notes

- **Code Signing:** Consider code signing for production releases
- **Antivirus:** Some antivirus software may flag unsigned executables
- **Permissions:** Application requires admin rights for installation

## 📞 Support

For deployment issues:
- Check Flutter documentation: https://flutter.dev/docs/deployment/windows
- Inno Setup documentation: https://jrsoftware.org/ishelp/
- Create an issue in the project repository

---

**Happy Deploying! 🚀**
