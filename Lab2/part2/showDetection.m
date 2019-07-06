function showDetection(vid,points,frames)

% vid    : 3d frames sequence
% points : Nx4 detected points (x,y,scale,t)
% frames : frames to visualize, if no input visualize all frames


if ~exist('frames','var');
    frames = 1:size(vid,3);
end

for i = 1:numel(frames)
    
    ii = frames(i);
    imshow(vid(:,:,ii)); hold on;

    ind = find(points(:,4) == ii);
    viscircles(points(ind,1:2),3*points(ind,3),'EdgeColor','g'); hold on;
    pause(1/25);
    %pause;
end