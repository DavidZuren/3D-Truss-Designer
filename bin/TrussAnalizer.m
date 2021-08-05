function varargout = TrussAnalizer(varargin)
%TRUSSANALIZER MATLAB code file for TrussAnalizer.fig
%      TRUSSANALIZER, by itself, creates a new TRUSSANALIZER or raises the existing
%      singleton*.
%
%      H = TRUSSANALIZER returns the handle to a new TRUSSANALIZER or the handle to
%      the existing singleton*.
%
%      TRUSSANALIZER('Property','Value',...) creates a new TRUSSANALIZER using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to TrussAnalizer_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      TRUSSANALIZER('CALLBACK') and TRUSSANALIZER('CALLBACK',hObject,...) call the
%      local function named CALLBACK in TRUSSANALIZER.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TrussAnalizer

% Last Modified by GUIDE v2.5 17-Jun-2021 12:43:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TrussAnalizer_OpeningFcn, ...
                   'gui_OutputFcn',  @TrussAnalizer_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


function TrussAnalizer_OpeningFcn(hObject, eventdata, handles, varargin)
pwd;
currentFolder = pwd;
str = '\Nodes.txt';
Folder = strcat(currentFolder, str);
type Folder;
fileID = fopen(Folder,'r');
fgets(fileID);  % Ignora la primera linea
formatSpec = '%f %f %f %f';
sizeA = [4 Inf];
Amat = fscanf(fileID,formatSpec,sizeA);
fclose(fileID);
Amat=Amat';
nonod=length(Amat);
XY=10*Amat(:,2:4);

for i=1:nonod
    text(XY(i,1)+3,XY(i,2)+3,XY(i,3)+3, num2str(i));
    hold on
end

%Introducir los elementos de la armadura
str = '\Connections.txt';
Folder = strcat(currentFolder, str);
type Folder;
elemID = fopen(Folder,'r');
fgets(fileID);  % Ignora la primera linea
formatSpec = '%f %f %f';
sizematelem = [3 Inf];
matelem = fscanf(elemID,formatSpec,sizematelem);
fclose(elemID);
matelem = matelem';
elem = length(matelem);
md=matelem(:,2:3);

%Plot dotted-line
for i=1:elem
    X_p = [XY(md(i,1),1), XY(md(i,2),1)];
    Y_p = [XY(md(i,1),2), XY(md(i,2),2)];
    Z_p = [XY(md(i,1),3), XY(md(i,2),3)];
    plot3 (X_p,Y_p,Z_p,'Color','k','LineWidth',0.1,'LineStyle','-.','LineWidth',2);
    view([-30 30])
   hold on 
end
axis equal
grid on
xlabel('Eje X')
ylabel('Eje Y')
zlabel('Eje Z')
fp = zeros(nonod*3,1);
DOFr = [];
NodosR = [];

set(handles.Reacciones,'Data',cell(6,1));
set(handles.Desplazamientos,'Data',cell(6,1));
set(handles.Esfuerzos,'Data',cell(6,1));
set(handles.MatFuerzas,'Data',cell(6,1));
handles.NodosR = NodosR;
handles.DOFr = DOFr;
handles.fp = fp;
handles.nonod = nonod;
handles.ForcesData = [];
handles.ForcesCount = 1;
handles.NumForces = {};
handles.FixedNodesData = [];
handles.FixedNodesCount = 1;
handles.NumFixedNodes = {};
handles.XY = XY;
handles.md = md;
handles.elem = elem;

info = '\icons\about.png';
Folder = strcat(currentFolder, info);
set(handles.info,'cdata',imread(Folder));
set(handles.btnRemoveForce,'Enable','off')
set(handles.btnEditForce,'Enable','off')

Nodes = [1:handles.nonod];
handles.Nodes = Nodes;
set(handles.comboNodes,'String',Nodes)
set(handles.comboNodesF,'String',Nodes)

xmin = min(XY(:,1));
xmax = max(XY(:,1));
ymin = min(XY(:,2));
ymax = max(XY(:,2));
zmin = min(XY(:,3));
zmax = max(XY(:,3)); 
handles.xmin = xmin;
handles.xmax = xmax;
handles.ymin = ymin;
handles.ymax = ymax;
handles.zmin = zmin;
handles.zmax = zmax;
set(handles.editXMin,'String',xmin)
set(handles.editXMax,'String',xmax)
set(handles.editYMin,'String',ymin)
set(handles.editYMax,'String',ymax)
set(handles.editZMin,'String',zmin)
set(handles.editZMax,'String',zmax)

