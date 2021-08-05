function FillComboConnFromHandles(handles)
    content = {};
    for i = 1:size(handles.Conn, 1)
        content{end+1} = strcat('Nodo', num2str(handles.Conn(i, 1)), ' - Nodo', num2str(handles.Conn(i, 2)));
    end
    if isempty(handles.Conn)
        content = '- Agregue conexión -';
    end
    set(handles.comboConn, 'String', content);
end