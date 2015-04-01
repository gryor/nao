# Polynomial

## Solve

```c
int polynomial_solve_degree_1(const double * c, double * x);
int polynomial_solve_degree_2(const double * c, double * x);
int polynomial_solve_degree_3(const double * c, double * x);
int polynomial_solve_degree_4(const double * c, double * x);
```

### Parameters

* `c` is an array of coefficients (array size is degree + 1)
* `x` will receive an array of solutions (array size equals to the degrees)

### Return
The number of solutions.
