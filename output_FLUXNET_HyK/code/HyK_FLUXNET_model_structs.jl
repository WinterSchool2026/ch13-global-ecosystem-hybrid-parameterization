# Code for parameter structs of SINDBAD for HyK experiment applied to FLUXNET domain.
# Based on @code_expr from CodeTracking.jl. In case of conflicts, follow the original code in model approaches in src/Processes/[model]/[approach].jl

abstract type LandEcosystem end

# constants_numbers
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/constants/constants_numbers.jl
# Call order: 1

abstract type constants <: LandEcosystem end

struct constants_numbers <: constants end

# --------------------------------------

# wCycleBase_simple
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/wCycleBase/wCycleBase_simple.jl
# Call order: 2

abstract type wCycleBase <: LandEcosystem end

struct wCycleBase_simple <: wCycleBase end

# --------------------------------------

# rainSnow_Tair
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 3

abstract type rainSnow <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rainSnow/rainSnow_Tair.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rainSnow/rainSnow_Tair.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rainSnow/rainSnow_Tair.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rainSnow/rainSnow_Tair.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rainSnow/rainSnow_Tair.jl:4 =# @with_kw struct rainSnow_Tair{T1} <: rainSnow
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rainSnow/rainSnow_Tair.jl:5 =#
                        airT_thres::T1 = 0.0 | (-5.0, 5.0) | "threshold for separating rain and snow" | "°C" | ""
end

# --------------------------------------

# PET_Lu2005
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 4

abstract type PET <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/PET/PET_Lu2005.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/PET/PET_Lu2005.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/PET/PET_Lu2005.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/PET/PET_Lu2005.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/PET/PET_Lu2005.jl:4 =# @with_kw struct PET_Lu2005{T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15} <: PET
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/PET/PET_Lu2005.jl:5 =#
                        α::T1 = 1.26 | (0.1, 2.0) | "calibration constant: α = 1.26 for wet or humid" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/PET/PET_Lu2005.jl:6 =#
                        svp_1::T2 = 0.2 | (-Inf, Inf) | "saturation vapor pressure temperature curve parameter 1" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/PET/PET_Lu2005.jl:7 =#
                        svp_2::T3 = 0.00738 | (-Inf, Inf) | "saturation vapor pressure temperature curve parameter 2" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/PET/PET_Lu2005.jl:8 =#
                        svp_3::T4 = 0.8072 | (-Inf, Inf) | "saturation vapor pressure temperature curve parameter 3" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/PET/PET_Lu2005.jl:9 =#
                        svp_4::T5 = 7.0 | (-Inf, Inf) | "saturation vapor pressure temperature curve parameter 4" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/PET/PET_Lu2005.jl:10 =#
                        svp_5::T6 = 0.000116 | (-Inf, Inf) | "saturation vapor pressure temperature curve parameter 5" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/PET/PET_Lu2005.jl:11 =#
                        sh_cp::T7 = 0.001013 | (-Inf, Inf) | "specific heat of moist air at constant pressure (1.013 kJ/kg/°C)" | "MJ/kg/°C" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/PET/PET_Lu2005.jl:12 =#
                        elev::T8 = 0.0 | (0.0, 8848.0) | "elevation" | "m" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/PET/PET_Lu2005.jl:13 =#
                        pres_sl::T9 = 101.29 | (0.0, 101.3) | "atmospheric pressure at sea level" | "kpa" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/PET/PET_Lu2005.jl:14 =#
                        pres_elev::T10 = 0.01055 | (-Inf, Inf) | "rate of change of atmospheric pressure with elevation" | "kpa/m" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/PET/PET_Lu2005.jl:15 =#
                        λ_base::T11 = 2.501 | (-Inf, Inf) | "latent heat of vaporization" | "MJ/kg" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/PET/PET_Lu2005.jl:16 =#
                        λ_airT::T12 = 0.002361 | (-Inf, Inf) | "rate of change of latent heat of vaporization with temperature" | "MJ/kg/°C" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/PET/PET_Lu2005.jl:17 =#
                        γ_resistance::T13 = 0.622 | (-Inf, Inf) | "ratio of canopy resistance to atmospheric resistance" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/PET/PET_Lu2005.jl:18 =#
                        Δt::T14 = 2.0 | (-Inf, Inf) | "time delta for calculation of G" | "day" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/PET/PET_Lu2005.jl:19 =#
                        G_base::T15 = 4.2 | (-Inf, Inf) | "base groundheat flux" | "" | ""
end

# --------------------------------------

# ambientCO2_forcing
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/ambientCO2/ambientCO2_forcing.jl
# Call order: 5

abstract type ambientCO2 <: LandEcosystem end

struct ambientCO2_forcing <: ambientCO2 end

# --------------------------------------

# getPools_simple
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/getPools/getPools_simple.jl
# Call order: 6

abstract type getPools <: LandEcosystem end

struct getPools_simple <: getPools end

# --------------------------------------

# soilTexture_forcing
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilTexture/soilTexture_forcing.jl
# Call order: 7

abstract type soilTexture <: LandEcosystem end

struct soilTexture_forcing <: soilTexture end

# --------------------------------------

# soilProperties_Saxton2006
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 8

