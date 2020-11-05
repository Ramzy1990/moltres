#ifndef HEATPRECURSORSOURCE_H
#define HEATPRECURSORSOURCE_H

#include "Kernel.h"
#include "ScalarTransportBase.h"

// Forward Declarations
class HeatPrecursorSource;

template <>
InputParameters validParams<HeatPrecursorSource>();

/**
 * This class computes the residual and Jacobian contributions for the
 * decay heat precursor source term in the decay heat precursor
 * equation.
 */
class HeatPrecursorSource : public Kernel, public ScalarTransportBase
{
public:
  HeatPrecursorSource(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian(unsigned int jvar) override;

  // Material properties
  const MaterialProperty<std::vector<Real>> & _fisse;
  const MaterialProperty<std::vector<Real>> & _d_fisse_d_temp;
  const MaterialProperty<std::vector<Real>> & _fissxs;
  const MaterialProperty<std::vector<Real>> & _d_fissxs_d_temp;

  unsigned int _num_groups;
  unsigned int _heat_group;
  Real _nt_scale;
  std::vector<Real> _decay_heat_frac;
  std::vector<Real> _decay_heat_const;
  const VariableValue & _temp;
  unsigned int _temp_id;
  std::vector<const VariableValue *> _group_fluxes;
  std::vector<unsigned int> _flux_ids;
};

#endif // HEATPRECURSORSOURCE_H
