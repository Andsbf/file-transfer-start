module FileTransferComponent
  class Projection
    include EntityProjection
    include Messages::Events

    entity_name :file

    apply Initiated do |initiated|
      SetAttributes.(file, initiated, copy: [
          {file_id: :id},
          :name,
      ])

      file.initiated_time = Time.parse(initiated.processed_time)
    end

    apply Renamed do |renamed|
      SetAttributes.(file, renamed, copy: [
       {file_id: :id},
        :name,
       ])
    end
  end
end