abstract type soilProperties <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:6 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:6 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:6 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:6 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:6 =# @with_kw struct soilProperties_Saxton2006{T1, T2, T3, T4, T5, TN} <: soilProperties
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:7 =#
                        DF::T1 = 1.0 | (0.9, 1.3) | "Density correction factor" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:8 =#
                        Rw::T2 = 0.0 | (0.0, 1.0) | "Weight fraction of gravel (decimal)" | "g g-1" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:9 =#
                        matric_soil_density::T3 = 2.65 | (2.5, 3.0) | "Matric soil density" | "g cm-3" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:10 =#
                        gravel_density::T4 = 2.65 | (2.5, 3.0) | "density of gravel material" | "g cm-3" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:11 =#
                        EC::T5 = 36.0 | (30.0, 40.0) | "SElectrical conductance of a saturated soil extract" | "dS m-1 (dS/m = mili-mho cm-1)" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:12 =#
                        a1::TN = -0.024 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:13 =#
                        a2::TN = 0.487 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:14 =#
                        a3::TN = 0.006 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:15 =#
                        a4::TN = 0.005 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:16 =#
                        a5::TN = 0.013 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:17 =#
                        a6::TN = 0.068 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:18 =#
                        a7::TN = 0.031 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:19 =#
                        b1::TN = 0.14 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:20 =#
                        b2::TN = 0.02 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:21 =#
                        c1::TN = -0.251 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:22 =#
                        c2::TN = 0.195 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:23 =#
                        c3::TN = 0.011 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:24 =#
                        c4::TN = 0.006 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:25 =#
                        c5::TN = 0.027 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:26 =#
                        c6::TN = 0.452 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:27 =#
                        c7::TN = 0.299 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:28 =#
                        d1::TN = 1.283 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:29 =#
                        d2::TN = 0.374 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:30 =#
                        d3::TN = 0.015 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:31 =#
                        e1::TN = 0.278 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:32 =#
                        e2::TN = 0.034 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:33 =#
                        e3::TN = 0.022 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:34 =#
                        e4::TN = 0.018 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:35 =#
                        e5::TN = 0.027 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:36 =#
                        e6::TN = 0.584 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:37 =#
                        e7::TN = 0.078 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:38 =#
                        f1::TN = 0.636 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:39 =#
                        f2::TN = 0.107 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:40 =#
                        g1::TN = -21.67 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:41 =#
                        g2::TN = 27.93 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:42 =#
                        g3::TN = 81.97 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:43 =#
                        g4::TN = 71.12 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:44 =#
                        g5::TN = 8.29 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:45 =#
                        g6::TN = 14.05 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:46 =#
                        g7::TN = 27.16 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:47 =#
                        h1::TN = 0.02 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:48 =#
                        h2::TN = 0.113 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:49 =#
                        h3::TN = 0.7 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:50 =#
                        i1::TN = 0.097 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:51 =#
                        i2::TN = 0.043 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:52 =#
                        n02::TN = 0.2 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:53 =#
                        n24::TN = 24.0 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:54 =#
                        n33::TN = 33.0 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:55 =#
                        n36::TN = 36.0 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:56 =#
                        n1500::TN = 1500.0 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilProperties/soilProperties_Saxton2006.jl:57 =#
                        n1930::TN = 1930.0 | (-Inf, Inf) | "Saxton Parameters" | "" | ""
end

# --------------------------------------

# soilWBase_uniform
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilWBase/soilWBase_uniform.jl
# Call order: 9

abstract type soilWBase <: LandEcosystem end

struct soilWBase_uniform <: soilWBase end

# --------------------------------------

# rootMaximumDepth_fracSoilD
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 10

abstract type rootMaximumDepth <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rootMaximumDepth/rootMaximumDepth_fracSoilD.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rootMaximumDepth/rootMaximumDepth_fracSoilD.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rootMaximumDepth/rootMaximumDepth_fracSoilD.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rootMaximumDepth/rootMaximumDepth_fracSoilD.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rootMaximumDepth/rootMaximumDepth_fracSoilD.jl:4 =# @with_kw struct rootMaximumDepth_fracSoilD{T1} <: rootMaximumDepth
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rootMaximumDepth/rootMaximumDepth_fracSoilD.jl:5 =#
                        constant_frac_max_root_depth::T1 = 0.5 | (0.1, 0.8) | "root depth as a fraction of soil depth" | "" | ""
end

# --------------------------------------

# rootWaterEfficiency_expCvegRoot
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 11

abstract type rootWaterEfficiency <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rootWaterEfficiency/rootWaterEfficiency_expCvegRoot.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rootWaterEfficiency/rootWaterEfficiency_expCvegRoot.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rootWaterEfficiency/rootWaterEfficiency_expCvegRoot.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rootWaterEfficiency/rootWaterEfficiency_expCvegRoot.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rootWaterEfficiency/rootWaterEfficiency_expCvegRoot.jl:4 =# @with_kw struct rootWaterEfficiency_expCvegRoot{T1, T2, T3} <: rootWaterEfficiency
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rootWaterEfficiency/rootWaterEfficiency_expCvegRoot.jl:5 =#
                        k_efficiency_cVegRoot::T1 = 0.02 | (0.001, 0.3) | "rate constant of exponential relationship" | "m2/gC" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rootWaterEfficiency/rootWaterEfficiency_expCvegRoot.jl:6 =#
                        max_root_water_efficiency::T2 = 0.95 | (0.7, 0.98) | "maximum root water uptake capacity" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rootWaterEfficiency/rootWaterEfficiency_expCvegRoot.jl:7 =#
                        min_root_water_efficiency::T3 = 0.1 | (0.05, 0.3) | "minimum root water uptake threshold" | "" | ""
