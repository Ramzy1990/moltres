#ifndef FISSIONEHEATSOURCE_H
#define FISSIONEHEATSOURCE_H

#include "Kernel.h"

class FissionHeatSource;

template <>
InputParameters validParams<FissionHeatSource>();

/**
 * This kernel will likely only be used with k-eigenvalue calculation mode
 * with neutrons only, since the power is normalized in this case.
 */
class FissionHeatSource : public Kernel
{
public:
  FissionHeatSource(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  const MaterialProperty<std::vector<Real>> & _fissxs;
  const MaterialProperty<std::vector<Real>> & _d_fissxs_d_temp;
  unsigned int _num_groups;
  const PostprocessorValue & _tot_fissions;
  Real _power;
  std::vector<const VariableValue *> _group_fluxes;
  std::vector<unsigned int> _flux_ids;
};

#endif // FISSIONEHEATSOURCE_H
