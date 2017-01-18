function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 14-Dec-2016 11:34:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

%Boolean which checks if a video is imported or not.
handles.vidimported = 0;

%Boolean which checks if the video is already running.
handles.running = 0;

%Number which keeps track of which frame was selected.
handles.frameselected = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in import_button.
function import_button_Callback(hObject, eventdata, handles)
% hObject    handle to import_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the file name and folder path.
[FileName,PathName,~] = uigetfile({'*.avi'}, 'Select video');

%Concatenate them to get the full file path
FullFileName = strcat(PathName, FileName);

%Reads the video selected.
vid = VideoReader(FullFileName);

%Store the VideoReader object so it can be used together with the
%startbutton
handles.vid = vid;

%Updates the imported video text:
set(handles.import_text, 'String', strcat('Video =',{' '}, FileName));

%Changes the boolean so that other buttons can be used.
handles.vidimported = 1;

%Update handles structure
guidata(hObject, handles);


% --- Executes on button press in play_button.
function play_button_Callback(hObject, eventdata, handles)
% hObject    handle to play_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Only play the video if one is imported.
if(handles.vidimported && ~handles.running)
    
    %Changed it so the file is running.
    handles.running = 1;
    
    %Update handles structure
    guidata(hObject, handles);
    
    %Get the videoreader object.
    vid = handles.vid;
    
    %Focus on the main video axes
    axes(handles.main_video)

    %Read the first frame
    frame = read(vid,1);

    %Display the video in the main view.
    image(frame);
    
    %Display the first frame from the start.
    set(handles.frame_text, 'String', strcat('Frame',{' '}, int2str(1), '/',int2str(vid.NumberOfFrames)));
    
    %Display the first frame in the table.
    set(handles.result_table, 'Data', [1, 1, vid.CurrentTime]);

    %For all the frames besides the first one
    for i=2:vid.NumberOfFrames
        
        %Get the frame
        frame = read(vid,i);
        
        %Display it in the main video axes
        h = get(handles.main_video, 'Children');
        set(h, 'CData', frame);
        
        %Display the amount of frames in the GUI
        set(handles.frame_text, 'String', strcat('Frame',{' '}, int2str(i), '/',int2str(vid.NumberOfFrames)));
        
        %The current table with all entries.
        current = get(handles.result_table, 'Data');
        
        %Add the new entry to the table.
        set(handles.result_table, 'Data', [current; 1, i, vid.CurrentTime]);
    end

    %The video is not running anymore after the loop.
    handles.running = 0;

    %Update handles structure
    guidata(hObject, handles);
    
    % Compare results
    results = get(handles.result_table, 'Data');
    resultsTable = {results(:,1), results(:,2), results(:,3)};
    checkSolution(resultsTable, 'trainingSolutions.mat')
end


% --- Executes on button press in step_button.
function step_button_Callback(hObject, eventdata, handles)
% hObject    handle to step_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in goto_button.
function goto_button_Callback(hObject, eventdata, handles)
% hObject    handle to goto_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Only play the video if one is imported.
if(handles.vidimported && ~handles.running)
    
    %Get the videoreader object.
    vid = handles.vid;
    
    %Get the framenumber specified in the edit box.
    framenumber = get(handles.edit_frame, 'String');

    %Parse the number to an integer.
    parsednumber = str2double(framenumber);

    %Get video frame
    frame = read(vid,parsednumber);
    
    %Display it in the main video axes
    h = get(handles.main_video, 'Children');
    set(h, 'CData', frame);
    
    %Display the amount of frames in the GUI
    set(handles.frame_text, 'String', strcat('Frame',{' '}, int2str(parsednumber), '/',int2str(vid.NumberOfFrames)));
end




function edit_frame_Callback(hObject, eventdata, handles)
% hObject    handle to edit_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_frame as text
%        str2double(get(hObject,'String')) returns contents of edit_frame as a double


% --- Executes during object creation, after setting all properties.
function edit_frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