end

# --------------------------------------

# plantForm_PFT
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/plantForm/plantForm_PFT.jl
# Call order: 12

abstract type plantForm <: LandEcosystem end

struct plantForm_PFT <: plantForm end

# --------------------------------------

# treeFraction_forcing
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/treeFraction/treeFraction_forcing.jl
# Call order: 13

abstract type treeFraction <: LandEcosystem end

struct treeFraction_forcing <: treeFraction end

# --------------------------------------

# vegFraction_forcing
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/vegFraction/vegFraction_forcing.jl
# Call order: 14

abstract type vegFraction <: LandEcosystem end

struct vegFraction_forcing <: vegFraction end

# --------------------------------------

# fAPAR_cVegLeafBareFrac
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 15

abstract type fAPAR <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/fAPAR/fAPAR_cVegLeafBareFrac.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/fAPAR/fAPAR_cVegLeafBareFrac.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/fAPAR/fAPAR_cVegLeafBareFrac.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/fAPAR/fAPAR_cVegLeafBareFrac.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/fAPAR/fAPAR_cVegLeafBareFrac.jl:4 =# @with_kw struct fAPAR_cVegLeafBareFrac{T1} <: fAPAR
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/fAPAR/fAPAR_cVegLeafBareFrac.jl:5 =#
                        k_extinction::T1 = 0.005 | (0.0005, 0.05) | "effective light extinction coefficient" | "" | ""
end

# --------------------------------------

# LAI_cVegLeaf
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 16

abstract type LAI <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/LAI/LAI_cVegLeaf.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/LAI/LAI_cVegLeaf.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/LAI/LAI_cVegLeaf.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/LAI/LAI_cVegLeaf.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/LAI/LAI_cVegLeaf.jl:4 =# @with_kw struct LAI_cVegLeaf{T1} <: LAI
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/LAI/LAI_cVegLeaf.jl:5 =#
                        SLA::T1 = 0.016 | (0.01, 0.024) | "specific leaf area" | "m^2.gC^-1" | ""
end

# --------------------------------------

# snowFraction_HTESSEL
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 17

abstract type snowFraction <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/snowFraction/snowFraction_HTESSEL.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/snowFraction/snowFraction_HTESSEL.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/snowFraction/snowFraction_HTESSEL.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/snowFraction/snowFraction_HTESSEL.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/snowFraction/snowFraction_HTESSEL.jl:4 =# @with_kw struct snowFraction_HTESSEL{T1} <: snowFraction
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/snowFraction/snowFraction_HTESSEL.jl:5 =#
                        snow_cover_param::T1 = 15.0 | (1.0, 100.0) | "Snow Cover Parameter" | "mm" | ""
end

# --------------------------------------

# snowMelt_TairRn
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 18

abstract type snowMelt <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/snowMelt/snowMelt_TairRn.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/snowMelt/snowMelt_TairRn.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/snowMelt/snowMelt_TairRn.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/snowMelt/snowMelt_TairRn.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/snowMelt/snowMelt_TairRn.jl:4 =# @with_kw struct snowMelt_TairRn{T1, T2} <: snowMelt
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/snowMelt/snowMelt_TairRn.jl:5 =#
                        melt_T::T1 = 3.0 | (0.01, 10.0) | "melt factor for temperature" | "mm/°C" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/snowMelt/snowMelt_TairRn.jl:6 =#
                        melt_Rn::T2 = 2.0 | (0.01, 3.0) | "melt factor for radiation" | "mm/MJ/m2" | ""
end

# --------------------------------------

# runoffSaturationExcess_Bergstroem1992
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 19

abstract type runoffSaturationExcess <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/runoffSaturationExcess/runoffSaturationExcess_Bergstroem1992.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/runoffSaturationExcess/runoffSaturationExcess_Bergstroem1992.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/runoffSaturationExcess/runoffSaturationExcess_Bergstroem1992.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/runoffSaturationExcess/runoffSaturationExcess_Bergstroem1992.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/runoffSaturationExcess/runoffSaturationExcess_Bergstroem1992.jl:4 =# @with_kw struct runoffSaturationExcess_Bergstroem1992{T1} <: runoffSaturationExcess
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/runoffSaturationExcess/runoffSaturationExcess_Bergstroem1992.jl:5 =#
                        β::T1 = 1.1 | (0.1, 5.0) | "berg exponential parameter" | "" | ""
end

# --------------------------------------

# runoffOverland_Sat
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/runoffOverland/runoffOverland_Sat.jl
# Call order: 20

abstract type runoffOverland <: LandEcosystem end

struct runoffOverland_Sat <: runoffOverland end

# --------------------------------------

# runoffSurface_all
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/runoffSurface/runoffSurface_all.jl
# Call order: 21

abstract type runoffSurface <: LandEcosystem end

struct runoffSurface_all <: runoffSurface end

# --------------------------------------

# runoffBase_Zhang2008
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 22

