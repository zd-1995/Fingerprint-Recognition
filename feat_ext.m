d_max=[];
for i=1:m
    for j=1:n
        if end_points(i,j)==1
            d=[];
            for ii=1:m
                for jj=1:n
                    if ii~=i || jj~=j
                        if start_points(ii,jj)==1
                            d=[d,sqrt((i-ii)^2+(j-jj)^2)];
                        end
                    end
                end
            end
            d_max=[d_max,max(d)];
        end
    end
end
d_max=unique(d_max);
minu=sort(d_max);
minu=minu(1:10);
