This script generates memory initialization hex files for RISC-V SOC Efinity compilation.
By default, memory initialization hex files contains bootloader that retrieve 4K size of application from flash.
If user modifies RAM_SIZE from IP-Manager, you are required to modify bootloader application and recompile in SDK. 
Then, regenerate memory initialization hex using following python script:

Command:
python binGen.py -b <application.bin> -c <SOC type> -t <tap type> -s <ram size> 

<SOC type>
rubysoc
jadesoc
opalsoc

<tap type>
soft
hard

<ram size>
Value same as user chose from IP-Manager.


