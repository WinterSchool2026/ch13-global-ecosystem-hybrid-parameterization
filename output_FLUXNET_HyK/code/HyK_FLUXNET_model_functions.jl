# Code for precompute and compute functions in models of SINDBAD for HyK experiment applied to FLUXNET domain.
# Precompute functions are called once outside the time loop per iteration in optimization, while compute functions are called every time step.
# Based on @code_string from CodeTracking.jl. In case of conflicts, follow the original code in model approaches in src/Processes/[model]/[approach].jl

# constants_numbers
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/constants/constants_numbers.jl
# Call order: 1

# --------------------------------------

# wCycleBase_simple
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/wCycleBase/wCycleBase_simple.jl
# Call order: 2

# --------------------------------------

# rainSnow_Tair
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 3

function compute(params::rainSnow_Tair, forcing, land, helpers)
    ## unpack parameters and forcing
    @unpack_rainSnow_Tair params
    @unpack_nt (f_rain, f_airT) ⇐ forcing

    ## unpack land variables
    @unpack_nt begin
        snowW ⇐ land.pools
        ΔsnowW ⇐ land.pools
    end
    rain = f_rain
    snow = zero(f_rain)
    ## calculate variables
    if f_airT < airT_thres
        snow = f_rain
        rain = zero(f_rain)
    end
    precip = rain + snow

    # add snowfall to snowpack of the first layer
    @add_to_elem snow ⇒ (ΔsnowW, 1, :snowW)
    ## pack land variables
    @pack_nt begin
        (precip, rain, snow) ⇒ land.fluxes
        ΔsnowW ⇒ land.pools
    end
    return land
end

# --------------------------------------

# PET_Lu2005
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 4

function compute(params::PET_Lu2005, forcing, land, helpers)
    ## unpack parameters
    @unpack_PET_Lu2005 params
    ## unpack forcing
    @unpack_nt (f_rn, f_airT) ⇐ forcing

    @unpack_nt begin
        Tair_prev ⇐ land.states
    end

    ## calculate variables
    # slope of the saturation vapor pressure temperature curve [kPa/°C]
    Δ = svp_1 * (svp_2 * f_airT + svp_3)^svp_4 - svp_5

    # atmp is the atmospheric pressure [kPa], elev = elevation
    atmp = pres_sl - pres_elev * elev

    # λ is the latent heat of vaporization [MJ/kg]
    λ = λ_base - λ_airT * f_airT

    # γ is the the psychrometric constant modified by the ratio of
    # canopy resistance to atmospheric resistance [kPa/°C].
    γ = sh_cp * atmp / (γ_resistance * λ)

    # G is the heat flux density to the ground [MJ/m^2/day]
    # G = 4.2[T[i+1]-T[i-1]]/dt ⇒ adopted to T[i]-T[i-1] by skoirala
    # G = 4.2 * (Tair_ip1 - Tair_im1) / dt
    # where Ti is the mean air temperature [°C] for the period i; &
    # dt the difference of time [days]..
    ΔTair = f_airT - Tair_prev
    G = G_base * (ΔTair) / Δt
    G = zero(G) #@needscheck: current G is set to zero because the original formula looked at tomorrow's temperature, and we only have today and yesterday's data available during a model run
    PET = (α * (Δ / (Δ + γ)) * (f_rn - G)) / λ
    PET = at_least_zero(PET)

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

function compute(params::ambientCO2_forcing, forcing, land, helpers)
    ## unpack forcing
    @unpack_nt f_ambient_CO2 ⇐ forcing

    ambient_CO2 = f_ambient_CO2

    ## pack land variables
    @pack_nt ambient_CO2 ⇒ land.states
    return land
end

# --------------------------------------

# getPools_simple
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/getPools/getPools_simple.jl
# Call order: 6

function compute(params::getPools_simple, forcing, land, helpers)

    ## unpack land variables
    @unpack_nt begin
        rain ⇐ land.fluxes
        WBP ⇐ land.states
    end
    ## calculate variables
    WBP = oftype(WBP, rain)

    @pack_nt WBP ⇒ land.states
    return land
end

# --------------------------------------

# soilTexture_forcing
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilTexture/soilTexture_forcing.jl
# Call order: 7

function precompute(params::soilTexture_forcing, forcing, land, helpers)
    ## unpack variables
    @unpack_nt (f_clay, f_orgm, f_sand, f_silt) ⇐ forcing
    @unpack_nt (st_clay, st_orgm, st_sand, st_silt) ⇐ land.properties

    if length(f_clay) != length(st_clay)
        @debug "soilTexture_forcing: the number of soil layers in forcing data does not match the layers in model_structure.json. Using mean of input over the soil layers."
        for sl ∈ eachindex(st_clay)
            @rep_elem mean(f_clay) ⇒ (st_clay, sl, :soilW)
            @rep_elem mean(f_sand) ⇒ (st_sand, sl, :soilW)
            @rep_elem mean(f_silt) ⇒ (st_silt, sl, :soilW)
            @rep_elem mean(f_orgm) ⇒ (st_orgm, sl, :soilW)
        end
    else
        for sl ∈ eachindex(st_clay)
            @rep_elem f_clay[sl] ⇒ (st_clay, sl, :soilW)
            @rep_elem f_sand[sl] ⇒ (st_sand, sl, :soilW)
            @rep_elem f_silt[sl] ⇒ (st_silt, sl, :soilW)
            @rep_elem f_orgm[sl] ⇒ (st_orgm, sl, :soilW)
        end
    end
    ## pack land variables
    @pack_nt (st_clay, st_orgm, st_sand, st_silt) ⇒ land.properties
    return land
end

# --------------------------------------

# soilProperties_Saxton2006
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 8

function precompute(params::soilProperties_Saxton2006, forcing, land, helpers)
    @unpack_soilProperties_Saxton2006 params

    @unpack_nt begin
        (sp_k_fc, sp_k_sat, sp_k_wp, sp_α, sp_β, sp_θ_fc, sp_θ_sat, sp_θ_wp, sp_ψ_fc, sp_ψ_sat, sp_ψ_wp) ⇐ land.properties
    end
    ## calculate variables
    # calculate & set the soil hydraulic properties for each layer
    for sl in eachindex(sp_α)
        (α, β, k_sat, θ_sat, ψ_sat, k_fc, θ_fc, ψ_fc, k_wp, θ_wp, ψ_wp) = calcPropsSaxton2006(params, land, helpers, sl)
        @rep_elem α ⇒ (sp_α, sl, :soilW)
        @rep_elem β ⇒ (sp_β, sl, :soilW)
        @rep_elem k_fc ⇒ (sp_k_fc, sl, :soilW)
        @rep_elem θ_fc ⇒ (sp_θ_fc, sl, :soilW)
        @rep_elem ψ_fc ⇒ (sp_ψ_fc, sl, :soilW)
        @rep_elem k_wp ⇒ (sp_k_wp, sl, :soilW)
        @rep_elem θ_wp ⇒ (sp_θ_wp, sl, :soilW)
        @rep_elem ψ_wp ⇒ (sp_ψ_wp, sl, :soilW)
        @rep_elem k_sat ⇒ (sp_k_sat, sl, :soilW)
        @rep_elem θ_sat ⇒ (sp_θ_sat, sl, :soilW)
        @rep_elem ψ_sat ⇒ (sp_ψ_sat, sl, :soilW)
    end

    ## pack land variables
    @pack_nt (sp_k_fc, sp_k_sat, sp_k_wp, sp_α, sp_β, sp_θ_fc, sp_θ_sat, sp_θ_wp, sp_ψ_fc, sp_ψ_sat, sp_ψ_wp) ⇒ land.properties
    return land
end

# --------------------------------------

# soilWBase_uniform
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/soilWBase/soilWBase_uniform.jl
# Call order: 9

