-- api.lua
local http = require("socket.http")
local ltn12 = require("ltn12")
local json = require("cjson")

local function get_domains()
    local response = {}
    http.request{
        url = "http://api.buss.lol/domains",
        sink = ltn12.sink.table(response)
    }
    return table.concat(response)
end

local function create_domain(domain)
    local response = {}
    http.request{
        url = "http://api.buss.lol/domain",
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = #domain
        },
        source = ltn12.source.string(domain),
        sink = ltn12.sink.table(response)
    }
    return table.concat(response)
end

-- Functions to be called from HTML
function fetch_all_domains()
    return get_domains()
end

function register_domain(name, tld, ip)
    local domain = json.encode({name = name, tld = tld, ip = ip})
    return create_domain(domain)
end
