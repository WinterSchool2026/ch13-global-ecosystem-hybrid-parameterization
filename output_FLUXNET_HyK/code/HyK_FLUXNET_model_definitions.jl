# Code for define functions (variable definition) in models of SINDBAD for HyK experiment applied to FLUXNET domain.
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

# wCycleBase_simple
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/wCycleBase/wCycleBase_simple.jl
# Call order: 2

function define(params::wCycleBase_simple, forcing, land, helpers)
    w_model = params
    @pack_nt begin
        w_model ⇒ land.models
    end
    return land
end

# --------------------------------------

# rainSnow_Tair
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 3

# --------------------------------------

# PET_Lu2005
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 4

function define(params::PET_Lu2005, forcing, land, helpers)
    ## unpack forcing
    @unpack_PET_Lu2005 params
    @unpack_nt f_airT ⇐ forcing
    PET = zero(f_airT)
    ## calculate variables
    Tair_prev = f_airT

    ## pack land variables
    @pack_nt begin 
        PET ⇒ land.fluxes
        Tair_prev ⇒ land.states
    end
    return land
end

# --------------------------------------

# ambientCO2_forcing
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/ambientCO2/ambientCO2_forcing.jl
# Call order: 5

# --------------------------------------

# getPools_simple
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/getPools/getPools_simple.jl
# Call order: 6

function define(params::getPools_simple, forcing, land, helpers)
    ## unpack land variables
    @unpack_nt begin
        z_zero ⇐ land.constants
    end
    ## calculate variables
    WBP = z_zero
    @pack_nt WBP ⇒ land.states
    return land
end

# --------------------------------------

# soilTexture_forcing
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilTexture/soilTexture_forcing.jl
# Call order: 7

function define(params::soilTexture_forcing, forcing, land, helpers)
    ## unpack forcing
    @unpack_nt soilW ⇐ land.pools

    ## precomputations/check
    st_clay = zero(soilW)
    st_orgm = zero(soilW)
    st_sand = zero(soilW)
    st_silt = zero(soilW)

    ## pack land variables
    @pack_nt (st_clay, st_orgm, st_sand, st_silt) ⇒ land.properties
    return land
end

# --------------------------------------

# soilProperties_Saxton2006
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 8

function define(params::soilProperties_Saxton2006, forcing, land, helpers)
    @unpack_soilProperties_Saxton2006 params

    @unpack_nt begin
        soilW ⇐ land.pools
    end
    ## Instantiate variables
    sp_α = zero(soilW)
    sp_β = zero(soilW)
    sp_k_fc = zero(soilW)
    sp_θ_fc = zero(soilW)
    sp_ψ_fc = zero(soilW)
    sp_k_wp = zero(soilW)
    sp_θ_wp = zero(soilW)
    sp_ψ_wp = zero(soilW)
    sp_k_sat = zero(soilW)
    sp_θ_sat = zero(soilW)
    sp_ψ_sat = zero(soilW)

    # generate the function handle to calculate soil hydraulic property
    unsat_k_model = kSaxton2006()

    ## pack land variables
    @pack_nt (sp_k_fc, sp_k_sat, sp_k_wp, sp_α, sp_β, sp_θ_fc, sp_θ_sat, sp_θ_wp, sp_ψ_fc, sp_ψ_sat, sp_ψ_wp) ⇒ land.properties
    @pack_nt unsat_k_model ⇒ land.models
    return land
end

# --------------------------------------

# soilWBase_uniform
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilWBase/soilWBase_uniform.jl
# Call order: 9

