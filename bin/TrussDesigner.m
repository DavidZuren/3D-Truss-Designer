function varargout = TrussDesigner(varargin)
% TRUSSDESIGNER MATLAB code for TrussDesigner.fig
%      TRUSSDESIGNER, by itself, creates a new TRUSSDESIGNER or raises the existing
%      singleton*.
%
%      H = TRUSSDESIGNER returns the handle to a new TRUSSDESIGNER or the handle to
%      the existing singleton*.
%
%      TRUSSDESIGNER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRUSSDESIGNER.M with the given input arguments.
%
%      TRUSSDESIGNER('Property','Value',...) creates a new TRUSSDESIGNER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TrussDesigner_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TrussDesigner_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TrussDesigner

% Last Modified by GUIDE v2.5 14-Jun-2021 15:27:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TrussDesigner_OpeningFcn, ...
                   'gui_OutputFcn',  @TrussDesigner_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
function TrussDesigner_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TrussDesigner (see VARARGIN)

    % Choose default command line output for TrussDesigner
    handles.output = hObject;
    handles.Nodes = [];
    handles.Conn = [];
    handles.NodesRadius = 0.2;
    handles.ConnRadius = 0.02;
    handles.xmin = -10;
    handles.xmax = 10;
    handles.ymin = -10;
    handles.ymax = 10;
    handles.zmin = -10;
    handles.zmax = 10;
    handles.IMPORT_H = [];
    ResetAll(hObject, handles);
    % Update handles structure
    guidata(hObject, handles);
    
    
function varargout = TrussDesigner_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
% Buttons Callbacks
% --------------------------------------------------------------------
function btnAddNode_Callback(hObject, eventdata, handles)
    set(handles.btnAddNode,'Enable','off');
    set(handles.editNodeX, 'String', '');
    set(handles.editNodeY, 'String', '');
    set(handles.editNodeZ, 'String', '');
    set(handles.btnRemoveNode, 'Enable', 'off');
    set(handles.btnEditNode, 'Enable', 'off');
    set(handles.editNodeX, 'Enable', 'on');
    set(handles.editNodeY, 'Enable', 'on');
    set(handles.editNodeZ, 'Enable', 'on');
    set(handles.editNodeRadius, 'Enable', 'on');
    set(handles.btnNodeDraw, 'Enable', 'on');
    set(handles.btnNodeDraw, 'String', 'Add');
    set(handles.CancelNodeDraw,'Enable','on');
    set(handles.comboNodes, 'Enable', 'off'); 

function btnNodeDraw_Callback(hObject, eventdata, handles)
    set(handles.btnSave,'Enable','on');
    [val, x, y, z] = CheckForNodesCoords(handles);
    if val
        if strcmp(get(handles.btnNodeDraw, 'String'), 'Apply') == 1
            % Se va a editar un valor
            contents = cellstr(get(handles.comboNodes,'String'));
            selectedVal = contents{get(handles.comboNodes,'Value')};
            idx = str2double(selectedVal(5:end));
            handles.Nodes(idx, :) = [x, y, z];
            guidata(hObject, handles);
            resetNodeBtns(handles);
            ReDraw(handles, idx, 0);
        else
            % Se va a agregar un nodo nuevo
            idx = AlreadyExistNode(x, y, z, handles);
            if ~isempty(idx)
                msgbox(strcat('Already existing node: Node', num2str(idx)));
            else
                handles.Nodes = [handles.Nodes; [x, y, z]];
                guidata(hObject, handles);

                contents = cellstr(get(handles.comboNodes, 'String'));
                newNode = strcat('Node ', num2str(size(handles.Nodes, 1)));            
                if size(handles.Nodes, 1) == 1
                    idx = 1;                
                else
                    idx = length(contents) + 1;
                end
                contents{idx} =  newNode;
                set(handles.comboNodes, 'String', contents);
                resetNodeBtns(handles);
%                 set(handles.comboNodes,'Value', idx);
%                 set(handles.editNodeX, 'Enable', 'off');
%                 set(handles.editNodeY, 'Enable', 'off');
%                 set(handles.editNodeZ, 'Enable', 'off');
%                 set(handles.btnNodeDraw, 'Enable', 'off');  
%                 set(handles.CancelNodeDraw,'Enable','off');
%                 set(handles.comboNodes, 'Enable', 'on');
%                 set(handles.btnAddNode,'Enable','on');
                ReDraw(handles, idx, 0);
            end
        end
    end
    % Ya existen 2 nodos, así que se puede crear una conexión
    if size(handles.Nodes, 1) >= 2 
        set(handles.comboConn, 'Enable', 'on');
        set(handles.btnAddConn, 'Enable', 'on');
        set(handles.btnDeleteConn, 'Enable', 'off');
        set(handles.btnEditConn, 'Enable', 'off');
        set(handles.comboConnFrom, 'Enable', 'off');
        set(handles.comboConnTo, 'Enable', 'off');
        set(handles.editConnRadius, 'Enable', 'on');
        set(handles.btnPrint,'Enable','on');
        set(handles.btnSave,'Enable','on');
        set(handles.FitAxis,'Enable','on');
        set(handles.Analizer,'Enable','on')
    else
        set(handles.comboConn, 'Enable', 'off');
        set(handles.btnAddConn, 'Enable', 'off');
        set(handles.btnDeleteConn, 'Enable', 'off');
        set(handles.btnEditConn, 'Enable', 'off');
        set(handles.comboConnFrom, 'Enable', 'off');
        set(handles.comboConnTo, 'Enable', 'off');  
        set(handles.editConnRadius, 'Enable', 'off');
    end

