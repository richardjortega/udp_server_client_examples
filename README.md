### UDP Server/Client Examples

Examples of UDP Servers and Clients in Ruby and Go, adjust sleep in `udp_client.rb` for speed.

**udp_client.rb | Ruby UDP Client**
Ruby UDP Client that will send abritrary messages to the Go Server/Client

**udp_server_client.rb | Go UDP Server/Client**
Go UDP Server/Client that echos out the messages to a Ruby UDP Server

**udp_server.rb | Ruby UDP Server**
Ruby UDP Server that will receive abrtirary messages over UDP and STDOUT the message.

#### Requirements
`go` and `ruby` must be installed for these to work.


#### Setup

```
$ git clone git@gitlab.swiftwater.lab:richardjortega/udp_server_client_examples.git

# Install related gems
$ bundle install
```

#### Usage
###### Start Ruby UDP Client
```
# Send random string of integers via UDP
$ ruby udp_client.rb test

# Send bytes in hex via UDP
$ ruby udp_client.rb bytes
```

####### Start Go UDP Server/Client
```
$ go run udp_server_client.go
```

####### Start Ruby UDP Server
```
$ ruby udp_server.rb
```
