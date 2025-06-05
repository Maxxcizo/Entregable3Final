function [zm] = trayectoria(Bz, z, mag, m, zo, dt, vz, gamma)

    % Peso del objeto
    w = -m * 9.81;

    % Inicialización de vectores
    zm(1) = zo;
    zmfree(1) = zo;
    vz(1) = 0.7;
    vzfree(1) = 0;
    tt(1) = 0;
    cc = 1;

    while zm(cc) > -3

        % Derivada centrada del campo Bz
        delta = 0.005;
        Bz_forward = interp1(z, Bz, zm(cc) + delta, 'linear', 'extrap');
        Bz_backward = interp1(z, Bz, zm(cc) - delta, 'linear', 'extrap');
        dBz_dz = (Bz_forward - Bz_backward) / (2 * delta);

        % Fuerzas: magnética, fricción y total
        Fm(cc) = -mag * dBz_dz;
        Ff = -gamma * vz(cc);
        F(cc) = Fm(cc) + w + Ff;
        %a = F(cc) / m;

        % Cinemática: caída libre
        zmfree(cc+1) = zmfree(cc) + vzfree(cc)*dt + 0.5*(-9.81)*dt^2;
        vzfree(cc+1) = vzfree(cc) - 9.81 * dt;

        % Cinemática: con campo magnético
        %zm(cc+1) = zm(cc) + vz(cc)*dt + 0.5*a*dt^2;
        %vz(cc+1) = vz(cc) + a * dt;
        z_axis = z;
        [zm(cc+1), vz(cc+1)] = rk4_step(zm(cc), vz(cc), dt, @(z, v) a_total(z, v, Bz, z_axis, mag, gamma, m));

        % Tiempo
        tt(cc+1) = tt(cc) + dt;

        % Contador
        cc = cc + 1;

        % Condición de frenado
        if abs(vz(cc)) < 1e-3
            break;
        end

        % pause(0.01) % opcional
    end
    figure(99)
    hold on
    plot(tt, zm, '-r', 'LineWidth', 2)
    plot(tt, zmfree, '--b', 'LineWidth', 2)
    %plot([0, max(tt)], [0, 0], '--k', 'LineWidth', 2)
    grid on
    xlabel('time (s)')
    ylabel('z position (m)')
    title('Position vs time of a Magnetic dipole falling through a current ring')
    legend('Fall over a current ring','Free fall (no Magnetic force)','southwest')
    axis([0 max(tt) -6 6])
    %axis([0 20 -25 25])
end


function a = a_total(z, v, Bz, z_axis, mag, gamma, m)
    delta = 0.005;
    Bz_forward = interp1(z_axis, Bz, z + delta, 'linear', 'extrap');
    Bz_backward = interp1(z_axis, Bz, z - delta, 'linear', 'extrap');
    dBz_dz = (Bz_forward - Bz_backward) / (2 * delta);
    Fm = -mag * dBz_dz;
    Ff = -gamma * v;
    F = Fm + Ff - m * 9.81;
    a = F / m;
end 

function [z_next, v_next] = rk4_step(z, v, dt, a_func)
    k1z = v;
    k1v = a_func(z, v);
    k2z = v + 0.5 * dt * k1v;
    k2v = a_func(z + 0.5 * dt * k1z, v + 0.5 * dt * k1v);
    k3z = v + 0.5 * dt * k2v;
    k3v = a_func(z + 0.5 * dt * k2z, v + 0.5 * dt * k2v);
    k4z = v + dt * k3v;
    k4v = a_func(z + dt * k3z, v + dt * k3v);
    z_next = z + (dt/6) * (k1z + 2*k2z + 2*k3z + k4z);
    v_next = v + (dt/6) * (k1v + 2*k2v + 2*k3v + k4v);
end