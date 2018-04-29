function mcu_phase = matlab_to_mcu_phase(phase_vector,radians)
%MATLAB_TO_MCU_PHASE Converts phase vector as generated in Matlab to
%                    phase vector for MCU. Length of phase_vector must be
%                    122. Optional argument radians = 1 if phase_vector 
%                    is in radians (default)
    if (nargin < 2) radians = 1; end

    assert(length(phase_vector) == 122,...
        'phase_vector måste innehålla 122 faser');
    if (radians)
        pv = mod(phase_vector,2*pi) * 250/2/pi;
    else
        pv = phase_vector;
    end
    
fel_pol = [1 6 8 10 12:14 16 17 20 22 23 27 29:32 35 36 40 41 43 ...
           46:48 50 51 55:57 59 61 65 67:70 73 74 76 79 81 83 ...
           91:93 95 96 99 105 107 109 113 116];
fel_pol = fel_pol + 1;
pv(fel_pol) = mod(pv(fel_pol) + 125,250);

pv(pv == 10) = 11;%Matlab eller USB-TTL kabeln tolkar 10 som newline

mcu_phase = 0*ones(1,130);
mcu_phase([52:-1:10 8 9 7:-1:1]) = pv(1:52);%Övre
mcu_phase([61:-1:53]) = pv(53:61);          %Nedre
mcu_phase([105 109:-1:106 111 110 112 123:-1:113]) = pv(62:80);
mcu_phase([102:104 130:-1:124 94:101]) = pv(81:98);
mcu_phase([81:86 88 87 89 90 92 91 93 70:80]) = pv(99:122);


end

