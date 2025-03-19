using Vermont

repo = pwd()
f = joinpath(repo, "data", "qgspoints.cex")
gisdata = readgisdata(f)


destdir = joinpath(repo, "data", "vault", "Panton")
if ! isdir(destdir)
    mkpath(destdir)
end


Vermont.buildvaultnotes(gisdata, destdir)