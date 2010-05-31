; Ken Mazaika
; VolumeOSD.nsi
; Provides an installer for VolumeOSD project.

!include "MUI.nsh"            ;; GUI Style Wizard Interface
!include LogicLib.nsh         ;; Required for conditionals
!include DotNET20.nsh         ;; This file deals with making sure the correct version of .NET is installed
!include VersionCheck.nsh     ;; Required to compare versions
!include "FileAssociation.nsh"

; Global Bindings
!define DOTNET_VERSION "2.0"
!define INSTALLED_NAME  "VolumeOSD"   ;; This is the name that will go into the Add/Remove
!define VERSION "1.0.0.06"                                   ;; Version of the application
!define APPLICATION_TITLE_NAME "VolumeOSD"


Name "VolumeOSD"
OutFile "VolumeOSD_v${VERSION}_setup.exe"

;Default installation folder
InstallDir "$PROGRAMFILES\KenMazaika\VolumeOSD"

;Get installation folder from registry if available
InstallDirRegKey HKLM "Software\KenMazaika\VolumeOSD" ""

;Interface Settings
  !define MUI_ABORTWARNING
;Pages
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;Languages
  !insertmacro MUI_LANGUAGE "English"

;------------------
;Installer Sections
;------------------

  ;; Select what icons to use: use the orange ones by default
  Icon "orange-install.ico"
  UninstallIcon "orange-uninstall.ico"
;-----------------
; FUNCTIONS      ;
;-----------------

;; .onInit is a function that is automatically called as soon as the installer is launched.
;; The function that it servers here is to determine if there is already a version of the
;; application installed on the system and react accordingly.
Function .onInit
   ;Find the version number currently installed, store it to $0
   ReadRegStr $0 HKLM "Software\KenMazaika\VolumeOSD" "Version"

   ;;If there is no key at that location, it means the program has not been installed, do that case
   IfErrors NotInstalled

   ;;Compare the versions using the VersioncheckV5 macro
   !insertmacro VersionCheckV5  $0 ${VERSION} $1

   ${if} $1 == 0
      ;;  If the version compare produced 0, it means the same verion
      ;;  is attempted to be installed again.  This is a reinstall.
      ;;  Now check the database revision
            MessageBox MB_OK "This version is currently installed.  Follow the prompts to reininstall."
            ReadRegStr $0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\VolumeOSD" "UninstallString"
            ExecWait '"$0"'
            GoTo End

   ${elseif} $1 == 1
      ;;  The version attempted to be installed is less than the version
      ;;  that is currently on the user's machine.  In this case, the
      ;;  user will be alerted that downgrades are not supported and the
      ;;  installer will quit.
      MessageBox MB_OK "Downgrading software is not supported, if you really wish to downgrade you will manually need to uninstall the version that is on your system first."
      Abort
   ${elseif} $1 == 2
      ;;  This is an upgrade.  Any backing up of the database or various
      ;;  upgrade procedures will need to be done here, otherwise all
      ;;  the files will be overwritten.
      MessageBox MB_OK "Thank you for upgrading your software.  All the program files will be automatically overwritten."
      GoTo End
   ${else}
      ;;   The version checking function found in the NSIS development
      ;;   area failed.  This should never happen.
      MessageBox MB_OK "VersionCheckV5 produced a value that it is not allowed to produce, assuming not installed."
      Goto NotInstalled
   ${EndIf}
   GoTo End
   ;; This block of code should never be executed.

   NotInstalled:
   ;;  This block of code is executed only if the program
   ;;  is not currently installed.  Any unusual first time
   ;;  setup should be done here.
   End:
FunctionEnd




;-------------------
;   PAGES
;-------------------
;; Make sure .NET Framework 2.0+ is installed.  If it isn't download it.
Section "NET Framework 2.0" NETFrameworkSec
SectionIn RO
   !insertmacro CheckDotNET ${DOTNET_VERSION}
SectionEnd


