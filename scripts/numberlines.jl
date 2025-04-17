
function numberlines(v::Vector{String}, pg::Int)

    numbered = []
    currline = 0
    for ln in filter(ln -> ! isempty(ln), v)
        currline = currline + 1
        newline = string(pg, "|", currline, "|", ln)
        push!(numbered,newline)
    end
    numbered
end



function numberpagelines(v)
    results = []
    currpage = 0
    currline = 0
    for ln in filter(ln -> ! isempty(ln), v)
        if startswith("#", ln)
            currpage = currpage + 1
            push!(results, "")
        else
            currline = currline + 1
            newline = string(currpage, "|", currline, "|", ln)
            push!(results,newline)
        end
    end
    results
end