ResetAllForces(hObject, handles)
ResetAllFixedNodes(hObject, handles)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TrussAnalizer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TrussAnalizer_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function NodoR_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function E_Callback(hObject, eventdata, handles)
function E_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function A_Callback(hObject, eventdata, handles)
function A_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Calcular_Callback(hObject, eventdata, handles)
warning1 = {get(handles.comboForces,'String')};
warning2 = {get(handles.comboFixedNodes,'String')};
if strcmp(warning1{1,1},'- Add force -')
    msgbox('Add forces first')
elseif strcmp(warning2{1,1},'- Add restriction -')
    msgbox('Add restrictions first')
else
    %PREPROCESAMIENTO
    hold off
    pwd;
    currentFolder = pwd;
    str = '\Nodes.txt';
    Folder = strcat(currentFolder, str);
    type Folder
    fileID = fopen(Folder,'r');
    fgets(fileID);  % Ignora la primera linea
    formatSpec = '%f %f %f %f';
    sizeA = [4 Inf];
    Amat = fscanf(fileID,formatSpec,sizeA);
    fclose(fileID);
    Amat=Amat';
    nonod=length(Amat);
    XY=10*Amat(:,2:4);
    %Introducir los elementos de la armadura
    str = '\Connections.txt';
    Folder = strcat(currentFolder, str);
    type Folder
    elemID = fopen(Folder,'r');
    fgets(fileID);  % Ignora la primera linea
    formatSpec = '%f %f %f';
    sizematelem = [3 Inf];
    matelem = fscanf(elemID,formatSpec,sizematelem);
    fclose(elemID);
    matelem = matelem';
    elem = length(matelem);

    %Definiendo las areas de seccion transvesal (m2)
    A = str2double(get(handles.A,'String'))*ones(elem,1);
    %Definiendo material para cada elemento (Unidades: MPa)
    E = str2double(get(handles.E,'String'))*ones(1,elem);
    %Cargas nodales (Unidades: N)
    fp = handles.fp;

    DOFr = handles.DOFr;

    %MALLADO : parte del preprocesamiento1
    %Matriz de conectividad de cada elemento
    md = matelem(:,2:3);  
    %PROCESAMIENTO
    %Grados de libertad totales, 3 DOF por nodo
    DOFt = 3*nonod;
    %Calculando longitudes
    L = zeros(elem,1);
    %Definiendo orientaciones por medio de los cosenos directores
    l = zeros(elem,1);   
    m = zeros(elem,1);   
    n = zeros(elem,1);    
    for    i = 1:elem
       L(i) = sqrt((XY(md(i,2),1)-XY(md(i,1),1))^2+(XY(md(i,2),2)-XY(md(i,1),2))^2+(XY(md(i,2),3)-XY(md(i,1),3))^2); 
       %Definir cosenos directores
       l(i) = (XY(md(i,2),1)-XY(md(i,1),1))/L(i); %coseno director x
       m(i) = (XY(md(i,2),2)-XY(md(i,1),2))/L(i); %coseno director y
       n(i) = (XY(md(i,2),3)-XY(md(i,1),3))/L(i); %coseno director z
    end
    %Trabajando la matriz de rigidez local (la de 6x6)
    Ke = zeros(6,6,elem);
    for    i=1:elem
         Ke(:,:,i)=(A(i)*E(i)/L(i))*[l(i)^2 l(i)*m(i) l(i)*n(i) -l(i)^2 -l(i)*m(i) -l(i)*n(i);
             l(i)*m(i) m(i)^2 m(i)*n(i) -l(i)*m(i) -m(i)^2 -m(i)*n(i);
             l(i)*n(i) m(i)*n(i) n(i)^2 -l(i)*n(i) -m(i)*n(i) -n(i)^2;
             -l(i)^2 -l(i)*m(i) -l(i)*n(i) l(i)^2 l(i)*m(i) l(i)*n(i);
             -l(i)*m(i) -m(i)^2 -m(i)*n(i) l(i)*m(i) m(i)^2 m(i)*n(i);
              -l(i)*n(i) -m(i)*n(i) -n(i)^2 l(i)*n(i) m(i)*n(i) n(i)^2];
    end
    %Se genera la matriz de destino 
    MD = zeros(elem,6); 
    for i=1:elem 
       MD(i,:)=[3*md(i,1)-2, 3*md(i,1)-1, 3*md(i,1), 3*md(i,2)-2, 3*md(i,2)-1, 3*md(i,2)];  
    end 
    %Ensamble matriz rigidez global  
    K = zeros(DOFt); 
    for i=1:elem 
        K(MD(i,1):MD(i,3),MD(i,1):MD(i,3))= K(MD(i,1):MD(i,3),MD(i,1):MD(i,3))+Ke(1:3,1:3,i);   
    %Primer cuadrante (ver figura 7) 
        K(MD(i,4):MD(i,6),MD(i,1):MD(i,3))=K(MD(i,4):MD(i,6),MD(i,1):MD(i,3))+Ke(4:6,1:3,i);   
    %Segundo cuadrante 
        K(MD(i,1):MD(i,3),MD(i,4):MD(i,6))=K(MD(i,1):MD(i,3),MD(i,4):MD(i,6))+Ke(1:3,4:6,i);   
    %Tercer cuadrante 
        K(MD(i,4):MD(i,6),MD(i,4):MD(i,6))=K(MD(i,4):MD(i,6),MD(i,4):MD(i,6))+Ke(4:6,4:6,i);   
    %Cuarto cuadrante 
    end 
    %Asignacion de vector de fuerzas 
    f = fp; 
    %Aplicacion de los grados de libertad restringidos
    %Para la matriz
    Kr =K;
    Kr(DOFr, :)=[]; 
    Kr(:,DOFr)=[]; 
    %Para el vector fuerzas
    fr   = f;
    fr(DOFr)=[]; 
    %Solucion
    ur = Kr\fr;
    %Incorporacion de u reducida a u global
    u = zeros(DOFt,1);
    cont_i=1;
    for    i = 1:DOFt
        if sum ( i == DOFr) == 1
            %Si mi indicador i es igual a algunos de los grados de libertad
            %proscritos por DOFr entonces esta posicion tendra desplazamiento
            %cero...
            u(i)=0;
        else
            %... si no, correspondera a alguno de los desplazamientos de ur.
            u(i) = ur(cont_i);
            cont_i = cont_i +1;
        end
    end
    %Fin de PROCESAMIENTO

    %POSPROCESAMIENTO
    % Calculando reacciones
    R = K*u;
    %disp(R(DOFr))
    %Graficar nodos
    plot3(XY(:,1),XY(:,2),XY(:,3),'r.');  %Siempre se puede usar para verificar si se
                                  % ponen bien los nodos.
    hold on   %Se deja activa la ventana de graficacion para imprimir los elementos
    %Graficar los elementos
    for    i=1:elem
        X_p = [XY(md(i,1),1), XY(md(i,2),1)]; 
        Y_p = [XY(md(i,1),2), XY(md(i,2),2)];
        Z_p = [XY(md(i,1),3), XY(md(i,2),3)];
        plot3 (X_p,Y_p,Z_p,'Color','k','LineWidth',0.1,'LineStyle','-.');
       hold on 
    end
    axis equal

    %Numero de Nodos
    nod = nonod;
    %Reacomodando vector de desplazamientos acorde a las dimensiones de XY
    u_v =reshape(u,[3,nod]);
    u_v = u_v';
    %Escala la figura deformada 
    %escala = 1; 
    escala =str2double(get(handles.Escala,'String'));
    %Realiza la suma directa
    XYd = XY + escala*u_v; 

    %Esfuerzos
    sigma=zeros(elem,1);
    for i=1:elem
        sigma(i)=(E(i)/L(i))*[-l(i) -m(i) -n(i) l(i) m(i) n(i)]*(u([MD(i,1) MD(i,2) MD(i,3) MD(i,4) MD(i,5) MD(i,6)]));
    end

    %Grafica los elementos deformados 
    for i=1:elem
        X_pd = [XYd(md(i,1),1), XYd(md(i,2),1)]; 
        Y_pd = [XYd(md(i,1),2), XYd(md(i,2),2)];
        Z_pd = [XYd(md(i,1),3), XYd(md(i,2),3)];
        patch(X_pd,Y_pd,Z_pd,[0 1],'FaceVertexCData', [sigma(i);sigma(i)],'EdgeColor', 'interp','LineWidth',4,'LineStyle','-')
        Xmid = (XYd(md(i,1),1)+ XYd(md(i,2),1))/2;
        Ymid = (XYd(md(i,1),2)+ XYd(md(i,2),2))/2;
        Zmid = (XYd(md(i,1),3)+ XYd(md(i,2),3))/2;
        text(Xmid+2,Ymid+2,Zmid+2,num2str(i));
        hold on 
    end
    grid minor
    
    %POSPROCESAMIENTO fin
    %colormap(hsv)
    colormap(jet)
    colorbar
    caxis([min(sigma) max(sigma)])
    
    CriterioFalla = str2double(get(handles.CriterioFalla,'String'));
    if CriterioFalla >= max(sigma)
        str = 'No failure';
        set(handles.Falla,'String',str)
        set(handles.Falla,'BackgroundColor','g')
    else
        str = 'Failure';
        set(handles.Falla,'String',str)
        set(handles.Falla,'BackgroundColor','r')
    end
    
    set(handles.Reacciones,'Data',R(DOFr))
    set(handles.Desplazamientos,'Data',u)
    set(handles.Esfuerzos,'Data',sigma)
    %Fin de programa
    
    handles.elem = elem;
    handles.md = md;
    handles.XYd = XYd;
    guidata(hObject, handles);
