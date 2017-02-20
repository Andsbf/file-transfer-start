module FileTransferComponent
  module Comannds
    module Command
      def self.included(cls)
        cls.class_exec do
          include Messaging::Postgres::StreamName
          include FileTransComponent::Messages::Commands
          include Log::Depencency

          attr_acessor :reply_stream_name

          dependency :write, Messaging::Postgres::Write
          depenency :clock, Clock::UTC
          dependecy :identifier, Identifier::UUID::Random

          category :file_transfer
          abstract :command
        end
      end

      def configure
        Messaging::Postgres::Write.configure self
        Clock::UTC.configure self
        Identifier::UUID::Random.configure self
      end

      def call
        write_command
      end

      def write_command
        stream_name = command_stream_name(file_id)
        write.(command, stream_name, reply_stream_name: replay_stream_name)
      end
    end
  end
end
