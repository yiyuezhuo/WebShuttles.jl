
# WebShuttles

A lightweight alternative to `WebIO`.

## Usages

### Map communication example:

See [gist](https://gist.github.com/yiyuezhuo/c0377a3b9e4b2c1b005b6d3979951f04):

```julia
HTML("""
    <div id="mapid" style="height: 240px;"></div>
""")

using WebShuttles

WebShuttles.@setup
WebShuttles.@embed_IJulia

HTML("<link rel='stylesheet' href='https://unpkg.com/leaflet@1.7.1/dist/leaflet.css'/>")

WebShuttles.run_script("""
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
""")

on("click") do event
    println(event)
end

WebShuttles.run_script("""
    WebShuttles.on("change", (event)=>console.log("event:", event))
""")

trigger("change", [1.,2.])

trigger("change", [1.,2.])

```
