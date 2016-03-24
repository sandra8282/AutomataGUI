function varargout = AutomataGUI(varargin)
% AUTOMATAGUI MATLAB code for AutomataGUI.fig
%      AUTOMATAGUI, by itself, creates a new AUTOMATAGUI or raises the existing
%      singleton*.
%
%      H = AUTOMATAGUI returns the handle to a new AUTOMATAGUI or the handle to
%      the existing singleton*.
%
%      AUTOMATAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUTOMATAGUI.M with the given input arguments.
%
%      AUTOMATAGUI('Property','Value',...) creates a new AUTOMATAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AutomataGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AutomataGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AutomataGUI

% Last Modified by GUIDE v2.5 04-Mar-2016 10:09:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AutomataGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @AutomataGUI_OutputFcn, ...
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


% --- Executes just before AutomataGUI is made visible.
function AutomataGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AutomataGUI (see VARARGIN)

% Choose default command line output for AutomataGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AutomataGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = AutomataGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;








% --- Executes on button press in pushbuttonSIM.
function pushbuttonSIM_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSIM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% GET INPUT FROM USER
%figstatus =get(handles.FigStatus,'Value');
ProbEmpty = str2num(get(handles.EdtProbEmpty,'String'));
ProbProd = str2num(get(handles.EdtProbProd,'String'));
ProbRes = str2num(get(handles.EdtProbRes,'String'));
ProbSus = str2num(get(handles.EdtProbSus,'String'));
RProbEmpty=get(handles.RadioProbEmpty,'Value');
RProbProd=get(handles.RadioProbProd,'Value');
RProbRes=get(handles.RadioProbRes,'Value');
RProbSus=get(handles.RadioProbSus,'Value');
if RProbEmpty==1
    ProbEmpty=1-ProbProd-ProbRes-ProbSus;
    assignin('base','ProbEmpty',ProbEmpty);
    set(handles.EdtProbEmpty,'String',num2str(ProbEmpty));
elseif RProbProd==1
    ProbProd=1-ProbEmpty-ProbRes-ProbSus;
    assignin('base','ProbProd',ProbProd);
    set(handles.EdtProbProd,'String',num2str(ProbProd));
elseif RProbRes==1
    ProbRes=1-ProbEmpty-ProbProd-ProbSus;
    assignin('base','ProbRes',ProbRes);
    set(handles.EdtProbRes,'String',num2str(ProbRes));
elseif RProbSus==1
    ProbSus=1-ProbEmpty-ProbProd-ProbRes;
    assignin('base','ProbSus',ProbSus);
    set(handles.EdtProbSus,'String',num2str(ProbSus));
end

b1=str2num(get(handles.parasiteB,'String'));
b2=str2num(get(handles.forbeB,'String'));
b3=str2num(get(handles.grassB,'String'));

TimeStep=.01;                      % dt: Time step width
Width=150;                       % Width of lattice
BirthRate=[b1,b2,b3];         % BirthRate: due to array indexing issue,
                             % BirthRate(i) denotes birth probability of strain (i+1)
DeathRate = str2num(get(handles.deathR,'String'));               % DeathRate: assumed constant for all strains
SeedRadius = str2num(get(handles.dispRad,'String'));             % SeedRadius: denotes radius seeds are dispersed to
ColStrength = str2num(get(handles.parStrength,'String'));             % ColStrength: Proportionality constant for impact of colicin-
                             % producing strain on colicin-susceptible strain
NumTimeStep=20;                   % Step: Number of time steps to perform


Bound = true;
Cracks = false;
deadYet = false;

%L=InitSpiralGrid(Width,1,100,40);
L=InitGrid(ProbEmpty,ProbProd,ProbRes,ProbSus,Bound,Cracks,Width); 
Time = [TimeStep:TimeStep:TimeStep * NumTimeStep];

PopCount = zeros(NumTimeStep, 5);
Inhomogeneity = zeros(NumTimeStep, 1);

if Bound == true
mymap = [1  1   1
    1 0 0
    0 1 0
    0 0 1
    0 0 0];
else 
  mymap = [1  1   1
    1 0 0
    0 1 0
    0 0 1];  
end

colormap(mymap);

% i=1;
% while ((i <= NumTimeStep)&&(num2str(get(handles.FigStatus,'String'))==1))
for i=1:NumTimeStep
    figstatus=num2str(get(handles.FigStatus,'String'))
   if figstatus~=0
    DisplayGrid(L);
    %if mod(i,100)==0
        %imagesc(L);
        %drawnow
        %saveas(gcf,num2str(i),'png');
    %end
    %i
    L = NewState(L, TimeStep, DeathRate, BirthRate, SeedRadius, ColStrength);
    [PopCount(i, :), Inhomogeneity(i)] = LatticeData(L);    
    if (deadYet == false)
        for j = 2:4
            if PopCount(i,j) == 0
                deadYet = true;
                deadTime = i * TimeStep;
            end
        end
    end
    %i=i+1;
   end 
