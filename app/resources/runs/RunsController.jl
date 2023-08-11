module RunsController
using REoptMVC.Runs
using Genie.Renderer, Genie.Renderer.Html, Genie.Router, Genie.Requests
using SearchLight
using JSON

function index()
    html(:runs, :index; runs = all(Run))
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

end