// MDN WebSocket example
socket = new WebSocket('ws://localhost:10001');

// Connection opened
socket.addEventListener('open', function (event) {
    socket.send('Hello Server!');
});

// Listen for messages
socket.addEventListener('message', function (event) {
    console.log('Message from server ', event.data);
});

//////////// Jupyter usage

(async function(){
    await SystemJS.import('https://unpkg.com/leaflet@1.7.1/dist/leaflet.js');

    var mymap = L.map('mapid').setView([51.505, -0.09], 13);

    L.tileLayer('https://a.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: 'attr',
    }).addTo(mymap);

    function onMapClick(e) {
        console.log('You clicked the map at:');
        console.log(e.latlng);
        WebShuttles.trigger("click", e.latlng);
    }

    mymap.on('click', onMapClick);

})();