function precompute(params::soilWBase_uniform, forcing, land, helpers)
    ## unpack land variables
    @unpack_nt begin
        (sp_k_fc, sp_k_sat, sp_k_wp, sp_α, sp_β, sp_θ_fc, sp_θ_sat, sp_θ_wp, sp_ψ_fc, sp_ψ_sat, sp_ψ_wp) ⇐ land.properties
        (k_fc, k_sat, k_wp, soil_layer_thickness, w_awc, w_fc, w_sat, w_wp, ∑w_awc, ∑w_fc, ∑w_sat, ∑w_wp, soil_α, soil_β, θ_fc, θ_sat, θ_wp, ψ_fc, ψ_sat, ψ_wp) ⇐ land.properties
        soilW ⇐ land.pools
        soil_depths = soilW ⇐ helpers.pools.layer_thickness 
    end

    for sl ∈ eachindex(soilW)
        @rep_elem sp_k_sat[sl] ⇒ (k_sat, sl, :soilW)
        @rep_elem sp_k_fc[sl] ⇒ (k_fc, sl, :soilW)
        @rep_elem sp_k_wp[sl] ⇒ (k_wp, sl, :soilW)
        @rep_elem sp_ψ_sat[sl] ⇒ (ψ_sat, sl, :soilW)
        @rep_elem sp_ψ_fc[sl] ⇒ (ψ_fc, sl, :soilW)
        @rep_elem sp_ψ_wp[sl] ⇒ (ψ_wp, sl, :soilW)
        @rep_elem sp_θ_sat[sl] ⇒ (θ_sat, sl, :soilW)
        @rep_elem sp_θ_fc[sl] ⇒ (θ_fc, sl, :soilW)
        @rep_elem sp_θ_wp[sl] ⇒ (θ_wp, sl, :soilW)
        @rep_elem sp_α[sl] ⇒ (soil_α, sl, :soilW)
        @rep_elem sp_β[sl] ⇒ (soil_β, sl, :soilW)

        sd_sl = soil_depths[sl]
        @rep_elem sd_sl ⇒ (soil_layer_thickness, sl, :soilW)
        p_w_fc_sl = θ_fc[sl] * sd_sl
        @rep_elem p_w_fc_sl ⇒ (w_fc, sl, :soilW)
        w_wp_sl = θ_wp[sl] * sd_sl
        @rep_elem w_wp_sl ⇒ (w_wp, sl, :soilW)
        p_w_sat_sl = θ_sat[sl] * sd_sl
        @rep_elem p_w_sat_sl ⇒ (w_sat, sl, :soilW)
        # soilW_sl = min(soilW[sl], w_sat[sl])
        # @rep_elem soilW_sl ⇒ (soilW, sl, :soilW)
    end

    # get the plant available water capacity
    w_awc = w_fc - w_wp

    # save the sums of selected variables
    ∑w_fc = sum(w_fc)
    ∑w_wp = sum(w_wp)
    ∑w_sat = sum(w_sat)
    ∑w_awc = sum(w_awc)

    @pack_nt begin
        (k_fc, k_sat, k_wp, soil_layer_thickness, w_awc, w_fc, w_sat, w_wp, ∑w_awc, ∑w_fc, ∑w_sat, ∑w_wp, soil_α, soil_β, θ_fc, θ_sat, θ_wp, ψ_fc, ψ_sat, ψ_wp) ⇒ land.properties
        soilW ⇒ land.pools
    end
    return land
end

# --------------------------------------

# rootMaximumDepth_fracSoilD
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 10

function precompute(params::rootMaximumDepth_fracSoilD, forcing, land, helpers)
    ## unpack parameters
    @unpack_rootMaximumDepth_fracSoilD params
    @unpack_nt ∑soil_depth ⇐ land.properties
    ## calculate variables
    # get the soil thickness & root distribution information from input
    max_root_depth = ∑soil_depth * constant_frac_max_root_depth
    # disp(["the maxRootD scalar: " constant_frac_max_root_depth])

    ## pack land variables
    @pack_nt max_root_depth ⇒ land.diagnostics
    return land
end

# --------------------------------------

# rootWaterEfficiency_expCvegRoot
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 11

function precompute(params::rootWaterEfficiency_expCvegRoot, forcing, land, helpers)
    ## unpack parameters
    @unpack_rootWaterEfficiency_expCvegRoot params
    ## unpack land variables
    @unpack_nt begin
        root_over ⇐ land.rootWaterEfficiency
        cumulative_soil_depths ⇐ land.properties
        z_zero ⇐ land.constants
        max_root_depth ⇐ land.diagnostics
        soilW ⇐ land.pools
    end
    if max_root_depth > z_zero
        @rep_elem one(eltype(root_over)) ⇒ (root_over, 1, :soilW)
    end
    for sl ∈ eachindex(soilW)[2:end]
        soilcumuD = cumulative_soil_depths[sl-1]
        rootOver = max_root_depth - soilcumuD
        rootEff = rootOver >= z_zero ? one(eltype(root_over)) : zero(eltype(root_over))
        @rep_elem rootEff ⇒ (root_over, sl, :soilW)
    end
    ## pack land variables
    @pack_nt root_over ⇒ land.rootWaterEfficiency
    return land
end

function compute(params::rootWaterEfficiency_expCvegRoot, forcing, land, helpers)
    ## unpack parameters
    @unpack_rootWaterEfficiency_expCvegRoot params
    ## unpack land variables
    @unpack_nt begin
        root_over ⇐ land.rootWaterEfficiency
        root_water_efficiency ⇐ land.diagnostics
        (cVegRoot, soilW) ⇐ land.pools
    end
    ## calculate variables
    tmp_rootEff = max_root_water_efficiency -
                  (max_root_water_efficiency - min_root_water_efficiency) * (exp(-k_efficiency_cVegRoot * totalS(cVegRoot))) # root fraction/efficiency as a function of total carbon in root pools

    for sl ∈ eachindex(soilW)
        root_water_efficiency_sl = root_over[sl] * tmp_rootEff
        @rep_elem root_water_efficiency_sl ⇒ (root_water_efficiency, sl, :soilW)
    end
    ## pack land variables
    @pack_nt root_water_efficiency ⇒ land.diagnostics
    return land
end

# --------------------------------------

# plantForm_PFT
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/plantForm/plantForm_PFT.jl
# Call order: 12

function precompute(params::plantForm_PFT, forcing, land, helpers)
	## unpack NT forcing
	@unpack_nt f_pft ⇐ forcing
	@unpack_nt (plant_form_pft, defined_forms_pft) ⇐ land.plantForm

	the_pft = f_pft[1]
	plant_form = :unknown
	if the_pft ∈ defined_forms_pft
		for (pf_key, pf_values) in plant_form_pft
			if the_pft in pf_values
				plant_form=pf_key 
				break
			end
		end
	end
	@pack_nt plant_form ⇒ land.states
	return land
end

# --------------------------------------

# treeFraction_forcing
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/treeFraction/treeFraction_forcing.jl
# Call order: 13

function compute(params::treeFraction_forcing, forcing, land, helpers)
    ## unpack forcing
    @unpack_nt f_tree_frac ⇐ forcing

    frac_tree = first(f_tree_frac)
    ## pack land variables
    @pack_nt frac_tree ⇒ land.states
    return land
end

# --------------------------------------

# vegFraction_forcing
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/vegFraction/vegFraction_forcing.jl
# Call order: 14

function compute(params::vegFraction_forcing, forcing, land, helpers)
    @unpack_nt f_frac_vegetation ⇐ forcing

    frac_vegetation = first(f_frac_vegetation)

    ## pack land variables
    @pack_nt frac_vegetation ⇒ land.states
    return land
end

# --------------------------------------

# fAPAR_cVegLeafBareFrac
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 15

function compute(params::fAPAR_cVegLeafBareFrac, forcing, land, helpers)
    ## unpack parameters
    @unpack_fAPAR_cVegLeaf params

    ## unpack land variables
    @unpack_nt begin
        cVegLeaf ⇐ land.pools
        frac_vegetation ⇐ land.states
    end
    ## calculate variables
    cVegLeaf_sum = totalS(cVegLeaf)
    fAPAR = one(k_extinction) - exp(-(cVegLeaf_sum * k_extinction))
    fAPAR_bare = fAPAR * frac_vegetation # ?  frac_vegetation -> (1 - frac_B_soil) 
    # Cross check frac_vegetation from NetCDF files! 
    # TODO:  tree_frac (1km), Ranits's, mix, use table is available if not keep it!
    # 
    # ? make sure that frac_vegetation is consistent with Ranit's table!
    ## pack land variables
    @pack_nt begin
        (fAPAR_bare, fAPAR) ⇒ land.states # TODO: now use fAPAR_bare as the output for the cost function!
    end
    return land
end

# --------------------------------------

# LAI_cVegLeaf
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 16

function compute(params::LAI_cVegLeaf, forcing, land, helpers)
    ## unpack parameters
    @unpack_LAI_cVegLeaf params

    @unpack_nt cVegLeaf ⇐ land.pools

    ## calculate variables
    cVegLeafTotal = totalS(cVegLeaf)
    LAI = cVegLeafTotal * SLA

    ## pack land variables
    @pack_nt LAI ⇒ land.states
    return land
end

# --------------------------------------

# snowFraction_HTESSEL
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 17

function compute(params::snowFraction_HTESSEL, forcing, land, helpers)
    ## unpack parameters
    @unpack_snowFraction_HTESSEL params

    ## unpack land variables
    @unpack_nt begin
        snowW ⇐ land.pools
        ΔsnowW ⇐ land.pools
        o_one ⇐ land.constants
    end

    ## calculate variables
    # suggested by Sujan [after HTESSEL GHM]

    frac_snow = min(o_one, sum(snowW) / snow_cover_param)

    ## pack land variables
    @pack_nt frac_snow ⇒ land.states
    return land
end

# --------------------------------------

# snowMelt_TairRn
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 18

