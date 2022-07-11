# Функция последовтельного поиска локальных максимумов и минимумов.

# Сигнал подаётся на вход по одной точке!

# Вход:
# ipos - позиция (номер) точки (отсчёта) в массиве ,iamp - амплитуда отсчёта,
# minmax_amp - минимальная допустимая амплитуда локального максимума,
# maxmin_amp - максимальная допустимая амплитуда локального минимума,
# radius - радиус поиска (раньше которого не встретится следующий максимум или минимум);
# state - состояние функции, где: 
# pos - позиция предыдущего предполагаемого максимума или минимума, 
# amp - амплитуда предыдущего предполагаемого максимума или минимума, 
# m - равно 1, если предыдущим был записан максимум, и -1, если был записан минимум.
# Рекомендуемое начальное значение state=(pos=1,amp=-Inf,m=-1)

# Выход:
# out - позиции локальных максимумов и минимумов, state - состояние функции.

function findminmax(ipos,iamp,radius,state)
    is_max=false
    is_min=false

    if ipos-state.pos>=radius && state.m==-1
        is_max=true

        if is_max
            push!(out,state.pos)
            state=(pos=ipos,amp=iamp,m=1)
        end

    elseif ipos-state.pos>=radius && state.m==1
        is_min=true

        if is_min
            push!(out,state.pos)
            state=(pos=ipos,amp=iamp,m=-1)
        end

    end

    if iamp>state.amp && state.m==-1
        state=(pos=ipos,amp=iamp,m=-1)
    elseif iamp<state.amp && state.m==1
        state=(pos=ipos,amp=iamp,m=1)
    end

    return out, state
end