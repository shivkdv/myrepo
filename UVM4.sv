// Code your testbench here
// or browse Examples
`include "uvm_macros.svh"
import uvm_pkg::*;

// Define a base class agent
class classA extends uvm_agent;
  `uvm_component_utils(classA)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  virtual function void dis();
    `uvm_info(get_type_name(), $sformatf("Inside the ClassA"), UVM_LOW)
  endfunction
endclass

// Define child class that extends base agent
class classB extends classA;
  `uvm_component_utils(classB)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  virtual function void dis();
    `uvm_info(get_type_name(), $sformatf("Inside the ClassB"), UVM_LOW)
  endfunction
endclass

class classC extends classB;
  `uvm_component_utils(classC)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void dis();
    `uvm_info(get_type_name(), $sformatf("Inside the ClassC"), UVM_LOW)
  endfunction
  
endclass

class classD extends classB;
  `uvm_component_utils(classD)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void dis();
    `uvm_info(get_type_name(), $sformatf("Inside the ClassD"), UVM_LOW)
  endfunction
  
endclass

class classE extends classC;
  `uvm_component_utils(classE)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void dis();
    `uvm_info(get_type_name(), $sformatf("Inside the ClassE"), UVM_LOW)
  endfunction
  
endclass


class classF extends classE;
  `uvm_component_utils(classF)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void dis();
    `uvm_info(get_type_name(), $sformatf("Inside the ClassF"), UVM_LOW)
  endfunction
  
endclass

class classG extends classF;
  `uvm_component_utils(classG)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void dis();
    `uvm_info(get_type_name(), $sformatf("Inside the ClassG"), UVM_LOW)
  endfunction
  
endclass

class classH extends classG;
  `uvm_component_utils(classH)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  virtual function void dis();
    `uvm_info(get_type_name(), $sformatf("Inside the ClassH"), UVM_LOW)
  endfunction
endclass

class classI extends classD;
  `uvm_component_utils(classI)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  virtual function void dis();
    `uvm_info(get_type_name(), $sformatf("Inside the ClassI"), UVM_LOW)
  endfunction
endclass

class classJ extends classD;
  `uvm_component_utils(classJ)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  virtual function void dis();
    `uvm_info(get_type_name(), $sformatf("Inside the ClassJ"), UVM_LOW)
  endfunction
endclass

// Environment contains the agent
class base_env extends uvm_env;
  `uvm_component_utils(base_env)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // 'a' is a class handle to hold base_agent
  // type class objects
  classA agent_a;
  classB agent_b;
  classC agent_c;
  classD agent_d;
  classE agent_e;
  classF agent_f;
  classJ agent_j;
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Use create method to request factory to return a base_agent
    // type of class object
    agent_a = classA::type_id::create("agent_a", this);
    agent_b = classB::type_id::create("agent_b", this);
//     agent_c = classC::type_id::create("agent_c", this);
//     agent_d = classD::type_id::create("agent_d", this);
    agent_e = classE::type_id::create("agent_e", this);
    agent_f = classF::type_id::create("agent_f", this);
    agent_j = classJ::type_id::create("agent_j", this);
    

    // Now print the type of the object pointing to by the 'm_agent' class handle
    `uvm_info("AGENT", $sformatf("Factory returned agent of type=%s, path=%s", agent_a.get_type_name(), agent_a.get_full_name()), UVM_LOW)
    agent_a.dis;
//     agent_c.dis;
    agent_e.dis;
//     agent_f.dis;
  endfunction
endclass


// test for factory override_by_type

class base_test extends uvm_test;
  
  `uvm_component_utils(base_test)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  base_env envh;

  virtual function void build_phase(uvm_phase phase);
  	// Get handle to the singleton factory instance
    uvm_factory factory = uvm_factory::get();

    super.build_phase(phase);

    // Set factory to override 'base_agent' by 'child_agent' by type
//     set_type_override_by_type(base_agent::get_type(), child_agent::get_type());

    // Or set factory to override 'base_agent' by 'child_agent' by name
    factory.set_type_override_by_name("classA", "classE");
    factory.set_type_override_by_name("classE", "classH");
    factory.set_type_override_by_name("classC", "classD");
//     factory.set_type_override_by_name("classD", "classH");
//     factory.set_type_override_by_name("classF", "classJ");
    // Print factory configuration
      factory.print();

    // Now create environment
    envh = base_env::type_id::create("envh", this);

  endfunction
  
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction


endclass


module top;
    initial begin
      run_test("base_test");
    end
endmodule

