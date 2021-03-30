# =============================================================================
# This file include the functions to control cache behavior.
# =============================================================================

#include "include/regdef.h"
#define CCTL_IInval   0x00000002
#define CCTL_DInval   0x00000001
#define CCTL_DWBInval 0x00000100

#if defined(__m3081)
#define ISA_IS_MIPS16R 1
#endif

# =============================================================================
# ================ ISA_IS_MIPS16R =============================================
# =============================================================================
#ifdef ISA_IS_MIPS16R

#define LA(t,x) lui t,%hi(x); addiu t,%lo(x)
    .set  	noat
    .set  	noreorder
    .set        mips16

    .text

# =============================================================================
# void flush_cache()
# =============================================================================
    .align      2
    .globl	flush_cache
    .ent 	flush_cache
flush_cache:
    mfc0  a0, C0_CCTL

    # Invalidate ICache
    li    a1, (~(CCTL_IInval)) & 0xffff
    and   a0, a1
    mtc0  a0, C0_CCTL
    li    a1, CCTL_IInval
    or    a0, a1
    mtc0  a0, C0_CCTL

    # Writeback and Invalidate DCache
    li    a1, (~(CCTL_DWBInval)) & 0xffff
    and   a0, a1
    mtc0  a0, C0_CCTL
    li    a1, CCTL_DWBInval
    or    a0, a1
    mtc0  a0, C0_CCTL

    # Invalidate DCache for not writeback cache cpu
    li    a1, (~(CCTL_DInval)) & 0xffff
    and   a0, a1
    mtc0  a0, C0_CCTL
    li    a1, CCTL_DInval
    or    a0, a1
    mtc0  a0, C0_CCTL

    j     ra
    .end flush_cache

# =============================================================================
# ================ !ISA_IS MIPS16R ============================================
# =============================================================================
#else
    .set  	noat
    .set  	noreorder
    .set        nomips16

    .text

# =============================================================================
# void flush_cache()
# =============================================================================
    .globl	flush_cache
    .ent 	flush_cache
flush_cache:
    mfc0  at, C0_CCTL

    # Invalidate ICache
    andi  at, (~(CCTL_IInval)) & 0xffff
    mtc0  at, C0_CCTL
    or    at, CCTL_IInval
    mtc0  at, C0_CCTL

    # Writeback and Invalidate DCache
    andi  at, (~(CCTL_DWBInval)) & 0xffff
    mtc0  at, C0_CCTL
    or    at, CCTL_DWBInval
    mtc0  at, C0_CCTL

    # Invalidate DCache for not writeback cache cpu
    andi  at, (~(CCTL_DInval)) & 0xffff
    mtc0  at, C0_CCTL
    or    at, CCTL_DInval
    mtc0  at, C0_CCTL

    j     ra
    nop
    .end flush_cache


#endif