function compute(params::snowMelt_TairRn, forcing, land, helpers)
    ## unpack parameters and forcing
    @unpack_snowMelt_TairRn params
    @unpack_nt (f_rn, f_airT) ⇐ forcing

    ## unpack land variables
    @unpack_nt begin
        (WBP, frac_snow) ⇐ land.states
        snowW ⇐ land.pools
        ΔsnowW ⇐ land.pools
        (z_zero, o_one) ⇐ land.constants
        n_snowW = snowW ⇐ helpers.pools.n_layers
    end

    # snowmelt [mm/day] is calculated as a simple function of temperature & radiation & scaled with the snow covered fraction
    tmp_T = f_airT * melt_T
    tmp_Rn = at_least_zero(f_rn * melt_Rn)
    potential_snow_melt = (tmp_T + tmp_Rn) * frac_snow

    # potential snow melt if T > 0.0 deg C
    potential_snow_melt = f_airT > z_zero ? potential_snow_melt : zero(potential_snow_melt)
    snow_melt = min(totalS(snowW, ΔsnowW), potential_snow_melt)

    # divide snowmelt loss equally from all layers
    ΔsnowW = addToEachElem(ΔsnowW, -snow_melt / n_snowW)

    # a Water Balance Pool variable that tracks how much water is still "available" | ""
    WBP = WBP + snow_melt

    ## pack land variables
    @pack_nt begin
        snow_melt ⇒ land.fluxes
        potential_snow_melt ⇒ land.fluxes
        WBP ⇒ land.states
        ΔsnowW ⇒ land.pools
    end
    return land
end

# --------------------------------------

# runoffSaturationExcess_Bergstroem1992
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 19

function compute(params::runoffSaturationExcess_Bergstroem1992, forcing, land, helpers)
    ## unpack parameters
    @unpack_runoffSaturationExcess_Bergstroem1992 params

    ## unpack land variables
    @unpack_nt begin
        WBP ⇐ land.states
        w_sat ⇐ land.properties
        soilW ⇐ land.pools
        ΔsoilW ⇐ land.pools
    end
    # @show WBP
    tmp_smax_veg = sum(w_sat)
    tmp_soilW_total = sum(soilW)
    # calculate land runoff from incoming water & current soil moisture
    tmp_sat_exc_frac = clamp_zero_one((tmp_soilW_total / tmp_smax_veg)^β)

    sat_excess_runoff = WBP * tmp_sat_exc_frac

    # update water balance pool
    WBP = WBP - sat_excess_runoff

    ## pack land variables
    @pack_nt begin
        sat_excess_runoff ⇒ land.fluxes
        WBP ⇒ land.states
    end
    return land
end

# --------------------------------------

# runoffOverland_Sat
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/runoffOverland/runoffOverland_Sat.jl
# Call order: 20

function compute(params::runoffOverland_Sat, forcing, land, helpers)

    ## unpack land variables
    @unpack_nt sat_excess_runoff ⇐ land.fluxes

    ## calculate variables
    overland_runoff = sat_excess_runoff

    ## pack land variables
    @pack_nt overland_runoff ⇒ land.fluxes
    return land
end

# --------------------------------------

# runoffSurface_all
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/runoffSurface/runoffSurface_all.jl
# Call order: 21

function compute(params::runoffSurface_all, forcing, land, helpers)

    ## unpack land variables
    @unpack_nt overland_runoff ⇐ land.fluxes

    ## calculate variables
    # all overland flow becomes surface runoff
    surface_runoff = overland_runoff

    ## pack land variables
    @pack_nt surface_runoff ⇒ land.fluxes
    return land
end

# --------------------------------------

# runoffBase_Zhang2008
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 22

function compute(params::runoffBase_Zhang2008, forcing, land, helpers)
    ## unpack parameters
    @unpack_runoffBase_Zhang2008 params

    ## unpack land variables
    @unpack_nt begin
        groundW ⇐ land.pools
        ΔgroundW ⇐ land.pools
        n_groundW = groundW ⇐ helpers.pools.n_layers
    end

    ## calculate variables
    # simply assume that a fraction of the GWstorage is baseflow
    base_runoff = k_baseflow * totalS(groundW, ΔgroundW)

    # update groundwater changes

    ΔgroundW = addToEachElem(ΔgroundW, -base_runoff / n_groundW)

    ## pack land variables
    @pack_nt begin
        base_runoff ⇒ land.fluxes
        ΔgroundW ⇒ land.pools
    end
    return land
end

# --------------------------------------

# percolation_WBP
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/percolation/percolation_WBP.jl
# Call order: 23

function compute(params::percolation_WBP, forcing, land, helpers)

    ## unpack land variables
    @unpack_nt begin
        (ΔgroundW, ΔsoilW, soilW, groundW) ⇐ land.pools
        WBP ⇐ land.states
        o_one ⇐ land.constants
        n_groundW = groundW ⇐ helpers.pools.n_layers
        tolerance ⇐ helpers.numbers
        w_sat ⇐ land.properties
    end

    # set WBP as the soil percolation
    percolation = WBP
    to_allocate = o_one * percolation
    for sl ∈ eachindex(land.pools.soilW)
        allocated = min(w_sat[sl] - (soilW[sl] + ΔsoilW[sl]), to_allocate)
        @add_to_elem allocated ⇒ (ΔsoilW, sl, :soilW)
        to_allocate = to_allocate - allocated
    end
    to_groundW = to_allocate / n_groundW
    ΔgroundW = addToEachElem(ΔgroundW, to_groundW)
    # to_groundW = abs(to_allocate)
    # ΔgroundW = addToEachElem(ΔgroundW, to_groundW / n_groundW)
    to_allocate = to_allocate - to_groundW
    WBP = to_allocate

    ## pack land variables
    @pack_nt begin
        percolation ⇒ land.fluxes
        WBP ⇒ land.states
        (ΔgroundW, ΔsoilW) ⇒ land.pools
    end
    return land
end

# --------------------------------------

# evaporation_fAPAR
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 24

function compute(params::evaporation_fAPAR, forcing, land, helpers)
    ## unpack parameters
    @unpack_evaporation_fAPAR params

    ## unpack land variables
    @unpack_nt begin
        fAPAR ⇐ land.states
        soilW ⇐ land.pools
        ΔsoilW ⇐ land.pools
        PET ⇐ land.fluxes
        (z_zero, o_one) ⇐ land.constants
    end
    # multiply equilibrium PET with αSoil & [1.0 - fAPAR] to get potential soil evap
    tmp = PET * α * (o_one - fAPAR)
    PET_evaporation = at_least_zero(tmp)
    # scale the potential with the a fraction of available water & get the minimum of the current moisture
    evaporation = min(PET_evaporation, k_evaporation * (soilW[1] + ΔsoilW[1]))

    # update soil moisture changes
    @add_to_elem -evaporation ⇒ (ΔsoilW, 1, :soilW)

    ## pack land variables
    @pack_nt begin
        PET_evaporation ⇒ land.fluxes
        evaporation ⇒ land.fluxes
        ΔsoilW ⇒ land.pools
    end
    return land
end

# --------------------------------------

# drainage_dos
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 25

function compute(params::drainage_dos, forcing, land, helpers)
    ## unpack parameters
    @unpack_drainage_dos params

    ## unpack land variables
    @unpack_nt begin
        drainage ⇐ land.fluxes
        (w_sat, soil_β, w_fc) ⇐ land.properties
        (soilW, ΔsoilW) ⇐ land.pools
        (z_zero, o_one) ⇐ land.constants
        tolerance ⇐ helpers.numbers
    end

    ## calculate drainage
    for sl ∈ 1:(length(land.pools.soilW)-1)
        soilW_sl = min(at_least_zero(soilW[sl] + ΔsoilW[sl]), w_sat[sl])
        drain_fraction = clamp_zero_one(((soilW_sl) / w_sat[sl])^(dos_exp * soil_β[sl]))
        drainage_tmp = drain_fraction * (soilW_sl)
        max_drain = w_sat[sl] - w_fc[sl]
        lossCap = min(soilW_sl, max_drain)
        holdCap = w_sat[sl+1] - (soilW[sl+1] + ΔsoilW[sl+1])
        drain = min(drainage_tmp, holdCap, lossCap)
        tmp = drain > tolerance ? drain : zero(drain)
        @rep_elem tmp ⇒ (drainage, sl, :soilW)
        @add_to_elem -tmp ⇒ (ΔsoilW, sl, :soilW)
        @add_to_elem tmp ⇒ (ΔsoilW, sl + 1, :soilW)
    end
    @rep_elem z_zero ⇒ (drainage, lastindex(drainage), :soilW)
    ## pack land variables
    @pack_nt begin
        drainage ⇒ land.fluxes
        ΔsoilW ⇒ land.pools
    end
    return land
end

# --------------------------------------

# capillaryFlow_VanDijk2010
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 26

function compute(params::capillaryFlow_VanDijk2010, forcing, land, helpers)
    ## unpack parameters
    @unpack_capillaryFlow_VanDijk2010 params

    ## unpack land variables
    @unpack_nt begin
        (k_fc, w_sat) ⇐ land.properties
        soil_capillary_flux ⇐ land.fluxes
        (soilW, ΔsoilW) ⇐ land.pools
        tolerance ⇐ helpers.numbers
        (z_zero, o_one) ⇐ land.constants
    end

    for sl ∈ 1:(length(soilW)-1)
        dos_soilW = clamp_zero_one((soilW[sl] + ΔsoilW[sl]) ./ w_sat[sl])
        tmpCapFlow = sqrt(k_fc[sl+1] * k_fc[sl]) * (o_one - dos_soilW)
        holdCap = at_least_zero(w_sat[sl] - (soilW[sl] + ΔsoilW[sl]))
        lossCap = at_least_zero(max_frac * (soilW[sl+1] + ΔsoilW[sl+1]))
        minFlow = min(tmpCapFlow, holdCap, lossCap)
        tmp = minFlow > tolerance ? minFlow : zero(minFlow)
        @rep_elem tmp ⇒ (soil_capillary_flux, sl, :soilW)
        @add_to_elem soil_capillary_flux[sl] ⇒ (ΔsoilW, sl, :soilW)
        @add_to_elem -soil_capillary_flux[sl] ⇒ (ΔsoilW, sl + 1, :soilW)
    end

    ## pack land variables
    @pack_nt begin
        soil_capillary_flux ⇒ land.fluxes
        ΔsoilW ⇒ land.pools
    end
    return land
