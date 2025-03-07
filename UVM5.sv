// Code your testbench here
// or browse Examples
`include "uvm_macros.svh"
import uvm_pkg::*;

typedef classB;
typedef classC;
typedef classD;
typedef classE;
typedef classF;

// Define a base class agent
class classA extends uvm_component;
  `uvm_component_utils(classA)
  classB s1;
  classE s2;
  classF s7;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void dis();
    `uvm_info(get_type_name(), $sformatf("Inside the ClassA"), UVM_LOW)
  endfunction
  
endclass

class classB extends uvm_component;
  `uvm_component_utils(classB)
  classC s3;
  classD s4;
  function new(string name, uvm_component parent);
    super.new(name, parent);

  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      s3 = classC::type_id::create("s3", this);
      s4 = classD::type_id::create("s4", this);
      s3.dis();
  endfunction
  
  virtual function void dis();
    `uvm_info(get_type_name(), $sformatf("Inside the ClassB"), UVM_LOW)
    s3.dis();
    s4.dis();
  endfunction
  
endclass

class classC extends uvm_component;
  `uvm_component_utils(classC)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void dis();
    `uvm_info(get_type_name(), $sformatf("Inside the ClassC"), UVM_LOW)
  endfunction
  
endclass

class classD extends uvm_component;
  `uvm_component_utils(classD)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  virtual function void dis();
    `uvm_info(get_type_name(), $sformatf("Inside the ClassD"), UVM_LOW)
  endfunction
  
endclass

class classE extends uvm_component;
  `uvm_component_utils(classE)
   classC s5;
   classD s6;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      s5 = classC::type_id::create("s3", this);
      s6 = classD::type_id::create("s4", this);
  endfunction
  
  virtual function void dis();
    `uvm_info(get_type_name(), $sformatf("Inside the ClassE"), UVM_LOW)
    s5.dis();
    s6.dis();
  endfunction
  
endclass

class classF extends uvm_component;
  `uvm_component_utils(classF)
   classC s8;
   classD s9;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    s8 = classC::type_id::create("s8", this);
    s9 = classD::type_id::create("s9", this);
  endfunction
  
  virtual function void dis();
    `uvm_info(get_type_name(), $sformatf("Inside the ClassF"), UVM_LOW)
    s8.dis();
    s9.dis();
  endfunction
  
endclass

class classc1 extends classC;
  `uvm_component_utils(classc1)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void dis();
    `uvm_info(get_type_name(), $sformatf("Inside the Classc1"), UVM_LOW)
  endfunction
  
endclass

class classc2 extends classC;
  `uvm_component_utils(classc2)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void dis();
    `uvm_info(get_type_name(), $sformatf("Inside the classc2"), UVM_LOW)
  endfunction
  
endclass

class classd1 extends classD;
  `uvm_component_utils(classd1)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void dis();
    `uvm_info(get_type_name(), $sformatf("Inside the classd1"), UVM_LOW)
  endfunction
  
endclass

class classd2 extends classD;
  `uvm_component_utils(classd2)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void dis();
    `uvm_info(get_type_name(), $sformatf("Inside the classd2"), UVM_LOW)
  endfunction
  
endclass


// // Environment contains the agent
// class base_env extends uvm_env;
  
//   `uvm_component_utils(base_env)
//   function new(string name, uvm_component parent);
//     super.new(name, parent);
//   endfunction


// endclass


class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  classA agent_a;
  classC agent_c;
  classB agent_b;
  classE agent_e;
  classF agent_f;
//   base_env envh;

  virtual function void build_phase(uvm_phase phase);
  	// Get handle to the singleton factory instance
    uvm_factory factory = uvm_factory::get();

    super.build_phase(phase);

//     Set factory to override 'base_agent' by 'child_agent' by type
//     set_type_override_by_type(base_agent::get_type(), child_agent::get_type());

//      Or set factory to override 'base_agent' by 'child_agent' by name
//     factory.set_type_override_by_name("classB", "classA");
       factory.set_type_override_by_name("classC", "classc1");
    
//     set_inst_override_by_type("envh.*",classD::get_type(), classd1::get_type());
    
       factory.set_type_override_by_name("classD", "classd1");

    
    // Print factory configuration
      factory.print();

    // Now create environment
//     envh = base_env::type_id::create("envh", this);
    agent_a = classA::type_id::create("agent_a", this);
    agent_c = classC::type_id::create("agent_c", this);
    agent_b = classB::type_id::create("agent_b", this);
    agent_e = classE::type_id::create("agent_e", this);
    agent_f = classF::type_id::create("agent_f", this);
  endfunction
  
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
  
   task run_phase(uvm_phase phase);
    super.run_phase(phase);

     agent_b.dis();
     agent_e.dis();
     agent_f.dis();
  endtask


endclass

module top;
    initial begin
      run_test("base_test");
    end
endmodule

