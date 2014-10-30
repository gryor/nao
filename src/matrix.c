#include "matrix.h"
#include <math.h>

double factorial(size_t number)
{
	size_t result = 1;

	for(; number > 1; number--)
		result *= number;

	return result;
}

double vector_length(size_t size, double * v)
{
	double length = 0;
	size_t i;

	for(i = 0; i < size; i++)
		length += v[i] * v[i];

	return sqrt(length);
}

void vector_unit(size_t size, double * v, double * vout)
{
	size_t i;
	double length = vector_length(size, v);

	for(i = 0; i < size; i++)
		vout[i] = v[i] / length;
}

void vector_multiply(size_t size, double scalar, double * v, double * vout)
{
	size_t i;

	for(i = 0;  i < size; i++)
		vout[i] = scalar * v[i];
}

void vector_interpolate(size_t size, double * v0, double * v1, double t, double * vout)
{
	size_t i;

	for(i = 0;  i < size; i++)
		vout[i] = t * (v1[i] - v0[i]);
}

double vector_dot(size_t size, double * v0, double * v1)
{
	double dot = 0;
	size_t i;

	for(i = 0; i < size; i++)
		dot += v0[i] * v1[i];

	return dot;
}

void matrix_zero(size_t size, double * m)
{
	size_t i;

	for(i = 0; i < size; i++)
		m[i] = 0;
}

void matrix_transpose(size_t rows, size_t columns, double * m, double * mt)
{
	size_t i, j;

	for(i = 0; i < rows; i++) {
		for(j = 0; j < columns; j++)
			mt[j * rows + i] = m[i * columns + j];
	}
}

void matrix_identity(size_t size, double * mi)
{
	size_t i;
	matrix_zero(size * size, mi);

	for(i = 0; i < size; i++)
		mi[i * size + i] = 1;
}

void matrix_multiply_scalar(size_t size, double scalar, double * m, double * mout)
{
	size_t i;

	for(i = 0; i < size; i++)
		mout[i] = scalar * m[i];
}

void matrix_multiply(size_t n, size_t m, size_t p, double * m0, double * m1, double * mout)
{
	size_t i, j;
	double mt[m * p];
	matrix_transpose(m, p, m1, mt);

	for(i = 0; i < n; i++) {
		for(j = 0; j < p; j++)
			mout[i * p + j] = vector_dot(m, &m0[i * m], &mt[j * m]);
	}
}

void matrix_set(size_t size, double scalar, double * m)
{
	size_t i;

	for(i = 0; i < size; i++)
		m[i] = scalar;
}

void matrix_add(size_t size, double * m0, double * m1, double * mout)
{
	size_t i;

	for(i = 0; i < size; i++)
		mout[i] = m1[i] + m0[i];
}

void matrix_sub(size_t size, double * m1, double * m0, double * mout)
{
	size_t i;

	for(i = 0; i < size; i++)
		mout[i] = m1[i] - m0[i];
}

static void matrix_capture(size_t size, size_t skip_row, size_t skip_column, double * m, double * mout)
{
	size_t i, j, k = 0;

	for(i = 0; i < size; i++) {
		if(i == skip_row)
			continue;

		for(j = 0; j < size; j++) {
			if(j == skip_column)
				continue;

			mout[k++] = m[i * size + j];
		}
	}
}

static void matrix_checkerboard(size_t size, double * m, double * mout)
{
	size_t i;

	for(i = 1; i < size; i += 2)
		mout[i] = -1 * m[i];
}

double matrix_determinant(size_t size, double * m)
{
	double det = 0;
	double mc[size - 1];
	size_t i;

	if(size == 2)
		return m[0] * m[3] - m[1] * m[2];

	for(i = 0; i < size; i += 2) {
		matrix_capture(size, 0, i, m, mc);
		det += m[i] * matrix_determinant(size - 1, mc);
	}

	for(i = 1; i < size; i += 2) {
		matrix_capture(size, 0, i, m, mc);
		det -= m[i] * matrix_determinant(size - 1, mc);
	}

	return det;
}

void matrix_cofactors(size_t size, double * m, double * mout)
{
	double mc[size - 1];
	size_t i, j;

	for(i = 0; i < size; i++) {
		for(j = 0; j < size; j++) {
			matrix_capture(size, i, j, m, mc);
			mout[i * size + j] = matrix_determinant(size - 1, mc);
		}
	}

	matrix_checkerboard(size * size, mout, mout);
}

void matrix_adjucate(size_t size, double * m, double * mout)
{
	double mtmp[size * size];
	matrix_cofactors(size, m, mtmp);
	matrix_transpose(size, size, mtmp, mout);
}

int matrix_inverse(size_t size, double * m, double * mout)
{
	double det = matrix_determinant(size, m);

	if(det == 0)
		return 1;

	matrix_adjucate(size, m, mout);
	matrix_multiply_scalar(size * size, 1 / det, mout, mout);
	return 0;
}

int matrix_solve(size_t size, double * A, double * B, double * X)
{
	double Ai[size * size];

	if(matrix_inverse(size, A, Ai))
		return 1;

	matrix_multiply(size, size, 1, Ai, B, X);
}