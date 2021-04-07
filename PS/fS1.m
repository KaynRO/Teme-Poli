function r = fS1(vc, dif)
  r = 0;
  if dif > 10
    r = vc + 10;
  else
    if dif > 0
      r = vc + 1;
    else
      if dif == 0
        r = vc;
      endif
    endif
   endif
endfunction