function btnRemoveNode_Callback(hObject, eventdata, handles)
set(handles.editNodeX, 'String', '');
set(handles.editNodeY, 'String', '');
set(handles.editNodeZ, 'String', '');
set(handles.btnEditNode,'Enable','off');
set(handles.btnSave,'Enable','on');
    content = cellstr(get(handles.comboNodes, 'String'));
    idx = str2double(content{get(handles.comboNodes, 'Value')}(5:end));
    if any(handles.Conn(:) == idx)
        msgbox(strcat('Connections associated with node ', num2str(idx), ' must be deleted first'));
    else
        handles.Nodes(idx, :) = [];
        % Actualizar las nuevas etiquetas de los nodos
        handles.Conn(handles.Conn > idx) = handles.Conn(handles.Conn > idx) - 1;
        % Eliminar la ultima etiqueta en el listado de nodos
        contentNode = cellstr(get(handles.comboNodes, 'String'));
        contentNode(end, :) = []; 
        if isempty(handles.Nodes)
            contentNode = '- Add node -';
            set(handles.btnEditNode,'Enable','off');
            set(handles.btnRemoveNode,'Enable','off');
            set(handles.comboNodes,'Enable','off');
        end
        set(handles.comboNodes, 'String', contentNode);
        set(handles.comboNodes, 'Value', 1);
        guidata(hObject, handles);
        % Actualizar las nuevas etiquetas en el listado de conexiones
        %FillComboConnFromHandles(handles);
        ReDraw(handles, 0, 0);
    end
function btnEditNode_Callback(hObject, eventdata, handles)
    set(handles.btnNodeDraw, 'String', 'Apply');
    set(handles.comboNodes, 'Enable', 'off');
    set(handles.btnAddNode,'Enable','off');
    set(handles.btnRemoveNode,'Enable','off');
    set(handles.btnEditNode,'Enable','off');
    set(handles.btnNodeDraw,'Enable','on');
    set(handles.editNodeX, 'Enable', 'on');
    set(handles.editNodeY, 'Enable', 'on');
    set(handles.editNodeZ, 'Enable', 'on');
    set(handles.CancelNodeDraw,'Enable','on');
      
function resetNodeBtns(handles)
set(handles.btnNodeDraw,'Enable','off');
set(handles.CancelNodeDraw,'Enable','off');
set(handles.editNodeX, 'Enable', 'off');
set(handles.editNodeY, 'Enable', 'off');
set(handles.editNodeZ, 'Enable', 'off'); 
set(handles.comboNodes, 'Enable', 'on');
set(handles.btnRemoveNode, 'Enable', 'off');
set(handles.btnEditNode, 'Enable', 'off');
set(handles.btnAddNode,'Enable','on');

function CancelNodeDraw_Callback(hObject, eventdata, handles)
set(handles.editNodeX, 'String', '');
set(handles.editNodeY, 'String', '');
set(handles.editNodeZ, 'String', '');
resetNodeBtns(handles);
          
function btnAddConn_Callback(hObject, eventdata, handles)
    set(handles.comboNodes,'Enable','off');
    set(handles.btnAddNode,'Enable','off');
    set(handles.btnRemoveNode, 'Enable', 'off');
    set(handles.btnEditNode, 'Enable', 'off');
    set(handles.comboConnFrom, 'Enable', 'on');
    set(handles.comboConnTo, 'Enable', 'on');
    FillConnCombos(handles, 1, 2);
   
    set(handles.btnConnDraw, 'Enable', 'on');
    set(handles.CancelConnDraw,'Enable','on');
    set(handles.btnConnDraw, 'String', 'Add');
    set(handles.comboConn, 'Enable', 'off'); 
    set(handles.btnAddConn,'Enable','off');
    set(handles.btnDeleteConn,'Enable','off');
    set(handles.btnEditConn,'Enable','off');
    guidata(hObject, handles);
    
