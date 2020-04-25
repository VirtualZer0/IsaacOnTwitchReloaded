-- Response headers
local header =
[[HTTP/1.1 200 OK
Server: ITMR Server 1.0
Connection: close
Content-Type: application/json
Access-Control-Allow-Origin: *
]]

-- Connect libraries
local socket = require('socket') -- This shit require --luadebug, THANKYOU EDMOND MTHORFKER, I LOVE --LUADEBUG, ALL USERS LOVE F U C K I N G --LUADEBUG
local json = require('json')

-- Root server object
local Server =
{
 _port = 666,       -- Server port
 _header = header,  -- Default headers
 _handlers = {},    -- Handlers for requests
 _running = false,  -- Server state
 
 output = {}        -- What is it? I don't remember
}

-- Bind handler for selected method
function Server:setHandler(method, func)
  self._handlers[method] = func
end

-- Running server on localhost
function Server:run()
  
  if (self._running == true) then
    Isaac.ConsoleOutput("ITMR Server: Already running\n")
    return
  end
  
  self._server = socket.tcp()
  self._server:bind("127.0.0.1", self._port)
  self._server:listen(15)
  self._server:settimeout(0)
  self._running = true
  Isaac.ConsoleOutput("\nITMR Server: Running on 127.0.0.1:"..self._port.."\n")
end

-- Checking new clients
function Server:getRequest()
  local client = self._server:accept()
  if client then
    client:settimeout(0)
    local stop = false
    local rec = ""
    
    while stop == false do
      local str = client:receive("*l")
      
      if (str ~= nil) then
        rec = rec .. "\n" .. str
      else
        stop = true
        break
      end
    end
    
    if rec ~= nil then
      local req = Server.getJSON(rec)
      if req.m == "out" then
        client:send(self._header.."\n"..json.encode({out = Server.ouput}))
        Server.ouput = {}
      elseif self._handlers[req.m] ~= nil then -- Check handler for requested method        
        client:send(self._header.."\n"..json.encode(self._handlers[req.m](req))) -- Call handler
      else
        Isaac.ConsoleOutput("ITMR Server: Not found handler for "..req.m.."\n") -- Handler not found message
        client:send(self._header.."\n{\"res\":\"err\",\"msg\":\"Method not found\"}") -- Response for client
      end
    end
    
    client:close()
  end
end

-- Method for debug server requests
function Server:debugOutput()
  local client = self._server:accept()
  if client then
    client:settimeout(0)
    local stop = false
    local rec = ""
    
    while stop == false do
      local str = client:receive("*l")
      
      if (str ~= nil) then
        rec = rec .. "\n" .. str
      else
        stop = true
        break
      end
    end
    
    if rec ~= nil then
      Isaac.ConsoleOutput("\n"..rec)
    end
    client:send(self._header.."\nContent-Type: application/json\n\n{\"t\":\"t\"}")
    client:close()
  end
end

-- Update function, for comfortable changes in future
function Server:update()
  -- Check if server running
  if (Server._running == false) then return end
  Server:getRequest()
  --Server:debugOutput()
end

-- Close server socket
function Server:close()
  if (Server._running == false) then return end
  self._running = false
  self._server:close()
  Isaac.ConsoleOutput("ITMR Server: Stopped\n")
end

-- Convert string with URI encoded symbols into normal
function Server.decodeURI(s)
  if(s) then
    s = string.gsub(s, "+", " ")
    s = string.gsub(s, '%%(%x%x)', 
      function (hex) return string.char(tonumber(hex,16)) end )
  end
  return s
end

-- Extract JSON from request
function Server.getJSON (str)
  --str = Server.decodeURI(str)
  if (str == nil) then return end
  local strmatch = string.match(str, "{{(.-)}}")
  if (strmatch ~= nil) then
    str = strmatch .."}"
    return json.decode(str)
  else
    return {m="empty"}
  end
end

--Add new output param
function Server:addOutput (obj)
  table.insert(Server.output, obj)
end

return Server;