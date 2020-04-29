ECHO OFF
cls
echo ***********************************************************
echo 			GERADOR DE BINARIO
Echo ***********************************************************
echo.
echo ------------------------------------------------------------------------

set Path_Files=C:\Users\BFTC\Desktop\SO Asm

set asm1=#1bootloader.asm
set asm2=#2initialization.asm
set asm3=#3init_interface.asm
set asm4=#4init_interface_edit.asm
set asm5=#5interface_effects.asm
set asm6=#6interface_events.asm
set asm7=#7black_editor.asm
set asm8=#8compiler_programs.asm

set bin1=7-bootloader.bin
set bin2=8-initialization.bin
set bin3=9-init_interface.bin
set bin4=10-init_interface_edit.bin
set bin5=11-interface_effects.bin
set bin6=12-interface_events.bin
set bin7=13-black_editor.bin
set bin8=14-compiler_programs.bin

set file1="%Path_Files%\%asm1%"
set file2="%Path_Files%\%asm2%"
set file3="%Path_Files%\%asm3%"
set file4="%Path_Files%\%asm4%"
set file5="%Path_Files%\%asm5%"
set file6="%Path_Files%\%asm6%"
set file7="%Path_Files%\%asm7%"
set file8="%Path_Files%\%asm8%"

..\Notepad++.lnk %file1% %file2% %file3% %file4% %file5% %file6% %file7% %file8%

set /p ask=Deseja Compilar os arquivos?(Y/N):
if %ask% == 'Y' goto :Compile
if %ask% == 'N' goto :Sair

:Compile

del %bin1%
del %bin2%
del %bin3%
del %bin4%
del %bin5%
del %bin6%
del %bin7%
del %bin8%
echo Arquivos anteriores deletado!
echo.
echo ------------------------------------------------------------------------

echo.

echo ------------------------------------------------------------------------

nasm %asm1% -f bin -o %bin1%
echo Arquivo "%asm1%" compilado!

nasm %asm2% -f bin -o %bin2%
echo Arquivo "%asm2%" compilado!

nasm %asm3% -f bin -o %bin3%
echo Arquivo "%asm3%" compilado!

nasm %asm4% -f bin -o %bin4%
echo Arquivo "%asm4%" compilado!

nasm %asm5% -f bin -o %bin5%
echo Arquivo "%asm5%" compilado!

nasm %asm6% -f bin -o %bin6%
echo Arquivo "%asm6%" compilado!

nasm %asm7% -f bin -o %bin7%
echo Arquivo "%asm7%" compilado!

nasm %asm8% -f bin -o %bin8%
echo Arquivo "%asm8%" compilado!
echo.

echo Gerando arquivo de imagem de disco...
FergoRaw\FergoRaw
echo.

echo Tornando pendrive bootavel...
RufusPortable\RufusPortable
echo.

echo ------------------------------------------------------------------------
set /p resp=Deseja reiniciar o computador?(Y/N):
if %resp% == 'Y' goto :Reiniciar
if %resp% == 'N' goto :Sair

:Reiniciar
 shutdown -r -t 0

:Sair