end

function Escala_Callback(hObject, eventdata, handles)
Calcular_Callback(hObject, eventdata, handles)

function Escala_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
close(SemanaiGUITest);
run('TrussAnalizer');

function info_Callback(hObject, eventdata, handles)
run('Members');

function CriterioFalla_Callback(hObject, eventdata, handles)
function CriterioFalla_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function comboNodes_Callback(hObject, eventdata, handles)
function comboNodes_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------%
%---------------------------Forces Setup----------------------------------%
%-------------------------------------------------------------------------%
function btnAddForce_Callback(hObject, eventdata, handles)
ResetForces(hObject, handles)
set(handles.btnForceDraw,'Enable','on')
set(handles.comboNodes,'Enable','on')
set(handles.comboForces,'Enable','off')
set(handles.ForceX,'Enable','on')
set(handles.ForceY,'Enable','on')
set(handles.ForceZ,'Enable','on')
set(handles.editForceMagnitude,'Enable','on')

function btnEditForce_Callback(hObject, eventdata, handles)
set(handles.btnChangeForce,'Enable','on')
set(handles.btnAddForce,'Enable','off')
set(handles.btnRemoveForce,'Enable','off')
set(handles.comboForces,'Enable','off')
set(handles.editForceMagnitude,'Enable','on')
set(handles.ForceX,'Enable','on')
set(handles.ForceY,'Enable','on')
set(handles.ForceZ,'Enable','on')
set(handles.comboNodes,'Enable','on')

