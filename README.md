# Netfilter-Adblocker
using netfilter to block ads hosts

# Usage
Download dependencies
```sh
$ sudo apt-get install libelf-dev gperf clang llvm linux-tools-`uname -r`
```

To run as kernel module
```sh
$ make kernel
```

# Update Host Block List
Just append the host you want to block to the file `hosts`

**Make sure there isn't any blank line in your list**
