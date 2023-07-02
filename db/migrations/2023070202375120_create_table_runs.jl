module CreateTableRuns

import SearchLight.Migrations: create_table, column, columns, pk, add_index, drop_table, add_indices

function up()
  create_table(:runs) do
    [
      pk()
      column(:status, :string)
      column(:input, :string)
    #   columns([
    #     :column_name => :column_type
    #   ])
    ]
  end

  add_index(:runs, :status)
  add_index(:runs, :input)
#   add_indices(:runs, :column_name_1, :column_name_2)
end

function down()
  drop_table(:runs)
end

end
