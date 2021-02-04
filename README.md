# Signal.luau
A Signal module made to replicate [to the best of its ability] the RbxScriptSignal library from Roblox, in pure Luau.
# The API
Signal boasts an intuitive, easy to pick-up API with very little set-up.

| Name     | Description     | 
| :----------: | ----- |
|  `SignalModule.new(name: string): Signal` | Creates a new Signal with id `name`.|
| `Signal:Connect(f: (args...) -> void): Connection`   | Connects `f` to Signal so that it will be called upon invocation. Args are sent from the invocation. |
| `Signal:Wait(): args...` | Yields the current thread until the Signal is invoked. Returns what was sent with the invocation. |
| `Connection:Disconnect(): void` | Disconnects the Connection so that any further invocations will not fire the function associated with this connection. |
| `Connection.Connected` | A `boolean` that describes whether not this Connection is connected. |