;; Program Files Page, if this option is chosen, copy all program files.
Section "VolumeOSD Program Files" ProgramFilesSec  ;! Makes bold
SectionIn RO ;Required Object, cannot be deselected

  ;; Copy the needed files
  SetOutPath "$INSTDIR"
  
  ;; Copy the device layer DLL's
  File VolumeOSDThemeInstaller.exe
  File VolumeOSDThemeInstaller.vshost.exe
  File VolumeOSD.vshost.exe
  File CoreAudioApi.dll
  File VolumeOSD.exe
  File BlueParen.VolumeOSD
  File RedParen.VolumeOSD
  File GreenParen.VolumeOSD
  File ICSharpCode.SharpZipLib.dll
  File WaveLibMixer.dll
  File VolumeOSD.vshost.exe.manifest
  
  ${registerExtension} "$INSTDIR\VolumeOSDThemeInstaller.exe" ".VolumeOSD" "VolumeOSD Theme"
  
  
  ExecWait "$INSTDIR\VolumeOSDThemeInstaller.exe BlueParen.VolumeOSD -A"
  ExecWait "$INSTDIR\VolumeOSDThemeInstaller.exe RedParen.VolumeOSD -S"
  ExecWait "$INSTDIR\VolumeOSDThemeInstaller.exe GreenParen.VolumeOSD -S"
  
  ;; Store installation folder and version
  WriteRegStr HKLM "Software\KenMazaika\VolumeOSD" "" $INSTDIR
  WriteRegStr HKLM "Software\KenMazaika\VolumeOSD" "Version" ${VERSION}
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Run" "VolumeOSD" "$INSTDIR\VolumeOSD.exe"

  ;; Add/Remove Programs Info
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\VolumeOSD" \
                 "DisplayName" "${INSTALLED_NAME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\VolumeOSD" \
                 "UninstallString" "$INSTDIR\Uninstall.exe"

  DetailPrint "Creating Registry Keys..."
  SetDetailsPrint listonly

  ;; Create uninstaller
  SetOutPath $INSTDIR
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  ;; Create shortcuts
  CreateDirectory "$SMPROGRAMS\VolumeOSD"
  CreateShortCut "$SMPROGRAMS\VolumeOSD\VolumeOSD Preview.lnk" "$INSTDIR\VolumeOSD.exe" "-P"
  CreateShortCut "$SMPROGRAMS\VolumeOSD\Restart Daemon.lnk" "$INSTDIR\VolumeOSD.exe"
  CreateShortCut "$SMPROGRAMS\VolumeOSD\Uninstall VolumeOSD.lnk" "$INSTDIR\Uninstall.exe"

  Exec "$INSTDIR\VolumeOSD.exe -p"
SectionEnd

;--------------------------------
;UNINSTALLER SECTION
;--------------------------------
Section "Uninstall"
  SetShellVarContext all
  ExecWait "$INSTDIR\VolumeOSD.exe -Q"
  Delete "$INSTDIR\VolumeOSDThemeInstaller.exe"
  Delete "$INSTDIR\VolumeOSDThemeInstaller.vshost.exe"
  Delete "$INSTDIR\VolumeOSD.vshost.exe"
  Delete "$INSTDIR\CoreAudioApi.dll"
  Delete "$INSTDIR\VolumeOSD.exe"
  Delete "$INSTDIR\Macintosh.VolumeOSD"
  Delete "$INSTDIR\ICSharpCode.SharpZipLib.dll"
  Delete "$INSTDIR\VolumeOSD.vshost.exe.manifest"
  Delete "$INSTDIR\BlueParen.VolumeOSD"
  Delete "$INSTDIR\RedParen.VolumeOSD"
  Delete "$INSTDIR\GreenParen.VolumeOSD"
  Delete "$INSTDIR\WaveLibMixer.dll"
  RmDir "$INSTDIR"
  ;; Delete Registry Keys for the program (ie Version etc)
  DeleteRegKey HKLM "Software\KenMazaika\VolumeOSD"

  ;; Delete information in the add/remove programs list
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\VolumeOSD"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Run\VolumeOSD"
  
  ${unregisterExtension} ".VolumeOSD" "VolumeOSD Theme"
  ;; Remove shortcuts
  Delete "$SMPROGRAMS\VolumeOSD\VolumeOSD Preview.lnk"
  Delete "$SMPROGRAMS\VolumeOSD\Restart Daemon.lnk"
  Delete "$SMPROGRAMS\VolumeOSD\Uninstall VolumeOSD.lnk"
  RmDir "$SMPROGRAMS\VolumeOSD"


  ;; Delete the uninstaller
  Delete "$INSTDIR\Uninstall.exe"

  ;; Deletes this folder
  RmDir "$INSTDIR"
SectionEnd