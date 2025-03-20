using Vermont
repo = pwd()
f1850 = joinpath(repo, "data", "Panton1850census.cex")
f1860 = joinpath(repo, "data", "Panton1860census.cex")

data1850 = readcensusdata(f1850)
data1860 = readcensusdata(f1860)

names1850 = map(t -> t.name, data1850)
names1860 = map(t -> t.name, data1860)



lastnames = map(vcat(names1850)) do name
    split(name, " ")[end]
end

outdir = joinpath(repo, "data", "vault", "people")

for n in lastnames
    mkpath(joinpath(outdir, n))
end