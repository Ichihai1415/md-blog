@echo off
setlocal DisableDelayedExpansion
set "BANG=!"
setlocal EnableDelayedExpansion

REM ���[�U�[�ɏ��������̃T�C�Y����͂��Ă��炤
set /p TARGET_SIZE="���������̃T�C�Y����͂��Ă������� (��: 720): "

for %%F in (*.jpg) do (
    REM ImageMagick �ŉ摜�̕��ƍ������擾�i��: "1920 1080"�j
    for /f "tokens=1,2 delims= " %%A in ('magick identify -format "%%w %%h" "%%F"') do (
        set WIDTH=%%A
        set HEIGHT=%%B

        if !WIDTH! GEQ !HEIGHT! (
            REM �����܂��͐����`�̏ꍇ�F���������͍����Ȃ̂ŁA
            REM �����I�� 16:9 (��:���� = 16:9) �ɂ��� => NEW_HEIGHT = TARGET_SIZE, NEW_WIDTH = TARGET_SIZE * 16 / 9
            set /A NEW_HEIGHT=%TARGET_SIZE%
            set /A NEW_WIDTH=!NEW_HEIGHT! * 16 / 9
        ) else (
            REM �c���̏ꍇ�F���������͕��Ȃ̂ŁA
            REM �����I�� 9:16 (��:���� = 9:16) �ɂ��� => NEW_WIDTH = TARGET_SIZE, NEW_HEIGHT = TARGET_SIZE * 16 / 9
            set /A NEW_WIDTH=%TARGET_SIZE%
            set /A NEW_HEIGHT=!NEW_WIDTH! * 16 / 9
        )

        REM �������T�C�Y�F������ ! (BANG) �ɂ��A���̃A�X�y�N�g��𖳎����Ďw��T�C�Y�ɕό`�i���k�j���܂�
        magick "%%F" -resize !NEW_WIDTH!x!NEW_HEIGHT!!BANG! "%%F"
    )
)

echo �摜�̃T�C�Y�ύX���������܂����B
pause