using Vermont
repo = pwd()
outdir1850 = joinpath(repo, "data", "vault", "VT-households-1850")
if !isdir(outdir1850)
    mkpath(outdir1850)
end
outdir1860 = joinpath(repo, "data", "vault", "VT-households-1860")
if !isdir(outdir1860)
    mkpath(outdir1860)
end

c1850 = readcensusdata(:panton1850)
c1860 = readcensusdata(:panton1860)


for i in householdids(c1850)
    wikiname = "Panton, Addison, Vermont, 1850, household $(i)"
    fname = wikiname * ".md"
    f = joinpath(outdir1850, fname)

    pagelines = [
        "# $(wikiname)","",
        "enumeration::[[Panton, Addison, Vermont]]","",
        "year::1850",""
    ]
    for tpl in filter(t -> t.house == i, c1850)
        push!(pagelines, "[[" * tpl.name * " in 1850 census]]\n")
    end

    # Add lists of names!

    open(f, "w") do io
        write(f, join(pagelines, "\n"))
    end
    @info("Wrote file $(f)")
end



for i in householdids(c1860)
    wikiname = "Panton, Addison, Vermont, 1860, household $(i)"
    fname = wikiname * ".md"
    f = joinpath(outdir1860, fname)

    pagelines = [
        "# $(wikiname)","",
        "enumeration::[[Panton, Addison, Vermont]]","",
        "year::1860",""
    ]
    for tpl in filter(t -> t.house == i, c1860)
        push!(pagelines, tpl.name * "\n")
    end

    open(f, "w") do io
        write(f, join(pagelines, "\n"))
    end
    @info("Wrote file $(f)")
end
