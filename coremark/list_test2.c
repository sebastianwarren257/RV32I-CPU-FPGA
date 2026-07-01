typedef unsigned int   ee_u32;
typedef unsigned short ee_u16;
typedef unsigned char  ee_u8;

#define NUM_NODES 5
#define TOHOST_ADDR 0x80001000

typedef struct node_s
{
    struct node_s *next;
    ee_u16         value;
    ee_u16         pad;
} node_t;

static node_t nodes[NUM_NODES];

static void
signal_tohost(ee_u32 v)
{
    *((volatile ee_u32 *)TOHOST_ADDR) = v;
}

int
main(void)
{
    int    i;
    ee_u32 sum;
    ee_u32 expected;
    node_t *p;
    ee_u32 vtmp;

    for (i = 0; i < NUM_NODES; i++)
    {
        nodes[i].value = (ee_u16)(i + 1);
        if (i < NUM_NODES - 1)
            nodes[i].next = &nodes[i + 1];
        else
            nodes[i].next = 0;
    }

    sum = 0;
    p   = &nodes[0];
    while (p != 0)
    {
        vtmp = (ee_u32)p->value;
        sum  = sum + vtmp;
        p    = p->next;
    }

    expected = (NUM_NODES * (NUM_NODES + 1)) / 2;

    if (sum == expected)
        signal_tohost(1);
    else
        signal_tohost(2);

    for (;;)
        ;
    return 0;
}
