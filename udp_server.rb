#!/usr/local/bin/ruby

require 'socket'

# Trap (Ctrl-C) interrupts, write a note, and exit immediately
# in parent. This trap is not inherited by the forks because it
# runs after forking has commenced.
trap('INT') { puts "\nbailing" ; exit }

class Listener
  def initialize
    @port = 45315
  end

  def run
    puts "Started UDP server. Listening on #{@port}..."
    Socket.udp_server_loop(@port) {|msg, msg_src|
      begin
        message_size = msg.length
        source_ip = msg_src.remote_address.ip_address
        puts "Time: #{Time.now.to_f} | Source: #{source_ip} | Size: #{message_size} | Message: #{msg}"
      rescue => ex
        puts "Rescued: #{ex.message}"
        puts ex.backtrace.join("\n")
      end
    }
  end
end

############
# Main process
############
listener = Listener.new
listener.run
