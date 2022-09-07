flow_velocity = 147 # Cammi 147 cm/s

[GlobalParams]
  num_groups = 2
  num_precursor_groups = 1
  group_fluxes = 'group1 group2'
  # MSRE full power = 10 MW; core volume 90 ft3
  power = 200000
[]

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 2
  ny = 2
  block_id = 0
  block_name = 'fuel'
[]

[MeshModifiers]
  [mod]
    type = SubdomainBoundingBox
    bottom_left = '0.5 0 0'
    top_right = '1 1 0'
    block_id = 1
    block_name = 'moder'
  []
[]

[Variables]
  # [./pre1]
  # [../]
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
    scaling = 1e-3
  []
[]

[Kernels]
  # Neutronics
  # [./time_group1]
  #   type = NtTimeDerivative
  #   grou_number = 1
  #   variable = group1
  # [../]
  # [./time_group2]
  #   type = NtTimeDerivative
  #   grou_number = 2
  #   variable = group2
  # [../]
  [diff_group1]
    type = GroupDiffusion
    variable = group1
    group_number = 1
    temperature = temp
  []
  [diff_group2]
    type = GroupDiffusion
    variable = group2
    group_number = 2
    temperature = temp
  []
  [sigma_r_group1]
    type = SigmaR
    variable = group1
    group_number = 1
    temperature = temp
  []
  [sigma_r_group2]
    type = SigmaR
    variable = group2
    group_number = 2
    temperature = temp
  []
  [inscatter_group1]
    type = InScatter
    variable = group1
    group_number = 1
    num_groups = 2
    group_fluxes = 'group1 group2'
    temperature = temp
  []
  [inscatter_group2]
    type = InScatter
    variable = group2
    group_number = 2
    num_groups = 2
    group_fluxes = 'group1 group2'
    temperature = temp
  []
  [fission_source_group1]
    type = CoupledFissionEigenKernel
    variable = group1
    group_number = 1
    num_groups = 2
    group_fluxes = 'group1 group2'
    temperature = temp
  []
  [fission_source_group2]
    type = CoupledFissionEigenKernel
    variable = group2
    group_number = 2
    num_groups = 2
    group_fluxes = 'group1 group2'
    temperature = temp
  []
  # [./fission_source_group1]
  #   type = CoupledFissionKernel
  #   variable = group1
  #   group_number = 1
  #   num_groups = 2
  #   group_fluxes = 'group1 group2'
  # temperature = temp
  # [../]
  # [./fission_source_group2]
  #   type = CoupledFissionKernel
  #   variable = group2
  #   group_number = 2
  #   num_groups = 2
  #   group_fluxes = 'group1 group2'
  # temperature = temp
  # [../]

  # Temperature
  # [./temp_cond]
  #   type = MatDiffusion
  #   variable = temp
  #   prop_name = 'k'
  # [../]
  [temp_flow_fuel]
    block = 'fuel'
    type = MatINSTemperatureRZ
    variable = temp
    rho = 'rho'
    k = 'k'
    cp = 'cp'
    uz = ${flow_velocity}
  []
  [temp_flow_moder]
    block = 'moder'
    type = MatINSTemperatureRZ
    variable = temp
    rho = 'rho'
    k = 'k'
    cp = 'cp'
  []
  [temp_source]
    type = FissionHeatSource
    tot_fissions = tot_fissions
    variable = temp
  []

  #   # Delayed neutron precursors
  # [./pre1_source]
  #   type = PrecursorSource
  #   variable = pre1
  #   precursor_group_number = 1
  #   temperature = temp
  # [../]
  # [./pre1_decay]
  #   type = PrecursorDecay
  #   variable = pre1
  #   precursor_group_number = 2
  #   temperature = temp
  # [../]
[]

[Precursors]
  var_name_base = pre
  # v_def = ${flow_velocity}
  # block = 'fuel'
  inlet_boundary = 'bottom'
  inlet_boundary_condition = 'DirichletBC'
  inlet_dirichlet_value = 0
  outlet_boundary = 'top'
  T = temp
[]

[AuxVariables]
  [Qf]
    family = MONOMIAL
    order = CONSTANT
  []
  # [./diffus_temp]
  #   family = MONOMIAL
  #   order = CONSTANT
  # [../]
  # [./diffus_resid]
  #   family = LAGRANGE
  #   order = FIRST
  # [../]
  # [./src_resid]
  #   family = LAGRANGE
  #   order = FIRST
  # [../]
  # [./bc_resid]
  #   family = LAGRANGE
  #   order = FIRST
  # [../]
  # [./tot_resid]
  #   family = LAGRANGE
  #   order = FIRST
  # [../]
[]

[AuxKernels]
  [Qf]
    type = FissionHeatSourceAux
    variable = Qf
    tot_fissions = tot_fissions
  []
  # [./diffus_temp]
  #   type = MatDiffusionAux
  #   variable = diffus_temp
  #   diffuse_var = temp
  #   prop_name = 'k'
  # [../]
[]

[Materials]
  [fuel]
    type = GenericMoltresMaterial
    block = 'fuel'
    property_tables_root = 'msr2g_enrU_mod_953_fuel_interp_'
    num_groups = 2
    num_precursor_groups = 8
    prop_names = 'k rho cp'
    prop_values = '.0123 3.327e-3 1357' # Cammi 2011 at 908 K
    temperature = temp
  []
  [moder]
    type = GenericMoltresMaterial
    block = 'moder'
    property_tables_root = 'msr2g_enrU_fuel_922_mod_interp_'
    num_groups = 2
    num_precursor_groups = 8
    prop_names = 'k rho cp'
    prop_values = '.312 1.843e-3 1760' # Cammi 2011 at 908 K
    temperature = temp
  []
[]

[BCs]
  [temp_inlet]
    boundary = 'bottom'
    type = DirichletBC
    variable = temp
    value = 900
  []
  [temp_outlet]
    boundary = 'top'
    type = MatINSTemperatureNoBCBC
    variable = temp
    k = 'k'
  []
  [group1_vacuum]
    type = VacuumBC
    variable = group1
    boundary = 'top bottom'
  []
  [group2_vacuum]
    type = VacuumBC
    variable = group2
    boundary = 'top bottom'
  []
[]

[Problem]
  type = FEProblem
  coord_type = RZ
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
  k0 = 1.7
  pfactor = 1e-2
  l_max_its = 100

  line_search = none
  # solve_type = 'PJFNK'
  solve_type = 'NEWTON'
  petsc_options = '-snes_converged_reason -ksp_converged_reason -snes_linesearch_monitor -snes_test_display'
  # This system will not converge with default preconditioning; need to use asm
  petsc_options_iname = '-pc_type -sub_pc_type -sub_ksp_type -pc_asm_overlap -ksp_gmres_restart'
  petsc_options_value = 'asm lu preonly 2 31'
  # petsc_options_iname = '-snes_type'
  # petsc_options_value = 'test'
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

[ICs]
  [temp_ic]
    type = ConstantIC
    variable = temp
    value = 900
  []
[]