end

# --------------------------------------

# groundWRecharge_dos
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 27

function compute(params::groundWRecharge_dos, forcing, land, helpers)
    ## unpack parameters
    @unpack_groundWRecharge_dos params

    ## unpack land variables
    @unpack_nt begin
        (w_sat, soil_β) ⇐ land.properties
        (ΔsoilW, soilW, ΔgroundW, groundW) ⇐ land.pools
        (z_zero, o_one) ⇐ land.constants
        # n_groundW ⇐ land.constants
        n_groundW = groundW ⇐ helpers.pools.n_layers
    end
    # calculate recharge
    dos_soil_end = clamp_zero_one((soilW[end] + ΔsoilW[end]) / w_sat[end])
    recharge_fraction = clamp_zero_one((dos_soil_end)^(dos_exp * soil_β[end]))
    gw_recharge = recharge_fraction * (soilW[end] + ΔsoilW[end])

    ΔgroundW = addToEachElem(ΔgroundW, gw_recharge / n_groundW)
    @add_to_elem -gw_recharge ⇒ (ΔsoilW, lastindex(ΔsoilW), :soilW)

    ## pack land variables
    @pack_nt begin
        gw_recharge ⇒ land.fluxes
        (ΔsoilW, ΔgroundW) ⇒ land.pools
    end
    return land
end

# --------------------------------------

# groundWSoilWInteraction_VanDijk2010
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 28

function compute(params::groundWSoilWInteraction_VanDijk2010, forcing, land, helpers)
    ## unpack parameters
    @unpack_groundWSoilWInteraction_VanDijk2010 params

    ## unpack land variables
    @unpack_nt begin
        (k_fc, k_sat, w_sat) ⇐ land.properties
        (ΔsoilW, ΔgroundW, groundW, soilW) ⇐ land.pools
        unsat_k_model ⇐ land.models
        (z_zero, o_one) ⇐ land.constants
        n_groundW = groundW ⇐ helpers.pools.n_layers
        gw_recharge ⇐ land.fluxes
    end

    # calculate recharge
    # degree of saturation & unsaturated hydraulic conductivity of the lowermost soil layer
    dosSoilend = clamp_zero_one((soilW[end] + ΔsoilW[end]) / w_sat[end])
    k_sat = k_sat[end] # assume GW is saturated
    k_fc = k_fc[end] # assume GW is saturated
    k_unsat = unsatK(land, helpers, lastindex(soilW), unsat_k_model)

    # get the capillary flux
    c_flux = sqrt(k_unsat * k_sat) * (o_one - dosSoilend)
    gw_capillary_flux = at_least_zero(min(c_flux, max_fraction * (sum(groundW) + sum(ΔgroundW)),
        soilW[end] + ΔsoilW[end]))

    # adjust the delta storages
    ΔgroundW = addToEachElem(ΔgroundW, -gw_capillary_flux / n_groundW)
    @add_to_elem gw_capillary_flux ⇒ (ΔsoilW, lastindex(ΔsoilW), :soilW)

    # adjust the gw_recharge as net flux between soil and groundwater. positive from soil to gw
    gw_recharge = gw_recharge - gw_capillary_flux

    ## pack land variables
    @pack_nt begin
        (gw_capillary_flux, gw_recharge) ⇒ land.fluxes
        (ΔsoilW, ΔgroundW) ⇒ land.pools
    end
    return land
end

# --------------------------------------

# vegAvailableWater_rootWaterEfficiency
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/vegAvailableWater/vegAvailableWater_rootWaterEfficiency.jl
# Call order: 29

function compute(params::vegAvailableWater_rootWaterEfficiency, forcing, land, helpers)

    ## unpack land variables
    @unpack_nt begin
        w_wp ⇐ land.properties
        root_water_efficiency ⇐ land.diagnostics
        soilW ⇐ land.pools
        ΔsoilW ⇐ land.pools
        PAW ⇐ land.states
    end
    for sl ∈ eachindex(soilW)
        PAW_sl = root_water_efficiency[sl] * (at_least_zero(soilW[sl] + ΔsoilW[sl] - w_wp[sl]))
        @rep_elem PAW_sl ⇒ (PAW, sl, :soilW)
    end

    @pack_nt PAW ⇒ land.states
    return land
end

# --------------------------------------

# transpirationSupply_wAWC
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 30

function compute(params::transpirationSupply_wAWC, forcing, land, helpers)
    ## unpack parameters
    @unpack_transpirationSupply_wAWC params

    ## unpack land variables
    @unpack_nt PAW ⇐ land.states

    ## calculate variables
    transpiration_supply = sum(PAW) * k_transpiration

    ## pack land variables
    @pack_nt transpiration_supply ⇒ land.diagnostics
    return land
end

# --------------------------------------

# gppPotential_Monteith
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 31

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
# Call order: 32

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
# Call order: 33

# --------------------------------------

# gppAirT_CASA
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 34

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
# Call order: 35

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

# gppSoilW_Stocker2020
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 36

function compute(params::gppSoilW_Stocker2020, forcing, land, helpers)
    ## unpack parameters
    @unpack_gppSoilW_Stocker2020 params

    ## unpack land variables
    @unpack_nt begin
        (∑w_fc, ∑w_wp) ⇐ land.properties
        soilW ⇐ land.pools
        (z_zero, o_one, t_two) ⇐ land.constants
    end
    ## calculate variables
    SM = sum(soilW)
    max_AWC = at_least_zero(∑w_fc - ∑w_wp)
    actAWC = at_least_zero(SM - ∑w_wp)
    SM_nor = at_most_one(actAWC / max_AWC)
    tf_soilW = -q * (SM_nor - θstar)^t_two + o_one
    tmp_f_soilW = SM_nor <= θstar ? tf_soilW : one(tf_soilW)
    gpp_f_soilW = clamp_zero_one(tmp_f_soilW)

    ## pack land variables
    @pack_nt gpp_f_soilW ⇒ land.diagnostics
    return land
end

# --------------------------------------

# gppDemand_mult
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gppDemand/gppDemand_mult.jl
# Call order: 37

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

# WUE_expVPDDayCo2
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 38

function compute(params::WUE_expVPDDayCo2, forcing, land, helpers)
    ## unpack parameters and forcing
    @unpack_WUE_expVPDDayCo2 params
    @unpack_nt f_VPD_day ⇐ forcing

    ## unpack land variables
    @unpack_nt begin
        ambient_CO2 ⇐ land.states
    end

    ## calculate variables
    WUENoCO2 = WUE_one_hpa * exp(κ * -(f_VPD_day))
    fCO2_CO2 = one(ambient_CO2) + (ambient_CO2 - base_ambient_CO2) / (ambient_CO2 - base_ambient_CO2 + sat_ambient_CO2)
    WUE = WUENoCO2 * fCO2_CO2

    ## pack land variables
    @pack_nt WUENoCO2 ⇒ land.diagnostics
    @pack_nt WUE ⇒ land.diagnostics
    return land
end

# --------------------------------------

# gpp_coupled
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/gpp/gpp_coupled.jl
# Call order: 39

function compute(params::gpp_coupled, forcing, land, helpers)

    ## unpack land variables
    @unpack_nt begin
        transpiration_supply ⇐ land.diagnostics
        gpp_f_soilW ⇐ land.diagnostics
        gpp_demand ⇐ land.diagnostics
        WUE ⇐ land.diagnostics
    end

    gpp = min(transpiration_supply * WUE, gpp_demand * gpp_f_soilW)

    ## pack land variables
    @pack_nt gpp ⇒ land.fluxes
    return land
end

# --------------------------------------

# transpiration_coupled
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/transpiration/transpiration_coupled.jl
# Call order: 40

function compute(params::transpiration_coupled, forcing, land, helpers)

    ## unpack land variables
    @unpack_nt begin
        gpp ⇐ land.fluxes
        WUE ⇐ land.diagnostics
    end
    # calculate actual transpiration coupled with GPP
    transpiration = gpp / WUE

    ## pack land variables
    @pack_nt transpiration ⇒ land.fluxes
    return land
end

# --------------------------------------

# rootWaterUptake_proportion
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/rootWaterUptake/rootWaterUptake_proportion.jl
# Call order: 41

