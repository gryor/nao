#include "polynomial.h"
#include <math.h>
#include <float.h>

const double pi = 3.14159265358979323846;

static int zero(double * x)
{
	if(*x > -DBL_EPSILON && *x < DBL_EPSILON) {
		*x = 0.0;
		return 1;
	}

	return 0;
}

static int solve_degree_1(const double * c, double * x)
{
	if(c[1] == 0)
		return 0;

	x[0] = -c[0] / c[1];
	return 1;
}

static int solve_degree_2(const double * c, double * x)
{
	if(c[2] == 0)
		return solve_degree_1(c, x);

	double p = c[1] / (2.0 * c[2]);
	double q = c[0] / c[2];
	double D = p * p - q;

	if(zero(&D)) {
		x[0] = x[1] = -p;
		return 1;
	} else if(D < 0)
		return 0;
	else {
		double sqrt_D = sqrt(D);
		x[0] = -sqrt_D - p;
		x[1] = sqrt_D - p;
		return 2;
	}
}

static int solve_degree_3(const double * c, double * x)
{
	int	num;
	double A = c[2] / c[3];
	double B = c[1] / c[3];
	double C = c[0] / c[3];
	double sq_A = A * A;
	double p = 1.0 / 3.0 * (-1.0 / 3.0 * sq_A + B);
	double q = 1.0 / 2.0 * (2.0 / 27.0 * A * sq_A - 1.0 / 3.0 * A * B + C);
	double cb_p = p * p * p;
	double D = q * q + cb_p;

	if(zero(&D)) {
		if(zero(&q)) {
			x[0] = 0.0;
			num = 1;
		} else {
			double u = cbrt(-q);
			x[0] = 2.0 * u;
			x[1] = - u;
			num = 2;
		}
	} else if(D < 0) {
		double phi = 1.0 / 3.0 * acos(-q / sqrt(-cb_p));
		double t = 2.0 * sqrt(-p);
		x[0] = t * cos(phi);
		x[1] = -t * cos(phi + pi / 3.0);
		x[2] = -t * cos(phi - pi / 3.0);
		num = 3;
	} else {
		double sqrt_D = sqrt(D);
		double u = cbrt(sqrt_D + fabs(q));

		if(q > 0)
			x[0] = - u + p / u ;
		else
			x[0] = u - p / u;

		num = 1;
	}

	double sub = 1.0 / 3.0 * A;

	for(int i = 0; i < num; i++)
		x[i] -= sub;

	return num;
}

static int solve_degree_4(const double * c, double * x)
{
	double coeffs[4];
	int num;
	double A = c[3] / c[4];
	double B = c[2] / c[4];
	double C = c[1] / c[4];
	double D = c[0] / c[4];
	double sq_A = A * A;
	double p = -3.0 / 8.0 * sq_A + B;
	double q = 1.0 / 8.0 * sq_A * A - 1.0 / 2.0 * A * B + C;
	double r = -3.0 / 256.0 * sq_A * sq_A + 1.0 / 16.0 * sq_A * B - 1.0 / 4.0 * A * C + D;

	if(zero(&r)) {
		coeffs[0] = q;
		coeffs[1] = p;
		coeffs[2] = 0.0;
		coeffs[3] = 1.0;
		num = solve_degree_3(coeffs, x);
		x[num++] = 0;
	} else {
		coeffs[0] = 1.0 / 2.0 * r * p - 1.0 / 8.0 * q * q;
		coeffs[1] = -r;
		coeffs[2] = -1.0 / 2.0 * p;
		coeffs[3] = 1.0;
		solve_degree_3(coeffs, x);
		double z = x[0];
		double u = z * z - r;
		double v = 2.0 * z - p;
		zero(&u);

		if(u < 0)
			return 0;
		else if(u > 0)
			u = sqrt(u);

		zero(&v);

		if(v < 0)
			return 0;
		else if(v > 0)
			v = sqrt(v);

		coeffs[0] = z - u;
		coeffs[1] = q < 0.0 ? -v : v;
		coeffs[2] = 1.0;
		num = solve_degree_2(coeffs, x);
		coeffs[0] = z + u;
		coeffs[1] = q < 0.0 ? v : -v;
		coeffs[2] = 1.0;
		num += solve_degree_2(coeffs, x + num);
	}

	double sub = 1.0 / 4.0 * A;

	for(int i = 0; i < num; i++)
		x[i] -= sub;

	return num;
}

int polynomial_solve_degree_1(const double * c, double * x)
{
	return solve_degree_1(c, x);
}

int polynomial_solve_degree_2(const double * c, double * x)
{
	return solve_degree_2(c, x);
}

int polynomial_solve_degree_3(const double * c, double * x)
{
	return solve_degree_3(c, x);
}

int polynomial_solve_degree_4(const double * c, double * x)
{
	return solve_degree_4(c, x);
}
