using Genie
using Genie.Router, Genie.Requests, Genie.Renderer.Json, Genie.Renderer.Html
using REoptMVC.RunsController

# route("/") do
#   serve_static_file("welcome.html")
# end

route("/", RunsController.index)

route("/runs", RunsController.create, method = POST)

route("/api/v1/runs", RunsController.API.V1.list, method = GET)
route("/api/v1/runs/:id::Int", RunsController.API.V1.item, method = GET)
route("/api/v1/runs", RunsController.API.V1.create, method = POST)
route("/api/v1/runs/:id::Int", RunsController.API.V1.update, method = PATCH)
route("/api/v1/runs/:id::Int", RunsController.API.V1.delete, method = DELETE)