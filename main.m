%% Simplex
clear

A = [1 1 1 0 ; 0 1 0 1]

b = [6;3]

c = [2 -3 0 0]

Simplex(A, b, c)

function Simplex(A, b, c)
    
    % Esta base B Ib In es temporal (se reemplazara con el metodo de las 
    % dos fases)
    B = [1 2;0 1];
    Ib = [1, 2];
    In = [3, 4];
    
    % Verificar si las dimensiones concuerdan
    dimensionA = size(A);
    rangoA = dimensionA(1, 1);
    
    if ~isequal(size(B),[rangoA rangoA])
        sprintf("B Error: Basis Matrix has incorrect dimensions ")
    end

    while 1
        % Simplex Paso 1

        cb = [];
        cn = [];

        % Generar cb 
        for col = 1: rangoA
            cb(1, col) = c(1, Ib(1, col));
        end

        % Generar cn
        cnDim = size(c);
        cncolNumber =  cnDim(1, 2);

        for col = 1: abs(cncolNumber - rangoA)
            cn(1, col) = c(1, In(1, col));
        end    

        xb = inv(B) * b;
        xn = 0;
        z0 = cb * xb;

        % Simplex Paso 2

        cj = cn-cb * inv(B);
        cjSize = size(cj);

        Optima = true;
        candidataParaEntrarALaBase = -5;
        indiceEntrada = -1;

        cjSize(1, 2);

        for col = 1 : cjSize(1, 2)
           if cj(1, col) < 0
               Optima = false;
               candidataParaEntrarALaBase = In(1, col);
               indiceEntrada = col;
           end
        end

        if Optima
            sprintf("Solucion optima encontrada!")
            z0
            cn
            return
        end

        % Simplex Paso 3

        yk = inv(B) * A(:,candidataParaEntrarALaBase);
        valor_minimo = Inf;
        paso = 0;
        candidataParaSalirDeLaBase = -5;
        indiceSalida = -1;

        for index = 1 : rangoA
            if xb(index, 1)/yk(index, 1) < valor_minimo
                valor_minimo = xb(index,1);
                candidataParaSalirDeLaBase = Ib(1, index);
                indiceSalida = index;
                paso = xb(index,1);
            end
        end

        candidataParaEntrarALaBase
        candidataParaSalirDeLaBase
        Ib(1, indiceEntrada) = candidataParaEntrarALaBase
        In(1, indiceSalida) = candidataParaSalirDeLaBase
    end

    
    
    
    
end