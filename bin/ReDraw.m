function V = ReDraw(handles, selectedNode, selectedConn)
    cla;
    set(gca,'BoxStyle','full','Box','off');
    % Dibujar nodos
    [x, y, z] = sphere;
    V = 0;
    for i = 1:size(handles.Nodes, 1)
        xC = handles.Nodes(i, 1);
        yC = handles.Nodes(i, 2);
        zC = handles.Nodes(i, 3);
        r = handles.NodesRadius;
        V = V + 4/3*pi*r^3;
        
        h = surf(r*x + xC, r*y + yC, r*z + zC);
        hold on;
        if selectedNode ==  i || (selectedConn ~= 0 && (handles.Conn(selectedConn, 1) == i || handles.Conn(selectedConn, 2) == i))
            color = [1 0 0];
        else 
            color = [0 0 1];
        end
        set(h, 'FaceColor', color, 'FaceAlpha', 1, ...
            'FaceLighting', 'gouraud', 'EdgeColor', 'none');   
        if get(handles.chkLabel, 'Value') == 1
            % pone el texto 'a'
            txt = num2str(i);
            text(xC + 1.5*r, yC + 1.5*r, zC + 1.5*r, txt);  
        end
    end
    % Dibujar conexiones    
    for i = 1:size(handles.Conn, 1)
        x1 = handles.Nodes(handles.Conn(i, 1), 1);
        y1 = handles.Nodes(handles.Conn(i, 1), 2);
        z1 = handles.Nodes(handles.Conn(i, 1), 3);
        x2 = handles.Nodes(handles.Conn(i, 2), 1);
        y2 = handles.Nodes(handles.Conn(i, 2), 2);
        z2 = handles.Nodes(handles.Conn(i, 2), 3);
        
        height = sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2);
        V = V + pi*r^2*height;
        % cascarón del cilindro
        [x, y, z] = cylinder2P(handles.ConnRadius, 40, [x1, y1, z1], [x2, y2, z2]);
        h = surf(x, y, z);    
        hold on;
        if selectedConn ==  i
            color = [1 0 0];
        else 
            color = [0 0 1];
        end
        set(h, 'FaceColor', color, 'FaceAlpha', 1, ...
            'FaceLighting', 'gouraud', 'EdgeColor', 'none');          
    end
    daspect([1 1 1]);
    camlight;
    lighting gouraud;
    axis([handles.xmin handles.xmax handles.ymin handles.ymax handles.zmin handles.zmax]);
    
    xlabel('X cm') ;
    ylabel('Y cm') ;
    zlabel('Z cm') ;
end

