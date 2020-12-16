#!/bin/sh
MyApp="evsoc_ispExample_sim.bin"
#export PATH=$PATH:<<PATH_TO_MODELSIM>>/bin/vsim

app_file="hex_apps.txt"
app1_file="hex_apps_1.txt"
appt_file="hex_apps_trim.txt"
stamp=`date +%Y-%m-%d_%H-%M-%S_soc`
byte=32

if [ -f "MEM.TXT" ]; then
	rm MEM.TXT
fi

od -An -vtx1 -w16 $MyApp | cut -c2- > hex_apps.txt

while IFS= read -r line
do
	echo $line | sed 's/ //g' >> $app1_file 
done < "$app_file"

while IFS= read -r line
do
	echo $line | ./endian.sh >> $appt_file 
done < "$app1_file"

cat hex_dummy.txt hex_apps_trim.txt > MEM.TXT

rm $app_file $app1_file $appt_file  

mkdir -p $stamp
cp ../source/*.v $stamp
cp ../source/cam/*.v $stamp
cp ../source/cam/*.vh $stamp
cp ../source/display/*.v $stamp
cp ../source/dma/*.v $stamp
cp ../source/hw_accel/*.v $stamp
cp ../source/soc/*.v $stamp
cp ../efinity_project/T120F324_devkit_hdmi_640_480/*.v $stamp
cp ../efinity_project/T120F324_devkit_hdmi_640_480/ip/cam_dma_fifo/*.v $stamp
cp ../efinity_project/T120F324_devkit_hdmi_640_480/ip/cam_pixel_remap_fifo/*.v $stamp
cp ../efinity_project/T120F324_devkit_hdmi_640_480/ip/display_dma_fifo/*.v $stamp
cp ../efinity_project/T120F324_devkit_hdmi_640_480/ip/hw_accel_dma_in_fifo/*.v $stamp
cp ../efinity_project/T120F324_devkit_hdmi_640_480/ip/hw_accel_dma_out_fifo/*.v $stamp
cp *.bin $stamp
cp *.do $stamp
cp *.v $stamp
cp *.vh $stamp
cp *.TXT $stamp

cd $stamp
rm -R *_softTap.v
rm -R *_tmpl.v
vsim -do sim.do

