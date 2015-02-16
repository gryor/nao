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
* Distance
  - Distance of a line to a point
  - Test whether a point is outside a sphere

Install
===
```sh
# Build what you need
# Release lib
make lib
# Debug lib
make libdebug

# Install
sudo make install

# Use alternative destination
# E.g. for packages or for one user
#make install destdir=/home/user/something

# Use alternative prefix
# E.g. for installing somewhere else than /usr
#sudo make install prefix=/usr/local

```

Example - main.c
===
``` c
#include <stdio.h>
#include "matrix.h"
#include "polynomial.h"

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
	double poly[] = {1080,-126,-123,6,3};
	double x[4] = {0};
	matrix_solve(3, A, B, X);

	if(!polynomial_solve_degree_4(poly, x))
		printf("No results for the polynomial.\n");

	printm("A", 9, A);
	printm("B", 3, B);
	printm("X", 3, X);
	printm("x", 4, x);
	return 0;
}
```
Output
```
A		1.00	1.00	1.00	0.00	2.00	5.00	2.00	5.00	-1.00
B		6.00	-4.00	27.00
X		5.00	3.00	-2.00
x		-6.00	-4.00	3.00	5.00
```
