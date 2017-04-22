require_relative '../../automated_init'

context 'handle command with store success' do

  require 'pry'
  binding.pry

  handler = Handlers::Events.build


  cloud_store = FileTransferComponent::Controls::CloudStoreSuccess.example

  clock_time = Controls::Time::Raw.example
  time = Controls::Time::ISO8601.example(clock_time)

  handler.clock.now = clock_time
  handler.cloud_store = cloud_store

  entity = Controls::File.example

  initiated = Controls::Events::Initiated.example
  initiated.file_id = entity.id

  handler.store.put(entity.id, entity)

  handler.(initiated)

  context 'Initiate' do
    writes = handler.write.writes do |written_event|
      written_event.class.message_type == 'Published'
    end

    published = writes.first.data.message

    test 'published event is written' do
      refute(published.nil?)
    end

    context 'Recorded stream attributes' do
      test 'File id set' do
        assert(published.file_id == initiated.file_id)
      end

      test 'File cloud_uri set' do
        refute(published.file_cloud_uri.nil?)
      end
    end
  end
end

context 'handle command with store fail' do
  handler = Handlers::Events.new

  cloud_store = FileTransferComponent::Controls::CloudStoreFail.example

  clock_time = Controls::Time::Raw.example
  time = Controls::Time::ISO8601.example(clock_time)

  handler.clock.now = clock_time
  handler.cloud_store = cloud_store

  entity = Controls::File.example

  initiated = Controls::Events::Initiated.example
  initiated.file_id = entity.id

  handler.store.put(entity.id, entity)

  handler.(initiated)

  context 'Initiate' do
    writes = handler.write.writes do |written_event|
      written_event.class.message_type == 'PublishFailed'
    end

    publish_failed = writes.first.data.message

    test 'publish_failed event is written' do
      refute(publish_failed.nil?)
    end

    context 'Recorded stream attributes' do
      test 'File id set' do
        assert(publish_failed.file_id == initiated.file_id)
      end

      test 'File error set' do
        refute(publish_failed.error_message.nil?)
      end
    end
  end
end
