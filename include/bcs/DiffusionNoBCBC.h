#ifndef DIFFUSIONNOBCBC_H
#define DIFFUSIONNOBCBC_H

#include "IntegratedBC.h"

class DiffusionNoBCBC;

template <>
InputParameters validParams<DiffusionNoBCBC>();

/**
 * This kernel implements the Laplacian operator:
 * \f$\nabla u \cdot \nabla \phi_i\f$
 */
class DiffusionNoBCBC : public IntegratedBC
{
public:
  DiffusionNoBCBC(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;

  virtual Real computeQpJacobian() override;
};

#endif /* DIFFUSIONNOBCBC_H */