function compute(params::rootWaterUptake_proportion, forcing, land, helpers)

    ## unpack land variables
    @unpack_nt begin
        PAW ⇐ land.states
        (soilW, ΔsoilW) ⇐ land.pools
        transpiration ⇐ land.fluxes
        root_water_uptake ⇐ land.fluxes
        (z_zero, o_one) ⇐ land.constants
        tolerance ⇐ helpers.numbers
    end
    # get the transpiration
    # to_uptake = o_one * transpiration
    PAWTotal = sum(PAW)
    to_uptake = at_least_zero(oftype(PAWTotal, transpiration))

    # extract from top to bottom
    for sl ∈ eachindex(land.pools.soilW)
        uptake_proportion = to_uptake * safe_divide(PAW[sl], PAWTotal)
        @rep_elem uptake_proportion ⇒ (root_water_uptake, sl, :soilW)
        @add_to_elem -root_water_uptake[sl] ⇒ (ΔsoilW, sl, :soilW)
    end
    # pack land variables
    @pack_nt begin
        root_water_uptake ⇒ land.fluxes
        ΔsoilW ⇒ land.pools
    end
    return land
end

# --------------------------------------

# cVegetationDieOff_forcing
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cVegetationDieOff/cVegetationDieOff_forcing.jl
# Call order: 42

function compute(params::cVegetationDieOff_forcing, forcing, land, helpers)
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

function precompute(params::cCycleBase_GSI_PlantForm_LargeKReserve, forcing, land, helpers)
    @unpack_cCycleBase_GSI_PlantForm_LargeKReserve params
    @unpack_nt begin
        (C_to_N_cVeg, c_eco_k_base, c_eco_τ, zero_c_τ_pf) ⇐ land.diagnostics
        (z_zero, o_one) ⇐ land.constants
        plant_form ⇐ land.states
    end

    c_τ_pf = zero_c_τ_pf
    ## replace values
    if plant_form == :tree
        c_τ_pf = c_τ_tree
    elseif plant_form == :shrub
        c_τ_pf = c_τ_shrub
    elseif plant_form == :herb
        c_τ_pf = c_τ_herb
    end

    c_τ_Root, c_τ_Wood, c_τ_Leaf, c_τ_Reserve = get_c_τ(c_τ_pf, params)
    # @show plant_form, c_τ_Root, c_τ_Wood, c_τ_Leaf, c_τ_Reserve, c_τ_pf
    @rep_elem c_τ_Root * c_τ_Root_scalar ⇒ (c_eco_τ, 1, :cEco)
    @rep_elem c_τ_Wood * c_τ_Wood_scalar ⇒ (c_eco_τ, 2, :cEco)
    @rep_elem c_τ_Leaf * c_τ_Leaf_scalar ⇒ (c_eco_τ, 3, :cEco)
    @rep_elem c_τ_Reserve * c_τ_Reserve_scalar ⇒ (c_eco_τ, 4, :cEco)
    @rep_elem c_τ_LitFast * c_τ_Litter_scalar ⇒ (c_eco_τ, 5, :cEco)
    @rep_elem c_τ_LitSlow * c_τ_Litter_scalar ⇒ (c_eco_τ, 6, :cEco)
    @rep_elem c_τ_SoilSlow * c_τ_Soil_scalar ⇒ (c_eco_τ, 7, :cEco)
    @rep_elem c_τ_SoilOld * c_τ_Soil_scalar ⇒ (c_eco_τ, 8, :cEco)


    vegZix = getZix(land.pools.cVeg, helpers.pools.zix.cVeg)
    for ix ∈ eachindex(vegZix)
        @rep_elem p_C_to_N_cVeg[ix] ⇒ (C_to_N_cVeg, vegZix[ix], :cEco)
    end
    for i ∈ eachindex(c_eco_k_base)
        tmp = c_eco_τ[i]
        @rep_elem tmp ⇒ (c_eco_k_base, i, :cEco)
    end

    ## pack land variables
    @pack_nt begin
        (C_to_N_cVeg, c_eco_τ, c_eco_k_base, ηA, ηH) ⇒ land.diagnostics
        c_remain ⇒ land.states
    end
    return land
end

# --------------------------------------

# cCycleDisturbance_WROASTED
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleDisturbance/cCycleDisturbance_WROASTED.jl
# Call order: 44

function compute(params::cCycleDisturbance_WROASTED, forcing, land, helpers)
    ## unpack forcing
    @unpack_nt f_dist_intensity ⇐ forcing

    ## unpack land variables
    @unpack_nt begin
        (zix_veg_all, c_lose_to_zix_vec) ⇐ land.cCycleDisturbance
        cEco ⇐ land.pools
        (c_giver, c_taker) ⇐ land.constants
        c_remain ⇐ land.states
        c_model ⇐ land.models
    end
    for zixVeg ∈ zix_veg_all
        cLoss = at_least_zero(cEco[zixVeg] - c_remain) * f_dist_intensity
        @add_to_elem -cLoss ⇒ (cEco, zixVeg, :cEco)
        c_lose_to_zix = c_lose_to_zix_vec[zixVeg]
        for tZ ∈ eachindex(c_lose_to_zix)
            tarZix = c_lose_to_zix[tZ]
            toGain = cLoss / oftype(cLoss, length(c_lose_to_zix))
            @add_to_elem toGain ⇒ (cEco, tarZix, :cEco)
        end
    end
    @pack_nt cEco ⇒ land.pools
    land = adjustPackPoolComponents(land, helpers, c_model)
    ## pack land variables
    return land
end

# --------------------------------------

# cTauSoilT_Q10
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 45

function compute(params::cTauSoilT_Q10, forcing, land, helpers)
    ## unpack parameters and forcing
    @unpack_cTauSoilT_Q10 params
    @unpack_nt f_airT ⇐ forcing

    ## calculate variables
    # CALCULATE EFFECT OF TEMPERATURE ON SOIL CARBON FLUXES
    c_eco_k_f_soilT = Q10^((f_airT - ref_airT) / Q10_base)

    ## pack land variables
    @pack_nt c_eco_k_f_soilT ⇒ land.diagnostics
    return land
end

# --------------------------------------

# cTauSoilW_GSI
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 46

function compute(params::cTauSoilW_GSI, forcing, land, helpers)
    ## unpack parameters
    @unpack_cTauSoilW_GSI params

    ## unpack land variables
    @unpack_nt c_eco_k_f_soilW ⇐ land.diagnostics

    ## unpack land variables
    @unpack_nt begin
        w_sat ⇐ land.properties
        (cEco, cLit, cSoil, soilW) ⇐ land.pools
    end
    w_one = one(eltype(soilW))
    ## for the litter pools; only use the top layer"s moisture
    soilW_top = min(frac_to_perc * soilW[1] / w_sat[1], frac_to_perc)
    soilW_top_sc = fSoilW_cTau(w_one, opt_soilW_A, opt_soilW_B, w_exp, opt_soilW, soilW_top)
    cLitZix = getZix(cLit, helpers.pools.zix.cLit)
    for l_zix ∈ cLitZix
        @rep_elem soilW_top_sc ⇒ (c_eco_k_f_soilW, l_zix, :cEco)
    end

    ## repeat for the soil pools; using all soil moisture layers
    soilW_all = min(frac_to_perc * sum(soilW) / sum(w_sat), frac_to_perc)
    soilW_all_sc = fSoilW_cTau(w_one, opt_soilW_A, opt_soilW_B, w_exp, opt_soilW, soilW_all)

    cSoilZix = getZix(cSoil, helpers.pools.zix.cSoil)
    for s_zix ∈ cSoilZix
        @rep_elem soilW_all_sc ⇒ (c_eco_k_f_soilW, s_zix, :cEco)
    end

    ## pack land variables
    @pack_nt c_eco_k_f_soilW ⇒ land.diagnostics
    return land
end

# --------------------------------------

# cTauLAI_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauLAI/cTauLAI_none.jl
# Call order: 47

# --------------------------------------

# cTauSoilProperties_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauSoilProperties/cTauSoilProperties_none.jl
# Call order: 48

# --------------------------------------

# cTauVegProperties_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTauVegProperties/cTauVegProperties_none.jl
# Call order: 49

# --------------------------------------

# cTau_mult
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cTau/cTau_mult.jl
# Call order: 50

function compute(params::cTau_mult, forcing, land, helpers)
    ## unpack land variables
    @unpack_nt begin
        c_eco_k_f_veg_props ⇐ land.diagnostics
        c_eco_k_f_soilW ⇐ land.diagnostics
        c_eco_k_f_soilT ⇐ land.diagnostics
        c_eco_k_f_soil_props ⇐ land.diagnostics
        c_eco_k_f_LAI ⇐ land.diagnostics
        c_eco_k_base ⇐ land.diagnostics
        c_eco_k ⇐ land.diagnostics
    end
    for i ∈ eachindex(c_eco_k)
        tmp = c_eco_k_base[i] * c_eco_k_f_LAI[i] * c_eco_k_f_soil_props[i] * c_eco_k_f_veg_props[i] * c_eco_k_f_soilT * c_eco_k_f_soilW[i]
        tmp = clamp_zero_one(tmp)
        @rep_elem tmp ⇒ (c_eco_k, i, :cEco)
    end

    ## pack land variables
    @pack_nt c_eco_k ⇒ land.diagnostics
    return land
end

# --------------------------------------

# autoRespirationAirT_Q10
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 51

