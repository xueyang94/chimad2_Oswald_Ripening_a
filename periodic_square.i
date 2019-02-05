[Mesh]
  type = GeneratedMesh
  dim = 2
  elem_type = QUAD4
  nx = 1
  ny = 1
  nz = 0
  xmin = 0
  xmax = 200
  ymin = 0
  ymax = 200
  zmin = 0
  zmax = 0
  uniform_refine = 7
[]

[Variables]
  [./c]
    order = FIRST
    family = LAGRANGE
    #scaling = 1e+04
  [../]
  [./w]
    order = FIRST
    family = LAGRANGE
  [../]
  [./eta1]
    order = FIRST
    family = LAGRANGE
  [../]
  [./eta2]
    order = FIRST
    family = LAGRANGE
  [../]
  [./eta3]
    order = FIRST
    family = LAGRANGE
  [../]
  [./eta4]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./f_density]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[ICs]
  [./concentrationIC]
    type = FunctionIC
    function = '0.5 + 0.05 * (cos(0.105*x)*cos(0.11*y) +
                (cos(0.13*x)*cos(0.087*y))^2 +
                cos(0.025*x - 0.15*y)*cos(0.07*y - 0.02*y))'
    variable = c
  [../]
  [./eta1IC]
    type = FunctionIC
    function = '0.1*(cos(0.01*1*x - 4)*cos((0.007 + 0.01*1)*y) +
                cos((0.11 + 0.01*1)*x)*cos((0.11 + 0.01*1)*y) +
                1.5*(cos((0.046 + 0.001*1)*x + (0.0405 + 0.001*1)*y)*
                cos((0.031 + 0.001*1)*x - (0.004 + 0.001*1)*y))^2)^2'
    variable = eta1
  [../]
  [./eta2IC]
    type = FunctionIC
    function = '0.1*(cos(0.01*2*x - 4)*cos((0.007 + 0.01*2)*y) +
                cos((0.11 + 0.01*2)*x)*cos((0.11 + 0.01*2)*y) +
                1.5*(cos((0.046 + 0.001*2)*x + (0.0405 + 0.001*2)*y)*
                cos((0.031 + 0.001*2)*x - (0.004 + 0.001*2)*y))^2)^2'
    variable = eta2
  [../]
  [./eta3IC]
    type = FunctionIC
    function = '0.1*(cos(0.01*3*x - 4)*cos((0.007 + 0.01*3)*y) +
                cos((0.11 + 0.01*3)*x)*cos((0.11 + 0.01*3)*y) +
                1.5*(cos((0.046 + 0.001*3)*x + (0.0405 + 0.001*3)*y)*
                cos((0.031 + 0.001*3)*x - (0.004 + 0.001*3)*y))^2)^2'
    variable = eta3
  [../]
  [./eta4IC]
    type = FunctionIC
    function = '0.1*(cos(0.01*4*x - 4)*cos((0.007 + 0.01*4)*y) +
                cos((0.11 + 0.01*4)*x)*cos((0.11 + 0.01*4)*y) +
                1.5*(cos((0.046 + 0.001*4)*x + (0.0405 + 0.001*4)*y)*
                cos((0.031 + 0.001*4)*x - (0.004 + 0.001*4)*y))^2)^2'
    variable = eta4
  [../]
[]

[BCs]
  [./Periodic]
    [./c_bcs]
      auto_direction = 'x y'
    [../]
  [../]
[]

[Kernels]
  [./w_dot]
    type = CoupledTimeDerivative
    v = c
    variable = w
  [../]
  [./coupled_res]
    type = SplitCHWRes
    variable = w
    mob_name = M
  [../]
  [./coupled_parsed]
    type = SplitCHParsed
    variable = c
    f_name = F
    kappa_name = kappa_c
    w = w
  [../]
  [./time_derivative_1]
    type = TimeDerivative
    variable = eta1
  [../]
  [./ACInterface_1]
    type = ACInterface
    variable = eta1
    kappa_name = kappa_eta
  [../]
  [./ACparsed_1]
    type = AllenCahn
    f_name = F
    variable = eta1
    mob_name = L
  [../]
  [./time_derivative_2]
    type = TimeDerivative
    variable = eta2
  [../]
  [./ACInterface_2]
    type = ACInterface
    variable = eta2
    kappa_name = kappa_eta
  [../]
  [./ACparsed_2]
    type = AllenCahn
    f_name = F
    variable = eta2
    mob_name = L
  [../]
  [./time_derivative_3]
    type = TimeDerivative
    variable = eta3
  [../]
  [./ACInterface_3]
    type = ACInterface
    variable = eta3
    kappa_name = kappa_eta
  [../]
  [./ACparsed_3]
    type = AllenCahn
    f_name = F
    variable = eta3
    mob_name = L
  [../]
  [./time_derivative_4]
    type = TimeDerivative
    variable = eta4
  [../]
  [./ACInterface_4]
    type = ACInterface
    variable = eta4
    kappa_name = kappa_eta
  [../]
  [./ACparsed_4]
    type = AllenCahn
    f_name = F
    variable = eta4
    mob_name = L
  [../]
