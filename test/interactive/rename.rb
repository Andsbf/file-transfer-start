require_relative '../client_test_init'
require_relative '../test_init'

file_id = ENV['FILE_ID']
name = ENV['NAME']

name ||= 'test.md'
uri ||= FileTransferComponent::Controls::URI.file

file_id = Client::Initiate.(name, uri)

command_handler = FileTransferComponent::Handlers::Commands.build

EventSource::Postgres::Read.("fileTransfer:command") do |event_data|
  command_handler.(event_data)
end

sleep(1)

Client::Rename.(file_id, name)

EventSource::Postgres::Read.("fileTransfer:command") do |event_data|
  command_handler.(event_data)
end
