# Edge Vision SoC Framework

Welcome to the Edge Vision SoC GitHub repo. Efinix offers an RISC-V SoC framework targeted for edge vision applications, namely Edge Vision SoC (EVSoC) framework. This site provides source codes, example designs, and supporting materials of the EVSoC framework.
- [Overview](#overview)
- [Image Signal Processing Example Design](#image-signal-processing-example-design)
- [Dual-Camera Example Design](#dual-camera-example-design)
- [Hardware and Software Setup](#hardware-and-software-setup)
- [Documentation](#documentation)
- [Videos](#videos)
- [Frequently Asked Questions](#frequently-asked-questions)

## Overview

Key features:
- **Modular building blocks** to facilitate different combinations of system design architecture
- **Established data transfer flow** between main memory and different building blocks through Direct Memory Access (DMA)
- **Ready-to-deploy** domain-specific **I/O peripherals and interfaces** (SW drivers, HW controllers, pre- and post-processing blocks are provided)
- Highly **flexible HW/SW co-design** is feasible (RISC-V performs control & compute, HW accelerator for time-critical computations)
- Enable **quick porting** of users' design for **edge AI and vision solutions**  
<br />

Building blocks to facilitate ease of modification to suit for various system architecture requirements:
- **RISC-V SoC**
- **DMA Controller**
- **Camera**
- **Display**
- **Hardware Accelerator**

## Image Signal Processing Example Design

ISP example design demonstrates a use case on the EVSoC framework, specifically, **hardware/software co-design for video processing**. Additionally, the design shows how user can **control the FPGA hardware using software**, that is, user can enable different hardware acceleration functions by changing firmware in the RISC-V processor. 

This example presents these concepts in the context of video filtering functions; however, user can use the same design with **own hardware accelerator block** instead of the
provided filtering functions. The design helps user explore **accelerating computationally intensive functions** in **hardware** and using **RISC-V software** to **control that acceleration** as well as to **perform computations** that are **inherently sequential or require flexibility**.

![](docs/isp_example_design_top_level.png "ISP Example Design Top-Level Block Diagram")

List of implemented ISP algorithms (available for both SW functions and HW modules):
- RGB to grayscale conversion
- Sobel edge detection
- Binary dilation
- Binary erosion

## Dual-Camera Example Design

Multi-camera vision systems are vital for a wide-range of applications such as video surveillance, security system, robotics, automotive and drone. The benefits of multi-camera vision system over single-camera setup include:
- Resolve occlusion problem
- Provide wider area coverage
- Produce more accurate geometric understanding
<br />

Here presents a dual-camera example design that provides a flexible hardware accelerator socket for processing frame data from multiple camera sources based on the targeted applications.

![](docs/dual_cam_design_top_level.png "Dual-Camera Example Design Top-Level Block Diagram")

List of implemented HW accelerator mode - Merging:
- Merge two horizontally half cropped frame from two camera sources by left and right
- Merge a downscaled overlay from one camera source on top of the frame data from another camera source
<br />

List of implemented HW accelerator mode - Processing:
- Cam source 1 – Passthrough (RGB or Grayscale); Cam source 2 – Passthrough (RGB or Grayscale)
- Cam source 1 – Passthrough (RGB or Grayscale); Cam source 2 – Processed   (Sobel)
- Cam source 1 – Processed   (Sobel);            Cam source 2 – Passthrough (RGB or Grayscale)
- Cam source 1 – Processed   (Sobel);            Cam source 2 – Processed   (Sobel)

## Hardware and Software Setup

The ISP and dual-camera example designs are implemented on:
- [Trion® T120 BGA324 Development Kit](https://www.efinixinc.com/products-devkits-triont120bga324.html).
- [Trion® T120 BGA576 Development Kit](https://www.efinixinc.com/products-devkits-triont120bga576.html).

Efinity® IDE is required for project compilation and bitstream generation, whereas RISC-V SDK (includes Eclipse, OpenOCD Debugger, etc) is used to manage RISC-V software projects and for debugging purposes.

Please refer to [EVSoC User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=UG-EVSOC) to get started.

Below are required hardware setup for ISP and dual-camera example designs:
- Trion® T120 BGA324 Development Kit
![](docs/t120f324_hw_setup.png "Hardware setup for T120 BGA324 development kit")
- Trion® T120 BGA576 Development Kit
![](docs/t120f576_hw_setup.png "Hardware setup for T120 BGA324 development kit")

Note: In *soc_sw/bsp/efinix/EFXRubySoC/openocd/ftdi.cfg* file, *ftdi_device_desc* may need to be updated to match with the targeted board name, which can be identified from the listed USB target in Efinity Programmer. Default *ftdi_device_desc* is set to *Trion T120F324 Development Board*.

### Software Tools Version
- [Efinity® IDE](https://www.efinixinc.com/support/efinity.php) v2021.1.165.1.6
- [RISC-V SDK](https://www.efinixinc.com/support/ip/riscv-sdk.php) v1.1

## Documentation
- [EVSoC User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=UG-EVSOC)
- [Ruby Vision RISC-V SoC Datasheet](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=DS-RUBYV)
- [Trion T120 BGA324 Development Kit User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=T120F324-DK-UG)
- [Trion T120 BGA576 Development Kit User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=T120F576-DK-UG)

## Videos
- [Edge Vision SoC Solution](https://vimeo.com/492359014)
- [ISP Example Design Tutorial - Demonstration](https://vimeo.com/500651950)
- [ISP Example Design Tutorial - Firmware](https://vimeo.com/500660740)
- [ISP Example Design Tutorial - RTL Design](https://vimeo.com/500664581)
- [ISP Example Design Tutorial - Flash Memory Read & Write](https://vimeo.com/516979931)
- [Dual-Camera Example Design Tutorial](https://vimeo.com/516963010)

## Frequently Asked Questions
1.  **Where are the HW/RTL and SW/firmware source files located?**

    The top-level RTL file is named *edge_vision_soc.v*, which is located in respective project folder in *soc_hw/efinity_project* directory. The rest of the RTL files are placed in *soc_hw/source* directory, which are organized according to respective building block. On the other hand, the main firmware file is named *main.c*, which is in *soc_sw/software/\*/src* directory, where other related drivers are provided in the same folder as well.
    
    Below depicts the directory structure of EVSoC framework:
    
    ```
    evsoc
    |-- soc_hw
    |   |-- efinity_project
    |   |   |-- dual_cam_design
    |   |   |   |-- T120F324_devkit_hdmi_1280_720
    |   |   |   |   `-- ip
    |   |   |   `-- T120F576_devkit_hdmi_1280_720
    |   |   |       `-- ip
    |   |   `-- isp_example_design
    |   |       |-- T120F324_devkit_hdmi_1280_720
    |   |       |   `-- ip
    |   |       |-- T120F324_devkit_hdmi_640_480
    |   |       |   `-- ip
    |   |       |-- T120F576_devkit_hdmi_1280_720
    |   |       |   `-- ip
    |   |       `-- T120F576_devkit_hdmi_640_480
    |   |           `-- ip
    |   |-- sim
    |   `-- source
    |       |-- cam
    |       |-- display
    |       |-- dma
    |       |-- hw_accel
    |       `-- soc
    `-- soc_sw
        |-- bsp
        |   `-- efinix
        |       `-- EfxRubySoc
        |           |-- app
        |           |-- include
        |           |-- linker
        |           `-- openocd
        |-- config
        |-- config_linux
        `-- software
            |-- common
            |-- driver
            |-- evsoc_dualCam
            |   `-- src
            |-- evsoc_dualCam_demo
            |   `-- src
            |-- evsoc_ispExample
            |   `-- src
            |-- evsoc_ispExample_demo
            |   `-- src
            |-- evsoc_ispExample_demo2
            |   `-- src
            |-- evsoc_ispExample_sim
            |   `-- src
            |-- evsoc_ispExample_timestamp
            |   `-- src
            |-- evsoc_readFlash
            |   `-- src
            `-- evsoc_writeFlash
                `-- src
    ```
    
    ***Note:*** Source files for Efinix soft-IP(s) are to be generated using IP Manager in Efinity® IDE, where IP settings files are provided in *ip* directory in respective project folder. Please refer to [EVSoC User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=UG-EVSOC) for more detail.
    
2.  **How much is the resource consumption for EVSoC framework?**

    Below are the resource utilization tables compiled for Efinix Trion® T120F324 device using Efinity® IDE v2020.2.
    
    **Resource utilization for ISP example design (640x480 resolution):**
    | Building Block          | LE    | FF    | ADD  | LUT   | MEM (M5K) | DSP (MULT) |
    |-------------------------|:-----:|:-----:|:----:|:-----:|:---------:|:----------:|
    | Edge Vision SoC (Total) | 22349 | 12401 | 3847 | 13025 | 150       | 4          |
    | RISC-V SoC              |   -   | 6158  | 1263 | 6798  | 77        | 4          |
    | DMA Controller          |   -   | 4715  | 1031 | 4858  | 31        | 0          |
    | Camera                  |   -   | 639   | 966  | 641   | 18        | 0          |
    | Display                 |   -   | 180   | 117  | 127   | 10        | 0          |
    | Hardware Accelerator    |   -   | 619   | 444  | 437   | 14        | 0          |
    
    **Resource utilization for ISP example design (1280x720 resolution):**
    | Building Block          | LE    | FF    | ADD  | LUT   | MEM (M5K) | DSP (MULT) |
    |-------------------------|:-----:|:-----:|:----:|:-----:|:---------:|:----------:|
    | Edge Vision SoC (Total) | 22182 | 12422 | 3868 | 12838 | 166       | 4          |
    | RISC-V SoC              |   -   | 6158  | 1263 | 6668  | 77        | 4          |
    | DMA Controller          |   -   | 4715  | 1031 | 4826  | 31        | 0          |
    | Camera                  |   -   | 646   | 973  | 629   | 22        | 0          |
    | Display                 |   -   | 181   | 118  | 131   | 10        | 0          |
    | Hardware Accelerator    |   -   | 632   | 457  | 420   | 26        | 0          |
    
    **Resource utilization for dual-camera example design (1280x720 resolution):**
    | Building Block          | LE    | FF    | ADD  | LUT   | MEM (M5K) | DSP (MULT) |
    |-------------------------|:-----:|:-----:|:----:|:-----:|:---------:|:----------:|
    | Edge Vision SoC (Total) | 31137 | 16261 | 5468 | 19257 | 210       | 4          |
    | RISC-V SoC              |   -   | 6158  | 1263 | 6612  | 77        | 4          |
    | DMA Controller          |   -   | 7652  | 1522 | 10366 | 38        | 0          |
    | Camera (x2)             |   -   | 1292  | 1946 | 1294  | 44        | 0          |
    | Display                 |   -   | 181   | 118  | 115   | 10        | 0          |
    | Hardware Accelerator    |   -   | 854   | 603  | 586   | 41        | 0          |
    
    ***Note:*** Resource values may vary from compile-to-compile due to PnR and updates in RTL. The presented tables are served as reference purposes.

3.  **How to check if the hardware and software setup for ISP example design is done correctly?**
    
    After setting up the hardware and software accordingly (refer to [EVSoC User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=UG-EVSOC) for the detail), user is to program the hardware bitstream (using Efinity Programmer) and software binary (using Eclipse software) to the targeted development kit. 
    
    User is expected to see colour bar on HDMI display, which lasts for 5 seconds. This indicates the HDMI display, RISC-V, and DMA are running correctly. If evsoc_ispExample or evsoc_ispExample_demo* software apps is used, user is expected to see video streaming of camera captured output (default mode) on display after the colour bar. This shows the camera is setup correctly too.
    
    In the case of the above expected outputs are not observed, user is to check on the board, camera, display, software setup, etc., with reference to [EVSoC User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=UG-EVSOC).

4.	**Are the software apps provided in the ISP example design can be used for a different resolution setting?**

    Yes. User is required to update *FRAME_WIDTH* and *FRAME_HEIGHT* parameter values in firmware (*main.c*) accordingly. Default values are set for 1280x720 resolution.

    ***Note:*** Please make sure the parameter values assigned in SW (*main.c*) match with the parameter values (*FRAME_WIDTH* and *FRAME_HEIGHT*) set for HW (*edge_vision_soc.v*).

5.	**How to modify camera input resolution from MIPI interface?**

    For HW, modify *MIPI_FRAME_WIDTH* and *MIPI_FRAME_HEIGHT* parameter values in *edge_vision_soc.v* accordingly. For SW, note to ensure the same set of values are set in camera SW driver (*PiCamDriver.c*) under *PiCam_init()* function, for example:
    ```
    PiCam_Output_Size(1920, 1080); 
    ```
    Refer to *Raspberry Pi Camera Module v2 Datasheet* for more detail about camera setting.

6.	**Why is after enabling Sobel operation (either HW or SW mode) in the firmware, display shows only black with scatter white lines/dots?**

    There are several potential factors that contribute to this, please try out the following adjustments:

    (a) Place an object with high colour contrast such as calendar, brochure, name card, etc., in front of the camera and observe the detected edge outlines. 

    (b) Modify the Sobel threshold value by changing the line:

    ```
    write_u32(100, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG0_OFFSET);
    ```

    in firmware (*main.c*). The Sobel threshold value is to be adjusted based on the lighting condition where the camera operates at. 

    (c) Adjust camera shutter speed to allow for longer exposure time. Refer to Question 7 for the detail.

7.	**How to adjust camera setting for low light condition?**

    User can adjust the camera shuttle speed to allow for longer exposure time. In camera SW driver (*PiCamDriver.c*) under *PiCam_init()* function, comment out the section for shorter exposure time and uncomment the section for longer exposure time. 

    ***Note:*** Increasing camera exposure time would trade-off in lower frame rates. Refer to *Raspberry Pi Camera Module v2 Datasheet* for more detail about camera setting.

8.	**Why is zooming effect observed on ISP example design, especially for 640x480 resolution?**

    This is due to the default setup performs cropping on the incoming 1920x1080 resolution MIPI camera frames to a smaller size eg., 640x480 resolution, prior to further processing. There are two ways to improve the overall captured view for small resolution: (a) Adjust camera binning mode setting in SW; (b) Insert scaler module in HW.

    For (a), user can modify the binning mode setting in camera SW driver (*PiCamDriver.c*) under *PiCam_init()* function. By making the following modifications:

    ```
    //PiCam_SetBinningMode(0, 0);
    PiCam_SetBinningMode(1, 1);
    ```
    
    2x vertical and 2x horizontal binning are performed. After the update, 2x taller and 2x wider frame view can be observed. Refer to *Raspberry Pi Camera Module v2 Datasheet* for more detail about camera setting.

    For (b), please refer to the [reference design](https://www.efinixinc.com/support/ed/t120f324-hdmi-rpi.php) in Efinix support portal for integration of a scaler module.

9.	**Why are captured frames not of central view of the camera?**

    This is due to the default setup for cropping is with X- and Y-offsets *(0,0)*. To adjust the cropping offsets, modify the *CROPPED_X_OFFSET* and *CROPPED_Y_OFFSET* parameter values that are passed to *cam_picam_v2* instance at *edge_vision_soc.v*. 

    ***Note:*** Please make sure parameter values for *(CAM_CROP_X_OFFSET+CROPPED_FRAME_WIDTH)* is less than or equal to *MIPI_FRAME_WIDTH*, and *(CAM_CROP_Y_OFFSET+CROPPED_FRAME_HEIGHT)* is less than or equal to *MIPI_FRAME_HEIGHT*.

10.	**What is the mechanism used to configure and trigger an DMA transfer?**

    RISC-V firmware is used to configure DMA controller through APB3 slave port. SW driver for DMA controller (*dmasg.h*) is in *soc_sw/software/driver* directory.

11.	**How does RISC-V detect completion of a triggered DMA transfer?**

    User can make use of polling or interrupt mode in RISC-V firmware to detect the completion of an DMA transfer. In the ISP example design, DMA completion checking with polling mode is demonstrated in the firmware (*main.c*).

    The following presents an example for converting the default self-restart display DMA channel to make use of interrupt mode to indicate DMA transfer completion of single video frame. In *main.c*, make these changes to the *Trigger Display* section:

    ```
    //SELECT start address of to be displayed data accordingly.
    dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, CAM_START_ADDR, 16);
    //dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, GRAYSCALE_START_ADDR, 16);
    //dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, SOBEL_START_ADDR, 16);
    dmasg_output_stream(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, 0, 0, 1);

    //Add interrupt config command
    dmasg_interrupt_config(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_CHANNEL_INTERRUPT_CHANNEL_COMPLETION_MASK);
    dmasg_direct_start(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, (IMG_WIDTH*IMG_HEIGHT)*4, 0);
    
    //Indicate that the display DMA channel is active
    display_mm2s_active = 1;
    ```
    
    In *dmasg_config.h*, go to the *externalInterrupt()* function and set up the interrupt service subroutine accordingly.

    ```
    void trigger_next_display_dma () {
       dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, CAM_START_ADDR, 16);
       dmasg_output_stream(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, 0, 0, 1);
       dmasg_interrupt_config(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_CHANNEL_INTERRUPT_CHANNEL_COMPLETION_MASK);
       dmasg_direct_start(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, (IMG_WIDTH*IMG_HEIGHT)*4, 0);
    }

    void externalInterrupt(){
      uint32_t claim;
      //While there is pending interrupts
      while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
         switch(claim){
            case PLIC_DMASG_CHANNEL:
               if(display_mm2s_active && !(dmasg_busy(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL))) {
                  trigger_next_display_dma();
               }
               break;
            default: crash(); break;
         }
         plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); //unmask the claimed interrupt
      }
    }
    ```

12. **How to customize RISC-V firmware for different HW/SW scenarios available in the ISP example design?**

    Please refer to *Customizing the Firmware* section in [EVSoC User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=UG-EVSOC) for the detail.

13. **How to replace the example ISP hardware accelerator core with user custom accelerator?**

    Please refer to *Using Your Own Hardware Accelerator* section in [EVSoC User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=UG-EVSOC) for the detail.

14.	**How to obtain processing frame rate of a specific scenario in the ISP example design?**
    
    Software app *evsoc_ispExample_timestamp* is provided in *soc_sw/software* directory for this purpose. MIPI camera input frame rate is determined by a hardware counter in camera building block, whereas software timestamp method is used for the processing frame rate profiling purposes. Formulae used to compute frames/second and seconds/frame are provided in the *main.c*. 
