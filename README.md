# Closed Loop Sound Stimulation During Sleep In Matlab

## About
This is a Matlab App which streams EEG data in real-time, detects the presence of a slow oscillation, and plays audio-tones after a delay. This is our implementation of an auditory closed loop stimulation platform as first described in https://doi.org/10.1016/j.neuron.2013.03.006. Our implementation in Matlab to allow easy exploration of different settings, stimulation protocols, delays, sounds and similar compared to using a lower level language (if using a higher level language introduces its own challenges).

The App interfaces with a Natus Embla EEG amplifier and RemLogic PSG software, and out of the box will only operate with these. It was designed to run on a background service optimized, non-networked, lab PC running Windows 7. Service optimization included turning off all non-essential background tasks, and running Matlab at a higher priority level. The computer has Matlab 2007b, with a limited set of toolboxes. Thus, some functions which would be 'easy' with newer versions of Matlab or with particular toolboxes are hard coded.

## License information
This code uses the following third party tools:
 - extrema.m: Carlos Adrian Vargas Aguilera (2022). extrema.m, extrema2.m (https://www.mathworks.com/matlabcentral/fileexchange/12275-extrema-m-extrema2-m), MATLAB Central File Exchange. License details are given in LICENSE_extrema.txt
 - nanmean.m: Jan Gläscher (2022). NaN Suite (https://www.mathworks.com/matlabcentral/fileexchange/6837-nan-suite), MATLAB Central File Exchange.
 - generate_sounds.m: The 1/f noise filter in this function uses the algorithm from Kasdin, N.J.. Discrete simulation of colored noise and stochastic processes and
1/f^{\alpha} power law noise generation. Proc IEEE 1995;83(5):802–27. The code was taken from a "Matlab answer" (https://uk.mathworks.com/matlabcentral/answers) to a 2007 post called "How to do I generate pink noise in Matlab or Simulink?". As far as we are aware this post is no longer online, but the code was freely available online for use. 
