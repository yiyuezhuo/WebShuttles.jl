
macro setup()
    return esc(quote
        default_ws_handler = WSHandler()
        default_task, default_host, default_port, default_ret = async_listenany(default_ws_handler)

        WebShuttles.on(callback, event::String) = on(callback, event, default_ws_handler)
        WebShuttles.trigger(event::String, data) = trigger(default_ws_handler, event, data)
    end)
end


const js_define = open(joinpath(@__DIR__, "js_define.js")) do f
    f |> read |> String
end

function run_script(js_str)
    display(HTML("<script>$js_str</script>"))
end

#=
function import_js(url)
    run_script("await SystemJS.import('$url')")
end

function import_css(url)
    display(HTML("<link rel='stylesheet' href='$url'/>"))
end
=#

macro embed_IJulia()
    return quote
        run_script(js_define)
        run_script(
            "WebShuttles.setup(\"" * 
                $(esc(:default_host)) *
                "\", \"" *
                string($(esc(:default_port))) *
            "\")"
        )
    end
end
