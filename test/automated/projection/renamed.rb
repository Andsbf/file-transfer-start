require_relative '../automated_init'

context "File Projection" do

  entity = Controls::File.example
  event = Controls::Events::Renamed.example

  event.file_id = entity.id

  fixture = Fixtures::Projection.build(
    projection: Projection,
    entity: entity,
    event: event
  )

  fixture.() do |test|
    test.assert_attributes_copied([
      {file_id: :id},
      :name,
    ])
  end
end
