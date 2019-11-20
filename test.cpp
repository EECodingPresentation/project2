#include "bign.h"

int main()
{
	bign a,b,c,m;
	a.Read();
	b.Read();
//	m.Read();
	c=a/b;
	c.Print();
	return 0;
}
