PHDRS {
 hdr PT_LOAD;
 text PT_LOAD;
}

SECTIONS {
  .text : ALIGN(0x10000) {
    *(.text)
    *(.bss)
    *(.data)
    *(.rodata.*)
    *(.rodata)
  } :text
  /DISCARD/ : { *(*) }
}