function define(params::soilWBase_uniform, forcing, land, helpers)
    #@needscheck
    ## unpack land variables
    @unpack_nt begin
        soilW ⇐ land.pools
    end

    # instatiate variables 
    soil_layer_thickness = zero(soilW)
    w_fc = zero(soilW)
    w_wp = zero(soilW)
    w_sat = zero(soilW)
    w_awc = zero(soilW)
    # save the sums of selected variables
    ∑w_fc = sum(w_fc)
    ∑w_wp = sum(w_wp)
    ∑w_sat = sum(w_sat)
    ∑w_awc = sum(w_awc)

    k_sat = zero(soilW)
    k_fc = zero(soilW)
    k_wp = zero(soilW)
    ψ_sat = zero(soilW)
    ψ_fc = zero(soilW)
    ψ_wp = zero(soilW)
    θ_sat = zero(soilW)
    θ_fc = zero(soilW)
    θ_wp = zero(soilW)
    soil_α = zero(soilW)
    soil_β = zero(soilW)

    # get the plant available water capacity

    @pack_nt begin
        (k_fc, k_sat, k_wp, soil_layer_thickness, w_awc, w_fc, w_sat, w_wp, ∑w_awc, ∑w_fc, ∑w_sat, ∑w_wp, soil_α, soil_β, θ_fc, θ_sat, θ_wp, ψ_fc, ψ_sat, ψ_wp) ⇒ land.properties
    end
    return land
end

# --------------------------------------

# rootMaximumDepth_fracSoilD
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 10

function define(params::rootMaximumDepth_fracSoilD, forcing, land, helpers)
    ## unpack parameters
    @unpack_rootMaximumDepth_fracSoilD params
    @unpack_nt soil_layer_thickness ⇐ land.properties
    ## calculate variables
    ∑soil_depth = sum(soil_layer_thickness)
    ## pack land variables
    @pack_nt begin
        ∑soil_depth ⇒ land.properties
    end
    return land
end

# --------------------------------------

# rootWaterEfficiency_expCvegRoot
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 11

function define(params::rootWaterEfficiency_expCvegRoot, forcing, land, helpers)
    @unpack_rootWaterEfficiency_expCvegRoot params
    @unpack_nt begin
        soil_layer_thickness ⇐ land.properties
        soilW ⇐ land.pools
    end
    ## Instantiate variables
    root_water_efficiency = one.(soilW)
    cumulative_soil_depths = cumsum(soil_layer_thickness)
    root_over = one.(soilW)
    ## pack land variables
    @pack_nt begin
        root_over ⇒ land.rootWaterEfficiency
        cumulative_soil_depths ⇒ land.properties
        root_water_efficiency ⇒ land.diagnostics
    end
    return land
end

# --------------------------------------

# plantForm_PFT
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/plantForm/plantForm_PFT.jl
# Call order: 12

function define(params::plantForm_PFT, forcing, land, helpers)
	## unpack NT forcing
		plant_form_pft = Dict(
			:tree  => [collect(1:5)..., 8, 9],
			:shrub => collect(6:7),
			:herb => [10, 11, 12, 14],
			)

	defined_forms_pft = vcat(values(plant_form_pft)...)
	# PFT_to_PlantForm = Dict(
	# 	1 => "Tree",
	# 	2 => "Tree",
	# 	3 => "Tree",
	# 	4 => "Tree",
	# 	5 => "Tree",
	# 	6 => "Shrub",
	# 	7 => "Shrub",
	# 	8 => "Savanna",
	# 	9 => "Savanna",
	# 	10 => "Herb",
	# 	11 => "Herb",
	# 	12 => "Herb",
	# 	14 => "Herb",
	# 	13 => "Non-Veg",
	# 	15 => "Non-Veg",
	# 	16 => "Non-Veg",
	# 	17 => "Non-Veg",
	# 	NaN => "Non-Veg",
	# 	missing => "Non-Veg"
	# 	)
	@pack_nt (plant_form_pft, defined_forms_pft) ⇒ land.plantForm
	return land
end

# --------------------------------------

# treeFraction_forcing
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/treeFraction/treeFraction_forcing.jl
# Call order: 13

# --------------------------------------

# vegFraction_forcing
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/vegFraction/vegFraction_forcing.jl
# Call order: 14

# --------------------------------------

# fAPAR_cVegLeafBareFrac
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 15

# --------------------------------------

