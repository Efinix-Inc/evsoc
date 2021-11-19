import binascii
import argparse
import csv
import json
import os
import cmd
import time
import codecs
from io import StringIO

binDatal        = []
binData_binaryl = []

regfile		= ".v_toplevel_system_cpu_logic_cpu_RegFilePlugin_regFile.bin"
rom0Hex         = ".v_toplevel_system_ramA_logic_ram_symbol0.bin"
rom1Hex         = ".v_toplevel_system_ramA_logic_ram_symbol1.bin"
rom2Hex         = ".v_toplevel_system_ramA_logic_ram_symbol2.bin"
rom3Hex         = ".v_toplevel_system_ramA_logic_ram_symbol3.bin"
softTap         = "_softTap"

def binSplit (start, romHex, ramsize):
    rom_l           = []
    for x in range (start, len(binData_binaryl), 4):
        rom_l.append(binData_binaryl[x])
        
    padNumber = (ramsize >> 2)-len(rom_l)
    
    for x in range (0, padNumber):
        rom_l.append("00000000")

    f = open(romHex ,'w')
    for x in range(0, len(rom_l)):
        f.write(rom_l[x]+"\n")
    f.close

def app_binSplit(args):
    
    ramSize = int(args.sizeram)
    
    if(args.tap == "hard"):
        regfile_p = args.core+regfile
        rom0Hex_p = args.core+rom0Hex
        rom1Hex_p = args.core+rom1Hex
        rom2Hex_p = args.core+rom2Hex
        rom3Hex_p = args.core+rom3Hex
    elif (args.tap == "soft"):
        regfile_p = args.core+softTap+regfile
        rom0Hex_p = args.core+softTap+rom0Hex
        rom1Hex_p = args.core+softTap+rom1Hex
        rom2Hex_p = args.core+softTap+rom2Hex
        rom3Hex_p = args.core+softTap+rom3Hex
    else:
        regfile_p = "regfile.bin" 
        rom0Hex_p = "rom0.bin"
        rom1Hex_p = "rom1.bin"
        rom2Hex_p = "rom2.bin"
        rom3Hex_p = "rom3.bin"
   
    with open(args.binfile , "rb") as f:
        while True:
            binData = f.read(1)
            if not binData:
                break
            binDatal.append(binData)


    for binData in binDatal:
        binData_value = ord(binData)
        binData_binary = '{0:08b}'.format(binData_value)
        binData_binaryl.append(binData_binary)
    
    binSplit(0,rom0Hex_p,ramSize)
    binSplit(1,rom1Hex_p,ramSize)
    binSplit(2,rom2Hex_p,ramSize)
    binSplit(3,rom3Hex_p,ramSize)

    f=open(regfile_p , 'w')
    for i in range(32):
        f.write("00000000000000000000000000000000\n")
    f.close

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-t',
                        '--tap',
                        default="hard",
                        help='FPGA Tap Type, <hard>,<soft>')
    parser.add_argument('-b',
                        '--binfile',
                        default=None,
                        help='Application bin to convert',
                        required=True)
    parser.add_argument('-c',
                        '--core',
                        default="rubysoc",
                        help='SOC prefix name')
    parser.add_argument('-s',
                        '--sizeram',
                        default=4096,
                        help='SOC RAM Size')

    args = parser.parse_args()
    return args


if __name__ == '__main__':
    args = parse_args()
    app_binSplit(args)