abstract type runoffBase <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/runoffBase/runoffBase_Zhang2008.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/runoffBase/runoffBase_Zhang2008.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/runoffBase/runoffBase_Zhang2008.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/runoffBase/runoffBase_Zhang2008.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/runoffBase/runoffBase_Zhang2008.jl:4 =# @with_kw struct runoffBase_Zhang2008{T1} <: runoffBase
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/runoffBase/runoffBase_Zhang2008.jl:5 =#
                        k_baseflow::T1 = 0.001 | (1.0e-5, 0.02) | "base flow coefficient" | "day-1" | "day"
end

# --------------------------------------

# percolation_WBP
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/percolation/percolation_WBP.jl
# Call order: 23

abstract type percolation <: LandEcosystem end

struct percolation_WBP <: percolation end

# --------------------------------------

# evaporation_fAPAR
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 24

abstract type evaporation <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/evaporation/evaporation_fAPAR.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/evaporation/evaporation_fAPAR.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/evaporation/evaporation_fAPAR.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/evaporation/evaporation_fAPAR.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/evaporation/evaporation_fAPAR.jl:4 =# @with_kw struct evaporation_fAPAR{T1, T2} <: evaporation
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/evaporation/evaporation_fAPAR.jl:5 =#
                        α::T1 = 1.0 | (0.1, 3.0) | "α coefficient of Priestley-Taylor formula for soil" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/evaporation/evaporation_fAPAR.jl:6 =#
                        k_evaporation::T2 = 0.2 | (0.05, 0.95) | "fraction of soil water that can be used for soil evaporation" | "day-1" | "day"
end

# --------------------------------------

# drainage_dos
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 25

abstract type drainage <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/drainage/drainage_dos.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/drainage/drainage_dos.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/drainage/drainage_dos.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/drainage/drainage_dos.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/drainage/drainage_dos.jl:4 =# @with_kw struct drainage_dos{T1} <: drainage
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/drainage/drainage_dos.jl:5 =#
                        dos_exp::T1 = 1.5 | (0.1, 3.0) | "exponent of non-linearity for dos influence on drainage in soil" | "" | ""
end

# --------------------------------------

# capillaryFlow_VanDijk2010
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 26

abstract type capillaryFlow <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/capillaryFlow/capillaryFlow_VanDijk2010.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/capillaryFlow/capillaryFlow_VanDijk2010.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/capillaryFlow/capillaryFlow_VanDijk2010.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/capillaryFlow/capillaryFlow_VanDijk2010.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/capillaryFlow/capillaryFlow_VanDijk2010.jl:4 =# @with_kw struct capillaryFlow_VanDijk2010{T1} <: capillaryFlow
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/capillaryFlow/capillaryFlow_VanDijk2010.jl:5 =#
                        max_frac::T1 = 0.95 | (0.02, 0.98) | "max fraction of soil moisture that can be lost as capillary flux" | "" | ""
end

# --------------------------------------

# groundWRecharge_dos
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 27

abstract type groundWRecharge <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/groundWRecharge/groundWRecharge_dos.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/groundWRecharge/groundWRecharge_dos.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/groundWRecharge/groundWRecharge_dos.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/groundWRecharge/groundWRecharge_dos.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/groundWRecharge/groundWRecharge_dos.jl:4 =# @with_kw struct groundWRecharge_dos{T1} <: groundWRecharge
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/groundWRecharge/groundWRecharge_dos.jl:5 =#
                        dos_exp::T1 = 1.5 | (1.0, 3.0) | "exponent of non-linearity for dos influence on drainage to groundwater" | "" | ""
end

# --------------------------------------

# groundWSoilWInteraction_VanDijk2010
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 28

abstract type groundWSoilWInteraction <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/groundWSoilWInteraction/groundWSoilWInteraction_VanDijk2010.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/groundWSoilWInteraction/groundWSoilWInteraction_VanDijk2010.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/groundWSoilWInteraction/groundWSoilWInteraction_VanDijk2010.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/groundWSoilWInteraction/groundWSoilWInteraction_VanDijk2010.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/groundWSoilWInteraction/groundWSoilWInteraction_VanDijk2010.jl:4 =# @with_kw struct groundWSoilWInteraction_VanDijk2010{T1} <: groundWSoilWInteraction
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/groundWSoilWInteraction/groundWSoilWInteraction_VanDijk2010.jl:5 =#
                        max_fraction::T1 = 0.5 | (0.001, 0.98) | "fraction of groundwater that can be lost to capillary flux" | "" | ""
end

# --------------------------------------

# vegAvailableWater_rootWaterEfficiency
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/vegAvailableWater/vegAvailableWater_rootWaterEfficiency.jl
# Call order: 29

abstract type vegAvailableWater <: LandEcosystem end

struct vegAvailableWater_rootWaterEfficiency <: vegAvailableWater end

# --------------------------------------

# transpirationSupply_wAWC
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 30

abstract type transpirationSupply <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/transpirationSupply/transpirationSupply_wAWC.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/transpirationSupply/transpirationSupply_wAWC.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/transpirationSupply/transpirationSupply_wAWC.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/transpirationSupply/transpirationSupply_wAWC.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/transpirationSupply/transpirationSupply_wAWC.jl:4 =# @with_kw struct transpirationSupply_wAWC{T1} <: transpirationSupply
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/transpirationSupply/transpirationSupply_wAWC.jl:5 =#
                        k_transpiration::T1 = 0.99 | (0.002, 1.0) | "fraction of total maximum available water that can be transpired" | "" | ""
