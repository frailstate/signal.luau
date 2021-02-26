local Signal = { 
	__tostring = function(ctx)
		return ctx.id
	end
}
Signal.__index = Signal

-- // @constructor(eventName: string): Signal
function Signal.new(name)
	local newSignal = {
		id = name or error('Signal.new :: Identifier must be provided.'),
		connections = {}
	}

	return setmetatable(newSignal, Signal)
end

-- // @method Signal:Connect(handler: (args...) => void): Connection
function Signal:Connect(handler)
	handler = type(handler) == 'function' and handler or error('Signal:Connect :: Argument 1 must be a function.')

	local newConnection = {
		Connected = true,

		Disconnect = function(connection)
			self.connections[connection] = nil
			connection.Connected = false
		end
	}

	self.connections[newConnection] = handler
	return newConnection
end

-- // @method Signal:Fire(args...)
function Signal:Fire(...)
	for connection, handler in pairs(self.connections) do
	    handler(...)
	end
end

-- // @method [yields] Signal:Wait(): args...
function Signal:Wait()
	local thread, conn = coroutine.running()
	conn = self:Connect(function(...)
		conn:Disconnect()
		conn = nil
		coroutine.resume(thread, ...)
	end)
	return coroutine.yield()
end

return Signal
