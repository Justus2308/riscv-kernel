#include "config.h"
#include "util.h"

void *
memset(void *dstpp, int c, unsigned long len)
{
	long dstp = (long) dstpp;

	if (len >= REGBYTES)
	{
		/* fill long with c according to REGBYTES of system */
		unsigned long wsec = * (long *) &c;

		#if REGBYTES == 8
		section |= wsec << 32;
		#endif

		/* align memory block to set */
		while (dstp % REGBYTES != 0)
		{
			((unsigned char*)dstp)[0] = c;
			dstp += 1;
			len -= 1;
		}

		/* write in batches of 8 REGBYTES per iteration */
		while (len > 7)
		{
			((unsigned long *)dstp)[0] = wsec;
			((unsigned long *)dstp)[1] = wsec;
			((unsigned long *)dstp)[2] = wsec;
			((unsigned long *)dstp)[3] = wsec;
			((unsigned long *)dstp)[4] = wsec;
			((unsigned long *)dstp)[5] = wsec;
			((unsigned long *)dstp)[6] = wsec;
			((unsigned long *)dstp)[7] = wsec;
			dstp += 8 * REGBYTES;
			len -= 8;
		}

		/* write remaining bytes */
		while (len > 0)
		{
			((unsigned char *)dstp)[0] = wsec;
			dstp += REGBYTES;
			len--;
		}
	}
	return dstpp;
}

void *
memcpy(void *dstpp, const void *src, unsigned long len)
{
	return NULL;
}
