@echo off


:: Change to your LLVM installation
set "LLVMPath=C:\Program Files\LLVM"
:: Change to your Visual Studio 2015 installation
set "VSPath=C:\Program Files (x86)\Microsoft Visual Studio 14.0"
:: Change to your Windows Kit version & installation
set "WinSDKVersion=10.0.15063.0"
set "WinSDKPath=C:\Program Files (x86)\Windows Kits\10"
:: Change this to your resulting exe
set "OUTPUT=test.exe"


:: Setup
set "PATH=%PATH%;%LLVMPath%\bin;%VSPath%\VC\bin\amd64"

:: Compiler Flags
set CFLAGS= ^
 -std=c++14 -Wall -Wextra -Wvla

set CPPFLAGS= ^
  -I "%VSPath%\include" ^
  -I "%WinSDKPath%\Include/%WinSDKVersion%\shared" ^
  -I "%WinSDKPath%\Include/%WinSDKVersion%\ucrt" ^
  -I "%WinSDKPath%\Include/%WinSDKVersion%\um"


:: Linker Libs
set LDFLAGS= ^
 -machine:x64 ^
 -nodefaultlib ^
 -subsystem:console

set LDLIBS= ^
 -libpath:"%VSPath%\VC\lib\amd64" ^
 -libpath:"%WinSDKPath%\Lib\%WinSDKVersion%\ucrt\x64" ^
 -libpath:"%WinSDKPath%\Lib\%WinSDKVersion%\um\x64" ^
 libucrt.lib libvcruntime.lib libcmt.lib libcpmt.lib ^
 legacy_stdio_definitions.lib oldnames.lib ^
 legacy_stdio_wide_specifiers.lib ^
 kernel32.lib User32.lib


:: Required Microsoft extensions
set MSEXT= ^
 -fms-compatibility -fdelayed-template-parsing ^
 -fms-compatibility-version=19.10.25019 ^
 -fms-extensions -fvisibility-ms-compat ^
 -mms-bitfields


:: Compiling
@echo on
@for %%f in (*.cc) do (
    clang++.exe "%%~f" -o "%%~nf.o" -c %CFLAGS% %MSEXT%
)

:: Linking
@set "LINK_FILES="
@for %%f in (*.o) do (
    @set "LINK_FILES=%LINK_FILES% %%~f"
)

lld-link.exe %LINK_FILES% -out:"%OUTPUT%" %LDFLAGS% %LDLIBS%