# LAI_cVegLeaf
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 16

# --------------------------------------

# snowFraction_HTESSEL
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 17

# --------------------------------------

# snowMelt_TairRn
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 18

# --------------------------------------

# runoffSaturationExcess_Bergstroem1992
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 19

# --------------------------------------

# runoffOverland_Sat
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/runoffOverland/runoffOverland_Sat.jl
# Call order: 20

# --------------------------------------

# runoffSurface_all
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/runoffSurface/runoffSurface_all.jl
# Call order: 21

# --------------------------------------

# runoffBase_Zhang2008
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 22

# --------------------------------------

# percolation_WBP
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/percolation/percolation_WBP.jl
# Call order: 23

# --------------------------------------

# evaporation_fAPAR
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 24

# --------------------------------------

# drainage_dos
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 25

function define(params::drainage_dos, forcing, land, helpers)
    ## unpack parameters

    ## unpack land variables
    @unpack_nt begin
        ΔsoilW ⇐ land.pools
    end
    drainage = zero(ΔsoilW)

    ## pack land variables
    @pack_nt begin
        drainage ⇒ land.fluxes
    end
    return land
end

# --------------------------------------

# capillaryFlow_VanDijk2010
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 26

function define(params::capillaryFlow_VanDijk2010, forcing, land, helpers)

    ## unpack land variables
    @unpack_nt begin
        soilW ⇐ land.pools
    end
    soil_capillary_flux = zero(soilW)

    ## pack land variables
    @pack_nt begin
        soil_capillary_flux ⇒ land.fluxes
    end
    return land
end

# --------------------------------------

# groundWRecharge_dos
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 27

function define(params::groundWRecharge_dos, forcing, land, helpers)
    ## unpack land variables
    @unpack_nt begin
        z_zero ⇐ land.constants
    end

    gw_recharge = z_zero

    ## pack land variables
    @pack_nt begin
        gw_recharge ⇒ land.fluxes
    end
    return land
end

# --------------------------------------

# groundWSoilWInteraction_VanDijk2010
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 28

function define(params::groundWSoilWInteraction_VanDijk2010, forcing, land, helpers)
    ## in case groundWReacharge is not selected in the model structure, instantiate the variable with zero
    @unpack_groundWSoilWInteraction_VanDijk2010 params
    gw_recharge = zero(max_fraction)
    ## pack land variables
    @pack_nt gw_recharge ⇒ land.fluxes
    return land
end

# --------------------------------------

# vegAvailableWater_rootWaterEfficiency
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/vegAvailableWater/vegAvailableWater_rootWaterEfficiency.jl
# Call order: 29

function define(params::vegAvailableWater_rootWaterEfficiency, forcing, land, helpers)

    ## unpack land variables
    @unpack_nt begin
        soilW ⇐ land.pools
    end

    PAW = zero(soilW)

    ## pack land variables
    @pack_nt PAW ⇒ land.states
    return land
end

# --------------------------------------

# transpirationSupply_wAWC
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 30

# --------------------------------------

# gppPotential_Monteith
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 31

# --------------------------------------

# gppDiffRadiation_Wang2015
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 32

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
# Call order: 33

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
# Call order: 34

# --------------------------------------

# gppVPD_PRELES
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 35

# --------------------------------------

# gppSoilW_Stocker2020
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 36

function define(params::gppSoilW_Stocker2020, forcing, land, helpers)
    @unpack_gppSoilW_Stocker2020 params
    gpp_f_soilW = one(q)

    ## pack land variables
    @pack_nt gpp_f_soilW ⇒ land.diagnostics
    return land
end

# --------------------------------------

# gppDemand_mult
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDemand/gppDemand_mult.jl
# Call order: 37

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

# WUE_expVPDDayCo2
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 38

# --------------------------------------

# gpp_coupled
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gpp/gpp_coupled.jl
# Call order: 39

# --------------------------------------

# transpiration_coupled
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/transpiration/transpiration_coupled.jl
# Call order: 40

