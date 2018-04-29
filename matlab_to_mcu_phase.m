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
    pv(pv == 10) = 11;%Matlab eller USB-TTL kabeln tolkar 10 som newline
    
mcu_phase = 0*ones(1,130);
mcu_phase([52:-1:10 8 9 7:-1:1]) = pv(1:52);%Övre
mcu_phase([61:-1:53]) = pv(53:61);          %Nedre
mcu_phase([105 109:-1:106 111 110 112 123:-1:113]) = pv(62:80);
mcu_phase([102:104 130:-1:124 94:101]) = pv(81:98);
mcu_phase([81:86 88 87 89 90 92 91 93 70:80]) = pv(99:122);

end

