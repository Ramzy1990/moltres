###############################################################################
################### MOOSE Application Standard Makefile #######################
###############################################################################
#
# Optional Environment variables
# MOOSE_DIR        - Root directory of the MOOSE project
#
###############################################################################
# Use the MOOSE submodule if it exists and MOOSE_DIR is not set
MOOSE_SUBMODULE    := $(CURDIR)/moose
ifneq ($(wildcard $(MOOSE_SUBMODULE)/framework/Makefile),)
  MOOSE_DIR        ?= $(MOOSE_SUBMODULE)
else
  MOOSE_DIR        ?= $(shell dirname `pwd`)/moose
endif

# framework
FRAMEWORK_DIR      := $(MOOSE_DIR)/framework
include $(FRAMEWORK_DIR)/build.mk
include $(FRAMEWORK_DIR)/moose.mk

################################## MODULES ####################################
# To use certain physics included with MOOSE, set variables below to
# yes as needed.  Or set ALL_MODULES to yes to turn on everything (overrides
# other set variables).

ALL_MODULES                 := no

OPTIMIZATION                := yes
CHEMICAL_REACTIONS          := yes
CONTACT                     := yes
EXTERNAL_PETSC_SOLVER       := yes
FLUID_PROPERTIES            := yes
FUNCTIONAL_EXPANSION_TOOLS  := yes
GEOCHEMISTRY                := yes
HEAT_CONDUCTION             := yes
LEVEL_SET                   := yes
MISC                        := no
NAVIER_STOKES               := yes
PHASE_FIELD                 := yes
POROUS_FLOW                 := yes
RAY_TRACING                 := no
RDG                         := no
RICHARDS                    := no
STOCHASTIC_TOOLS            := yes
TENSOR_MECHANICS            := yes
THERMAL_HYDRAULICS          := no
FSI                         := yes
XFEM                        := yes


# CHEMICAL_REACTIONS          := yes
# CONTACT                     := yes
# ELECTROMAGNETICS            := yes
# EXTERNAL_PETSC_SOLVER       := yes
# FLUID_PROPERTIES            := yes
# FSI                         := yes
# FUNCTIONAL_EXPANSION_TOOLS  := yes
# GEOCHEMISTRY                := yes
# HEAT_CONDUCTION             := yes
# LEVEL_SET                   := yes
# MISC                        := yes
# NAVIER_STOKES               := yes
# OPTIMIZATION                := yes
# PERIDYNAMICS                := yes
# PHASE_FIELD                 := yes
# POROUS_FLOW                 := yes
# RAY_TRACING                 := yes
# REACTOR                     := yes
# RDG                         := yes
# RICHARDS                    := yes
# STOCHASTIC_TOOLS            := yes
# THERMAL_HYDRAULICS          := yes
# TENSOR_MECHANICS            := yes
# XFEM                        := yes



include $(MOOSE_DIR)/modules/modules.mk
###############################################################################

# Use the SQUIRREL submodule if it exists and SQUIRREL_DIR is not set
SQUIRREL_SUBMODULE    := $(CURDIR)/squirrel
ifneq ($(wildcard $(SQUIRREL_SUBMODULE)/Makefile),)
  SQUIRREL_DIR        ?= $(SQUIRREL_SUBMODULE)
else
  SQUIRREL_DIR        ?= $(shell dirname `pwd`)/squirrel
endif

# squirrel
APPLICATION_DIR    := $(SQUIRREL_DIR)
APPLICATION_NAME   := squirrel
include            $(FRAMEWORK_DIR)/app.mk

# dep apps
APPLICATION_DIR    := $(CURDIR)
APPLICATION_NAME   := moltres
BUILD_EXEC         := yes
DEP_APPS           := $(shell $(FRAMEWORK_DIR)/scripts/find_dep_apps.py $(APPLICATION_NAME))
include            $(FRAMEWORK_DIR)/app.mk

###############################################################################
# Additional special case targets should be added here
