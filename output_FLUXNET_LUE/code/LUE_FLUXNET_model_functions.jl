# Code for precompute and compute functions in models of SINDBAD for LUE experiment applied to FLUXNET domain.
# Precompute functions are called once outside the time loop per iteration in optimization, while compute functions are called every time step.
# Based on @code_string from CodeTracking.jl. In case of conflicts, follow the original code in model approaches in src/Processes/[model]/[approach].jl

# constants_numbers
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/constants/constants_numbers.jl
# Call order: 1

# --------------------------------------

# ambientCO2_forcing
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/ambientCO2/ambientCO2_forcing.jl
# Call order: 2

function compute(params::ambientCO2_forcing, forcing, land, helpers)
    ## unpack forcing
    @unpack_nt f_ambient_CO2 ⇐ forcing

    ambient_CO2 = f_ambient_CO2

    ## pack land variables
    @pack_nt ambient_CO2 ⇒ land.states
    return land
end

# --------------------------------------

# fAPAR_constant
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 3

function precompute(params::fAPAR_constant, forcing, land, helpers)
    ## unpack parameters
    @unpack_fAPAR_constant params

    ## calculate variables
    fAPAR = constant_fAPAR

    ## pack land variables
    @pack_nt fAPAR ⇒ land.states
    return land
end

# --------------------------------------

# gppPotential_Monteith
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 4

function compute(params::gppPotential_Monteith, forcing, land, helpers)
    ## unpack parameters and forcing
    @unpack_gppPotential_Monteith params
    @unpack_nt f_PAR ⇐ forcing

    ## calculate variables
    # set rueGPP to a constant
    gpp_potential = εmax * f_PAR

    ## pack land variables
    @pack_nt gpp_potential ⇒ land.diagnostics
    return land
end

# --------------------------------------

# gppDiffRadiation_Wang2015
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 5

function precompute(params::gppDiffRadiation_Wang2015, forcing, land, helpers)
    ## unpack parameters and forcing
    @unpack_gppDiffRadiation_Wang2015 params
    ## calculate variables
    gpp_f_cloud = one(μ)
    ## pack land variables
    @pack_nt gpp_f_cloud ⇒ land.diagnostics
    return land
end

function compute(params::gppDiffRadiation_Wang2015, forcing, land, helpers)
    ## unpack parameters and forcing
    @unpack_gppDiffRadiation_Wang2015 params

    @unpack_nt (f_rg, f_rg_pot) ⇐ forcing

    @unpack_nt begin
        (CI_min, CI_max) ⇐ land.gppDiffRadiation
        z_zero ⇐ land.constants
        tolerance ⇐ helpers.numbers
    end

    ## calculate variables
    ## FROM SHANNING
    rg_frac = safe_divide(f_rg, f_rg_pot)

    CI = clamp_zero_one(one(rg_frac) - rg_frac) #@needscheck: this is different to Turner which does not have 1- . So, need to check if this correct

    # update the minimum and maximum on the go
    CI_min = min(CI, CI_min)
    CI_max = max(CI, CI_max)

    CI_nor = clamp_zero_one(safe_divide(CI - CI_min, CI_max - CI_min)) # @needscheck: originally, CI_min and max were based on the year's data. see below.


    cScGPP = one(μ) - μ * (one(μ) - CI_nor)
    gpp_f_cloud = f_rg_pot > zero(f_rg_pot) ? cScGPP : zero(cScGPP)

    ## pack land variables
    @pack_nt gpp_f_cloud ⇒ land.diagnostics
    @pack_nt (CI_min, CI_max) ⇒ land.gppDiffRadiation
    return land
end

# --------------------------------------

# gppDirRadiation_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDirRadiation/gppDirRadiation_none.jl
# Call order: 6

# --------------------------------------

# gppAirT_CASA
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 7

function compute(params::gppAirT_CASA, forcing, land, helpers)
    ## unpack parameters and forcing
    @unpack_gppAirT_CASA params
    @unpack_nt f_airT_day ⇐ forcing
    @unpack_nt o_one ⇐ land.constants

    ## calculate variables
    # CALCULATE T1: account for effects of temperature stress reflects the empirical observation that plants in very cold habitats typically have low maximum rates
    # T1 = 0.8 + 0.02 * opt_airT - 0.0005 * opt_airT ^ 2 this would make sense if opt_airT would be the same everywhere.

    # first half of the response curve
    Tp1 = o_one / ((o_one + exp(opt_airT_A * -exp_airT)) * (o_one + exp(opt_airT_A * -exp_airT)))
    TC1 = o_one / Tp1
    T1 =
        TC1 / ((o_one + exp(opt_airT_A * (opt_airT - exp_airT - f_airT_day))) *
               (o_one + exp(opt_airT_A * (-opt_airT - exp_airT + f_airT_day))))

    # second half of the response curve
    Tp2 = o_one / ((o_one + exp(opt_airT_B * (-exp_airT))) * (o_one + exp(opt_airT_B * (-exp_airT))))
    TC2 = o_one / Tp2
    T2 =
        TC2 / ((o_one + exp(opt_airT_B * (opt_airT - exp_airT - f_airT_day))) *
               (o_one + exp(opt_airT_B * (-opt_airT - exp_airT + f_airT_day))))

    # get the scalar
    gpp_f_airT = f_airT_day >= opt_airT ? T2 : T1

    ## pack land variables
    @pack_nt gpp_f_airT ⇒ land.diagnostics
    return land
