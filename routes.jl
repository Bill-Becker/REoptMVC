using Genie
using Genie.Router, Genie.Requests, Genie.Renderer.Json, Genie.Renderer.Html
using REoptMVC.RunsController

# route("/") do
#   serve_static_file("welcome.html")
# end

route("/", RunsController.index)

route("/runs", RunsController.create, method = POST)