using Vermont

repo = pwd()
f = joinpath(repo, "data", "qgspoints.cex")
gisdata = readgisdata(f)


destdir = joinpath(repo, "data", "vault", "Panton")
if ! isdir(destdir)
    mkpath(destdir)
end


Vermont.vaultlocationnotes(gisdata, destdir)

dir1850 = joinpath(repo, "data", "vault", "Panton", "1850 census")
data1850 = readcensusdata(:panton1850)
Vermont.vaultcensusnotes(data1850, dir1850)


dir1860 = joinpath(repo, "data", "vault", "Panton", "1860 census")
data1860 = readcensusdata(:panton1856)
Vermont.vaultcensusnotes(data1860, dir1860)