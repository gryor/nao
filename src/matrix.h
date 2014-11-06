#ifndef MATRIX_H_A7YR3HHQ
#define MATRIX_H_A7YR3HHQ

#ifdef __cplusplus
extern "C" {
#endif

#include <stddef.h>


double vector_length(size_t size, double * v);
void vector_unit(size_t size, double * v, double * vout);
void vector_multiply(size_t size, double scalar, double * v, double * vout);
void vector_interpolate(size_t size, double * v0, double * v1, double t, double * vout);
double vector_dot(size_t size, double * v0, double * v1);


void matrix_zero(size_t size, double * m);
void matrix_transpose(size_t rows, size_t columns, double * m, double * mt);
void matrix_identity(size_t size, double * mi);
void matrix_multiply_scalar(size_t size, double scalar, double * m, double * mout);
void matrix_multiply(size_t n, size_t m, size_t p, double * m0, double * m1, double * mout);
void matrix_set(size_t size, double scalar, double * m);
void matrix_add(size_t size, double * m0, double * m1, double * mout);
void matrix_sub(size_t size, double * m1, double * m0, double * mout);
double matrix_determinant(size_t size, double * m);
void matrix_cofactors(size_t size, double * m, double * mout);
void matrix_adjucate(size_t size, double * m, double * mout);
int matrix_inverse(size_t size, double * m, double * mout);
int matrix_solve(size_t size, double * A, double * B, double * X);


#ifdef __cplusplus
}
#endif

#endif // end of include guard: MATRIX_H_A7YR3HHQ