function btnChangeForce_Callback(hObject, eventdata, handles)
ForcesData = handles.ForcesData;
ForceID = get(handles.comboForces,'Value');
ForceMagnitude = str2double(get(handles.editForceMagnitude,'String'));
NodeNum = get(handles.comboNodes,'Value');
if isnan(ForceMagnitude)
    msgbox('La magnitud de la fuerza debe ser un número')
    set(handles.editForceMagnitude,'String','')
else
    Xval = get(handles.ForceX,'Value');
    Yval = get(handles.ForceY,'Value');
    Zval = get(handles.ForceZ,'Value');
    repeat = 0;
    OrgForce = ForcesData(ForceID,:);
    ForcesData(ForceID,:) = zeros(1,5);
    for i = 1:size(ForcesData,1)
        if ForcesData(i,1) == NodeNum & ForcesData(i,[3,4,5]) == [Xval, Yval, Zval]
            msgbox('Ya existe una fuerza en esa dirección')
            ForcesData(ForceID,:) = OrgForce;
            handles.ForcesData = ForcesData;
            guidata(hObject, handles)
            repeat = 1;
        end
    end
    if repeat == 0
        ChangedForceData = [NodeNum, ForceMagnitude, Xval, Yval, Zval];
        ForcesData(ForceID,:) = ChangedForceData;
        handles.ForcesData = ForcesData;
        guidata(hObject, handles)
        ForcesVector(hObject, handles)
        ResetAllForces(hObject,handles)
    end 
end