end

# --------------------------------------

# gppPotential_Monteith
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 31

abstract type gppPotential <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppPotential/gppPotential_Monteith.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppPotential/gppPotential_Monteith.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppPotential/gppPotential_Monteith.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppPotential/gppPotential_Monteith.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppPotential/gppPotential_Monteith.jl:4 =# @with_kw struct gppPotential_Monteith{T1} <: gppPotential
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppPotential/gppPotential_Monteith.jl:5 =#
                        εmax::T1 = 2.0 | (0.1, 5.0) | "Maximum Radiation Use Efficiency" | "gC/MJ" | ""
end

# --------------------------------------

# gppDiffRadiation_Wang2015
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 32

abstract type gppDiffRadiation <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDiffRadiation/gppDiffRadiation_Wang2015.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDiffRadiation/gppDiffRadiation_Wang2015.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDiffRadiation/gppDiffRadiation_Wang2015.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDiffRadiation/gppDiffRadiation_Wang2015.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDiffRadiation/gppDiffRadiation_Wang2015.jl:4 =# @with_kw struct gppDiffRadiation_Wang2015{T1} <: gppDiffRadiation
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDiffRadiation/gppDiffRadiation_Wang2015.jl:5 =#
                        μ::T1 = 0.46 | (0.0001, 1.0) | "" | "" | ""
end

# --------------------------------------

# gppDirRadiation_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDirRadiation/gppDirRadiation_none.jl
# Call order: 33

abstract type gppDirRadiation <: LandEcosystem end

struct gppDirRadiation_none <: gppDirRadiation end

# --------------------------------------

# gppAirT_CASA
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 34

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
# Call order: 35

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

# gppSoilW_Stocker2020
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 36

abstract type gppSoilW <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppSoilW/gppSoilW_Stocker2020.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppSoilW/gppSoilW_Stocker2020.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppSoilW/gppSoilW_Stocker2020.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppSoilW/gppSoilW_Stocker2020.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppSoilW/gppSoilW_Stocker2020.jl:4 =# @with_kw struct gppSoilW_Stocker2020{T1, T2} <: gppSoilW
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppSoilW/gppSoilW_Stocker2020.jl:5 =#
                        q::T1 = 1.0 | (0.01, 4.0) | "sensitivity of GPP to soil moisture " | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppSoilW/gppSoilW_Stocker2020.jl:6 =#
                        θstar::T2 = 0.6 | (0.1, 1.0) | "" | "" | ""
end

# --------------------------------------

# gppDemand_mult
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDemand/gppDemand_mult.jl
# Call order: 37

abstract type gppDemand <: LandEcosystem end

struct gppDemand_mult <: gppDemand end

# --------------------------------------

# WUE_expVPDDayCo2
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 38

abstract type WUE <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/WUE/WUE_expVPDDayCo2.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/WUE/WUE_expVPDDayCo2.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/WUE/WUE_expVPDDayCo2.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/WUE/WUE_expVPDDayCo2.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/WUE/WUE_expVPDDayCo2.jl:4 =# @with_kw struct WUE_expVPDDayCo2{T1, T2, T3, T4, T5} <: WUE
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/WUE/WUE_expVPDDayCo2.jl:5 =#
                        WUE_one_hpa::T1 = 9.2 | (2.0, 20.0) | "WUE at 1 hpa VPD" | "gC/mmH2O" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/WUE/WUE_expVPDDayCo2.jl:6 =#
                        κ::T2 = 0.4 | (0.06, 0.7) | "" | "kPa-1" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/WUE/WUE_expVPDDayCo2.jl:7 =#
                        base_ambient_CO2::T3 = 380.0 | (300.0, 500.0) | "" | "ppm" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/WUE/WUE_expVPDDayCo2.jl:8 =#
                        sat_ambient_CO2::T4 = 500.0 | (10.0, 2000.0) | "" | "ppm" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/WUE/WUE_expVPDDayCo2.jl:9 =#
                        kpa_to_hpa::T5 = 10.0 | (-Inf, Inf) | "unit conversion kPa to hPa" | "" | ""
end

# --------------------------------------

# gpp_coupled
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gpp/gpp_coupled.jl
# Call order: 39

abstract type gpp <: LandEcosystem end

struct gpp_coupled <: gpp end

# --------------------------------------

# transpiration_coupled
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/transpiration/transpiration_coupled.jl
# Call order: 40

abstract type transpiration <: LandEcosystem end

struct transpiration_coupled <: transpiration end

# --------------------------------------

# rootWaterUptake_proportion
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rootWaterUptake/rootWaterUptake_proportion.jl
# Call order: 41

abstract type rootWaterUptake <: LandEcosystem end

struct rootWaterUptake_proportion <: rootWaterUptake end

# --------------------------------------

# cVegetationDieOff_forcing
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cVegetationDieOff/cVegetationDieOff_forcing.jl
# Call order: 42

abstract type cVegetationDieOff <: LandEcosystem end

struct cVegetationDieOff_forcing <: cVegetationDieOff end

# --------------------------------------

# cCycleBase_GSI_PlantForm_LargeKReserve
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 43

