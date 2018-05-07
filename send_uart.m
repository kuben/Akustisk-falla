function out = send_uart(s,data,respond)
    if (nargin < 3) respond = 1; end
    data(data == 10) = 11;
    fprintf(s,data);
    out = [];
    if (respond)
        out = fscanf(s);
    end
end