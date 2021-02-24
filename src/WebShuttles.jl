module WebShuttles

using HTTP
using JSON
using Sockets

using HTTP.WebSockets

export find_free_port, async_listenany, on, WSHandler, trigger
export default_ws_handler, default_task, default_host, default_port, default_ret
export embed_IJulia

include("events.jl")
include("listen_any.jl")
include("embeds.jl")
# include("defaults.jl")


# greet() = print("Hello World!")

end # module
