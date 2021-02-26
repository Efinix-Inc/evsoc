@echo off
SETLOCAL EnableDelayedExpansion

set "MyApp=evsoc_ispExample_sim.bin"
::set PATH=%PATH%;<<PATH_TO_MODELSIM>>

set stamp=%DATE:/=-%_%TIME::=-%_%soc
set stamp=%stamp: =%
MD %stamp%

certutil -f -encodehex %MyApp% hex_apps.txt 8

if exist MEM.TXT del MEM.TXT
for /f "tokens=*" %%a in (hex_apps.txt) do (
	set space=%%a
	echo !space: =! >> hex_apps_1.txt
)

if exist hex_apps_trim.txt del hex_apps_trim.txt
for /f "tokens=*" %%a in (hex_apps_1.txt) do (
	
	call :processLittleEndian %%a
)
type hex_dummy.txt hex_apps_trim.txt > MEM.TXT
del hex_apps_1.txt
del hex_apps.txt
del hex_apps_trim.txt

xcopy ..\source\*.v %stamp%
xcopy ..\source\cam\*.v %stamp%
xcopy ..\source\cam\*.vh %stamp%
xcopy ..\source\display\*.v %stamp%
xcopy ..\source\dma\*.v %stamp%
xcopy ..\source\hw_accel\*.v %stamp%
xcopy ..\source\soc\*.v %stamp% 
xcopy ..\efinity_project\isp_example_design\T120F324_devkit_hdmi_640_480\*.v %stamp%
xcopy ..\efinity_project\isp_example_design\T120F324_devkit_hdmi_640_480\ip\cam_dma_fifo\*.v %stamp%
xcopy ..\efinity_project\isp_example_design\T120F324_devkit_hdmi_640_480\ip\cam_pixel_remap_fifo\*.v %stamp%
xcopy ..\efinity_project\isp_example_design\T120F324_devkit_hdmi_640_480\ip\display_dma_fifo\*.v %stamp%
xcopy ..\efinity_project\isp_example_design\T120F324_devkit_hdmi_640_480\ip\hw_accel_dma_in_fifo\*.v %stamp%
xcopy ..\efinity_project\isp_example_design\T120F324_devkit_hdmi_640_480\ip\hw_accel_dma_out_fifo\*.v %stamp%
xcopy *.bin %stamp%
xcopy *.do %stamp%
xcopy *.v %stamp%
xcopy *.vh %stamp%
xcopy *.TXT %stamp%
cd %stamp%
del *_softTap.v
del *_tmpl.v
del dma_socRuby_dual_cam.v
del dma2ddr_wrapper_dual_cam.v
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
