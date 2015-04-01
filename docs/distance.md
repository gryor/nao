## Distance from a line to a point 

```c
int distance_posdir_point(double * position, double * direction, double * point, double * distance);
```

### Parameters
`Position` and `direction` represents the first and the second point in a 3d line.

`Position`, `direction` and `point` are all 3 dimensional arrays.

`Distance` is a scalar, which will get the result.


### Return
* 0 Success
* 1 Error

## Test for a line being outside of a sphere

```c
int posdir_outside_of_sphere(double * position, double * direction, double * center, double radius);
```

### Parameters

`Position` and `direction` represents the first and the second point in a 3d line.
`Center` is the center of a sphere and `radius` is the radius of the sphere.

`Position`, `direction` and `center` are all 3 dimensional arrays.

### Return
* -1 Error
* 0 The line crosses the sphere (includes the border)
* 1 The line is outside of the sphere
