using CairoMakie, GeoMakie
using Rasters
using ArchGDAL

srcdir = "/Users/nsmith/Dropbox/_current_projects/_genealogy/GIS"
fname = "commonwealth_wd376466z_image_primary_modified.tif"

f = joinpath(srcdir, fname)
isfile(f)

#rast = Raster(f)

fig = Figure()
