module FileTransferComponent
  module Controls
    module Events
      module Renamed
        def self.example

          renamed = FileTransferComponent::Messages::Events::Renamed.build

          renamed.file_id = ID.example
          renamed.name = "some_rename"
          renamed.time = Controls::Time::Effective.example
          renamed.processed_time = Controls::Time::Processed.example

          renamed
        end
      end
    end
  end
end
