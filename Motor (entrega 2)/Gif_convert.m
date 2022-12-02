file_name = 'Animacion\test.gif';

for n = 1:181
    i=imread(['Animacion/frame', num2str(n),'.bmp']);
    [imind,cm] = rgb2ind(i,256);

    if n == 1
        imwrite(imind,cm,file_name,'gif', 'Loopcount',inf, 'DelayTime', 0.1);
    else
        imwrite(imind,cm,file_name,'gif','WriteMode','append', 'DelayTime',0.1);
    end
end