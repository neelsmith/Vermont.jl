
function familyids(data)
    familyids = map(t -> t.family, data) |> unique
end



function householdids(data)
    familyids = map(t -> t.house, data) |> unique
end



"""Extract records for heads of household from a vector of tuples with census data.
$(SIGNATURES)
"""
function hohlist(data)
   heads = []
   currenthouse = 0
   for tpl in data
        if tpl.house != currenthouse
            push!(heads, tpl.name)
            currenthouse = tpl.house
        end
   end
   heads
end


function housemembers(data, name::String)
    matches = filter(tpl -> tpl.name == name, data)
    map(t -> t.name, matches)
end

function housemembers(data, houseid::Int)
    matches = filter(tpl -> tpl.house == houseid, data)
    map(t -> t.name, matches)
end

function households(data)
    housedict = Dict()
    for i in familyids(data)
        matches = filter(tpl -> tpl.house == i, data)
        housedict[i] = map(t -> t.name, matches)
    end
    housedict
end

function males(data)
    matches = filter(tpl -> tpl.sex == "M", data)
    map(t -> t.name, matches)  
end

function females(data)
    matches = filter(tpl -> tpl.sex == "F", data)
    map(t -> t.name, matches)  
end