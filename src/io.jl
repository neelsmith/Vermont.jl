pointsurl = "https://raw.githubusercontent.com/neelsmith/Vermont.jl/refs/heads/main/data/qgspoints.cex"

censusurls = Dict(
    :panton1850 =>  "https://raw.githubusercontent.com/neelsmith/Vermont.jl/refs/heads/main/data/Panton1850census.cex",
    :panton1860 => "https://raw.githubusercontent.com/neelsmith/Vermont.jl/refs/heads/main/data/Panton1860census.cex"
)

"""Read delimited-text dump of QGIS locations data.
$(SIGNATURES)
"""
function readgisdata(f)
    datalines = readlines(f)[2:end]
    #X|Y|id|house1850|label1850|house1860|label1860 
    data = map(datalines) do ln
        cols = split(ln, "|")
        if length(cols) < 10
            @info("ERROR on $(ln)")
        else
            (lonraw, latraw, id, house1850raw, label1850, house1860raw, label1860, struct1850raw,struct1860raw,walling) = cols
            lon = parse(Float32, lonraw)
            lat = parse(Float32, latraw)
            id = parse(Int, id)
            house1850 = isempty(house1850raw) ? nothing  : parse(Int, house1850raw)
            house1860 = isempty(house1860raw) ? nothing  : parse(Int, house1860raw)
            struct1850 = isempty(struct1850raw) ? nothing  : parse(Int, struct1850raw)
            struct1860 = isempty(struct1860raw) ? nothing  : parse(Int, struct1860raw)
            (lon = lon, lat = lat, id = id, house1850 = house1850, label1850 = label1850, house1860 = house1860, label1860 = label1860, struct1850 = struct1850, struct1860 = struct1860, walling = walling)
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
        "#panton","#walling1857",
        ]

       # if ! isnothing(tpl.house1850)
       #     push!(pagelines, "#in1850census")
       # end
       # if ! isnothing(tpl.house1860)
       #     push!(pagelines, "#in1860census")
       # end

        
        open(fname,"w") do io
            write(io, join(pagelines, "\n"))
        end
        @info("Wrote file $(fname)")
    end

end


"""Download and read data for a specific census.
$(SIGNATURES)
"""
function readcensusdata(census::Symbol)
    if census == :panton1850 || census == :panton1860
        url = censusurls[census]
        f = Downloads.download(url)
        data = readcensusdata(f)
        rm(f)
        data

    else
        @warn("No records for $(census)")
        nothing
    end
end

"""Read 1850 or 1860 census data from a file.
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
