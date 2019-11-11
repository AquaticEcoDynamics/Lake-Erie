function [VideoFrame] = fig2frame(hfig,framepar)
    % Convert a figure into a high-resolution video frame, trying to preserve figure appearance as much as possible.
    % 
    % INPUTS
    %   hfig: handle to the figure
    %   framepar: Optional structure with additional parameters.
    %     *.resolution: Vector of length 2 containing the target resolution in pixels,
    %       such that frame width = resolution(1) and frame height = resolution(2).
    %       Set width or height to -1 to preserve the original aspect ratio.
    %
    % OUTPUTS
    %   VideoFrame: a frame object suitable for use with writeVideo()
    %
    % HISTORY
    % 2013-10-23 Created by CWM
    % 2015-03-11 Modified by CWM
    %   - Switched from the undocumented HARDCOPY (deprecated as of R2014b) 
    %     to PRINT with the output option -RGBImage (new as of R2014b).
    %   - Various minor improvements
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
    
    % Create an empty structure framepar if one was not passed in.
    if nargin<2
        framepar = struct([]);
    end
    
    % Get axis and line handles from original figure
    hax = findall(hfig,'type','axes');
    hlines = findobj(hfig,'type','line');
    
    % Get the background color of the original figure
    orig_fig_Color = get(hfig,'Color');
    
    % Get the sizes of things in the original figure
    orig_fig_Position = get(hfig,'Position');
    orig_ax_LineWidth = get(hax,'LineWidth');
    orig_lines_LineWidth = get(hlines,'LineWidth');
    orig_lines_MarkerSize = get(hlines,'MarkerSize');
    orig_ax_FontSize = get(hax,'FontSize');
    
    % Original aspect ratio (width/height)
    ar = orig_fig_Position(3)/orig_fig_Position(4);
    
    % Get target resolution
    if isfield(framepar,'resolution')
        w = framepar.resolution(1); % Target frame width [px]
        h = framepar.resolution(2); % Target frame height [px]
        if w==-1
            h = round(h);
            w = round(h*ar);
        elseif h==-1
            h = round(w/ar);
            w = round(w);
        end
    else
        w = 1600; % Default width [px]
        h = round(1600/ar); % Preserve original aspect ratio
    end
    
    % Set new figure size
    new_fig_Position = [0 0 w h];
    
    % Scale factor (new width / old width)
    s = round(w/orig_fig_Position(3)); 
    
    % Scale up other properties
    new_ax_LineWidth = s*orig_ax_LineWidth;
    if iscell(orig_lines_LineWidth)
        new_lines_LineWidth = cellfun(@(x) s*x, orig_lines_LineWidth);
        new_lines_MarkerSize = cellfun(@(x) s*x, orig_lines_MarkerSize);
    else
        new_lines_LineWidth = s*orig_lines_LineWidth;
        new_lines_MarkerSize = s*orig_lines_MarkerSize;
    end
    new_ax_FontSize = s*orig_ax_FontSize;
    
    % Create a new figure
    hfig2 = figure('Visible','Off', ... % New figure is invisible
                   'PaperPositionMode','auto', ... % Does not work without this
                   'Position',new_fig_Position, ... % Target image resolution
                   'Color',orig_fig_Color); % Retain original background color
    
    % Copy all objects from fig to the new figure
    objects = allchild(hfig);
    copyobj(get(hfig,'children'),hfig2);
    
    % Get handles for various objects in fig2
    hax = findall(hfig2,'type','axes');
    hlines = findobj(hfig2,'type','line');
    
    % Scale up the lines and symbols
    set(hax,'LineWidth',new_ax_LineWidth);
    for i=1:length(hlines)
        set(hlines(i),'LineWidth',new_lines_LineWidth(i), ...
                      'MarkerSize',new_lines_MarkerSize(i));
    end
    
    % Scale up the fonts
    set(hax,'FontSize',new_ax_FontSize,'fontname','Times New Roman')
    set(get(hax,'XLabel'),'FontSize',new_ax_FontSize)
    set(get(hax,'YLabel'),'FontSize',new_ax_FontSize)
    
    % Convert the figure to an image at the target resolution
    im = print(hfig2,'-RGBImage','-r0');
    
    % Close the invisible figure
    close(hfig2);
    
    % Convert the image to a video frame
    VideoFrame = im2frame(im);
    
end
