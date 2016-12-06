%values from each 3X3 transform matrix into 9 row column for trendline
%analysis

for i=1:3
    for j=1:11
        trend(:,j,i)=reshape(changes{i}(:,:,j)',9,[]);
    end
end

%plotting visualizations of transform matrix values 
xAxis1=0:10;
xAxis=0:.1:10;

for i=1:3
    figure
    for j=1:9
        subplot(3,3,j)
        plot(xAxis1,trend(j,:,i),'b')
        hold on
        %obtaining values of & from 5th degree polynomial fit
        fitPolyVals(j,:,i)=polyfit(xAxis1,trend(j,:,i),5);
        fitLine(j,:,i)=polyval(fitPolyVals(j,:,i),0:.1:10);
    end
    
    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');

    if i==1
        text(0.5, 1,'\bf Tracking Protanomalous Value Changes','HorizontalAlignment','center','VerticalAlignment', 'top')
        hold off
    elseif i==2
        text(0.5, 1,'\bf Tracking Deuteranomalous Value Changes','HorizontalAlignment','center','VerticalAlignment', 'top')
        hold off
    elseif i==3
        text(0.5, 1,'\bf Tracking Tritanomalous Value Changes','HorizontalAlignment','center','VerticalAlignment', 'top')
        hold off
    end
end

%reconstructing colorblindness representation for any value between 0 and 100
%note that we are only considering singular deficiencies whereas mixtures
%of red/green for instance would be of interest
%example of how to use:
%changes{2}(:,:,4); this command refers to all rows and columns (3x3) of
%the third degree deuteranomalous colorvision transform matrix as given in
%http://www.inf.ufrgs.br/~oliveira/pubs_files/CVD_Simulation/CVD_Simulation.html
%
%reshape(fitLine(:,41,2),3,3)'; this command retrieves the identical matrix
%
%if value 41 is changed in the reshape command to 36 we would have the
%equivalent of a 3.5 degree colorvision transform matrix
%