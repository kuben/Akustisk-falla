function mcu_phase = matlab_to_mcu_phase(phase_vector)
%MATLAB_TO_MCU_PHASE phase_vector in radians. Must have length 122
    assert(length(phase_vector) == 122,...
        'phase_vector måste innehålla 122 faser');
    
%OBS Matlab 1-indexerat MCU 0-indexerat i tabell nedan
% Matlab 1  2     3     4  5  6     7    UNDRE
% MCU    51 (44?) (48?) 49 47 (46?) 45
% Matlab 8   9-19  20 21-26 27-37 38-43
% MCU    32  43-33 32 31-26 23-13 12-7
% Matlab 44 45 46-50 51    52    53-61
% MCU    5  6  4-0   (25?) (24?) 60-52

% Matlab 62  63-66   67  68  69  70-80    ÖVRE
% MCU    104 108-105 110 109 111 122-112
% Matlab 81-83   84-89   90     91-98  
% MCU    101-103 129-124 (123?) 93-100
% Matlab 99-104 105 106 107 108 109 110 111 112-122
% MCU    80-85  87  86  88  89  91  90  92  69-79
pv = mod(phase_vector,2*pi) * 250/2/pi;
mcu_phase = zeros(1,130);
mcu_phase([52 45 48 50 48:-1:46]) = pv(1:7);
mcu_phase([33 44:-1:34 33 32:-1:27 24:-1:14 13:-1:8]) = pv(8:43);
mcu_phase([6  7  5:-1:1 26 25 61:-1:53]) = pv(44:61);
mcu_phase([105 109:-1:106 111 110 112 123:-1:113]) = pv(62:80);
mcu_phase([102:104 130:-1:125 124 94:101]) = pv(81:98);
mcu_phase([81:86 88 87  89 90 92  91  93  70:80]) = pv(99:122);

end