# --------------------------------------

# rootWaterUptake_proportion
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rootWaterUptake/rootWaterUptake_proportion.jl
# Call order: 41

function define(params::rootWaterUptake_proportion, forcing, land, helpers)

    ## unpack land variables
    @unpack_nt begin
        soilW ⇐ land.pools
    end
    root_water_uptake = zero(soilW)

    ## pack land variables
    @pack_nt begin
        root_water_uptake ⇒ land.fluxes
    end
    return land
end

# --------------------------------------

# cVegetationDieOff_forcing
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cVegetationDieOff/cVegetationDieOff_forcing.jl
# Call order: 42

function define(params::cVegetationDieOff_forcing, forcing, land, helpers)
    ## unpack forcing
    @unpack_nt f_dist_intensity ⇐ forcing
    c_fVegDieOff = f_dist_intensity
    @pack_nt c_fVegDieOff ⇒ land.diagnostics
    return land
end

# --------------------------------------

# cCycleBase_GSI_PlantForm_LargeKReserve
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 43

function define(params::cCycleBase_GSI_PlantForm_LargeKReserve, forcing, land, helpers)
    @unpack_cCycleBase_GSI_PlantForm_LargeKReserve params
    @unpack_nt begin
        cEco ⇐ land.pools
        (z_zero, o_one) ⇐ land.constants
    end
    ## Instantiate variables
    C_to_N_cVeg = zero(cEco) #sujan
    # C_to_N_cVeg[getZix(land.pools.cVeg, helpers.pools.zix.cVeg)] .= p_C_to_N_cVeg
    c_eco_k_base = zero(cEco)
    c_eco_τ = zero(cEco)

    # if there is flux order check that is consistent
    c_flow_order = Tuple(collect(1:length(findall(>(z_zero), c_flow_A_array))))
    c_taker = Tuple([ind[1] for ind ∈ findall(>(z_zero), c_flow_A_array)])
    c_giver = Tuple([ind[2] for ind ∈ findall(>(z_zero), c_flow_A_array)])

    c_model = cCycleBase_GSI_PlantForm_LargeKReserve()

    zero_c_τ_pf = zero(c_τ_tree)

    ## pack land variables
    @pack_nt begin
        c_flow_A_array ⇒ land.diagnostics
        (c_flow_order, c_taker, c_giver) ⇒ land.constants
        (C_to_N_cVeg, c_eco_τ, c_eco_k_base, zero_c_τ_pf) ⇒ land.diagnostics
        c_model ⇒ land.models
    end
    return land
end

# --------------------------------------

# cCycleDisturbance_WROASTED
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleDisturbance/cCycleDisturbance_WROASTED.jl
# Call order: 44

function define(params::cCycleDisturbance_WROASTED, forcing, land, helpers)
    @unpack_nt begin
        (c_giver, c_taker) ⇐ land.constants
        cVeg ⇐ land.pools
    end
    zix_veg_all = Tuple(vcat(getZix(cVeg, helpers.pools.zix.cVeg)...))
    c_lose_to_zix_vec = Tuple{Int}[]
    for zixVeg ∈ zix_veg_all
        # make reserve pool flow to slow litter pool/woody debris
        if helpers.pools.components.cEco[zixVeg] == :cVegReserve
            c_lose_to_zix = helpers.pools.zix.cLitSlow
        else
            c_lose_to_zix = c_taker[[(c_giver .== zixVeg)...]]
        end
        ndxNoVeg = Int[]
        for ndxl ∈ c_lose_to_zix
            if ndxl ∉ zix_veg_all
                push!(ndxNoVeg, ndxl)
            end
        end
        push!(c_lose_to_zix_vec, Tuple(ndxNoVeg))
    end
    c_lose_to_zix_vec = Tuple(c_lose_to_zix_vec)
    @pack_nt (zix_veg_all, c_lose_to_zix_vec) ⇒ land.cCycleDisturbance
    return land
end

# --------------------------------------

