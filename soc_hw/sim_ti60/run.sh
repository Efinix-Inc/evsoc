#!/bin/sh
MyApp="evsoc_ispExample_sim.bin"
#export PATH=$PATH:<<PATH_TO_MODELSIM>>/bin/vsim

stamp=`date +%Y-%m-%d_%H-%M-%S_soc`

if [ -z "$MyApp" ]
then
   echo "MyApp variable isn't set, running DEFAULT_APP..."
   echo "Copy your software bin file, eg.blinkAndEcho.bin to this directory"
   echo "Set MyApp environment variable as your software bin file name"
else
	echo "Converting $MyApp to MEM.TXT"
	app_file="hex_apps.txt"
	app1_file="hex_apps_1.txt"
	appt_file="hex_apps_trim.txt"
	if [ -f "MEM_x16.TXT" ]; then
		rm MEM_x16.TXT
	fi
	
	od -An -vtx1 -w4 $MyApp | cut -c2- > hex_apps.txt
	
	while IFS= read -r line
	do
		echo $line | sed 's/ //g' >> $app1_file 
	done < "$app_file"
	
	while IFS= read -r line
	do
		echo $line | ./endian.sh >> $appt_file 
	done < "$app1_file"
	
	cat hex_dummy.txt hex_apps_trim.txt > MEM_x16.TXT
	
	rm $app_file $app1_file $appt_file  
fi

mkdir -p $stamp
cp ../source_ti60/*.v $stamp
cp ../source_ti60/axi/*.v $stamp
cp ../source_ti60/cam/*.v $stamp
cp ../source_ti60/display/*.v $stamp
cp ../source_ti60/dma/*.v $stamp
cp ../source_ti60/hw_accel/*.v $stamp
#cp ../source_ti60/mipi/*.sv $stamp
cp ../source_ti60/soc/*.v $stamp
cp ../efinity_project/isp_example_design/Ti60F225_devkit_dsi/*.v $stamp
cp ../efinity_project/isp_example_design/Ti60F225_devkit_dsi/ip/cam_dma_fifo/*.v $stamp
cp ../efinity_project/isp_example_design/Ti60F225_devkit_dsi/ip/cam_dma_fifo/*.sv $stamp
cp ../efinity_project/isp_example_design/Ti60F225_devkit_dsi/ip/cam_pixel_remap_fifo/*.v $stamp
cp ../efinity_project/isp_example_design/Ti60F225_devkit_dsi/ip/cam_pixel_remap_fifo/*.sv $stamp
#cp ../efinity_project/isp_example_design/Ti60F225_devkit_dsi/ip/csi2_rx_cam/*.v $stamp
#cp ../efinity_project/isp_example_design/Ti60F225_devkit_dsi/ip/csi2_rx_cam/*.sv $stamp
cp ../efinity_project/isp_example_design/Ti60F225_devkit_dsi/ip/display_dma_fifo/*.v $stamp
cp ../efinity_project/isp_example_design/Ti60F225_devkit_dsi/ip/display_dma_fifo/*.sv $stamp
cp ../efinity_project/isp_example_design/Ti60F225_devkit_dsi/ip/hbram/*.v $stamp
cp ../efinity_project/isp_example_design/Ti60F225_devkit_dsi/ip/hbram/*.sv $stamp
cp ../efinity_project/isp_example_design/Ti60F225_devkit_dsi/ip/hbram/*.vh $stamp
cp ../efinity_project/isp_example_design/Ti60F225_devkit_dsi/ip/hw_accel_dma_in_fifo/*.v $stamp
cp ../efinity_project/isp_example_design/Ti60F225_devkit_dsi/ip/hw_accel_dma_in_fifo/*.sv $stamp
cp ../efinity_project/isp_example_design/Ti60F225_devkit_dsi/ip/hw_accel_dma_out_fifo/*.v $stamp
cp ../efinity_project/isp_example_design/Ti60F225_devkit_dsi/ip/hw_accel_dma_out_fifo/*.sv $stamp
cp *.bin $stamp
cp *.do $stamp
cp *.v $stamp
cp *.vh $stamp
cp *.TXT $stamp
cp model/*.v $stamp
cp model/*.sv $stamp
cp model/*.vh $stamp
cp model_third_party/*.v $stamp
cp model_third_party/*.vh $stamp

cd $stamp
rm -R *_softTap.v
rm -R *_tmpl.v

vsim -do sim.do

