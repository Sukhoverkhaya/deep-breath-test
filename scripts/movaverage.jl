function movaverage(state,x)
    buf,k=state
    sum_x=x
    for xi in buf #сумма всех элементов буфера + один новый
        sum_x+=xi
    end
    y=sum_x/window

    buf[k]=x
    k+=1
    if k>length(buf)
        k=1
    end

    state=(buf,k)
    return state,y
end