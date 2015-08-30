@echo off
setlocal enableextensions enabledelayedexpansion

set zip=C:\Program Files\7-Zip\7z.exe
if not exist "%zip%" goto :zipnotfound

set name=
for %%* in (.) do set name=%%~nx*
echo Packaging: %name%

for /F "tokens=3" %%i in ('findstr /C:"## Version:" %name%.txt') do set version=%%i
echo Version: %version%

md tmp\%name%

for /F %%i in ('findstr ".lua .xml" %name%.txt') do (
  set file=%%i

  if !file:$^(language^)^=! == !file! (
    xcopy /E !file! tmp\%name%
  ) else (
    xcopy /C /E /Y !file:$^(language^)=EN! tmp\%name%
    xcopy /C /E /Y !file:$^(language^)=DE! tmp\%name%
    xcopy /C /E /Y !file:$^(language^)=FR! tmp\%name%
  )
)

exit /B

set archive=%name%-%version%.zip

cd tmp
"%zip%" a -tzip ..\%archive% %name%
cd ..
rd /S /Q tmp

echo.
echo Done

pause
exit /B

:zipnotfound
echo 7-Zip cannot be found, get it at http://www.7-zip.org
pause
exit /B
