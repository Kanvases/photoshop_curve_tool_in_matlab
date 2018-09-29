function varargout = MAIN_MouseAdjust(varargin)
% MAIN_MOUSEADJUST MATLAB code for MAIN_MouseAdjust.fig
%      MAIN_MOUSEADJUST, by itself, creates a new MAIN_MOUSEADJUST or raises the existing
%      singleton*.
%
%      H = MAIN_MOUSEADJUST returns the handle to a new MAIN_MOUSEADJUST or the handle to
%      the existing singleton*.
%
%      MAIN_MOUSEADJUST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_MOUSEADJUST.M with the given input arguments.
%
%      MAIN_MOUSEADJUST('Property','Value',...) creates a new MAIN_MOUSEADJUST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MAIN_MouseAdjust_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MAIN_MouseAdjust_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MAIN_MouseAdjust

% Last Modified by GUIDE v2.5 29-Sep-2018 15:44:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MAIN_MouseAdjust_OpeningFcn, ...
                   'gui_OutputFcn',  @MAIN_MouseAdjust_OutputFcn, ...
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


% --- Executes just before MAIN_MouseAdjust is made visible.
function MAIN_MouseAdjust_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MAIN_MouseAdjust (see VARARGIN)

% Choose default command line output for MAIN_MouseAdjust
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MAIN_MouseAdjust wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global points
points(1,1:2)=0.0;
points(2,1:2)=0.25;
points(3,1:2)=0.5;
points(4,1:2)=0.75;
points(5,1:2)=1;
axes(handles.axes1);
p1 =  polyfit(points(:,1), points(:,2), 3);
x=0:0.01:1;
y = polyval(p1, x); 
plot(x, y, '-', points(:,1),points(:,2),'b*') 
global idx
idx=0;

% --- Outputs from this function are returned to the command line.
function varargout = MAIN_MouseAdjust_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Browse_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile({'*.*';'*.jpg';'*.png'},'Choose Image');
Img=imread([pathname filename]);
axes(handles.axes2);
imshow(Img);
axes(handles.axes3);
histogram(Img);
global ImgOri
ImgOri=Img;
handles.ImgOri=Img;
guidata(hObject,handles);
set(gcbf,'WindowButtonDownFcn',@MouseDown);

% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function MouseDown(~,~)
set(gcbf,'WindowButtonMotionFcn',@MouseMoving);
set(gcbf,'WindowButtonUpFcn',@MouseUp);

function MouseUp(~,~)
set(gcbf,'WindowButtonMotionFcn','');
set(gcbf,'WindowButtonUpFcn','');
global idx
global points
idx=0;
handles=guidata(gcbo);
global ImgOri
[~,~,c]=size(ImgOri);
ImgRes=double(ImgOri)./256;
global myPlot
for cc=1:c
    ImgRes(:,:,cc)=polyval(myPlot,ImgRes(:,:,cc)); 
end

axes(handles.axes2);
ImgRes=uint8(ImgRes.*256);
imshow(ImgRes)
axes(handles.axes3);
histogram(ImgRes);

function MouseMoving(~,~)
handles=guidata(gcbo);
curtP=get(gca,'CurrentPoint');
curtP(curtP>1)=1;
curtP(curtP<0)=0;
x=curtP(1,1);
y=curtP(1,2);
global points
global idx
if(idx==0)
    dis=(points(:,1)-x).^2+(points(:,2)-y).^2;
    idx=find(dis==min(dis));
end
points(idx,1)=x;
points(idx,2)=y;
p1 =  polyfit(points(:,1), points(:,2), 4);
global myPlot
myPlot=p1;

x=0:0.05:1;
y = polyval(p1, x); 
y(y>1)=1;
y(y<0)=0;
axes(handles.axes1);
plot(x, y, '-', points(:,1),points(:,2),'b*');





% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
