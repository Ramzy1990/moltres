[GlobalParams]
  num_groups = 2
  temperature = temp
  group_fluxes = 'group1 group2'
  # MSRE full power = 10 MW; core volume 90 ft3
  power = 20
[]

[Mesh]
  file = '/home/lindsayad/gdrive/gmsh-scripts/msr-small.msh'
[]

[Variables]
  [group1]
    order = FIRST
    family = LAGRANGE
  []
  [group2]
    order = FIRST
    family = LAGRANGE
  []
  [temp]
    order = FIRST
    family = LAGRANGE
    # scaling = 1e-3
  []
[]

[Kernels]
  # Neutronics
  [diff_group1]
    type = GroupDiffusion
    variable = group1
    group_number = 1
  []
  [diff_group2]
    type = GroupDiffusion
    variable = group2
    group_number = 2
  []
  [sigma_r_group1]
    type = SigmaR
    variable = group1
    group_number = 1
  []
  [sigma_r_group2]
    type = SigmaR
    variable = group2
    group_number = 2
  []
  [inscatter_group1]
    type = InScatter
    variable = group1
    group_number = 1
    num_groups = 2
    group_fluxes = 'group1 group2'
  []
  [inscatter_group2]
    type = InScatter
    variable = group2
    group_number = 2
    num_groups = 2
    group_fluxes = 'group1 group2'
  []
  [fission_source_group1]
    type = CoupledFissionEigenKernel
    variable = group1
    group_number = 1
    num_groups = 2
    group_fluxes = 'group1 group2'
  []
  [fission_source_group2]
    type = CoupledFissionEigenKernel
    variable = group2
    group_number = 2
    num_groups = 2
    group_fluxes = 'group1 group2'
  []

  # Temperature
  [temp_cond]
    type = MatDiffusion
    variable = temp
    prop_name = 'k'
    save_in = 'diffus_resid tot_resid'
  []
  # [./temp_cond]
  #   type = HeatConduction
  #   diffusion_coefficient_name = k
  #   diffusion_coefficient_dT_name = d_k_d_temp
  #   use_displaced_mesh = false
  #   variable = temp
  # [../]
  [temp_source]
    type = FissionHeatSource
    tot_fissions = tot_fissions
    variable = temp
    save_in = 'src_resid tot_resid'
  []
[]

[AuxVariables]
  [Qf]
    family = MONOMIAL
    order = CONSTANT
  []
  [diffus_temp]
    family = MONOMIAL
    order = CONSTANT
  []
  [diffus_resid]
    family = LAGRANGE
    order = FIRST
  []
  [src_resid]
    family = LAGRANGE
    order = FIRST
  []
  [bc_resid]
    family = LAGRANGE
    order = FIRST
  []
  [tot_resid]
    family = LAGRANGE
    order = FIRST
  []
[]

[AuxKernels]
  [Qf]
    type = FissionHeatSourceAux
    variable = Qf
    tot_fissions = tot_fissions
  []
  [diffus_temp]
    type = MatDiffusionAux
    variable = diffus_temp
    diffuse_var = temp
    prop_name = 'k'
  []
[]

[Materials]
  [fuel]
    type = GenericMoltresMaterial
    block = 'fuel'
    property_tables_root = '/home/lindsayad/serpent/core/examples/serpent-input/msre/msr2g_enrU_mod_953_fuel_interp_'
    num_groups = 2
    prop_names = 'k'
    prop_values = '.0123' # Cammi 2011 at 908 K
    # prop_names = 'k d_k_d_temp'
    # prop_values = '.0123 0' # Cammi 2011 at 908 K
  []
  [moder]
    type = GenericMoltresMaterial
    block = 'moder'
    property_tables_root = '/home/lindsayad/serpent/core/examples/serpent-input/msre/msr2g_enrU_fuel_922_mod_interp_'
    num_groups = 2
    prop_names = 'k'
    prop_values = '.312' # Cammi 2011 at 908 K
    # prop_names = 'k d_k_d_temp'
    # prop_values = '.312 0' # Cammi 2011 at 908 K
  []
[]

[BCs]
  [temp]
    boundary = boundary
    type = DirichletBC
    variable = temp
    value = 900
    save_in = 'bc_resid tot_resid'
  []
  # [./temp]
  #   boundary = boundary
  #   type = VacuumBC
  #   variable = temp
  # [../]
[]

[Executioner]
  type = NonlinearEigen
  free_power_iterations = 2
  source_abs_tol = 1e-12
  source_rel_tol = 1e-8
  output_after_power_iterations = false

  # type = InversePowerMethod
  # max_power_iterations = 50
  # xdiff = 'group1diff'

  bx_norm = 'bnorm'
  k0 = 1.0
  pfactor = 1e-2
  l_max_its = 100

  # solve_type = 'PJFNK'
  solve_type = 'NEWTON'
  petsc_options = '-snes_converged_reason -ksp_converged_reason -snes_linesearch_monitor'
  petsc_options_iname = '-pc_type -sub_pc_type'
  petsc_options_value = 'asm lu'
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

[Postprocessors]
  [bnorm]
    type = ElmIntegTotFissNtsPostprocessor
    group_fluxes = 'group1 group2'
    execute_on = linear
  []
  [tot_fissions]
    type = ElmIntegTotFissPostprocessor
    execute_on = linear
  []
  [group1norm]
    type = ElementIntegralVariablePostprocessor
    variable = group1
    execute_on = linear
  []
  [group2norm]
    type = ElementIntegralVariablePostprocessor
    variable = group2
    execute_on = linear
  []
  [group1max]
    type = NodalExtremeValue
    value_type = max
    variable = group1
    execute_on = timestep_end
  []
  [group2max]
    type = NodalExtremeValue
    value_type = max
    variable = group2
    execute_on = timestep_end
  []
  [src_resid_post]
    type = NodalL2Norm
    variable = src_resid
    execute_on = nonlinear
  []
  [diffus_resid_post]
    type = NodalL2Norm
    variable = diffus_resid
    execute_on = nonlinear
  []
  [bc_resid_post]
    type = NodalL2Norm
    variable = bc_resid
    execute_on = nonlinear
  []
  [tot_resid_post]
    type = NodalL2Norm
    variable = tot_resid
    execute_on = nonlinear
  []
  [group1diff]
    type = ElementL2Diff
    variable = group1
    execute_on = 'linear timestep_end'
    use_displaced_mesh = false
  []
[]

[Outputs]
  [out]
    type = Exodus
    execute_on = 'timestep_end'
  []
[]

[Debug]
  show_var_residual_norms = true
[]

# [ICs]
#   [./temp_ic]
#     type = ConstantIC
#     variable = temp
#     value = 900
#   [../]
# []
