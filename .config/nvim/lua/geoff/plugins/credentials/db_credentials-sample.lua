local function url_encode(str)
	if not str then
		return str
	end
	str = string.gsub(str, "([^%w%-%.%_%~])", function(c)
		return string.format("%%%02X", string.byte(c))
	end)
	return str
end

local username = "<DB_USERNAME>"
local password = "<DB_PASSWORD>"
local host = "<HOST_IP>"
local port = "<HOST_PORT>"

-- TODO: Create a way to load these credentials in a working directory or project rather than
-- a huge list of connections in the configs.
return {
	_database1_ = string.format("postgres://%s:%s@%s:%s/<database1>", username, url_encode(password), host, port),
	_database2_ = string.format("postgres://%s:%s@%s:%s/<database2>", username, url_encode(password), host, port),
}
