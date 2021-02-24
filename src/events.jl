"""
event json (trigger server(here) function):
{
    "event": "event_name",
    "data": ""
}

channel json (trigger client function):
{
    "event": "event_name",
    "data": ""
}

control json:
    "command": "exit"
"""

struct WSHandler
    listener_map::Dict{String, Vector}
    in_channel::Channel{Dict}
end

WSHandler() = WSHandler(Dict{String, Vector}(), Channel{Dict}())

function get_func(ws_handler::WSHandler)
    return function(ws)
        return ws_handler(ws)
    end
end

function read_handler(ws_handler::WSHandler, ws)
    # println("read_handler called")
    try
        while !eof(ws)
            # println("while begin")
            binary_data = readavailable(ws)
            # @show binary_data
            str_data = String(binary_data)
            # @show str_data
            if str_data != ""
                #=
                data = try
                    JSON.parse(str_data)
                catch e
                    println("JSON.parse failed, ", e)
                    break
                end
                =#
                data = JSON.parse(str_data)
                # @show data
                listeners = ws_handler.listener_map[data["event"]]
                for listener in listeners
                    # @show listener
                    listener(data["data"])
                end
            end
            # @show eof(ws)
        end
    catch e
        # @error "error read_handler" exception=(e, stacktrace(catch_backtrace()))
        throw(e)
    finally
        # println("before exit command put")
        exit_command = Dict("command" => "exit") # JSON.json(Dict("command" => "exit"))
        # @show exit_command
        put!(ws_handler.in_channel, exit_command)
        # println("read_handler exit")
    end
end

function (ws_handler::WSHandler)(ws)
    # println("Combined handler called")
    @sync begin
        @async read_handler(ws_handler, ws)
        for json_data in ws_handler.in_channel # json_data is a Dict
            # println("incoming in_channel, ", json_data)
            # json_data = JSON.json(in_data)
            if haskey(json_data, "command")
                if json_data["command"] == "exit"
                    break
                end
            end
            write(ws, JSON.json(json_data))
        end
        # println("exit callable handler")
    end
end

function on(callback, event::String, ws_handler::WSHandler)
    if !haskey(ws_handler.listener_map, event)
        ws_handler.listener_map[event] = Vector()
    end
    push!(ws_handler.listener_map[event], callback)
end

function trigger(ws_handler::WSHandler, event::String, data)
    put!(ws_handler.in_channel, Dict("event"=>event, "data"=>data))
end