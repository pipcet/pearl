#!/bin/sh
kexec --mem-max=0x900000000 -fix ./pearl.image --dtb=/sys/firmware/fdt
