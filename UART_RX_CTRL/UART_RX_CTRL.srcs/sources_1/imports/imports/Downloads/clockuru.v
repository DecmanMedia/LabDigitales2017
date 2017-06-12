module clock_divider #(parameter CONSTANT = 50_000) 
(   input clk_in,
    input rst,
    output reg clk_out
    );
    
   localparam constantNumber = CONSTANT;
   
   // Este reg debe ser de tamano suficiente para poder contar hasta el numero especificado
   // en CONSTANT. Puede ser de 16, 32, 64, o cualquier numero de bits, de acuerdo a los valores
   // que se espera pueda tener CONSTANT.
   reg [31:0] count;
    
  //Este bloque procedural solo incrementa un contador por cada pulso del reloj de entrada.
  // La cuenta llega hasta CONSTANT-1, y luego se reinicia.
  // Notar tambien que se usa una senal de reset, que permite setear el contador a un valor conocido
  // en cualquier momento. La logica que gatilla el reset puede ser un simple boton o alguna condicion
  // preprogramada. Siempre que se describa logica secuencial deberia incluirse por defecto una logica de reset.
   always @ (posedge(clk_in) or posedge(rst))
   begin
       if (rst == 1'b1)
           count <= 32'd0;
       else if (count == (constantNumber - 32'd1))
           count <= 32'd0;
       else
           count <= count + 32'b1;
   end

// Este bloque procedural utiliza el valor de count para decidir cuando invertir el valor del 
// reloj de salida.
   
   always @ (posedge(clk_in) or posedge(rst))
   begin
       if (rst == 1'b1)
           clk_out <= 1'b0;
       else if (count == (constantNumber - 32'd1))  //cuando el contador haya alcanzado el valor de referencia
           clk_out <= ~clk_out;                     // se invierte su valor. Notar que esto ocurre solo durante un 
       else                                         // ciclo del reloj de entrada, y este valor se mantiene constante 
           clk_out <= clk_out;                      // hasta que el contador nuevamente llegue a CONSTANT.
   end 
    
endmodule