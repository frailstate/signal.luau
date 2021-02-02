local Signal = {}

-- // @constructor(eventName: string): Signal
function Signal.new(name)
	local newSignal = {
		id = name or error('Signal.new :: Identifier must be provided.'),
		connections = {}
	}

	return setmetatable(newSignal, {
		__index = Signal, 
		__tostring = function()
			return newSignal.id
		end
	})
end

-- // @method Signal:Connect(handler: (args...) => void): Connection
function Signal:Connect(handler)
	handler = type(handler) == 'function' and handler or error('Signal:Connect :: Argument 1 must be a function.')

	local newConnection = {
		_handler = handler,
		Connected = true,

		Disconnect = function(connection, s)
			table.remove(self.connections, table.find(self.connections, connection))
			connection.Connected = false
		end
	}

	self.connections[#self.connections + 1] = newConnection
	return newConnection
end

-- // @method Signal:Fire(args...)
function Signal:Fire(...)
	for _, connection in ipairs(self.connections) do
		connection._handler(...)
	end
end

-- // @method [yields] Signal:Wait(): args...
function Signal:Wait()
	local thread, conn = coroutine.running()
	conn = self:Connect(function(...)
		conn:Disconnect(); conn = nil
		coroutine.resume(thread, ...)
	end)
	return coroutine.yield()
end

return Signal
