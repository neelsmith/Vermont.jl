using Vermont

repo = pwd()
f = joinpath(repo, "data", "qgspoints.cex")
gisdata = readgisdata(f)


destdir = joinpath(repo, "data", "vault", "Panton")
wallingdir = joinpath(destdir, "walling1857")
if ! isdir(wallingdir)
    mkpath(wallingdir)
end

Vermont.vaultlocationnotes(gisdata, wallingdir)

dir1850 = joinpath(repo, "data", "vault", "Panton", "1850 census")
data1850 = readcensusdata(:panton1850)
Vermont.vaultcensusnotes(data1850, dir1850)


dir1860 = joinpath(repo, "data", "vault", "Panton", "1860 census")
data1860 = readcensusdata(:panton1860)
Vermont.vaultcensusnotes(data1860, dir1860)

allcensus =  filter(t -> !isnothing(t.name), vcat(data1850, data1860))

# Make last-name directoreis
function lastnamedirs(destdir, namelist)
    lastnames = map(s -> split(s)[end], allnames) |> unique |> sort
    for n in lastnames
        subdir = joinpath(destdir, n)
        if !isdir(subdir)
            mkpath(subdir)
        end
        @info(n)
    end
end

namesindexdir = joinpath(repo, "data", "vault", "last names")
allnames = map(t -> t.name, allcensus)
lastnamedirs(namesindexdir, allnames)


# Now make people pages:
for n in allnames
    @info("Now $(n)")
    f = joinpath(namesindexdir, split(n)[end], n * ".md")
    pagelines = [
        "# $(n)","","",
        "#deceased",
    ]
    open(f,"w") do io
        write(io, join(pagelines,"\n"))
    end
    @info("Wrote $(f)")
    
end