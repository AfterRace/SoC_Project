#define SRC_L   *((unsigned *)(ptr_src + 0))
#define SRC_R   *((unsigned *)(ptr_src + 4))

#define DST0_ADR 0x43C10000
#define DST1_ADR 0x43C20000 
#define DST0_L   *((unsigned *)(ptr_dst0 + 0))
#define DST0_R   *((unsigned *)(ptr_dst0 + 4))
#define DST1_L   *((unsigned *)(ptr_dst1 + 0))
#define DST1_R   *((unsigned *)(ptr_dst1 + 4))

#define FILTER0_ADR 0x43C30000
#define FILTER1_ADR 0x43C50000
#define VOLUME0_ADR 0x43C40000
#define VOLUME1_ADR 0x43C60000

#define VOLUME0_REG_0   *((unsigned *)(ptr_volume0 + 0))
#define VOLUME0_REG_1   *((unsigned *)(ptr_volume0 + 4))
#define VOLUME1_REG_0   *((unsigned *)(ptr_volume1 + 0))
#define VOLUME1_REG_1   *((unsigned *)(ptr_volume1 + 4))

#define FILTER0_REG_0   *((unsigned *)(ptr_filter0 + 0))
#define FILTER0_REG_1   *((unsigned *)(ptr_filter0 + 4))
#define FILTER0_REG_2   *((unsigned *)(ptr_filter0 + 8))
#define FILTER0_REG_3   *((unsigned *)(ptr_filter0 + 12))
#define FILTER0_REG_4   *((unsigned *)(ptr_filter0 + 16))
#define FILTER0_REG_5   *((unsigned *)(ptr_filter0 + 20))
#define FILTER0_REG_6   *((unsigned *)(ptr_filter0 + 24))
#define FILTER0_REG_7   *((unsigned *)(ptr_filter0 + 28))
#define FILTER0_REG_8   *((unsigned *)(ptr_filter0 + 32))
#define FILTER0_REG_9   *((unsigned *)(ptr_filter0 + 36))
#define FILTER0_REG_10   *((unsigned *)(ptr_filter0 + 40))
#define FILTER0_REG_11   *((unsigned *)(ptr_filter0 + 44))
#define FILTER0_REG_12   *((unsigned *)(ptr_filter0 + 48))
#define FILTER0_REG_13   *((unsigned *)(ptr_filter0 + 52))
#define FILTER0_REG_14   *((unsigned *)(ptr_filter0 + 56))
#define FILTER0_REG_15   *((unsigned *)(ptr_filter0 + 60))
#define FILTER0_REG_16   *((unsigned *)(ptr_filter0 + 64))
#define FILTER0_REG_17   *((unsigned *)(ptr_filter0 + 68))
#define FILTER0_REG_18   *((unsigned *)(ptr_filter0 + 72))
#define FILTER0_REG_19   *((unsigned *)(ptr_filter0 + 76))

#define FILTER1_REG_0   *((unsigned *)(ptr_filter1 + 0))
#define FILTER1_REG_1   *((unsigned *)(ptr_filter1 + 4))
#define FILTER1_REG_2   *((unsigned *)(ptr_filter1 + 8))
#define FILTER1_REG_3   *((unsigned *)(ptr_filter1 + 12))
#define FILTER1_REG_4   *((unsigned *)(ptr_filter1 + 16))
#define FILTER1_REG_5   *((unsigned *)(ptr_filter1 + 20))
#define FILTER1_REG_6   *((unsigned *)(ptr_filter1 + 24))
#define FILTER1_REG_7   *((unsigned *)(ptr_filter1 + 28))
#define FILTER1_REG_8   *((unsigned *)(ptr_filter1 + 32))
#define FILTER1_REG_9   *((unsigned *)(ptr_filter1 + 36))
#define FILTER1_REG_10   *((unsigned *)(ptr_filter1 + 40))
#define FILTER1_REG_11   *((unsigned *)(ptr_filter1 + 44))
#define FILTER1_REG_12   *((unsigned *)(ptr_filter1 + 48))
#define FILTER1_REG_13   *((unsigned *)(ptr_filter1 + 52))
#define FILTER1_REG_14   *((unsigned *)(ptr_filter1 + 56))
#define FILTER1_REG_15   *((unsigned *)(ptr_filter1 + 60))
#define FILTER1_REG_16   *((unsigned *)(ptr_filter1 + 64))
#define FILTER1_REG_17   *((unsigned *)(ptr_filter1 + 68))
#define FILTER1_REG_18   *((unsigned *)(ptr_filter1 + 72))
#define FILTER1_REG_19   *((unsigned *)(ptr_filter1 + 76))
