function [Ib, In] = Fase1(A, b, c)
%Implementacion de la fase 1 del algoritmo simplex
    % Añadir matriz identidad a A, para poder hallar una base factible
    % que permita inicar la fase 2
    
    TEMPdimensionA = size(A);
    TEMPrangoA = TEMPdimensionA(1, 1);
    
    A = [A eye(TEMPrangoA)];
    B = eye(TEMPrangoA);
    
    dimensionB = size(B);
    rangoB = dimensionB(1, 1);
    
    % Actualizar indices basicos y no basicos
    In = [1:TEMPdimensionA(1, 2)];
    Ib = [TEMPdimensionA(1, 2) + 1: TEMPdimensionA(1, 2) + TEMPrangoA];

    % Actualizar de c
    cSize = size(c);
    c = [zeros([1, cSize(1, 2)]) ones([1, TEMPrangoA])];
    
    dimensionA = size(A);
    rangoA = dimensionA(1, 1);
    numColumnasA = dimensionA(1, 2);
    
    i = 0;
    
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

        cj = cn-(cb * inv(B)*N);
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
               elseif cj(1, col) == valorMinimoActual && In(1, col) < candidataParaEntrarALaBase
                   valorMinimoActual = cj(1, col);
                   candidataParaEntrarALaBase = In(1, col);
                   indiceEntrada = col;
               end
           end
        end

        if Optima
            
            InSize = size(In);
            colSize = InSize(1, 2);
            remainder = 0;
            
            for col_index = 1 : colSize
                col_index = col_index - remainder;
                if In(1,col_index) > (numColumnasA - rangoA)
                    In(:,col_index) = [];
                    remainder = remainder + 1;
                end
            end
            
            factible = true;
            % Verificar que los indices de la base existan
            for item = Ib
                if item > (numColumnasA - rangoA)
                    Ib = [];
                    In = [];
                    factible = false;
                end
            end

            if factible
                disp('Fase 1: Base encontrada')
            else
                disp('Fase 1: No se encontro una solucion basica factible')
            end
            
            return
        end

        % Simplex Paso 3

        yk = inv(B) * A(:,candidataParaEntrarALaBase);
        valor_minimo = Inf;
        paso = 0;
        candidataParaSalirDeLaBase = inf;
        indiceSalida = -1;
        
        for index = 1 : rangoA
            if xb(index, 1)/yk(index, 1) < valor_minimo && yk(index, 1) > 0
                valor_minimo = xb(index,1);
                candidataParaSalirDeLaBase = Ib(1, index);
                indiceSalida = index;
                paso = xb(index,1);
            end
        end

        Ib(1, indiceSalida) = candidataParaEntrarALaBase;
        In(1, indiceEntrada) = candidataParaSalirDeLaBase;
        
        candidataParaEntrarALaBase;
        candidataParaSalirDeLaBase;
        i = i + 1;
        
    end

end