function btnConnDraw_Callback(hObject, eventdata, handles)
    set(handles.btnSave,'Enable','on');
    set(handles.btnSave,'Enable','on');
    set(handles.FitAxis,'Enable','on');
    if strcmp(get(handles.btnConnDraw, 'String'), 'Apply') == 1
        % Se va a editar un valor
        idx = AlreadyExistConn(handles);
        if ~isempty(idx)
            msgbox(strcat('Already existing connection betwen: Node', num2str(handles.Conn(idx, 1)), ' - Node', num2str(handles.Conn(idx, 2))));
            %restaurar los valores a los combo de seleccion
            contents = cellstr(get(handles.comboConn,'String'));
            idx = get(handles.comboConn,'Value');
            selectedVal = contents{idx};
            % splitear para quedarme con los indices
            selectedVal(isspace(selectedVal)) = [];
            splitted = strsplit(selectedVal, '-');
            idx1 = str2double(splitted{1}(5:end));
            idx2 = str2double(splitted{2}(5:end));
            FillConnCombos(handles, idx1, idx2);
        else
            contents = cellstr(get(handles.comboConn,'String'));
            selectedIdx = get(handles.comboConn,'Value');
            
            content = cellstr(get(handles.comboConnFrom, 'String'));
            idxStr = content{get(handles.comboConnFrom, 'Value')};
            n1 = str2double(idxStr(5:end));
            content = cellstr(get(handles.comboConnTo, 'String'));
            idxStr = content{get(handles.comboConnTo, 'Value')};
            n2 = str2double(idxStr(5:end));
            
            handles.Conn(selectedIdx, :) = [n1 n2];
            newConn = strcat('Node ', num2str(n1), ' - Node', num2str(n2));
            contents{selectedIdx} = newConn;
            set(handles.comboConn, 'String', contents);
            set(handles.comboConn, 'Value', selectedIdx);
                        
            guidata(hObject, handles);            
            ReDraw(handles, 0, selectedIdx);            
        end       
        resetConnBtns(handles);

    else
        % Se va a agregar una conexión nueva
        idx = AlreadyExistConn(handles);
        if ~isempty(idx)
            msgbox(strcat('Already existing connectino between: Node', num2str(handles.Conn(idx, 1)), ' - Node', num2str(handles.Conn(idx, 2))));
            %restaurar los valores a los combo de seleccion
            contents = cellstr(get(handles.comboConn,'String'));
            idx = get(handles.comboConn,'Value');
            selectedVal = contents{idx};
            % splitear para quedarme con los indices
            selectedVal(isspace(selectedVal)) = [];
            splitted = strsplit(selectedVal, '-');
            idx1 = str2double(splitted{1}(5:end));
            idx2 = str2double(splitted{2}(5:end));
            FillConnCombos(handles, idx1, idx2);
        else
            content = cellstr(get(handles.comboConnFrom, 'String'));
            idxStr = content{get(handles.comboConnFrom, 'Value')};
            n1 = str2double(idxStr(5:end));
            content = cellstr(get(handles.comboConnTo, 'String'));
            idxStr = content{get(handles.comboConnTo, 'Value')};
            n2 = str2double(idxStr(5:end));
            handles.Conn = [handles.Conn; [n1 n2]];            
            guidata(hObject, handles);

            contents = cellstr(get(handles.comboConn, 'String'));
            newConn = strcat('Node ', num2str(n1), ' - Node', num2str(n2));            
            if size(handles.Conn, 1) == 1
                idx = 1;                
            else
                idx = length(contents) + 1;
            end
            contents{idx} =  newConn;
            set(handles.comboConn, 'String', contents);
            set(handles.comboConn,'Value', idx);
            resetConnBtns(handles);
            ReDraw(handles, 0, idx);
        end
    end
    
function btnDeleteConn_Callback(hObject, eventdata, handles)
    set(handles.btnSave,'Enable','on');
    contents = cellstr(get(handles.comboConn,'String'));
    idx = get(handles.comboConn,'Value');
    selectedVal = contents{idx};
    contents(idx,:) = [];
    if isempty(contents)
        contents = '- Add connection -';
    end
    set(handles.comboConn, 'String', contents);
    set(handles.comboConn, 'Value', 1);
    % splitear para quedarme con los indices
    selectedVal(isspace(selectedVal)) = [];
    splitted = strsplit(selectedVal, '-');
    idx1 = str2double(splitted{1}(5:end));
    idx2 = str2double(splitted{2}(5:end));
    idxConn = find(ismember(handles.Conn, [idx1 idx2; idx2 idx1], 'rows') == 1);
    handles.Conn(idxConn, :) = [];
    if isempty(handles.Conn)
        set(handles.comboConn, 'Enable', 'off');
        set(handles.comboConnFrom, 'Enable', 'off');
        set(handles.comboConnTo, 'Enable', 'off');
        set(handles.btnEditConn, 'Enable', 'off');
        set(handles.btnDeleteConn, 'Enable', 'off');        
    end
    guidata(hObject, handles);
    ReDraw(handles, 0, 0);  
    
