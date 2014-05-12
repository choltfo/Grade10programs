% The "Chat" program
        const chatPort : int := 5055
        var choice : int
        loop
            put "Enter 1 to run chat server"
            put "Enter 2 to run chat session"
            put "Choice: " ..
            get choice
            exit when choice = 1 or choice = 2
        end loop
        var netStream : int
        var netAddress : string
        
        if choice = 1 then
            netStream := Net.WaitForConnection (chatPort, netAddress)
        else
            put "Enter the address to connect to: " ..
            get netAddress
            netStream := Net.OpenConnection (netAddress, chatPort)
            if netStream <= 0 then
                put "Unable to connect to ", netAddress
                return
            end if
        end if
        Draw.Cls
        put "Connected to ", netAddress
        
        var localRow : int := 2
        var localCol : int := 1
        var remoteRow := maxrow div 2
        var remoteCol : int := 1
        var ch : char
        
        View.Set ("noecho")
        loop
            if hasch then
                ch := getchar
                put : netStream, ch
                if ch = '\n' then
                    localRow := localRow mod (maxrow div 2) + 1
                    localCol := 1
                    Text.Locate (localRow, localCol)
                    put "" % Clear to end of line
                    Text.Locate (localRow, localCol)
                else
                    Text.Locate (localRow, localCol)
                    
                    put ch ..
                    localCol += 1
                end if
            end if
        
            if Net.CharAvailable (netStream) then
                get : netStream, ch
                if ch = '\n' then
                    remoteRow := remoteRow mod (maxrow div 2) +
                        1 + (maxrow div 2)
                    remoteCol := 1
                    Text.Locate (remoteRow, remoteCol)            put ""  % Clear to end of line
                    Text.Locate (remoteRow, remoteCol)
                else
                    Text.Locate (remoteRow, remoteCol)
                    put ch ..
                    remoteCol += 1
                end if
            end if
        end loop