PHDRS {
 hdr PT_LOAD;
 text PT_LOAD;
}

SECTIONS {
  . = 0x800200000;
  /DISCARD/ : { *(.eh_frame) }
  .text : {
    *(.text)
    *(.bss)
    *(.data)
    *(.rodata.*)
    *(.rodata)
  } :text
}