# cTauSoilT_Q10
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 45

# --------------------------------------

# cTauSoilW_GSI
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 46

function define(params::cTauSoilW_GSI, forcing, land, helpers)
    @unpack_cTauSoilW_GSI params
    @unpack_nt cEco ⇐ land.pools

    ## Instantiate variables
    c_eco_k_f_soilW = one.(cEco)

    ## pack land variables
    @pack_nt c_eco_k_f_soilW ⇒ land.diagnostics
    return land
end

# --------------------------------------

# cTauLAI_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauLAI/cTauLAI_none.jl
# Call order: 47

function define(params::cTauLAI_none, forcing, land, helpers)
    @unpack_nt cEco ⇐ land.pools

    ## calculate variables
    c_eco_k_f_LAI = one.(cEco)

    ## pack land variables
    @pack_nt c_eco_k_f_LAI ⇒ land.diagnostics
    return land
end

# --------------------------------------

# cTauSoilProperties_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauSoilProperties/cTauSoilProperties_none.jl
# Call order: 48

function define(params::cTauSoilProperties_none, forcing, land, helpers)
    @unpack_nt cEco ⇐ land.pools

    ## calculate variables
    c_eco_k_f_soil_props = one.(cEco)

    ## pack land variables
    @pack_nt c_eco_k_f_soil_props ⇒ land.diagnostics
    return land
end

# --------------------------------------

# cTauVegProperties_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauVegProperties/cTauVegProperties_none.jl
# Call order: 49

function define(params::cTauVegProperties_none, forcing, land, helpers)

    @unpack_nt begin
        (z_zero, o_one) ⇐ land.constants
        cEco ⇐ land.pools        
    end 

    ## calculate variables
    c_eco_k_f_veg_props = one.(cEco)
    LITC2N = z_zero
    LIGNIN = z_zero
    MTF = o_one
    SCLIGNIN = z_zero
    LIGEFF = z_zero

    ## pack land variables
    @pack_nt (LIGEFF, LIGNIN, LITC2N, MTF, SCLIGNIN) ⇒ land.properties
    @pack_nt c_eco_k_f_veg_props ⇒ land.diagnostics
    return land

end

# --------------------------------------

# cTau_mult
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTau/cTau_mult.jl
# Call order: 50

function define(params::cTau_mult, forcing, land, helpers)
    ## unpack land variables
    @unpack_nt begin
        cEco ⇐ land.pools
    end
    c_eco_k = zero(cEco)

    ## pack land variables
    @pack_nt c_eco_k ⇒ land.diagnostics
    return land
end

# --------------------------------------

# autoRespirationAirT_Q10
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 51

# --------------------------------------

# cAllocationLAI_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocationLAI/cAllocationLAI_none.jl
# Call order: 52

function define(params::cAllocationLAI_none, forcing, land, helpers)
    @unpack_nt cEco ⇐ land.pools

    ## calculate variables
    c_allocation_f_LAI = one(first(cEco))

    ## pack land variables
    @pack_nt c_allocation_f_LAI ⇒ land.diagnostics
    return land
end

# --------------------------------------

# cAllocationRadiation_RgPot
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocationRadiation/cAllocationRadiation_RgPot.jl
# Call order: 53

function define(params::cAllocationRadiation_RgPot, forcing, land, helpers)
    @unpack_nt f_rg_pot ⇐ forcing
	rg_pot_max = at_least_zero(f_rg_pot)
    @pack_nt (rg_pot_max) ⇒ land.cAllocationRadiation
	return land
end

# --------------------------------------

# cAllocationSoilW_gpp
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocationSoilW/cAllocationSoilW_gpp.jl
# Call order: 54

# --------------------------------------

# cAllocationSoilT_gpp
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocationSoilT/cAllocationSoilT_gpp.jl
# Call order: 55

# --------------------------------------

# cAllocationNutrients_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocationNutrients/cAllocationNutrients_none.jl
# Call order: 56