end

# --------------------------------------

# gppVPD_PRELES
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 8

function compute(params::gppVPD_PRELES, forcing, land, helpers)
    ## unpack parameters and forcing
    @unpack_gppVPD_PRELES params
    @unpack_nt f_VPD_day ⇐ forcing

    ## unpack land variables
    @unpack_nt begin
        ambient_CO2 ⇐ land.states
        o_one ⇐ land.constants
    end
    # fVPD_VPD                    = exp(p.gppfVPD.kappa .* -f.f_VPD_day(:,tix) .* (p.gppfVPD.base_ambient_CO2 ./ s.cd.ambCO2) .^ -p.gppfVPD.Ckappa);
    # fCO2_CO2                    = 1 + (s.cd.ambCO2 - p.gppfVPD.base_ambient_CO2) ./ (s.cd.ambCO2 - p.gppfVPD.base_ambient_CO2 + p.gppfVPD.sat_ambient_CO2);
    # VPDScGPP                    = max(0, min(1, fVPD_VPD .* fCO2_CO2));
    # d.gppfVPD.VPDScGPP(:,tix)	= VPDScGPP;

    ## calculate variables
    fVPD_VPD = exp(-κ * f_VPD_day * (base_ambient_CO2 / ambient_CO2)^-c_κ)
    fCO2_CO2 = o_one + (ambient_CO2 - base_ambient_CO2) / (ambient_CO2 - base_ambient_CO2 + sat_ambient_CO2)
    gpp_f_vpd = clamp_zero_one(fVPD_VPD * fCO2_CO2)

    ## pack land variables
    @pack_nt gpp_f_vpd ⇒ land.diagnostics
    return land
end

# --------------------------------------

# gppSoilW_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppSoilW/gppSoilW_none.jl
# Call order: 9

# --------------------------------------

# gppDemand_mult
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDemand/gppDemand_mult.jl
# Call order: 10

function compute(params::gppDemand_mult, forcing, land, helpers)

    ## unpack land variables
    @unpack_nt begin
        gpp_f_cloud ⇐ land.diagnostics
        fAPAR ⇐ land.states
        gpp_potential ⇐ land.diagnostics
        gpp_f_light ⇐ land.diagnostics
        gpp_climate_stressors ⇐ land.diagnostics
        gpp_f_airT ⇐ land.diagnostics
        gpp_f_vpd ⇐ land.diagnostics
    end

    # set 3d scalar matrix with current scalars
    gpp_climate_stressors = repElem(gpp_climate_stressors, gpp_f_airT, gpp_climate_stressors, gpp_climate_stressors, 1)
    gpp_climate_stressors = repElem(gpp_climate_stressors, gpp_f_vpd, gpp_climate_stressors, gpp_climate_stressors, 2)
    gpp_climate_stressors = repElem(gpp_climate_stressors, gpp_f_light, gpp_climate_stressors, gpp_climate_stressors, 3)
    gpp_climate_stressors = repElem(gpp_climate_stressors, gpp_f_cloud, gpp_climate_stressors, gpp_climate_stressors, 4)

    # compute the product of all the scalars
    gpp_f_climate = gpp_f_light * gpp_f_cloud * gpp_f_airT * gpp_f_vpd

    # compute demand GPP
    gpp_demand = fAPAR * gpp_potential * gpp_f_climate

    ## pack land variables
    @pack_nt (gpp_climate_stressors, gpp_f_climate, gpp_demand) ⇒ land.diagnostics
    return land
end

# --------------------------------------

# gpp_min
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gpp/gpp_min.jl
# Call order: 11

function compute(params::gpp_min, forcing, land, helpers)

    ## unpack land variables
    @unpack_nt begin
        gpp_f_climate ⇐ land.diagnostics
        fAPAR ⇐ land.states
        gpp_potential ⇐ land.diagnostics
        gpp_f_soilW ⇐ land.diagnostics
    end

    AllScGPP = min(gpp_f_climate, gpp_f_soilW)
    # & multiply
    gpp = fAPAR * gpp_potential * AllScGPP

    ## pack land variables
    @pack_nt begin
        gpp ⇒ land.fluxes
        AllScGPP ⇒ land.gpp
    end
    return land
end

# --------------------------------------

# Fallback precompute and compute functions for LandEcosystem
    function precompute(params::LandEcosystem, forcing, land, helpers)
        return land
    end

    

    function compute(params::LandEcosystem, forcing, land, helpers)
        return land
    end

    