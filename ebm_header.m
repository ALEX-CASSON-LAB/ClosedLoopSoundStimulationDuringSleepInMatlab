function Embla = ebm_header(filename)
%% Alex Casson
%
% Versions
% 22.12.14 - v1 - initial script
%
% Aim
% Load header of a .ebm file
%
% Notes
% Based upon sopen.m from Biosig. This is released under a GPL license.
% -------------------------------------------------------------------------


%% Load file and check worked
fid = fopen(filename,'rb');
[ss,c] = fread(fid,[1,48],'uint8=>char');
if (strncmp(ss,'Embla data file',15) && (c==48))
    tag = fread(fid,[1],'uint32');
    
    % Initialise variables
    Embla=[];
    k = 1;
    Embla.NS = 0; 
    Embla.SPR = 1; 
    Embla.NRec = 1; 
else
    error('Error while reading file header. Process aborted.')
    return
end

%% Process the file header
while ~feof(fid)

    siz = fread(fid,[1],'uint32');
    switch tag,
    case 32
        Embla.header_end = ftell(fid);
        Embla.Data = fread(fid,[siz/2,1],'int16');
        Embla.AS.SPR(1,k)=length(Embla.Data);
        Embla.SPR = lcm(Embla.SPR,Embla.AS.SPR(1,k)); 
    case 48 
        Embla.DateGuid = fread(fid,[1,siz],'uint8');
    case 64 
        Embla.DateRecGuid = fread(fid,[1,siz],'uint8');
    case 128
        Embla.Version = fread(fid,[1,siz/2],'uint16');
    case 129
        Embla.Header = fread(fid,[1,siz],'uint8');
    case 132
        t0 = fread(fid,[1,siz],'uint8');
        Embla.Time = t0; 
        T0 = t0(2:7);
        T0(1) = t0(1)+t0(2)*256;	
        T0(6) = t0(7)+t0(8)/100;
        T0 = datenum(T0); 
        Embla.T0 = T0; %datevec(T0); 
        if (k==1)
            Embla.T0 = T0;
        elseif abs(Embla.T0-T0) > 2/(24*3600),
            fprintf(Embla.FILE.stderr,'Warning SOPEN(EMBLA): start time differ between channels\n');
        end; 	 	
    case 133
        Embla.Channel = fread(fid,[1,siz],'uint8');
    case 134
        %Embla.SamplingRate = fread(fid,[1,siz/4],'uint32');
        Embla.AS.SampleRate(1,k) = fread(fid,[1,siz/4],'uint32')/1000;
    case 135
        u = fread(fid,[1,siz/4],'uint32');
        if (u~=1) u=u*1e-9; end;
        Embla.Cal(k) = u; 
    case 136
        Embla.SessionCount = fread(fid,[1,siz],'uint8');
    case 137
        %Embla.DoubleSampleingRate = fread(fid,[1,siz/8],'double');
        Embla.AS.SampleRate(1,k) = fread(fid,[1,siz/8],'double');
    case 138
        Embla.RateCorrection = fread(fid,[1,siz/8],'double');
    case 139
        Embla.RawRange = fread(fid,[1,siz/2],'int16');
    case 140
        Embla.TransformRange = fread(fid,[1,siz/2],'int16');
    case 141
        Embla.Channel32 = fread(fid,[1,siz],'uint8');
    case 144
        %Embla.ChannelName = fread(fid,[1,siz],'uint8=>char');
        Embla.Label{k} = deblank(fread(fid,[1,siz],'uint8=>char'));
    case 149
        Embla.DataMask16bit = fread(fid,[1,siz/2],'int16');
    case 150
        Embla.SignedData = fread(fid,[1,siz],'uint8');
    case 152
        Embla.CalibrationFunction = fread(fid,[1,siz],'uint8=>char');
    case 153
        %Embla.CalibrationUnit = fread(fid,[1,siz],'uint8=>char');
        Embla.PhysDim{k} = deblank(fread(fid,[1,siz],'uint8=>char'));		
        %HDR.PhysDimCode(k) = physicalunits(fread(fid,[1,siz],'uint8=>char'));		
    case 154
        Embla.CalibrationPoint = fread(fid,[1,siz],'uint8');
    case 160
        Embla.CalibrationEvent = fread(fid,[1,siz],'uint8');
    case 192
        Embla.DeviceSerialNumber = fread(fid,[1,siz],'uint8=>char');
    case 193
        Embla.DeviceType = fread(fid,[1,siz],'uint8=>char');
    case 208
        Embla.SubjectName = fread(fid,[1,siz],'uint8=>char');
    case 209
        Embla.SubjectID = fread(fid,[1,siz],'uint8=>char');
    case 210
        Embla.SubjectGroup = fread(fid,[1,siz],'uint8=>char');
    case 211
        Embla.SubjectAttendant = fread(fid,[1,siz],'uint8=>char');
    case 224
        Embla.FilterSettings = fread(fid,[1,siz],'uint8');
    case hex2dec('020000A0')
        Embla.SensorSignalType = fread(fid,[1,siz],'uint8=>char');
    case hex2dec('03000070')
        Embla.InputReference = fread(fid,[1,siz],'uint8=>char');
    case hex2dec('03000072')
        Embla.InputMainType = fread(fid,[1,siz],'uint8=>char');
    case hex2dec('03000074')
        Embla.InputSubType = fread(fid,[1,siz],'uint8=>char');
    case hex2dec('03000080')
        Embla.InputComment = fread(fid,[1,siz],'uint8=>char');
    case hex2dec('04000020')
        Embla.WhatComment = fread(fid,[1,siz],'uint8=>char');
    otherwise 
        fread(fid,[1,siz],'uint8=>char');
    end;
    tag = fread(fid,[1],'uint32');

end;
Embla.NS=k;
Embla.Calib = sparse(2:Embla.NS+1,1:Embla.NS,Embla.Cal,Embla.NS+1,Embla.NS); 
Embla.DigMax = repmat(2^15-1,1,Embla.NS);
Embla.DigMin = repmat(-2^15,1,Embla.NS);
Embla.PhysMax = Embla.DigMax.*Embla.Cal(:)';
Embla.PhysMin = Embla.DigMin.*Embla.Cal(:)';
Duration = mean(Embla.AS.SPR./Embla.AS.SampleRate);
Embla.SampleRate = Embla.SPR/Duration;
fclose(fid);