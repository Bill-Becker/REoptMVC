module Runs

import SearchLight: AbstractModel, DbId
import Base: @kwdef

export Run

@kwdef mutable struct Run <: AbstractModel
  id::DbId = DbId()
  status::String = ""
  input::String = ""
end

end
