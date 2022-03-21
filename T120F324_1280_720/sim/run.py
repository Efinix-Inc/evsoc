import argparse
import os.path
import shutil
import fileinput
import re
import subprocess
import sys
import time
import os
import glob
import codecs
from pathlib import Path

binDl = []
binDbl= []
        
def genMEM(args,cp,dp):

    if(args.bin[0] == '/' or args.bin[1] == ':'):
        fb=Path(args.bin)
    else:
        fb=Path(cp,args.bin)
    #read from application bin
    try:
        with open(fb, "rb") as f:
            while True:
                binD = f.read(1)
                if not binD:
                    break
                binDl.append(binD)
    except IOError:
        print('Application binary file '+str(fb)+' was not found!')
        print('Aborting simulation...')
        quit()
    
    for i in binDl:
        binDv = ord(i)
        binDb = '{0:02x}'.format(binDv)
        binDbl.append(binDb)
    
    ft=len(binDbl) % 16 
    if(ft != 0):
        for x in range(16-ft):
            binDbl.append('00')

    words=''
    wordsl=[]
    r=0
    while (r < len(binDbl)):
        for n in range(r, r+16):
            words = binDbl[n]+words
        wordsl.append(words)
        words=''
        r=r+16

    #calculate address
    adr=int(4096/16)
    adrx=hex(adr).split('x')[-1]
    wordsl.insert(0,'@'+str(adrx))

    dt=Path(dp,'MEM.TXT')
    fm=open(dt,'w')
    for l in range(0,len(wordsl)):
        fm.write(wordsl[l]+'\n')
    fm.close()
        
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-b',
                        '--bin',
                        default=None,
                        help='Location to Application bin(Relative Path)')

    args = parser.parse_args()
    #check efinity environment
    try:
        os.environ['EFINITY_HOME']
    except:
        print('neither EFINITY_HOME nor EFXIPM_HOME is set.  Stop.')
        quit()
    #check bin file is valid for simulation
    if(args.bin != None and args.bin[-4:] != ".bin"):
        print('Application file must be in .bin format!')
        print('Eg. apb3Demo.bin')
        print('Aborting simulation...')
        quit()

    #check directory
    cp=os.getcwd()
    dest_sim=Path(cp, 'SimSOC')
    tb_sim=Path(dest_sim, 'tb_soc.v')
        
    #move file to new folder
    if os.path.exists(dest_sim):
        shutil.rmtree(dest_sim)
    os.mkdir(dest_sim)

    for d in glob.glob(r'*.bin'):
        shutil.copy(d, dest_sim)

    for d in glob.glob(r'*.v*'):
        shutil.copy(d, dest_sim)

    for d in glob.glob(r'*.TXT'):
        shutil.copy(d, dest_sim)

    for d in glob.glob(r'*.do'):
        shutil.copy(d, dest_sim)
        
    for d in glob.glob(r'*.vh'):
        shutil.copy(d, dest_sim)
        
    #additional rtl files
    path_source=os.path.join("..","source","**","*.v*")
    for filename in glob.iglob(path_source, recursive=True):
        shutil.copy(filename, dest_sim)
        
    path_base=os.path.join("..","*.v*")
    for filename in glob.iglob(path_base , recursive=True):
        shutil.copy(filename, dest_sim)
    
    path_cam_dma_fifo=os.path.join("..","ip","cam_dma_fifo","Testbench","cam_dma_fifo.v")
    shutil.copy(path_cam_dma_fifo, dest_sim)
        
    path_cam_pixel_remap_fifo=os.path.join("..","ip","cam_pixel_remap_fifo","Testbench","cam_pixel_remap_fifo.v")
    shutil.copy(path_cam_pixel_remap_fifo, dest_sim)
    
    path_display_dma_fifo=os.path.join("..","ip","display_dma_fifo","Testbench","display_dma_fifo.v")
    shutil.copy(path_display_dma_fifo, dest_sim)

    path_hw_accel_dma_in_fifo=os.path.join("..","ip","hw_accel_dma_in_fifo","Testbench","hw_accel_dma_in_fifo.v")
    shutil.copy(path_hw_accel_dma_in_fifo, dest_sim)

    path_hw_accel_dma_out_fifo=os.path.join("..","ip","hw_accel_dma_out_fifo","Testbench","hw_accel_dma_out_fifo.v")
    shutil.copy(path_hw_accel_dma_out_fifo, dest_sim)
    
    path_cam_scaler_fifo=os.path.join("..","ip","cam_scaler_fifo","Testbench","cam_scaler_fifo.v")
    shutil.copy(path_cam_scaler_fifo, dest_sim)

    path_ddr_reset_seq=os.path.join("..","ip","ddr_reset_seq","Testbench","ddr_reset_seq.v")
    shutil.copy(path_ddr_reset_seq, dest_sim)

    path_dma=os.path.join("..","ip","dma","Testbench","dma.v")
    shutil.copy(path_dma, dest_sim)

    path_SapphireSoc=os.path.join("..","ip","SapphireSoc","Testbench","SapphireSoc.v")
    shutil.copy(path_SapphireSoc, dest_sim)    
         
    test=os.listdir(dest_sim)
    cur=os.getcwd()
    for item in test:
        if item.endswith("_tmpl.v"):
            item=os.path.join(cur,"SimSOC",item)
            os.remove(item)
        if item.endswith("_softTap.v"):
            item=os.path.join(cur,"SimSOC",item)
            os.remove(item)               
    #check if any bin file parse in
    if(args.bin == None):
        pass
    else:
        genMEM(args,cp,dest_sim)

    #skip original sequences if custom bin found
    if(args.bin == None):
        pass
    else:
        tmpf = Path(dest_sim, 'tb_soc.v'+'.tmp')
        with codecs.open(tb_sim, 'r', encoding='utf-8') as fi, \
            codecs.open(tmpf, 'w', encoding='utf-8') as fo:

            for line in fi:
            #new_line = do_processing(line) # do your line processing here
                new_line = line.replace('//`define SKIP_TEST', '`define SKIP_TEST')
                fo.write(new_line)

        os.remove(tb_sim) # remove original
        os.rename(tmpf, tb_sim) # rename temp to original name

    #run simulation
    os.chdir(dest_sim)    
    if(os.name == 'nt'):
        os.system('vsim.exe -do sim.do')
    else:
        os.system('vsim -do sim.do')


if __name__ == '__main__':
    main()


