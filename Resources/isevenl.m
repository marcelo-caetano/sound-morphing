function evenodd = isevenl(len)

%   WINDOW_EVEN
if rem(len,2)
    % ODD
    evenodd = false;
else
    % EVEN
    evenodd = true;
end

end