require 'socket'
require 'byebug'
require 'celluloid'
trap('INT') { puts "\nbailing" ; exit }

module UDPTester
  class Client
    attr_accessor :hex_bytes, :command

    def initialize hex_bytes, command
      @command = command.to_s
      @hex_bytes = hex_bytes
      binary_bytes = hex_bytes.scan(/../).map{|x|x.hex.chr}.join
    end

    def deliver
      message = UDPTester::Message.new(hex_bytes, command)
      message.async.send
    end

    def loop_deliver
      index = 0
      loop do
        puts "Index: #{index}"
        deliver
        sleep 0.25
        index += 1
      end
    end
  end

  class Message
    include Celluloid
    attr_accessor :bytes, :payload, :command
    UDP_SERVER_IP = 'localhost'
    PORT = 45312

    trap_exit :actor_died

    def actor_died(actor, reason)
      p "Oh no! #{actor.inspect} has died because of a #{reason.class}"
    end

    def initialize bytes, command
      @bytes = bytes
      @command = command
      @payload = set_payload
    end

    # Called async and requires a terminate to GC the actor
    def send
      UDPSocket.new.send(payload, 0, UDP_SERVER_IP, PORT)
      puts "Sent UDP Message: #{payload}"
    ensure
      terminate
    end

    private
    def set_payload
      case @command
      when 'test'
        "#{rand(0..100000)}"
      when 'wsnd'
        bytes
      else
        raise ArgumentError.new "Unsupported Payload Format"
      end
    end
  end
end


command = ARGV[0]
hex_bytes = '57534e440308f10000000016b001020172ff0057534e4403eb8adea3040016b0060104ac9f8f5302b10204000000000271430101ff0202960bff03020f000207ff02fbffff04024609020410ff0a04d71d0600ff0602760dffe8'
client = UDPTester::Client.new(hex_bytes, command)
# Single deliver
# client.deliver

# Loop Single deliver
client.loop_deliver