function editForceMagnitude_Callback(hObject, eventdata, handles)
function editForceMagnitude_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function btnForceDraw_Callback(hObject, eventdata, handles)
ForceMagnitude = str2double(get(handles.editForceMagnitude,'String'));
NodeNum = get(handles.comboNodes,'Value');
if isnan(ForceMagnitude)
    msgbox('Magnitude must be a numbre')
    set(handles.editForceMagnitude,'String','')
else
    Xval = get(handles.ForceX,'Value');
    Yval = get(handles.ForceY,'Value');
    Zval = get(handles.ForceZ,'Value');
    if Xval == 0 && Yval == 0 && Zval == 0
        msgbox('Direction must be specified')
    else
        %---------Forces Data-----------
        ForcesCount = handles.ForcesCount;
        ForcesData = handles.ForcesData;
        NumForces = handles.NumForces;
        if size(ForcesData,1) == 0
            ForcesData(ForcesCount,:) = [NodeNum, ForceMagnitude, Xval, Yval, Zval];
            NumForces{end+1} = ['Force ',num2str(ForcesCount)];
        else
            repeat = 0;
            for i = 1: size(ForcesData,1)
                if ForcesData(i,[1,3,4,5]) == [NodeNum, Xval, Yval, Zval]
                    msgbox('A force already exist in that direction')
                    ForcesCount = ForcesCount - 1;
                    repeat = 1;
                end
            end
            if repeat == 0
                ForcesData(ForcesCount,:) = [NodeNum, ForceMagnitude, Xval, Yval, Zval];
                NumForces{end+1} = ['Force ',num2str(ForcesCount)];
            end
        end
        ForcesCount = ForcesCount + 1;
        handles.ForcesCount = ForcesCount;
        handles.ForcesData = ForcesData;
        handles.NumForces = NumForces;
        set(handles.comboForces,'String',NumForces)
        handles.NodeNum = NodeNum;
        guidata(hObject, handles)
        ResetAllForces(hObject,handles)
    end
end
ForcesVector(hObject, handles)

function ForcesVector(hObject, handles)
ForcesData = handles.ForcesData;
fp = zeros(size(handles.Nodes,2)*3,1);
for i = 1: size(ForcesData,1)
    NodeNum = ForcesData(i,1);
    ForceMagnitude = ForcesData(i,2);
    %fp = handles.fp;
    if ForcesData(i,3) == 1
        GDL = 3*NodeNum-2;
    elseif ForcesData(i,4) == 1
        GDL = 3*NodeNum-1;
    elseif ForcesData(i,5) == 1
        GDL = 3*NodeNum;
    end
    %ContF = str2double(get(handles.ContF,'String'));
    ContF = handles.ForcesCount;
    if fp(GDL) == 0
        fp(GDL) = ForceMagnitude;
        ContF = ContF +1;
        %set(handles.ContF,'String',ContF);
    end
    fp(GDL) = ForceMagnitude;
    handles.fp = fp;
    set(handles.MatFuerzas,'Data',fp)
    guidata(hObject, handles);
end

function btnRemoveForce_Callback(hObject, eventdata, handles)
set(handles.btnRemoveForce,'Enable','off')
set(handles.btnEditForce,'Enable','off')
NumForces = {};
ForcesData = handles.ForcesData;
EmptyForce = ForcesData;
ForceID = get(handles.comboForces,'Value');
ForcesData(ForceID,:) = [];
if isempty(ForcesData)
    set(handles.comboForces,'String', '- Add force -')
    EmptyForce(1,2) = 0;
    ForcesData = EmptyForce;
    ResetForces(hObject, handles)
else
    for i = 1 : size(ForcesData,1)
        NumForces{end+1} = ['Force ',num2str(i)];
    end
    set(handles.comboForces,'String',NumForces)
    ResetForces(hObject, handles)
end
ForcesCount = handles.ForcesCount - 1;
handles.ForcesData = ForcesData;
handles.NumForces = NumForces;
handles.ForcesCount = ForcesCount;
guidata(hObject, handles);
ForcesVector(hObject, handles)

%Forces Dimensions%
function ForceX_Callback(hObject, eventdata, handles)
set(handles.ForceY,'Value',0)
set(handles.ForceZ,'Value',0)
function ForceY_Callback(hObject, eventdata, handles)
set(handles.ForceX,'Value',0)
set(handles.ForceZ,'Value',0)
function ForceZ_Callback(hObject, eventdata, handles)
set(handles.ForceX,'Value',0)
set(handles.ForceY,'Value',0)