function btnEditConn_Callback(hObject, eventdata, handles)
    contents = cellstr(get(handles.comboConn,'String'));
    idx = get(handles.comboConn,'Value');
    selectedVal = contents{idx};
    % splitear para quedarme con los indices
    selectedVal(isspace(selectedVal)) = [];
    splitted = strsplit(selectedVal, '-');
    idx1 = str2double(splitted{1}(5:end));
    idx2 = str2double(splitted{2}(5:end));
    FillConnCombos(handles, idx1, idx2);
    ReDraw(handles, 0, idx);
    
    set(handles.comboConn, 'Enable', 'off');
    set(handles.btnAddConn,'Enable','off');
    set(handles.btnDeleteConn,'Enable','off');
    set(handles.btnAddNode,'Enable','off');
    set(handles.comboConnFrom, 'Enable', 'on');
    set(handles.comboConnTo, 'Enable', 'on');
    set(handles.btnConnDraw, 'Enable', 'on');
    set(handles.CancelConnDraw,'Enable','on');
    set(handles.btnConnDraw, 'String', 'Apply');
    
 function resetConnBtns(handles)
    set(handles.btnConnDraw,'Enable','off');
    set(handles.CancelConnDraw,'Enable','off');
    set(handles.comboConnFrom, 'Enable', 'off');
    set(handles.comboConnTo, 'Enable', 'off');
    set(handles.btnAddConn,'Enable','on');
    set(handles.btnDeleteConn, 'Enable', 'off');
    set(handles.btnEditConn, 'Enable', 'off');
    set(handles.editConnRadius, 'Enable', 'on');
    set(handles.comboConn, 'Enable', 'on');
    set(handles.btnAddNode,'Enable','on');
    set(handles.comboNodes,'Enable','on');

function CancelConnDraw_Callback(hObject, eventdata, handles)
    resetConnBtns(handles);
     
function FitAxis_Callback(hObject, eventdata, handles)
    Nodes = handles.Nodes;
    xmin = min(Nodes(:,1))-handles.NodesRadius*2;
    xmax = max(Nodes(:,1))+handles.NodesRadius*2;
    ymin = min(Nodes(:,2))-handles.NodesRadius*2;
    ymax = max(Nodes(:,2))+handles.NodesRadius*2;
    zmin = min(Nodes(:,3))-handles.NodesRadius*2;
    zmax = max(Nodes(:,3))+handles.NodesRadius*2;   
    set(handles.editXMin,'String',xmin)
    set(handles.editXMax,'String',xmax)
    set(handles.editYMin,'String',ymin)
    set(handles.editYMax,'String',ymax)
    set(handles.editZMin,'String',zmin)
    set(handles.editZMax,'String',zmax)
    xlim([xmin,xmax])
    ylim([ymin,ymax])
    zlim([zmin,zmax])
    handles.xmin = xmin;
    handles.xmax = xmax;
    handles.ymin = ymin;
    handles.ymax = ymax;
    handles.zmin = zmin;
    handles.zmax = zmax;
    guidata(hObject, handles);

function btnPrint_Callback(hObject, eventdata, handles)
    PrintToStl(handles);
function btnSave_Callback(hObject, eventdata, handles)
    set(handles.btnSave,'Enable','off');
    set(handles.Analizer,'Enable','on');
    SaveToFile(handles);
function btnClose_Callback(hObject, eventdata, handles)
    close all;
function btnAbout_Callback(hObject, eventdata, handles)
    guifig = open('About.fig');
function chkLabel_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
% PopupMenu Callbacks
% --------------------------------------------------------------------
function comboNodes_Callback(hObject, eventdata, handles)
    contents = cellstr(get(hObject,'String'));
    selectedVal = contents{get(hObject,'Value')};
    idx = str2double(selectedVal(5:end));
    set(handles.editNodeX, 'String', num2str(handles.Nodes(idx, 1)));
    set(handles.editNodeY, 'String', num2str(handles.Nodes(idx, 2)));
    set(handles.editNodeZ, 'String', num2str(handles.Nodes(idx, 3)));
    if ~isempty(handles.Nodes)
        set(handles.btnEditNode, 'Enable', 'on');
        set(handles.btnRemoveNode, 'Enable', 'on');
    end
    ReDraw(handles, idx, 0);
    
function comboConn_Callback(hObject, eventdata, handles)
    if ~isempty(handles.Conn)
        set(handles.btnEditConn, 'Enable', 'on');
        set(handles.btnDeleteConn, 'Enable', 'on');
        contents = cellstr(get(hObject, 'String'));
        idx = get(hObject, 'Value');
        selectedVal = contents{idx};
        % splitear para quedarme con los indices
        selectedVal(isspace(selectedVal)) = [];
        splitted = strsplit(selectedVal, '-');
        idx1 = str2double(splitted{1}(5:end));
        idx2 = str2double(splitted{2}(5:end));
        FillConnCombos(handles, idx1, idx2);
        ReDraw(handles, 0, idx);
    end
    
