===================================================================================================
Lauterbach TRACE32 Debug Scripts for SapphireSoC
===================================================================================================

This folder contains sample debug scripts for Lauterbach TRACE32 software, to debug SapphireSoC.

This folder contains 4 debug scripts, which are:
1. debug.cmm
   - Halt and reset the system, load and program software ELF file into the system, 
     and start debugging from the beginning of software.

2. attach.cmm
   - Halt the system, load ELF file for debugging symbols (not re-programming the system),
     then start debugging from the point where the system was before it was halted.

3. freertos.cmm
   - To debug FreeRTOS.

4. smp.cmm
   - To debug multicore system. 


-------------
HOW TO USE
-------------
1. Look for the command "Data.LOAD.Elf" within the scripts, change the ELF file path,
   to the path to your ELF file.

2. For SMP debugging, you might need to further modify the smp.cmm script according to the 
   number of cores in your SapphireSoC.

3. You may further modify the scripts to fit your environment/system/personal preference.


For more information on Lauterbach TRACE32 software and its commands:
   - Debugger tutorial: https://www2.lauterbach.com/pdf/debugger_tutorial.pdf
   - RISC-V Debugger:   https://www2.lauterbach.com/pdf/debugger_riscv.pdf
   - Lauterbach TRACE32 General Commands Reference Guide (multiple volumes)
   - Lauterbach official website: https://www.lauterbach.com/
 
