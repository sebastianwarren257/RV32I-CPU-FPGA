/*
core_portme.c -- ported for RV32IM 5-stage pipelined CPU (Basys 3 / Artix-7)
Based on EEMBC CoreMark barebones template.

Timing source: memory-mapped free-running cycle counter at 0x80001004.
Output: stubbed (no UART on this platform) -- score is read back from
the counter directly rather than printed.
*/
#include "coremark.h"
#include "core_portme.h"

#if VALIDATION_RUN
volatile ee_s32 seed1_volatile = 0x3415;
volatile ee_s32 seed2_volatile = 0x3415;
volatile ee_s32 seed3_volatile = 0x66;
#endif
#if PERFORMANCE_RUN
volatile ee_s32 seed1_volatile = 0x0;
volatile ee_s32 seed2_volatile = 0x0;
volatile ee_s32 seed3_volatile = 0x66;
#endif
#if PROFILE_RUN
volatile ee_s32 seed1_volatile = 0x8;
volatile ee_s32 seed2_volatile = 0x8;
volatile ee_s32 seed3_volatile = 0x8;
#endif
volatile ee_s32 seed4_volatile = ITERATIONS;
volatile ee_s32 seed5_volatile = 0;

/* Memory-mapped cycle counter address (see dmem.sv) */
#define CYCLE_COUNTER_ADDR 0x80001004

static inline ee_u32
read_cycle_counter(void)
{
    return *((volatile ee_u32 *)CYCLE_COUNTER_ADDR);
}

CORETIMETYPE
barebones_clock()
{
    return read_cycle_counter();
}

/* Define : TIMER_RES_DIVIDER */
#define GETMYTIME(_t)              (*_t = barebones_clock())
#define MYTIMEDIFF(fin, ini)       ((fin) - (ini))
#define TIMER_RES_DIVIDER          1
#define SAMPLE_TIME_IMPLEMENTATION 1
#define EE_TICKS_PER_SEC           (CLOCKS_PER_SEC / TIMER_RES_DIVIDER)

#define CRC_ADDR 0x8000100C
volatile ee_u32 g_coremark_crc = 0;   /* set by core_main before fini */

/* CPU runs at 50MHz -- cycle counter increments once per clock */
#define CLOCKS_PER_SEC 50000000

static CORETIMETYPE start_time_val, stop_time_val;

void
start_time(void)
{
    GETMYTIME(&start_time_val);
}

void
stop_time(void)
{
    GETMYTIME(&stop_time_val);
}

CORE_TICKS
get_time(void)
{
    CORE_TICKS elapsed
        = (CORE_TICKS)(MYTIMEDIFF(stop_time_val, start_time_val));
    return elapsed;
}

secs_ret
time_in_secs(CORE_TICKS ticks)
{
    secs_ret retval = ((secs_ret)ticks) / (secs_ret)EE_TICKS_PER_SEC;
    return retval;
}

ee_u32 default_num_contexts = 1;

/* Memory-mapped "tohost"-style register for pass/fail/done signaling
   (see dmem.sv, same register your other tests use) */
#define TOHOST_ADDR 0x80001000

void
portable_init(core_portable *p, int *argc, char *argv[])
{
    (void)argc;
    (void)argv;

    if (sizeof(ee_ptr_int) != sizeof(ee_u8 *))
    {
        ee_printf(
            "ERROR! Please define ee_ptr_int to a type that holds a "
            "pointer!\n");
    }
    if (sizeof(ee_u32) != 4)
    {
        ee_printf("ERROR! Please define ee_u32 to a 32b unsigned type!\n");
    }
    p->portable_id = 1;
}

/* Memory-mapped address to expose the elapsed cycle count, so the
   score can be read back on hardware (and in sim) without printf/UART.
   Distinct from TOHOST (0x80001000) and the cycle counter (0x80001004). */
#define ELAPSED_ADDR 0x80001008

void
portable_fini(core_portable *p)
{
    ee_u32 elapsed;
    p->portable_id = 0;
    elapsed = (ee_u32)(stop_time_val - start_time_val);
    *((volatile ee_u32 *)ELAPSED_ADDR) = elapsed;
    *((volatile ee_u32 *)CRC_ADDR)     = g_coremark_crc;   /* CRC before tohost */
    *((volatile ee_u32 *)TOHOST_ADDR)  = 1;
}