function define(params::cAllocationNutrients_none, forcing, land, helpers)
    @unpack_nt cEco ⇐ land.pools

    ## calculate variables
    c_allocation_f_W_N = one(first(cEco))

    ## pack land variables
    @pack_nt c_allocation_f_W_N ⇒ land.diagnostics
    return land
end

# --------------------------------------

# cAllocation_GSI
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocation/cAllocation_GSI.jl
# Call order: 57

function define(params::cAllocation_GSI, forcing, land, helpers)
    @unpack_nt cEco ⇐ land.pools
    ## Instantiate variables
    c_allocation = zero(cEco)
    cVeg_names = (:cVegRoot, :cVegWood, :cVegLeaf)

    c_allocation_to_veg = zero(cEco)
    cVeg_zix = Tuple{Int}[]
    cVeg_nzix = eltype(cEco)[]
    cpI = 1
    for cpName ∈ cVeg_names
        zix = getZix(getfield(land.pools, cpName), getfield(helpers.pools.zix, cpName))
        nZix = oftype(first(c_allocation), length(zix))
        push!(cVeg_zix, zix)
        push!(cVeg_nzix, nZix)
    end
    cVeg_zix = Tuple(cVeg_zix)
    cVeg_nzix = Tuple(cVeg_nzix)
    ## pack land variables
    @pack_nt begin
        (cVeg_names, cVeg_zix, cVeg_nzix, c_allocation_to_veg) ⇒ land.cAllocation
        c_allocation ⇒ land.diagnostics
    end
    return land
end

# --------------------------------------

# cAllocationTreeFraction_Friedlingstein1999
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 58

function define(params::cAllocationTreeFraction_Friedlingstein1999, forcing, land, helpers)
    ## unpack parameters
    ## calculate variables
    # check if there are fine & coarse root pools
    cVeg_names_for_c_allocation_frac_tree = (:cVegRoot, :cVegWood, :cVegLeaf)::Tuple
    if hasproperty(land.pools, :cVegWoodC) && hasproperty(land.pools, :cVegWoodF)
        cVeg_names_for_c_allocation_frac_tree = (:cVegRootF, :cVegRootC, :cVegWood, :cVegLeaf)::Tuple
    end
    @pack_nt cVeg_names_for_c_allocation_frac_tree ⇒ land.cAllocationTreeFraction
    return land
end

# --------------------------------------

# autoRespiration_Thornley2000A
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 59

function define(params::autoRespiration_Thornley2000A, forcing, land, helpers)
    @unpack_nt begin
        cEco ⇐ land.pools
    end
    c_eco_efflux = zero(cEco)
    k_respiration_maintain = one.(cEco)
    k_respiration_maintain_su = one.(cEco)
    auto_respiration_growth = zero(cEco)
    auto_respiration_maintain = zero(cEco)

    ## pack land variables
    @pack_nt begin
        (k_respiration_maintain, k_respiration_maintain_su) ⇒ land.diagnostics
        (auto_respiration_growth, auto_respiration_maintain, c_eco_efflux) ⇒ land.fluxes
    end
    return land
end

# --------------------------------------

# cFlowSoilProperties_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cFlowSoilProperties/cFlowSoilProperties_none.jl
# Call order: 60

function define(params::cFlowSoilProperties_none, forcing, land, helpers)
    @unpack_nt begin
        c_taker ⇐ land.constants
        cEco ⇐ land.pools
    end 
    ## calculate variables
    p_E_vec = eltype(cEco).(zero([c_taker...]))

    if cEco isa SVector
        p_E_vec = SVector{length(p_E_vec)}(p_E_vec)
    end

    p_F_vec = eltype(cEco).(zero([c_taker...]))
    if cEco isa SVector
        p_F_vec = SVector{length(p_F_vec)}(p_F_vec)
    end

    ## pack land variables
    @pack_nt (p_E_vec, p_F_vec) ⇒ land.diagnostics
    return land
end

# --------------------------------------