function compute(params::autoRespirationAirT_Q10, forcing, land, helpers)
    ## unpack parameters and forcing
    @unpack_autoRespirationAirT_Q10 params
    @unpack_nt f_airT ⇐ forcing

    ## calculate variables
    auto_respiration_f_airT = Q10^((f_airT - ref_airT) / Q10_base)

    ## pack land variables
    @pack_nt begin
        auto_respiration_f_airT ⇒ land.diagnostics
    end
    return land
end

# --------------------------------------

# cAllocationLAI_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocationLAI/cAllocationLAI_none.jl
# Call order: 52

# --------------------------------------

# cAllocationRadiation_RgPot
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocationRadiation/cAllocationRadiation_RgPot.jl
# Call order: 53

function compute(params::cAllocationRadiation_RgPot, forcing, land, helpers)
    @unpack_nt begin
		f_rg_pot ⇐ forcing
		rg_pot_max ⇐ land.cAllocationRadiation
	end

	rg_pot_max = max(rg_pot_max, f_rg_pot)

	c_allocation_f_cloud = f_rg_pot / rg_pot_max

	@pack_nt begin
		c_allocation_f_cloud ⇒ land.diagnostics
		rg_pot_max ⇒ land.diagnostics
	end 
	return land
end

# --------------------------------------

# cAllocationSoilW_gpp
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocationSoilW/cAllocationSoilW_gpp.jl
# Call order: 54

function compute(params::cAllocationSoilW_gpp, forcing, land, helpers)

    ## unpack land variables
    @unpack_nt gpp_f_soilW ⇐ land.diagnostics

    ## calculate variables
    # computation for the moisture effect on decomposition/mineralization
    c_allocation_f_soilW = gpp_f_soilW

    ## pack land variables
    @pack_nt c_allocation_f_soilW ⇒ land.diagnostics
    return land
end

# --------------------------------------

# cAllocationSoilT_gpp
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocationSoilT/cAllocationSoilT_gpp.jl
# Call order: 55

function compute(params::cAllocationSoilT_gpp, forcing, land, helpers)

    ## unpack land variables
    @unpack_nt gpp_f_airT ⇐ land.diagnostics

    ## calculate variables
    # computation for the temperature effect on decomposition/mineralization
    c_allocation_f_soilT = gpp_f_airT

    ## pack land variables
    @pack_nt c_allocation_f_soilT ⇒ land.diagnostics
    return land
end

# --------------------------------------

# cAllocationNutrients_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocationNutrients/cAllocationNutrients_none.jl
# Call order: 56

# --------------------------------------

# cAllocation_GSI
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cAllocation/cAllocation_GSI.jl
# Call order: 57

function compute(params::cAllocation_GSI, forcing, land, helpers)

    ## unpack land variables
    @unpack_nt begin
        (cVeg_names, cVeg_zix, cVeg_nzix, c_allocation_to_veg) ⇐ land.cAllocation
        c_allocation ⇐ land.diagnostics
        c_allocation_f_soilW ⇐ land.diagnostics
        c_allocation_f_soilT ⇐ land.diagnostics
        t_two ⇐ land.constants
    end
    c_two = one(c_allocation_f_soilT) + one(c_allocation_f_soilT)
    # allocation to root; wood & leaf
    a_cVegLeaf = c_allocation_f_soilW / ((c_allocation_f_soilW + c_allocation_f_soilT) * c_two)
    a_cVegWood = c_allocation_f_soilW / ((c_allocation_f_soilW + c_allocation_f_soilT) * c_two)
    a_cVegRoot = c_allocation_f_soilT / ((c_allocation_f_soilW + c_allocation_f_soilT))

    # @needscheck. from semda l and w are allocated more when there is no water stress
    # % change a2L a2R a2W according to DAS components...
    #     a2L = DASW./(DASW+DAST)./2;
    #     a2W = DASW./(DASW+DAST)./2;
    #     a2R = DAST./(DASW+DAST);

    @rep_elem a_cVegRoot ⇒ (c_allocation_to_veg, 1, :cEco)
    @rep_elem a_cVegWood ⇒ (c_allocation_to_veg, 2, :cEco)
    @rep_elem a_cVegLeaf ⇒ (c_allocation_to_veg, 3, :cEco)

    # distribute the allocation according to pools
    for cl in eachindex(cVeg_names)
        zix = cVeg_zix[cl]
        nZix = cVeg_nzix[cl]
        for ix ∈ zix
            c_allocation_to_veg_ix = c_allocation_to_veg[cl] / nZix
            @rep_elem c_allocation_to_veg_ix ⇒ (c_allocation, ix, :cEco)
        end
    end

    @pack_nt c_allocation ⇒ land.diagnostics

    return land
end

# --------------------------------------

# cAllocationTreeFraction_Friedlingstein1999
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 58

function compute(params::cAllocationTreeFraction_Friedlingstein1999, forcing, land, helpers)
    ## unpack parameters
    @unpack_cAllocationTreeFraction_Friedlingstein1999 params

    ## unpack land variables
    @unpack_nt begin
        frac_tree ⇐ land.states
        c_allocation ⇐ land.diagnostics
        cVeg_names_for_c_allocation_frac_tree ⇐ land.cAllocationTreeFraction
        (z_zero, o_one) ⇐ land.constants
    end
    # the allocation fractions according to the partitioning to root/wood/leaf - represents plant level allocation
    r0 = z_zero
    for ix ∈ getZix(land.pools.cVegRoot, helpers.pools.zix.cVegRoot)
        r0 = r0 + c_allocation[ix]
    end
    s0 = z_zero
    for ix ∈ getZix(land.pools.cVegWood, helpers.pools.zix.cVegWood)
        s0 = s0 + c_allocation[ix]
    end
    l0 = z_zero
    for ix ∈ getZix(land.pools.cVegLeaf, helpers.pools.zix.cVegLeaf)
        l0 = l0 + c_allocation[ix]
    end     # this is to below ground root fine+coarse

    # adjust for spatial consideration of TreeFrac & plant level
    # partitioning between fine & coarse roots
    o_one = one(eltype(c_allocation))
    a_cVegWood = frac_tree
    a_cVegRoot = o_one + (s0 / (r0 + l0)) * (o_one - frac_tree)
    a_cVegRootF = a_cVegRoot * (frac_fine_to_coarse * frac_tree + (o_one - frac_tree))
    a_cVegRootC = a_cVegRoot * (o_one - frac_fine_to_coarse) * frac_tree
    # cVegRoot = cVegRootF + cVegRootC
    a_cVegLeaf = o_one + (s0 / (r0 + l0)) * (o_one - frac_tree)

    c_allocation = setCAlloc(c_allocation, a_cVegWood, land.pools.cVegWood, helpers.pools.zix.cVegWood, helpers)
    if hasproperty(cVeg_names_for_c_allocation_frac_tree, :cVegRootC)
        c_allocation = setCAlloc(c_allocation, a_cVegRootC, land.pools.cVegRootC, helpers.pools.zix.cVegRootC,
            helpers)
        c_allocation = setCAlloc(c_allocation, a_cVegRootF, land.pools.cVegRootF, helpers.pools.zix.cVegRootF,
            helpers)
    else
        c_allocation = setCAlloc(c_allocation, a_cVegRoot, land.pools.cVegRoot, helpers.pools.zix.cVegRoot,
            helpers)
    end

    c_allocation = setCAlloc(c_allocation, a_cVegLeaf, land.pools.cVegLeaf, helpers.pools.zix.cVegLeaf, helpers)

    @pack_nt c_allocation ⇒ land.diagnostics

    return land
end

# --------------------------------------

# autoRespiration_Thornley2000A
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 59

function compute(params::autoRespiration_Thornley2000A, forcing, land, helpers)
    ## unpack parameters
    @unpack_autoRespiration_Thornley2000A params

    ## unpack land variables
    @unpack_nt begin
        (k_respiration_maintain, k_respiration_maintain_su) ⇐ land.diagnostics
        (c_eco_efflux, auto_respiration_growth, auto_respiration_maintain) ⇐ land.fluxes
        (cEco, cVeg) ⇐ land.pools
        gpp ⇐ land.fluxes
        C_to_N_cVeg ⇐ land.diagnostics
        (c_allocation, auto_respiration_f_airT) ⇐ land.diagnostics
    end
    # adjust nitrogen efficiency rate of maintenance respiration to the current
    # model time step
    zix = getZix(cVeg, helpers.pools.zix.cVeg)
    for ix ∈ zix

        # compute maintenance & growth respiration terms for each vegetation pool
        # according to MODEL A - maintenance respiration is given priority

        # scalars of maintenance respiration for models A; B & C
        # km is the maintenance respiration coefficient [d-1]
        k_respiration_maintain_ix = at_most_one(one(eltype(C_to_N_cVeg)) / C_to_N_cVeg[ix] * RMN * auto_respiration_f_airT)
        k_respiration_maintain_su_ix = k_respiration_maintain[ix] * YG

        # maintenance respiration first: R_m = km * C
        RA_M_ix = k_respiration_maintain_ix * cEco[ix]
        # no negative maintenance respiration
        RA_M_ix = at_least_zero(RA_M_ix)

        #TODO: check if this is correct
        # if helpers.pools.components.cEco[ix] == :cVegReserve
        #     if (cEco[ix] - RA_M_ix) < land.states.c_remain
        #         RA_M_ix = zero(RA_M_ix)
        #     end
        # end


        # growth respiration: R_g = (1.0 - YG) * (GPP * allocationToPool - R_m)
        RA_G_ix = (one(YG) - YG) * (gpp * c_allocation[ix] - RA_M_ix)

        # no negative growth respiration
        RA_G_ix = at_least_zero(RA_G_ix)

        # total respiration per pool: R_a = R_m + R_g
        cEcoEfflux_ix = RA_M_ix + RA_G_ix
        @rep_elem cEcoEfflux_ix ⇒ (c_eco_efflux, ix, :cEco)
        @rep_elem k_respiration_maintain_ix ⇒ (k_respiration_maintain, ix, :cEco)
        @rep_elem k_respiration_maintain_su_ix ⇒ (k_respiration_maintain_su, ix, :cEco)
        @rep_elem RA_M_ix ⇒ (auto_respiration_maintain, ix, :cEco)
        @rep_elem RA_G_ix ⇒ (auto_respiration_growth, ix, :cEco)
    end
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

