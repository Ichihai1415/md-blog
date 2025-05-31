@echo off
setlocal DisableDelayedExpansion
set "BANG=!"
setlocal EnableDelayedExpansion

REM ユーザーに小さい側のサイズを入力してもらう
set /p TARGET_SIZE="小さい側のサイズを入力してください (例: 720): "

for %%F in (*.jpg) do (
    REM ImageMagick で画像の幅と高さを取得（例: "1920 1080"）
    for /f "tokens=1,2 delims= " %%A in ('magick identify -format "%%w %%h" "%%F"') do (
        set WIDTH=%%A
        set HEIGHT=%%B

        if !WIDTH! GEQ !HEIGHT! (
            REM 横長または正方形の場合：小さい側は高さなので、
            REM 強制的に 16:9 (幅:高さ = 16:9) にする => NEW_HEIGHT = TARGET_SIZE, NEW_WIDTH = TARGET_SIZE * 16 / 9
            set /A NEW_HEIGHT=%TARGET_SIZE%
            set /A NEW_WIDTH=!NEW_HEIGHT! * 16 / 9
        ) else (
            REM 縦長の場合：小さい側は幅なので、
            REM 強制的に 9:16 (幅:高さ = 9:16) にする => NEW_WIDTH = TARGET_SIZE, NEW_HEIGHT = TARGET_SIZE * 16 / 9
            set /A NEW_WIDTH=%TARGET_SIZE%
            set /A NEW_HEIGHT=!NEW_WIDTH! * 16 / 9
        )

        REM 強制リサイズ：末尾の ! (BANG) により、元のアスペクト比を無視して指定サイズに変形（圧縮）します
        magick "%%F" -resize !NEW_WIDTH!x!NEW_HEIGHT!!BANG! "%%F"
    )
)

echo 画像のサイズ変更が完了しました。
pause