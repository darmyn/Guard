# Welcome to the Guard wiki!

### __MODULE__
***
###### METHODS
```lua 
Guard:Start() 
--> Returns: NIL
--> About: Starts the guard cycle. All initialized guards will be periodically scanned based on the guards buffSpeed
--> Note: Invoking this method while the guard has already been started / is running will have no effect.
```

```lua
Guard:Stop()
--> Returns: NIL
--> About: Stops the guard cycle. All initialized guards will not be scanned.
--> Note: Invoking this method while the guard is already stopped will have no effect.
```
***
### __GUARD__
###### PROPERTIES
```lua
guard.buffSize
--> About: How many slots are available in the buffer. Once the buffer's size reaches the buffSize, it will start removing the oldest value from the buffer every time a new value is added
--> Note: Changing the buff size will automatically apply on the next scan.
```
```lua
guard.buffSpeed
--> About: How fast the guard is scanned. Each guard can have it's own buffer speed. The guard will be scanned in intervals, with the interval being the value of guard.BuffSpeed
--> Note: Changing the buff speed will automatically apply on the next scan.
```

###### METHODS
***
```lua
guard:Bind(bindBin: String, callback: Function)
--> Returns: Bind
--> About: There are two bindBins, "onCycle" and "onScan". See properties > guard.bindBins. Each function inside of a bindBin is fired each scan. onCycle fires first, and is when you should be writing data to the buffer. onScan is the second process, where all the data has been written, and you should be running algorithms to determine if a player is cheating or not
--> Note: You can bind as many functions to a bindBin as you want.
```
```lua
guard:Write(data: Dictionary)
--> Returns: NIL
--> About: adds all key/value pairs from "data" into the cHead position, which is the newest position of the buffer.
```
```lua
guard:Read()
--> Returns: cHead: Dictionary, cNeck: Dictionary
--> About: Returns the 2 newest key value pairs of the buffer, so you can compare the data from the current frame to the last. For example checking distance travelled since the last scan to tell if a player is speed hacking.
```
```lua
guard:GetBuffer()
--> Returns: buffer: Dictionary
--> About: Returns the entire buffer. The size of the buffer is corresponding to guard.buffSize
--> Note: If you do not understand what the circular buffer is, you should use this function to learn.
```
```lua
guard:SecondsToBuffSize(seconds: Number)
--> Returns: bufferSize: Number
--> About: Takes a number representing time in seconds, and returns the recommended buffSize in order to store "seconds" amount of data in the buffer.
```
***
