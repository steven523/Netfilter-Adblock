KDIR := /lib/modules/$(shell uname -r)/build

USRC = adblock.c tls.c http.c
# USRC = adblock.c
TARGET_MODULE := adblock


obj-m := $(TARGET_MODULE).o
adblock-objs := kadblock.o tls.o http.o dns.o send_close.o
# adblock-objs := kadblock.o dns.o send_close.o verdict_ssl.o

PWD = $(shell pwd)

KBUILD_CFLAGS += -Wno-implicit-fallthrough

# BPF_PROG = ssl_sniff

# all:
# 	$(MAKE) kernel
# 	$(MAKE) $(BPF_PROG)
# 	sudo python3 bpf.py

all:
	./generate_hash.sh .
	gcc -o adblock $(USRC) -lnetfilter_queue

# user:
# 	./generate_hash.sh .
# 	gcc -o adblock $(USRC) -lnetfilter_queue

load:
	sudo insmod $(TARGET_MODULE).ko
unload:
	sudo rmmod $(TARGET_MODULE) || true >/dev/null


kernel:
#	./generate_hash.sh .
	$(MAKE) unload
	$(MAKE) -C $(KDIR) M=$(PWD) modules
	$(MAKE) load
	
clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
	rm -rf adblock host_table.h .tmp*
#	rm -rf adblock ssl_sniff host_table.h .tmp* ssl_sniff


# OUTPUT := .output
# CLANG ?= clang
# LLVM_STRIP ?= llvm-strip
# BPFTOOL = bpftool
# LIBBPF_SRC := $(abspath ./libbpf/src)
# LIBBPF_OBJ := $(abspath $(OUTPUT)/libbpf.a)
# INCLUDES := -I$(OUTPUT) -Ilibbpf/include/uapi
# CFLAGS := -g -Wall
# ARCH := $(shell uname -m | sed 's/x86_64/x86/')
# CLANG_BPF_SYS_INCLUDES ?= $(shell clang -v -E - </dev/null 2>&1 \
# 	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }')



# $(OUTPUT) $(OUTPUT)/libbpf:
# 	$(call msg,MKDIR,$@)
# 	$(Q)mkdir -p $@

# # Build final application
# $(BPF_PROG): %: $(OUTPUT)/%.o $(LIBBPF_OBJ) | $(OUTPUT)
# 	$(call msg,BINARY,$@)
# 	$(Q)$(CC) $(CFLAGS) $^ -lelf -lz -o $@

# $(patsubst %,$(OUTPUT)/%.o,$(BPF_PROG)): %.o: %.skel.h

# # Build user-space code
# $(OUTPUT)/%.o: %.c $(wildcard %.h) | $(OUTPUT)
# 	$(call msg,CC,$@)
# 	$(CC) $(CFLAGS) $(INCLUDES) -c $(filter %.c,$^) -o $@

# # Generate BPF skeletons
# $(OUTPUT)/%.skel.h: $(OUTPUT)/%.bpf.o | $(OUTPUT)
# 	$(call msg,GEN-SKEL,$@)
# 	$(BPFTOOL) gen skeleton $< > $@

# # Build BPF code
# $(OUTPUT)/%.bpf.o: %.bpf.c $(LIBBPF_OBJ)| $(OUTPUT)
# 	$(call msg,BPF,$@)
# 	$(CLANG) -g -O2 -target bpf -D__TARGET_ARCH_$(ARCH)		      \
# 		     $(INCLUDES) $(CLANG_BPF_SYS_INCLUDES) -c $(filter %.c,$^) -o $@
# 	$(LLVM_STRIP) -g $@

# # Build libbpf
# $(LIBBPF_OBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)/libbpf
# 	$(call msg,LIB,$@)
# 	$(MAKE) -C $(LIBBPF_SRC) BUILD_STATIC_ONLY=1		      \
# 		    OBJDIR=$(dir $@)/libbpf DESTDIR=$(dir $@)		      \
# 		    INCLUDEDIR= LIBDIR= UAPIDIR=			      \
# 		    install

# # delete failed targets
# .DELETE_ON_ERROR:
