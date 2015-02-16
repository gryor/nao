#ifndef DISTANCE_H_YSXH8WBX
#define DISTANCE_H_YSXH8WBX

#ifdef __cplusplus
extern "C" {
#endif


int distance_posdir_point(double * position, double * direction, double * point, double * distance);
int posdir_outside_of_sphere(double * position, double * direction, double * center, double radius);


#ifdef __cplusplus
}
#endif

#endif // end of include guard: DISTANCE_H_YSXH8WBX
