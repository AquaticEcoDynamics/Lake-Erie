# fig2frame

Convert a figure into a high-resolution video frame, trying to preserve figure appearance as much as possible.

Why is this better than GETFRAME? GETFRAME performs a screen grab of the region of your screen where the figure is. This is problematic because:
 1. You must actually draw and display the figure on-screen. This is slow.
 2. GETFRAME does not check that the figure is the front-most object on your screen.
 3. The frame cannot be larger than your screen.

fig2frame avoids these problems by generating a new, invisible figure and converting the figure data directly to an image instead of performing a screen grab.