%Reset Forces%
function ResetForces(hObject, handles)
set(handles.editForceMagnitude,'String','')
set(handles.ForceX,'Value',0)
set(handles.ForceY,'Value',0)
set(handles.ForceZ,'Value',0)
set(handles.comboForces,'Value',1)
set(handles.btnRemoveForce,'Enable','off')
set(handles.btnEditForce,'Enable','off')

%Reset All Forces%
function ResetAllForces(hObject, handles)
set(handles.btnForceDraw,'Enable','off')
set(handles.btnChangeForce,'Enable','off')
set(handles.comboNodes,'Enable','off')
set(handles.ForceX,'Enable','off')
set(handles.ForceY,'Enable','off')
set(handles.ForceZ,'Enable','off')
set(handles.editForceMagnitude,'Enable','off')
set(handles.editForceMagnitude,'String','')
set(handles.ForceX,'Value',0)
set(handles.ForceY,'Value',0)
set(handles.ForceZ,'Value',0)
set(handles.comboForces,'Enable','on')
set(handles.btnAddForce,'Enable','on')
set(handles.btnEditForce,'Enable','off')

%Forces Popup Menu%
function comboForces_Callback(hObject, eventdata, handles)
warning = {get(handles.comboForces,'String')};
if strcmp(warning{1,1},'- Add force -')
    msgbox('Add forces first')
else
    ForceVal = get(handles.comboForces,'Value');
    Xval = handles.ForcesData(ForceVal,3);
    Yval = handles.ForcesData(ForceVal,4);
    Zval = handles.ForcesData(ForceVal,5);
    if Xval == 1
        set(handles.ForceX,'Value',1)
        set(handles.ForceY,'Value',0)
        set(handles.ForceZ,'Value',0)
    elseif Yval == 1
        set(handles.ForceX,'Value',0)
        set(handles.ForceY,'Value',1)
        set(handles.ForceZ,'Value',0)
    elseif Zval == 1
        set(handles.ForceX,'Value',0)
        set(handles.ForceY,'Value',0)
        set(handles.ForceZ,'Value',1)
    end
    set(handles.editForceMagnitude,'String',num2str(handles.ForcesData(ForceVal,2)))
    set(handles.comboNodes,'Value',handles.ForcesData(ForceVal,1))
    set(handles.btnRemoveForce,'Enable','on')
    set(handles.btnEditForce,'Enable','on')
end
function comboForces_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function MatFuerzas_CellEditCallback(hObject, eventdata, handles)

function btnAddFixedNode_Callback(hObject, eventdata, handles)
ResetNodes(hObject, handles)
set(handles.comboNodesF,'Enable','on')
set(handles.comboFixedNodes,'Enable','off')
set(handles.btnFixedNodeDraw,'Enable','on')
set(handles.FixedX,'Enable','on')
set(handles.FixedY,'Enable','on')
set(handles.FixedZ,'Enable','on')

function btnRemoveFixedNode_Callback(hObject, eventdata, handles)
set(handles.btnRemoveFixedNode,'Enable','off')
set(handles.btnEditFixedNode,'Enable','off')
NumFixedNodes = {};
FixedNodesData = handles.FixedNodesData;
EmptyNode = FixedNodesData;
NodeID = get(handles.comboFixedNodes,'Value');
FixedNodesData(NodeID,:) = [];
if isempty(FixedNodesData)
    set(handles.comboFixedNodes,'String', '- Add restriction -')
    FixedNodesData = [];
    ResetNodes(hObject, handles)
else
    for i = 1 : size(FixedNodesData,1)
        NumFixedNodes{end+1} = ['Restriction ',num2str(i)];
    end
    set(handles.comboFixedNodes,'String',NumFixedNodes)
    ResetNodes(hObject, handles)
end
FixedNodesCount = handles.FixedNodesCount - 1;
handles.FixedNodesData = FixedNodesData;
handles.NumFixedNodes = NumFixedNodes;
handles.FixedNodesCount = FixedNodesCount;
DOFr = [];
for i = 1:size(FixedNodesData,1)
    DOFr = [DOFr,[(3*FixedNodesData(i,1)-2)*FixedNodesData(i,2),(3*FixedNodesData(i,1)-1)*FixedNodesData(i,3),(3*FixedNodesData(i,1))*FixedNodesData(i,4)]];
