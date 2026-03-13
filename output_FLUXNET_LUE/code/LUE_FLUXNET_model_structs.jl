# Code for parameter structs of SINDBAD for LUE experiment applied to FLUXNET domain.
# Based on @code_expr from CodeTracking.jl. In case of conflicts, follow the original code in model approaches in src/Processes/[model]/[approach].jl

abstract type LandEcosystem end

# constants_numbers
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/constants/constants_numbers.jl
# Call order: 1

abstract type constants <: LandEcosystem end

struct constants_numbers <: constants end

# --------------------------------------

# ambientCO2_forcing
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/ambientCO2/ambientCO2_forcing.jl
# Call order: 2

abstract type ambientCO2 <: LandEcosystem end

struct ambientCO2_forcing <: ambientCO2 end

# --------------------------------------

# fAPAR_constant
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 3

abstract type fAPAR <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/fAPAR/fAPAR_constant.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/fAPAR/fAPAR_constant.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/fAPAR/fAPAR_constant.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/fAPAR/fAPAR_constant.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/fAPAR/fAPAR_constant.jl:4 =# @with_kw struct fAPAR_constant{T1} <: fAPAR
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/fAPAR/fAPAR_constant.jl:5 =#
                        constant_fAPAR::T1 = 0.2 | (0.0, 1.0) | "a constant fAPAR" | "" | ""
end

# --------------------------------------

# gppPotential_Monteith
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 4

abstract type gppPotential <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppPotential/gppPotential_Monteith.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppPotential/gppPotential_Monteith.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppPotential/gppPotential_Monteith.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppPotential/gppPotential_Monteith.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppPotential/gppPotential_Monteith.jl:4 =# @with_kw struct gppPotential_Monteith{T1} <: gppPotential
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppPotential/gppPotential_Monteith.jl:5 =#
                        εmax::T1 = 2.0 | (0.1, 5.0) | "Maximum Radiation Use Efficiency" | "gC/MJ" | ""
end

# --------------------------------------

# gppDiffRadiation_Wang2015
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 5

abstract type gppDiffRadiation <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDiffRadiation/gppDiffRadiation_Wang2015.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDiffRadiation/gppDiffRadiation_Wang2015.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDiffRadiation/gppDiffRadiation_Wang2015.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDiffRadiation/gppDiffRadiation_Wang2015.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDiffRadiation/gppDiffRadiation_Wang2015.jl:4 =# @with_kw struct gppDiffRadiation_Wang2015{T1} <: gppDiffRadiation
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDiffRadiation/gppDiffRadiation_Wang2015.jl:5 =#
                        μ::T1 = 0.46 | (0.0001, 1.0) | "" | "" | ""
end

# --------------------------------------

# gppDirRadiation_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDirRadiation/gppDirRadiation_none.jl
# Call order: 6

abstract type gppDirRadiation <: LandEcosystem end

struct gppDirRadiation_none <: gppDirRadiation end

# --------------------------------------

# gppAirT_CASA
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 7

abstract type gppAirT <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppAirT/gppAirT_CASA.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppAirT/gppAirT_CASA.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppAirT/gppAirT_CASA.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppAirT/gppAirT_CASA.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppAirT/gppAirT_CASA.jl:4 =# @with_kw struct gppAirT_CASA{T1, T, T3, T4} <: gppAirT
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppAirT/gppAirT_CASA.jl:5 =#
                        opt_airT::T1 = 25.0 | (5.0, 35.0) | "check in CASA code" | "°C" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppAirT/gppAirT_CASA.jl:6 =#
                        opt_airT_A::T = 0.2 | (0.01, 0.3) | "increasing slope of sensitivity" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppAirT/gppAirT_CASA.jl:7 =#
                        opt_airT_B::T3 = 0.3 | (0.01, 0.5) | "decreasing slope of sensitivity" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppAirT/gppAirT_CASA.jl:8 =#
                        exp_airT::T4 = 10.0 | (9.0, 11.0) | "reference for exponent of sensitivity" | "" | ""
end

# --------------------------------------

# gppVPD_PRELES
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 8

abstract type gppVPD <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppVPD/gppVPD_PRELES.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppVPD/gppVPD_PRELES.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppVPD/gppVPD_PRELES.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppVPD/gppVPD_PRELES.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppVPD/gppVPD_PRELES.jl:4 =# @with_kw struct gppVPD_PRELES{T1, T2, T3, T4} <: gppVPD
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppVPD/gppVPD_PRELES.jl:5 =#
                        κ::T1 = 0.4 | (0.06, 0.7) | "" | "kPa-1" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppVPD/gppVPD_PRELES.jl:6 =#
                        c_κ::T2 = 0.4 | (-50.0, 10.0) | "" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppVPD/gppVPD_PRELES.jl:7 =#
                        base_ambient_CO2::T3 = 295.0 | (250.0, 500.0) | "" | "ppm" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppVPD/gppVPD_PRELES.jl:8 =#
                        sat_ambient_CO2::T4 = 2000.0 | (400.0, 4000.0) | "" | "ppm" | ""
end

# --------------------------------------

# gppSoilW_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppSoilW/gppSoilW_none.jl
# Call order: 9

abstract type gppSoilW <: LandEcosystem end

struct gppSoilW_none <: gppSoilW end

# --------------------------------------

# gppDemand_mult
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDemand/gppDemand_mult.jl
# Call order: 10

abstract type gppDemand <: LandEcosystem end

struct gppDemand_mult <: gppDemand end

# --------------------------------------

# gpp_min
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gpp/gpp_min.jl
# Call order: 11

abstract type gpp <: LandEcosystem end

struct gpp_min <: gpp end

# --------------------------------------