# cFlowVegProperties_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cFlowVegProperties/cFlowVegProperties_none.jl
# Call order: 61

function define(params::cFlowVegProperties_none, forcing, land, helpers)
    @unpack_nt cEco ⇐ land.pools

    @unpack_nt c_taker ⇐ land.constants

    ## calculate variables
    p_E_vec = eltype(cEco).(zero([c_taker...]))

    if cEco isa SVector
        p_E_vec = SVector{length(p_E_vec)}(p_E_vec)
    end

    p_F_vec = eltype(cEco).(zero([c_taker...]))
    if cEco isa SVector
        p_F_vec = SVector{length(p_F_vec)}(p_F_vec)
    end

    ## pack land variables
    @pack_nt (p_E_vec, p_F_vec) ⇒ land.cFlowVegProperties
    return land
end

# --------------------------------------

# cFlow_GSI
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 62

function define(params::cFlow_GSI, forcing, land, helpers)
    @unpack_cFlow_GSI params
    @unpack_nt begin
        (cEco, soilW) ⇐ land.pools
        (c_giver, c_taker) ⇐ land.constants
        cEco_comps = cEco ⇐ helpers.pools.components
        ∑w_sat ⇐ land.properties
    end
    ## Instantiate variables

    # transfers
    aTrg = []
    for t_rg in c_taker
        push!(aTrg, cEco_comps[t_rg])
    end
    aSrc = []
    for s_rc in c_giver
        push!(aSrc, cEco_comps[s_rc])
    end

    # aTrg_a = Tuple(aTrg_a)
    # aSrc_b = Tuple(aSrc_a)

    # flowVar = [:reserve_to_leaf, :reserve_to_root, :leaf_to_reserve, :root_to_reserve, :k_shedding_leaf, :k_shedding_root]
    # aSrc = (:cVegReserve, :cVegReserve, :cVegLeaf, :cVegRoot, :cVegLeaf, :cVegRoot)
    # aTrg = (:cVegLeaf, :cVegRoot, :cVegReserve, :cVegReserve, :cLitFast, :cLitFast)

    aSrc = Tuple(aSrc)
    aTrg = Tuple(aTrg)

    # @show aSrc, aSrc_b
    # @show aTrg, aTrg_a
    c_flow_A_vec_ind = (reserve_to_leaf=findall((aSrc .== :cVegReserve) .* (aTrg .== :cVegLeaf) .== true)[1],
        reserve_to_root=findall((aSrc .== :cVegReserve) .* (aTrg .== :cVegRoot) .== true)[1],
        leaf_to_reserve=findall((aSrc .== :cVegLeaf) .* (aTrg .== :cVegReserve) .== true)[1],
        root_to_reserve=findall((aSrc .== :cVegRoot) .* (aTrg .== :cVegReserve) .== true)[1],
        k_shedding_leaf=findall((aSrc .== :cVegLeaf) .* (aTrg .== :cLitFast) .== true)[1],
        k_shedding_root=findall((aSrc .== :cVegRoot) .* (aTrg .== :cLitFast) .== true)[1])

    # tc_print(c_flow_A_vec_ind)
    c_flow_A_vec = one.(eltype(cEco).(zero([c_taker...])))

    if cEco isa SVector
        c_flow_A_vec = SVector{length(c_flow_A_vec)}(c_flow_A_vec)
    end

    eco_stressor_prev = totalS(soilW) / ∑w_sat
    slope_eco_stressor_prev = zero(eco_stressor_prev)

    @pack_nt begin
        c_flow_A_vec_ind ⇒ land.cFlow
        eco_stressor_prev ⇒ land.diagnostics
        slope_eco_stressor_prev ⇒ land.diagnostics
        c_flow_A_vec ⇒ land.diagnostics
    end

    return land
end

# --------------------------------------

# cCycleConsistency_simple
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleConsistency/cCycleConsistency_simple.jl
# Call order: 63

