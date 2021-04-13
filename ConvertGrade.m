function Output = ConvertGrade(Input)
if isnumeric(Input)
    if Input <= 1
        Input = Input*100;
    end
    if Input >= 90
        Output = 'A';
    elseif Input >= 80
        Output = 'B';
    elseif Input >= 70
        Output = 'C';
    elseif Input >= 60
        Output = 'D';
    else
        Output = 'E';
    end
elseif ischar(Input)
    switch Input
        case('A')
            Output = 95;
        case('B')
            Output = 85;
        case('C')
            Output = 75;
        case('D')
            Output = 65;
        case('E')
            Output = 55;
        otherwise
            fprintf('¡¾´íÎó¡¿Î´ÖªÊäÈë×Ö·û£¡\n')
            return
    end
elseif isstring(Input)
    if ~ismissing(Input)
        switch Input
            case("A")
                Output = 95;
            case("B")
                Output = 85;
            case("C")
                Output = 75;
            case("D")
                Output = 65;
            case("E")
                Output = 55;
            otherwise
                fprintf('¡¾´íÎó¡¿Î´ÖªÊäÈë×Ö¶Î£¡\n')
                return
        end
    else
        Output = 0;
    end
end
