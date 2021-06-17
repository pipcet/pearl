#!/bin/sh
macho-image-fill ./m1n1.macho.image
kexec -fix ./m1n1.macho.image --dtb=/sys/firmware/fdt
