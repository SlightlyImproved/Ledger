:: Package your ESO add-on ready for distribution.
:: Version 1.2 Fri Sep 04 12:31:31 BRT 2015
@echo off
setlocal enableextensions enabledelayedexpansion

set zip=%ProgramFiles%\7-Zip\7z.exe
if not exist "%zip%" goto :zipnotfound

for %%* in (.) do set name=%%~nx*

if not exist %name%.txt (
  echo * Please enter the name of your add-on:
  set /P name=^>
)

for /F "tokens=3" %%i in ('findstr /C:"## Version:" %name%.txt') do set version=%%i

set archive=%name%-%version%.zip

echo * Packaging %archive%...

md .package\%name%

set files=%name%.txt

for /F %%i in ('findstr /B /R "[^#;]" %name%.txt') do (
  set file=%%~nxi
  set files=!files! !file:$^(language^)=*!
)

if exist package.txt (
  for /F "tokens=*" %%i in (package.txt) do (
    set files=!files! %%~nxi
  )
)

robocopy . .package\%name% %files% /S /XD .* /NJH /NJS /NFL /NDL > nul

cd .package
"%zip%" a -tzip -bd ..\%archive% %name% > nul
cd ..
rd /S /Q .package

echo * Done^^!
echo.

pause
exit /B

:zipnotfound
echo 7-Zip cannot be found, get it free at http://www.7-zip.org
pause
exit /B
