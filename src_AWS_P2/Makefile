CONNECTALDIR?=~/connectal

S2H_INTERFACES = AWSP2_Request:AWSP2.request
H2S_INTERFACES = AWSP2:AWSP2_Response
MEM_READ_INTERFACES = lAWSP2.readClients
MEM_WRITE_INTERFACES = lAWSP2.writeClients

## CONNECTALFLAGS +=  -D BYTE_ENABLES

BSVFILES = AWSP2_IFC.bsv
CPPFILES = loadelf.cpp testawsp2.cpp
CONNECTALFLAGS += -lelf
CONNECTALFLAGS += -D SIM_DMA_READ_LATENCY=1
CONNECTALFLAGS += -D SIM_DMA_WRITE_LATENCY=1

ARCH ?= RV64ACDFIMSU

include $(CONNECTALDIR)/Makefile.connectal

CONNECTALFLAGS += -D PUBLIC_ACCESS_POLICY

CONNECTALFLAGS += --bscflags="-keep-fires -no-warn-action-shadowing -show-range-conflict"
CONNECTALFLAGS += -DRV64
CONNECTALFLAGS += -DSV39
CONNECTALFLAGS += -DISA_PRIV_M  -DISA_PRIV_S  -DISA_PRIV_U 
CONNECTALFLAGS += -DISA_I  -DISA_M  -DISA_A  -DISA_C 
CONNECTALFLAGS += -DISA_F -DISA_D -DISA_FD_DIV 
CONNECTALFLAGS += -DISA_FD -DISA_F_OR_D
CONNECTALFLAGS += -DSHIFT_BARREL   
CONNECTALFLAGS += -DMULT_SERIAL   
CONNECTALFLAGS += -DNear_Mem_Caches   
CONNECTALFLAGS += -DFABRIC64   
CONNECTALFLAGS += -DINCLUDE_GDB_CONTROL
#CONNECTALFLAGS += -DINCLUDE_TANDEM_VERIF
CONNECTALFLAGS += -DBRVF_TRACE
CONNECTALFLAGS += -DXILINX_BSCAN  -DXILINX_XCVU9P
#CONNECTALFLAGS += -DJTAG_TAP

CONNECTALFLAGS += --bsvpath=../src_SSITH_P2/src_BSV/
CONNECTALFLAGS += --bsvpath=../src_Core/BSV_Additional_Libs
CONNECTALFLAGS += --bsvpath=../src_Core/Core
CONNECTALFLAGS += --bsvpath=../src_Core/CPU
CONNECTALFLAGS += --bsvpath=../src_Core/Debug_Module
CONNECTALFLAGS += --bsvpath=../src_Core/ISA
CONNECTALFLAGS += --bsvpath=../src_Core/Near_Mem_IO
CONNECTALFLAGS += --bsvpath=../src_Core/Near_Mem_VM
CONNECTALFLAGS += --bsvpath=../src_Core/PLIC
CONNECTALFLAGS += --bsvpath=../src_Core/RegFiles
CONNECTALFLAGS += --bsvpath=../src_Core/Tagged
CONNECTALFLAGS += --bsvpath=../src_Core/TaggingPolicies
CONNECTALFLAGS += --bsvpath=../src_Testbench/Fabrics/AXI4

## for TLM.defines
CONNECTALFLAGS += $(shell test -d $(BLUESPECDIR)/Libraries/Axi && echo --bsvpath=$(BLUESPECDIR)/Libraries/Axi)
CONNECTALFLAGS += $(shell test -d $(BLUESPECDIR)/Libraries/Axi4 && echo --bsvpath=$(BLUESPECDIR)/Libraries/Axi4)
CONNECTALFLAGS += $(shell test -d $(BLUESPECDIR)/Libraries/Bus && echo --bsvpath=$(BLUESPECDIR)/Libraries/Bus)
CONNECTALFLAGS += $(shell test -d $(BLUESPECDIR)/Libraries/TLM3 && echo --bsvpath=$(BLUESPECDIR)/Libraries/TLM3)
CONNECTALFLAGS += $(shell test -d $(BLUESPECDIR)/Libraries/AMBA_TLM3/Axi && echo --bsvpath=$(BLUESPECDIR)/Libraries/AMBA_TLM3/Axi)
CONNECTALFLAGS += $(shell test -d $(BLUESPECDIR)/Libraries/AMBA_TLM3/Axi4 && echo --bsvpath=$(BLUESPECDIR)/Libraries/AMBA_TLM3/Axi4)
CONNECTALFLAGS += $(shell test -d $(BLUESPECDIR)/Libraries/AMBA_TLM3/TLM3 && echo --bsvpath=$(BLUESPECDIR)/Libraries/AMBA_TLM3/TLM3)

