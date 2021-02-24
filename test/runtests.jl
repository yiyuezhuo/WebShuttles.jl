
using Test
using WebShuttles, JSON

ws_handler = WSHandler()
task, host, port, ret = async_listenany(ws_handler)

clicked = false
click_cond = Condition()

on("click", ws_handler) do event
    println("event data: ", event)
    global clicked = true
    notify(click_cond)
end

@testset "client to server" begin
    ret() do ws
        println("Connection established")
        write(ws, JSON.json(Dict("event" => "click", "data" => "custom_event_data")))
        wait(click_cond)
        @test clicked
    end
end



@testset "server to client" begin

    # send to client test
    ret() do ws
        @sync begin
            @async trigger(ws_handler, "change", [1., 2.])
            read_ws = readavailable(ws)
            read_ws_str = String(read_ws)
            event_obj = JSON.parse(read_ws_str)
            @show event_obj
            @test event_obj["event"] == "change"
            @test event_obj["data"] == [1., 2.]
        end
    end

    # send to client test

    ret() do ws
        @sync begin
            @async put!(ws_handler.in_channel, Dict("event"=>"change", "data"=>[1.,2.]))
            read_ws = readavailable(ws)
            read_ws_str = String(read_ws)
            event_obj = JSON.parse(read_ws_str)
            @show event_obj
            @test event_obj["event"] == "change"
            @test event_obj["data"] == [1., 2.]
        end
    end
end
