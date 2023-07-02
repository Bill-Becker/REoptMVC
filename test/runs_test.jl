using Test, SearchLight, Main.UserApp, Main.UserApp.Runs

@testset "Runs unit tests" begin

    ### Read .json file, create run item with .json string, read out input field
    input_data = get_json_string_from_file("input_file.json")
    run_inst = Run("", input_data)
    input_string = run_inst.input
    input_dict = JSON.parse(input_string)
    @test typeof(input_dict) <: Dict
  
  end;
  
  function write_json_to_file(fp::String, data::Dict)
      open(fp*".json","w") do f
          JSON.print(f, data)
      end
  end
  
  function get_json_string_from_file(fp::String)
      data_dict = JSON.parsefile(fp)
      return JSON.json(data_dict)
  end
