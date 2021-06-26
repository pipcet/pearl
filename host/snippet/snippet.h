#define START_SNIPPET							\
  void function(void) __attribute__((section(".noinclude.text")));	\
									\
  void function(void)							\
  {									\
    asm volatile(".pushsection .text");					\
    asm volatile(".cfi_startproc");

#define END_SNIPPET				\
   asm volatile(".cfi_endproc");		\
   asm volatile(".popsection");			\
   asm volatile("" : : "r" (&&label));		\
 label:						\
 return;					\
 }
