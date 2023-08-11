module Runs

using UUIDs, JSON
import SearchLight: AbstractModel, DbId
import Base: @kwdef

export Run

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

end