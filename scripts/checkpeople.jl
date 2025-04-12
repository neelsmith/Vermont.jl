repo = pwd()

idfile = joinpath(repo, "data", "vermonters.cex")
isfile(idfile)
expandedfile = joinpath(repo, "data", "vermonters-expanded.cex")


file1lines = readlines(idfile)[2:end]
for (i, s) in enumerate(file1lines)
    cols = split(s, "|")
    if length(cols) < 5
        @warn("Problem at line $i), value $(s): too few lines")
    end
end


idlist1 = map(readlines(idfile)[2:end]) do ln
    lncount = lncount + 1
    cols = split(ln, "|")
    if length(cols) < 5
        
        @warn("Problem at line $lncount), value $(ln): too few lines")
        nothing
    else
        cols[5]
    end
end


idlist2 = map(readlines(expandedfile)[2:end]) do ln
    split(ln,"|")[5]
end


matchlist = []
for n in idlist1
    if n in idlist2
        push!(matchlist, n)
    else
        @warn("$(n) missing from list 2")
    end
end

