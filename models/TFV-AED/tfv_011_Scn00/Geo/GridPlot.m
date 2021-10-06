clear all
load GridErie.mat
%%scatter(xx,y,'.','k');
hold on


for i=2601:2800;
    c=cell(i,:);
    if isnan(c(6))==1;
      
        h=plot([xx(c(2)) xx(c(3)) xx(c(4)) xx(c(2))], [y(c(2)) y(c(3)) y(c(4)) y(c(2))],'k'); label(h,num2str(i),'middle');
        hold on
    end
    if isnan(c(6))==0;
        
        h=plot([xx(c(2)) xx(c(3)) xx(c(4)) xx(c(5)) xx(c(2))], [y(c(2)) y(c(3)) y(c(4)) y(c(5)) y(c(2))],'k'); label(h,num2str(i),'middle');
        hold on
    end
end
    



clear all
load GridErie.mat
%%scatter(xx,y,'.','k');

%hold on


for i=1:21884;
c=cell(i,:);
if isnan(c(6))==1;
      
   h=plot([xx(c(2)) xx(c(3)) xx(c(4)) xx(c(2))], [y(c(2)) y(c(3)) y(c(4)) y(c(2))],'k');
     hold on
 end
 if isnan(c(6))==0;
     
     h=plot([xx(c(2)) xx(c(3)) xx(c(4)) xx(c(5)) xx(c(2))], [y(c(2)) y(c(3)) y(c(4)) y(c(5)) y(c(2))],'k');
    hold on
 end
end
    