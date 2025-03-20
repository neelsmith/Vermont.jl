
"""Read delimited-text dump of QGIS locations data.
$(SIGNATURES)
"""
function readgisdata(f)
    datalines = readlines(f)[2:end]
    #X|Y|id|house1850|label1850|house1860|label1860 
    data = map(datalines) do ln
        cols = split(ln, "|")
        if length(cols) < 7
            @info("ERROR on $(ln)")
        else
            (lonraw, latraw, id, house1850raw, label1850, house1860raw, label1860) = cols
            lon = parse(Float32, lonraw)
            lat = parse(Float32, latraw)
            id = parse(Int, id)
            house1850 = isempty(house1850raw) ? nothing  : parse(Int, house1850raw)
            house1860 = isempty(house1860raw) ? nothing  : parse(Int, house1860raw)
            (lon = lon, lat = lat, id = id, house1850 = house1850, label1850 = label1850, house1860 = house1860, label1860 = label1860)
        end
    end
end


"""Write Obsidian vault notes for each location in the GIS data.
$(SIGNATURES)
"""
function buildvaultnotes(gisdata, destdir)
    for tpl in gisdata
        topicname = isempty(tpl.label1850) ? string("Panton, ", tpl.label1860) :  string("Panton, ", tpl.label1850)
        fname = joinpath(destdir, topicname * ".md")

        pagelines = ["---",
        "location: $(tpl.lat),$(tpl.lon)",
        "---", "",
        "# $(topicname)", "",
        "#panton","",
        ]

        if ! isnothing(tpl.house1850)
            push!(pagelines, "#in1850census")
        end
        if ! isnothing(tpl.house1860)
            push!(pagelines, "#in1860census")
        end

        
        open(fname,"w") do io
            write(io, join(pagelines, "\n"))
        end
        @info("Wrote file $(fname)")
    end

end




"""Read 1850 or 1860 census data.
$(SIGNATURES)
"""
function readcensusdata(f)
    datalines = readlines(f)[2:end]
    data = map(datalines) do ln
        cols = split(ln, "|")
        if length(cols) < 11
            @info("ERROR on $(ln)")
            
        else 
        (mappedraw, cdate, houseraw, familyraw, name, ageraw, sex, color, occupation, realestate, birthplace)  = cols
        house = isempty(houseraw) ? nothing : parse(Int, houseraw)
        family = isempty(familyraw) ? nothing :  parse(Int, familyraw)
        age = isempty(ageraw) ? nothing : parse(Int, ageraw)
        mapped = isempty(mappedraw) ? nothing : mappedraw
            (mapped = mapped, censusdate = Date(cdate), house = house, family = family, name = name, age = age, sex = sex, color = color, occupation = occupation, realestate = realestate, birthplace = birthplace)
        end
    end
end
