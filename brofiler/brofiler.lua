
local M = {}

M.total_time = 0
M.segments = {}

function M.frame_init()

    if M.total_time > 0 then

        print("--BROFILER--")
        print("Tracked segments took a total time of " .. math.ceil(M.total_time * 10000) / 10000 .. "s to execute.")
        for segment, table in pairs(M.segments) do
            print(segment .. " took " .. math.ceil(table.total_time * 10000) / 10000 .. "s (" .. math.ceil(table.total_time / M.total_time * 1000) / 10 .. "%), called " .. table.num_calls .. " times")
        end
        print("--END BROFILER--")

    end

    M.total_time = 0
    M.segments = {}
end

function M.start_segment(segment)

    if not M.segments[segment] then
        M.segments[segment] = {total_time = 0, num_calls = 0}
    end
    
    M.segments[segment].current_start = socket.gettime()
end

function M.end_segment(segment)

    if not M.segments[segment] then
        return
    end

    local t = socket.gettime() - M.segments[segment].current_start

    M.segments[segment].total_time = M.segments[segment].total_time + t
    M.segments[segment].num_calls = M.segments[segment].num_calls + 1

    M.total_time = M.total_time + t

end

return M