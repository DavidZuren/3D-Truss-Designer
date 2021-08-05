function FillComboNodesFromHandles(handles)
    content = {};
    for i = 1:size(handles.Nodes, 1)
        content{end+1} = strcat('Nodo', num2str(i));
    end
    if isempty(handles.Nodes)
        content = '- Agregue Nodo -';
    end
    set(handles.comboNodes, 'String', content);
end