pointsurl = "https://raw.githubusercontent.com/neelsmith/Vermont.jl/refs/heads/main/data/qgspoints.cex"

walling = "https://dl.dropbox.com/scl/fi/4uhisdr9iwp1bg9aywfk9/commonwealth_wd376466z_image_primary_wgs84ll.tif?rlkey=iy7erqstmygtnm52kn39zr8ik&st=l169peps&dl=1"


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
function vaultlocationnotes(gisdata, destdir)
    for tpl in gisdata
        topicname = string(tpl.walling, " in Walling (1857)") 

        #nowhitespace = replace(topicname, " " => "_")
        fname = joinpath(destdir,  topicname * ".md")

        pagelines = ["---",
        "location: $(tpl.lat),$(tpl.lon)",
        "---", "",
        "# $(topicname)", "",
        "#panton","#walling1857",
        ]

        
        open(fname,"w") do io
            write(io, join(pagelines, "\n"))
        end
        @info("Wrote file $(fname)")
    end

end



"""Download and read GIS data for Walling map of 1857.
$(SIGNATURES)
"""
function readgisdata()
    f = Downloads.download(pointsurl)
    data = readgisdata(f)
    rm(f)
    data
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
    datalines = filter(readlines(f)[2:end]) do ln
        ! isempty(ln)
    end
    data = map(datalines) do ln
        cols = split(ln, "|")
        if length(cols) < 11
            @info("ERROR on $(ln)")
            
        else 
        (mappedraw, cdate, houseraw, familyraw, name, ageraw, sex, color, occupation, realestate, birthplace)  = cols
        house = isempty(houseraw) ? nothing : parse(Int, houseraw)
        family = isempty(familyraw) ? nothing :  parse(Int, familyraw)
        age = nothing
        if ! isempty(ageraw)
            try 
                age = parse(Int, ageraw)
            catch e
                @warn("Error parsing age $(ageraw) in $(ln)")
            end
        end
        mapped = isempty(mappedraw) ? nothing : mappedraw
            (mapped = mapped, censusdate = Date(cdate), house = house, family = family, name = name, age = age, sex = sex, color = color, occupation = occupation, realestate = realestate, birthplace = birthplace)
        end
    end
    filter(t -> ! isnothing(t), data)
end



#=


=#
function vaultcensusnotes(data, destdir; enumeration = "Panton, Addison, Vermont")
    if ! isdir(destdir)
        mkpath(destdir)
    end
    for tpl in data
        yr = tpl.censusdate |> year
        householdname = string("[[", enumeration, ", ", yr, ", household ", tpl.house, "]]")
        topicname = "$(tpl.name) in $(yr) census"
        fname = joinpath(destdir,  topicname * ".md")
        @info("Compose $(fname)")

        pagelines = [
        "# $(topicname)", "",
        "#census$(yr)","",
        "household::$(householdname)", "",
        "## Transcription", "",
        "Enumeration::[[" * enumeration * "]]", "",

        "Date::$(tpl.censusdate)", "",
                  
        "House::$(tpl.house)", "",
        "Family::$(tpl.family)", "",
       
        "Name::" * tpl.name, "",
        "Age::$(tpl.age)", "",
        "Sex::" * tpl.sex, "",
        "Race::" * tpl.color, "",
        "Occupation::" * tpl.occupation, "",
        "Real estate value::$(tpl.realestate)", "",
        "Birthplace::" * tpl.birthplace,""
  
        ]

        
        open(fname,"w") do io
            write(io, join(pagelines, "\n"))
        end
        @info("Wrote file $(fname)")
 
    end

end


