Nao
===

Nao is a math library.

Features
===
* Scalar
  - Factorial
* Matrices
  - Matrix solver
* Vectors
* Polynomials
  - Solvers for 1-4 degree polynomials

Example - main.c
===
``` c
#include <stdio.h>
#include "matrix.h"

static void printm(const char * name, size_t size, double * m)
{
	printf("%s\t\t", name);

	for(size_t i = 0; i < size; i++)
		printf("%.2f\t", m[i]);

	puts("");
}

int main(int argc, char * argv[])
{
	double A[] = {1, 1, 1, 0, 2, 5, 2, 5, -1}, B[] = {6, -4, 27}, X[3] = {0};
	matrix_solve(3, A, B, X);
	printm("A", 9, A);
	printm("B", 3, B);
	printm("X", 3, X);
	return 0;
}
```
```
A		1.00	1.00	1.00	0.00	2.00	5.00	2.00	5.00	-1.00	
B		6.00	-4.00	27.00	
X		5.00	3.00	-2.00
```
