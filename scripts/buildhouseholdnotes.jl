repo = pwd()

f = joinpath(repo, "data", "qgspoints.cex")

outdir = joinpath(repo,"vault","households1850")
if ! isdir(outdir)
    mkpath(outdir)
end


data = map(readlines(f)[2:end]) do ln
    cols = split(ln,"|")
    (x = cols[1], y = cols[2], house1850 = cols[4])
end

for tpl in filter(t -> ! isempty(t.house1850), data)
    label = "Panton, Addison, Vermont, 1850, household $(tpl.house1850)"
    pagelines = ["---", "location: $(tpl.y),$(tpl.x)", "---","",
    "# ", label, ""
    ]
    txt = join(pagelines,"\n")

    fname = replace(label, " " => "_")
    outfile = joinpath(outdir, fname)
    @info("Write output to $(outfile)")
    
end