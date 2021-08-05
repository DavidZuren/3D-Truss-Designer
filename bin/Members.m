function varargout = Members(varargin)
% MEMBERS MATLAB code for Members.fig
%      MEMBERS, by itself, creates a new MEMBERS or raises the existing
%      singleton*.
%
%      H = MEMBERS returns the handle to a new MEMBERS or the handle to
%      the existing singleton*.
%
%      MEMBERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MEMBERS.M with the given input arguments.
%
%      MEMBERS('Property','Value',...) creates a new MEMBERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Members_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Members_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Members

% Last Modified by GUIDE v2.5 12-Jun-2021 22:05:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Members_OpeningFcn, ...
                   'gui_OutputFcn',  @Members_OutputFcn, ...
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


% --- Executes just before Members is made visible.
function Members_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Members (see VARARGIN)

pwd;
currentFolder = pwd;
str = '\icons\tecLogo2.jpg';
Folder = strcat(currentFolder, str);
set(handles.Tec,'cdata',imread(Folder))

% Choose default command line output for Members
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Members wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Members_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Tec.
function Tec_Callback(hObject, eventdata, handles)
% hObject    handle to Tec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
