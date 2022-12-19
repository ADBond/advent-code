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
re_operation = r"\s*Operation: new = old (\+|\-|\*|\/) (\d+|old)"
re_divtest = r"\s*Test: divisible by (\d*)"
re_monkeythrow = r"\s*If (true|false): throw to monkey (\d*)"


mutable struct Item
    worrylevel::Int64
end

Base.@kwdef mutable struct Monkey
    items::Array{Item}
    operationfunc::Any
    testdivisibleby::Int8
    testmonkeyindices::Dict{Bool, String}
    inspected::Int64 = 0
end

function giveitem!(monkey::Monkey, item::Item)
    push!(monkey.items, item)
end

function monkeyturn!(monkeys::Dict{String, Monkey}, monkeyindex)
    # println(monkeys)
    monkey = monkeys[monkeyindex]
    testmonkeyindices = monkey.testmonkeyindices
    for item in monkey.items
        # inspection:
        # println(code_typed(monkey.operationfunc, (Integer,)) )
        item.worrylevel = monkey.operationfunc(item.worrylevel)
        monkey.inspected += 1
        # relief
        item.worrylevel = floor(item.worrylevel/3)
        # test
        testbool = mod(item.worrylevel, monkey.testdivisibleby) == 0
        # throw to new monkey
        if testbool
            giveitem!(monkeys[testmonkeyindices[true]], item)
        else
            giveitem!(monkeys[testmonkeyindices[false]], item)
        end
    end
    monkey.items = Item[]
end

function monkeyround!(monkeys::Dict{String, Monkey})
    # for monkeyindex in keys(monkeys)
    # order matters!
    for monkeyindex in 0:(length(monkeys) - 1)
        println("\tDealing with monkey $monkeyindex")
        # soz for gross typing
        monkeyturn!(monkeys, "$monkeyindex")
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
        0
    )
end

function maketestfunction(operator, operand)
    function(x)
        # println("my lovely function has argument $x")
        # println("and operator $operand")
        newoperand = operand == "old" ? x : parse(Int64, operand)
        # println("mlf will use $newoperand")
        operator(x, newoperand)
    end
end

function getinitialmonkeys(filename)
    inputlines = readlines(filename)
    monkeyindex = nothing
    # this syntax is fine, parser is clever
    operatorlookup = Dict(
        "*" => *,
        "+" => +,
        "-" => -,
        "/" => /
    )
    # init, to get us rolling.
    # this is a bad default, that will cause problems if it creeps in
    items = Item[]
    operationfunc = (x -> x)
    testdivisibleby = 0
    testmonkeyindices = Dict(true => "-1", false => "-1")
    # and the actual holster for the monkeys
    initialmonkeys = Dict{String, Monkey}()
    for line in inputlines
        # println(line)
        # i _really_ need to get a better pattern than continuously doing this
        # obviously should be able to use match() directly
        if occursin(re_monkeyindex, line)
            # println("fresh monkeyman")
            # not sure if this is idiomatic. Check that at some stage.
            if monkeyindex != nothing && !haskey(initialmonkeys, monkeyindex)
                error("Don't think this should happen")
            end
            # okay this is very hacky, but let's initialise here with different value to above
            # will make it easier to trace if bad values sneak through
            testmonkeyindices = Dict(true => "-2", false => "-2")
            monkeyindex = match(re_monkeyindex, line).captures[1]
            # println(monkeyindex)
        elseif occursin(re_startingitems, line)
            # println("obviously here we complain")
            itemsstring = match(re_startingitems, line).captures[1]
            items = split(itemsstring, ",")
            items = filter(x -> x != nothing, items)
            # println(items)
            items = map(x -> Item(parse(Int8, x)), items)
            # println(items)
        elseif occursin(re_operation, line)
            # println(line)
            # could use some eval magic, but let's not
            (operatorstring, operand) = match(re_operation, line)
            operator = operatorlookup[operatorstring]
            operationfunc = maketestfunction(operator, operand)
        elseif occursin(re_divtest, line)
            testdivisibleby = parse(Int8, match(re_divtest, line).captures[1])
        elseif occursin(re_monkeythrow, line)
            (condition, to_monkey) = match(re_monkeythrow, line).captures
            # I do not love this
            condition = parse(Bool, condition)
            # to_monkey = parse(Int8, to_monkey)
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

function iteratemonkeys!(monkeys, rounds)
    for i in 1:rounds
        println("round $i")
        monkeyround!(monkeys)
    end
end

function monkeybusiness(filename, rounds)
    monkeys = getinitialmonkeys(filename)
    iteratemonkeys!(monkeys, rounds)
    println(monkeys)
    monkeysarranged = Int64[]
    for monkey in values(monkeys)
        push!(monkeysarranged, monkey.inspected)
    end
    monkeysarranged = sort(monkeysarranged, rev=true)
    prod(monkeysarranged[1:2])
end


println("Part 1:")
# should be
println(monkeybusiness(inputfilenametest, 20))
println(monkeybusiness(inputfilename, 20))


println("Part 2:")

end
