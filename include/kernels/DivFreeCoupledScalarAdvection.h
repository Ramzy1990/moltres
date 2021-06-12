#pragma once

#include "Kernel.h"
#include "ScalarTransportBase.h"

/**
 * This class computes the residual and Jacobian contributions for the
 * incompressible Navier-Stokes temperature (energy) equation.
 */
class DivFreeCoupledScalarAdvection : public Kernel, public ScalarTransportBase
{
public:
  DivFreeCoupledScalarAdvection(const InputParameters & parameters);

  static InputParameters validParams();

  virtual ~DivFreeCoupledScalarAdvection() {}

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned jvar);

  // DivFreeCoupled variables
  const VariableValue & _u_vel;
  const VariableValue & _v_vel;
  const VariableValue & _w_vel;

  // Variable numberings
  unsigned _u_vel_var_number;
  unsigned _v_vel_var_number;
  unsigned _w_vel_var_number;

  VariableValue _u_def;
  VariableValue _v_def;
  VariableValue _w_def;
  Real _conc_scaling;
};