# --------------------------------------

# cFlowVegProperties_none
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cFlowVegProperties/cFlowVegProperties_none.jl
# Call order: 61

# --------------------------------------

# cFlow_GSI
# /Users/xshan/.julia/packages/Parameters/MK0O4/src/Parameters.jl
# Call order: 62

function compute(params::cFlow_GSI, forcing, land, helpers)
    ## unpack parameters
    @unpack_cFlow_GSI params
    ## unpack land variables
    @unpack_nt begin
        c_flow_A_vec_ind ⇐ land.cFlow
        (c_allocation_f_soilW, c_allocation_f_soilT, c_allocation_f_cloud, eco_stressor_prev, slope_eco_stressor_prev)  ⇐ land.diagnostics
        c_eco_k ⇐ land.diagnostics
        c_flow_A_vec ⇐ land.diagnostics
    end

    # Compute sigmoid functions
    # LPJ-GSI formulation: In GSI; the stressors are smoothened per control variable. That means; gppfsoilW; fTair; and fRdiff should all have a GSI approach for 1:1 conversion. For now; the function below smoothens the combined stressors; & then calculates the slope for allocation
    # current time step before smoothing
    # attention, the stressors are to be interepreted like this: 
    
    #   high stressor (close to 1) means actually low stress
    #   low stressor (close to 0) means actually high stress
    # this is counterintuitive, but it is how the GSI formulation works

    eco_stressor = c_allocation_f_soilW * c_allocation_f_soilT * c_allocation_f_cloud

    # get the smoothened stressor based on contribution of previous steps using ARMA-like formulation
    slope_eco_stressor_now = eco_stressor - eco_stressor_prev

    
    slope_eco_stressor = (one(f_τ) - f_τ) * slope_eco_stressor_prev + f_τ * slope_eco_stressor_now


    # calculate the flow rate for exchange with reserve pools based on the slopes
    # get the flow & shedding rates
    leaf_root_to_reserve = at_most_one(at_least_zero(-slope_eco_stressor) * slope_leaf_root_to_reserve) # number when negative (increasing stress; decreasing stressor), 0 when positive
    reserve_to_leaf_root = at_most_one(at_least_zero(slope_eco_stressor) * slope_reserve_to_leaf_root) # number when positive, 0 when negative
    shedding_rate = at_most_one(at_least_zero(-slope_eco_stressor) * k_shedding) # number when negative, 0 when positive


    # set the Leaf & Root to Reserve flow rate as the same
    leaf_to_reserve = leaf_root_to_reserve # should it be divided by 2?
    root_to_reserve = leaf_root_to_reserve
    #todo this is needed to make sure that the flow out of Leaf or root does not exceed one. was not needed in matlab version, but reaches this point often in julia, when the eco_stressor suddenly drops from 1 to near zero.
    k_shedding_leaf = min(shedding_rate, one(leaf_to_reserve) - leaf_to_reserve)
    k_shedding_root = min(shedding_rate, one(root_to_reserve) - root_to_reserve)

    # Estimate flows from reserve to leaf & root (sujan modified on
    Re2L_i = zero(slope_leaf_root_to_reserve)
    if c_allocation_f_soilW + c_allocation_f_cloud !== Re2L_i
        Re2L_i = reserve_to_leaf_root * (c_allocation_f_soilW / (c_allocation_f_cloud + c_allocation_f_soilW)) # if water stressor is high, , larger fraction of reserve goes to the leaves for light acquisition
    end
    Re2R_i = reserve_to_leaf_root * (one(Re2L_i) - Re2L_i) # if light stressor is high (=sufficient light), larger fraction of reserve goes to the root for water uptake

    # adjust the outflow rate from the flow pools
    c_eco_k, c_eco_k_f_sum = adjust_pk(c_eco_k, k_shedding_leaf, leaf_to_reserve, one(leaf_to_reserve), helpers.pools.zix.cVegLeaf, helpers)
    leaf_to_reserve_frac = safe_divide(leaf_to_reserve, c_eco_k_f_sum)
    k_shedding_leaf_frac = safe_divide(k_shedding_leaf, c_eco_k_f_sum)

    c_eco_k, c_eco_k_f_sum = adjust_pk(c_eco_k, k_shedding_root, root_to_reserve, one(root_to_reserve), helpers.pools.zix.cVegRoot, helpers)
    root_to_reserve_frac = safe_divide(root_to_reserve, c_eco_k_f_sum)
    k_shedding_root_frac = safe_divide(k_shedding_root, c_eco_k_f_sum)

    c_eco_k, c_eco_k_f_sum = adjust_pk(c_eco_k, Re2L_i, Re2R_i, one(Re2R_i), helpers.pools.zix.cVegReserve, helpers)
    reserve_to_leaf_frac = safe_divide(Re2L_i, c_eco_k_f_sum)
    reserve_to_root_frac = safe_divide(Re2R_i, c_eco_k_f_sum)

    c_flow_A_vec = repElem(c_flow_A_vec, reserve_to_leaf_frac, c_flow_A_vec, c_flow_A_vec, c_flow_A_vec_ind.reserve_to_leaf)
    c_flow_A_vec = repElem(c_flow_A_vec, reserve_to_root_frac, c_flow_A_vec, c_flow_A_vec, c_flow_A_vec_ind.reserve_to_root)
    c_flow_A_vec = repElem(c_flow_A_vec, leaf_to_reserve_frac, c_flow_A_vec, c_flow_A_vec, c_flow_A_vec_ind.leaf_to_reserve)
    c_flow_A_vec = repElem(c_flow_A_vec, root_to_reserve_frac, c_flow_A_vec, c_flow_A_vec, c_flow_A_vec_ind.root_to_reserve)
    c_flow_A_vec = repElem(c_flow_A_vec, k_shedding_leaf_frac, c_flow_A_vec, c_flow_A_vec, c_flow_A_vec_ind.k_shedding_leaf)
    c_flow_A_vec = repElem(c_flow_A_vec, k_shedding_root_frac, c_flow_A_vec, c_flow_A_vec, c_flow_A_vec_ind.k_shedding_root)

    # store the varibles in diagnostic structure
    leaf_to_reserve = leaf_root_to_reserve # should it be divided by 2?
    k_shedding_leaf = shedding_rate
    k_shedding_root = shedding_rate
    reserve_to_leaf = reserve_to_leaf_frac
    reserve_to_root = reserve_to_root_frac
    leaf_to_reserve_frac = leaf_to_reserve_frac # should it be divided by 2?

    eco_stressor_prev = eco_stressor
    slope_eco_stressor_prev = slope_eco_stressor

    ## pack land variables
    @pack_nt begin
        (leaf_to_reserve, leaf_to_reserve_frac, root_to_reserve, root_to_reserve_frac, reserve_to_leaf, reserve_to_leaf_frac, reserve_to_root, reserve_to_root_frac, eco_stressor, k_shedding_leaf, k_shedding_leaf_frac, k_shedding_root, k_shedding_root_frac, slope_eco_stressor, eco_stressor_prev, slope_eco_stressor_prev, c_eco_k) ⇒ land.diagnostics
        c_flow_A_vec ⇒ land.diagnostics
    end
    return land
end

# --------------------------------------

# cCycleConsistency_simple
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycleConsistency/cCycleConsistency_simple.jl
# Call order: 63

function compute(params::cCycleConsistency_simple, forcing, land, helpers)
    checkCcycleErrors(params, forcing, land, helpers, helpers.run.catch_model_errors)
    return land
end

# --------------------------------------

# cCycle_GSI
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cCycle/cCycle_GSI.jl
# Call order: 64