function comboConnFrom_Callback(hObject, eventdata, handles)
    contentFrom = cellstr(get(hObject,'String'));
    selectedFrom = contentFrom{get(hObject,'Value')};
    
    contentTo = cellstr(get(handles.comboConnTo,'String'));
    selectedTo = contentTo{get(handles.comboConnTo,'Value')};
    if ~isempty(handles.Conn)
        set(handles.btnEditConn, 'Enable', 'on');
    end
    FillConnCombos(handles, str2double(selectedFrom(5:end)), str2double(selectedTo(5:end)));
    
function comboConnTo_Callback(hObject, eventdata, handles)
    contentTo = cellstr(get(hObject,'String'));
    selectedTo = contentTo{get(hObject,'Value')};
    
    contentFrom = cellstr(get(handles.comboConnFrom, 'String'));
    selectedFrom = contentFrom{get(handles.comboConnFrom,'Value')};
    FillConnCombos(handles, str2double(selectedFrom(5:end)), str2double(selectedTo(5:end)));

% --------------------------------------------------------------------
% Edits Callbacks
% --------------------------------------------------------------------
function editNodeX_Callback(hObject, eventdata, handles)
function editNodeY_Callback(hObject, eventdata, handles)
function editNodeZ_Callback(hObject, eventdata, handles)
function editXMin_Callback(hObject, eventdata, handles)
    val = str2double(get(handles.editXMin,'String'));
    if val >= handles.xmax 
        msgbox('X min no puede ser mayor a X max');
        set(set(handles.editXMin,'String',handles.xmin));
    else
        if isnan(val)
            msgbox('El valor de X min debe ser un número');
            set(set(handles.editXMin,'String',handles.xmin));
        else
            xlim([val,handles.xmax])
            handles.xmin = val;
            guidata(hObject, handles);
        end
    end
function editXMax_Callback(hObject, eventdata, handles)
    val = str2double(get(handles.editXMax,'String'));
    if val <= handles.xmin
        msgbox('X max no puede ser menor a X min');
        set(set(handles.editXMax,'String',handles.xmax))
    else
        if isnan(val)
            msgbox('El valor de X max debe ser un número');
            set(set(handles.editXMax,'String',handles.xmax))
        else
            xlim([handles.xmin, val])
            handles.xmax = val;
            guidata(hObject, handles);
        end
    end
function editYMin_Callback(hObject, eventdata, handles)
    val = str2double(get(handles.editYMin,'String'));
    if val >= handles.ymax 
        msgbox('Y min no puede ser mayor a Y max');
        set(set(handles.editYMin,'String',handles.ymin));
    else
        if isnan(val)
            msgbox('El valor de Y min debe ser un número');
            set(set(handles.editYMin,'String',handles.Ymin));
        else
            ylim([val,handles.ymax])
            handles.ymin = val;
            guidata(hObject, handles);
        end
    end
function editYMax_Callback(hObject, eventdata, handles)
    val = str2double(get(handles.editYMax,'String'));
    if val <= handles.ymin
        msgbox('Y max no puede ser menor a Y min');
        set(set(handles.editYMax,'String',handles.ymax))
    else
        if isnan(val)
            msgbox('El valor de Y max debe ser un número');
            set(set(handles.editYMax,'String',handles.ymax))
        else
            ylim([handles.ymin, val])
            handles.ymax = val;
            guidata(hObject, handles);
        end
    end
function editZMin_Callback(hObject, eventdata, handles)
    val = str2double(get(handles.editZMin,'String'));
    if val >= handles.zmax 
        msgbox('Z min no puede ser mayor a Z max');
        set(set(handles.editZMin,'String',handles.zmin));
    else
        if isnan(val)
            msgbox('El valor de Z min debe ser un número');
            set(set(handles.editZMin,'String',handles.Zmin));
        else
            zlim([val,handles.zmax])
            handles.zmin = val;
            guidata(hObject, handles);
        end
    end
function editZMax_Callback(hObject, eventdata, handles)
    val = str2double(get(handles.editZMax,'String'));
    if val <= handles.zmin
        msgbox('Z max no puede ser menor a Z min');
        set(set(handles.editZMax,'String',handles.zmax))
    else
        if isnan(val)
            msgbox('El valor de Z max debe ser un número');
            set(set(handles.editZMax,'String',handles.zmax))
        else
            zlim([handles.zmin, val])
            handles.zmax = val;
            guidata(hObject, handles);
        end
    end
function editNodeRadius_Callback(hObject, eventdata, handles)
    nodesRadius = str2double(get(handles.editNodeRadius, 'String'));
    if isnan(nodesRadius)
        mbox('El valor del radio debe ser numérico.');
    else
        handles.NodesRadius = nodesRadius;
        guidata(hObject, handles);
        ReDraw(handles, 0, 0);
    end
