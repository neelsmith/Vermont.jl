using Vermont
using StatsBase, OrderedCollections
using CairoMakie
using Format

data1850 = readcensusdata(:panton1850)
propvals = map(filter(t -> ! isempty(t.realestate), data1850)) do rec
    parse(Int, rec.realestate)
end
valsdict = countmap(propvals) |> OrderedDict
sort!(valsdict, rev=true)

ys = values(valsdict) |> collect
xs = keys(valsdict) |> collect

f = Figure()
Axis(f[1, 1],

title = "Property values",

xtickformat = v -> format.(v, commas=true, precision=3)
)
barplot!(xs, ys, width=100)

f
