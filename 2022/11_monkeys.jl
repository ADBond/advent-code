module constants
export inputfilename, inputfilenametest
inputfilename = "2022/11monkeys.input.txt"
inputfilenametest = "2022/11monkeys_test.input.txt"
end

module v1
using ..constants

# let's not be too clever
re_monkeyindex = r"Monkey (\d*):"
re_startingitems = r"\s*Starting items: (\d+(?:,\s*\d+)*)"
re_operation = r"\s*Operation: new = old (\+|\-|\*|\/) (\d*|old)"
re_divtest = r"\s*Test: divisible by (\d*)"
re_monkeythrow = r"\s*If (true|false): throw to monkey (\d*)"


mutable struct Item
    worrylevel::Int64
end

Base.@kwdef mutable struct Monkey
    items::Array{Item}
    operationfunc::Any
    testdivisibleby::Int8
    testmonkeyindices::Dict{Bool, Int8}
    inspected::Int8 = 1
end

function monkeyturn!(monkeys::Dict{Monkey}, monkeyindex)
    monkey = monkeys[monkeyindex]
    for item in monkey.items
        # inspection:
        item.worrylevel = monkey.operationfunc(item.worrylevel)
        monkey.inspected += 1
        # relief
        item.worrylevel = floor(item.worrylevel/3)
        # test
        testbool = mod(item.worrylevel, monkey.testdivisibleby)
        # throw to new monkey
        if testbool
            push!(monkeys[testmonkeyindices[1]], item)
        else
            push!(monkeys[testmonkeyindices[2]], item)
        end
    end
end

function monkeyround!(monkeys::Dict{Monkey})
    for i in 1:length(monkeys)
        monkeyturn!(monkeys, i)
    end
end

function insertmonkey!(
    initialmonkeys,
    monkeyindex,
    items,
    operationfunc,
    testdivisibleby,
    testmonkeyindices
)
    if monkeyindex == nothing || haskey(initialmonkeys, monkeyindex)
        error("Don't think this should happen")
    end
    initialmonkeys[monkeyindex] = Monkey(
        items,
        operationfunc,
        testdivisibleby,
        testmonkeyindices,
        1
    )
end

function getinitialmonkeys(filename)
    inputlines = readlines(filename)
    monkeyindex = nothing
    # init, to get us rolling.
    # this is a bad default, that will cause problems if it creeps in
    items = Item[]
    operationfunc = (x -> x)
    testdivisibleby = 0
    testmonkeyindices = Dict(true => -1, false => -1)
    # and the actual holster for the monkeys
    initialmonkeys = Dict()
    for line in inputlines
        println(line)
        # i _really_ need to get a better pattern than continuously doing this
        # obviously should be able to use match() directly
        if occursin(re_monkeyindex, line)
            println("fresh monkeyman")
            # not sure if this is idiomatic. Check that at some stage.
            if monkeyindex != nothing && !haskey(initialmonkeys, monkeyindex)
                error("Don't think this should happen")
            end
            # okay this is very hacky, but let's initialise here with different value to above
            # will make it easier to trace if bad values sneak through
            testmonkeyindices = Dict(true => -2, false => -2)
            monkeyindex = match(re_monkeyindex, line).captures[1]
            println(monkeyindex)
        elseif occursin(re_startingitems, line)
            println("obviously here we complain")
            itemsstring = match(re_startingitems, line).captures[1]
            items = split(itemsstring, ",")
            items = filter(x -> x != nothing, items)
            println(items)
            items = map(x -> Item(parse(Int8, x)), items)
            println(items)
        elseif occursin(re_operation, line)
            nothing
        elseif occursin(re_divtest, line)
            testdivisibleby = parse(Int8, match(re_divtest, line).captures[1])
        elseif occursin(re_monkeythrow, line)
            (condition, to_monkey) = match(re_monkeythrow, line).captures
            # I do not love this
            condition = parse(Bool, condition)
            to_monkey = parse(Int8, to_monkey)
            testmonkeyindices[condition] = to_monkey
        elseif line == ""
            # put it all together
            insertmonkey!(
                initialmonkeys,
                monkeyindex,
                items,
                operationfunc,
                testdivisibleby,
                testmonkeyindices
            )
        else
            error("Well that did not work: '$line'")
        end
    end
    insertmonkey!(
        initialmonkeys,
        monkeyindex,
        items,
        operationfunc,
        testdivisibleby,
        testmonkeyindices
    )
    initialmonkeys
end

println("Part 1:")
# should be
println(getinitialmonkeys(inputfilenametest))


println("Part 2:")

end
