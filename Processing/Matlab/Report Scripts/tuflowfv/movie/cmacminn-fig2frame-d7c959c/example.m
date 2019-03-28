% Example illustrating usage of fig2frame
%
% HISTORY
% 2013-10-24 Created by CWM
% 2015-03-11 Modified by CWM
%   - General tidying
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The MIT License (MIT)
% 
% Copyright (c) 2013 Christopher W. MacMinn
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all;

% Create a new VideoWriter object (an empty video file). Use whatever format you want,
% but in my experience MP4 (with H.264 codec) is by far the best. Please stop using AVI.
hvid = VideoWriter('./movie.mp4','MPEG-4');

% Full quality, because why not?
set(hvid,'Quality',100);

% Set the frame rate
set(hvid,'FrameRate',30);

% Open the object for writing
open(hvid);

% Desired frame resolution (see fig2frame). The video will automatically adopt the resolution of the first frame (see HELP VIDEOWRITER).
% You could instead set the Width property of the video object, but I prefer this.
framepar.resolution = [1024,768];

% Create a new figure
hfig = figure();

for i=1:1:20
    
    disp(['Processing frame ' num2str(i) '...'])
    
    % Plot something function
    figure(hfig)
    x = linspace(0,8*pi,1000);
    plot(x,sin(10*x+i/40),'b-','LineWidth',1.5)
    axis([0,1,-2,2])
    
    % Convert the figure to a video frame.
    % The built-in function for this is GETFRAME, which has a variety of annoying features.
    % fig2frame is a drop-in replacement for getframe that avoids most (all?) the annoyance.
    
    F = fig2frame(hfig,framepar); % <-- Use this
    % F = getframe(hfig); % <-- Not this.
    
    % Add the frame to the video object
    writeVideo(hvid,F);
    
end

% Close the figure
close(hfig);

% Close the video object. This is important! The file may not play properly if you don't close it.
close(hvid);