abstract type cCycleBase <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:3 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:3 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:3 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:3 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:3 =# @with_kw struct cCycleBase_GSI_PlantForm_LargeKReserve{T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18} <: cCycleBase
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:23 =#
                        c_τ_Root_scalar::T1 = 1.0 | (0.25, 4) | "scalar for turnover rate of root carbon pool" | "-" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:24 =#
                        c_τ_Wood_scalar::T2 = 1.0 | (0.25, 4) | "scalar for turnover rate of wood carbon pool" | "-" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:25 =#
                        c_τ_Leaf_scalar::T3 = 1.0 | (0.25, 4) | "scalar for turnover rate of leaf carbon pool" | "-" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:26 =#
                        c_τ_Litter_scalar::T4 = 1.0 | (0.25, 4) | "scalar for turnover rate of litter carbon pool" | "-" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:27 =#
                        c_τ_Reserve_scalar::T5 = 1.0 | (0.25, 4) | "scalar for Reserve does not respire, but has a small value to avoid numerical error" | "-" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:28 =#
                        c_τ_Soil_scalar::T6 = 1.0 | (0.25, 4) | "scalar for turnover rate of soil carbon pool" | "-" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:30 =#
                        c_τ_tree::T7 = Float64.(1.0 ./ [1.0, 50.0, 1.0, 1000.0]) | (1 ./ [4.0, 200.0, 4.0, 4000.0], 1 ./ [0.25, 12.5, 0.25, 250.0]) | "turnover of different organs of trees" | "year-1" | "year"
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:31 =#
                        c_τ_shrub::T8 = Float64.(1.0 ./ [1.0, 5.0, 1.0, 1000.0]) | (1 ./ [4.0, 20.0, 4.0, 4000.0], 1 ./ [0.25, 1.25, 0.25, 250.0]) | "turnover of different organs of shrubs" | "year-1" | "year"
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:32 =#
                        c_τ_herb::T9 = Float64.(1.0 ./ [0.75, 0.75, 0.75, 750.0]) | (1 ./ [3.0, 3.0, 3.0, 3000.0], 1 ./ [0.1875, 0.1875, 0.1875, 187.5]) | "turnover of different organs of herbs" | "year-1" | "year"
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:34 =#
                        c_τ_LitFast::T10 = 14.8 | (0.5, 148.0) | "turnover rate of fast litter (leaf litter) carbon pool" | "year-1" | "year"
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:35 =#
                        c_τ_LitSlow::T11 = 3.9 | (0.39, 39.0) | "turnover rate of slow litter carbon (wood litter) pool" | "year-1" | "year"
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:36 =#
                        c_τ_SoilSlow::T12 = 0.2 | (0.02, 2.0) | "turnover rate of slow soil carbon pool" | "year-1" | "year"
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:37 =#
                        c_τ_SoilOld::T13 = 0.0045 | (0.00045, 0.045) | "turnover rate of old soil carbon pool" | "year-1" | "year"
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:38 =#
                        c_flow_A_array::T14 = Float64.([-1.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0; 0.0 -1.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 -1.0 1.0 0.0 0.0 0.0 0.0; 1.0 0.0 1.0 -1.0 0.0 0.0 0.0 0.0; 1.0 0.0 1.0 0.0 -1.0 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 -1.0 0.0 0.0; 0.0 0.0 0.0 0.0 1.0 1.0 -1.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 1.0 -1.0]) | (-Inf, Inf) | "Transfer matrix for carbon at ecosystem level" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:48 =#
                        p_C_to_N_cVeg::T15 = Float64.([25.0, 260.0, 260.0, 10.0]) | (-Inf, Inf) | "carbon to nitrogen ratio in vegetation pools" | "gC/gN" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:49 =#
                        ηH::T16 = 1.0 | (0.125, 8.0) | "scaling factor for heterotrophic pools after spinup" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:50 =#
                        ηA::T17 = 1.0 | (0.25, 4.0) | "scaling factor for vegetation pools after spinup" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleBase/cCycleBase_GSI_PlantForm_LargeKReserve.jl:51 =#
                        c_remain::T18 = 50.0 | (0.1, 100.0) | "remaining carbon after disturbance" | "gC/m2" | ""
end

# --------------------------------------

# cCycleDisturbance_WROASTED
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleDisturbance/cCycleDisturbance_WROASTED.jl
# Call order: 44

abstract type cCycleDisturbance <: LandEcosystem end

struct cCycleDisturbance_WROASTED <: cCycleDisturbance end

# --------------------------------------

# cTauSoilT_Q10
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 45

abstract type cTauSoilT <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauSoilT/cTauSoilT_Q10.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauSoilT/cTauSoilT_Q10.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauSoilT/cTauSoilT_Q10.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauSoilT/cTauSoilT_Q10.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauSoilT/cTauSoilT_Q10.jl:4 =# @with_kw struct cTauSoilT_Q10{T1, T2, T3} <: cTauSoilT
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauSoilT/cTauSoilT_Q10.jl:5 =#
                        Q10::T1 = 1.4 | (1.05, 3.0) | "" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauSoilT/cTauSoilT_Q10.jl:6 =#
                        ref_airT::T2 = 30.0 | (0.01, 40.0) | "" | "°C" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauSoilT/cTauSoilT_Q10.jl:7 =#
                        Q10_base::T3 = 10.0 | (-Inf, Inf) | "base temperature difference" | "°C" | ""
