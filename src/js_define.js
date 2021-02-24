
WebShuttles = {
    host: undefined,
    port: undefined,
    socket: undefined,
    listeners_map: {},

    setup: function(host, port){
        this.host = host;
        this.port = port;
        var url = `ws://${this.host}:${this.port}`
        this.socket = new WebSocket(url);
        var listeners_map = this.listeners_map;
        this.socket.addEventListener('message', function (event) {
            var obj = JSON.parse(event.data);
            for (var callback of listeners_map[obj["event"]]){
                callback(obj["data"]);
            }
            // console.log('Message from server ', event.data);
        });
        console.log("WebShuttles setup");
    },

    trigger: function(event, data){
        var message = {event: event, data:data};
        var message_str = JSON.stringify(message);
        console.log(message);
        console.log(message_str);
        this.socket.send(message_str);
    },
    on: function(event, callback){
        if(!(event in this.listeners_map)){
            this.listeners_map[event] = [];
        }
        this.listeners_map[event].push(callback);
    }
};