end
DOFr = sort(DOFr);
DOFr = unique(DOFr);
DOFr(DOFr == 0) = [];
handles.DOFr = DOFr;
%disp(FixedNodesData)
%disp(DOFr)
guidata(hObject, handles);

function btnEditFixedNode_Callback(hObject, eventdata, handles)
set(handles.btnAddFixedNode,'Enable','off')
set(handles.btnRemoveFixedNode,'Enable','off')
set(handles.comboNodesF,'Enable','off')
set(handles.comboFixedNodes,'Enable','off')
set(handles.btnFixedNodeDraw,'Enable','off')
set(handles.btnChangeFixedNode,'Enable','on')
set(handles.FixedX,'Enable','on')
set(handles.FixedY,'Enable','on')
set(handles.FixedZ,'Enable','on')
set(handles.comboNodesF,'Enable','on')

function btnFixedNodeDraw_Callback(hObject, eventdata, handles)
NodoR = get(handles.comboNodesF, 'Value');
x = get(handles.FixedX,'Value');
y = get(handles.FixedY,'Value');
z = get(handles.FixedZ,'Value');
if x == 0 && y == 0 && z == 0
    msgbox('Restrict at least one DOF')
else
    DOFr = handles.DOFr;
    if x == 1
        GDL = 3*NodoR - 2;
        DOFr(end+1) = GDL;
    end
    if y == 1
        GDL = 3*NodoR - 1;
        DOFr(end+1) = GDL;
    end
    if z == 1
        GDL = 3*NodoR;
        DOFr(end+1) = GDL;
    end
    DOFr = sort(DOFr);
    DOFr = unique(DOFr);
    FixedNodesData = handles.FixedNodesData;
    FixedNodesCount = handles.FixedNodesCount;
    NumFixedNodes = handles.NumFixedNodes;
    if size(FixedNodesData,1) == 0
        FixedNodesData(FixedNodesCount,:) = [NodoR, x, y, z];
        NumFixedNodes{end+1} = ['Restriction ', num2str(FixedNodesCount)];
    else
        repeat = 0;
        for i = 1: size(FixedNodesData,1)
            if FixedNodesData(i,1) == [NodoR]
                msgbox(['Node ', num2str(NodoR),' is already restricted'])
                FixedNodesCount = FixedNodesCount - 1;
                repeat = 1;
            end
        end
        if repeat == 0
            FixedNodesData(FixedNodesCount,:) = [NodoR, x, y, z];
            NumFixedNodes{end+1} = ['Restriction ', num2str(FixedNodesCount)];
        end
    end
    FixedNodesCount = FixedNodesCount+1;
    set(handles.comboFixedNodes,'String',NumFixedNodes)
    handles.DOFr = DOFr;
    handles.FixedNodesData = FixedNodesData;
    handles.FixedNodesCount = FixedNodesCount;
    handles.NumFixedNodes = NumFixedNodes;
    guidata(hObject, handles);
    ResetAllFixedNodes(hObject, handles)
%     disp(DOFr)
%     disp(FixedNodesData)
end

function comboFixedNodes_Callback(hObject, eventdata, handles)
warning = {get(handles.comboFixedNodes,'String')};
if strcmp(warning{1,1},'- Add restriction -')
    msgbox('Add restrictions first')
else
    FixedNodesData = handles.FixedNodesData;
    NodeID = get(handles.comboFixedNodes,'Value');
    set(handles.comboNodesF,'Value',FixedNodesData(NodeID,1))
    set(handles.FixedX,'Value',FixedNodesData(NodeID,2))
    set(handles.FixedY,'Value',FixedNodesData(NodeID,3))
    set(handles.FixedZ,'Value',FixedNodesData(NodeID,4))
    set(handles.btnRemoveFixedNode,'Enable','on')
    set(handles.btnEditFixedNode,'Enable','on')
    set(handles.btnFixedNodeDraw,'Enable','off')
end

function comboFixedNodes_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function btnChangeFixedNode_Callback(hObject, eventdata, handles)
FixedNodesData = handles.FixedNodesData;
NodeID = get(handles.comboFixedNodes,'Value');
Node = get(handles.comboNodesF,'Value');
FixedX = get(handles.FixedX,'Value');
FixedY = get(handles.FixedY,'Value');
FixedZ = get(handles.FixedZ,'Value');
repeat = 0;
ChangedFixedNode = [Node, FixedX, FixedY, FixedZ];
for i = 1:size(FixedNodesData,1)
    if FixedNodesData(i,:) == ChangedFixedNode
        msgbox('That restriction already exists')
        repeat = 1;
    end
