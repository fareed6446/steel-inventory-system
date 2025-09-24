; Steel Factory Inventory Management System - Windows Installer Script
; This script creates a professional Windows installer using Inno Setup

[Setup]
AppName=Steel Factory Inventory Management
AppVersion=1.0.0
AppPublisher=Steel Factory
AppPublisherURL=https://steelfactory.com
AppSupportURL=https://steelfactory.com/support
AppUpdatesURL=https://steelfactory.com/updates
DefaultDirName={autopf}\SteelFactoryInventory
DefaultGroupName=Steel Factory Inventory
AllowNoIcons=yes
LicenseFile=LICENSE
OutputDir=build\installer
OutputBaseFilename=SteelFactoryInventory-Setup-v1.0.0
Compression=lzma
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin
MinVersion=6.1sp1
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
DisableProgramGroupPage=no
DisableReadyPage=no
DisableFinishedPage=no
ShowLanguageDialog=no
UninstallDisplayIcon={app}\steel_factory_inventory.exe
UninstallDisplayName=Steel Factory Inventory Management

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "LICENSE"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\Steel Factory Inventory"; Filename: "{app}\steel_factory_inventory.exe"; WorkingDir: "{app}"
Name: "{group}\{cm:UninstallProgram,Steel Factory Inventory}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\Steel Factory Inventory"; Filename: "{app}\steel_factory_inventory.exe"; WorkingDir: "{app}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\Steel Factory Inventory"; Filename: "{app}\steel_factory_inventory.exe"; WorkingDir: "{app}"; Tasks: quicklaunchicon

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
    if MsgBox('Microsoft Visual C++ Redistributable is required but not installed.' + #13#10 + #13#10 + 
              'Would you like to download and install it now?', 
              mbConfirmation, MB_YESNO) = IDYES then
    begin
      ShellExec('open', 'https://aka.ms/vs/17/release/vc_redist.x64.exe', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
    end;
  end;
  
  // Check Windows version
  if not IsWin64 then
  begin
    MsgBox('This application requires a 64-bit version of Windows.', mbError, MB_OK);
    Result := False;
  end;
end;

function InitializeUninstall(): Boolean;
begin
  Result := True;
  
  // Ask for confirmation before uninstalling
  if MsgBox('Are you sure you want to completely remove Steel Factory Inventory Management and all of its components?', 
            mbConfirmation, MB_YESNO) = IDNO then
  begin
    Result := False;
  end;
end;
