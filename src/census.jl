
function familyids(data)
    familyids = map(t -> t.family, data) |> unique
end

"""Extract records for heads of household from a data vector.
$(SIGNATURES)
"""
function hohlist(data)
   
end