end
if repeat == 0
    if FixedX == 0 && FixedY == 0 && FixedZ == 0
        msgbox('At least one DOF must be restricted')
    else
        FixedNodesData(NodeID,:) = ChangedFixedNode;
        handles.FixedNodesData = FixedNodesData;
        DOFr = [];
        for i = 1:size(FixedNodesData,1)
            DOFr = [DOFr,[(3*FixedNodesData(i,1)-2)*FixedNodesData(i,2),(3*FixedNodesData(i,1)-1)*FixedNodesData(i,3),(3*FixedNodesData(i,1))*FixedNodesData(i,4)]];
        end
        DOFr = sort(DOFr);
        DOFr = unique(DOFr);
        DOFr(DOFr == 0) = [];
        %disp(DOFr)
        handles.DOFr = DOFr;
        guidata(hObject, handles)
        ResetAllFixedNodes(hObject,handles)
    end
end
%handles.FixedNodesData = FixedNodesData;
%guidata(hObject, handles)
%disp(FixedNodesData)

function FixedX_Callback(hObject, eventdata, handles)
function FixedY_Callback(hObject, eventdata, handles)
function FixedZ_Callback(hObject, eventdata, handles)

function ResetAllFixedNodes(hObject, handles)
set(handles.btnAddFixedNode,'Enable','on')
set(handles.btnRemoveFixedNode,'Enable','off')
set(handles.btnEditFixedNode,'Enable','off')
set(handles.comboNodesF,'Enable','off')
set(handles.comboFixedNodes,'Enable','on')
set(handles.btnFixedNodeDraw,'Enable','off')
set(handles.btnChangeFixedNode,'Enable','off')
set(handles.FixedX,'Enable','off')
set(handles.FixedY,'Enable','off')
set(handles.FixedZ,'Enable','off')
%set(handles.FixedX,'Value',0)
%set(handles.FixedY,'Value',0)
%set(handles.FixedZ,'Value',0)

function comboNodesF_Callback(hObject, eventdata, handles)
function comboNodesF_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ResetNodes(hObject, handles)
set(handles.comboFixedNodes,'Value',1)
set(handles.btnFixedNodeDraw,'Enable','on')
set(handles.btnRemoveFixedNode,'Enable','off')

function btnFixedNodeDraw_CreateFcn(hObject, eventdata, handles)

% --- Executes on button press in FitAxis.
function FitAxis_Callback(hObject, eventdata, handles)
    XY = handles.XY;
    xmin = min(XY(:,1));
    xmax = max(XY(:,1));
    ymin = min(XY(:,2));
    ymax = max(XY(:,2));
    zmin = min(XY(:,3));
    zmax = max(XY(:,3)); 
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

function editXMin_Callback(hObject, eventdata, handles)
    val = str2double(get(handles.editXMin,'String'));
    if val >= handles.xmax 
        msgbox('X min must be less than X max');
        set(set(handles.editXMin,'String',handles.xmin));
    else
        if isnan(val)
            msgbox('X min must be a number');
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
        msgbox('X max must be greater than X min');
        set(set(handles.editXMax,'String',handles.xmax))
    else
        if isnan(val)
            msgbox('X min must be a number');
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
        msgbox('Y min must be less than Y max');
        set(set(handles.editYMin,'String',handles.ymin));
    else
        if isnan(val)
            msgbox('Y min must be a number');
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
        msgbox('Y max must be greater than Y min');
        set(set(handles.editYMax,'String',handles.ymax))
    else
        if isnan(val)
            msgbox('Y max must be a number');
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
        msgbox('Z min must be less than Z max');
        set(set(handles.editZMin,'String',handles.zmin));
    else
        if isnan(val)
            msgbox('Z min must be a number');
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
        msgbox('Z max must be greater than Z min');
        set(set(handles.editZMax,'String',handles.zmax))
    else
        if isnan(val)
            msgbox('Z max must be a number');
            set(set(handles.editZMax,'String',handles.zmax))
        else
            zlim([handles.zmin, val])
            handles.zmax = val;
            guidata(hObject, handles);
        end
    end
function editXMin_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editXMax_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editYMin_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editYMax_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editZMin_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editZMax_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
