using CairoMakie, GeoMakie
using Rasters, ArchGDAL, NaturalEarth, FileIO


#Full size:
#blue_marble_image = FileIO.load(FileIO.query(download("https://eoimages.gsfc.nasa.gov/images/imagerecords/76000/76487/world.200406.3x5400x2700.jpg"))) |> rotr90 .|> RGBA{Makie.Colors.N0f8}


# Tiny:
blue_marble_image = GeoMakie.earth() |> rotr90 .|> RGBA{Makie.Colors.N0f8}


blue_marble_raster = Raster(
    blue_marble_image, # the contents
    ( # the dimensions go in this tuple.  `X` and `Y` are defined by the Rasters ecosystem.
        X(LinRange(-180, 180, size(blue_marble_image, 1))),
        Y(LinRange(-90, 90, size(blue_marble_image, 2)))
    )
)

land_mask = Rasters.boolmask(NaturalEarth.naturalearth("land", 10); to = blue_marble_raster)

land_raster = deepcopy(blue_marble_raster)
land_raster[(!).(land_mask)] .= RGBA{Makie.Colors.N0f8}(0.0, 0.0, 0.0, 0.0)
land_raster


sea_raster = deepcopy(blue_marble_raster)
sea_raster[land_mask] .= RGBA{Makie.Colors.N0f8}(0.0, 0.0, 0.0, 0.0)
sea_raster


fig = Figure()
ax = GeoAxis(fig[1, 1]; dest = "+proj=ortho +lon_0=0 +lat_0=0")


sea_plot = meshimage!(ax, sea_raster; source = "+proj=longlat +datum=WGS84 +type=crs", npoints = 300)

land_plot = meshimage!(ax, land_raster; source = "+proj=longlat +datum=WGS84 +type=crs", npoints = 300)
