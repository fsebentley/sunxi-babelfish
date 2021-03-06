/*
 * Original code taken from pxa-impedance-matcher, written by Jason
 * Cooper <jason@lakedaemon.net>
 */

#include <types.h>

inline void writel(u32 val, u32 addr)
{
	*(volatile u32 *) addr = val;
}

inline u32 readl(u32 addr)
{
	return *(volatile u32 *) addr;
}
