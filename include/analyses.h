#if !defined(ANALYSES_H)
#define ANALYSES_H

extern double analyses_compute_kinetic_dissipation_x(const param_t *param, const fluid_t *fluid, const int i, const int j);
extern double analyses_compute_kinetic_dissipation_y(const param_t *param, const fluid_t *fluid, const int i, const int j);
extern double analyses_compute_thermal_dissipation(const param_t *param, const temperature_t *temperature, const int i, const int j);

#endif // ANALYSES_H
