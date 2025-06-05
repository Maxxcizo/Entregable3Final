function [Bz, z]=campoS(ds, km, Px, Py, Pz, dx, dy, nl, N, rw, plot_option)
    z= -5.2 : ds : 5.2;
    if plot_option
        x=z;
        y= z;
    else 
        x= -0.1: 0.01: 0.1;
        y= -0.1: 0.01: 0.1;
    end 

    % Definicion del espacio de calculo
    Lx = length(x); Ly = length(y); Lz = length(z);

    % Incializacion de los componentes del campo
    dBx = zeros(Lx, Ly, Lz, "single");
    dBy = zeros(Lx, Ly, Lz, "single");
    dBz = zeros(Lx, Ly, Lz, "single");

    % Calculo del campo en cada punto del espacio 
    for i= 1:Lx
        for j= 1:Ly
            for k= 1:Lz
                for l= 1:nl*N
                    rx = x(i) - Px(l);
                    ry = y(j) - Py(l);
                    rz = z(k) - Pz(l);

                    r = sqrt(rx^2 + ry^2 + rz^2 + rw^2); %Se suma rw^2 para evitar singularidades
                    r3 = r^3;

                    %Ley de Biot-Savart
                    dBx (i,j,k) = dBx(i, j, k) + km * dy(l) * rz / r3;
                    dBy (i,j,k) = dBy(i, j, k) + km * dx(l) * rz / r3;
                    dBz (i,j,k) = dBz(i, j, k) + km * (dx(l) *ry - dy(l) * rx) / r3;
                end 
            end 
        end 
    end

    if plot_option
        %Magnitud del campo 
        Bmag= sqrt(dBx.^2 + dBy.^2 + dBz.^2);
    
        %Corte en el plano XZ (y=0)
        centery = round(Ly/2);
        Bx_xz = squeeze(dBx(:, centery, :));
        Bz_xz = squeeze(dBz(:, centery, :));
        Bxz = squeeze(Bmag(:, centery, :));
    
        %Visualización del campo 
        fig = figure;
        hold on
        pcolor (x,z, (Bxz').^ (1/3)); shading interp; colormap jet; colorbar 
        h1 = streamslice(x, z, Bx_xz', Bz_xz', 1);
        set(h1, "Color", [0.8, 1.0, 0.9]);
        xlabel("x"); ylabel("z");
        title ("Campo magnético generado por un solenoide");
        exportgraphics(fig, 'campo_magnetico.png', 'Resolution', 300);
        Bz='None';
        I_in = 'None';
        z_mid = 'None';

    else 
        idx_x= ceil(Lx/2);
        idx_y= ceil(Ly/2);
        Bz=squeeze(dBz(idx_x, idx_y, :));


        %Calcular el gradiente del campo
        dBz_dz_profile= diff(Bz) ./ diff(z);
        z_mid= z(1: end-1) + diff(z)/2;

        %Graficar gradiente del campo

        figure

        plot(z_mid, dBz_dz_profile, "r-", "Linewidth",2);
        xlabel 'z'; ylabel 'Valor'
        title('Gradiente del campo');
        grid on;
    end 
end