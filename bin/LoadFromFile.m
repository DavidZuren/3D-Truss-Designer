function varargout = LoadFromFile(varargin)
% LOADFROMFILE MATLAB code for LoadFromFile.fig
%      LOADFROMFILE, by itself, creates a new LOADFROMFILE or raises the existing
%      singleton*.
%
%      H = LOADFROMFILE returns the handle to a new LOADFROMFILE or the handle to
%      the existing singleton*.
%
%      LOADFROMFILE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOADFROMFILE.M with the given input arguments.
%
%      LOADFROMFILE('Property','Value',...) creates a new LOADFROMFILE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LoadFromFile_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LoadFromFile_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LoadFromFile

% Last Modified by GUIDE v2.5 24-Sep-2018 19:29:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LoadFromFile_OpeningFcn, ...
                   'gui_OutputFcn',  @LoadFromFile_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before LoadFromFile is made visible.
function LoadFromFile_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LoadFromFile (see VARARGIN)

% Choose default command line output for LoadFromFile
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LoadFromFile wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LoadFromFile_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function btnNodes_Callback(hObject, eventdata, handles)
    ReadNodes(hObject, handles);
    set(handles.btnConn, 'Enable', 'on');
function btnConn_Callback(hObject, eventdata, handles)
    ReadElems(hObject, handles);    
    handles = guidata(hObject);
    
    % obtain data stored in MAIN
    MAIN_data = guidata(handles.MAIN_H); 
    % update handles in MAIN
    MAIN_data.Nodes = handles.Nodes;
    MAIN_data.Conn = handles.Conn;   
        
    guidata(handles.MAIN_H, MAIN_data);
    
    %EnableDisableOptions(handles.MAIN_H,'on');
    if size(MAIN_data.Nodes,1) > 0
        set(findall(MAIN_data.btnRemoveNode, '-property', 'enable'), 'enable', 'on');
        set(findall(MAIN_data.btnEditNode, '-property', 'enable'), 'enable', 'on');
    end
    if size(MAIN_data.Nodes,1) > 1
        set(findall(MAIN_data.comboConn, '-property', 'enable'), 'enable', 'on');
        set(findall(MAIN_data.btnAddConn, '-property', 'enable'), 'enable', 'on');
        set(findall(MAIN_data.editNodeRadius, '-property', 'enable'), 'enable', 'on');        
    end
    if size(MAIN_data.Conn,1) > 1
        set(findall(MAIN_data.btnDeleteConn, '-property', 'enable'), 'enable', 'on');
        set(findall(MAIN_data.btnEditConn, '-property', 'enable'), 'enable', 'on');
        set(findall(MAIN_data.editConnRadius, '-property', 'enable'), 'enable', 'on'); 
    end
    close;
    FillComboNodesFromHandles(MAIN_data);
    FillComboConnFromHandles(MAIN_data);
    ReDraw(MAIN_data, 0, 0);

function figure1_CloseRequestFcn(hObject, eventdata, handles)
    if isfield(handles, 'MAIN_H')
        MAIN_data = guidata(handles.MAIN_H); 
        MAIN_data.IMPORT_H = [];   
        guidata(handles.MAIN_H, MAIN_data);
    end
    delete(hObject);

% --------------------------------------------------------------------
% Auxiliar Functions
% --------------------------------------------------------------------
function ReadNodes(hObject, handles)
    [FileName,PathName] = uigetfile('*.txt','Load Node file');
    nodesId = fopen(strcat(PathName, FileName), 'r');
    if nodesId ~= -1
        fgets(nodesId);  % Ignora la primera linea
        A = fscanf(nodesId, '%u %f %f %f \n', [4 inf]);
        handles.Nodes = (A(2:4, :))';
        fclose(nodesId);

        guidata(hObject, handles);
    end
function ReadElems(hObject, handles)
    [FileName,PathName] = uigetfile('*.txt','Load Connection file');
    elemsId = fopen(strcat(PathName, FileName), 'r');
    if elemsId ~= -1
        fgets(elemsId);  % Ignora la primera linea
        A = fscanf(elemsId, '%i %i %i \n', [3 inf]);
        handles.Conn = (A(2:3, :))';
        fclose(elemsId);        
                
        guidata(hObject, handles);
    end
