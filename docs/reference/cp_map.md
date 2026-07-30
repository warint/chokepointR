# Map chokepoint risk levels

Launch an interactive map of the chokepoints, coloured by risk level,
for the dimensions you select. Filtering works exactly like
[`cp_data`](https://warint.github.io/chokepointR/reference/cp_data.md):
choose any combination of locations, risks, risk levels and category,
and the map shows the matching records. Each chokepoint is drawn as a
circle coloured by its highest matching risk level and sized by how many
matching records it has; the popup lists the risks, levels and
documented incidents.

## Usage

``` r
cp_map(
  locations = NULL,
  risks = NULL,
  levels = NULL,
  category = NULL,
  incidents_only = FALSE
)
```

## Arguments

- locations, risks, levels, category:

  Optional filters passed through to
  [`cp_data`](https://warint.github.io/chokepointR/reference/cp_data.md)
  (any left `NULL` is not filtered on).

- incidents_only:

  If `TRUE`, map only records with a documented incident. Default
  `FALSE`.

## Value

A leaflet map widget (invisibly returned; auto-prints in interactive
sessions). Requires the suggested package leaflet.

## See also

[`cp_data`](https://warint.github.io/chokepointR/reference/cp_data.md),
[`cp_search`](https://warint.github.io/chokepointR/reference/cp_search.md).

## Examples

``` r
# \donttest{
if (requireNamespace("leaflet", quietly = TRUE)) {
  # All high risks:
  cp_map(levels = "High risk")
  # Weather and climate risks only:
  cp_map(category = "Weather and climate risk")
}

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addCircleMarkers","args":[9.08,-79.68000000000001,10.4,null,null,{"interactive":true,"className":"","stroke":true,"color":"#2CA25F","weight":1,"opacity":1,"fill":true,"fillColor":"#2CA25F","fillOpacity":0.7},null,null,"<b>Panama Canal<\/b><br/>Top risk level: <b>High risk<\/b><br/>Matching records: 2 (2 documented incidents)<br/><b>Incidents:<\/b><ul><li>A severe El Nino drought forced the Panama Canal Authority to cut daily transits to about 32 ships by August 2023, producing a backlog of roughly 115 waiting vessels. <i>(Flood and drought, 2023)<\/i><\/li><li>Record-low water in Gatun Lake pushed the canal to reduce daily crossings to 24 from 7 November 2023 with tightened draft limits before rains allowed transit slots to be raised again through 2024. <i>(Flood and drought, 2023-24)<\/i><\/li><\/ul>",null,"Panama Canal",{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]},{"method":"addLegend","args":[{"colors":["#2CA25F"],"labels":["High risk"],"na_color":null,"na_label":"NA","opacity":1,"position":"bottomright","type":"factor","title":"Top risk level","extra":null,"layerId":null,"className":"info legend","group":null}]}],"limits":{"lat":[9.08,9.08],"lng":[-79.68000000000001,-79.68000000000001]}},"evals":[],"jsHooks":[]}# }
```
