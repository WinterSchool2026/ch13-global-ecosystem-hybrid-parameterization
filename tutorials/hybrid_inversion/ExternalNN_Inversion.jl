using Revise
using Flux
using JLD2
using ForwardDiff
using SindbadTutorials
using SindbadTutorials.SindbadTEM
using SindbadTutorials.Plots
using Sindbad.MachineLearning
using Sindbad.MachineLearning.Random
import SindbadTutorials.SindbadTEM.Processes: define, precompute, compute

# Extend define for gppAirT_externalNN
function define(params::gppAirT_externalNN, forcing, land, helpers)
    @unpack_nt (o_one, z_zero) ⇐ land.constants
    model           = nothing
    μ_x             = zeros(Float32, 7)
    σ_x             = ones(Float32, 7)
    μ_y             = z_zero
    σ_y             = o_one
    input_list      = Vector{String}(undef, 0)
    sensitivity     = o_one
    @pack_nt model      ⇒ land.gppAirT
    @pack_nt μ_x        ⇒ land.gppAirT
    @pack_nt σ_x        ⇒ land.gppAirT
    @pack_nt μ_y        ⇒ land.gppAirT
    @pack_nt σ_y        ⇒ land.gppAirT
    @pack_nt input_list ⇒ land.gppAirT
    @pack_nt sensitivity ⇒ land.diagnostics
    return land
end

# Extend precompute for gppAirT_externalNN
function precompute(params::gppAirT_externalNN, forcing, land, helpers)
    checkpoint  = load(joinpath(@__DIR__, "../../gpp_model.jld2"))
    input_list  = checkpoint["input_list"]
    F_loaded    = length(input_list)
    model       = Chain(Dense(F_loaded => 64, relu), Dense(64 => 32, relu), Dense(32 => 1))

    # here model weights are stored in checkpoint["model_state"]
    Flux.loadmodel!(model, checkpoint["model_state"])
    μ_x         = Float32.(checkpoint["μ_x"])
    σ_x         = Float32.(checkpoint["σ_x"])
    μ_y         = Float32(checkpoint["μ_y"])
    σ_y         = Float32(checkpoint["σ_y"])
    tair_name = "TA_DayTime_ERAIv2_gfld"
    abs_sens_lo = Float32(checkpoint["abs_sens_lo"])
    abs_sens_hi = Float32(checkpoint["abs_sens_hi"])

    @pack_nt tair_name    ⇒ land.gppAirT
    @pack_nt model        ⇒ land.gppAirT
    @pack_nt μ_x          ⇒ land.gppAirT
    @pack_nt σ_x          ⇒ land.gppAirT
    @pack_nt μ_y          ⇒ land.gppAirT
    @pack_nt σ_y          ⇒ land.gppAirT
    @pack_nt input_list   ⇒ land.gppAirT
    @pack_nt abs_sens_lo  ⇒ land.gppAirT
    @pack_nt abs_sens_hi  ⇒ land.gppAirT
    return land
end

# Extend compute for gppAirT_externalNN
function compute(params::gppAirT_externalNN, forcing, land, helpers)
    @unpack_nt model        ⇐ land.gppAirT
    @unpack_nt μ_x          ⇐ land.gppAirT
    @unpack_nt σ_x          ⇐ land.gppAirT
    @unpack_nt input_list   ⇐ land.gppAirT
    @unpack_nt abs_sens_lo  ⇐ land.gppAirT
    @unpack_nt abs_sens_hi  ⇐ land.gppAirT
    @unpack_nt (o_one, z_zero) ⇐ land.constants
    @unpack_nt tair_name     ⇐ land.gppAirT
    @unpack_nt f_airT_day    ⇐ forcing

    tair_idx  = findfirst(==(tair_name), input_list)
    x = zeros(Float32, length(input_list))
    for (i, name) in enumerate(input_list)
        if haskey(forcing, Symbol(name))
            x[i] = Float32(forcing[Symbol(name)])
        else
            x[i] = z_zero
        end
    end
    x_n = vec((x .- μ_x) ./ σ_x)
    # Use f_airT_day from forcing, normalize it
    tair_raw = f_airT_day
    tair_n = (tair_raw - μ_x[tair_idx]) / σ_x[tair_idx]
    function gpp_vs_tair(tair_n_val::T) where T<:Real
        x_t = Vector{T}(x_n)
        x_t[tair_idx] = tair_n_val
        return only(model(x_t))
    end
    sens = abs(ForwardDiff.derivative(gpp_vs_tair, tair_n))
    sens_norm = (sens - abs_sens_lo) / (abs_sens_hi - abs_sens_lo)
    gpp_f_airT = clamp(sens_norm, z_zero, o_one)
    @pack_nt gpp_f_airT ⇒ land.diagnostics
    return land
