
local M = {}

M.total_time = 0
M.segments = {}
M.frame_log = {}

function M.frame_init()
    
    

    if M.total_time > 0 then

        local num = #M.frame_log+1
        M.frame_log[num] = {total_time = M.total_time, segments = {}}

        print("--BROFILER--")
        print("Tracked segments took a total time of " .. math.ceil(M.total_time * 10000) / 10000 .. "s to execute.")
        for segment, t in pairs(M.segments) do
            print(segment .. " took " .. math.ceil(t.total_time * 10000) / 10000 .. "s (" .. math.ceil(t.total_time / M.total_time * 1000) / 10 .. "%), called " .. t.num_calls .. " times")
            table.insert(M.frame_log[num].segments, {id = segment, time = t.total_time})
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

local function clone(t)
  local rtn = {}
  for k, v in pairs(t) do rtn[k] = v end
  return rtn
end

local function sort(t, comp)
    local rtn = clone(t)
    if comp then
        if type(comp) == "string" then
            table.sort(rtn, function(a, b) return a[comp] > b[comp] end)
        else
            table.sort(rtn, comp)
        end
    else
        table.sort(rtn)
    end
    return rtn
end

function M.show_longest_frames(num)
    
    num = num or 3

    local sorted = sort(M.frame_log, "total_time")

    local suffix_t = {
        "st", "nd", "rd"
    }
    local suffix = nil
    for i=1,num do
        if i >= 3 then
            suffix = suffix_t[3]
        else
           suffix = suffix_t[i] 
        end
        print(i .. suffix .. " longest frame: ")
        pprint(sorted[i])
    end
end

return M