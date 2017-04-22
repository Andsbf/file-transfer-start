module FileTransferComponent
  module Handlers
    class Events
      # class Initiated
        include Messaging::Handle
        include Messaging::Postgres::StreamName # includes the stream_name method
        include FileTransferComponent::Messages::Commands
        include FileTransferComponent::Messages::Events
        include Log::Dependency

        dependency :write, Messaging::Postgres::Write
        dependency :clock, Clock::UTC
        dependency :store, FileTransferComponent::Store
        dependency :cloud_store, CloudStore

        def configure
          require 'pry'
          binding.pry
          Messaging::Postgres::Write.configure self
          Clock::UTC.configure self
          FileTransferComponent::Store.configure self
          CloudStore.configure self
        end

        category :file_transfer

        handle Initiated do |initiated|

          file_id = initiated.file_id

          file, stream_version = store.get(file_id, include: :version)

          unless file.cloud_uri.nil?
            logger.debug "#{initiated} event was ignored. File trasfer #{file_id} has already been published"
            return
          end

          time = clock.iso8601

          stream_name = stream_name(file_id)


          ok, meta = cloud_store.upload(initiated.temp_path)

          if ok
            file_transfer_published = Published.follow(initiated, include: [:file_id])

            file_transfer_published.file_cloud_uri =meta[:address]

            file_transfer_published.processed_time = time

            write.(file_transfer_published, stream_name, expected_version: stream_version)
          else
            file_transfer_publish_failed = PublishFailed.follow(initiated, include: [:file_id])

            file_transfer_publish_failed.error_message = meta[:error]

            file_transfer_publish_failed.processed_time = time

            write.(file_transfer_publish_failed, stream_name, expected_version: stream_version)
          end
        end
      # end
    end
  end
end
