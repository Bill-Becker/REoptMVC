module CreateTableRuns

import SearchLight.Migrations: create_table, column, columns, pk, add_index, drop_table, add_indices

function up()
  create_table(:runs) do
    [
      pk()
      column(:run_uuid, :string)
      column(:status, :string)
      column(:input, :string)
    #   columns([
    #     :column_name => :column_type
    #   ])
    ]
  end

    # Only add index to uuid because that's how we'll query for Runs
    add_index(:runs, :run_uuid)
#   add_indices(:runs, :uuid, :status, :input)
end

function down()
  drop_table(:runs)
end

end
