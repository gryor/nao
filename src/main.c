#include <stdio.h>
#include <string.h>
#include "matrix.h"
#include "polynomial.h"
#include "distance.h"

static void printm(const char * name, size_t size, double * m)
{
	printf("%s\t", name);

	if(strlen(name) < 8)
		printf("\t");

	for(size_t i = 0; i < size; i++)
		printf("%.2f\t", m[i]);

	puts("");
}

int main(int argc, char * argv[])
{
	double A[] = {1, 1, 1, 0, 2, 5, 2, 5, -1}, B[] = {6, -4, 27}, X[3] = {0};
	double poly[] = {1080,-126,-123,6,3};
	double a[] = {1, 2, 3}, b[] = {3, 2, 1}, abcross[3] = {0};
	double x[4] = {0};
	matrix_solve(3, A, B, X);
	vector3_cross(a, b, abcross);

	if(!polynomial_solve_degree_4(poly, x))
		printf("No results for the polynomial.\n");

	printm("A", 9, A);
	printm("B", 3, B);
	printm("X", 3, X);
	printm("a x b", 3, abcross);
	printm("x", 4, x);

    /////////////////////////////////////////////

	puts("=======================================");

	double position[] = {1, 1, 0}, direction[] = {1, 0, 0}, point[] = {0, 3.5, 0};
	double distance = 0;

	printm("position", 3, position);
	printm("direction", 3, direction);
	printm("point", 3, point);

	if(!distance_posdir_point(position, direction, point, &distance))
		printf("Distance %f\n", distance);

	if(posdir_outside_of_sphere(position, direction, point, 2.5))
		puts("The point is outside.");
	else
		puts("The point is inside.");

	point[1] += 0.000001;
	puts("point[1] += 0.000001");

	if(!distance_posdir_point(position, direction, point, &distance))
		printf("Distance %f\n", distance);

	if(posdir_outside_of_sphere(position, direction, point, 2.5))
		puts("The point is outside.");
	else
		puts("The point is inside.");

	return 0;
}