function define(params::cCycleConsistency_simple, forcing, land, helpers)

    ## unpack land variables
    @unpack_nt begin
        cEco ⇐ land.pools
        c_flow_A_array ⇐ land.diagnostics
        c_giver ⇐ land.constants
    end
    # make list of indices which give carbon to other pools during the flow, and separate them if 
    # they are above or below the diagonal in flow vector
giver_upper = Tuple([ind[2] for ind ∈ findall(>(0), upper_triangle_mask(c_flow_A_array) .* c_flow_A_array)])
giver_lower = Tuple([ind[2] for ind ∈ findall(>(0), lower_triangle_mask(c_flow_A_array) .* c_flow_A_array)])
    giver_upper_unique = unique(giver_upper)
    giver_lower_unique = unique(giver_lower)
    giver_upper_indices = []
    for giv in giver_upper_unique
        giver_pos = findall(==(giv), c_giver)
        push!(giver_upper_indices, Tuple(giver_pos))
    end
    giver_lower_indices = []
    for giv in giver_lower_unique
        giver_pos = findall(==(giv), c_giver)
        push!(giver_lower_indices, Tuple(giver_pos))
    end
    giver_lower_indices = Tuple(giver_lower_indices)
    giver_upper_indices = Tuple(giver_upper_indices)
    @pack_nt (giver_lower_unique, giver_lower_indices, giver_upper_unique, giver_upper_indices) ⇒ land.cCycleConsistency
    return land
end

# --------------------------------------

# cCycle_GSI
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycle/cCycle_GSI.jl
# Call order: 64

function define(params::cCycle_GSI, forcing, land, helpers)
    @unpack_nt cEco ⇐ land.pools
    ## Instantiate variables
    c_eco_flow = zero(cEco)
    c_eco_out = zero(cEco)
    c_eco_influx = zero(cEco)
    zero_c_eco_flow = zero(c_eco_flow)
    zero_c_eco_influx = zero(c_eco_influx)
    ΔcEco = zero(cEco)
    c_eco_npp = zero(cEco)

    cEco_prev = cEco
    ## pack land variables

    @pack_nt begin
        (c_eco_flow, c_eco_influx, c_eco_out, c_eco_npp, zero_c_eco_flow, zero_c_eco_influx) ⇒ land.fluxes
        cEco_prev ⇒ land.states
        ΔcEco ⇒ land.pools
    end
    return land
end

# --------------------------------------

# evapotranspiration_sum
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/evapotranspiration/evapotranspiration_sum.jl
# Call order: 65

function define(params::evapotranspiration_sum, forcing, land, helpers)
    @unpack_nt z_zero ⇐ land.constants

    ## set variables to zero
    evaporation = z_zero
    evapotranspiration = z_zero
    interception = z_zero
    sublimation = z_zero
    transpiration = z_zero

    ## pack land variables
    @pack_nt begin
        (evaporation, evapotranspiration, interception, sublimation, transpiration) ⇒ land.fluxes
    end
    return land
end

# --------------------------------------

# runoff_sum
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/runoff/runoff_sum.jl
# Call order: 66

function define(params::runoff_sum, forcing, land, helpers)

    @unpack_nt z_zero ⇐ land.constants

    ## set variables to zero
    base_runoff = z_zero
    runoff = z_zero
    surface_runoff = z_zero

    ## pack land variables
    @pack_nt begin
        (runoff, base_runoff, surface_runoff) ⇒ land.fluxes
    end
    return land
end

# --------------------------------------

# wCycle_components
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/wCycle/wCycle_components.jl
# Call order: 67

# --------------------------------------

# waterBalance_simple
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/waterBalance/waterBalance_simple.jl
# Call order: 68

# --------------------------------------

# cBiomass_treeGrass_cVegReserveScaling
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cBiomass/cBiomass_treeGrass_cVegReserveScaling.jl
# Call order: 69

# --------------------------------------

# Fallback define function for LandEcosystem
    function define(params::LandEcosystem, forcing, land, helpers)
        return land
    end

    