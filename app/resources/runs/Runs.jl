module Runs

using UUIDs, JSON
import SearchLight: AbstractModel, DbId
import Base: @kwdef

export Run, run_dict

@kwdef mutable struct Run <: AbstractModel
  id::DbId = DbId()
  run_uuid::String = ""
  status::String = ""
  input::String = ""  # Must store JSON/Dict data as a string (JSON -> string)
end

function Run(input_dict::Dict{String, Any})
  uuid = UUIDs.uuid4()
  uuid_string = "$uuid"
  input_string = JSON.json(input_dict)
  return Run(run_uuid=uuid_string, input=input_string)
end

function run_dict(run::Run)
    # List comprehension way, efficient but less flexible to handle/convert different fields differently
    # dict = Dict(key=>getfield(run, key) for key ∈ fieldnames(Run))
    keys_convert_to_dict = [:input]
    dict = Dict()
    for key in fieldnames(Run)
        if key in keys_convert_to_dict
            value = JSON.parse(getfield(run, key))
        else
            value = getfield(run, key)
        end
        dict[key] = value
    end
    return dict
end

end