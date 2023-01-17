module constants
export inputfilename, inputfilenametest
inputfilename = "2022/13signals.input.txt"
inputfilenametest = "2022/13signals_test.input.txt"
end

module v1
using ..constants

@enum PACKETCOMPARISON correct incorrect same

struct Packet
    contents::Union{Array, Integer}
end

function reverse(comparison::PACKETCOMPARISON)
    if comparison == correct
        return incorrect
    elseif comparison == incorrect
        return correct
    end
    same
end

function iscorrectlyordered(number_l::Integer, number_r::Integer)::PACKETCOMPARISON
    if number_l == number_r
        return same
    end
    number_l < number_r ? correct : incorrect
end

function iscorrectlyordered(list_l::Array, list_r::Array)::PACKETCOMPARISON
    for i in 1:length(list_l)
        right_item = get(list_r, i, nothing)
        # if right items runs out first, wrong order
        if right_item == nothing
            return incorrect
        end
        comparison = iscorrectlyordered(list_l[i], right_item)
        if comparison != same
            return comparison
        end
    end
    # if left runs out, correct order
    if length(list_r) > length(list_l)
        return correct
    end
    same
end

function iscorrectlyordered(list_l::Array, number_r::Integer)::PACKETCOMPARISON
    iscorrectlyordered(list_l, [number_r])
end

function iscorrectlyordered(number_l::Integer, list_r::Array)::PACKETCOMPARISON
    reverse(iscorrectlyordered(list_r, number_l))
end

function iscorrectlyordered(packet_l::Packet, packet_r::Packet)::PACKETCOMPARISON
    iscorrectlyordered(packet_l.contents, packet_r.contents)
end

function correctlyorderedpairs(filename)
    lines = readlines(filename)
    index = 1
    packets = Packet[]
    correctindices = Integer[]
    for line in lines
        if line != ""
            # sorry!
            current = Packet(eval(Meta.parse(line)))
            push!(packets, current)
        else
            if length(packets) != 2
                error("Oopsie")
            end
            if iscorrectlyordered(packets[1], packets[2]) == correct
                push!(correctindices, index)
            end
            index += 1
            packets = Packet[]
        end
    end
    correctindices
end

function quicksort(list)
    if length(list) < 2
        return list
    end
    pivot = list[1]
    # could be cleverer with array types here, but probably overkill for this
    fore = []
    aft = []
    for item in list[2:end]
        order = iscorrectlyordered(item, pivot)
        if order == correct
            push!(fore, item)
        else
            # let ties go to the aft list
            push!(aft, item)
        end
    end
    [quicksort(fore)..., pivot, quicksort(aft)...]
end

function getallpackets(filename)
    lines = readlines(filename)
    packets = Packet[]
    for line in lines
        if line != ""
            # sorry!
            current = Packet(eval(Meta.parse(line)))
            push!(packets, current)
        end
    end
    packets
end

function getdividerindices(filename)
    dividers = [Packet([[2]]), Packet([[6]])]
    input = [getallpackets(filename)..., dividers...]
    sorted = quicksort(input)
    dividerindices = Integer[]
    for i in 1:length(sorted)
        if sorted[i] in dividers
            push!(dividerindices, i)
        end
    end
    dividerindices
end

println("Part 1:")

# incorrect x2
println(iscorrectlyordered([1,[2,[3,[4,[5,6,7]]]],8,9], [1,[2,[3,[4,[5,6,0]]]],8,9]))
println(iscorrectlyordered([[[]]], [[]]))

# should be 13
println(sum(correctlyorderedpairs(inputfilenametest)))
println(sum(correctlyorderedpairs(inputfilename)))

println("Part 2:")
# should be 140
println(prod(getdividerindices(inputfilenametest)))
println(prod(getdividerindices(inputfilename)))

end