end

# --- Experiment setup ---
selected_site_indices = getSiteIndicesForHybrid()
do_random = 0
if do_random > 0
    Random.seed!(1234)
    selected_site_indices = first(shuffle(selected_site_indices), do_random)
end

path_experiment_json = joinpath(@__DIR__, "..", "setups", "WROASTED_HB", "experiment_hybrid.json")
path_setups = joinpath(@__DIR__, "..", "setups", "WROASTED_HB")
path_output = ""

function build_replace_info(model_structure_file, optimization_file; experiment_name)
    return Dict(
        "forcing.subset.site" => selected_site_indices,
        "experiment.basics.name" => experiment_name,
        "experiment.model_output.path" => path_output,
        "experiment.basics.config_files.model_structure" => joinpath(path_setups, model_structure_file),
        "experiment.basics.config_files.optimization" => joinpath(path_setups, optimization_file),
        "optimization.optimization_cost_threaded" => false,
        "optimization.optimization_parameter_scaling" => nothing,
        "hybrid.ml_training.fold_path" => nothing,
    )
end

function load_experiment(model_structure_file, optimization_file; experiment_name)
    replace_info = build_replace_info(model_structure_file, optimization_file; experiment_name=experiment_name)
    info = getExperimentInfo(path_experiment_json; replace_info=deepcopy(replace_info))
    forcing = getForcing(info)
    observations = getObservation(info, forcing.helpers)
    hybrid_helpers = prepHybrid(forcing, observations, info, info.hybrid.ml_training.method)
    return info, forcing, observations, hybrid_helpers
end

function run_model_param(info, forcing, observations, site_index, loc_params)
    run_helpers = prepTEM(info.models.forward, forcing, observations, info)
    params = loc_params
    selected_models = info.models.forward
    parameter_scaling_type = info.optimization.run_options.parameter_scaling
    tbl_params = info.optimization.parameter_table
    param_to_index = getParameterIndices(selected_models, tbl_params)
    models = updateModels(params, param_to_index, parameter_scaling_type, selected_models)
    loc_forcing = run_helpers.space_forcing[site_index]
    loc_spinup_forcing = run_helpers.space_spinup_forcing[site_index]
    loc_forcing_t = run_helpers.loc_forcing_t
    loc_output = getCacheFromOutput(run_helpers.space_output[site_index], info.hybrid.ml_gradient.method)
    gradient_lib = info.hybrid.ml_gradient.method
    loc_output_from_cache = getOutputFromCache(loc_output, params, gradient_lib)
    land_init = deepcopy(run_helpers.loc_land)
    tem_info = run_helpers.tem_info
    loc_obs = run_helpers.space_observation[site_index]
    loc_cost_option = prepCostOptions(loc_obs, info.optimization.cost_options)
    constraint_method = info.optimization.run_options.multi_constraint_method
    coreTEM!(
        models,
        loc_forcing,
        loc_spinup_forcing,
        loc_forcing_t,
        loc_output_from_cache,
        land_init,
        tem_info)
    forward_output = (; Pair.(getUniqueVarNames(info.output.variables), loc_output_from_cache)...)
    loss_vector = SindbadTutorials.metricVector(loc_output_from_cache, loc_obs, loc_cost_option)
    t_loss = combineMetric(loss_vector, constraint_method)
    return forward_output, loss_vector, t_loss
end

function extract_site_series(output, var_name::Symbol)
    data = getproperty(output, var_name)
    if ndims(data) == 4
        return Array(data[:, 1, 1, 1])
    elseif ndims(data) == 3
        return Array(data[:, 1, 1])
    elseif ndims(data) == 2
        return Array(data[:, 1])
    end
    return Array(data)
end