end

# --------------------------------------

# cTauSoilW_GSI
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 46

abstract type cTauSoilW <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauSoilW/cTauSoilW_GSI.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauSoilW/cTauSoilW_GSI.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauSoilW/cTauSoilW_GSI.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauSoilW/cTauSoilW_GSI.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauSoilW/cTauSoilW_GSI.jl:4 =# @with_kw struct cTauSoilW_GSI{T1, T2, T3, T4, T5} <: cTauSoilW
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauSoilW/cTauSoilW_GSI.jl:5 =#
                        opt_soilW::T1 = 90.0 | (60.0, 95.0) | "Optimal moisture for decomposition" | "percent degree of saturation" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauSoilW/cTauSoilW_GSI.jl:6 =#
                        opt_soilW_A::T2 = 0.2 | (0.1, 0.3) | "slope of increase" | "per percent" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauSoilW/cTauSoilW_GSI.jl:7 =#
                        opt_soilW_B::T3 = 0.3 | (0.15, 0.5) | "slope of decrease" | "per percent" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauSoilW/cTauSoilW_GSI.jl:8 =#
                        w_exp::T4 = 10.0 | (-Inf, Inf) | "reference for exponent of sensitivity" | "per percent" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauSoilW/cTauSoilW_GSI.jl:9 =#
                        frac_to_perc::T5 = 100.0 | (-Inf, Inf) | "unit converter for fraction to percent" | "" | ""
end

# --------------------------------------

# cTauLAI_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauLAI/cTauLAI_none.jl
# Call order: 47

abstract type cTauLAI <: LandEcosystem end

struct cTauLAI_none <: cTauLAI end

# --------------------------------------

# cTauSoilProperties_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauSoilProperties/cTauSoilProperties_none.jl
# Call order: 48

abstract type cTauSoilProperties <: LandEcosystem end

struct cTauSoilProperties_none <: cTauSoilProperties end

# --------------------------------------

# cTauVegProperties_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauVegProperties/cTauVegProperties_none.jl
# Call order: 49

abstract type cTauVegProperties <: LandEcosystem end

struct cTauVegProperties_none <: cTauVegProperties end

# --------------------------------------

# cTau_mult
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTau/cTau_mult.jl
# Call order: 50

abstract type cTau <: LandEcosystem end

struct cTau_mult <: cTau end

# --------------------------------------

# autoRespirationAirT_Q10
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 51

abstract type autoRespirationAirT <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/autoRespirationAirT/autoRespirationAirT_Q10.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/autoRespirationAirT/autoRespirationAirT_Q10.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/autoRespirationAirT/autoRespirationAirT_Q10.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/autoRespirationAirT/autoRespirationAirT_Q10.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/autoRespirationAirT/autoRespirationAirT_Q10.jl:4 =# @with_kw struct autoRespirationAirT_Q10{T1, T2, T3} <: autoRespirationAirT
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/autoRespirationAirT/autoRespirationAirT_Q10.jl:5 =#
                        Q10::T1 = 2.0 | (1.05, 3.0) | "Q10 parameter for maintenance respiration" | "" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/autoRespirationAirT/autoRespirationAirT_Q10.jl:6 =#
                        ref_airT::T2 = 20.0 | (0.0, 40.0) | "Reference temperature for the maintenance respiration" | "°C" | ""
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/autoRespirationAirT/autoRespirationAirT_Q10.jl:7 =#
                        Q10_base::T3 = 10.0 | (-Inf, Inf) | "base temperature difference" | "°C" | ""
end

# --------------------------------------

# cAllocationLAI_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocationLAI/cAllocationLAI_none.jl
# Call order: 52

abstract type cAllocationLAI <: LandEcosystem end

struct cAllocationLAI_none <: cAllocationLAI end

# --------------------------------------

# cAllocationRadiation_RgPot
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocationRadiation/cAllocationRadiation_RgPot.jl
# Call order: 53

abstract type cAllocationRadiation <: LandEcosystem end

struct cAllocationRadiation_RgPot <: cAllocationRadiation end

# --------------------------------------

# cAllocationSoilW_gpp
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocationSoilW/cAllocationSoilW_gpp.jl
# Call order: 54

abstract type cAllocationSoilW <: LandEcosystem end

struct cAllocationSoilW_gpp <: cAllocationSoilW end

# --------------------------------------

# cAllocationSoilT_gpp
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocationSoilT/cAllocationSoilT_gpp.jl
# Call order: 55

abstract type cAllocationSoilT <: LandEcosystem end

struct cAllocationSoilT_gpp <: cAllocationSoilT end

# --------------------------------------

# cAllocationNutrients_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocationNutrients/cAllocationNutrients_none.jl
# Call order: 56

abstract type cAllocationNutrients <: LandEcosystem end

struct cAllocationNutrients_none <: cAllocationNutrients end

# --------------------------------------

# cAllocation_GSI
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocation/cAllocation_GSI.jl
# Call order: 57

abstract type cAllocation <: LandEcosystem end

struct cAllocation_GSI <: cAllocation end

# --------------------------------------

# cAllocationTreeFraction_Friedlingstein1999
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 58