function compute(params::cCycle_GSI, forcing, land, helpers)

    ## unpack land variables
    @unpack_nt begin
        (c_allocation, c_eco_k, c_flow_A_vec) ⇐ land.diagnostics
        (c_eco_efflux, c_eco_flow, c_eco_influx, c_eco_out, c_eco_npp, zero_c_eco_flow, zero_c_eco_influx) ⇐ land.fluxes
        (cEco, cVeg, ΔcEco) ⇐ land.pools
        cEco_prev ⇐ land.states
        gpp ⇐ land.fluxes
        (c_flow_order, c_giver, c_taker) ⇐ land.constants
        c_model ⇐ land.models
    end
    ## reset ecoflow and influx to be zero at every time step
    @rep_vec c_eco_flow ⇒ helpers.pools.zeros.cEco
    @rep_vec c_eco_influx ⇒ helpers.pools.zeros.cEco
    # @rep_vec ΔcEco ⇒ ΔcEco .* z_zero

    ## compute losses
    for cl ∈ eachindex(cEco)
        c_eco_out_cl = min(cEco[cl], cEco[cl] * c_eco_k[cl])
        @rep_elem c_eco_out_cl ⇒ (c_eco_out, cl, :cEco)
    end

    ## gains to vegetation
    for zv ∈ getZix(cVeg, helpers.pools.zix.cVeg)
        c_eco_npp_zv = gpp * c_allocation[zv] - c_eco_efflux[zv]
        @rep_elem c_eco_npp_zv ⇒ (c_eco_npp, zv, :cEco)
        @rep_elem c_eco_npp_zv ⇒ (c_eco_influx, zv, :cEco)
    end

    # flows & losses
    # @nc; if flux order does not matter; remove# sujanq: this was deleted by simon in the version of 2020-11. Need to
    # find out why. Led to having zeros in most of the carbon pools of the
    # explicit simple
    # old before cleanup was removed during biomascat when cFlowAct was changed to gsi. But original cFlowAct CASA was writing c_flow_order. So; in biomascat; the fields do not exist & this block of code will not work.
    for fO ∈ c_flow_order
        take_r = c_taker[fO]
        give_r = c_giver[fO]
        tmp_flow = c_eco_flow[take_r] + c_eco_out[give_r] * c_flow_A_vec[fO]
        @rep_elem tmp_flow ⇒ (c_eco_flow, take_r, :cEco)
    end
    # for jix = 1:length(p_taker)
    # c_taker = p_taker[jix]
    # c_giver = p_giver[jix]
    # c_flow = c_flow_A_vec(c_taker, c_giver)
    # take_flow = c_eco_flow[c_taker]
    # give_flow = c_eco_out[c_giver]
    # c_eco_flow[c_taker] = take_flow + give_flow * c_flow
    # end
    ## balance
    for cl ∈ eachindex(cEco)
        ΔcEco_cl = c_eco_flow[cl] + c_eco_influx[cl] - c_eco_out[cl]
        @add_to_elem ΔcEco_cl ⇒ (ΔcEco, cl, :cEco)
        cEco_cl = cEco[cl] + c_eco_flow[cl] + c_eco_influx[cl] - c_eco_out[cl]
        @rep_elem cEco_cl ⇒ (cEco, cl, :cEco)
    end

    ## compute RA & RH
    npp = totalS(c_eco_npp)
    backNEP = totalS(cEco) - totalS(cEco_prev)
    auto_respiration = gpp - npp
    eco_respiration = gpp - backNEP
    hetero_respiration = eco_respiration - auto_respiration
    nee = eco_respiration - gpp

    # cEco_prev = cEco 
    # cEco_prev = cEco_prev .*z_zero.+ cEco
    @rep_vec cEco_prev ⇒ cEco
    @pack_nt cEco ⇒ land.pools

    land = adjustPackPoolComponents(land, helpers, c_model)
    # setComponentFromMainPool(land, helpers, helpers.pools.vals.self.cEco, helpers.pools.vals.all_components.cEco, helpers.pools.vals.zix.cEco)

    ## pack land variables
    @pack_nt begin
        (nee, npp, auto_respiration, eco_respiration, hetero_respiration) ⇒ land.fluxes
        (c_eco_efflux, c_eco_flow, c_eco_influx, c_eco_out, c_eco_npp) ⇒ land.fluxes
        cEco_prev ⇒ land.states
        ΔcEco ⇒ land.pools
    end
    return land
end

# --------------------------------------

# evapotranspiration_sum
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/evapotranspiration/evapotranspiration_sum.jl
# Call order: 65

function compute(params::evapotranspiration_sum, forcing, land, helpers)

    ## unpack land variables
    @unpack_nt (evaporation, interception, sublimation, transpiration) ⇐ land.fluxes

    ## calculate variables
    evapotranspiration = interception + transpiration + evaporation + sublimation

    ## pack land variables
    @pack_nt evapotranspiration ⇒ land.fluxes
    return land
end

# --------------------------------------

# runoff_sum
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/runoff/runoff_sum.jl
# Call order: 66

function compute(params::runoff_sum, forcing, land, helpers)

    ## unpack land variables
    @unpack_nt (base_runoff, surface_runoff) ⇐ land.fluxes

    ## calculate variables
    runoff = surface_runoff + base_runoff

    ## pack land variables
    @pack_nt runoff ⇒ land.fluxes
    return land
end

# --------------------------------------

# wCycle_components
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/wCycle/wCycle_components.jl
# Call order: 67

function compute(params::wCycle_components, forcing, land, helpers)
    ## unpack variables
    @unpack_nt begin
        (groundW, snowW, soilW, surfaceW, TWS) ⇐ land.pools
        (ΔgroundW, ΔsnowW, ΔsoilW, ΔsurfaceW, ΔTWS) ⇐ land.pools
        zix ⇐ helpers.pools
        (z_zero, o_one) ⇐ land.constants
        w_model ⇐ land.models
    end
    total_water_prev = totalS(soilW) + totalS(groundW) + totalS(surfaceW) + totalS(snowW)

    ## update variables
    groundW = addVec(groundW, ΔgroundW)
    snowW = addVec(snowW, ΔsnowW)
    soilW = addVec(soilW, ΔsoilW)
    surfaceW = addVec(surfaceW, ΔsurfaceW)

    # setMainFromComponentPool(land, helpers, helpers.pools.vals.self.TWS, helpers.pools.vals.all_components.TWS, helpers.pools.vals.zix.TWS)

    # always pack land tws before calling the adjust method
    @pack_nt begin
        (groundW, snowW, soilW, surfaceW, TWS) ⇒ land.pools
    end

    land = adjustPackMainPool(land, helpers, w_model)

    # reset moisture changes to zero
    for l in eachindex(ΔsnowW)
        @rep_elem zero(eltype(ΔsnowW)) ⇒ (ΔsnowW, l, :snowW)
    end
    for l in eachindex(ΔsoilW)
        @rep_elem zero(eltype(ΔsoilW)) ⇒ (ΔsoilW, l, :soilW)
    end
    for l in eachindex(ΔgroundW)
        @rep_elem zero(eltype(ΔgroundW)) ⇒ (ΔgroundW, l, :groundW)
    end
    for l in eachindex(ΔsurfaceW)
        @rep_elem zero(eltype(ΔsurfaceW)) ⇒ (ΔsurfaceW, l, :surfaceW)
    end

    total_water = totalS(soilW) + totalS(groundW) + totalS(surfaceW) + totalS(snowW)

    ## pack land variables
    @pack_nt begin
        (ΔgroundW, ΔsnowW, ΔsoilW, ΔsurfaceW) ⇒ land.pools
        (total_water, total_water_prev) ⇒ land.states
    end
    return land
end

# --------------------------------------

# waterBalance_simple
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/waterBalance/waterBalance_simple.jl
# Call order: 68

function compute(params::waterBalance_simple, forcing, land, helpers)
    @unpack_nt begin
        precip ⇐ land.fluxes
        (total_water_prev, total_water, WBP) ⇐ land.states
        (evapotranspiration, runoff) ⇐ land.fluxes
        tolerance ⇐ helpers.numbers
    end

    ## calculate variables
    dS = total_water - total_water_prev
    water_balance = precip - runoff - evapotranspiration - dS

    checkWaterBalanceError(forcing, land, water_balance, tolerance, total_water, total_water_prev, WBP, precip, runoff, evapotranspiration, helpers.run.catch_model_errors)

    ## pack land variables
    @pack_nt water_balance ⇒ land.diagnostics
    return land
end

# --------------------------------------

# cBiomass_treeGrass_cVegReserveScaling
# /Users/xshan/.julia/packages/SindbadTEM/HHgVk/src/Processes/cBiomass/cBiomass_treeGrass_cVegReserveScaling.jl
# Call order: 69

function compute(params::cBiomass_treeGrass_cVegReserveScaling, forcing, land, helpers)
    @unpack_nt (cVegWood, cVegLeaf, cVegReserve, cVegRoot) ⇐ land.pools
    @unpack_nt frac_tree ⇐ land.states

    ## calculate variables    
    cVegLeaf_sum = totalS(cVegLeaf)
    cVegWood_sum = totalS(cVegWood)
    cVegReserve_sum = totalS(cVegReserve)
    cVegRoot_sum = totalS(cVegRoot)
    aboveground_biomass = (cVegWood_sum + cVegLeaf_sum) + cVegReserve_sum * (cVegWood_sum + cVegLeaf_sum) / (cVegWood_sum + cVegLeaf_sum + cVegRoot_sum)

	
    aboveground_biomass = frac_tree > zero(frac_tree) ? aboveground_biomass : cVegWood_sum

    @pack_nt begin
        aboveground_biomass ⇒ land.states
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

    