function editConnRadius_Callback(hObject, eventdata, handles)
    connRadius = str2double(get(handles.editConnRadius, 'String'));
    if isnan(connRadius)
        mbox('Radius must be a number');
    else
        handles.ConnRadius = connRadius;
        guidata(hObject, handles);
        ReDraw(handles, 0, 0);
    end
    
% --------------------------------------------------------------------
% MenuBar Callbacks
% --------------------------------------------------------------------
function barmenuNew_ClickedCallback(hObject, eventdata, handles)
    ResetAll(hObject, handles);    
function menubarOpen_ClickedCallback(hObject, eventdata, handles)
    ResetAll(hObject, handles);        
    if isempty(handles.IMPORT_H)
        handles.IMPORT_H = LoadFromFile('name','Abrir');
        % obtain data in LIST
        IMPORT_data = guidata(handles.IMPORT_H); 
        % store handle to MAIN as data in LIST
        IMPORT_data.MAIN_H = get(hObject,'parent');
        % save the LIST data 
        guidata(handles.IMPORT_H, IMPORT_data);        
        % save the handles structure as data of MAIN
        guidata(get(hObject,'parent'), handles);        
    end
    set(handles.FitAxis,'Enable','on');
    set(handles.btnConnDraw,'Enable','on');
    set(handles.btnPrint,'Enable','on');
    set(handles.btnSave,'Enable','on');
    set(handles.Analizer,'Enable','on');
    
function menubarSave_ClickedCallback(hObject, eventdata, handles)
    SaveToFile(handles);
function menubarPrint_ClickedCallback(hObject, eventdata, handles)
    PrintToStl(handles);
function btnOpenFiles_Callback(hObject, eventdata, handles)
    menubarOpen_ClickedCallback(hObject, eventdata, handles)


% --------------------------------------------------------------------
% Auxiliar functions
% --------------------------------------------------------------------
function ResetAll(hObject, handles)
    handles.Nodes = [];
    handles.Conn = [];
    handles.NodesRadius = 0.2;
    handles.ConnRadius = 0.02;
    handles.xmin = -10;
    handles.xmax = 10;
    handles.ymin = -10;
    handles.ymax = 10;
    handles.zmin = -10;
    handles.zmax = 10;
    handles.IMPORT_H = [];
    
    set(handles.btnRemoveNode, 'Enable', 'off');
    set(handles.btnEditNode, 'Enable', 'off');
    set(handles.editNodeX, 'Enable', 'off');
    set(handles.editNodeX, 'String', '');
    set(handles.editNodeY, 'Enable', 'off');
    set(handles.editNodeY, 'String', '');
    set(handles.editNodeZ, 'Enable', 'off');
    set(handles.editNodeZ, 'String', '');
    set(handles.editNodeRadius, 'Enable', 'off');
%     set(handles.btnNodeDraw, 'Visible', 'off');
    set(handles.comboConn, 'Enable', 'off');
    set(handles.btnAddConn, 'Enable', 'off');
    set(handles.btnDeleteConn, 'Enable', 'off');
    set(handles.btnEditConn, 'Enable', 'off');
    set(handles.comboConnFrom, 'Enable', 'off');
    set(handles.comboConnTo, 'Enable', 'off');
    set(handles.editConnRadius, 'Enable', 'off');
       
    %set(handles.editXMin, 'String', num2str(handles.xmin));
    %set(handles.editYMin, 'String', num2str(handles.ymin));
    %set(handles.editZMin, 'String', num2str(handles.zmin));
    %set(handles.editXMax, 'String', num2str(handles.xmax));
    %set(handles.editYMax, 'String', num2str(handles.ymax));
    %set(handles.editZMax, 'String', num2str(handles.zmax));
    set(handles.editNodeRadius, 'String', num2str(handles.NodesRadius));
    set(handles.editConnRadius, 'String', num2str(handles.ConnRadius));
    set(handles.comboConnFrom, 'String', '- Node -');
    set(handles.comboConnFrom, 'Value', 1);
    set(handles.comboConnTo, 'String', '- Node -');
    set(handles.comboConnTo, 'Value', 1);
    set(handles.comboConn, 'String', '- Add connection -');
    set(handles.comboConn, 'Value', 1);
    set(handles.comboNodes, 'String', '- Add node -');
    set(handles.comboNodes, 'Value', 1);
    
    cla;
    set(gca,'BoxStyle','full','Box','on');
    plot3(0,0,0,'.w');
    xlim([handles.xmin,handles.xmax])
    ylim([handles.ymin,handles.ymax])
    zlim([handles.zmin,handles.zmax])
    xlabel('X [cm]')
    ylabel('Y [cm]')
    zlabel('Z [cm]')
    grid on
    guidata(hObject, handles);
    
