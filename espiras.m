function [Lx, Ly, Lz, dLx, dLy, dLz] = espiras(nl, N, R, sz)
    dO = (2*pi)/N; % Valor del ángulo de las espiras
    angulo = 0:dO:(2*pi - dO); % Vector para el ángulo que cubre la espira
    x = R*cos(angulo); % Valor componente X
    y = R*sin(angulo); % Valor componente Y
    z = zeros(1, N); % Valor componente Z
    dx = -R*sin(angulo); % Valor diferencial componente X
    dy = R*cos(angulo); % Valor diferencial componente Y
    dz = zeros(1, N); % Valor diferencial componente Z
    Lx = []; Ly = []; Lz = [];
    dLx = []; dLy = []; dLz = [];
    for i = 0:nl-1
        Z_offset = i * sz;
        Lx = [Lx, x];
        Ly = [Ly, y];
        Lz = [Lz, z + Z_offset];
        dLx = [dLx, dx];
        dLy = [dLy, dy];
        dLz = [dLz, dz];
    end
    figure;
    quiver3(Lx, Ly, Lz, dLx, dLy, dLz, 'r');
    axis equal;
    xlabel('x'); ylabel('y'); zlabel('z');
    title('Vectores dl en espiras');
end