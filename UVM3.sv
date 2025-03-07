// Code your testbench here
// or browse Examples
`include "uvm_macros.svh"
import uvm_pkg::*;

class Packet extends uvm_object;
  rand bit[7:0] addr;
  rand bit[7:0] data;

  `uvm_object_utils_begin(Packet)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "Packet");
    super.new(name);
  endfunction
endclass




class producer extends uvm_component;
   `uvm_component_utils (producer)

  // Create a blocking TLM put port which can send an object
  // of type 'Packet'
  uvm_blocking_put_port #(Packet) put_port;
  int m_num_tx = 2;

   function new (string name = "producer", uvm_component parent= null);
      super.new (name, parent);
   endfunction

   // Remember that TLM put_port is a class object and it will have to be
   // created with new ()
   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
     put_port = new ("put_port", this);
   endfunction

  // Create a packet, randomize it and send it through the port
  // Note that put() is a method defined by the receiving component
  // Repeat these steps N times to send N packets
   virtual task run_phase (uvm_phase phase);
     phase.raise_objection(this);
     repeat (m_num_tx) begin
         Packet pkt = Packet::type_id::create ("pkt");
         assert(pkt.randomize ());
 		#50;
          // Print the packet to be displayed in log
         `uvm_info ("COMPA", "Packet sent to CompB", UVM_LOW)
         pkt.print ();

         // Call the TLM put() method of put_port class and pass packet as argument
         put_port.put(pkt);
      end
      phase.drop_objection(this);
   endtask
endclass



class consumer extends uvm_component;
   `uvm_component_utils (consumer)

   // Create a get_port to request for data from componentA
   uvm_blocking_get_port #(Packet) get_port;
   int m_num_tx = 2;

  function new (string name, uvm_component parent);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      get_port = new ("get_port", this);
   endfunction

   virtual task run_phase (uvm_phase phase);
      Packet pkt;
     phase.raise_objection(this);
     repeat (m_num_tx) begin
       #100;
         get_port.get (pkt);
       `uvm_info ("COMPB", "producer just gave me the packet", UVM_LOW)
        pkt.print ();
      end
     phase.drop_objection(this);
   endtask
endclass



class my_test extends uvm_env;
  `uvm_component_utils (my_test)

   producer pro;
   consumer cons;

   int m_num_tx;

   // Create the UVM TLM Fifo that can accept simple_packet
   uvm_tlm_fifo #(Packet)    tlm_fifo;

  function new (string name = "my_test", uvm_component parent = null);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      // Create an object of both components
      pro = producer::type_id::create ("pro", this);
      cons = consumer::type_id::create ("cons", this);
     std::randomize(m_num_tx) with { m_num_tx inside {[4:10]}; };
     pro.m_num_tx = m_num_tx;
     cons.m_num_tx = m_num_tx;

      // Create a FIFO with depth 2
      tlm_fifo = new ("uvm_tlm_fifo", this, 2);
   endfunction

   // Connect the ports to the export of FIFO.
   virtual function void connect_phase (uvm_phase phase);
//      if(tlm_fifo.nb_can_put())
       begin
         pro.put_port.connect(tlm_fifo.put_export);
       end
//      if(tlm_fifo.get)
       begin
         cons.get_port.connect(tlm_fifo.get_export);
       end
   endfunction

   // Display a message when the FIFO is full
   virtual task run_phase (uvm_phase phase);
      forever begin
        #10;
        if (tlm_fifo.is_full())
          begin
//             `uvm_info ("UVM_TLM_FIFO", $sformatf("size of the FIFO is : %0d",m_tlm_fifo.size()), UVM_MEDIUM)
            `uvm_info ("UVM_TLM_FIFO", $sformatf("Fifo is now FULL !"), UVM_MEDIUM)
          end
        else
          begin
             `uvm_info ("UVM_TLM_FIFO", $sformatf("Fifo is not FULL !"), UVM_MEDIUM)
          end
        
        if(tlm_fifo.is_empty)
          begin
            `uvm_info ("UVM_TLM_FIFO", $sformatf("Fifo is now EMPTY !"), UVM_MEDIUM)
          end
          
      end 
   endtask
endclass
          
          
module top;
    initial begin
        run_test("my_test");
    end
endmodule          
          
          