function [val, xCoord, yCoord, zCoord] = CheckForNodesCoords(handles)
    val = 0;
    xCoord = str2double(get(handles.editNodeX, 'String'));
    yCoord = str2double(get(handles.editNodeY, 'String'));
    zCoord = str2double(get(handles.editNodeZ, 'String'));
    if(isnan(xCoord))
        msgbox('X value must be a number');
    elseif isnan(yCoord)
        msgbox('Y value must be a number');
    elseif isnan(zCoord)
        msgbox('Z value must be a number');
    else
        val = 1;
    end
function idx = AlreadyExistNode(x, y, z, handles)
    idx = [];
    if ~isempty(handles.Nodes)
        [~,idx] = intersect(handles.Nodes, [x y z], 'rows');
    end
function idx = AlreadyExistConn(handles)
    idx = [];
    if ~isempty(handles.Conn)
        fromContents = cellstr(get(handles.comboConnFrom, 'String'));
        n1str = fromContents{get(handles.comboConnFrom, 'Value')};
        n1 = str2double(n1str(5:end));
        
        toContents = cellstr(get(handles.comboConnTo, 'String'));
        n2str = toContents{get(handles.comboConnTo, 'Value')};
        n2 = str2double(n2str(5:end));
        [~,idx] = intersect(handles.Conn, [n1 n2; n2 n1], 'rows');        
    end
   
function FillConnCombos(handles, idxFrom, idxTo)
    allContents = {};
    for i = 1:size(handles.Nodes, 1)
       newNode = strcat('Node ', num2str(i));
       allContents{end+1} =  newNode;
    end
    contents1 = [allContents(1:idxTo-1) allContents(idxTo+1:end)];
    idx = find(strcmp(contents1, strcat('Node', num2str(idxFrom))));
    set(handles.comboConnFrom, 'String', contents1);
    set(handles.comboConnFrom,'Value', idx);
    contents2 = [allContents(1:idxFrom-1) allContents(idxFrom+1:end)];
    idx = find(strcmp(contents2,strcat('Node', num2str(idxTo))));
    set(handles.comboConnTo, 'String', contents2);
    set(handles.comboConnTo,'Value', idx);    
    
