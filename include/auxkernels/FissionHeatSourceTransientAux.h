#pragma once

#include "AuxKernel.h"

/**
 * Computes heat source due to fission during a transient.
 * This is the same as FissionHeatSourceAux, but with the exception
 * that the power is not normalized to some user-defined value. The reactor
 * will produce heat freely. You'll probably see thermal feedback since MSRs are
 * nice like that.
 */
class FissionHeatSourceTransientAux : public AuxKernel
{
public:
  FissionHeatSourceTransientAux(const InputParameters & parameters);

  static InputParameters validParams();

protected:
  virtual Real computeValue() override;

  const MaterialProperty<std::vector<Real>> & _fissxs;
  const MaterialProperty<std::vector<Real>> & _fisse;
  unsigned int _num_groups;
  Real _nt_scale;
  std::vector<const VariableValue *> _group_fluxes;
};