[]

[AuxKernels]
  [./f_density]
    type = TotalFreeEnergy
    variable = f_density
    f_name = 'F'
    kappa_names = 'kappa_c'
    interfacial_vars = c
  [../]
[]

[Materials]
  [./kappa_c]
    type = GenericConstantMaterial
    prop_names = 'kappa_c'
    prop_values = '3'
  [../]
  [./kappa_eta]
    type = GenericConstantMaterial
    prop_names = 'kappa_eta'
    prop_values = '3'
  [../]
  [./CH_mobility]
    type = GenericConstantMaterial
    prop_names = 'M'
    prop_values = '5'
  [../]
  [./AC_mobility]
    type = GenericConstantMaterial
    prop_names = 'L'
    prop_values = '5'
  [../]
  [./free_energy_A]
    type = DerivativeParsedMaterial
    f_name = Fa
    function = '2*(c - 0.3)^2'
    args = c
    derivative_order = 2
    enable_jit = true
  [../]
  [./free_energy_B]
    type = DerivativeParsedMaterial
    f_name = Fb
    function = '2*(0.7 - c)^2'
    args = c
    derivative_order = 2
    enable_jit = true
  [../]
  [./h]
    type = DerivativeParsedMaterial
    f_name = h
    args = 'eta1 eta2 eta3 eta4'
    function = 'eta1^3*(6*eta1^2 - 15*eta1 + 10) +
                eta2^3*(6*eta2^2 - 15*eta2 + 10) +
                eta3^3*(6*eta3^2 - 15*eta3 + 10) +
                eta4^3*(6*eta4^2 - 15*eta4 +10)'
    derivative_order = 2
  [../]
  [./g]
    type = DerivativeParsedMaterial
    f_name = g
    args = 'eta1 eta2 eta3 eta4'
    function = 'eta1^2*(1 - eta1)^2 + eta2^2*(1 - eta2)^2 + eta3^2*(1 - eta3)^2 + eta4^2*(1 - eta4)^2 +
               5*((eta1*eta2)^2 + (eta1*eta3)^2 + (eta1*eta4)^2 +
               (eta2*eta3)^2 + (eta2*eta4)^2 +
               (eta3*eta4)^2)'
    derivative_order = 2
  [../]
  [./F]
    type = DerivativeParsedMaterial
    f_name = F
    material_property_names = 'Fa(c) Fb(c) h(eta1,eta2,eta3,eta4) g(eta1,eta2,eta3,eta4)'
    args = 'c eta1 eta2 eta3 eta4'
    constant_names = W
    constant_expressions = 1.0
    function = 'Fa*(1-h)+Fb*h+W*g'
    derivative_order = 2
  [../]
  # [./precipitate_indicator]
  #   type = ParsedMaterial
  #   f_name = prec_indic
  #   args = c
  #   function = if(c>0.6,0.0016,0)
  # [../]
[]

[Preconditioning]
  [./coupled]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  l_max_its = 30
  l_tol = 1e-06
  nl_max_its = 50
  nl_abs_tol = 1e-09
  end_time = 604800
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm      31                  preonly       ilu          1'
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 50
    cutback_factor = 0.8
    growth_factor = 1.5
    optimal_iterations = 7
  [../]
  [./Adaptivity]
    coarsen_fraction = 0.1
    refine_fraction = 0.7
    max_h_level = 7
  [../]
[]

[Postprocessors]
  # [./step_size]
  #   type = TimestepSize
  # [../]
  # [./iterations]
  #   type = NumNonlinearIterations
  # [../]
  # [./nodes]
  #   type = NumNodes
  # [../]
  # [./evaluations]
  #   type = NumResidualEvaluations
  # [../]
  # [./precipitate_area]
  #   type = ElementIntegralMaterialProperty
  #   mat_prop = prec_indic
  # [../]
  [./total_energy]
    type = ElementIntegralVariablePostprocessor
    variable = f_density
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]

[Outputs]
  exodus = true
  console = true
  csv = true
#  perf_graph = true
  [./console]
    type = Console
    max_rows = 10
  [../]
[]
