module Vermont
using Dates, Downloads
using StatsBase, OrderedCollections
using CairoMakie
using Format


using Documenter, DocStringExtensions

include("io.jl")
include("plots.jl")
include("census.jl")


export readcensusdata
export readgisdata

export realestatebarchart

export familyids, hohlist

end # module Vermont
