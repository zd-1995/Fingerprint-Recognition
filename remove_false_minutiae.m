for i=1:m
    for j=1:n
        if start_points(i,j)==1
            if sum(sum(start_points(i-1:i+1,j-1:j+1)))>1
                start_points(i-1:i+1,j-1:j+1)=[0,0,0;0,1,0;0,0,0];
            end
        end
    end
end

Img_labeld=bwlabel(Img_thins);
avg_D=10;

%M1
for i=1:m
    for j=1:n
        if start_points(i,j)==1
            for ii=1:m
                for jj=1:n
                    if end_points(ii,jj)==1
                        d=sqrt((i-ii)^2+(j-jj)^2);
                        if d<avg_D
                            start_points(i,j)=0;
                            end_points(ii,jj)=0;
                        end
                    end
                end
            end
        end
    end
end

%M2,3
for i=1:m
    for j=1:n
        if start_points(i,j)==1
            for ii=1:m
                for jj=1:n
                    if ii~=i || jj~=j
                        if start_points(ii,jj)==1
                            d=sqrt((i-ii)^2+(j-jj)^2);
                            if d<avg_D
                                start_points(i,j)=0;
                                start_points(ii,jj)=0;
                            end
                        end
                    end
                end
            end
        end
    end
end

for i=1:m
    for j=1:n
        if end_points(i,j)==1
            for ii=1:m
                for jj=1:n
                    if ii~=i || jj~=j
                        if end_points(ii,jj)==1
                            d=sqrt((i-ii)^2+(j-jj)^2);
                            if d<avg_D
                                end_points(i,j)=0;
                                end_points(ii,jj)=0;
                            end
                        end
                    end
                end
            end
        end
    end
end



