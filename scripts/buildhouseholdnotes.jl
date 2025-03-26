using Vermont
repo = pwd()
outdir1850 = joinpath(repo, "data", "vault", "households1850")
if !isdir(outdir1850)
    mkpath(outdir1850)
end
outdir1860 = joinpath(repo, "data", "vault", "households1860")
if !isdir(outdir1860)
    mkpath(outdir1860)
end

c1850 = readcensusdata(:panton1850)
c1860 = readcensusdata(:panton1860)


for tpl in c1850 
    wikiname = "Panton, Addison, Vermont, 1850, household $(tpl.house)"
    fname = wikiname * ".md"
    f = joinpath(outdir1850, fname)

    pagelines = [
        "# $(wikiname)","",
        "enumeration::[[Panton, Addison, Vermont]]","",
        "year::1850"
    ]
    
    open(f, "w") do io
        write(f, join(pagelines, "\n"))
    end
    @info("Wrote file $(f)")
end


for tpl in c1860 
    wikiname = "Panton, Addison, Vermont, 1860, household $(tpl.house)"
    fname = wikiname * ".md"
    f = joinpath(outdir1860, fname)

    pagelines = [
        "# $(wikiname)","",
        "enumeration::[[Panton, Addison, Vermont]]","",
        "year::1860"
    ]
    
    open(f, "w") do io
        write(f, join(pagelines, "\n"))
    end
    @info("Wrote file $(f)")
end
