module RunsController
using REoptMVC.Runs
using Genie.Renderer, Genie.Renderer.Html, Genie.Router, Genie.Requests
using SearchLight
using JSON

function runs()
    #data = getpayload()  # For convert all query params to Dict{Symbol, Any} for GET requests, from Genie.Requests module
    #data = postpayload()  # For getting POST payload in Dict{Symbol, Any}, from Genie.Requests module
    runs = if params(:filter, "") == "optimal" # For getting query param directly; :filter is not a Run field, just a [standard] query
        find(Run, status = "optimal")
    elseif params(:filter, "") == "error"
        find(Run, status = "error")
    else
        # First step at pagination but only implemented for API, not UI implemented
        # this line was: all(Run) and is changed to:
        all(
            Run; 
            limit = params(:limit, SearchLight.SQLLimit_ALL) |> SQLLimit,
            offset = (parse(Int, params(:page, "1"))-1) * parse(Int, params(:limit, "0"))
        )
    end
end

function index()
    html(:runs, :index; runs = runs())  #add args/vars to end, like runs
end

function create()  
    if haskey(filespayload(), "input")
        input_dict = JSON.parse(IOBuffer(filespayload("input").data))
    else
        redirect("/?error=No input file provided")
    end
    run_inst = Run(input_dict)
    if save(run_inst)
        redirect("/?success=Valid .json file $(filespayload("input").name) successfully uploaded")
    else
        redirect("/?error=Could not save input&input=$(filespayload("input").name)")
    end
end

# Placeholder function for run_reopt(), to be called with @async
function run_reopt(run::Run)
    sleep(20)
    run.status = "optimal"
    # TODO Create outputs/results field of Run struct and populate with dummy outputs
    save!(run)
end

### API
module API
module V1
using REoptMVC.Runs
using Genie.Router
using Genie.Renderers.Json
using ....RunsController
using Genie.Requests
using SearchLight.Validation
using SearchLight

# Simple function to demonstrate that RunsController.[function] is used for both UI and API (below) for DRY
function list()
  RunsController.runs() |> json
end

# Find and return one Run
function item()
    run = findone(Run, run_uuid = params(:run_uuid))
    if run === nothing
        return JSONException(status = NOT_FOUND, message = "Run not found") |> json
    end

    run |> json
end

function check_payload(payload = Requests.jsonpayload())
    isnothing(payload) && throw(
        JSONException(status = BAD_REQUEST, message = "Invalid JSON message received"),
    )
    payload
end

function persist(run)
    validator = validate(run)
    if haserrors(validator)
        return JSONException(status = BAD_REQUEST, message = errors_to_string(validator)) |>
               json
    end

    try
        # What is "(SearchLight).ispersisted" and why is it false for a typical good POST? No docstrings.
        if ispersisted(run)
            save!(run)
            json(run.run_uuid, status = OK)
        else
            run.status = "optimizing..."
            save!(run)
            @async RunsController.run_reopt(run)
            json(
                Dict("run_uuid" => run.run_uuid),
                status = CREATED,
                headers = Dict("Location" => "/api/v1/runs/$(run.run_uuid)"),
            )
        end
    catch ex
        JSONException(status = INTERNAL_ERROR, message = string(ex)) |> json
    end
end

function create()
    payload = try
        check_payload()
    catch ex
        return json(ex)
    end
    run = Run(payload)
    persist(run)
end

function update()
    # Not sure what is relevant to update because we need to run REopt again if inputs are updated
    payload = try
        check_payload()
    catch ex
        return json(ex)
    end

    run = findone(Run, run_uuid = params(:run_uuid))
    if run === nothing
        return JSONException(status = NOT_FOUND, message = "Run not found") |> json
    end

    run.inputs = get(payload, "inputs", run.inputs)
    # TODO if inputs are changes, need to re-run REopt and store outputs too

    persist(run)
end

function delete()
    run = findone(Run, run_uuid = params(:run_uuid))
    if run === nothing
        return JSONException(status = NOT_FOUND, message = "Run not found") |> json
    end

    try
        SearchLight.delete(run) |> json
    catch ex
        JSONException(status = INTERNAL_ERROR, message = string(ex)) |> json
    end
end

end # V1

end # API

end # RunsController Module