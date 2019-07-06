function frames = readVideo(videoname,K,show_video)

% videoname : string of path + name of video file 
% K         : number of frames to retrieve
% show_video: play video 

mov=VideoReader(videoname);
vidFrames=read(mov);
nFrames = mov.NumberOfFrames;
K = min(nFrames,K);
frames = squeeze(vidFrames(:,:,1,1:K));


if show_video == 1

figure(1);
for i=1:nFrames
   imshow(vidFrames(:,:,i),[]);  %frames are grayscale
   pause(1/mov.FrameRate);
end

end