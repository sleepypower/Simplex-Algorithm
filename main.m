%% Simplex
clear
A = [1 2 1 0; 0 1 0 1]

b = [4;1];

c = [1 1 0 0];

Simplex(A, b, c, true, true)

function Simplex(A, b, c, v, min)
% Implementacion de la del algoritmo simplex
% Parametros:
%            - A (matriz): matriz de coeficientes.
%            - b (matriz): vector igualdad.
%            - c (matriz): coeficientes
%            - v (bool): vervose, muestra el procedimiento 
%            - min (bool): si es verdadero la función es de minimización
%
    clc
    % Esta base B Ib In es temporal (se reemplazara con el metodo de las 
    % dos fases)
    disp("======Iniciando Fase 1======")
    [Ib, In] = Fase1(A, b, c)
    disp("======Fase 1 Terminada======")
    
    % El problema es max
    if ~min
        c = -1 * c
    end
    
    % Fase 1 error
    if isequal(Ib,[])
        disp("Fase 1: Error, no se encontró región factible")
        return
    end
   
    % Verificar si las dimensiones concuerdan
    dimensionA = size(A);
    dimensionB = size(b);
    dimensionC = size(c);
    
    valido = true
    
    if dimensionA(1, 2) < dimensionA(1, 1)
        valido = false;
    end
    if dimensionB(1, 2) ~= 1
        valido = false;
    end
    if dimensionA(1, 1) ~= dimensionB(1, 1)
        valido = false;
    end
    if dimensionC(1, 1) ~= 1
        valido = false;
    end
    if dimensionA(1, 2) ~= dimensionC(1, 2)
        valido = false;
    end
    
    if ~valido
        disp("Las dimensiones no concuerdan!")
        disp("Finalizando!")
        return
    end
    
    rangoA = dimensionA(1, 1);
    
    i = 0;
    disp("======Iniciando Fase 2======")
    while i < 10000
        % Simplex Paso 1
        
        B = [];
        N = [];
    
        % Generar B
        for col = Ib
           B = [B A(:,col)];
        end
        
        % Generar N
        for col = In
            
           N = [N A(:,col)];
        end
       
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

        cj = cn-cb * inv(B)*N;
        cjSize = size(cj);

        Optima = true;
        candidataParaEntrarALaBase = inf;
        valorMinimoActual = inf;
        indiceEntrada = -1;

        cjSize(1, 2);

        for col = 1 : cjSize(1, 2)
           if cj(1, col) < 0
               Optima = false;
               if cj(1, col) < valorMinimoActual
                   valorMinimoActual = cj(1, col);
                   candidataParaEntrarALaBase = In(1, col);
                   indiceEntrada = col;
               elseif cj(1, col) == valorMinimoActual && ...
                       In(1, col) < candidataParaEntrarALaBase
                   valorMinimoActual = cj(1, col);
                   candidataParaEntrarALaBase = In(1, col);
                   indiceEntrada = col;
               end
           elseif cj(1, col) == 0
               disp("Multiples soluciones!")
           end
        end
        

        if Optima
            sprintf("Solucion optima encontrada!")
            
            sizeXb = size(xb)
            xbF = zeros([dimensionA(1, 2) 1]);
            for i = 1: sizeXb(1, 1)
                xb(i, 1)
                xbF(Ib(1, i), 1) = xb(i, 1);
            end
            disp("======Fase 2 Terminada======")
            disp("======Solución======")
            z0
            xbF
            disp("======Solución======")
            
            return
        end

        % Simplex Paso 3

        yk = inv(B) * A(:,candidataParaEntrarALaBase);
        valor_minimo = Inf;
        paso = 0;
        candidataParaSalirDeLaBase = inf;
        indiceSalida = -1;
        
        for index = 1 : rangoA
            if yk(index, 1) <= 0
                disp("Fase 2: el problema no tiene optimo finito")
                return
            end
            xb(index, 1)/yk(index, 1);
            if xb(index, 1)/yk(index, 1) < valor_minimo && yk(index, 1) > 0
                if Ib(1, index) < candidataParaSalirDeLaBase
                    valor_minimo = xb(index,1);
                    candidataParaSalirDeLaBase = Ib(1, index);
                    indiceSalida = index;
                    paso = xb(index,1);
                elseif Ib(1, index) == candidataParaSalirDeLaBase && Ib(1, index) < candidataParaSalirDeLaBase
                    valor_minimo = xb(index,1);
                    candidataParaSalirDeLaBase = Ib(1, index);
                    indiceSalida = index;
                    paso = xb(index,1);
                end
                
            end 
        end

        Ib(1, indiceSalida) = candidataParaEntrarALaBase;
        In(1, indiceEntrada) = candidataParaSalirDeLaBase;
        i = i + 1;
        
        % Verbose
        if v
           str_e = sprintf("ITERACION: %d", i);
           disp(str_e)
           disp("===================")
           cn 
           cj
           xb
           candidataParaEntrarALaBase
           candidataParaSalirDeLaBase
           str_e = sprintf("Tamaño Paso: %e", abs(valorMinimoActual));
           disp(str_e)
           disp("===================")
           
        end
        
    end

end