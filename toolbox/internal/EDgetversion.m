function [versionnumber,lastchangedate,lastchangetime]= EDgetversion
% This function returns the current version of the EDtoolbox
%
% Output parameters:
%   versionnumber       A number, like 0.101
%   lastchangedate      A string with the date of the last change,
%                       on the form '15Jan2018'
%   lastchangetime      A string with the time of the last change, 
%                       on the form '15h35m11'
%
% Peter Svensson 29 Nov. 2023 (peter.svensson@ntnu.no)
%
% [versionnumber,lastchangedate,lastchangetime]= EDgetversion;

% 15 Jan. 2018 First version
% 16 Jan. 2018 Changed name to EDgetversion to avoid confusion with the
% variable name
% After 16 Jan 2018: Updated date and/or time (and/or version)

versionnumber = 0.402;
lastchangedate = '29Nov2023';
lastchangetime = '11h30';
