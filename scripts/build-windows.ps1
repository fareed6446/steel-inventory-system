# Steel Factory Inventory - Windows Build and Installer Script
# This script builds the Flutter app for Windows and creates an installer

param(
    [switch]$SkipBuild,
    [switch]$SkipInstaller,
    [string]$Version = "1.0.0"
)

Write-Host "🏭 Steel Factory Inventory - Windows Build Script" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

# Check if Flutter is installed
if (!(Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Error "Flutter is not installed or not in PATH. Please install Flutter first."
    exit 1
}

# Check Flutter version
$flutterVersion = flutter --version | Select-String "Flutter" | ForEach-Object { $_.Line.Split()[1] }
Write-Host "📱 Flutter Version: $flutterVersion" -ForegroundColor Green

# Step 1: Clean and get dependencies
if (-not $SkipBuild) {
    Write-Host "🧹 Cleaning previous builds..." -ForegroundColor Yellow
    flutter clean
    
    Write-Host "📦 Getting dependencies..." -ForegroundColor Yellow
    flutter pub get
    
    Write-Host "🔧 Generating Hive adapters..." -ForegroundColor Yellow
    flutter packages pub run build_runner build --delete-conflicting-outputs
    
    # Step 2: Build Windows application
    Write-Host "🏗️ Building Windows application..." -ForegroundColor Yellow
    flutter build windows --release
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "❌ Windows build failed!"
        exit 1
    }
    
    Write-Host "✅ Windows build completed successfully!" -ForegroundColor Green
}

# Step 3: Create installer
if (-not $SkipInstaller) {
    Write-Host "📦 Creating Windows installer..." -ForegroundColor Yellow
    
    # Create installer directory
    $installerDir = "build\installer"
    if (!(Test-Path $installerDir)) {
        New-Item -ItemType Directory -Path $installerDir -Force | Out-Null
    }
    
    # Create Inno Setup script
    $innoScript = @"
[Setup]
AppName=Steel Factory Inventory Management
AppVersion=$Version
AppPublisher=Steel Factory
AppPublisherURL=https://steelfactory.com
AppSupportURL=https://steelfactory.com/support
AppUpdatesURL=https://steelfactory.com/updates
DefaultDirName={autopf}\SteelFactoryInventory
DefaultGroupName=Steel Factory Inventory
AllowNoIcons=yes
LicenseFile=LICENSE
OutputDir=build\installer
OutputBaseFilename=SteelFactoryInventory-Setup-v$Version
Compression=lzma
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin
MinVersion=6.1sp1
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "LICENSE"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\Steel Factory Inventory"; Filename: "{app}\steel_factory_inventory.exe"
Name: "{group}\{cm:UninstallProgram,Steel Factory Inventory}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\Steel Factory Inventory"; Filename: "{app}\steel_factory_inventory.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\Steel Factory Inventory"; Filename: "{app}\steel_factory_inventory.exe"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\steel_factory_inventory.exe"; Description: "{cm:LaunchProgram,Steel Factory Inventory}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: filesandordirs; Name: "{app}"

[Code]
function InitializeSetup(): Boolean;
begin
  Result := True;
  // Check if Visual C++ Redistributable is installed
  if not RegKeyExists(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64') then
  begin
    MsgBox('Microsoft Visual C++ Redistributable is required but not installed.' + #13#10 + 
           'Please install it from: https://aka.ms/vs/17/release/vc_redist.x64.exe', 
           mbError, MB_OK);
    Result := False;
  end;
end;
"@
    
    $innoScript | Out-File -FilePath "installer.iss" -Encoding UTF8
    
    # Check if Inno Setup is installed
    $innoSetupPath = "C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
    if (!(Test-Path $innoSetupPath)) {
        Write-Warning "Inno Setup is not installed. Downloading and installing..."
        
        # Download Inno Setup
        $downloadUrl = "https://files.jrsoftware.org/is/6/innosetup-6.2.2.exe"
        $tempFile = "$env:TEMP\innosetup.exe"
        
        try {
            Invoke-WebRequest -Uri $downloadUrl -OutFile $tempFile -UseBasicParsing
            Write-Host "📥 Downloaded Inno Setup installer" -ForegroundColor Green
            
            # Install Inno Setup silently
            Start-Process -FilePath $tempFile -ArgumentList "/SILENT" -Wait
            Write-Host "📦 Installed Inno Setup" -ForegroundColor Green
            
            # Clean up
            Remove-Item $tempFile -Force
        }
        catch {
            Write-Error "Failed to download Inno Setup: $_"
            Write-Host "Please manually install Inno Setup from: https://jrsoftware.org/isinfo.php" -ForegroundColor Yellow
            exit 1
        }
    }
    
    # Compile installer
    Write-Host "🔨 Compiling installer..." -ForegroundColor Yellow
    & $innoSetupPath "installer.iss"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Installer created successfully!" -ForegroundColor Green
        Write-Host "📁 Installer location: build\installer\SteelFactoryInventory-Setup-v$Version.exe" -ForegroundColor Cyan
    } else {
        Write-Error "❌ Installer compilation failed!"
        exit 1
    }
}

Write-Host "🎉 Build process completed successfully!" -ForegroundColor Green
Write-Host "📋 Summary:" -ForegroundColor Cyan
Write-Host "  - Windows build: build\windows\x64\runner\Release\" -ForegroundColor White
Write-Host "  - Installer: build\installer\SteelFactoryInventory-Setup-v$Version.exe" -ForegroundColor White
Write-Host "  - Version: $Version" -ForegroundColor White
