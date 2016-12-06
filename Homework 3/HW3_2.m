stim = double(stim);
counts = double(counts);
t_max = d(3);
d = size(stim);
%Grab 12 before
spike_avg = zeros(16,16,12);
for i = 13:t_max
    if (counts(i) > 0) %there exists a spike
        % adds the frame to a bin, weighted
        for t = 1:12
            weight = stim(:,:,i-t)*counts(i);
            spikes = counts(i-t);
            spike_avg(:,:,13-t) = spike_avg(:,:,13-t) + weight; %add on the weight per frame
            
        end     
    end
end
% average by number of spikes
spike_avg = spike_avg/sum(counts);
for i = 1:12
    figure;
    imagesc(spike_avg(:,:,i)); %display using imagesc
    
end

%Sum up all figures in spatial dimension to produce figure 2.25C
figure225C = zeros(12,16);
for i = 1:12
    for j = 1:16
        figure225C(i,:)=figure225C(i,:)+spike_avg(j,:,i); %the summing
        
    end
end

figure;
imagesc(figure225C)