abstract type cAllocationTreeFraction <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocationTreeFraction/cAllocationTreeFraction_Friedlingstein1999.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocationTreeFraction/cAllocationTreeFraction_Friedlingstein1999.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocationTreeFraction/cAllocationTreeFraction_Friedlingstein1999.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocationTreeFraction/cAllocationTreeFraction_Friedlingstein1999.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocationTreeFraction/cAllocationTreeFraction_Friedlingstein1999.jl:4 =# @with_kw struct cAllocationTreeFraction_Friedlingstein1999{T1} <: cAllocationTreeFraction
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocationTreeFraction/cAllocationTreeFraction_Friedlingstein1999.jl:5 =#
                        frac_fine_to_coarse::T1 = 1.0 | (0.0, 1.0) | "carbon fraction allocated to fine roots" | "fraction" | ""
end

# --------------------------------------

# autoRespiration_Thornley2000A
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 59

abstract type autoRespiration <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/autoRespiration/autoRespiration_Thornley2000A.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/autoRespiration/autoRespiration_Thornley2000A.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/autoRespiration/autoRespiration_Thornley2000A.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/autoRespiration/autoRespiration_Thornley2000A.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/autoRespiration/autoRespiration_Thornley2000A.jl:4 =# @with_kw struct autoRespiration_Thornley2000A{T1, T2} <: autoRespiration
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/autoRespiration/autoRespiration_Thornley2000A.jl:5 =#
                        RMN::T1 = 0.009085714285714286 | (0.0009085714285714285, 0.09085714285714286) | "Nitrogen efficiency rate of maintenance respiration" | "gC/gN/day" | "day"
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/autoRespiration/autoRespiration_Thornley2000A.jl:6 =#
                        YG::T2 = 0.75 | (0.0, 1.0) | "growth yield coefficient, or growth efficiency. Loosely: (1-YG)*GPP is growth respiration" | "gC/gC" | ""
end

# --------------------------------------

# cFlowSoilProperties_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cFlowSoilProperties/cFlowSoilProperties_none.jl
# Call order: 60

abstract type cFlowSoilProperties <: LandEcosystem end

struct cFlowSoilProperties_none <: cFlowSoilProperties end

# --------------------------------------

# cFlowVegProperties_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cFlowVegProperties/cFlowVegProperties_none.jl
# Call order: 61

abstract type cFlowVegProperties <: LandEcosystem end

struct cFlowVegProperties_none <: cFlowVegProperties end

# --------------------------------------

# cFlow_GSI
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 62

abstract type cFlow <: LandEcosystem end

#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cFlow/cFlow_GSI.jl:4 =#@bounds#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cFlow/cFlow_GSI.jl:4 =# @describe#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cFlow/cFlow_GSI.jl:4 =# @units#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cFlow/cFlow_GSI.jl:4 =# @timescale#= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cFlow/cFlow_GSI.jl:4 =# @with_kw struct cFlow_GSI{T1, T2, T3, T4} <: cFlow
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cFlow/cFlow_GSI.jl:5 =#
                        slope_leaf_root_to_reserve::T1 = 0.14 | (0.033, 0.33) | "Leaf-Root to Reserve" | "fraction" | "day"
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cFlow/cFlow_GSI.jl:6 =#
                        slope_reserve_to_leaf_root::T2 = 0.14 | (0.033, 0.33) | "Reserve to Leaf-Root" | "fraction" | "day"
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cFlow/cFlow_GSI.jl:7 =#
                        k_shedding::T3 = 0.14 | (0.033, 0.33) | "rate of shedding" | "fraction" | "day"
                        #= /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cFlow/cFlow_GSI.jl:8 =#
                        f_τ::T4 = 0.03 | (0.01, 0.1) | "contribution factor for current stressor" | "fraction" | "day"
end

# --------------------------------------

# cCycleConsistency_simple
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleConsistency/cCycleConsistency_simple.jl
# Call order: 63

abstract type cCycleConsistency <: LandEcosystem end

struct cCycleConsistency_simple <: cCycleConsistency end

# --------------------------------------

# cCycle_GSI
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycle/cCycle_GSI.jl
# Call order: 64

abstract type cCycle <: LandEcosystem end

struct cCycle_GSI <: cCycle end

# --------------------------------------

# evapotranspiration_sum
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/evapotranspiration/evapotranspiration_sum.jl
# Call order: 65

abstract type evapotranspiration <: LandEcosystem end

struct evapotranspiration_sum <: evapotranspiration end

# --------------------------------------

# runoff_sum
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/runoff/runoff_sum.jl
# Call order: 66

abstract type runoff <: LandEcosystem end

struct runoff_sum <: runoff end

# --------------------------------------

# wCycle_components
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/wCycle/wCycle_components.jl
# Call order: 67

abstract type wCycle <: LandEcosystem end

struct wCycle_components <: wCycle end

# --------------------------------------

# waterBalance_simple
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/waterBalance/waterBalance_simple.jl
# Call order: 68

abstract type waterBalance <: LandEcosystem end

struct waterBalance_simple <: waterBalance end

# --------------------------------------

# cBiomass_treeGrass_cVegReserveScaling
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cBiomass/cBiomass_treeGrass_cVegReserveScaling.jl
# Call order: 69

abstract type cBiomass <: LandEcosystem end

struct cBiomass_treeGrass_cVegReserveScaling <: cBiomass end

# --------------------------------------