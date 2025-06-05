function animar_con_fondo (zm, imagen, nombre_video) 
    %zm: vector con posiciones del objeto 
    %imagen: nombre del archivo de imagen de fondo (png) 
    %nombre video: nombre del video de salida (mp4) 
    %Rango físico que usaste para graficar tu imagen 
    x_range =[-6, 6]; 
    z_range =[-6, 6]; 
    %Crear objeto de video 
    writerObj = VideoWriter(nombre_video, 'MPEG-4'); 
    %writerObj = VideoWriter(nombre_video, 'Motion JPEG AVI'); 

    writerObj.FrameRate= 30; %Puedes bajarlo para hacer la animación 
    open (writerObj) 
    %Cargar imagen 
    img = imread(imagen); 


    figure(100); clf 
    imagesc(x_range, z_range, flipud(img)); %Imagen de fondo 
    axis xy 
    hold on 
    xlabel('x (m)') 
    ylabel('z (m)') 
    title('Trayectoria sobre campo magnético');
    %Simular trayectoria punto a punto 
        for i = 1:2:length(zm)
            cla
            imagesc(x_range, z_range, flipud(img)); % Redibujar fondo
            axis xy
            hold on
            scatter(0, zm(i), 100, 'r', 'filled') % <-- Aquí va zm(i)
            xlim(x_range)
            ylim(z_range)
            frame = getframe(gcf);
            writeVideo(writerObj, frame);
        end
    close(writerObj); 
    disp(['Video guardado como', nombre_video]) 
end