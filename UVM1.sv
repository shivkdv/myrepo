class digi_base_test extends uvm_test;
  bit is_active;
  bit is_agent_active;
  bit scoreboard;
  bit [3:0] no_of_agents;
    `uvm_component_utils(digi_base_test)
  
  // making digi_base_env class---- to---- env_h  using typedef for further use.
  typedef digi_base_env#(digi_base_env_cfg) env_h;
  env_h env;
  
    function new(string name="digi_base_test",uvm_component parent);
	    super.new(name,parent);
    endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // create the object for digi_base_env (enviroment) using creare method
   env=env_h::type_id::create("env",this);
    
    // try to get the vlaue of is_active from config_db using get
    if(!uvm_config_db#(bit)::get(this,"","is_active",is_active))
        `uvm_fatal("TEST", $sformatf("TEST is not getting is_active via config_db:"))
     
     // going to set value for is_active for enviroment class via env handle in config_db using set method 
     uvm_config_db#(bit)::set(this,"env","is_active",is_active);
    
    // try to get the vlaue of is scoreboard from config_db using get
    if(!uvm_config_db#(bit)::get(this,"","scoreboard",scoreboard))
         `uvm_fatal("TEST", $sformatf("TEST is not getting scoreboard via config_db:"))
      
     // going to set value for scoreboard for enviroment class via env handle in config_db using set method  
     uvm_config_db#(bit)::set(this,"env","scoreboard",scoreboard);
    
    // try to get the vlaue of is is_agent_active from config_db using get
    if(!uvm_config_db#(bit)::get(this,"","is_agent_active",is_agent_active))
        `uvm_fatal("TEST", $sformatf("TEST is not getting is_agent_active via config_db:"))
     
     // going to set value for is_agent_active for enviroment class via env handle in config_db using set method   
     uvm_config_db#(bit)::set(this,"env","is_agent_active",is_agent_active);
    
    // try to get the vlaue of is no_of_agents from config_db using get
    if(!uvm_config_db#(bit [3:0])::get(this,"","no_of_agents",no_of_agents))
      `uvm_fatal("TEST", $sformatf("TEST is not getting no_of_agents via config_db:"))
     
      // going to set value for no_of_agents for enviroment class via env handle in config_db using set method  
      uvm_config_db#(bit [3:0])::set(this,"env","no_of_agents",no_of_agents);

  endfunction
  
   function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
     `uvm_info(get_type_name(), $sformatf("Inside the ..... connect_phase"), UVM_LOW)
//     uvm_top.print_topology();
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Inside the ..... end_of_elaboration_phase"), UVM_LOW)
//     uvm_top.print_topology();
  endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Inside the ..... start_of_simulation_phase"), UVM_LOW)
  endfunction
  
//   task run_phase(uvm_phase phase);
//     super.run_phase(phase);
//     `uvm_info(get_type_name(), $sformatf("Inside the ..... run_test"), UVM_LOW)
// //     uvm_top.print_topology();
//   endtask
  
//   function void extract_phase(uvm_phase phase);
//     super.extract_phase(phase);
//     `uvm_info(get_type_name(), $sformatf("Inside the ..... extract_phase "), UVM_LOW)
//   endfunction
  
//   function void check_phase(uvm_phase phase);
//     super.check_phase(phase);
//     `uvm_info(get_type_name(), $sformatf("Inside the ..... check_phase "), UVM_LOW)
//   endfunction
  
//   function void report_phase(uvm_phase phase);
//     super.report_phase(phase);
//     `uvm_info(get_type_name(), $sformatf("Inside the ..... report_phase "), UVM_LOW)
//   endfunction
  
  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Inside the ..... final_phase "), UVM_LOW)
  endfunction
  
endclass

