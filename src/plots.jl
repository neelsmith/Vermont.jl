

"""Compose a bar chart with the frequency of
real estate values in a census data set.
$(SIGNATURES)
"""
function realestatebarchart(data)
    propvals = map(filter(t -> ! isempty(t.realestate), data)) do rec
        parse(Int, rec.realestate)
    end
    valsdict = countmap(propvals) |> OrderedDict
    sort!(valsdict, rev=true)
    
    xlist = keys(valsdict) |> collect
    ylist = values(valsdict) |> collect
    f = Figure()
    Axis(f[1, 1],
        title = "Real estate values in census district",
        xlabel = "Value of property (dollars)", 
        ylabel = "Number of properties",
        xtickformat = v -> map(n -> string('$', n), format.(v, commas=true, precision=0))
)


    barplot!(xlist, ylist, width=100, gap = 0)

    f
end