function get_site_optimized_params(hybrid_helpers, info, forcing, site_index)
    sites_forcing = forcing.data[1].site
    ml_model = hybrid_helpers.ml_model
    xfeatures = hybrid_helpers.features.data
    params_sites = ml_model(xfeatures)
    scaled_params_sites = getParamsAct(params_sites, info.optimization.parameter_table)
    site_name = sites_forcing[site_index]
    loc_params = scaled_params_sites(site=site_name).data.data
    return (; site_name, loc_params, scaled_params_sites)
end

function get_site_observation(observations, site_index, var_row)
    loc_observation = [Array(o[:, site_index]) for o in observations.data]
    obs_var, obs_sigma, _ = getData((;), loc_observation, var_row)
    obs_var = obs_var[:, 1, 1, 1]
    obs_sigma = obs_sigma[:, 1, 1, 1]
    return obs_var, obs_sigma
end

function analyze_structure(label, model_structure_file, optimization_file, site_index)
    info, forcing, observations, hybrid_helpers = load_experiment(
        model_structure_file,
        optimization_file;
        experiment_name="hybrid_$(label)",
    )

    trainML(hybrid_helpers, info.hybrid.ml_training.method)

    site_fit = get_site_optimized_params(hybrid_helpers, info, forcing, site_index)
    output_default, loss_default, total_loss_default = run_model_param(
        info,
        forcing,
        observations,
        site_index,
        info.optimization.parameter_table.default,
    )
    output_optimized, loss_optimized, total_loss_optimized = run_model_param(
        info,
        forcing,
        observations,
        site_index,
        site_fit.loc_params,
    )

    return (;
        label,
        info,
        forcing,
        observations,
        hybrid_helpers,
        site_name=site_fit.site_name,
        loc_params=site_fit.loc_params,
        output_default,
        output_optimized,
        loss_default,
        loss_optimized,
        total_loss_default,
        total_loss_optimized,
    )
end

function plot_structure_diagnostics(result, site_index)
    info = result.info
    observations = result.observations
    site_name = result.site_name
    loc_observation = [Array(o[:, site_index]) for o in observations.data]
    costOpt = prepCostOptions(loc_observation, info.optimization.cost_options)

    default(titlefont=(16, "times"), legendfontsize=11, tickfont=(10, :black))
    foreach(costOpt) do var_row
        v = (var_row.mod_field, var_row.mod_subfield)
        vinfo = getVariableInfo(v, info.experiment.basics.temporal_resolution)
        standard_name = vinfo["standard_name"]
        lossMetric = var_row.cost_metric
        loss_name = nameof(typeof(lossMetric))
        if loss_name in (:NNSEInv, :NSEInv)
            lossMetric = NSE()
        end
        obs_var, obs_sigma, def_var = getData(result.output_default, loc_observation, var_row)
        _, _, opt_var = getData(result.output_optimized, loc_observation, var_row)
        obs_var = obs_var[:, 1, 1, 1]
        obs_sigma = obs_sigma[:, 1, 1, 1]
        def_var = def_var[:, 1, 1, 1]
        opt_var = opt_var[:, 1, 1, 1]

        non_nan_index = findall(x -> !isnan(x), obs_var)
        if length(non_nan_index) < 2
            tspan = 1:length(obs_var)
        else
            tspan = first(non_nan_index):last(non_nan_index)
        end

        xdata = collect(info.helpers.dates.range[tspan])
        obs_var_t = obs_var[tspan]
        obs_sigma_t = obs_sigma[tspan]
        def_var_t = def_var[tspan]
        opt_var_t = opt_var[tspan]

        obs_var_n, obs_sigma_n, def_var_n = getDataWithoutNaN(obs_var_t, obs_sigma_t, def_var_t)
        obs_var_n2, obs_sigma_n2, opt_var_n = getDataWithoutNaN(obs_var_t, obs_sigma_t, opt_var_t)
        metr_def = metric(obs_var_n, obs_sigma_n, def_var_n, lossMetric)
        metr_opt = metric(obs_var_n2, obs_sigma_n2, opt_var_n, lossMetric)

        p = plot(
            xdata,
            obs_var_t;
            label="obs",
            seriestype=:scatter,
            mc=:black,
            ms=3,
            lw=0,
            ma=0.6,
            left_margin=1Plots.cm,
            title="$(standard_name) ($(vinfo["units"]))",
            size=(1800, 800),
        )
        plot!(p, xdata, def_var_t; color=:steelblue2, lw=1.5, ls=:dash, label="default ($(round(metr_def, digits=2)))")
        plot!(p, xdata, opt_var_t; color=:seagreen3, lw=1.5, label="optimized ($(round(metr_opt, digits=2)))")
        savefig(p, joinpath(info.output.dirs.figure, "$(result.label)_$(site_name)_$(standard_name).png"))
    end
