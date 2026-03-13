# Code for define functions (variable definition) in models of SINDBAD for LUE experiment applied to FLUXNET domain.
# These functions are called just ONCE for variable/array definitions.
# Based on @code_string from CodeTracking.jl. In case of conflicts, follow the original code in define functions of model approaches in src/Models/[model]/[approach].jl

# constants_numbers
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/constants/constants_numbers.jl
# Call order: 1

function define(params::constants_numbers, forcing, land, helpers)

	z_zero = oftype(helpers.numbers.tolerance, 0.0)
	o_one = oftype(helpers.numbers.tolerance, 1.0)
	t_two = oftype(helpers.numbers.tolerance, 2.0)
	t_three = oftype(helpers.numbers.tolerance, 3.0)

	@pack_nt (z_zero, o_one, t_two, t_three) ⇒ land.constants

	return land
end

# --------------------------------------

# ambientCO2_forcing
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/ambientCO2/ambientCO2_forcing.jl
# Call order: 2

# --------------------------------------

# fAPAR_constant
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 3

# --------------------------------------

# gppPotential_Monteith
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 4

# --------------------------------------

# gppDiffRadiation_Wang2015
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 5

function define(params::gppDiffRadiation_Wang2015, forcing, land, helpers)
    ## unpack parameters and forcing
    @unpack_gppDiffRadiation_Wang2015 params
    @unpack_nt (f_rg, f_rg_pot) ⇐ forcing

    ## calculate variables
    CI = one(μ) #@needscheck: this is different to Turner which does not have 1- . So, need to check if this correct
    CI_min = CI
    CI_max = CI
    @pack_nt (CI_min, CI_max) ⇒ land.gppDiffRadiation
    return land
end

# --------------------------------------

# gppDirRadiation_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDirRadiation/gppDirRadiation_none.jl
# Call order: 6

function define(params::gppDirRadiation_none, forcing, land, helpers)
    @unpack_nt o_one ⇐ land.constants
    ## calculate variables
    gpp_f_light = o_one

    ## pack land variables
    @pack_nt gpp_f_light ⇒ land.diagnostics
    return land
end

# --------------------------------------

# gppAirT_CASA
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 7

# --------------------------------------

# gppVPD_PRELES
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 8

# --------------------------------------

# gppSoilW_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppSoilW/gppSoilW_none.jl
# Call order: 9

function define(params::gppSoilW_none, forcing, land, helpers)
    @unpack_nt o_one ⇐ land.constants

    ## calculate variables
    # set scalar to a constant one [no effect on potential GPP]
    gpp_f_soilW = o_one

    ## pack land variables
    @pack_nt gpp_f_soilW ⇒ land.diagnostics
    return land
end

# --------------------------------------

# gppDemand_mult
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDemand/gppDemand_mult.jl
# Call order: 10

function define(params::gppDemand_mult, forcing, land, helpers)
    @unpack_nt f_VPD_day ⇐ forcing
    gpp_climate_stressors = ones(typeof(f_VPD_day), 4)

    if hasproperty(land.pools, :soilW)
        @unpack_nt soilW ⇐ land.pools
        if soilW isa SVector
            gpp_climate_stressors = SVector{4}(gpp_climate_stressors)
        end
    end

    @pack_nt gpp_climate_stressors ⇒ land.diagnostics

    return land
end

# --------------------------------------

# gpp_min
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gpp/gpp_min.jl
# Call order: 11

# --------------------------------------

# Fallback define function for LandEcosystem
    function define(params::LandEcosystem, forcing, land, helpers)
        return land
    end

    