end

figure(2);
plot(Time, PopCount');
legend('Empty','Parasitic Plant','Forbe','Grass')



function EdtProbSus_Callback(hObject, eventdata, handles)
% hObject    handle to EdtProbSus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EdtProbSus as text
%        str2double(get(hObject,'String')) returns contents of EdtProbSus as a double


% --- Executes during object creation, after setting all properties.
function EdtProbSus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EdtProbSus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EdtProbRes_Callback(hObject, eventdata, handles)
% hObject    handle to EdtProbRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EdtProbRes as text
%        str2double(get(hObject,'String')) returns contents of EdtProbRes as a double


% --- Executes during object creation, after setting all properties.
function EdtProbRes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EdtProbRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EdtProbProd_Callback(hObject, eventdata, handles)
% hObject    handle to EdtProbProd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EdtProbProd as text
%        str2double(get(hObject,'String')) returns contents of EdtProbProd as a double


% --- Executes during object creation, after setting all properties.
function EdtProbProd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EdtProbProd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EdtProbEmpty_Callback(hObject, eventdata, handles)
% hObject    handle to EdtProbEmpty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of EdtProbEmpty as text
%        str2double(get(hObject,'String')) returns contents of EdtProbEmpty as a double


% --- Executes during object creation, after setting all properties.
function EdtProbEmpty_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EdtProbEmpty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EdtBRsus_Callback(hObject, eventdata, handles)
% hObject    handle to EdtBRsus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of EdtBRsus as text
%        str2double(get(hObject,'String')) returns contents of EdtBRsus as a double
slideVal = get(handles.EdtBRsus,'Value');
assignin('base','slideVal',slideVal);
set(handles.grassB,'String',num2str(slideVal));


% --- Executes during object creation, after setting all properties.
function EdtBRsus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EdtBRsus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EdtBRres_Callback(hObject, eventdata, handles)
% hObject    handle to EdtBRres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of EdtBRres as text
%        str2double(get(hObject,'String')) returns contents of EdtBRres as a double
slideVal = get(handles.EdtBRres,'Value');
assignin('base','slideVal',slideVal);
set(handles.forbeB,'String',num2str(slideVal));

% --- Executes during object creation, after setting all properties.
function EdtBRres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EdtBRres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EdtBRprod_Callback(hObject, eventdata, handles)
% hObject    handle to EdtBRprod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of EdtBRprod as text
%        str2double(get(hObject,'String')) returns contents of EdtBRprod as a double
slideVal = get(handles.EdtBRprod,'Value');
assignin('base','slideVal',slideVal);
set(handles.parasiteB,'String',num2str(slideVal));

% --- Executes during object creation, after setting all properties.
function EdtBRprod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EdtBRprod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EdtDR_Callback(hObject, eventdata, handles)
% hObject    handle to EdtDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EdtDR as text
%        str2double(get(hObject,'String')) returns contents of EdtDR as a double
slideVal = get(handles.EdtDR,'Value');
assignin('base','slideVal',slideVal);
set(handles.deathR,'String',num2str(slideVal));

% --- Executes during object creation, after setting all properties.
function EdtDR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EdtDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EdtDisp_Callback(hObject, eventdata, handles)
% hObject    handle to EdtDisp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EdtDisp as text
%        str2double(get(hObject,'String')) returns contents of EdtDisp as a double
slideVal = get(handles.EdtDisp,'Value');
assignin('base','slideVal',slideVal);
set(handles.dispRad,'String',num2str(slideVal));

% --- Executes during object creation, after setting all properties.
function EdtDisp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EdtDisp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EdtPS_Callback(hObject, eventdata, handles)
% hObject    handle to EdtPS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EdtPS as text
%        str2double(get(hObject,'String')) returns contents of EdtPS as a double
slideVal = get(handles.EdtPS,'Value');
assignin('base','slideVal',slideVal);
set(handles.parStrength,'String',num2str(slideVal));



% --- Executes during object creation, after setting all properties.
function EdtPS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EdtPS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in RadioProbSus.
function RadioProbSus_Callback(hObject, eventdata, handles)
% hObject    handle to RadioProbSus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioProbSus


% --- Executes on button press in RadioProbRes.
function RadioProbRes_Callback(hObject, eventdata, handles)
% hObject    handle to RadioProbRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioProbRes


% --- Executes on button press in RadioProbProd.
function RadioProbProd_Callback(hObject, eventdata, handles)
% hObject    handle to RadioProbProd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioProbProd


% --- Executes on button press in RadioProbEmpty.
function RadioProbEmpty_Callback(hObject, eventdata, handles)
% hObject    handle to RadioProbEmpty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioProbEmpty


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
figstatus=0; 
assignin('base','figstatus',figstatus);
set(handles.FigStatus,'String',num2str(figstatus));
    
    
delete(hObject);


% --- Executes on button press in FigStatus.
function FigStatus_Callback(hObject, eventdata, handles)
% hObject    handle to FigStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FigStatus
