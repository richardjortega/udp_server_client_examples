package main

import (
  "fmt"
  "net"
  "os"
)

// Err helper func
func CheckError(err error) {
  if err != nil {
    fmt.Println("Error: ", err)
    os.Exit(0)
  }
}

func main() {
  ServerAddr := net.UDPAddr {
    Port: 45312,
    IP: net.ParseIP("localhost"),
  }

  ServerConn, err := net.ListenUDP("udp", &ServerAddr)
  defer ServerConn.Close()
  CheckError(err)

  fmt.Println("Started UDP Listener...")

  // Main UDP loop
  // Read up to 4K bytes
  buf := make([]byte, 4096)

  for {
    n, addr, err := ServerConn.ReadFromUDP(buf)
    fmt.Println("Received ", string(buf[0:n]), " from ", addr)

    CheckError(err)

    // Goroutine UDP send messages
    go func() {
      SendPkt(buf)
    }()
  }
}

func SendPkt(msg []byte) {
  ServerAddr := net.UDPAddr {
    Port: 45315,
    IP: net.ParseIP("localhost"),
  }

  LocalAddr := net.UDPAddr {
    Port: 0,
    IP: net.ParseIP("localhost"),
  }

  ServerConn, err := net.DialUDP("udp", &LocalAddr, &ServerAddr)
  CheckError(err)

  defer ServerConn.Close()

  ServerConn.Write(msg)
}
