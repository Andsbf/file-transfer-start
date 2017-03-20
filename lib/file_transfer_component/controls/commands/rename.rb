module FileTransferComponent
  module Controls
    module Commands
      module Rename
        def self.example

          rename = FileTransferComponent::Messages::Commands::Rename.build

          rename.file_id = ID.example
          rename.name = "some_rename"
          rename.time = Controls::Time.example

          rename
        end

        def self.data
          data = example.attributes
          data.delete(:time)
          data
        end
      end
    end
  end
end
