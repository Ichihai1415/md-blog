@echo off
setlocal DisableDelayedExpansion
set "BANG=!"
setlocal EnableDelayedExpansion

rem This bat made with copilot.
echo [caution] The original image file will be overwritten. A copy is recommended just in case.
echo [caution] This bat must be copied and placed in the directory with the image files.
echo [notice] Now only convert to 720p size are available. If you want to change size, you can edit this bat file.
echo [notice] Now only jpg files are available. If you want to convert other format file, you can edit this bat file.
echo [notice] You can stop now by pressing the X button on the console.

rem If use variable, change to:  set /p TARGET_SIZE="小さい側のサイズを入力してください (例: 720): "
set TARGET_SIZE=720

echo Ready to start converting?
pause

for %%F in (*.jpg) do (
    rem Get image size
    for /f "tokens=1,2 delims= " %%A in ('magick identify -format "%%w %%h" "%%F"') do (
        set WIDTH=%%A
        set HEIGHT=%%B

        if !WIDTH! GEQ !HEIGHT! (
            rem If Width >= Height
            set /A NEW_HEIGHT=%TARGET_SIZE%
            set /A NEW_WIDTH=!NEW_HEIGHT! * 16 / 9
        ) else (
            rem If Width < Height
            set /A NEW_WIDTH=%TARGET_SIZE%
            set /A NEW_HEIGHT=!NEW_WIDTH! * 16 / 9
        )

        REM Resizing
        echo Doing: magick "%%F" -resize !NEW_WIDTH!x!NEW_HEIGHT!!BANG! "%%F"
        magick "%%F" -resize !NEW_WIDTH!x!NEW_HEIGHT!!BANG! "%%F"
    )
)

echo Image resizing is complete. Press any key to delete the bat file and exit.
pause
del "%~f0"