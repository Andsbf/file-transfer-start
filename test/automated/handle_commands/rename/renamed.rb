require_relative '../../automated_init'

context 'handle command' do
  handler = Handlers::Commands.new

  clock_time = Controls::Time::Raw.example
  time = Controls::Time::ISO8601.example(clock_time)

  handler.clock.now = clock_time

  rename = Controls::Commands::Rename.example

  entity = Controls::File.example
  entity.id = rename.file_id

  handler.store.put(entity.id, entity)

  handler.(rename)

  context 'Rename' do
    writes = handler.write.writes do |written_event|
      written_event.class.message_type == 'Renamed'
    end

    renamed = writes.first.data.message

    test 'Renamed event is written' do
      refute(renamed.nil?)
    end

    context 'Recorded stream attributes' do
      test 'File name set' do
	assert(renamed.name == rename.name)
      end

      test 'File time set' do
	assert(renamed.time == rename.time)
      end

      test 'File processed_time set' do
	assert(renamed.processed_time == time)
      end

      test 'File has no nils' do
	renamed.attributes.each do |attr,val|
	  refute(val.nil?)
	end
      end
    end
  end
end
