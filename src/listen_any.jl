
export async_serveany, test_async_serveany

"""
find_free_port()

This function is not theory correct but works at most time.
So the usage should be limited on interactive interaction.
"""
function find_free_port()
    port, server = listenany(10000)
    close(server)
    return Int(port)
end

function async_listenany(ws_handler::Function, host="127.0.0.1")
    
    port = find_free_port()
    task = @async WebSockets.listen(ws_handler, host, UInt16(port))
    url = "ws://$host:$port"
    ret(callback) = WebSockets.open(callback, url)
    
    return task, host, port, ret
end

function async_listenany(ws_handler::WSHandler, host="127.0.0.1")
    return async_listenany((ws)->ws_handler(ws), host)
end
