#include "matrix.h"

int distance_posdir_point(double * position, double * direction, double * point, double * distance)
{
	double point2[3], dir_len = vector_length(3, direction), p_pos[3], numerator[3];

	if(dir_len == 0)
		return 1;

	matrix_add(3, position, direction, point2);
	matrix_sub(3, position, point, p_pos);
	vector3_cross(direction, p_pos, numerator);
	*distance = vector_length(3, numerator) / dir_len;
	return 0;
}

int posdir_outside_of_sphere(double * position, double * direction, double * center, double radius)
{
	double distance;

	if(distance_posdir_point(position, direction, center, &distance))
		return -1;

	if(distance > radius)
		return 1;

	return 0;
}