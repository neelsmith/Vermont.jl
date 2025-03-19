using Dates
using StatsBase, OrderedCollections

repo = pwd()


f1850 = joinpath(repo, "data", "Panton1850census.cex")

function readcensusdata(f)
    datalines = readlines(f)[2:end]
    data = map(datalines) do ln
        cols = split(ln, "|")
        if length(cols) < 11
            @info("ERROR on $(ln)")
            
        else 
        (mappedraw, cdate, houseraw, familyraw, name, ageraw, sex, color, occupation, realestate, birthplace)  = cols
        house = parse(Int, houseraw)
        family = parse(Int, familyraw)
        age = parse(Int, ageraw)
        mapped = isempty(mappedraw) ? nothing : mappedraw
            (mapped = mapped, censusdate = Date(cdate), house = house, family = family, name = name, age = age, sex = sex, color = color, occupation = occupation, realestate = realestate, birthplace = birthplace)
        end
    end
end


data = readcensusdata(f)