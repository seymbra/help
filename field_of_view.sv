`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////


module field_of_view(input sysclk,
                                    input [23:0] FOV,
                                    output logic [23:0] fov_multiplier
                                     );

always_ff @(posedge sysclk) begin
    if(0>= FOV && FOV < 1) fov_multiplier <= 20'he5b50;
    if(1>= FOV && FOV < 2) fov_multiplier <= 20'h7224c;
    if(2>= FOV && FOV < 3) fov_multiplier <= 20'h39122;
    if(3>= FOV && FOV < 4) fov_multiplier <= 20'h26bc0;
    if(4>= FOV && FOV < 5) fov_multiplier <= 20'h1c27c;
    if(5>= FOV && FOV < 6) fov_multiplier <= 20'h16387;
    if(6>= FOV && FOV < 7) fov_multiplier <= 20'h13510;
    if(7>= FOV && FOV < 8) fov_multiplier <= 20'h1015d;
    if(8>= FOV && FOV < 9) fov_multiplier <= 20'h0e12c;
    if(9>= FOV && FOV < 10) fov_multiplier <= 20'h0c2c2;
    
    if(10>= FOV && FOV < 11) fov_multiplier <= 20'h0b1ae;
    if(11>= FOV && FOV < 12) fov_multiplier <= 20'h0a181;
    if(12>= FOV && FOV < 13) fov_multiplier <= 20'h091ff;
    if(13>= FOV && FOV < 14) fov_multiplier <= 20'h08308;
    if(14>= FOV && FOV < 15) fov_multiplier <= 20'h08900;
    if(15>= FOV && FOV < 16) fov_multiplier <= 20'h07253;
    if(16>= FOV && FOV < 17) fov_multiplier <= 20'h07730;
    if(17>= FOV && FOV < 18) fov_multiplier <= 20'h062b3;
    if(18>= FOV && FOV < 19) fov_multiplier <= 20'h06139;
    if(19>= FOV && FOV < 20) fov_multiplier <= 20'h053cf;
    
    if(20>= FOV && FOV < 21) fov_multiplier <= 20'h0529f;
    if(21>= FOV && FOV < 22) fov_multiplier <= 20'h0518b;
    if(22>= FOV && FOV < 23) fov_multiplier <= 20'h05900;
    if(23>= FOV && FOV < 24) fov_multiplier <= 20'h04393;
    if(24>= FOV && FOV < 25) fov_multiplier <= 20'h042c0;
    if(25>= FOV && FOV < 26) fov_multiplier <= 20'h041fe;
    if(26>= FOV && FOV < 27) fov_multiplier <= 20'h0414b;
    if(27>= FOV && FOV < 28) fov_multiplier <= 20'h04a50;
    if(28>= FOV && FOV < 29) fov_multiplier <= 20'h04a00;
    if(29>= FOV && FOV < 30) fov_multiplier <= 20'h03362;
    
    if(30>= FOV && FOV < 31) fov_multiplier <= 20'h032dc;
    if(31>= FOV && FOV < 32) fov_multiplier <= 20'h0325d;
    if(32>= FOV && FOV < 33) fov_multiplier <= 20'h031e7;
    if(33>= FOV && FOV < 34) fov_multiplier <= 20'h03177;
    if(34>= FOV && FOV < 35) fov_multiplier <= 20'h0310e;
    if(35>= FOV && FOV < 36) fov_multiplier <= 20'h03ab0;
    if(36>= FOV && FOV < 37) fov_multiplier <= 20'h034d0;
    if(37>= FOV && FOV < 38) fov_multiplier <= 20'h023dc;
    if(38>= FOV && FOV < 39) fov_multiplier <= 20'h02388;
    if(39>= FOV && FOV < 40) fov_multiplier <= 20'h02337;
    
    if(40>= FOV && FOV < 41) fov_multiplier <= 20'h022eb;
    if(41>= FOV && FOV < 42) fov_multiplier <= 20'h022a2;
    if(42>= FOV && FOV < 43) fov_multiplier <= 20'h0225d;
    if(43>= FOV && FOV < 44) fov_multiplier <= 20'h0221a;
    if(44>= FOV && FOV < 45) fov_multiplier <= 20'h021db;
    if(45>= FOV && FOV < 46) fov_multiplier <= 20'h0219e;
    if(46>= FOV && FOV < 47) fov_multiplier <= 20'h02163;
    if(47>= FOV && FOV < 48) fov_multiplier <= 20'h0212b;
    if(48>= FOV && FOV < 49) fov_multiplier <= 20'h02f60;
    if(49>= FOV && FOV < 50) fov_multiplier <= 20'h02c20;
    
    if(50>= FOV && FOV < 51) fov_multiplier <= 20'h02900;
    if(51>= FOV && FOV < 52) fov_multiplier <= 20'h02600;
    if(52>= FOV && FOV < 53) fov_multiplier <= 20'h02320;
    if(53>= FOV && FOV < 54) fov_multiplier <= 20'h02500;
    if(54>= FOV && FOV < 55) fov_multiplier <= 20'h013c2;
    if(55>= FOV && FOV < 56) fov_multiplier <= 20'h01398;
    if(56>= FOV && FOV < 57) fov_multiplier <= 20'h01370;
    if(57>= FOV && FOV < 58) fov_multiplier <= 20'h01349;
    if(58>= FOV && FOV < 59) fov_multiplier <= 20'h01324;
    if(59>= FOV && FOV < 60) fov_multiplier <= 20'h012ff;
    
    if(60>= FOV && FOV < 61) fov_multiplier <= 20'h012dc;
    if(61>= FOV && FOV < 62) fov_multiplier <= 20'h012b9;
    if(62>= FOV && FOV < 63) fov_multiplier <= 20'h01298;
    if(63>= FOV && FOV < 64) fov_multiplier <= 20'h01277;
    if(64>= FOV && FOV < 65) fov_multiplier <= 20'h01258;
    if(65>= FOV && FOV < 66) fov_multiplier <= 20'h01239;
    if(66>= FOV && FOV < 67) fov_multiplier <= 20'h0121b;
    if(67>= FOV && FOV < 68) fov_multiplier <= 20'h011fe;
    if(68>= FOV && FOV < 69) fov_multiplier <= 20'h011e2;
    if(69>= FOV && FOV < 70) fov_multiplier <= 20'h011c7;
    
    if(70>= FOV && FOV < 71) fov_multiplier <= 20'h011ac;
    if(71>= FOV && FOV < 72) fov_multiplier <= 20'h01191;
    if(72>= FOV && FOV < 73) fov_multiplier <= 20'h01178;
    if(73>= FOV && FOV < 74) fov_multiplier <= 20'h0115f;
    if(74>= FOV && FOV < 75) fov_multiplier <= 20'h01147;
    if(75>= FOV && FOV < 76) fov_multiplier <= 20'h0112f;
    if(76>= FOV && FOV < 77) fov_multiplier <= 20'h01117;
    if(77>= FOV && FOV < 78) fov_multiplier <= 20'h01101;
    if(78>= FOV && FOV < 79) fov_multiplier <= 20'h01ea0;
    if(79>= FOV && FOV < 80) fov_multiplier <= 20'h01d50;
    
    if(80>= FOV && FOV < 81) fov_multiplier <= 20'h01bf0;
    if(81>= FOV && FOV < 82) fov_multiplier <= 20'h01aa0;
    if(82>= FOV && FOV < 83) fov_multiplier <= 20'h01960;
    if(83>= FOV && FOV < 84) fov_multiplier <= 20'h01820;
    if(84>= FOV && FOV < 85) fov_multiplier <= 20'h016e0;
    if(85>= FOV && FOV < 86) fov_multiplier <= 20'h015b0;
    if(86>= FOV && FOV < 87) fov_multiplier <= 20'h01480;
    if(87>= FOV && FOV < 88) fov_multiplier <= 20'h01350;
    if(88>= FOV && FOV < 89) fov_multiplier <= 20'h01230;
    if(89>= FOV && FOV <= 90) fov_multiplier <= 20'h01110;
    
    end //always_ff
endmodule