end

function plot_cross_structure_comparison(external_result, standard_result, site_index)
    xdata = collect(external_result.info.helpers.dates.range)
    site_name = external_result.site_name
    loc_observation = [Array(o[:, site_index]) for o in external_result.observations.data]
    costOpt = prepCostOptions(loc_observation, external_result.info.optimization.cost_options)
    gpp_row = findfirst(row -> row.variable == :gpp, costOpt)
    obs_gpp = nothing
    if !isnothing(gpp_row)
        obs_gpp_tmp, _, _ = getData(external_result.output_default, loc_observation, costOpt[gpp_row])
        obs_gpp = obs_gpp_tmp[:, 1, 1, 1]
    end

    gpp_ext_def = extract_site_series(external_result.output_default, :gpp)
    gpp_ext_opt = extract_site_series(external_result.output_optimized, :gpp)
    gpp_std_def = extract_site_series(standard_result.output_default, :gpp)
    gpp_std_opt = extract_site_series(standard_result.output_optimized, :gpp)

    gpp_f_ext_def = extract_site_series(external_result.output_default, :gpp_f_airT)
    gpp_f_ext_opt = extract_site_series(external_result.output_optimized, :gpp_f_airT)
    gpp_f_std_def = extract_site_series(standard_result.output_default, :gpp_f_airT)
    gpp_f_std_opt = extract_site_series(standard_result.output_optimized, :gpp_f_airT)

    p_gpp = plot(
        xdata,
        gpp_ext_def;
        label="external default",
        color=:firebrick,
        lw=1.5,
        ls=:dash,
        xlabel="Date",
        ylabel="GPP",
        title="GPP comparison at $(site_name)",
        size=(1800, 700),
        left_margin=1Plots.cm,
    )
    if !isnothing(obs_gpp)
        plot!(p_gpp, xdata, obs_gpp; label="obs", seriestype=:scatter, mc=:black, ms=2, lw=0, ma=0.5)
    end
    plot!(p_gpp, xdata, gpp_ext_opt; label="external optimized", color=:firebrick, lw=2)
    plot!(p_gpp, xdata, gpp_std_def; label="standard default", color=:steelblue, lw=1.5, ls=:dash)
    plot!(p_gpp, xdata, gpp_std_opt; label="standard optimized", color=:steelblue, lw=2)

    p_gpp_f_airT = plot(
        xdata,
        gpp_f_ext_def;
        label="external default",
        color=:firebrick,
        lw=1.5,
        ls=:dash,
        xlabel="Date",
        ylabel="gpp_f_airT",
        title="gpp_f_airT comparison at $(site_name)",
        ylim=(0, 1.05),
        size=(1800, 700),
        left_margin=1Plots.cm,
    )
    plot!(p_gpp_f_airT, xdata, gpp_f_ext_opt; label="external optimized", color=:firebrick, lw=2)
    plot!(p_gpp_f_airT, xdata, gpp_f_std_def; label="standard default", color=:steelblue, lw=1.5, ls=:dash)
    plot!(p_gpp_f_airT, xdata, gpp_f_std_opt; label="standard optimized", color=:steelblue, lw=2)

    fig_dir = external_result.info.output.dirs.figure
    savefig(p_gpp, joinpath(fig_dir, "compare_gpp_externalNN_vs_standard_$(site_name).png"))
    savefig(p_gpp_f_airT, joinpath(fig_dir, "compare_gpp_f_airT_externalNN_vs_standard_$(site_name).png"))
    return (; p_gpp, p_gpp_f_airT)
end

site_index = 1
external_result = analyze_structure("externalNN", "model_structure_externalNN.json", "optimization_externalNN.json", site_index);
standard_result = analyze_structure("standard", "model_structure.json", "optimization.json", site_index);

plot_structure_diagnostics(external_result, site_index);
plot_structure_diagnostics(standard_result, site_index);
comparison = plot_cross_structure_comparison(external_result, standard_result, site_index);