function SaveToFile(handles)
    % Guardar nodos
    fileID = fopen('Nodes.txt','w');
    fprintf(fileID,'%u \n',size(handles.Nodes, 1));
    indx = (1:1:size(handles.Nodes, 1))';
    fprintf(fileID,'%u %12.8f %12.8f %12.8f\n', [indx handles.Nodes]');
    fclose(fileID);
    % Guardar conecciones
    fileID = fopen('Connections.txt','w');
    fprintf(fileID,'%u \n',size(handles.Conn, 1));
    indx = (1:1:size(handles.Conn, 1))';
    fprintf(fileID,'%u %u %u\n', [indx handles.Conn]');
    fclose(fileID);
    msgbox('Nodes and connection files have been saved');
function PrintToStl(handles)
    [file, path] = uiputfile('*.stl','Guardar fichero stl');
    if ~(isequal(file,0) || isequal(path,0))
        nn = size(handles.Nodes, 1);
        cn = size(handles.Conn, 1);
        xCell = cell(1, nn + cn);
        yCell = cell(1, nn + cn);
        zCell = cell(1, nn + cn);
        
        [x, y, z] = sphere;
        r = str2double(get(handles.editNodeRadius, 'String'))*10;
        Nodes = handles.Nodes * 10; % Se guarda en milimetros y se esta mostrando en cm
        for i = 1:nn
            xC = Nodes(i, 1);
            yC = Nodes(i, 2);
            zC = Nodes(i, 3);
            xCell{i} = x*r + xC;
            yCell{i} = y*r + yC;
            zCell{i} = z*r + zC;
        end
        for i = 1:cn
            x1 = Nodes(handles.Conn(i, 1), 1);
            y1 = Nodes(handles.Conn(i, 1), 2);
            z1 = Nodes(handles.Conn(i, 1), 3);
            x2 = Nodes(handles.Conn(i, 2), 1);
            y2 = Nodes(handles.Conn(i, 2), 2);
            z2 = Nodes(handles.Conn(i, 2), 3);
            [x, y, z] = cylinder2P(handles.ConnRadius*10, 20, [x1, y1, z1], [x2, y2, z2]);
            xCell{i + nn} = x;
            yCell{i + nn} = y;
            zCell{i + nn} = z;
        end
        surf2stlv2(fullfile(path,file), xCell, yCell, zCell, 'ascii'); 
    end
function surf2stlv2(filename, xCell, yCell, zCell, mode)
    %SURF2STLv2   Write STL file from cell array of surfaces data.
    %   SURF2STL('filename', X, Y, Z) writes a stereolithography (STL) file
    %   for several surfaces. Each surface has geometry defined by three matrix arguments, X, Y
    %   and Z.  X, Y and Z must be two-dimensional arrays with the same size.
    %
    %   SURF2STLV2(...,'mode') may be used to specify the output format.
    %
    %     'binary' - writes in STL binary format (default)
    %     'ascii'  - writes in STL ASCII format
    %
    %   Author: Bill McDonald, 02-20-04
    %   Modified by: Suset G. Rodríguez Alemán 09-23-18
    narginchk(4, 5);
    if ~ischar(filename)
        error( 'Invalid filename');
    end
    if nargin < 5
        mode = 'binary';
    elseif ~strcmp(mode,'ascii')
        mode = 'binary';
    end

    for i = 1:length(zCell)
        x = cell2mat(xCell(i));
        y = cell2mat(yCell(i));
        z = cell2mat(zCell(i));
        if ndims(z) ~= 2
            error( 'Variable z must be a 2-dimensional array' );
        end
        if any( (size(x) ~= size(z)) | (size(y) ~= size(z)) )    
            % size of x or y does not match size of z
            if ( (length(x) == 1) && (length(y) == 1) )
                % Must be specifying dx and dy, so make vectors
                dx = x;
                dy = y;
                x = ((1:size(z,2))-1)*dx;
                y = ((1:size(z,1))-1)*dy;
            end
            if ( (length(x) == size(z, 2)) && (length(y) == size(z, 1)))
                % Must be specifying vectors
                xvec = x;
                yvec = y;
                [x, y] = meshgrid(xvec, yvec);
                xCell{i} = x;
                yCell{i} = y;
            else
                error('Unable to resolve x and y variables');
            end
        end
    end

    if strcmp(mode, 'ascii')
        % Open for writing in ascii mode
        fid = fopen(filename, 'w');
    else
        % Open for writing in binary mode
        fid = fopen(filename, 'wb+');
    end

    if (fid == -1)
        error('Unable to write to %s', filename);
    end

    title_str = sprintf('Created by surf2stlv2.m %s', datestr(now));

    if strcmp(mode, 'ascii')
        fprintf(fid, 'solid %s\r\n', title_str);
    else
        str = sprintf('%-80s', title_str);    
        fwrite(fid, str, 'uchar');         % Title
        fwrite(fid, 0, 'int32');           % Number of facets, zero for now
    end

    nfacets = 0;
    for k = 1:length(xCell)
        x = cell2mat(xCell(k));
        y = cell2mat(yCell(k));
        z = cell2mat(zCell(k));
        for i = 1:(size(z, 1) - 1)
            for j = 1:(size(z, 2) - 1)

                p1 = [x(i,j)     y(i,j)     z(i,j)];
                p2 = [x(i,j+1)   y(i,j+1)   z(i,j+1)];
                p3 = [x(i+1,j+1) y(i+1,j+1) z(i+1,j+1)];
                val = local_write_facet(fid, p1, p2, p3, mode);
                nfacets = nfacets + val;

                p1 = [x(i+1,j+1) y(i+1,j+1) z(i+1,j+1)];
                p2 = [x(i+1,j)   y(i+1,j)   z(i+1,j)];
                p3 = [x(i,j)     y(i,j)     z(i,j)];        
                val = local_write_facet(fid, p1, p2, p3, mode);
                nfacets = nfacets + val;
            end
        end
    end

    if strcmp(mode, 'ascii')
        fprintf(fid, 'endsolid %s\r\n', title_str);
    else
        fseek(fid, 0, 'bof');
        fseek(fid, 80, 'bof');
        fwrite(fid, nfacets, 'int32');
    end
    fclose(fid);
function num = local_write_facet(fid,p1,p2,p3,mode)
    if any( isnan(p1) | isnan(p2) | isnan(p3) )
        num = 0;
        return;
    else
        num = 1;
        n = local_find_normal(p1,p2,p3);
        if strcmp(mode,'ascii')
            fprintf(fid,'facet normal %.7E %.7E %.7E\r\n', n(1),n(2),n(3) );
            fprintf(fid,'outer loop\r\n');        
            fprintf(fid,'vertex %.7E %.7E %.7E\r\n', p1);
            fprintf(fid,'vertex %.7E %.7E %.7E\r\n', p2);
            fprintf(fid,'vertex %.7E %.7E %.7E\r\n', p3);
            fprintf(fid,'endloop\r\n');
            fprintf(fid,'endfacet\r\n');
        else
            fwrite(fid,n,'float32');
            fwrite(fid,p1,'float32');
            fwrite(fid,p2,'float32');
            fwrite(fid,p3,'float32');
            fwrite(fid,0,'int16');  % unused
        end
    end
function n = local_find_normal(p1,p2,p3)
    v1 = p2-p1;
    v2 = p3-p1;
    v3 = cross(v1,v2);
    n = v3 ./ sqrt(sum(v3.*v3));

% --- Executes on button press in Analizer.
function Analizer_Callback(hObject, eventdata, handles)
condition = get(handles.btnSave,'Enable');
if strcmpi('on',condition)
    msgbox(strcat('Truss must be saved first'))
else
    run('TrussAnalizer');
end
