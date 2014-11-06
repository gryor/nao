#include "scalar.h"


double factorial(size_t number)
{
	size_t result = 1;

	for(; number > 1; number--)
		result *= number;

	return result;
}
