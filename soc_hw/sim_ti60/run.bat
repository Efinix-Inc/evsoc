@echo off
SETLOCAL EnableDelayedExpansion

set "MyApp=evsoc_ispExample_sim.bin"
::set PATH=%PATH%;<<PATH_TO_MODELSIM>>

set stamp=%DATE:/=-%_%TIME::=-%_%soc
set stamp=%stamp: =%
MD %stamp%

certutil -f -encodehex %MyApp% hex_apps.txt 8

if exist MEM_x16.TXT del MEM_x16.TXT
for /f "tokens=*" %%a in (hex_apps.txt) do (
	set space=%%a
	echo !space: =! >> hex_apps_1.txt
)

if exist hex_apps_trim.txt del hex_apps_trim.txt
for /f "tokens=*" %%a in (hex_apps_1.txt) do (
	call :processLittleEndian %%a
)

for /f "tokens=*" %%a in (hex_apps_trim.txt) do (
   set str=%%a
   set str=00000000000000000000000000000000!str!
   set str=!str: =!
   set str=!str:~-32!
   echo !str:~24,8!>> hex_apps_trim2.txt
   echo !str:~16,8!>> hex_apps_trim2.txt
   echo !str:~8,8!>> hex_apps_trim2.txt
   echo !str:~0,8!>> hex_apps_trim2.txt
)

type hex_dummy.txt hex_apps_trim2.txt > MEM_x16.TXT

del hex_apps_1.txt
del hex_apps.txt
del hex_apps_trim.txt
del hex_apps_trim2.txt

xcopy ..\source_ti60\*.v %stamp%
xcopy ..\source_ti60\axi\*.v %stamp%
xcopy ..\source_ti60\cam\*.v %stamp%
xcopy ..\source_ti60\display\*.v %stamp%
xcopy ..\source_ti60\dma\*.v %stamp%
xcopy ..\source_ti60\hw_accel\*.v %stamp%
xcopy ..\source_ti60\soc\*.v %stamp%
xcopy ..\efinity_project\isp_example_design\Ti60F225_devkit_dsi\*.v %stamp%
xcopy ..\efinity_project\isp_example_design\Ti60F225_devkit_dsi\ip\cam_dma_fifo\*.v %stamp%
xcopy ..\efinity_project\isp_example_design\Ti60F225_devkit_dsi\ip\cam_dma_fifo\*.sv %stamp%
xcopy ..\efinity_project\isp_example_design\Ti60F225_devkit_dsi\ip\cam_pixel_remap_fifo\*.v %stamp%
xcopy ..\efinity_project\isp_example_design\Ti60F225_devkit_dsi\ip\cam_pixel_remap_fifo\*.sv %stamp%
xcopy ..\efinity_project\isp_example_design\Ti60F225_devkit_dsi\ip\csi2_rx_cam\Testbench\modelsim\*.v %stamp%
xcopy ..\efinity_project\isp_example_design\Ti60F225_devkit_dsi\ip\csi2_rx_cam\Testbench\modelsim\*.sv %stamp%
xcopy ..\efinity_project\isp_example_design\Ti60F225_devkit_dsi\ip\dsi_tx_display\Testbench\modelsim\*.v %stamp%
xcopy ..\efinity_project\isp_example_design\Ti60F225_devkit_dsi\ip\dsi_tx_display\Testbench\modelsim\*.sv %stamp%
xcopy ..\efinity_project\isp_example_design\Ti60F225_devkit_dsi\ip\display_dma_fifo\*.v %stamp%
xcopy ..\efinity_project\isp_example_design\Ti60F225_devkit_dsi\ip\display_dma_fifo\*.sv %stamp%
xcopy ..\efinity_project\isp_example_design\Ti60F225_devkit_dsi\ip\hbram\Testbench\modelsim\*.v %stamp%
xcopy ..\efinity_project\isp_example_design\Ti60F225_devkit_dsi\ip\hbram\Testbench\modelsim\*.sv %stamp%
xcopy ..\efinity_project\isp_example_design\Ti60F225_devkit_dsi\ip\hbram\*.vh %stamp%
xcopy ..\efinity_project\isp_example_design\Ti60F225_devkit_dsi\ip\hw_accel_dma_in_fifo\*.v %stamp%
xcopy ..\efinity_project\isp_example_design\Ti60F225_devkit_dsi\ip\hw_accel_dma_in_fifo\*.sv %stamp%
xcopy ..\efinity_project\isp_example_design\Ti60F225_devkit_dsi\ip\hw_accel_dma_out_fifo\*.v %stamp%
xcopy ..\efinity_project\isp_example_design\Ti60F225_devkit_dsi\ip\hw_accel_dma_out_fifo\*.sv %stamp%

xcopy *.bin %stamp%
xcopy *.do %stamp%
xcopy *.v %stamp%
xcopy *.vh %stamp%
xcopy *.TXT %stamp%
xcopy model\*.v %stamp%
xcopy model\*.sv %stamp%
xcopy model\*.vh %stamp%
xcopy model_third_party\*.v* %stamp%
cd %stamp%
del *_softTap.v
del *_tmpl.v
vsim.exe -do sim.do

goto :eof

:processLittleEndian
setlocal EnableExtensions
set "BytesBE=%~1"
if not defined BytesBE goto :EOF

set "BytesCO=%BytesBE%"
set "BytesLE="

:ChangeOrder
set "BytesLE=%BytesLE%%BytesCO:~-2%"
set "BytesCO=%BytesCO:~0,-2%"
if defined BytesCO goto ChangeOrder

echo    Big Endian: %BytesBE%
echo %BytesLE% >> hex_apps_trim.txt

endlocal
goto :eof
