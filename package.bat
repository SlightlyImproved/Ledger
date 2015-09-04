:: Package your ESO add-on ready for distribution.
:: Version 1.0 Thu Sep 03 23:09:05 BRT 2015
@echo off
setlocal enableextensions enabledelayedexpansion

set zip=%ProgramFiles%\7-Zip\7z.exe
if not exist "%zip%" goto :zipnotfound

for %%* in (.) do set name=%%~nx*
for /F "tokens=3" %%i in ('findstr /C:"## Version:" %name%.txt') do set version=%%i

set archive=%name%-%version%.zip

echo * Packaging %archive%...

md tmp\%name%

for /F %%i in ('findstr /B /R "[^#;]" %name%.txt') do (
  set file=%%~nxi

  if !file:$^(language^)^=! == !file! (
    set files=!file! !files!
  ) else (
    set files=!file:$^(language^)=EN! !files!
    set files=!file:$^(language^)=DE! !files!
    set files=!file:$^(language^)=FR! !files!
  )
)

robocopy . tmp\%name% %files%%name%.txt /S /XD tmp .git /NJH /NJS /NFL /NDL > nul

cd tmp
"%zip%" a -tzip -bd ..\%archive% %name% > nul
cd ..
rd /S /Q tmp

echo * Done^^!
echo.

pause
exit /B

:zipnotfound
echo 7-Zip cannot be found, get it free at http://www.7-zip.org
pause
exit /B
