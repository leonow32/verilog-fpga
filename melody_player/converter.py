
# Axel F
#melody = "4g2 8.#a2 16g2 16- 16g2 8c3 8g2 8f2 4g2 8.d3 16g2 16- 16g2 8#d3 8d3 8#a2 8g2 8d3 8g3 16g2 16f2 16- 16f2 8d2 8a2 2g2"

# Star Wars
melody = "4a1 4a1 4a1 4f1 16c2 4a1 4f1 16c2 2a1 4e2 4e2 4e2 4f2 16c2 4#g1 4f1 16c2 2a1 4a2 4a1 16a1 4a2 4#g2 16g2 16#f2 16f2 4#f2 8#a1 4#d2 4d2 16#c2 16c2 16b1 4c2 8f1 4#g1 4f1 16#g1 4c2 4a1 16c2 2e2 4a2 4a1 16a1 4a2 4#g2 16g2 16#f2 16f2"
notes = melody.split(" ")

memory = bytearray()
address = 0;

duration_dict = {
    "64.": b'\x00\x30',
    "64":  b'\x00\x20',
    "32.": b'\x00\x60',
    "32":  b'\x00\x40',
    "16.": b'\x00\xBB',
    "16":  b'\x00\x7D',
    "8.":  b'\x01\x77',
    "8":   b'\x00\xFA',
    "4.":  b'\x02\xEE',
    "4":   b'\x01\xF4',
    "2.":  b'\x05\xDC',
    "2":   b'\x03\xE8',
    "1.":  b'\x0B\xB8',
    "1":   b'\x07\xD0',
}

frequency_dict = {
    "#c1": b'\x07\x0B',
    "c1":  b'\x07\x77',
    "#d1": b'\x06\x47',
    "d1":  b'\x06\xA6',
    "e1":  b'\x05\xEC',
    "#f1": b'\x05\x47',
    "f1":  b'\x05\x97',
    "#g1": b'\x04\xB3',
    "g1":  b'\x04\xFB',
    "#a1": b'\x04\x30',
    "a1":  b'\x04\x70',
    "b1":  b'\x03\xF4',
    "#c2": b'\x03\x85',
    "c2":  b'\x03\xBB',
    "#d2": b'\x03\x23',
    "d2":  b'\x03\x53',
    "e2":  b'\x02\xF6',
    "#f2": b'\x02\xA3',
    "f2":  b'\x02\xCB',
    "#g2": b'\x02\x59',
    "g2":  b'\x02\x7D',
    "#a2": b'\x02\x18',
    "a2":  b'\x02\x38',
    "b2":  b'\x01\xFA',
    "#c3": b'\x01\xC2',
    "c3":  b'\x01\xDD',
    "#d3": b'\x01\x91',
    "d3":  b'\x01\xA9',
    "e3":  b'\x01\x7B',
    "#f3": b'\x01\x51',
    "f3":  b'\x01\x65',
    "#g3": b'\x01\x2C',
    "g3":  b'\x01\x3E',
    "#a3": b'\x01\x0C',
    "a3":  b'\x01\x1C',
    "b3":  b'\x00\xFD',
    "-":   b'\x00\x00',
}

with open("test.v", "w") as file:
    # Create Verilog file and save all data 
    file.write("`default_nettype none\n")
    file.write("module ROM(\n")
    file.write("	input wire Clock,\n")
    file.write("	input wire Reset,\n")
    file.write("	input wire ReadEnable_i,\n")
    file.write("	input wire [7:0] Address_i,\n")
    file.write("	output reg [7:0] Data_o\n")
    file.write(");\n")
    file.write("\n")
    file.write("	always @(posedge Clock) begin\n")
    file.write("		if(!Reset)\n")
    file.write("			Data_o <= 0;\n")
    file.write("		else if(ReadEnable_i) begin\n")
    file.write("			case(Address_i)\n")
    file.write("\n")
    
    # Parse note and find its frequency and half period values
    for note in notes:
        
        print(f"Processing note: {note}")
        file.write(f"				// {note}\n")
        
        half_period_hex = None;
        duration_hex = None;
        
        for frequency in frequency_dict:
            if frequency in note:
                print(f"- Found note {frequency}")
                note = note.replace(frequency, "")
                half_period_hex = frequency_dict[frequency]
                break;
        
        for duration in duration_dict:
            if duration in note:
                print(f"- Found duration {duration}")
                duration_hex = duration_dict[duration]
                break;
                
        print(f"-- Result {duration_hex[0]:02X}{duration_hex[1]:02X} {half_period_hex[0]:02X}{half_period_hex[1]:02X}")
        
        # Append duration and half period values to the memory
        memory += duration_hex
        memory += half_period_hex
        
        # Save results to the file
        file.write(f"				8'h{address:02X}:		Data_o <= 8'h{duration_hex[0]:02X};\n")
        address += 1
        file.write(f"				8'h{address:02X}:		Data_o <= 8'h{duration_hex[1]:02X};\n")
        address += 1
        file.write(f"				8'h{address:02X}:		Data_o <= 8'h{half_period_hex[0]:02X};\n")
        address += 1
        file.write(f"				8'h{address:02X}:		Data_o <= 8'h{half_period_hex[1]:02X};\n")
        address += 1
        file.write("\n")
            
  
    file.write("				default:	Data_o <= 8'h00;\n")
    file.write("			endcase\n")
    file.write("		end\n")
    file.write("	end\n")
    file.write("\n")
    file.write("endmodule\n")
    file.write("`default_nettype wire\n")
    file.write("\n")
    
